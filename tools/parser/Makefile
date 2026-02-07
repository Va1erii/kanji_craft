VENV      := .venv
PYTHON    := $(VENV)/bin/python
PIP       := $(VENV)/bin/pip
ACTIVATE  := . $(VENV)/bin/activate

.PHONY: setup download download-force version clean

## Create virtual environment and install dependencies
setup: $(VENV)/bin/activate

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@touch $(VENV)/bin/activate

## Download latest KanjiVG release (skips if already up to date)
download: setup
	$(PYTHON) download_kanjivg.py

## Force re-download even if already up to date
download-force: setup
	$(PYTHON) download_kanjivg.py --force

## Print installed KanjiVG version
version: setup
	$(PYTHON) download_kanjivg.py --version

## Remove virtual environment
clean:
	rm -rf $(VENV)
