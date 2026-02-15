"""Tests for Phase 2.5 vocabulary extraction (Steps 1-6)."""

import json

import pandas as pd
import pytest

from src.extractors.ph2_5_vocabulary import extract_vocabulary

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _k_ele(keb, ke_inf=None, ke_pri=None):
    """Build a k_ele dict."""
    return {
        "keb": keb,
        "ke_inf": ke_inf or [],
        "ke_pri": ke_pri or [],
    }


def _r_ele(reb, re_nokanji=False, re_restr=None, re_pri=None):
    """Build an r_ele dict."""
    return {
        "reb": reb,
        "re_nokanji": re_nokanji,
        "re_restr": re_restr or [],
        "re_inf": [],
        "re_pri": re_pri or [],
    }


def _sense(pos=None, misc=None, field=None, dial=None, glosses=None, stagk=None, stagr=None):
    """Build a sense dict."""
    gloss_list = []
    if glosses:
        for lang, texts in glosses.items():
            for t in texts:
                gloss_list.append({"lang": lang, "text": t})
    return {
        "pos": pos or [],
        "misc": misc or [],
        "field": field or [],
        "dial": dial or [],
        "gloss": gloss_list,
        "stagk": stagk or [],
        "stagr": stagr or [],
        "xref": [],
        "ant": [],
        "lsource": [],
    }


def _jmdict_row(ent_seq, k_ele=None, r_ele=None, senses=None):
    """Build a JMdict DataFrame row with JSON-encoded fields."""
    return {
        "ent_seq": ent_seq,
        "k_ele": json.dumps(k_ele, ensure_ascii=False) if k_ele else None,
        "r_ele": json.dumps(r_ele, ensure_ascii=False),
        "senses": json.dumps(senses, ensure_ascii=False),
    }


def _make_jmdict_df(rows):
    df = pd.DataFrame(rows)
    df["ent_seq"] = df["ent_seq"].astype("int64")
    return df


def _make_jlpt_vocab_df(entries):
    """entries: list of (expression, reading, level) tuples."""
    if not entries:
        return pd.DataFrame(columns=["expression", "reading", "level"])
    df = pd.DataFrame(entries, columns=["expression", "reading", "level"])
    df["level"] = df["level"].astype("int32")
    return df


def _make_furigana_df(entries):
    """entries: list of (text, reading, furigana_segments) tuples."""
    if not entries:
        return pd.DataFrame(columns=["text", "reading", "furigana"])
    rows = []
    for text, reading, segments in entries:
        rows.append({
            "text": text,
            "reading": reading,
            "furigana": json.dumps(segments, ensure_ascii=False),
        })
    return pd.DataFrame(rows)


def _make_examples_df(entries):
    """entries: list of (ent_seq, sentence_ja, sentence_en) tuples."""
    cols = ["ent_seq", "source_id", "word_form", "sentence_ja", "sentence_en"]
    if not entries:
        return pd.DataFrame(columns=cols)
    rows = []
    for ent_seq, ja, en in entries:
        rows.append({
            "ent_seq": ent_seq,
            "source_id": "tatoeba",
            "word_form": "",
            "sentence_ja": ja,
            "sentence_en": en,
        })
    df = pd.DataFrame(rows)
    df["ent_seq"] = df["ent_seq"].astype("int64")
    return df


def _make_kanji_csv(entries, csv_dir):
    """entries: list of (id, character, min_jlpt_level) tuples. Writes kanji.csv."""
    cols = ["id", "character", "stroke_count", "min_grade", "min_jlpt_level",
            "frequency_rank", "svg_file_name", "svg_file_url", "svg_hash"]
    rows = []
    for kid, char, jlpt_level in entries:
        rows.append({
            "id": kid,
            "character": char,
            "stroke_count": 4,
            "min_grade": None,
            "min_jlpt_level": jlpt_level,
            "frequency_rank": 1,
            "svg_file_name": None,
            "svg_file_url": None,
            "svg_hash": None,
        })
    df = pd.DataFrame(rows, columns=cols)
    if not df.empty:
        df["id"] = df["id"].astype("int64")
    csv_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_dir / "kanji.csv", index=False)


def _run_extract(
    tmp_path,
    jmdict_rows,
    jlpt_vocab_entries=None,
    furigana_entries=None,
    example_entries=None,
    kanji_entries=None,
    manual_furigana_path=None,
    manual_localization_path=None,
):
    """Full setup-and-run helper. Returns the result dict."""
    parquet_dir = tmp_path / "parquet"
    parquet_dir.mkdir(parents=True, exist_ok=True)
    csv_dir = tmp_path / "csv"
    warnings_dir = csv_dir / "warnings"

    _make_jmdict_df(jmdict_rows).to_parquet(parquet_dir / "jmdict.parquet", index=False)
    _make_jlpt_vocab_df(jlpt_vocab_entries or []).to_parquet(
        parquet_dir / "jlpt_vocab.parquet", index=False,
    )
    _make_furigana_df(furigana_entries or []).to_parquet(
        parquet_dir / "jmdict_furigana.parquet", index=False,
    )
    _make_examples_df(example_entries or []).to_parquet(
        parquet_dir / "jmdict_examples.parquet", index=False,
    )

    if kanji_entries is not None:
        _make_kanji_csv(kanji_entries, csv_dir)

    # Use a non-existent path by default (no manual overrides)
    if manual_furigana_path is None:
        manual_furigana_path = tmp_path / "manual_furigana.csv"
    if manual_localization_path is None:
        manual_localization_path = tmp_path / "manual_localization.csv"

    return extract_vocabulary(
        parquet_dir, csv_dir, warnings_dir,
        manual_furigana_path=manual_furigana_path,
        manual_localization_path=manual_localization_path,
    )


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------


