###################################################
#  Makefile: General library and executable maker 
###################################################

TOP = ../..
INC1 = $(TOP)/inc/event
INC2 = $(TOP)/inc/geom
INC4 = $(STDHEP_DIR)/src
LIB = $(TOP)/lib.IRIX

LIST_O = \
allow_id.o \
gnr_generate_event.o \
gnr_init.o \
gnr_readparam.o \
main_fortran.o \
mcp_analyze.o \
mcp_checktypein.o \
mcp_elec_fill.o \
mcp_gamma_fill.o \
mcp_gen_fill.o \
mcp_help.o \
mcp_init.o \
mcp_ks_fill.o \
mcp_lambda_fill.o \
mcp_muon_fill.o \
mcp_nextevent.o \
mcp_nextfile.o \
mcp_pi0_fill.o \
mcp_read_cmd.o \
mcp_readevent.o \
mcp_set_exit.o \
mcp_set_readtype.o \
mcp_stable_fill.o \
mcp_status.o \
mcp_summary.o \
mcp_time_init.o \
mcp_time_set.o \
mcp_track_fill.o \
mcp_version_write.o \
vtx_add.o \
vtx_fill.o \
vtx_gen.o

FLAG  = -g
FFLAG = -g -I$(INC1) -I$(INC2) -I$(INC4)

.SUFFIXES : .c .F .f .o

#-----------------
#  Action section 
#-----------------

all:	$(LIB)/main_args.o $(LIB)/libmcfast.a

$(LIB)/main_args.o:
	cc -c $(CFLAG) main_args.c;
	mv main_args.o $(LIB)

$(LIB)/libmcfast.a: $(LIST_O)
	ar r libmcfast.a $(LIST_O);
	mv libmcfast.a $(LIB);
	rm -f *.o

.F.o:
	f77 -c $(FFLAG) $?

.f.o:
	f77 -c $(FFLAG) $?

.c.o:
	cc -c $(CFLAG) $?

