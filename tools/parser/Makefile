VENV      := .venv
PYTHON    := $(VENV)/bin/python
PIP       := $(VENV)/bin/pip
ACTIVATE  := . $(VENV)/bin/activate

.PHONY: setup clean

## Create virtual environment and install dependencies
setup: $(VENV)/bin/activate

$(VENV)/bin/activate: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@touch $(VENV)/bin/activate

## Remove virtual environment
clean:
	rm -rf $(VENV)