@pytest.fixture
def basic_jmdict_rows():
    """JMdict with 食べる (ichi1), 大人, すごい."""
    return [
        _jmdict_row(
            1000010,
            k_ele=[_k_ele("食べる", ke_pri=["ichi1", "nf01"])],
            r_ele=[_r_ele("たべる", re_pri=["ichi1", "nf01"])],
            senses=[_sense(
                pos=["v1", "vt"],
                glosses={"eng": ["to eat"], "spa": ["comer"]},
            )],
        ),
        _jmdict_row(
            1000020,
            k_ele=[_k_ele("大人")],
            r_ele=[_r_ele("おとな", re_pri=["ichi1"])],
            senses=[_sense(
                pos=["n"],
                glosses={"eng": ["adult"]},
            )],
        ),
        _jmdict_row(
            1000030,
            k_ele=None,
            r_ele=[_r_ele("すごい", re_pri=["ichi1"])],
            senses=[_sense(
                pos=["adj-i"],
                glosses={"eng": ["amazing", "great"]},
            )],
        ),
    ]


@pytest.fixture
def basic_kanji_entries():
    """Kanji: 食(id=1, N5), 大(id=2, N5), 人(id=3, N5)."""
    return [(1, "食", 5), (2, "大", 5), (3, "人", 5)]


@pytest.fixture
def basic_furigana_entries():
    return [
        ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
        ("大人", "おとな", [{"ruby": "大人", "rt": "おとな"}]),
    ]


# ---------------------------------------------------------------------------
# Step 1: Vocabulary Selection
# ---------------------------------------------------------------------------


class TestVocabularySelection:
    def test_priority_flagged_included(self, tmp_path):
        """Word with ichi1 priority → imported."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            kanji_entries=[(1, "食", 5)],
        )
        assert len(result["vocabulary"]) == 1

    def test_jlpt_word_included(self, tmp_path):
        """No priority, in jlpt_vocab → imported."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("駅")],
                r_ele=[_r_ele("えき")],
                senses=[_sense(pos=["n"], glosses={"eng": ["station"]})],
            )],
            jlpt_vocab_entries=[("駅", "えき", 5)],
            kanji_entries=[(1, "駅", 4)],
        )
        assert len(result["vocabulary"]) == 1

    def test_excluded_when_no_priority_no_jlpt(self, tmp_path):
        """Neither priority nor JLPT → excluded."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("霰")],
                r_ele=[_r_ele("あられ")],
                senses=[_sense(pos=["n"], glosses={"eng": ["hail"]})],
            )],
        )
        assert len(result["vocabulary"]) == 0

    def test_ent_seq_as_id(self, tmp_path):
        """vocabulary.id == ent_seq."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                1594720,
                k_ele=[_k_ele("収集", ke_pri=["ichi1"])],
                r_ele=[_r_ele("しゅうしゅう", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["collection"]})],
            )],
        )
        assert result["vocabulary"].iloc[0]["id"] == 1594720

    def test_word_from_first_keb(self, tmp_path):
        """Uses k_ele[0].keb as word."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("御飯", ke_pri=["ichi1"]), _k_ele("ご飯")],
                r_ele=[_r_ele("ごはん", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["rice"]})],
            )],
        )
        assert result["vocabulary"].iloc[0]["word"] == "御飯"

    def test_kana_only_word(self, tmp_path):
        """Uses r_ele[0].reb when no k_ele."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("すごい", re_pri=["ichi1"])],
                senses=[_sense(pos=["adj-i"], glosses={"eng": ["amazing"]})],
            )],
        )
        assert result["vocabulary"].iloc[0]["word"] == "すごい"


# ---------------------------------------------------------------------------
# JLPT Level
# ---------------------------------------------------------------------------


