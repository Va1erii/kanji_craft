"""Tests for JmdictFurigana parser."""

import json
import tarfile
import tempfile
from pathlib import Path

from src.parsers.jmdict_furigana import parse_jmdict_furigana

FIXTURES = Path(__file__).parent / "fixtures"


def _make_tar_gz(json_path: Path, bom: bool = False) -> Path:
    """Create a .tar.gz from a JSON file, optionally with BOM prefix."""
    tmp = Path(tempfile.mkdtemp())
    tar_path = tmp / "JmdictFurigana.json.tar.gz"
    data = json_path.read_bytes()
    if bom:
        data = b"\xef\xbb\xbf" + data

    with tarfile.open(tar_path, "w:gz") as tar:
        import io

        info = tarfile.TarInfo(name="JmdictFurigana.json")
        info.size = len(data)
        tar.addfile(info, io.BytesIO(data))

    return tar_path


def test_row_count():
    tar_path = _make_tar_gz(FIXTURES / "jmdict_furigana.json")
    df = parse_jmdict_furigana(tar_path)
    assert len(df) == 3


def test_columns():
    tar_path = _make_tar_gz(FIXTURES / "jmdict_furigana.json")
    df = parse_jmdict_furigana(tar_path)
    assert list(df.columns) == ["text", "reading", "furigana"]


def test_values():
    tar_path = _make_tar_gz(FIXTURES / "jmdict_furigana.json")
    df = parse_jmdict_furigana(tar_path)
    row0 = df.iloc[0]
    assert row0["text"] == "食べる"
    assert row0["reading"] == "たべる"
    furigana = json.loads(row0["furigana"])
    assert len(furigana) == 2
    assert furigana[0] == {"ruby": "食", "rt": "た"}
    assert furigana[1] == {"ruby": "べる"}


def test_jukujikun_entry():
    tar_path = _make_tar_gz(FIXTURES / "jmdict_furigana.json")
    df = parse_jmdict_furigana(tar_path)
    row1 = df.iloc[1]
    assert row1["text"] == "大人"
    furigana = json.loads(row1["furigana"])
    assert len(furigana) == 1
    assert furigana[0] == {"ruby": "大人", "rt": "おとな"}


def test_kana_only_entry():
    tar_path = _make_tar_gz(FIXTURES / "jmdict_furigana.json")
    df = parse_jmdict_furigana(tar_path)
    row2 = df.iloc[2]
    assert row2["text"] == "する"
    furigana = json.loads(row2["furigana"])
    assert len(furigana) == 1
    assert "rt" not in furigana[0]


def test_bom_handling():
    """Verify BOM prefix is properly stripped."""
    tar_path = _make_tar_gz(FIXTURES / "jmdict_furigana.json", bom=True)
    df = parse_jmdict_furigana(tar_path)
    assert len(df) == 3
    assert df.iloc[0]["text"] == "食べる"
