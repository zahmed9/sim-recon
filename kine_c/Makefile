
include $(BUILDS)/cms/Rules.make

DATA_CSRCS = gottjack.c lorentz.c vector3.c vector4.c

DATA_COBJS= $(patsubst %.c,$(OBJDIR)/%.o,$(DATA_CSRCS))

libs: libkine_c$(ADD_DEBUG).a

lib: libkine_c$(ADD_DEBUG).a

libkine_c$(ADD_DEBUG).a: $(DATA_COBJS)
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