class TestJlptLevel:
    def test_jlpt_vocab_authoritative(self, tmp_path):
        """jlpt_vocab level takes precedence over kanji-derived."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("駅", ke_pri=["ichi1"])],
                r_ele=[_r_ele("えき", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["station"]})],
            )],
            jlpt_vocab_entries=[("駅", "えき", 5)],
            kanji_entries=[(1, "駅", 4)],
        )
        # JLPT vocab says N5, kanji says N4 → N5 wins
        assert result["vocabulary"].iloc[0]["min_jlpt_level"] == 5

    def test_kanji_derived_fallback(self, tmp_path):
        """MAX(kanji.min_jlpt_level) when not in jlpt_vocab."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("大変", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たいへん", re_pri=["ichi1"])],
                senses=[_sense(pos=["adj-na"], glosses={"eng": ["tough"]})],
            )],
            kanji_entries=[(1, "大", 5), (2, "変", 3)],
        )
        # N5=5 easiest, N1=1 hardest. Word is gated by hardest kanji.
        # 大=N5=5, 変=N3=3 → min_jlpt_level = 3 (gated by N3 kanji).
        assert result["vocabulary"].iloc[0]["min_jlpt_level"] == 3

    def test_null_when_no_source(self, tmp_path):
        """null when neither source has level."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            kanji_entries=[(1, "食", None)],
        )
        assert pd.isna(result["vocabulary"].iloc[0]["min_jlpt_level"])


# ---------------------------------------------------------------------------
# POS Tag Extraction
# ---------------------------------------------------------------------------


class TestPosTagExtraction:
    def test_basic_pos_mapping(self, tmp_path):
        """n+vs → [noun, suru_verb]."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("勉強", ke_pri=["ichi1"])],
                r_ele=[_r_ele("べんきょう", re_pri=["ichi1"])],
                senses=[_sense(pos=["n", "vs"], glosses={"eng": ["study"]})],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["pos_tags"])
        assert "noun" in tags
        assert "suru_verb" in tags

    def test_godan_variants_collapse(self, tmp_path):
        """v5s+vt → [godan_verb, transitive]."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("消す", ke_pri=["ichi1"])],
                r_ele=[_r_ele("けす", re_pri=["ichi1"])],
                senses=[_sense(pos=["v5s", "vt"], glosses={"eng": ["to erase"]})],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["pos_tags"])
        assert tags == ["godan_verb", "transitive"]

    def test_pos_inheritance(self, tmp_path):
        """Sense 2 null pos inherits sense 1."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("勉強", ke_pri=["ichi1"])],
                r_ele=[_r_ele("べんきょう", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["n", "vs"], glosses={"eng": ["study"]}),
                    _sense(pos=[], glosses={"eng": ["diligence"]}),
                ],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["pos_tags"])
        assert "noun" in tags
        assert "suru_verb" in tags
        # No duplicates despite inheritance
        assert len(tags) == len(set(tags))

    def test_new_pos_values(self, tmp_path):
        """All 9 new POS values map correctly."""
        test_cases = [
            ("int", "interjection"),
            ("pn", "pronoun"),
            ("prt", "particle"),
            ("ctr", "counter"),
            ("conj", "conjunction"),
            ("exp", "expression"),
            ("pref", "prefix"),
            ("suf", "suffix"),
            ("adj-no", "no_adjective"),
        ]
        for jmdict_code, expected_tag in test_cases:
            result = _run_extract(
                tmp_path / jmdict_code,
                [_jmdict_row(
                    100,
                    k_ele=None,
                    r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                    senses=[_sense(pos=[jmdict_code], glosses={"eng": ["test"]})],
                )],
            )
            tags = json.loads(result["vocabulary"].iloc[0]["pos_tags"])
            assert expected_tag in tags, f"{jmdict_code} should map to {expected_tag}, got {tags}"

    def test_pos_deduplication(self, tmp_path):
        """Same pos across senses → once."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["v1", "vt"], glosses={"eng": ["to eat"]}),
                    _sense(pos=["v1", "vt"], glosses={"eng": ["to consume"]}),
                ],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["pos_tags"])
        assert len(tags) == len(set(tags))

    def test_unmapped_pos_ignored(self, tmp_path):
        """Unmapped pos code (cop-da) dropped."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("です", re_pri=["ichi1"])],
                senses=[_sense(pos=["cop-da"], glosses={"eng": ["is"]})],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["pos_tags"])
        assert tags == []


# ---------------------------------------------------------------------------
# Misc Tag Extraction
# ---------------------------------------------------------------------------


class TestMiscTagExtraction:
    def test_basic_misc_mapping(self, tmp_path):
        """uk → usually_kana, pol → polite."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("ありがとう", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["int"],
                    misc=["uk", "pol"],
                    glosses={"eng": ["thank you"]},
                )],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["misc_tags"])
        assert "usually_kana" in tags
        assert "polite" in tags

    def test_misc_from_ke_inf(self, tmp_path):
        """ateji on k_ele → ateji."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("出鱈目", ke_inf=["ateji"], ke_pri=["ichi1"])],
                r_ele=[_r_ele("でたらめ", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["nonsense"]})],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["misc_tags"])
        assert "ateji" in tags

    def test_misc_no_inheritance(self, tmp_path):
        """Misc does NOT inherit across senses."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["v1"], misc=["col"], glosses={"eng": ["to eat"]}),
                    _sense(pos=[], misc=[], glosses={"eng": ["to consume"]}),
                ],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["misc_tags"])
        # col appears only once, from sense 1
        assert tags == ["colloquial"]

    def test_multiple_misc_tags(self, tmp_path):
        """[col, abbr] → [colloquial, abbreviation]."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["n"],
                    misc=["col", "abbr"],
                    glosses={"eng": ["test"]},
                )],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["misc_tags"])
        assert "colloquial" in tags
        assert "abbreviation" in tags

    def test_misc_deduplication(self, tmp_path):
        """Same misc across senses → once."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["n"], misc=["col"], glosses={"eng": ["test1"]}),
                    _sense(pos=[], misc=["col"], glosses={"eng": ["test2"]}),
                ],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["misc_tags"])
        assert tags.count("colloquial") == 1

    def test_unmapped_misc_ignored(self, tmp_path):
        """Unmapped misc (chn) → dropped."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["n"],
                    misc=["chn"],
                    glosses={"eng": ["test"]},
                )],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["misc_tags"])
        assert tags == []


# ---------------------------------------------------------------------------
# Field Tag Extraction
# ---------------------------------------------------------------------------


