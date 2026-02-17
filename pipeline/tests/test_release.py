"""Tests for the release bundle system (slicer, validator, uploader, web_reviewer)."""

import json
from pathlib import Path

import pandas as pd

# ── Test data builders ───────────────────────────────────────────────────────


def _make_radicals(
    symbols: list[str], family_map: dict[str, str | None] | None = None,
) -> pd.DataFrame:
    if family_map is None:
        family_map = {}
    return pd.DataFrame([
        {
            "master_symbol": s,
            "family_symbol": family_map.get(s, ""),
            "positions": '["unknown"]',
            "is_official": "True",
            "stroke_count": "3",
            "visual_group": "lines",
            "svg_file_name": f"{ord(s):x}.svg",
            "svg_file_url": f"http://localhost:54321/storage/v1/object/public/svg/radicals/{ord(s):x}.svg",
            "svg_hash": "abc123",
            "impact_score": "10",
            "min_grade": "1",
            "min_jlpt_level": "5",
        }
        for s in symbols
    ])


def _make_radical_i18n(symbols: list[str], langs: list[str]) -> pd.DataFrame:
    rows = []
    for s in symbols:
        for lang in langs:
            rows.append({
                "master_symbol": s,
                "lang_code": lang,
                "name": f"name_{s}_{lang}",
                "system_mnemonic": f"mnemonic_{s}_{lang}",
                "search_tags": '["tag1"]',
                "disambiguation_note": "",
            })
    return pd.DataFrame(rows)


def _make_kanji(chars: list[str], jlpt: int = 5) -> pd.DataFrame:
    return pd.DataFrame([
        {
            "character": c,
            "stroke_count": "5",
            "min_grade": "1",
            "min_jlpt_level": str(jlpt),
            "frequency_rank": str(i + 1),
            "svg_file_name": f"{ord(c):x}.svg",
            "svg_file_url": f"http://localhost:54321/storage/v1/object/public/svg/kanji/{ord(c):x}.svg",
            "svg_hash": "def456",
        }
        for i, c in enumerate(chars)
    ])


def _make_kanji_readings(chars: list[str]) -> pd.DataFrame:
    return pd.DataFrame([
        {"character": c, "reading": f"reading_{c}", "reading_type": "onyomi", "priority": "normal"}
        for c in chars
    ])


def _make_kanji_i18n(chars: list[str], langs: list[str]) -> pd.DataFrame:
    rows = []
    for c in chars:
        for lang in langs:
            rows.append({
                "character": c,
                "lang_code": lang,
                "meanings": f'["{c}_meaning_{lang}"]',
                "system_mnemonic": f"mnemonic_{c}_{lang}",
                "search_tags": '["tag1"]',
            })
    return pd.DataFrame(rows)


def _make_kanji_components(char_to_radicals: dict[str, list[str]]) -> pd.DataFrame:
    cols = ["character", "master_symbol", "position", "logic_hint", "radical_type", "is_primary"]
    rows = []
    for char, radicals in char_to_radicals.items():
        for rad in radicals:
            rows.append({
                "character": char,
                "master_symbol": rad,
                "position": "hen",
                "logic_hint": "none",
                "radical_type": "general",
                "is_primary": "True",
            })
    return pd.DataFrame(rows, columns=cols)


def _make_vocabulary(ids: list[int], jlpt: int = 5) -> pd.DataFrame:
    return pd.DataFrame([
        {
            "id": str(vid),
            "word": f"word_{vid}",
            "furigana": f"{{word_{vid}|reading}}",
            "min_jlpt_level": str(jlpt),
            "pos_tags": '["noun"]',
            "misc_tags": "[]",
            "field_tags": "[]",
            "dialect_tags": "[]",
            "frequency_rank": str(i + 1),
        }
        for i, vid in enumerate(ids)
    ])


def _make_vocabulary_readings(ids: list[int]) -> pd.DataFrame:
    return pd.DataFrame([
        {
            "vocabulary_id": str(vid), "reading": f"reading_{vid}",
            "reading_type": "primary", "priority": "normal",
        }
        for vid in ids
    ])


def _make_vocabulary_i18n(ids: list[int], langs: list[str]) -> pd.DataFrame:
    rows = []
    for vid in ids:
        for lang in langs:
            rows.append({
                "vocabulary_id": str(vid),
                "lang_code": lang,
                "meanings": f'["meaning_{vid}_{lang}"]',
                "system_mnemonic": "",
                "search_tags": '["tag1"]',
            })
    return pd.DataFrame(rows)


def _make_vocabulary_kanji(vid_to_chars: dict[int, list[str]]) -> pd.DataFrame:
    rows = []
    for vid, chars in vid_to_chars.items():
        for i, c in enumerate(chars):
            rows.append({
                "vocabulary_id": str(vid),
                "character": c,
                "position": str(i),
            })
    return pd.DataFrame(rows)


def _make_vocabulary_sentences(ids: list[int], with_furigana: bool = True) -> pd.DataFrame:
    return pd.DataFrame([
        {
            "vocabulary_id": str(vid),
            "original_text": f"{{日|にち}}に{vid}" if with_furigana else f"日に{vid}",
        }
        for vid in ids
    ])


def _make_vocabulary_sentence_i18n(
    ids: list[int], langs: list[str],
) -> pd.DataFrame:
    rows = []
    for vid in ids:
        for lang in langs:
            rows.append({
                "vocabulary_id": str(vid),
                "lang_code": lang,
                "sentence_translated": f"translated_{vid}_{lang}",
            })
    return pd.DataFrame(rows)


