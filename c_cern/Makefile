
include $(BUILDS)/cms/Rules.make

DATA_CSRCS = clas_cern.c clas_hplot.c

DATA_COBJS= $(patsubst %.c,$(OBJDIR)/%.o,$(DATA_CSRCS))

libs: libc_cern$(ADD_DEBUG).a

lib: libc_cern$(ADD_DEBUG).a

libc_cern$(ADD_DEBUG).a: $(DATA_COBJS)
	ar rv $@ $^
	$(VDIR) $(HALLDLIB)
	mv $@ $(HALLDLIB)/$@

clean:
	rm -r $(OBJDIR)
	rm $(libs)



env:
	@echo CVSROOT $(CVSROOT)
	@echo INCLUDE $(INCLUDE)
	@echo DATA_CSRCS $(DATA_CSRCS)
	@echo DATA_COBJS $(DATA_COBJS)
