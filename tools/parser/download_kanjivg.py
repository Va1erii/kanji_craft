#!/usr/bin/env python3
"""Download the latest KanjiVG release from GitHub.

Archives are kept with their version names (tracked in git).
Extracted files go to data/.unpacked/ (gitignored) with stable names
so parser code doesn't change between versions.

Usage:
    python tools/parser/download_kanjivg.py              # download latest
    python tools/parser/download_kanjivg.py --force      # re-download
    python tools/parser/download_kanjivg.py --version    # print installed version
"""

from __future__ import annotations

import argparse
import glob
import gzip
import json
import os
import shutil
import sys
import urllib.request
import zipfile

GITHUB_API_URL = (
    "https://api.github.com/repos/KanjiVG/kanjivg/releases/latest"
)

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SOURCE_DIR = os.path.join(SCRIPT_DIR, "data", "kanjivg")
UNPACKED_DIR = os.path.join(SOURCE_DIR, ".unpacked")
VERSION_FILE = os.path.join(SOURCE_DIR, ".version")
XML_PATH = os.path.join(UNPACKED_DIR, "kanjivg.xml")
SVG_DIR = os.path.join(UNPACKED_DIR, "kanjivg")


def get_installed_version() -> str | None:
    """Return the currently installed release tag, or None."""
    if os.path.isfile(VERSION_FILE):
        with open(VERSION_FILE, "r") as f:
            return f.read().strip()
    return None


def fetch_latest_release() -> dict:
    """Query the GitHub API for the latest KanjiVG release."""
    req = urllib.request.Request(
        GITHUB_API_URL,
        headers={
            "Accept": "application/vnd.github+json",
            "User-Agent": "kanji-craft-downloader",
        },
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())


def find_asset(assets: list[dict], suffix: str) -> dict | None:
    """Find a release asset whose name ends with *suffix*."""
    for asset in assets:
        if asset["name"].endswith(suffix):
            return asset
    return None


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


def extract_svgs(zip_path: str) -> int:
    """Unzip SVGs from *zip_path* into SVG_DIR.  Returns the count."""
    if os.path.isdir(SVG_DIR):
        shutil.rmtree(SVG_DIR)
    os.makedirs(SVG_DIR, exist_ok=True)

    count = 0
    with zipfile.ZipFile(zip_path) as zf:
        for info in zf.infolist():
            if info.is_dir():
                continue
            name = os.path.basename(info.filename)
            if not name.endswith(".svg"):
                continue
            dest = os.path.join(SVG_DIR, name)
            with zf.open(info) as src, open(dest, "wb") as dst:
                dst.write(src.read())
            count += 1
    return count


def remove_old_archives(keep_xml_gz: str, keep_zip: str) -> None:
    """Remove old KanjiVG archives from SOURCE_DIR, keeping only the current ones."""
    for path in glob.glob(os.path.join(SOURCE_DIR, "kanjivg-*.xml.gz")):
        if path != keep_xml_gz:
            os.remove(path)
    for path in glob.glob(os.path.join(SOURCE_DIR, "kanjivg-*-main.zip")):
        if path != keep_zip:
            os.remove(path)


def dir_size_mb(path: str) -> float:
    """Return the total size of all files under *path* in megabytes."""
    total = 0
    for dirpath, _, filenames in os.walk(path):
        for name in filenames:
            total += os.path.getsize(os.path.join(dirpath, name))
    return total / (1024 * 1024)


def main() -> None:
    parser = argparse.ArgumentParser(description="Download KanjiVG data.")
    parser.add_argument(
        "--force",
        action="store_true",
        help="Re-download even if archives already exist.",
    )
    parser.add_argument(
        "--version",
        action="store_true",
        help="Print the installed KanjiVG version and exit.",
    )
    args = parser.parse_args()

    if args.version:
        ver = get_installed_version()
        if ver:
            print(ver)
        else:
            print("No KanjiVG version installed.")
        sys.exit(0)

    print("Fetching latest release info from GitHub...")
    release = fetch_latest_release()
    tag = release["tag_name"]
    print(f"Latest release: {tag}")

    assets = release.get("assets", [])

    xml_asset = find_asset(assets, ".xml.gz")
    if xml_asset is None:
        print("ERROR: No .xml.gz asset found in the release.", file=sys.stderr)
        sys.exit(1)

    zip_asset = find_asset(assets, "-main.zip")
    if zip_asset is None:
        print(
            "ERROR: No -main.zip asset found in the release.", file=sys.stderr
        )
        sys.exit(1)

    os.makedirs(SOURCE_DIR, exist_ok=True)
    os.makedirs(UNPACKED_DIR, exist_ok=True)

    xml_gz_path = os.path.join(SOURCE_DIR, xml_asset["name"])
    zip_path = os.path.join(SOURCE_DIR, zip_asset["name"])

    # Download archives if missing (or --force)
    downloaded = False

    if args.force or not os.path.isfile(xml_gz_path):
        print(f"Downloading {xml_asset['name']} ({xml_asset['size'] / 1024:.0f} KB)...")
        download_to_file(xml_asset["browser_download_url"], xml_gz_path)
        downloaded = True
    else:
        print(f"Archive exists: {xml_asset['name']}")

    if args.force or not os.path.isfile(zip_path):
        print(f"Downloading {zip_asset['name']} ({zip_asset['size'] / 1024:.0f} KB)...")
        download_to_file(zip_asset["browser_download_url"], zip_path)
        downloaded = True
    else:
        print(f"Archive exists: {zip_asset['name']}")

    # Extract if downloaded new archives or unpacked dir is missing
    needs_extract = downloaded or not os.path.isfile(XML_PATH) or not os.path.isdir(SVG_DIR)

    if needs_extract:
        print("Extracting XML...")
        extract_xml_gz(xml_gz_path)

        print("Extracting SVGs...")
        svg_count = extract_svgs(zip_path)
    else:
        svg_count = len(glob.glob(os.path.join(SVG_DIR, "*.svg")))
        print("Already up to date.")

    # Clean up old version archives
    remove_old_archives(xml_gz_path, zip_path)

    # Write version file
    with open(VERSION_FILE, "w") as f:
        f.write(tag + "\n")

    if needs_extract:
        xml_size = os.path.getsize(XML_PATH) / (1024 * 1024)
        svg_size = dir_size_mb(SVG_DIR)

        print()
        print(f"Version:    {tag}")
        print(f"XML:        {XML_PATH} ({xml_size:.1f} MB)")
        print(f"SVGs:       {svg_count} files in {SVG_DIR} ({svg_size:.1f} MB)")
        print(f"Total size: {xml_size + svg_size:.1f} MB")


if __name__ == "__main__":
    main()
