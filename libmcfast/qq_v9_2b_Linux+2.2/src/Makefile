# CLEO libraries
MAKE=gmake
MAKEFILE=Makefile

PROJNAME = noncleo

FROMCVS = cleoks korb qqlib 

SUBNAMES= $(FROMCVS)

PWD=$(shell pwd)

#.PHONY:$(SUBNAMES)

temp : fromcvs

default : mklib production

mklib production depend debug ::
	$(MAKE) -f $(MAKEFILE) $(SUBNAMES) "TARGET=$@"

rewrite_boot::
	for file in $(FROMCVS); do (cd $$file;mv boot boot~;sed "s#pwd#( [ -x /usr/local/bin/awd ] \&\& awd ) || pwd#" boot~ > boot;cvs ci -m "Use awd if available" boot;chmod +x boot) ; done

fromcvs :: $(SUBNAMES)

all ::
	$(MAKE) -f $(MAKEFILE) depend production debug

$(SUBNAMES) ::
	@echo ""; echo "***** $@"; echo ""
	-test -d Build/$(shell uname)/$@ || mkdir -p Build/$(shell uname)/$@
	-test -d Log/$(shell uname) || mkdir -p Log/$(shell uname)
	-test -d Log/$(shell uname)/OLD || mkdir -p Log/$(shell uname)/OLD
	-mv -f Log/$(shell uname)/$@.log* Log/$(shell uname)/OLD
	-(cd Build/$(shell uname)/$@; pwd; rm -f config.*; $(PWD)/$@/boot -f; $(MAKE) $(TARGET)) > Log/$(shell uname)/$@.log_$$$$ 2>&1
