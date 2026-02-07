#!/usr/bin/env python3
"""Download the latest KANJIDIC2 data from EDRDG.

Unlike KanjiVG (GitHub releases), KANJIDIC2 is a single gzipped XML file
updated in-place at a fixed URL.  New-version detection uses the HTTP
Last-Modified header compared against a locally stored value.

Archives are kept with date-stamped names (tracked in git).
Extracted files go to data/.unpacked/ (gitignored) with stable names
so parser code doesn't change between versions.

Usage:
    python tools/parser/download_kanjidic2.py              # download if newer
    python tools/parser/download_kanjidic2.py --force      # re-download
    python tools/parser/download_kanjidic2.py --version    # print installed version
"""

from __future__ import annotations

import argparse
import glob
import gzip
import os
import re
import shutil
import sys
import urllib.request
import xml.etree.ElementTree as ET

DOWNLOAD_URL = "http://www.edrdg.org/kanjidic/kanjidic2.xml.gz"

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SOURCE_DIR = os.path.join(SCRIPT_DIR, "data", "kanjidic2")
UNPACKED_DIR = os.path.join(SOURCE_DIR, ".unpacked")
VERSION_FILE = os.path.join(SOURCE_DIR, ".version")
LAST_MODIFIED_FILE = os.path.join(SOURCE_DIR, ".last-modified")
XML_PATH = os.path.join(UNPACKED_DIR, "kanjidic2.xml")


def get_installed_version() -> str | None:
    """Return the currently installed database_version, or None."""
    if os.path.isfile(VERSION_FILE):
        with open(VERSION_FILE, "r") as f:
            return f.read().strip()
    return None


def get_stored_last_modified() -> str | None:
    """Return the stored Last-Modified header value, or None."""
    if os.path.isfile(LAST_MODIFIED_FILE):
        with open(LAST_MODIFIED_FILE, "r") as f:
            return f.read().strip()
    return None


def fetch_last_modified() -> str | None:
    """Send a HEAD request and return the Last-Modified header."""
    req = urllib.request.Request(
        DOWNLOAD_URL,
        method="HEAD",
        headers={"User-Agent": "kanji-craft-downloader"},
    )
    with urllib.request.urlopen(req) as resp:
        return resp.headers.get("Last-Modified")


def download_to_file(url: str, dest: str) -> None:
    """Download a URL and write it to *dest*."""
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "kanji-craft-downloader"},
    )
    with urllib.request.urlopen(req) as resp, open(dest, "wb") as f:
        shutil.copyfileobj(resp, f)


def extract_xml_gz(gz_path: str) -> None:
    """Gunzip *gz_path* and write the result to XML_PATH."""
    with gzip.open(gz_path, "rb") as src, open(XML_PATH, "wb") as dst:
        shutil.copyfileobj(src, dst)


def parse_xml_header(xml_path: str) -> dict:
    """Parse database_version, date_of_creation, and kanji count from the XML.

    Uses iterparse to avoid loading the full tree into memory.
    """
    info: dict = {}
    kanji_count = 0
    for event, elem in ET.iterparse(xml_path, events=("end",)):
        if elem.tag == "database_version":
            info["database_version"] = elem.text.strip() if elem.text else ""
        elif elem.tag == "date_of_creation":
            info["date_of_creation"] = elem.text.strip() if elem.text else ""
        elif elem.tag == "character":
            kanji_count += 1
            elem.clear()
        elif elem.tag == "header":
            # Done with header; keep counting characters
            pass
    info["kanji_count"] = kanji_count
    return info


def remove_old_archives(keep_gz: str) -> None:
    """Remove old date-stamped archives from SOURCE_DIR, keeping only *keep_gz*."""
    for path in glob.glob(os.path.join(SOURCE_DIR, "kanjidic2-*.xml.gz")):
        if path != keep_gz:
            os.remove(path)


def main() -> None:
    parser = argparse.ArgumentParser(description="Download KANJIDIC2 data.")
    parser.add_argument(
        "--force",
        action="store_true",
        help="Re-download even if data is already up to date.",
    )
    parser.add_argument(
        "--version",
        action="store_true",
        help="Print the installed KANJIDIC2 version and exit.",
    )
    args = parser.parse_args()

    if args.version:
        ver = get_installed_version()
        if ver:
            print(ver)
        else:
            print("No KANJIDIC2 version installed.")
        sys.exit(0)

    os.makedirs(SOURCE_DIR, exist_ok=True)
    os.makedirs(UNPACKED_DIR, exist_ok=True)

    # Check if remote file has changed via Last-Modified header
    print("Checking for updates...")
    remote_last_modified = fetch_last_modified()
    stored_last_modified = get_stored_last_modified()

    if (
        not args.force
        and remote_last_modified
        and remote_last_modified == stored_last_modified
        and os.path.isfile(XML_PATH)
    ):
        ver = get_installed_version() or "unknown"
        print(f"Already up to date (version {ver}).")
        sys.exit(0)

    # Download to a temporary name, then rename after parsing
    tmp_gz = os.path.join(SOURCE_DIR, "kanjidic2-tmp.xml.gz")
    print(f"Downloading {DOWNLOAD_URL}...")
    download_to_file(DOWNLOAD_URL, tmp_gz)

    gz_size = os.path.getsize(tmp_gz)
    print(f"Downloaded ({gz_size / 1024:.0f} KB compressed)")

    # Extract
    print("Extracting XML...")
    extract_xml_gz(tmp_gz)

    # Parse header to get version info
    info = parse_xml_header(XML_PATH)
    db_version = info.get("database_version", "unknown")
    date_of_creation = info.get("date_of_creation", "")
    kanji_count = info.get("kanji_count", 0)

    # Build date-stamped archive name from date_of_creation (e.g. "2026-02-07" → "20260207")
    date_stamp = re.sub(r"[^0-9]", "", date_of_creation)
    if not date_stamp:
        date_stamp = "unknown"
    archive_name = f"kanjidic2-{date_stamp}.xml.gz"
    archive_path = os.path.join(SOURCE_DIR, archive_name)

    # Rename temp file to date-stamped name
    if os.path.exists(archive_path) and archive_path != tmp_gz:
        os.remove(archive_path)
    os.rename(tmp_gz, archive_path)

    # Clean up old archives
    remove_old_archives(archive_path)

    # Write version file
    with open(VERSION_FILE, "w") as f:
        f.write(db_version + "\n")

    # Store Last-Modified for future comparisons
    if remote_last_modified:
        with open(LAST_MODIFIED_FILE, "w") as f:
            f.write(remote_last_modified + "\n")

    xml_size = os.path.getsize(XML_PATH) / (1024 * 1024)

    print()
    print(f"Version:      {db_version}")
    print(f"Created:      {date_of_creation}")
    print(f"Kanji count:  {kanji_count}")
    print(f"Archive:      {archive_name} ({gz_size / 1024:.0f} KB)")
    print(f"XML:          {XML_PATH} ({xml_size:.1f} MB)")


if __name__ == "__main__":
    main()