def _write_all_csvs(
    csv_dir: Path,
    kanji_chars: list[str],
    radical_symbols: list[str],
    char_to_radicals: dict[str, list[str]],
    vocab_ids: list[int],
    vid_to_chars: dict[int, list[str]],
    langs: list[str] | None = None,
    kanji_jlpt: int = 5,
    vocab_jlpt: int = 5,
    with_furigana: bool = True,
) -> None:
    """Write a complete set of main CSVs to csv_dir."""
    if langs is None:
        langs = ["en", "es", "ru"]
    csv_dir.mkdir(parents=True, exist_ok=True)

    _make_kanji(kanji_chars, kanji_jlpt).to_csv(csv_dir / "kanji.csv", index=False)
    _make_kanji_readings(kanji_chars).to_csv(csv_dir / "kanji_readings.csv", index=False)
    _make_kanji_i18n(kanji_chars, langs).to_csv(csv_dir / "kanji_i18n.csv", index=False)
    _make_kanji_components(char_to_radicals).to_csv(csv_dir / "kanji_components.csv", index=False)
    _make_radicals(radical_symbols).to_csv(csv_dir / "radicals.csv", index=False)
    _make_radical_i18n(radical_symbols, langs).to_csv(csv_dir / "radical_i18n.csv", index=False)
    _make_vocabulary(vocab_ids, vocab_jlpt).to_csv(csv_dir / "vocabulary.csv", index=False)
    _make_vocabulary_readings(vocab_ids).to_csv(csv_dir / "vocabulary_readings.csv", index=False)
    _make_vocabulary_i18n(vocab_ids, langs).to_csv(csv_dir / "vocabulary_i18n.csv", index=False)
    _make_vocabulary_kanji(vid_to_chars).to_csv(csv_dir / "vocabulary_kanji.csv", index=False)
    _make_vocabulary_sentences(vocab_ids, with_furigana).to_csv(
        csv_dir / "vocabulary_sentences.csv", index=False,
    )
    _make_vocabulary_sentence_i18n(vocab_ids, langs).to_csv(
        csv_dir / "vocabulary_sentence_i18n.csv", index=False,
    )


# ── Slicer tests ─────────────────────────────────────────────────────────────


