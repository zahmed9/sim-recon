
include Rules.make

DATA_CSRCS = data.c tapeIO.c tapeIoctl.c dataIO.c crc.c

DATA_COBJS= $(patsubst %.c,$(OBJDIR)/%.o,$(DATA_CSRCS))

libs: libdata$(ADD_DEBUG).a

libdata$(ADD_DEBUG).a: $(DATA_COBJS)
	ar rv $@ $^
	mv $@ $(HALLDLIB)/$@

clean:
	rm -r $(OBJDIR)
	rm $(libs)



env:
	@echo CVSROOT $(CVSROOT)
	@echo INCLUDE $(INCLUDE)
	@echo DATA_CSRCS $(DATA_CSRCS)
	@echo DATA_COBJS $(DATA_COBJS)
