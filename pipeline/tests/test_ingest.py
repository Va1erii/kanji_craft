"""Integration test for the full ingestion pipeline."""

import gzip
import io
import shutil
import tarfile
from pathlib import Path

import pytest

from src.ingest import discover_sources, main, write_parquet_atomic

FIXTURES = Path(__file__).parent / "fixtures"


def _gzip_file(src: Path, dst: Path) -> None:
    """Gzip a file."""
    with open(src, "rb") as f_in, gzip.open(dst, "wb") as f_out:
        f_out.write(f_in.read())


def _make_tar_gz(json_path: Path, dst: Path) -> None:
    """Create a .tar.gz from a JSON file with BOM prefix."""
    data = b"\xef\xbb\xbf" + json_path.read_bytes()
    with tarfile.open(dst, "w:gz") as tar:
        info = tarfile.TarInfo(name="JmdictFurigana.json")
        info.size = len(data)
        tar.addfile(info, io.BytesIO(data))


@pytest.fixture
def integration_sources(tmp_path: Path) -> Path:
    """Create a temp sources directory with all fixture files."""
    sources = tmp_path / "sources"

    # KANJIDIC
    kd_dir = sources / "kanjidic2-20240101"
    kd_dir.mkdir(parents=True)
    _gzip_file(FIXTURES / "kanjidic_sample.xml", kd_dir / "kanjidic2.xml.gz")

    # KanjiVG
    kvg_dir = sources / "kanjivg-20240101"
    kvg_dir.mkdir(parents=True)
    _gzip_file(FIXTURES / "kanjivg_sample.xml", kvg_dir / "kanjivg-20240101.xml.gz")

    # JMdict
    jm_dir = sources / "jmdict-20240101"
    jm_dir.mkdir(parents=True)
    _gzip_file(FIXTURES / "jmdict_sample.xml", jm_dir / "JMdict.gz")
    _gzip_file(FIXTURES / "jmdict_examp_sample.xml", jm_dir / "JMdict_e_examp.gz")

    # JLPT kanji
    jlpt_dir = sources / "jlpt_mapping"
    jlpt_dir.mkdir(parents=True)
    shutil.copy(FIXTURES / "jlpt_mapping.csv", jlpt_dir / "jlpt_mapping.csv")

    # JLPT vocab
    jlpt_vocab_dir = sources / "jlpt_vocab_mapping"
    jlpt_vocab_dir.mkdir(parents=True)
    for level in (1, 2, 3):
        (jlpt_vocab_dir / f"n{level}.csv").write_text("expression,reading,meaning,tags,guid\n")
    shutil.copy(FIXTURES / "jlpt_vocab_n4.csv", jlpt_vocab_dir / "n4.csv")
    shutil.copy(FIXTURES / "jlpt_vocab_n5.csv", jlpt_vocab_dir / "n5.csv")

    # JmdictFurigana
    jf_dir = sources / "jmdictfurigana-1.0+20240101"
    jf_dir.mkdir(parents=True)
    _make_tar_gz(FIXTURES / "jmdict_furigana.json", jf_dir / "JmdictFurigana.json.tar.gz")

    return sources


def test_discover_sources(integration_sources: Path):
    sources = discover_sources(integration_sources)
    assert "kanjidic" in sources
    assert "kanjivg" in sources
    assert "jmdict" in sources
    assert "jmdict_examples" in sources
    assert "jlpt_kanji" in sources
    assert "jlpt_vocab" in sources
    assert "jmdict_furigana" in sources


def test_discover_sources_missing(tmp_path: Path):
    with pytest.raises(FileNotFoundError, match="Missing required sources"):
        discover_sources(tmp_path)


def test_write_parquet_atomic(tmp_path: Path):
    import pandas as pd

    df = pd.DataFrame({"a": [1, 2], "b": ["x", "y"]})
    path = tmp_path / "test.parquet"
    write_parquet_atomic(df, path)
    assert path.exists()
    # Temp file should be gone
    assert not path.with_suffix(".parquet.tmp").exists()
    # Read back
    result = pd.read_parquet(path)
    assert len(result) == 2


def test_full_integration(integration_sources: Path, tmp_path: Path, monkeypatch):
    """Run the full pipeline against fixtures."""
    output_dir = tmp_path / "parquet"

    monkeypatch.setattr("src.ingest.SOURCES_DIR", integration_sources)
    monkeypatch.setattr("src.ingest.OUTPUT_DIR", output_dir)

    main()

    expected_files = [
        "kanjidic.parquet",
        "kanjivg.parquet",
        "jmdict.parquet",
        "jmdict_examples.parquet",
        "jlpt_kanji.parquet",
        "jlpt_vocab.parquet",
        "jmdict_furigana.parquet",
    ]

    for fname in expected_files:
        f = output_dir / fname
        assert f.exists(), f"Missing {fname}"

    # Basic row count checks
    import pandas as pd

    assert len(pd.read_parquet(output_dir / "kanjidic.parquet")) == 3
    assert len(pd.read_parquet(output_dir / "kanjivg.parquet")) == 3
    assert len(pd.read_parquet(output_dir / "jmdict.parquet")) == 3
    assert len(pd.read_parquet(output_dir / "jmdict_examples.parquet")) == 2
    assert len(pd.read_parquet(output_dir / "jlpt_kanji.parquet")) == 4
    assert len(pd.read_parquet(output_dir / "jlpt_vocab.parquet")) == 4
    assert len(pd.read_parquet(output_dir / "jmdict_furigana.parquet")) == 3