class TestFieldTagExtraction:
    def test_field_passthrough(self, tmp_path):
        """["food", "comp"] stored as-is."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["n"],
                    field=["food", "comp"],
                    glosses={"eng": ["test"]},
                )],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["field_tags"])
        assert tags == ["food", "comp"]

    def test_field_deduplication(self, tmp_path):
        """Same field across senses → once."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["n"], field=["comp"], glosses={"eng": ["test1"]}),
                    _sense(pos=[], field=["comp"], glosses={"eng": ["test2"]}),
                ],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["field_tags"])
        assert tags == ["comp"]

    def test_field_empty_default(self, tmp_path):
        """No field → []."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["test"]})],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["field_tags"])
        assert tags == []


# ---------------------------------------------------------------------------
# Dialect Tag Extraction
# ---------------------------------------------------------------------------


class TestDialectTagExtraction:
    def test_dialect_passthrough(self, tmp_path):
        """["ksb"] stored as-is."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("おおきに", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["int"],
                    dial=["ksb"],
                    glosses={"eng": ["thank you"]},
                )],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["dialect_tags"])
        assert tags == ["ksb"]

    def test_dialect_deduplication(self, tmp_path):
        """Same dialect across senses → once."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("おおきに", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["int"], dial=["ksb"], glosses={"eng": ["thanks"]}),
                    _sense(pos=[], dial=["ksb"], glosses={"eng": ["much obliged"]}),
                ],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["dialect_tags"])
        assert tags == ["ksb"]

    def test_dialect_empty_default(self, tmp_path):
        """No dialect → []."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("テスト", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["test"]})],
            )],
        )
        tags = json.loads(result["vocabulary"].iloc[0]["dialect_tags"])
        assert tags == []


# ---------------------------------------------------------------------------
# Frequency Rank
# ---------------------------------------------------------------------------


