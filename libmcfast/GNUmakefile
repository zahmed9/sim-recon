#
# LIBMCFAST master makefile -- builds mcfast libs and associated libraries
#
MAKE=gmake
MAKEFILE=GNUmakefile



all ::
	$(MAKE) -f $(MAKEFILE) dist-clean
	$(MAKE) -f $(MAKEFILE) qq stdhep mcfast



qq ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $(QQ_DIR)/src; pwd; $(MAKE)  all)

stdhep ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $(STDHEP_DIR)/src; pwd; $(MAKE)  stdhep)

mcfast ::
	@echo ""; echo "Building $@"; echo ""
	-(cd $(MCFAST_DIR) ; pwd; $(MAKE)  all)






dist-clean ::
	@echo cleaning up distribution before building
	-(cd $(QQ_DIR)/src; rm -rf Build ) 
	-(cd $(STDHEP_DIR)/src; $(MAKE) clean) 
	-(cd $(MCFAST_DIR); $(MAKE) dist-clean) 





