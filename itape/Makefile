
include $(BUILDS)/cms/Rules.make

DATA_CSRCS = data.c tapeIO.c tapeIoctl.c dataIO.c crc.c endian.c

DATA_COBJS= $(patsubst %.c,$(OBJDIR)/%.o,$(DATA_CSRCS))

libs: libdata$(ADD_DEBUG).a

lib: libdata$(ADD_DEBUG).a

libdata$(ADD_DEBUG).a: $(DATA_COBJS)
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
