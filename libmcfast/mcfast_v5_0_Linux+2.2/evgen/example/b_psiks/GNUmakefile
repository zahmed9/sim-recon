###################################################
#  Makefile: General library and executable maker 
#
#  build evgen user examples
#  this is the user example - it assumes all libraries have been built
#
#  Important:  use gmake
#
###################################################

# platform specific information
include $(MCFAST_DIR)/arch_mcfast

#-----------------------------
#  Useful Definitions
#----------------------------

# User files.
PYTHIA_USER_OBJS = usr_filter_preqq.o usr_end_event.o bookhistos.o
ISAJET_USER_OBJS = usr_filter_preqq.o usr_end_event.o bookhistos.o
HERWIG_USER_OBJS = usr_filter_preqq.o usr_end_event.o bookhistos.o


# Include path.  
# Note that pythia and isajet do not use fortran or cpp includes.
# There is no harm having the herwig include area in the path for
# for compilation of pythia and isajet code.
FINC = -I$(EVGEN_DIR)/inc \
	 -I$(STDHEP_DIR)/src/inc -I$(LUND_DIR)/src/inc \
	 -I$(QQ_DIR)/src/inc -I$(HERWIG_DIR)/src


# Evgen main program.
MAIN = $(GLIB)/main_args.o

# Directory which contains EVGEN .a and .o files.
ifdef MCFREL
  OBJ = $(MCFAST_DIR)/lib.$(UNAME)
  MCFIO = -L$(MCFAST_DIR)/lib.$(UNAME) -lFmcfio
else
  OBJ = $(EVGEN_DIR)/lib.$(UNAME)
  MCFIO = $(MCFIO_DIR)/lib.$(UNAME)/libFmcfio.a
endif

CERNLIB = -L$(CRNLIB) -lmathlib -lpacklib 

#-----------------
#  Action section 
#-----------------

all: pythia_exam isajet_exam herwig_exam

clean:
	rm -f pythia_exam pythia_exam.map
	rm -f isajet_exam isajet_exam.map
	rm -f herwig_exam herwig_exam.map
	rm -f *.f
	rm -f *.o

test:
	@echo OBJ is $(OBJ)

#-----------------
#  Executables 
#-----------------

pythia_exam:    $(PYTHIA_USER_OBJS)
	$(F77)  $(FMAIN) $(FFLAGS) -o pythia_exam \
		$(MAIN) $(OBJ)/pythia_exam.o \
	        $(PYTHIA_USER_OBJS) \
		$(LULIB)/pydata.o $(LULIB)/pdfdum.o $(QQ_DIR)/lib/ranp.o \
		-L$(OBJ) -levgen \
                -L$(STDHEP_DIR)/lib -lstdhep  $(MCFIO) \
		$(QQLIB) $(TYPSCN) \
		$(LULIB)/liblund.a \
                -L$(GLIB) -lcmd_parse -lgeneral \
		$(CERNLIB) $(LIBS) $(MAP)


isajet_exam:    $(ISAJET_USER_OBJS)
	$(F77) $(FMAIN) $(FFLAGS) -o isajet_exam \
		$(MAIN) $(OBJ)/isajet_exam.o \
		$(ISAJET_USER_OBJS) \
		$(OBJ)/amass_isa.o $(QQ_DIR)/lib/ranp.o \
                -L$(OBJ) -levgen \
                -L$(GLIB) -lgeneral \
                -L$(STDHEP_DIR)/lib -lstdhep  \
		$(ISAJET_DIR)/isajet.a \
		$(QQLIB) $(TYPSCN) $(MCFIO) \
		$(CERNLIB) $(LIBS) $(MAP)

herwig_exam:    $(HERWIG_USER_OBJS)
	$(F77) $(FMAIN) $(FFLAGS) -o herwig_exam \
                $(MAIN) $(OBJ)/herwig_exam.o \
		$(HERWIG_USER_OBJS) \
		-L$(OBJ) -levgen \
		$(HERWIG_DIR)/lib/hwudat.o $(QQ_DIR)/lib/ranp.o \
		-L$(STDHEP_DIR)/lib -lstdhep  $(MCFIO) \
                -L$(GLIB) -lcmd_parse -lgeneral \
		-L$(HERWIG_DIR)/lib -lherwig  \
                $(QQLIB) $(TYPSCN) -lherdum \
		$(CERNLIB) $(LIBS) $(MAP)


# Tell gmake to forget about the all implicit rules and then
# define only the ones that we want - all this is to get rid of
# the .f rule, which bites us because f77mcf creates .f files in
# .F.o step ( not the .f.o step ) and these subsequently confuse gmake.
# A corollary is that one cannot make .f files with this GNUmakefile.
.SUFFIXES :
.SUFFIXES :  .o .c .F

.F.o:
	$(FC) $(ABSOFT) -f77 "$(FFLAGS)" -cpp "$(FINC)" $<

#
# $Id$
#
# $Log$
# Revision 1.1  2000/06/19 19:58:31  eugenio
# Initial revision
#
# Revision 1.19  2000/02/08 16:45:24  garren
# first pass at merging archtecture files
#
# Revision 1.18  1999/11/08  21:11:01  garren
# remove map files at cleanup time
#
# Revision 1.17  1999/10/21  14:55:51  garren
# don't need -lutil
#
# Revision 1.16  1999/01/31  00:43:33  garren
# use common architecture include file
#
# Revision 1.15  1999/01/13  22:23:38  garren
# fix example makefiles for UNAME=IRIX under IRIX+6
#
# Revision 1.14  1998/12/01  16:25:56  procario
# Get rid of -g77 flag. No longer used
#
# Revision 1.13  1998/11/20  22:48:33  procario
# Linux port Added Linux section makefiles Small Linux modes to code.
#
# Revision 1.12  1998/07/09  22:21:32  garren
# for new generators
#
# Revision 1.11  1998/06/25  15:48:52  bphyslib
# add all necessary changes from v3_3
#
# Revision 1.8.2.7  1998/05/21  21:05:09  garren
# fix IRIX+6 options
#
# Revision 1.8.2.6  1998/05/19  01:07:00  kutschke
# New link libraries for updated example.
#
# Revision 1.8.2.5  1998/05/19  00:52:31  kutschke
# Updates for aix and suffix rules.
#
#