class TestFrequencyRank:
    def test_high_priority_lowest_rank(self, tmp_path):
        """ichi1 < spec2 in rank."""
        result = _run_extract(
            tmp_path,
            [
                _jmdict_row(
                    100,
                    k_ele=[_k_ele("食べる", ke_pri=["ichi1", "nf01"])],
                    r_ele=[_r_ele("たべる", re_pri=["ichi1", "nf01"])],
                    senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
                ),
                _jmdict_row(
                    200,
                    k_ele=[_k_ele("珍しい", ke_pri=["spec2"])],
                    r_ele=[_r_ele("めずらしい", re_pri=["spec2"])],
                    senses=[_sense(pos=["adj-i"], glosses={"eng": ["rare"]})],
                ),
            ],
        )
        vdf = result["vocabulary"]
        high = vdf[vdf["id"] == 100].iloc[0]["frequency_rank"]
        mid = vdf[vdf["id"] == 200].iloc[0]["frequency_rank"]
        assert high < mid

    def test_jlpt_only_synthetic(self, tmp_path):
        """JLPT-only words get offset rank."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("駅")],
                r_ele=[_r_ele("えき")],
                senses=[_sense(pos=["n"], glosses={"eng": ["station"]})],
            )],
            jlpt_vocab_entries=[("駅", "えき", 5)],
        )
        rank = result["vocabulary"].iloc[0]["frequency_rank"]
        assert rank >= 100000  # synthetic offset

    def test_headword_nf_used_not_alternate(self, tmp_path):
        """nfXX from primary headword used, alternate spellings ignored."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                # Primary headword 歌 nf02, alternate 唄 nf16
                k_ele=[
                    _k_ele("歌", ke_pri=["ichi1", "news1", "nf02"]),
                    _k_ele("唄", ke_pri=["news1", "nf16"]),
                ],
                r_ele=[_r_ele("うた", re_pri=["ichi1", "news1", "nf02", "nf16"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["song"]})],
            )],
        )
        rank = result["vocabulary"].iloc[0]["frequency_rank"]
        # Headword 歌 has nf02, so rank should be nf02 * 500 = 1000
        assert rank == 1000

    def test_multiple_nf_on_headword_uses_best(self, tmp_path):
        """When headword + reading contribute different nfXX, use lowest (best)."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("飲む", ke_pri=["ichi1", "news2", "nf35"])],
                # Reading collects nf35 from 飲む and nf40 from alternate 呑む
                # but headword collection only takes k_ele[0] + r_ele[0]
                r_ele=[_r_ele("のむ", re_pri=["ichi1", "news2", "nf35"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to drink"]})],
            )],
        )
        rank = result["vocabulary"].iloc[0]["frequency_rank"]
        assert rank == 17500  # nf35 * 500

    def test_frequency_rank_deterministic(self, tmp_path):
        """Frequency rank is identical across multiple runs."""
        jmdict_rows = [_jmdict_row(
            100,
            k_ele=[
                _k_ele("会う", ke_pri=["ichi1", "news2", "nf26"]),
                _k_ele("遭う", ke_pri=["ichi1", "news2", "nf34"]),
            ],
            r_ele=[_r_ele("あう", re_pri=["ichi1", "news2", "nf26"])],
            senses=[_sense(pos=["v1"], glosses={"eng": ["to meet"]})],
        )]
        ranks = []
        for i in range(5):
            run_dir = tmp_path / f"run{i}"
            result = _run_extract(run_dir, jmdict_rows)
            ranks.append(int(result["vocabulary"].iloc[0]["frequency_rank"]))
        # All 5 runs must produce identical rank
        assert len(set(ranks)) == 1, f"Non-deterministic ranks: {ranks}"


# ---------------------------------------------------------------------------
# Furigana (Step 2)
# ---------------------------------------------------------------------------


class TestFurigana:
    def test_per_character(self, tmp_path):
        """食べる → {食|た}べる."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "{食|た}べる"

    def test_jukujikun(self, tmp_path):
        """大人 → {大人|おとな}."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("大人", ke_pri=["ichi1"])],
                r_ele=[_r_ele("おとな", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["adult"]})],
            )],
            furigana_entries=[
                ("大人", "おとな", [{"ruby": "大人", "rt": "おとな"}]),
            ],
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "{大人|おとな}"

    def test_compound_format(self, tmp_path):
        """学生 → {学生|がく|せい} (compound, not per-character brackets)."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("学生", ke_pri=["ichi1"])],
                r_ele=[_r_ele("がくせい", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["student"]})],
            )],
            furigana_entries=[
                ("学生", "がくせい", [
                    {"ruby": "学", "rt": "がく"},
                    {"ruby": "生", "rt": "せい"},
                ]),
            ],
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "{学生|がく|せい}"

    def test_compound_mixed_with_kana(self, tmp_path):
        """お見舞い → お{見舞|み|ま}い."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("お見舞い", ke_pri=["ichi1"])],
                r_ele=[_r_ele("おみまい", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["sympathy call"]})],
            )],
            furigana_entries=[
                ("お見舞い", "おみまい", [
                    {"ruby": "お"},
                    {"ruby": "見", "rt": "み"},
                    {"ruby": "舞", "rt": "ま"},
                    {"ruby": "い"},
                ]),
            ],
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "お{見舞|み|ま}い"

    def test_kana_only_plain_text(self, tmp_path):
        """すごい → すごい (no braces)."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("すごい", re_pri=["ichi1"])],
                senses=[_sense(pos=["adj-i"], glosses={"eng": ["amazing"]})],
            )],
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "すごい"

    def test_fallback_whole_word(self, tmp_path):
        """Missing furigana → {word|reading}."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            # No furigana entries → fallback
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "{食べる|たべる}"

    def test_strip_reproduces_word(self, tmp_path):
        """Validation: stripping notation reproduces word."""
        import re
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
        )
        furigana = result["vocabulary"].iloc[0]["furigana"]
        plain = re.sub(r"\{([^|]+)\|[^}]+\}", r"\1", furigana)
        assert plain == "食べる"

    def test_manual_furigana_override(self, tmp_path):
        """manual_furigana.csv overrides jmdict_furigana and suppresses warning."""
        # Write a manual furigana CSV
        manual_path = tmp_path / "manual_furigana.csv"
        manual_path.write_text("word,reading,furigana\n食べる,たべる,{食|た}べる\n")

        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            # No jmdict furigana entries → would normally trigger fallback warning
            jlpt_vocab_entries=[("食べる", "たべる", 5)],
            kanji_entries=[(1, "食", 5)],
            manual_furigana_path=manual_path,
        )
        assert result["vocabulary"].iloc[0]["furigana"] == "{食|た}べる"

        # No furigana warning should exist
        csv_dir = tmp_path / "csv"
        warnings_path = csv_dir / "warnings" / "ph2_5_warnings.csv"
        if warnings_path.exists():
            w_df = pd.read_csv(warnings_path)
            furigana_warns = w_df[w_df["message"].str.contains("jmdict_furigana")]
            assert len(furigana_warns) == 0


# ---------------------------------------------------------------------------
# Reading Rows (Step 3)
# ---------------------------------------------------------------------------


class TestReadingRows:
    def test_primary_secondary_priority(self, tmp_path):
        """Reading with matching priority → primary, others → secondary."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[
                    _r_ele("たべる", re_pri=["ichi1"]),
                    _r_ele("くべる"),
                ],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
        )
        rdf = result["vocabulary_readings"]
        primary = rdf[rdf["priority"] == "primary"]
        secondary = rdf[rdf["priority"] == "secondary"]
        assert len(primary) >= 1
        assert primary.iloc[0]["reading"] == "たべる"
        assert len(secondary) >= 1

    def test_re_restr_filtering(self, tmp_path):
        """Reading with re_restr not matching headword → skipped."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("御飯", ke_pri=["ichi1"]), _k_ele("ご飯")],
                r_ele=[
                    _r_ele("ごはん", re_pri=["ichi1"]),
                    _r_ele("おはん", re_restr=["ご飯"]),  # restricted to ご飯, not 御飯
                ],
                senses=[_sense(pos=["n"], glosses={"eng": ["rice"]})],
            )],
        )
        rdf = result["vocabulary_readings"]
        readings = set(rdf["reading"])
        assert "ごはん" in readings
        assert "おはん" not in readings  # filtered by re_restr

    def test_re_nokanji(self, tmp_path):
        """Kana-only entry creates reading row."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("すごい", re_nokanji=True, re_pri=["ichi1"])],
                senses=[_sense(pos=["adj-i"], glosses={"eng": ["amazing"]})],
            )],
        )
        rdf = result["vocabulary_readings"]
        assert len(rdf) == 1
        assert rdf.iloc[0]["reading"] == "すごい"
        assert rdf.iloc[0]["priority"] == "primary"


# ---------------------------------------------------------------------------
# I18n Rows (Step 4)
# ---------------------------------------------------------------------------


