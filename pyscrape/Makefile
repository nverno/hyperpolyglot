emacs ?= emacs
python ?= python
wget ?= wget

ifeq ($(OS), Windows_NT)
  python="C:/Program Files/Anaconda/python.exe"
endif

json= hyperglot-data.json

.PHONY: clean $(json)

scrape: $(json)
	$(emacs) -batch -l build.el -f build-el

$(json):
	$(python) scrape.py

clean:
	$(RM) *~

distclean: clean
	$(RM) *.json
