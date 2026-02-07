VENV      := .venv
PYTHON    := $(VENV)/bin/python
PIP       := $(VENV)/bin/pip
ACTIVATE  := . $(VENV)/bin/activate

.PHONY: setup download-all \
        download-kanjivg download-kanjivg-force version-kanjivg \
        download-kanjidic2 download-kanjidic2-force version-kanjidic2 \
        clean

## Create virtual environment and install dependencies
setup: $(VENV)/bin/activate

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@touch $(VENV)/bin/activate

## Download all data sources
download-all: download-kanjivg download-kanjidic2

# --- KanjiVG ---

## Download latest KanjiVG release (skips if already up to date)
download-kanjivg: setup
	$(PYTHON) download_kanjivg.py

## Force re-download KanjiVG even if already up to date
download-kanjivg-force: setup
	$(PYTHON) download_kanjivg.py --force

## Print installed KanjiVG version
version-kanjivg: setup
	$(PYTHON) download_kanjivg.py --version

# --- KANJIDIC2 ---

## Download latest KANJIDIC2 (skips if already up to date)
download-kanjidic2: setup
	$(PYTHON) download_kanjidic2.py

## Force re-download KANJIDIC2 even if already up to date
download-kanjidic2-force: setup
	$(PYTHON) download_kanjidic2.py --force

## Print installed KANJIDIC2 version
version-kanjidic2: setup
	$(PYTHON) download_kanjidic2.py --version

## Remove virtual environment
clean:
	rm -rf $(VENV)