class TestI18nRows:
    def test_english_glosses(self, tmp_path):
        """English glosses collected from all senses."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("勉強", ke_pri=["ichi1"])],
                r_ele=[_r_ele("べんきょう", re_pri=["ichi1"])],
                senses=[
                    _sense(pos=["n"], glosses={"eng": ["study", "learning"]}),
                    _sense(pos=[], glosses={"eng": ["diligence"]}),
                ],
            )],
        )
        idf = result["vocabulary_i18n"]
        en_row = idf[idf["lang_code"] == "en"].iloc[0]
        meanings = json.loads(en_row["meanings"])
        assert meanings == ["study", "learning", "diligence"]

    def test_multilingual_glosses(self, tmp_path):
        """Glosses for multiple target languages."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["v1"],
                    glosses={"eng": ["to eat"], "spa": ["comer"], "rus": ["есть"]},
                )],
            )],
        )
        idf = result["vocabulary_i18n"]
        langs = set(idf["lang_code"])
        assert "en" in langs
        assert "es" in langs
        assert "ru" in langs

    def test_non_target_lang_excluded(self, tmp_path):
        """French (not in TARGET_LANGS) excluded."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(
                    pos=["v1"],
                    glosses={"eng": ["to eat"], "fre": ["manger"]},
                )],
            )],
        )
        idf = result["vocabulary_i18n"]
        assert "fr" not in set(idf["lang_code"])

    def test_system_mnemonic_placeholder(self, tmp_path):
        """system_mnemonic is empty string (Phase 3 placeholder)."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
        )
        idf = result["vocabulary_i18n"]
        assert (idf["system_mnemonic"] == "").all()
        assert (idf["search_tags"] == "[]").all()


# ---------------------------------------------------------------------------
# Sentences (Step 5)
# ---------------------------------------------------------------------------


class TestSentences:
    def test_sentence_extraction(self, tmp_path):
        """Example sentence linked to vocabulary."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            example_entries=[
                (100, "りんごを食べた。", "I ate an apple."),
            ],
        )
        sdf = result["vocabulary_sentences"]
        assert len(sdf) == 1
        assert sdf.iloc[0]["vocabulary_id"] == 100
        assert sdf.iloc[0]["original_text"] == "りんごを食べた。"

        sidf = result["vocabulary_sentence_i18n"]
        assert len(sidf) == 1
        assert sidf.iloc[0]["lang_code"] == "en"
        assert sidf.iloc[0]["sentence_translated"] == "I ate an apple."

    def test_one_per_word_shortest(self, tmp_path):
        """Multiple examples → shortest selected."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            example_entries=[
                (100, "りんごを食べた。", "I ate an apple."),
                (100, "食べた。", "Ate."),
            ],
        )
        sdf = result["vocabulary_sentences"]
        assert len(sdf) == 1
        assert sdf.iloc[0]["original_text"] == "食べた。"  # shorter


# ---------------------------------------------------------------------------
# Kanji Links (Step 6)
# ---------------------------------------------------------------------------


class TestKanjiLinks:
    def test_linking(self, tmp_path):
        """日本 → positions 0, 1."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("日本", ke_pri=["ichi1"])],
                r_ele=[_r_ele("にほん", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["Japan"]})],
            )],
            kanji_entries=[(1, "日", 5), (2, "本", 5)],
        )
        kdf = result["vocabulary_kanji"]
        assert len(kdf) == 2
        nichi = kdf[kdf["kanji_id"] == 1].iloc[0]
        hon = kdf[kdf["kanji_id"] == 2].iloc[0]
        assert nichi["position"] == 0
        assert hon["position"] == 1

    def test_orphan_kanji_permissive(self, tmp_path):
        """Word with orphan kanji still imported."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("日本", ke_pri=["ichi1"])],
                r_ele=[_r_ele("にほん", re_pri=["ichi1"])],
                senses=[_sense(pos=["n"], glosses={"eng": ["Japan"]})],
            )],
            kanji_entries=[(1, "日", 5)],  # 本 is missing
        )
        assert len(result["vocabulary"]) == 1
        kdf = result["vocabulary_kanji"]
        # Only 日 linked, 本 is orphan
        assert len(kdf) == 1
        assert kdf.iloc[0]["kanji_id"] == 1

    def test_kana_only_no_links(self, tmp_path):
        """Kana-only word → 0 kanji links."""
        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=None,
                r_ele=[_r_ele("すごい", re_pri=["ichi1"])],
                senses=[_sense(pos=["adj-i"], glosses={"eng": ["amazing"]})],
            )],
            kanji_entries=[(1, "日", 5)],
        )
        kdf = result["vocabulary_kanji"]
        assert len(kdf) == 0


# ---------------------------------------------------------------------------
# Warnings
# ---------------------------------------------------------------------------


