###################################################
#  Makefile: General library and executable maker 
#  build evgen library and examples
###################################################
#
# allow a hook for forcing use of the absoft compiler on linux
#
COMPILER = default
ABSOFT = 

# platform specific information
include $(MCFAST_DIR)/arch_mcfast

#-----------------------------
#  Useful Definitions
#-----------------------------

INC = $(EVGEN_DIR)/inc
SRCDIR = $(EVGEN_DIR)/src
BLDDIR = $(MCFAST_DIR)/build/$(UNAME)/evgen/src
FINC = -I$(INC) -I$(STDHEP_DIR)/src/inc -I$(LUND_DIR)/src/inc \
       -I$(HERWIG_DIR)/src -I$(QQ_DIR)/src/inc

CERNLIB = $(CRNLIB)/libpacklib.a 
STDLIB = $(STDHEP_DIR)/lib/libstdhep.a
ISALIB = $(ISAJET_DIR)/isajet.a
PARSE  = $(MCFLIB)/libcmd_parse.a
GENERAL = $(MCFLIB)/libgeneral.a
MCFIO = $(MCFLIB)/libFmcfio.a

MAIN = $(BLDDIR)/main_args.o
EVGEN_SRC = main_fortran bookhistos \
             pyt_command pyt_user_init pyt_get_seed pyt_save_seed \
             hwg_command hwg_open hwg_user_init hwg_user_reset \
             usr_filter usr_filter_preqq  usr_filter_postqq \
             usr_end_event usr_end_job
EVGEN_OBJS   = $(addprefix $(BLDDIR)/,$(addsuffix .o,$(EVGEN_SRC)))
SLIST = amass_isa.o herwig_exam.o isajet_exam.o pythia_exam.o \
        main_args.o read_xdr.o 
SOBJS = $(addprefix $(BLDDIR)/,$(SLIST))

#-----------------
#  Action section 
#-----------------

production: $(MCFLIB)/libevgen.a libobjs $(MCFBIN)/pythia_exam \
            $(MCFBIN)/isajet_exam $(MCFBIN)/herwig_exam $(MCFBIN)/read_xdr

$(MCFLIB)/libevgen.a:	$(EVGEN_OBJS)
	$(AR) -urs $(MCFLIB)/libevgen.a $(EVGEN_OBJS)

#-----------------
#  Executables 
#-----------------

$(MCFBIN)/pythia_exam:  $(BLDDIR)/pythia_exam.o $(MCFLIB)/libevgen.a $(MAIN)
	$(F77) $(FFLAGS) -o $(MCFBIN)/pythia_exam $(FMAIN) $(MAIN) \
		$(BLDDIR)/pythia_exam.o \
		$(MCFLIB)/libevgen.a \
		$(LULIB)/pydata.o $(LULIB)/pdfdum.o $(QQ_DIR)/lib/ranp.o \
		$(STDLIB) $(MCFIO) \
		$(QQLIB) $(TYPSCN) \
		$(LULIB)/liblund.a \
		$(PARSE) $(GENERAL) \
		$(CRNLIB)/libmathlib.a $(CRNLIB)/libpacklib.a $(LIBS)

$(MCFBIN)/isajet_exam:  $(BLDDIR)/isajet_exam.o $(BLDDIR)/amass_isa.o \
                  $(MCFLIB)/libevgen.a $(MAIN)
	$(F77) $(FFLAGS) -o $(MCFBIN)/isajet_exam $(FMAIN) $(MAIN) \
		$(BLDDIR)/isajet_exam.o \
		$(BLDDIR)/amass_isa.o $(QQ_DIR)/lib/ranp.o \
		$(MCFLIB)/libevgen.a \
		$(GENERAL) $(STDLIB) $(MCFIO) \
		$(ISALIB) \
		$(QQLIB) $(TYPSCN) \
		$(CERNLIB) $(LIBS)

$(MCFBIN)/herwig_exam:  $(BLDDIR)/herwig_exam.o $(MCFLIB)/libevgen.a $(MAIN)
	$(F77) $(FFLAGS) -o $(MCFBIN)/herwig_exam $(FMAIN) $(MAIN) \
		$(BLDDIR)/herwig_exam.o \
                $(MCFLIB)/libevgen.a \
		$(HERWIG_DIR)/lib/hwudat.o $(QQ_DIR)/lib/ranp.o \
		$(PARSE) $(STDLIB) $(MCFIO) \
		$(GENERAL) $(QQLIB) $(TYPSCN) \
		-L$(HERWIG_DIR)/lib -lherwig $(QQLIB) -lherdum \
		$(CRNLIB)/libmathlib.a $(CRNLIB)/libpacklib.a $(LIBS)

$(MCFBIN)/read_xdr:  $(BLDDIR)/read_xdr.o 
	$(F77) $(FFLAGS) -o $(MCFBIN)/read_xdr $(BLDDIR)/read_xdr.o \
                $(MCFLIB)/libevgen.a \
		$(STDLIB) $(MCFIO) \
		$(CERNLIB) $(LIBS)

libobjs: $(SOBJS)
	cp $? $(MCFLIB)/.

cleanobjs:
	make clean


clean:
#	rm -f $(MCFLIB)/libevgen.a
	rm -f $(patsubst $(BLDDIR)/%,$(MCFLIB)/%,$(SOBJS))
	rm -f $(MCFBIN)/pythia_exam
	rm -f $(MCFBIN)/isajet_exam
	rm -f $(MCFBIN)/herwig_exam
	rm -f $(MCFBIN)/read_xdr
	rm -f $(BLDDIR)/*.o
	rm -f $(BLDDIR)/*.f

glib:
	@echo "libraries are debug by default"

depend:
	@echo "no depend option for evgen"

#--------------------------

$(BLDDIR)/%.o: $(SRCDIR)/%.F
	$(FC) $(ABSOFT) -f77 "$(FFLAGS)" -cpp "$(FINC)" -wdir "$(BLDDIR)" -sdir "$(SRCDIR)" $*.F

$(BLDDIR)/%.o:	$(SRCDIR)/%.c
	$(CCB) -nodebug -cpp "$(CFLAGS) $(FINC)" -outfile "$@" $<

#------------------------
#  Suffix rules
#------------------------

.PHONY: clean cleanobjs glib depend

.SUFFIXES :
.SUFFIXES :  .o .c .F