class TestSlicer:
    """Tests for src.releases.slicer.slice_batch."""

    def _setup(self, tmp_path, monkeypatch):
        """Create test CSV data and patch config paths."""
        csv_dir = tmp_path / "csv"
        releases_dir = tmp_path / "releases"
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir(parents=True)

        kanji_chars = ["日", "一", "人", "国", "年"]
        radical_symbols = ["丿", "囗"]
        char_to_radicals = {"日": ["丿"], "国": ["囗"]}
        vocab_ids = [100, 200, 300, 400, 500]
        vid_to_chars = {100: ["日"], 200: ["国"]}

        _write_all_csvs(
            csv_dir, kanji_chars, radical_symbols, char_to_radicals,
            vocab_ids, vid_to_chars,
        )

        # Create Tanos JLPT vocab parquet with all test words at N5
        jlpt_vocab = pd.DataFrame([
            {"expression": f"word_{vid}", "reading": f"reading_{vid}", "level": 5}
            for vid in vocab_ids
        ])
        jlpt_vocab.to_parquet(parquet_dir / "jlpt_vocab.parquet", index=False)

        monkeypatch.setattr("src.releases.slicer.CSV_DIR", csv_dir)
        monkeypatch.setattr("src.releases.slicer.RELEASES_DIR", releases_dir)
        monkeypatch.setattr("src.releases.slicer.PARQUET_DIR", parquet_dir)

        return csv_dir, releases_dir

    def test_slice_creates_batch_directory(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        result = slice_batch("test_batch", jlpt_level=5, kanji_count=3, vocab_count=2)

        assert result == releases_dir / "test_batch"
        assert result.is_dir()

    def test_slice_creates_all_csvs(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        slice_batch("test_batch", jlpt_level=5, kanji_count=3, vocab_count=2)

        expected_files = [
            "batch.toml", "radicals.csv", "radical_i18n.csv",
            "kanji.csv", "kanji_readings.csv",
            "kanji_i18n.csv", "kanji_components.csv", "vocabulary.csv",
            "vocabulary_readings.csv", "vocabulary_i18n.csv",
            "vocabulary_kanji.csv", "vocabulary_sentences.csv",
            "vocabulary_sentence_i18n.csv",
        ]
        batch_dir = releases_dir / "test_batch"
        for f in expected_files:
            assert (batch_dir / f).exists(), f"Missing {f}"

    def test_slice_respects_kanji_count(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        slice_batch("test_batch", jlpt_level=5, kanji_count=3, vocab_count=2)

        kanji_df = pd.read_csv(releases_dir / "test_batch" / "kanji.csv")
        assert len(kanji_df) == 3

    def test_slice_respects_vocab_count(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        slice_batch("test_batch", jlpt_level=5, kanji_count=3, vocab_count=2)

        vocab_df = pd.read_csv(releases_dir / "test_batch" / "vocabulary.csv")
        assert len(vocab_df) == 2

    def test_slice_sorts_kanji_by_frequency(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        slice_batch("test_batch", jlpt_level=5, kanji_count=5, vocab_count=2)

        kanji_df = pd.read_csv(releases_dir / "test_batch" / "kanji.csv")
        ranks = kanji_df["frequency_rank"].tolist()
        assert ranks == sorted(ranks)

    def test_slice_resolves_radicals_from_components(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        slice_batch("test_batch", jlpt_level=5, kanji_count=5, vocab_count=2)

        radicals_df = pd.read_csv(
            releases_dir / "test_batch" / "radicals.csv", dtype=str,
        )
        symbols = set(radicals_df["master_symbol"])
        assert symbols == {"丿", "囗"}

    def test_slice_batch_toml_content(self, tmp_path, monkeypatch):
        import tomllib

        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)
        slice_batch("test_batch", jlpt_level=5, kanji_count=2, vocab_count=3)

        with open(releases_dir / "test_batch" / "batch.toml", "rb") as f:
            toml = tomllib.load(f)
        assert toml["name"] == "test_batch"
        assert toml["jlpt_level"] == 5
        assert toml["version"] == 1
        assert len(toml["kanji"]) == 2
        assert len(toml["vocab_ids"]) == 3

    def test_slice_excludes_already_allocated(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)

        # Slice first batch
        slice_batch("batch_1", jlpt_level=5, kanji_count=2, vocab_count=2)
        # Slice second batch — should get different kanji
        slice_batch("batch_2", jlpt_level=5, kanji_count=2, vocab_count=2)

        k1 = set(pd.read_csv(releases_dir / "batch_1" / "kanji.csv")["character"])
        k2 = set(pd.read_csv(releases_dir / "batch_2" / "kanji.csv")["character"])
        assert k1.isdisjoint(k2), "Batches should not share kanji"
        assert len(k1) == 2
        assert len(k2) == 2

    def test_slice_scaffolds_missing_i18n(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        csv_dir = tmp_path / "csv"
        releases_dir = tmp_path / "releases"
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir(parents=True)

        # Write CSVs with only EN i18n rows
        _write_all_csvs(
            csv_dir,
            kanji_chars=["日"],
            radical_symbols=["丿"],
            char_to_radicals={"日": ["丿"]},
            vocab_ids=[100],
            vid_to_chars={100: ["日"]},
            langs=["en"],  # Only EN — ES and RU missing
        )
        pd.DataFrame([
            {"expression": "word_100", "reading": "r", "level": 5},
        ]).to_parquet(parquet_dir / "jlpt_vocab.parquet", index=False)

        monkeypatch.setattr("src.releases.slicer.CSV_DIR", csv_dir)
        monkeypatch.setattr("src.releases.slicer.RELEASES_DIR", releases_dir)
        monkeypatch.setattr("src.releases.slicer.PARQUET_DIR", parquet_dir)

        slice_batch("test_batch", jlpt_level=5, kanji_count=1, vocab_count=1)

        # Should have 3 rows (en, es, ru) even though source only had en
        kanji_i18n = pd.read_csv(
            releases_dir / "test_batch" / "kanji_i18n.csv", dtype=str,
        )
        assert len(kanji_i18n) == 3
        assert set(kanji_i18n["lang_code"]) == {"en", "es", "ru"}

    def test_slice_filters_by_jlpt_level(self, tmp_path, monkeypatch):
        from src.releases.slicer import slice_batch

        csv_dir = tmp_path / "csv"
        releases_dir = tmp_path / "releases"
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir(parents=True)

        # Mix N5 and N4 kanji
        n5 = _make_kanji(["日", "一"], jlpt=5)
        n4 = _make_kanji(["学", "校"], jlpt=4)
        csv_dir.mkdir(parents=True)
        pd.concat([n5, n4]).to_csv(csv_dir / "kanji.csv", index=False)

        # Write remaining CSVs with all chars
        all_chars = ["日", "一", "学", "校"]
        _make_kanji_readings(all_chars).to_csv(csv_dir / "kanji_readings.csv", index=False)
        _make_kanji_i18n(all_chars, ["en", "es", "ru"]).to_csv(
            csv_dir / "kanji_i18n.csv", index=False,
        )
        _make_kanji_components({"日": [], "一": []}).to_csv(
            csv_dir / "kanji_components.csv", index=False,
        )
        _make_radicals(["丿"]).to_csv(csv_dir / "radicals.csv", index=False)
        _make_radical_i18n(["丿"], ["en", "es", "ru"]).to_csv(
            csv_dir / "radical_i18n.csv", index=False,
        )
        _make_vocabulary([100], 5).to_csv(csv_dir / "vocabulary.csv", index=False)
        _make_vocabulary_readings([100]).to_csv(
            csv_dir / "vocabulary_readings.csv", index=False,
        )
        _make_vocabulary_i18n([100], ["en", "es", "ru"]).to_csv(
            csv_dir / "vocabulary_i18n.csv", index=False,
        )
        _make_vocabulary_kanji({100: ["日"]}).to_csv(
            csv_dir / "vocabulary_kanji.csv", index=False,
        )
        _make_vocabulary_sentences([100]).to_csv(
            csv_dir / "vocabulary_sentences.csv", index=False,
        )
        _make_vocabulary_sentence_i18n([100], ["en", "es", "ru"]).to_csv(
            csv_dir / "vocabulary_sentence_i18n.csv", index=False,
        )
        # JLPT vocab parquet
        pd.DataFrame([
            {"expression": "word_100", "reading": "r", "level": 5},
        ]).to_parquet(parquet_dir / "jlpt_vocab.parquet", index=False)

        monkeypatch.setattr("src.releases.slicer.CSV_DIR", csv_dir)
        monkeypatch.setattr("src.releases.slicer.RELEASES_DIR", releases_dir)
        monkeypatch.setattr("src.releases.slicer.PARQUET_DIR", parquet_dir)

        slice_batch("n5_only", jlpt_level=5, kanji_count=10, vocab_count=0)

        kanji_df = pd.read_csv(releases_dir / "n5_only" / "kanji.csv", dtype=str)
        assert set(kanji_df["character"]) == {"日", "一"}

    def test_slice_excludes_vocab_not_in_tanos(self, tmp_path, monkeypatch):
        """Vocab with matching JLPT level but NOT in Tanos parquet is excluded."""
        from src.releases.slicer import slice_batch

        csv_dir = tmp_path / "csv"
        releases_dir = tmp_path / "releases"
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir(parents=True)

        # 5 vocab items at N5
        vocab_ids = [100, 200, 300, 400, 500]
        _write_all_csvs(
            csv_dir,
            kanji_chars=["日"],
            radical_symbols=["丿"],
            char_to_radicals={"日": ["丿"]},
            vocab_ids=vocab_ids,
            vid_to_chars={100: ["日"]},
        )

        # Tanos parquet only includes word_100 and word_300
        pd.DataFrame([
            {"expression": "word_100", "reading": "r", "level": 5},
            {"expression": "word_300", "reading": "r", "level": 5},
        ]).to_parquet(parquet_dir / "jlpt_vocab.parquet", index=False)

        monkeypatch.setattr("src.releases.slicer.CSV_DIR", csv_dir)
        monkeypatch.setattr("src.releases.slicer.RELEASES_DIR", releases_dir)
        monkeypatch.setattr("src.releases.slicer.PARQUET_DIR", parquet_dir)

        slice_batch("test_batch", jlpt_level=5, kanji_count=1, vocab_count=10)

        vocab_df = pd.read_csv(releases_dir / "test_batch" / "vocabulary.csv", dtype=str)
        words = set(vocab_df["word"])
        # Only the 2 Tanos words should be included
        assert words == {"word_100", "word_300"}

    def test_summary_log_shows_counts(self, tmp_path, monkeypatch, caplog):
        import logging

        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)

        with caplog.at_level(logging.INFO, logger="src.releases.slicer"):
            slice_batch("test_batch", jlpt_level=5, kanji_count=3, vocab_count=2)

        log_text = caplog.text
        assert "Kanji:" in log_text
        assert "3 selected" in log_text
        assert "remaining: 2" in log_text
        assert "Vocabulary:" in log_text
        assert "2 selected" in log_text
        assert "remaining: 3" in log_text
        assert "Radicals:" in log_text

    def test_summary_log_all_done_when_exhausted(self, tmp_path, monkeypatch, caplog):
        import logging

        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)

        # Take all 5 kanji and all 5 vocab
        with caplog.at_level(logging.INFO, logger="src.releases.slicer"):
            slice_batch("test_batch", jlpt_level=5, kanji_count=10, vocab_count=10)

        log_text = caplog.text
        assert "remaining: 0" in log_text
        assert "all done" in log_text

    def test_summary_log_zero_kanji_when_exhausted(self, tmp_path, monkeypatch, caplog):
        import logging

        from src.releases.slicer import slice_batch

        _, releases_dir = self._setup(tmp_path, monkeypatch)

        # First batch takes all 5 kanji
        slice_batch("batch_1", jlpt_level=5, kanji_count=10, vocab_count=2)
        caplog.clear()

        # Second batch — no kanji left
        with caplog.at_level(logging.INFO, logger="src.releases.slicer"):
            slice_batch("batch_2", jlpt_level=5, kanji_count=10, vocab_count=2)

        log_text = caplog.text
        assert "Kanji:" in log_text
        assert "0 selected" in log_text
        assert "all done" in log_text
        # Vocab should still have items
        assert "Vocabulary:" in log_text
        assert "2 selected" in log_text


# ── Validator tests ──────────────────────────────────────────────────────────


class TestValidator:
    """Tests for src.releases.validator.validate_batch."""

    def _make_valid_batch(self, releases_dir: Path, name: str = "valid") -> Path:
        """Create a fully valid batch directory."""
        batch_dir = releases_dir / name
        batch_dir.mkdir(parents=True)

        kanji_chars = ["日"]
        radical_symbols = ["丿"]
        vocab_ids = [100]

        _make_radicals(radical_symbols).to_csv(batch_dir / "radicals.csv", index=False)
        _make_radical_i18n(radical_symbols, ["en", "es", "ru"]).to_csv(
            batch_dir / "radical_i18n.csv", index=False,
        )
        _make_kanji(kanji_chars).to_csv(batch_dir / "kanji.csv", index=False)
        _make_kanji_readings(kanji_chars).to_csv(batch_dir / "kanji_readings.csv", index=False)
        _make_kanji_i18n(kanji_chars, ["en", "es", "ru"]).to_csv(
            batch_dir / "kanji_i18n.csv", index=False,
        )
        _make_kanji_components({"日": ["丿"]}).to_csv(
            batch_dir / "kanji_components.csv", index=False,
        )
        _make_vocabulary(vocab_ids).to_csv(batch_dir / "vocabulary.csv", index=False)
        _make_vocabulary_readings(vocab_ids).to_csv(
            batch_dir / "vocabulary_readings.csv", index=False,
        )
        _make_vocabulary_i18n(vocab_ids, ["en", "es", "ru"]).to_csv(
            batch_dir / "vocabulary_i18n.csv", index=False,
        )
        _make_vocabulary_kanji({100: ["日"]}).to_csv(
            batch_dir / "vocabulary_kanji.csv", index=False,
        )
        _make_vocabulary_sentences(vocab_ids, with_furigana=True).to_csv(
            batch_dir / "vocabulary_sentences.csv", index=False,
        )
        _make_vocabulary_sentence_i18n(vocab_ids, ["en", "es", "ru"]).to_csv(
            batch_dir / "vocabulary_sentence_i18n.csv", index=False,
        )
        return batch_dir

    def test_valid_batch_passes(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        self._make_valid_batch(releases_dir)
        errors = validate_batch("valid")
        assert errors == []

    def test_missing_batch_directory(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        errors = validate_batch("nonexistent")
        assert len(errors) == 1
        assert "does not exist" in errors[0].message

    def test_empty_system_mnemonic_in_kanji_i18n(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        batch_dir = self._make_valid_batch(releases_dir)
        # Overwrite kanji_i18n with empty mnemonic
        df = pd.read_csv(batch_dir / "kanji_i18n.csv", dtype=str, keep_default_na=False)
        df["system_mnemonic"] = ""
        df.to_csv(batch_dir / "kanji_i18n.csv", index=False)

        errors = validate_batch("valid")
        mnemonic_errors = [e for e in errors if "system_mnemonic" in e.message]
        assert len(mnemonic_errors) == 3  # one per lang

    def test_empty_search_tags_in_vocabulary_i18n(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        batch_dir = self._make_valid_batch(releases_dir)
        df = pd.read_csv(batch_dir / "vocabulary_i18n.csv", dtype=str, keep_default_na=False)
        df["search_tags"] = "[]"
        df.to_csv(batch_dir / "vocabulary_i18n.csv", index=False)

        errors = validate_batch("valid")
        tag_errors = [e for e in errors if "search_tags" in e.message]
        assert len(tag_errors) == 3

    def test_missing_furigana_in_sentences(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        batch_dir = self._make_valid_batch(releases_dir)
        # Overwrite sentences without furigana
        _make_vocabulary_sentences([100], with_furigana=False).to_csv(
            batch_dir / "vocabulary_sentences.csv", index=False,
        )

        errors = validate_batch("valid")
        furigana_errors = [e for e in errors if "furigana" in e.message]
        assert len(furigana_errors) == 1

    def test_missing_i18n_lang(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        batch_dir = self._make_valid_batch(releases_dir)
        # Remove RU rows from kanji_i18n
        df = pd.read_csv(batch_dir / "kanji_i18n.csv", dtype=str, keep_default_na=False)
        df = df[df["lang_code"] != "ru"]
        df.to_csv(batch_dir / "kanji_i18n.csv", index=False)

        errors = validate_batch("valid")
        lang_errors = [e for e in errors if "lang_code='ru'" in e.message]
        assert len(lang_errors) == 1

    def test_component_references_missing_radical(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        batch_dir = self._make_valid_batch(releases_dir)
        # Add a component referencing a radical not in the batch
        comp_df = pd.read_csv(batch_dir / "kanji_components.csv", dtype=str, keep_default_na=False)
        new_row = comp_df.iloc[0].copy()
        new_row["master_symbol"] = "⻌"  # not in radicals.csv
        comp_df = pd.concat([comp_df, pd.DataFrame([new_row])], ignore_index=True)
        comp_df.to_csv(batch_dir / "kanji_components.csv", index=False)

        errors = validate_batch("valid")
        ref_errors = [e for e in errors if "not in batch" in e.message]
        assert len(ref_errors) == 1
        assert "⻌" in ref_errors[0].row

    def test_vocab_kanji_resolved_from_pushed_batches(self, tmp_path, monkeypatch):
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        # Create "pushed" batch with kanji 学
        pushed_dir = releases_dir / "pushed_batch"
        pushed_dir.mkdir(parents=True)
        _make_kanji(["学"]).to_csv(pushed_dir / "kanji.csv", index=False)
        (pushed_dir / "manifest.json").write_text(json.dumps({
            "pushes": [{"version": 1, "pushed_at": "2026-01-01T00:00:00"}],
        }))

        # Create batch under test with vocab referencing 学
        batch_dir = self._make_valid_batch(releases_dir)
        vk_df = pd.read_csv(batch_dir / "vocabulary_kanji.csv", dtype=str, keep_default_na=False)
        new_row = {"vocabulary_id": "100", "character": "学", "position": "1"}
        vk_df = pd.concat([vk_df, pd.DataFrame([new_row])], ignore_index=True)
        vk_df.to_csv(batch_dir / "vocabulary_kanji.csv", index=False)

        errors = validate_batch("valid")
        ref_errors = [e for e in errors if "previously-pushed" in e.message]
        assert len(ref_errors) == 0  # 学 found in pushed batch

    def test_vocab_system_mnemonic_nullable(self, tmp_path, monkeypatch):
        """vocabulary_i18n.system_mnemonic is nullable per mnemonic.md."""
        from src.releases.validator import validate_batch

        releases_dir = tmp_path / "releases"
        monkeypatch.setattr("src.releases.validator.RELEASES_DIR", releases_dir)

        batch_dir = self._make_valid_batch(releases_dir)
        df = pd.read_csv(batch_dir / "vocabulary_i18n.csv", dtype=str, keep_default_na=False)
        df["system_mnemonic"] = ""
        df.to_csv(batch_dir / "vocabulary_i18n.csv", index=False)

        errors = validate_batch("valid")
        mnemonic_errors = [e for e in errors if "system_mnemonic" in e.message]
        assert len(mnemonic_errors) == 0  # should NOT flag


# ── Uploader tests ───────────────────────────────────────────────────────────


class TestUploader:
    """Tests for src.releases.uploader helper functions."""

    def test_rewrite_svg_urls(self):
        from src.releases.uploader import _rewrite_svg_urls

        df = pd.DataFrame({
            "character": ["日"],
            "svg_file_url": ["http://localhost:54321/storage/v1/object/public/svg/kanji/65e5.svg"],
        })
        result = _rewrite_svg_urls(df, "https://prod.supabase.co/storage/v1/object/public/svg")
        assert "localhost" not in result.iloc[0]["svg_file_url"]
        assert result.iloc[0]["svg_file_url"].startswith("https://prod.supabase.co/")

    def test_rewrite_preserves_non_svg_columns(self):
        from src.releases.uploader import _rewrite_svg_urls

        df = pd.DataFrame({"character": ["日"], "stroke_count": ["5"]})
        result = _rewrite_svg_urls(df, "https://prod.supabase.co")
        assert list(result.columns) == ["character", "stroke_count"]

    def test_csv_checksum_deterministic(self, tmp_path):
        from src.releases.uploader import _csv_checksum

        path = tmp_path / "test.csv"
        path.write_text("a,b\n1,2\n")
        c1 = _csv_checksum(path)
        c2 = _csv_checksum(path)
        assert c1 == c2

    def test_manifest_versioning(self, tmp_path, monkeypatch):
        from src.releases.uploader import _load_manifest, _save_manifest

        batch_dir = tmp_path / "batch"
        batch_dir.mkdir()

        # Fresh manifest
        m = _load_manifest(batch_dir)
        assert m["current_version"] == 0
        assert m["pushes"] == []

        # Save and reload
        m["current_version"] = 1
        m["pushes"].append({"version": 1, "pushed_at": "now"})
        _save_manifest(batch_dir, m)

        m2 = _load_manifest(batch_dir)
        assert m2["current_version"] == 1
        assert len(m2["pushes"]) == 1

    def test_coerce_int_columns(self):
        from src.releases.uploader import _coerce_int_columns

        df = pd.DataFrame({"id": ["100"], "word": ["test"], "min_jlpt_level": ["5"]})
        result = _coerce_int_columns(df.copy(), "vocabulary")
        assert result["id"].dtype.name == "Int64"
        assert result["min_jlpt_level"].dtype.name == "Int64"
        # word column should remain string, not coerced
        assert result.iloc[0]["word"] == "test"

    def test_coerce_bool_columns(self):
        from src.releases.uploader import _coerce_bool_columns

        df = pd.DataFrame({"master_symbol": ["丿"], "is_official": ["True"]})
        result = _coerce_bool_columns(df.copy(), "radicals")
        assert bool(result.iloc[0]["is_official"]) is True


# ── Reviewer tests ──────────────────────────────────────────────────────────


class TestReviewer:
    """Tests for src.releases.reviewer — review.xlsx generation and apply."""

    def _make_batch(self, tmp_path: Path) -> Path:
        """Create a minimal valid batch and return batch_dir."""
        batch_dir = tmp_path / "releases" / "test_batch"
        batch_dir.mkdir(parents=True)

        kanji_chars = ["日", "一"]
        radical_symbols = ["丿"]
        vocab_ids = [100, 200]
        langs = ["en", "es", "ru"]

        _make_radicals(radical_symbols).to_csv(batch_dir / "radicals.csv", index=False)
        _make_radical_i18n(radical_symbols, langs).to_csv(
            batch_dir / "radical_i18n.csv", index=False,
        )
        _make_kanji(kanji_chars).to_csv(batch_dir / "kanji.csv", index=False)
        _make_kanji_readings(kanji_chars).to_csv(batch_dir / "kanji_readings.csv", index=False)
        _make_kanji_i18n(kanji_chars, langs).to_csv(
            batch_dir / "kanji_i18n.csv", index=False,
        )
        _make_kanji_components({"日": ["丿"]}).to_csv(
            batch_dir / "kanji_components.csv", index=False,
        )
        _make_vocabulary(vocab_ids).to_csv(batch_dir / "vocabulary.csv", index=False)
        _make_vocabulary_readings(vocab_ids).to_csv(
            batch_dir / "vocabulary_readings.csv", index=False,
        )
        _make_vocabulary_i18n(vocab_ids, langs).to_csv(
            batch_dir / "vocabulary_i18n.csv", index=False,
        )
        _make_vocabulary_kanji({100: ["日"]}).to_csv(
            batch_dir / "vocabulary_kanji.csv", index=False,
        )
        _make_vocabulary_sentences(vocab_ids).to_csv(
            batch_dir / "vocabulary_sentences.csv", index=False,
        )
        _make_vocabulary_sentence_i18n(vocab_ids, langs).to_csv(
            batch_dir / "vocabulary_sentence_i18n.csv", index=False,
        )
        return batch_dir

    def test_generate_creates_xlsx(self, tmp_path, monkeypatch):
        from src.releases.reviewer import generate_review_xlsx

        batch_dir = self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")

        assert path == batch_dir / "review.xlsx"
        assert path.is_file()

    def test_xlsx_has_four_sheets(self, tmp_path, monkeypatch):
        from src.releases.reviewer import generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")
        sheets = pd.read_excel(path, sheet_name=None, engine="openpyxl")

        assert set(sheets.keys()) == {"Radicals", "Kanji", "Vocabulary", "Sentences"}

    def test_radicals_sheet_has_wide_columns(self, tmp_path, monkeypatch):
        from src.releases.reviewer import generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")
        df = pd.read_excel(path, sheet_name="Radicals", engine="openpyxl")

        assert "master_symbol" in df.columns
        assert "name_en" in df.columns
        assert "name_es" in df.columns
        assert "name_ru" in df.columns
        assert "system_mnemonic_en" in df.columns
        assert len(df) == 1  # one radical

    def test_kanji_sheet_row_count_and_context(self, tmp_path, monkeypatch):
        from src.releases.reviewer import generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")
        df = pd.read_excel(path, sheet_name="Kanji", engine="openpyxl")

        assert len(df) == 2
        assert "character" in df.columns
        assert "frequency_rank" in df.columns
        assert "meanings_en" in df.columns

    def test_sentences_sheet_has_word_context(self, tmp_path, monkeypatch):
        from src.releases.reviewer import generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")
        df = pd.read_excel(path, sheet_name="Sentences", engine="openpyxl")

        assert "word" in df.columns
        assert "original_text" in df.columns
        assert "sentence_translated_en" in df.columns
        assert len(df) == 2

    def test_round_trip_preserves_data(self, tmp_path, monkeypatch):
        """review → apply → review produces identical data."""
        from src.releases.reviewer import apply_review_xlsx, generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        # First pass: generate
        path1 = generate_review_xlsx("test_batch")
        sheets1 = pd.read_excel(path1, sheet_name=None, engine="openpyxl", dtype=str)
        sheets1 = {k: v.fillna("") for k, v in sheets1.items()}

        # Apply (no edits)
        apply_review_xlsx("test_batch")

        # Second pass: regenerate
        path2 = generate_review_xlsx("test_batch")
        sheets2 = pd.read_excel(path2, sheet_name=None, engine="openpyxl", dtype=str)
        sheets2 = {k: v.fillna("") for k, v in sheets2.items()}

        for sheet_name in sheets1:
            pd.testing.assert_frame_equal(
                sheets1[sheet_name], sheets2[sheet_name],
                check_names=True, obj=sheet_name,
            )

    def test_apply_writes_edited_value(self, tmp_path, monkeypatch):
        """Editing a cell in xlsx propagates to the CSV."""
        from src.releases.reviewer import apply_review_xlsx, generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")

        # Edit a kanji mnemonic in the xlsx
        sheets = pd.read_excel(path, sheet_name=None, engine="openpyxl", dtype=str)
        sheets["Kanji"].loc[0, "system_mnemonic_en"] = "EDITED_MNEMONIC"
        with pd.ExcelWriter(path, engine="openpyxl") as writer:
            for name, df in sheets.items():
                df.to_excel(writer, sheet_name=name, index=False)

        apply_review_xlsx("test_batch")

        # Verify the CSV was updated
        batch_dir = tmp_path / "releases" / "test_batch"
        kanji_i18n = pd.read_csv(batch_dir / "kanji_i18n.csv", dtype=str, keep_default_na=False)
        en_rows = kanji_i18n[kanji_i18n["lang_code"] == "en"]
        assert "EDITED_MNEMONIC" in en_rows["system_mnemonic"].values

    def test_apply_updates_original_text(self, tmp_path, monkeypatch):
        """Editing original_text in Sentences sheet writes to vocabulary_sentences.csv."""
        from src.releases.reviewer import apply_review_xlsx, generate_review_xlsx

        self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        path = generate_review_xlsx("test_batch")

        sheets = pd.read_excel(path, sheet_name=None, engine="openpyxl", dtype=str)
        sheets["Sentences"].loc[0, "original_text"] = "{新|あたら}しいテスト"
        with pd.ExcelWriter(path, engine="openpyxl") as writer:
            for name, df in sheets.items():
                df.to_excel(writer, sheet_name=name, index=False)

        apply_review_xlsx("test_batch")

        batch_dir = tmp_path / "releases" / "test_batch"
        sentences = pd.read_csv(
            batch_dir / "vocabulary_sentences.csv", dtype=str, keep_default_na=False,
        )
        assert "{新|あたら}しいテスト" in sentences["original_text"].values

    def test_missing_batch_raises(self, tmp_path, monkeypatch):
        import pytest

        from src.releases.reviewer import generate_review_xlsx

        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        with pytest.raises(FileNotFoundError):
            generate_review_xlsx("nonexistent")

    def test_missing_xlsx_raises(self, tmp_path, monkeypatch):
        import pytest

        from src.releases.reviewer import apply_review_xlsx

        batch_dir = tmp_path / "releases" / "test_batch"
        batch_dir.mkdir(parents=True)
        monkeypatch.setattr("src.releases.reviewer.RELEASES_DIR", tmp_path / "releases")

        with pytest.raises(FileNotFoundError):
            apply_review_xlsx("test_batch")


# ── Web Reviewer tests ──────────────────────────────────────────────────────


class TestWebReviewer:
    """Tests for src.releases.web_reviewer — HTML review data loading and changeset apply."""

    def _make_batch(self, tmp_path: Path) -> Path:
        """Create a minimal valid batch and return batch_dir."""
        batch_dir = tmp_path / "releases" / "test_batch"
        batch_dir.mkdir(parents=True)

        kanji_chars = ["日", "一"]
        radical_symbols = ["丿"]
        vocab_ids = [100, 200]
        langs = ["en", "es", "ru"]

        _make_radicals(radical_symbols).to_csv(batch_dir / "radicals.csv", index=False)
        _make_radical_i18n(radical_symbols, langs).to_csv(
            batch_dir / "radical_i18n.csv", index=False,
        )
        _make_kanji(kanji_chars).to_csv(batch_dir / "kanji.csv", index=False)
        _make_kanji_readings(kanji_chars).to_csv(batch_dir / "kanji_readings.csv", index=False)
        _make_kanji_i18n(kanji_chars, langs).to_csv(
            batch_dir / "kanji_i18n.csv", index=False,
        )
        _make_kanji_components({"日": ["丿"]}).to_csv(
            batch_dir / "kanji_components.csv", index=False,
        )
        _make_vocabulary(vocab_ids).to_csv(batch_dir / "vocabulary.csv", index=False)
        _make_vocabulary_readings(vocab_ids).to_csv(
            batch_dir / "vocabulary_readings.csv", index=False,
        )
        _make_vocabulary_i18n(vocab_ids, langs).to_csv(
            batch_dir / "vocabulary_i18n.csv", index=False,
        )
        _make_vocabulary_kanji({100: ["日"]}).to_csv(
            batch_dir / "vocabulary_kanji.csv", index=False,
        )
        _make_vocabulary_sentences(vocab_ids).to_csv(
            batch_dir / "vocabulary_sentences.csv", index=False,
        )
        _make_vocabulary_sentence_i18n(vocab_ids, langs).to_csv(
            batch_dir / "vocabulary_sentence_i18n.csv", index=False,
        )
        return batch_dir

    def test_load_batch_data_structure(self, tmp_path, monkeypatch):
        from src.releases.web_reviewer import _load_batch_data

        batch_dir = self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.web_reviewer.RELEASES_DIR", tmp_path / "releases")

        data = _load_batch_data(batch_dir, "test_batch")

        assert data["batch_name"] == "test_batch"
        assert "radicals" in data
        assert "kanji" in data
        assert "vocabulary" in data
        assert "sentences" in data
        assert len(data["radicals"]) == 1
        assert len(data["kanji"]) == 2
        assert len(data["vocabulary"]) == 2
        assert len(data["sentences"]) == 2

    def test_load_batch_data_i18n_grouping(self, tmp_path, monkeypatch):
        from src.releases.web_reviewer import _load_batch_data

        batch_dir = self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.web_reviewer.RELEASES_DIR", tmp_path / "releases")

        data = _load_batch_data(batch_dir, "test_batch")

        # Radicals have i18n grouped by lang
        radical = data["radicals"][0]
        assert set(radical["i18n"].keys()) == {"en", "es", "ru"}
        assert "name" in radical["i18n"]["en"]
        assert "system_mnemonic" in radical["i18n"]["en"]

        # Kanji have i18n grouped by lang
        kanji = data["kanji"][0]
        assert set(kanji["i18n"].keys()) == {"en", "es", "ru"}
        assert "meanings" in kanji["i18n"]["en"]

        # Vocabulary have i18n grouped by lang
        vocab = data["vocabulary"][0]
        assert set(vocab["i18n"].keys()) == {"en", "es", "ru"}

        # Sentences have i18n grouped by lang
        sentence = data["sentences"][0]
        assert set(sentence["i18n"].keys()) == {"en", "es", "ru"}
        assert "sentence_translated" in sentence["i18n"]["en"]

    def test_apply_changes_patches_csv(self, tmp_path, monkeypatch):
        from src.releases.web_reviewer import apply_changes_json

        batch_dir = self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.web_reviewer.RELEASES_DIR", tmp_path / "releases")

        # Write a changeset
        changeset = {
            "version": 1,
            "batch_name": "test_batch",
            "created_at": "2026-02-17T12:00:00Z",
            "changes": {
                "radical_i18n": [
                    {
                        "key": {"master_symbol": "丿", "lang_code": "en"},
                        "fields": {"name": "EDITED_NAME"},
                    }
                ],
                "kanji_i18n": [
                    {
                        "key": {"character": "日", "lang_code": "en"},
                        "fields": {"system_mnemonic": "NEW_MNEMONIC"},
                    }
                ],
            },
        }
        (batch_dir / "changes.json").write_text(json.dumps(changeset))

        count = apply_changes_json("test_batch")

        assert count == 2

        # Verify radical_i18n was patched
        ri = pd.read_csv(batch_dir / "radical_i18n.csv", dtype=str, keep_default_na=False)
        en_row = ri[(ri["master_symbol"] == "丿") & (ri["lang_code"] == "en")]
        assert en_row.iloc[0]["name"] == "EDITED_NAME"

        # Verify kanji_i18n was patched
        ki = pd.read_csv(batch_dir / "kanji_i18n.csv", dtype=str, keep_default_na=False)
        en_row = ki[(ki["character"] == "日") & (ki["lang_code"] == "en")]
        assert en_row.iloc[0]["system_mnemonic"] == "NEW_MNEMONIC"

    def test_apply_changes_only_affects_targeted_fields(self, tmp_path, monkeypatch):
        from src.releases.web_reviewer import apply_changes_json

        batch_dir = self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.web_reviewer.RELEASES_DIR", tmp_path / "releases")

        # Read original values
        ri_before = pd.read_csv(batch_dir / "radical_i18n.csv", dtype=str, keep_default_na=False)
        orig_mnemonic = ri_before[
            (ri_before["master_symbol"] == "丿") & (ri_before["lang_code"] == "en")
        ].iloc[0]["system_mnemonic"]

        # Only change name, not mnemonic
        changeset = {
            "version": 1,
            "batch_name": "test_batch",
            "created_at": "2026-02-17T12:00:00Z",
            "changes": {
                "radical_i18n": [
                    {
                        "key": {"master_symbol": "丿", "lang_code": "en"},
                        "fields": {"name": "ONLY_THIS"},
                    }
                ],
            },
        }
        (batch_dir / "changes.json").write_text(json.dumps(changeset))

        apply_changes_json("test_batch")

        ri_after = pd.read_csv(batch_dir / "radical_i18n.csv", dtype=str, keep_default_na=False)
        en_row = ri_after[
            (ri_after["master_symbol"] == "丿") & (ri_after["lang_code"] == "en")
        ].iloc[0]
        assert en_row["name"] == "ONLY_THIS"
        assert en_row["system_mnemonic"] == orig_mnemonic  # unchanged

    def test_apply_empty_changeset_is_noop(self, tmp_path, monkeypatch):
        from src.releases.web_reviewer import apply_changes_json

        batch_dir = self._make_batch(tmp_path)
        monkeypatch.setattr("src.releases.web_reviewer.RELEASES_DIR", tmp_path / "releases")

        # Read original CSVs
        ri_before = pd.read_csv(batch_dir / "radical_i18n.csv", dtype=str, keep_default_na=False)

        changeset = {
            "version": 1,
            "batch_name": "test_batch",
            "created_at": "2026-02-17T12:00:00Z",
            "changes": {},
        }
        (batch_dir / "changes.json").write_text(json.dumps(changeset))

        count = apply_changes_json("test_batch")

        assert count == 0

        # CSV unchanged
        ri_after = pd.read_csv(batch_dir / "radical_i18n.csv", dtype=str, keep_default_na=False)
        pd.testing.assert_frame_equal(ri_before, ri_after)

    def test_apply_missing_changes_json_raises(self, tmp_path, monkeypatch):
        import pytest

        from src.releases.web_reviewer import apply_changes_json

        batch_dir = tmp_path / "releases" / "test_batch"
        batch_dir.mkdir(parents=True)
        monkeypatch.setattr("src.releases.web_reviewer.RELEASES_DIR", tmp_path / "releases")

        with pytest.raises(FileNotFoundError):
            apply_changes_json("test_batch")