class TestWarnings:
    def test_orphan_kanji_high_for_jlpt(self, tmp_path):
        """Orphan kanji in JLPT word → high severity."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_jmdict_df([_jmdict_row(
            100,
            k_ele=[_k_ele("日本", ke_pri=["ichi1"])],
            r_ele=[_r_ele("にほん", re_pri=["ichi1"])],
            senses=[_sense(pos=["n"], glosses={"eng": ["Japan"]})],
        )]).to_parquet(parquet_dir / "jmdict.parquet", index=False)
        _make_jlpt_vocab_df([("日本", "にほん", 5)]).to_parquet(
            parquet_dir / "jlpt_vocab.parquet", index=False,
        )
        _make_furigana_df([]).to_parquet(
            parquet_dir / "jmdict_furigana.parquet", index=False,
        )
        _make_examples_df([]).to_parquet(
            parquet_dir / "jmdict_examples.parquet", index=False,
        )
        _make_kanji_csv([(1, "日", 5)], csv_dir)  # 本 missing

        extract_vocabulary(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_5_warnings.csv")
        orphan = w_df[w_df["message"].str.contains("Orphan kanji")]
        assert len(orphan) >= 1
        assert orphan.iloc[0]["severity"] == "high"

    def test_orphan_kanji_low_for_non_jlpt(self, tmp_path):
        """Orphan kanji in non-JLPT word → low severity."""
        parquet_dir = tmp_path / "parquet"
        parquet_dir.mkdir()
        csv_dir = tmp_path / "csv"
        warnings_dir = csv_dir / "warnings"

        _make_jmdict_df([_jmdict_row(
            100,
            k_ele=[_k_ele("日本", ke_pri=["ichi1"])],
            r_ele=[_r_ele("にほん", re_pri=["ichi1"])],
            senses=[_sense(pos=["n"], glosses={"eng": ["Japan"]})],
        )]).to_parquet(parquet_dir / "jmdict.parquet", index=False)
        _make_jlpt_vocab_df([]).to_parquet(
            parquet_dir / "jlpt_vocab.parquet", index=False,
        )
        _make_furigana_df([]).to_parquet(
            parquet_dir / "jmdict_furigana.parquet", index=False,
        )
        _make_examples_df([]).to_parquet(
            parquet_dir / "jmdict_examples.parquet", index=False,
        )
        # No kanji at all → both 日 and 本 are orphans, but no JLPT → low
        _make_kanji_csv([], csv_dir)

        extract_vocabulary(parquet_dir, csv_dir, warnings_dir)

        w_df = pd.read_csv(warnings_dir / "ph2_5_warnings.csv")
        orphan = w_df[w_df["message"].str.contains("Orphan kanji")]
        assert len(orphan) >= 1
        assert (orphan["severity"] == "low").all()

    def test_missing_furigana_high_for_jlpt(self, tmp_path):
        """Missing furigana for JLPT word → high warning."""
        _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            jlpt_vocab_entries=[("食べる", "たべる", 5)],
            # No furigana entries → fallback
            kanji_entries=[(1, "食", 5)],
        )

        csv_dir = tmp_path / "csv"
        w_df = pd.read_csv(csv_dir / "warnings" / "ph2_5_warnings.csv")
        missing = w_df[w_df["message"].str.contains("jmdict_furigana")]
        assert len(missing) >= 1
        assert missing.iloc[0]["severity"] == "high"

    def test_missing_furigana_low_for_non_jlpt(self, tmp_path):
        """Missing furigana for non-JLPT word → low warning."""
        _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            # No JLPT, no furigana, kanji has no JLPT level
            kanji_entries=[(1, "食", None)],
        )

        csv_dir = tmp_path / "csv"
        w_df = pd.read_csv(csv_dir / "warnings" / "ph2_5_warnings.csv")
        missing = w_df[w_df["message"].str.contains("jmdict_furigana")]
        assert len(missing) >= 1
        assert missing.iloc[0]["severity"] == "low"

    def test_missing_translation_high_for_jlpt(self, tmp_path):
        """JLPT word missing non-English translation → high warning."""
        _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
                # No Spanish or Russian glosses
            )],
            jlpt_vocab_entries=[("食べる", "たべる", 5)],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
            kanji_entries=[(1, "食", 5)],
        )

        csv_dir = tmp_path / "csv"
        w_df = pd.read_csv(csv_dir / "warnings" / "ph2_5_warnings.csv")
        missing_es = w_df[w_df["message"].str.contains("missing es")]
        missing_ru = w_df[w_df["message"].str.contains("missing ru")]
        assert len(missing_es) == 1
        assert missing_es.iloc[0]["severity"] == "high"
        assert len(missing_ru) == 1
        assert missing_ru.iloc[0]["severity"] == "high"

    def test_no_translation_warning_for_non_jlpt(self, tmp_path):
        """Non-JLPT word missing translations → no warning."""
        _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
            kanji_entries=[(1, "食", None)],
        )

        csv_dir = tmp_path / "csv"
        warnings_path = csv_dir / "warnings" / "ph2_5_warnings.csv"
        if warnings_path.exists():
            w_df = pd.read_csv(warnings_path)
            translation_warns = w_df[w_df["message"].str.contains("translation")]
            assert len(translation_warns) == 0


# ---------------------------------------------------------------------------
# Integration
# ---------------------------------------------------------------------------


class TestIntegration:
    def test_full_pipeline(
        self, basic_jmdict_rows, basic_kanji_entries, basic_furigana_entries, tmp_path,
    ):
        """All 6 CSVs written, contents verified."""
        result = _run_extract(
            tmp_path,
            basic_jmdict_rows,
            furigana_entries=basic_furigana_entries,
            kanji_entries=basic_kanji_entries,
            example_entries=[
                (1000010, "りんごを食べた。", "I ate an apple."),
                (1000020, "大人になった。", "I became an adult."),
            ],
        )

        csv_dir = tmp_path / "csv"

        # All CSVs exist
        for name in [
            "vocabulary.csv", "vocabulary_readings.csv", "vocabulary_i18n.csv",
            "vocabulary_kanji.csv", "vocabulary_sentences.csv",
            "vocabulary_sentence_i18n.csv",
        ]:
            assert (csv_dir / name).exists(), f"{name} not found"

        # Verify contents
        vdf = result["vocabulary"]
        assert len(vdf) == 3  # 食べる, 大人, すごい

        rdf = result["vocabulary_readings"]
        assert len(rdf) >= 3  # at least one per word

        idf = result["vocabulary_i18n"]
        assert len(idf) >= 3  # at least English for each

        kdf = result["vocabulary_kanji"]
        assert len(kdf) >= 2  # 食, 大+人

        sdf = result["vocabulary_sentences"]
        assert len(sdf) == 2  # two words have examples

        sidf = result["vocabulary_sentence_i18n"]
        assert len(sidf) == 2

        # Unique word
        assert vdf["word"].is_unique

    def test_deterministic_output(
        self, basic_jmdict_rows, basic_kanji_entries, basic_furigana_entries, tmp_path,
    ):
        """Two runs produce identical CSVs."""
        for run in ("run1", "run2"):
            run_dir = tmp_path / run
            _run_extract(
                run_dir,
                basic_jmdict_rows,
                furigana_entries=basic_furigana_entries,
                kanji_entries=basic_kanji_entries,
            )

        for name in [
            "vocabulary.csv", "vocabulary_readings.csv", "vocabulary_i18n.csv",
            "vocabulary_kanji.csv",
        ]:
            df1 = pd.read_csv(tmp_path / "run1" / "csv" / name)
            df2 = pd.read_csv(tmp_path / "run2" / "csv" / name)
            pd.testing.assert_frame_equal(df1, df2)


# ---------------------------------------------------------------------------
# Manual Localization Override (Step 4)
# ---------------------------------------------------------------------------


class TestManualLocalization:
    def test_manual_localization_override(self, tmp_path):
        """Non-empty meanings in manual CSV creates i18n row, suppresses warning."""
        manual_path = tmp_path / "manual_localization.csv"
        manual_path.write_text(
            'word,lang_code,meanings\n食べる,es,"[""comer""]"\n食べる,ru,"[""есть""]"\n'
        )

        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            jlpt_vocab_entries=[("食べる", "たべる", 5)],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
            kanji_entries=[(1, "食", 5)],
            manual_localization_path=manual_path,
        )
        idf = result["vocabulary_i18n"]
        es_rows = idf[idf["lang_code"] == "es"]
        assert len(es_rows) == 1
        assert json.loads(es_rows.iloc[0]["meanings"]) == ["comer"]

        ru_rows = idf[idf["lang_code"] == "ru"]
        assert len(ru_rows) == 1
        assert json.loads(ru_rows.iloc[0]["meanings"]) == ["есть"]

        # No missing translation warnings should exist
        csv_dir = tmp_path / "csv"
        warnings_path = csv_dir / "warnings" / "ph2_5_warnings.csv"
        if warnings_path.exists():
            w_df = pd.read_csv(warnings_path)
            trans_warns = w_df[w_df["message"].str.contains("missing .+ translation", regex=True)]
            assert len(trans_warns) == 0

    def test_jmdict_priority_over_manual(self, tmp_path):
        """JMdict glosses used when available, manual ignored."""
        manual_path = tmp_path / "manual_localization.csv"
        manual_path.write_text(
            'word,lang_code,meanings\n食べる,es,"[""manual_override""]"\n'
        )

        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"], "spa": ["comer"]})],
            )],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
            manual_localization_path=manual_path,
        )
        idf = result["vocabulary_i18n"]
        es_rows = idf[idf["lang_code"] == "es"]
        assert len(es_rows) == 1
        # JMdict "comer" wins over manual "manual_override"
        assert json.loads(es_rows.iloc[0]["meanings"]) == ["comer"]

    def test_empty_manual_meanings_no_effect(self, tmp_path):
        """Empty meanings in manual CSV = no i18n row, warning still fires."""
        manual_path = tmp_path / "manual_localization.csv"
        manual_path.write_text("word,lang_code,meanings\n食べる,es,\n食べる,ru,\n")

        result = _run_extract(
            tmp_path,
            [_jmdict_row(
                100,
                k_ele=[_k_ele("食べる", ke_pri=["ichi1"])],
                r_ele=[_r_ele("たべる", re_pri=["ichi1"])],
                senses=[_sense(pos=["v1"], glosses={"eng": ["to eat"]})],
            )],
            jlpt_vocab_entries=[("食べる", "たべる", 5)],
            furigana_entries=[
                ("食べる", "たべる", [{"ruby": "食", "rt": "た"}, {"ruby": "べる"}]),
            ],
            kanji_entries=[(1, "食", 5)],
            manual_localization_path=manual_path,
        )
        idf = result["vocabulary_i18n"]
        # Only English row, no es/ru
        assert set(idf["lang_code"]) == {"en"}

        # Missing translation warnings should still fire
        csv_dir = tmp_path / "csv"
        w_df = pd.read_csv(csv_dir / "warnings" / "ph2_5_warnings.csv")
        trans_warns = w_df[w_df["message"].str.contains("missing .+ translation", regex=True)]
        assert len(trans_warns) == 2  # es + ru
