emacs ?= emacs
ruby ?= ruby
wget ?= wget

index= ../index.html
dl= ../build/provision.sh

.PHONY: clean distclean
all:

html:
	./$(dl)

clean:
	$(RM) *~

distclean: clean
	$(RM) *.json
