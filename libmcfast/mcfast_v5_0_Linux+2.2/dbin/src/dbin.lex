
/*   (leave the space! lex insists on it!)
 
Version 1.1 : P. Lebrun, Fermilab, July 1996

- Add a parameter (F77) or define (C) statement to the .inc and .h files
  so that we can check at mcfastRead run time if when we start overflowing 
  the arrays. 
- Enforce  the grouping rule upon reading a DBIN data file (F77 only), 
  if the varname changes (refering to the template name, or the name 
  of the data structure, then the index refering to the array of D.S. 
  better be one, to make sure we start filling at the appropriate location.
Version 1.2 : Lebrun, Fermilab, June 1997
-  Add a warining if the 'database' statement is missing in the beginning of 
   the file, to avoid such an obvious crash button. Since I am not sure 
   where that check ought to go, this fix is probably not 100% reliable.
- Fix the extraneous MAXNUM, in case of nested structure (It was my mistake!)
- Fix a small XDR bug in the filter for integer arrays   

------------
   T. Wenaus 7/95

ToDo (.=done)
----
- $$$ f90 option on Fortran side
- $$$ pointers
- $$$ self-describing XDR I/O
. new index behaviour; no prefix if '-' leads.
. update structures
. dummy word following n_obj_* in common to protect against misaligned
  commons
. VARIABLE keyword following array declaration to stipulate that the
  most recent integer should be interpreted as the useful dimension
  of the array for XDR read/write
. output of nested substructures in internal mode to XDR file implemented
. eliminate C++ entirely from dbin and auxiliary code (eg. //, extern "C")
. unify the Fortran and C data spaces
. switch from use of CLHEP Strings to char arrays. No longer any C++
  dependence in dbin. Can be used with C or C++.
. ,->* in XDR filter code on dimension string; will correctly handle multi-dim
  arrays
. write only the used number of array objects to XDR. VARIABLE keyword.
. ivar eliminated; was causing fp overflows. rvar now used to load integers.
- $$$ 'will generate file' report in dbin startup
. access to version string
- $$$ alternate (faster?) xdr encoding: copy to contiguous arrays
. undimensioned instantiations
. mgr code needs to be produced in close_makes since one routine for each
  declared structure should be generated.
. handle F<-> moving routines for case of multi-dimensional arrays. [issue warning.]
. XDR handling: have to handle moving of data between C data structures and
  Fortran data structures. Do this from the MGR routine, which performs the
  move before/after the XDR activity depending on encode/decode state.
  Need new routines, includes generated for XDR:
  . include file defining mapping of Fortran struct for C access
  . 'move from C structs to Fortran' and vice versa.
  . new units: fcmap -> nameFstruct.h
               fftoc -> nameFtoC.cc
               fctof -> nameCtoF.cc
. add comment to GUI structure. Protect GUI, XDR code with cpp flags.
. reimplement DOUBLE
. xdr mgr code for multiple instantiations. Avoid code for
  non-existent instantiations.
- verbatim directive for internal-mode (& other) include files
- $$$ bounds checking for fixed-size templates
- single-pass scheme for include files
- command mode:
  - $$$ make ndim available to the user routine
  - $$$ make command name available to the user routine (for single-routine
    handling of multiple commands)
- 2nd arg on dbin command line: dir to put generated sources in
. dynamic instantiation of templates; declared array size
. tools on Fortran and C++ sides to loop through all instantiations of an object
. C++ side file handling in dbinc.cc
. User's Guide
. defining params in terms of other params (internal mode)

FORTRAN STRUCTURES
Handling of structures and templates has been converted to VMS-style Fortran
structures.
TEMPLATE INSTANTIATION
- MAKE no longer accepts an instantiation name. Uses the index. DEFINE replaces this function of
  MAKE, but not fully re-implemented.
GUI MENU DEFINITION
- GUI menu definition file now generated: xxxxGUI.h.
XDR/MCFIO DATA STRUCTURE I/O
INTERNAL DATA STRUCTURE DEFINITION
- MODE INTERNAL declaration
- RECORD statement, instantiation handling. Instance name allowed as param on RECORD stmt.
  Hence multiple instantiations.
- separation of structure def file from instantiation file
- relaxed fixed size declarations, multi-dimensional arrays
- restricted file set
- different master include name, _dst
- no _db extension to rerouted include file names
DOUBLE
- re-implemented

 *
 * dbin  - DataBase INput tool
 * ---------------------------
 *
 *                 Torre Wenaus 31/12/1993
 *
 * This utility takes an ascii parameter definition file and
 * using lex parsing of the file constructs
 * - a Fortran include file containing a common block that includes
 *   all parameters, with explicit typing and documentation
 * - a Fortran routine to read the parameter definition file as the
 *   data file that specifies parameter values, with extensive
 *   error checking
 * - analogous include file and input routine in C.
 *
 * Thus given an ascii database that simultaneously specifies the
 * structure, mnemonic names, actual values, and documentation of
 * a parameter set, this package automatically generates the code
 * needed to read and use this database in Fortran and C programs.
 *
 * Accommodating a change in the database (eg. addition of a parameter)
 * involves nothing more than changing the database file itself and
 * rerunning this tool; a valuable simplification over the several manual
 * coding modifications -- in two languages if C and Fortran are
 * supported -- traditionally required.
 *
 * Example illustrating database file structure:
 *
 * STRUCTURE MUON     ! parameter group, eg. subdetector name
 *   REAL BLEN 400.   ! barrel length
 *   INT  NBPL 24     ! number of barrel planes
 *   REAL PLTHK(2) 1.0 2.0  ! inner and outer plate thicknesses
 * END STRUCTURE
 *
 *
 * Building variable names from mnemonics
 * --------------------------------------
 * The derivation of variable name from the given mnemonic can be
 * done in whatever way is desired. What is presently done is
 * the first two characters of the structure (subdetector) name
 * are appended (with a leading _) to the mnemonic to come up with
 * the variable name. eg. the BLEN parameter above would have a
 * variable name BLEN_MU.
 *
 *
 *
 * Template structures:
 * --------------------
 * 
 * TEMPLATE MAT 5  ! structure template for materials, with max no. of materials
 *   REAL A
 *   REAL Z
 *   REAL DENS
 *   REAL RADL
 *   REAL ABSL
 * END TEMPLATE
 * MAKE MAT CSI   129.97  54.02  4.51  1.86  37.   ! instantiate template MAT, name CSI
 * MAKE MAT SCINT 6.25    3.4    1.03  43.   437.
 * 
 * => COMMON // MAT_A(N_MAT), MAT_Z(N_MAT), MAT_DENS(N_MAT), MAT_RADL(N_MAT)...
 *    IF (VARNAME.EQ.'MAT_TEMPLATE') THEN
 *      INDEX = IMATIDX  ! from lookup list using object name string
 *      MAT_A(INDEX) = RVAR(1)
 *      MAT_Z(INDEX) = RVAR(2) ...
 *
 * New:
 * - PROVIDE statement to have specified include file added to generated
 *   .inc,.h
 * - FFREAD handling
 * - To split include file into several:
 *     INCNAME name where name doesn't include type; .h,.inc added automatically
 * - dbin now accepts db filename on command line (or from stdin for backwards
 *   compatibility). Path is prefixed to INCLUDEd files so they can be found
 *   when the db is not in the current directory.
 * - .inc,.h diversion to new filename: INCNAME directive
 * - DIMENSION statement to generate constant integer parameter for array
 *   dimensioning. Must appear OUTSIDE structures and templates. Variable name
 *   is the mnemonic name without modification (so be sure to make it unique)
 * - INDEX statement to generate mnemonic pointers into an array. Like
 *   DIMENSION, must appear OUTSIDE structures and templates and mnemonic
 *   names are taken directly for variable names.
 * - DOUBLE supported only for structures, to reduce amount of code to be
 *   maintained, and because only need for it I foresee is for constants
 *   like pi.
 * - new COMMAND/CALL type for passing template-like structures to a
 *   user routine for processing, rather than dbin loading the information
 *   into dbin-defined data structures. Very much like defining and then
 *   calling a command, hence the name.
 * - strings need not be quoted in COMMANDS (but ONLY in COMMANDS)
 * 
 */

%p 17000
%n 2000
%a 7000

%s STRUCTURE
%{
#include <stdio.h>
#include <unistd.h>
#include <string.h>
# define MAXLINE 2000
# define YYLMAX 2048
%}

%s TEMPLATE
%{
%}

%s COMMAND
%{
%}

%s FFREAD
%{
%}

  /***** DBIN Version number *****/ int idbin_version = 0001;

  char* stlower(char* st);
  char* stupper(char* st);
  void strsub(char* str, char* sub, char* repl);
  void check_finc_fh();

  int npgmlines = 0, ntotlines = 0, ntotchars = 0, ndim = 0, n2dim = 0;
  int is_template = 0, n_elements = 0, n_templates = 0, indx = 0;
  int nguiel = 0, declare_record;
  int is_command = 0, new_template = 0, fixed_size = 0, print_listing = 0;
  int indxtot = 0, internal_mode = 0, incfile_open = 0;
  int nstructbase = 0, n_templ_entries = 0, ischar = 0, cray=0;
  int nv, nn, n, n1, np, nq;
  char *chmaterial = "material", *chnest = "nest", *chinternal="internal";
  char dbpath[40];  /* pathname of database file */
  char vartype[20], typenamc[20], typenamf[20], parent[30];
  char fname[80], incfname[80], *fpnt;
  char dbin_dbvsn[10], dim[30], dim1[30], cstruct[30], template_size[30];
  char varlist[10000], varlistc[10000], line1[MAXLINE];
  int nvars = 0, nvarsc = 0;
  char curtype[30], curname[30], curstruct[30], fullname[30], curcomment[1000];
  char values[50000], dbname[30], curvar[30], curvarc[30], *curval, *curnum, *curnumc;
  char uroutine[30];
  char *iprefix = "ies_", *rprefix = "res_";
  char *objname, *arg1, *arg2, *valpnt, *idxlst;
  extern char *getenv();
  FILE *finc, *fh, *frdf, *frdc, *finitc, *finitf, *fopen();
  FILE *fgui, *fxdr, *fxdrall, *fxdrmgr, *fxdrinc;
  FILE *finc_original, *fh_original;
  FILE *yyinlist[10];
  int inlist = 0;
DATABASE  [ \t]*("DATABASE"|"database")+[^\n]*
INTEGER   [ \t]*("INT"|"int")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
REAL      [ \t]*("REAL"|"real")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
DOUBLE    [ \t]*("DOUBLE"|"double")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
CHARACTER [ \t]*("CHAR"|"char")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
MATERIAL  [ \t]*("MATERIAL"|"material")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
DIMENSION [ \t]*("DIMENSION"|"dimension")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
INDEX     [ \t]*("INDEX"|"index")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
STRUCTURE [ \t]*("STRUCTURE"|"structure")+[^\n]*
TEMPLATE  [ \t]*("TEMPLATE"|"template")+[^\n]*
RECORD    [ \t]*("RECORD"|"record")+[^\n]*
CHILD     [ \t]*("CHILD"|"child")+[^\n]*
NEST      [ \t]*("NEST"|"nest")+[^\n]*
PARENT    [ \t]*("PARENT"|"parent")+[^\n]*
MODE      [ \t]*("MODE"|"mode")+[^\n]*
MAKE      [ \t]*("MAKE"|"make")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
DEFINE    [ \t]*("DEFINE"|"define")+([^\n]*|[^\n]*(("/\n"|"/"+[ \t]*"!"+[^\n]+"\n")+[^\n]*)*)
PROVIDE   [ \t]*("PROVIDE"|"provide")+[^\n]*
INCLUDE   [ \t]*("INCLUDE"|"include")+[^\n]*
INCNAME   [ \t]*("INCNAME"|"incname")+[^\n]*
END       [ \t]*("END"|"end")+[^\n]*
FFREAD    [ \t]*("FFREAD"|"ffread")+[^\n]*
FFEND     [ \t]*("FFEND"|"ffend")+[^\n]*
FILE      [ \t]*("FILE"|"file")+[^\n]*
FILEEND   [ \t]*("FILEEND"|"fileend")+[^\n]*
COMMAND   [ \t]*("COMMAND"|"command")+[^\n]*
CALL      [ \t]*("CALL"|"call")+[^\n]*
ANY       [^\n]*

%%

.     ntotchars++;

\n    ntotlines++;

<STRUCTURE>^{REAL}|{INTEGER}|{DOUBLE}|{CHARACTER}|{MATERIAL} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      /* turn mnemonic into variable name */
      varsave(-1);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      fprintf(frdf,
         "      else if (varname.eq.'%s.%s') then\n",curstruct,curname);
      if (strcmp(stlower(curtype),"real") == 0) {
          strcpy(vartype,"rvar");
          strcpy(typenamf,"real");
          strcpy(typenamc,"float");
      }
      if (strcmp(stlower(curtype),"double") == 0) {
          strcpy(vartype,"dvar");
          strcpy(typenamf,"double precision");
          strcpy(typenamc,"double");
      }
      if (strncmp(stlower(curtype),"int",3) == 0) {
          strcpy(vartype,"rvar");
          strcpy(typenamf,"integer");
          strcpy(typenamc,"int");
      }
      if (strncmp(stlower(curtype),"char",4) == 0 || strcmp(stlower(curtype),"material") == 0) {
          strcpy(vartype,"chvar");
          strcpy(typenamf,"character*80");
          strcpy(typenamc,"char");
      }
      if (strlen(dim) == 0) {
        fprintf(frdf,
        "        %s.%s = %s(1) ! %s\n",curstruct,curname,vartype,curcomment);
        fprintf(finc,
        "        %s %s ! %s\n",typenamf,curname,curcomment);
        if (strcmp(typenamc,"char")==0) {
          fprintf(frdc,"if (varname==\"%s.%s\"){ strcpy(%s->%s,chvar[0]); iok=1;}\n",
                curstruct,curname,curstruct,curname);
          fprintf(fh,"  %s %s[80]; /* %s */\n",typenamc,curname,curcomment);
        } else {
          fprintf(frdc,"if (varname==\"%s.%s\"){ %s->%s = %s[0]; iok=1;}\n",
                curstruct,curname,curstruct,curname,vartype);
          fprintf(fh,"  %s %s; /* %s */\n",typenamc,curname,curcomment);
        }
        curval = strtok(values," /\t\n");
        if (strcmp(typenamc,"char")==0) {
          fprintf(finitc,
          "      strcpy(%s->%s,%s);\n",curstruct,curname,curval);
          n1=0; while (n1<strlen(values)) {if (values[n1]=='"') values[n1]='\''; n1++;}
        } else {
          fprintf(finitc,
          "      %s->%s = %s;\n",curstruct,curname,curval);
        }
        fprintf(finitf,
        "      %s.%s = %s\n",curstruct,curname,curval);
      } else {
        if (strcmp(typenamc,"char")==0) {
          fprintf(frdf,
          "        do i=1,%s  ! %s\n",dim,curcomment);
          fprintf(frdf,
          "          %s.%s(i) = chvar(i)\n",curstruct,curname);
          fprintf(frdf,
          "        enddo\n");
        } else {
          if (strcmp(typenamc,"double")==0) {
            fprintf(frdf,
            "        call ucopy(%s,%s.%s,%s*2) ! %s\n",vartype,curstruct,curname,dim,curcomment);
          } else {
            fprintf(frdf,
            "        call ucopy(%s,%s.%s,%s) ! %s\n",vartype,curstruct,curname,dim,curcomment);
          }
        }
        fprintf(finc,
        "        %s %s(%s) ! %s\n",typenamf,curname,dim,curcomment);
        if (strcmp(typenamc,"char")==0) {
          fprintf(frdc,
          "if (varname==\"%s.%s\")\n   {int i=0; while (i<%s) {strcpy(%s->%s[i],chvar[i]);i++;};iok=1;}\n",
           curstruct,curname,dim,curstruct,curname);
        } else {
          fprintf(frdc,
          "if (varname==\"%s.%s\")\n   {int i=0; while (i<%s) {%s->%s[i]=%s[i];i++;};iok=1;}\n",
           curstruct,curname,dim,curstruct,curname,vartype);
        }
        strcpy(dim1,dim); strsub(dim1,",","][");
        if (strcmp(typenamc,"char")==0) {
          fprintf(fh,"  %s %s[%s][80]; /* %s */\n",typenamc,curname,dim1,curcomment);
        } else {
          fprintf(fh,"  %s %s[%s]; /* %s */\n",typenamc,curname,dim1,curcomment);
        }
        arg1 = values;
        n = 0; while (n<ndim) {
          curval = strtok(arg1," /\n");
          arg1 = NULL;
          if (strcmp(typenamc,"char")==0) {
              n1=0; np=0; while (n1<strlen(curval)) {
                  if (curval[n1]=='"'||curval[n1]=='\'') np++;
                  if (curval[n1]=='/'&&np%2==0) curval[n1]=' '; n1++;}
              fprintf(finitc,
              "      strcpy(%s->%s[%d],%s);\n",curstruct,curname,n,curval);
              n1=0; while (n1<strlen(curval)) {if (curval[n1]=='"') 
                  curval[n1]='\''; n1++;}
          } else {
            fprintf(finitc,
            "      %s->%s[%d] = %s;\n",curstruct,curname,n,curval);
          }
          fprintf(finitf,
          "      %s.%s(%d) = %s\n",curstruct,curname,n+1,curval);
          n++;
        }
      }
    }
<TEMPLATE>^{REAL} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      if (strlen(dim) == 0) {
        varsave(-1);
        fprintf(frdf,
           "        %s(index).%s = rvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
           "        inum = inum + 1\n");
        fprintf(finc,
           "        real %s  ! %s\n",curname,curcomment);
        fprintf(frdc,
           "  %s[index].%s = rvar[inum++];\n",curstruct,curname);
        fprintf(fh,"  float %s; /* %s */\n",curname,curcomment);
        strsub(curcomment,"\"","'");
        nguiel++;
        fprintf(fgui,"    \"%s\", \"float\", \"%s\",\n",curname,curcomment);
        fprintf(fxdr,"  if (!xdr_float(xdrs,&(dbobj->%s))) return 0;\n",curname);
        n_elements++;
      } else {
        int i; for (i=0;i<ndim;i++) varsave(i);
        fprintf(frdf,"        do i=1,%s\n",dim);
        fprintf(frdf,
           "           %s(index).%s(i) = rvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
           "          inum = inum + 1\n        enddo\n");
        fprintf(finc,
           "        real %s(%s)  ! %s\n",curname,dim,curcomment);
        fprintf(frdc,
           "  for (i=0;i<%s;i++) %s[index].%s[i] = rvar[inum++];\n",
           dim,curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  float %s[%s]; /* %s */\n",curname,dim1,curcomment);
        strsub(curcomment,"\"","'");
        for (i=0;i<ndim;i++) {
          nguiel++;
          fprintf(fgui,"    \"%s(%d)\", \"float\", \"%s\",\n",curname,i+1,curcomment);
        }
        fprintf(fxdr,"  dat = (float *) dbobj->%s;\n",curname);
        strsub(dim,",","*");
        if (strcmp(stlower(values),"variable") != 0) 
          fprintf(fxdr,"  ui = %s;\n",dim);
        fprintf(fxdr,
          "  if (!xdr_array(xdrs,(char **) &dat,&ui,ui,sizeof(float),(xdrproc_t) xdr_float)) return 0;\n");
        n_elements = n_elements + ndim;
      }
    }
<COMMAND>^{REAL} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      varsave(-1);
      if (strlen(dim) == 0) {
        fprintf(frdf,
         "        %s_%s = rvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
         "        inum = inum + 1\n");
        fprintf(finc,
         "        real %s_%s  ! %s\n",curstruct,curname,curcomment);
        fprintf(frdc,
         "  %s.%s = rvar[inum++];\n",curstruct,curname);
        fprintf(fh,"  float %s; /* %s */\n",curname,curcomment);
      } else {
        fprintf(frdf,
         "        call ucopy(rvar(inum),%s_%s,ndim) ! %s\n",
                curstruct,curname,curcomment);
        fprintf(frdf,
         "        inum = inum + ndim\n");
        fprintf(finc,
         "        real %s_%s(%s)  ! %s\n",curstruct,curname,dim,curcomment);
        fprintf(frdc,
         "  { int i=0; while (i<ndim) {%s.%s[i] = rvar[inum++];i++;}}\n",
                curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  float %s[%s]; /* %s */\n",curname,dim1,curcomment);
      }
      n_elements++;
    }

<TEMPLATE>^{DOUBLE}    {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      if (strlen(dim) == 0) {
        varsave(-1);
        fprintf(frdf,
           "        %s(index).%s = dvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
           "        inum = inum + 1\n");
        fprintf(finc,
           "        double precision %s  ! %s\n",curname,curcomment);
        fprintf(frdc,
           "  %s[index].%s = dvar[inum++];\n",curstruct,curname);
        fprintf(fh,"  double %s; /* %s */\n",curname,curcomment);
        strsub(curcomment,"\"","'");
        nguiel++;
        fprintf(fgui,"    \"%s\", \"double\", \"%s\",\n",curname,curcomment);
        fprintf(fxdr,"  if (!xdr_double(xdrs,&(dbobj->%s))) return 0;\n",curname);
        n_elements++;
      } else {
        int i; for (i=0;i<ndim;i++) varsave(i);
        fprintf(frdf,"        do i=1,%s\n",dim);
        fprintf(frdf,
           "           %s(index).%s(i) = dvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
           "          inum = inum + 1\n        enddo\n");
        fprintf(finc,
           "        double precision %s(%s)  ! %s\n",curname,dim,curcomment);
        fprintf(frdc,
           "  for (i=0;i<%s;i++) %s[index].%s[i] = dvar[inum++];\n",
           dim,curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  double %s[%s]; /* %s */\n",curname,dim1,curcomment);
        strsub(curcomment,"\"","'");
        for (i=0;i<ndim;i++) {
          nguiel++;
          fprintf(fgui,"    \"%s(%d)\", \"double\", \"%s\",\n",curname,i+1,curcomment);
        }
        fprintf(fxdr,"  ddat = (double *) dbobj->%s;\n",curname);
        strsub(dim,",","*");
        if (strcmp(stlower(values),"variable") != 0)
          fprintf(fxdr,"  ui = %s;\n",dim);
        fprintf(fxdr,
          "  if (!xdr_array(xdrs,(char **) &ddat,&ui,ui,sizeof(double),(xdrproc_t) xdr_double)) return 0;\n");
        n_elements = n_elements + ndim;
      }
    }
<COMMAND>^{DOUBLE} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      varsave(-1);
      if (strlen(dim) == 0) {
        fprintf(frdf,
         "        %s_%s = dvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
         "        inum = inum + 1\n");
        fprintf(finc,
         "        double precision %s_%s  ! %s\n",curstruct,curname,curcomment);
        fprintf(frdc,
         "  %s.%s = dvar[inum++];\n",curstruct,curname);
        fprintf(fh,"  double %s; /* %s */\n",curname,curcomment);
      } else {
        fprintf(frdf,
         "        call ucopy(rvar(inum),%s_%s,ndim*2) ! %s\n",
                curstruct,curname,curcomment);
        fprintf(frdf,
         "        inum = inum + ndim\n");
        fprintf(finc,
         "        double precision %s_%s(%s)  ! %s\n",curstruct,curname,dim,curcomment);
        fprintf(frdc,
         "  { int i=0; while (i<ndim) {%s.%s[i] = dvar[inum++];i++;}}\n",
                curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  double %s[%s]; /* %s */\n",curname,dim1,curcomment);
      }
      n_elements++;
    }
<TEMPLATE>^{INTEGER} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      if (strlen(dim) == 0) {
        varsave(-1);
        fprintf(frdf,
      "        %s(index).%s = rvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
           "        inum = inum + 1\n");
        fprintf(finc,
           "        integer %s  ! %s\n",curname,curcomment);
        fprintf(frdc,
           "  %s[index].%s = rvar[inum++];\n",curstruct,curname);
        fprintf(fh,"  int %s; /* %s */\n",curname,curcomment);
        strsub(curcomment,"\"","'");
        nguiel++;
        fprintf(fgui,"    \"%s\", \"int\", \"%s\",\n",curname,curcomment);
        fprintf(fxdr,"  if (!xdr_int(xdrs,&(dbobj->%s))) return 0;\n",curname);
        fprintf(fxdr,"  ui = dbobj->%s;\n",curname);
        n_elements++;
      } else {
        int i; for (i=0;i<ndim;i++) varsave(i);
        fprintf(frdf,"        do i=1,%s\n",dim);
        fprintf(frdf,
      "          %s(index).%s(i) = rvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
           "          inum = inum + 1\n        enddo\n");
        fprintf(finc,
           "        integer %s(%s)  ! %s\n",curname,dim,curcomment);
        fprintf(frdc,
           "  for (i=0;i<<%s;i++) %s[index].%s[i] = rvar[inum++];\n",
           dim,curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  int %s[%s]; /* %s */\n",curname,dim1,curcomment);
        strsub(curcomment,"\"","'");
        for (i=0;i<ndim;i++) {
          nguiel++;
          fprintf(fgui,"    \"%s(%d)\", \"int\", \"%s\",\n",curname,i+1,curcomment);
        }
        fprintf(fxdr,"  idat = (int *) dbobj->%s;\n",curname);
        strsub(dim,",","*");
        if (strcmp(stlower(values),"variable") != 0)
          fprintf(fxdr,"  ui = %s;\n",dim);
        fprintf(fxdr,
          "  if (!xdr_array(xdrs,(char **) &idat,&ui,ui,sizeof(int),(xdrproc_t) xdr_int)) return 0;\n");
        n_elements = n_elements + ndim;
      }
    }
<COMMAND>^{INTEGER} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      varsave(-1);
      if (strlen(dim) == 0) {
        fprintf(frdf,
         "        %s_%s = rvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
         "        ndim = rvar(inum)\n");
        fprintf(frdf,
         "        inum = inum + 1\n");
        fprintf(finc,
         "        integer %s_%s  ! %s\n",curstruct,curname,curcomment);
        fprintf(frdc,
         "  ndim = rvar[inum];\n");
        fprintf(frdc,
         "  %s.%s = rvar[inum++];\n",curstruct,curname);
        fprintf(fh,"  int %s; /* %s */\n",curname,curcomment);
      } else {
        fprintf(frdf,
         "        call ucopy(rvar(inum),%s_%s,ndim) ! %s\n",
                curstruct,curname,curcomment);
        fprintf(frdf,
         "        inum = inum + ndim\n");
        fprintf(finc,
         "        integer %s_%s(%s)  ! %s\n",curstruct,curname,dim,curcomment);
        fprintf(frdc,
         "  { int i=0; while (i<ndim) {%s.%s[i] = rint(var[inum++]);i++;}}\n",
                curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  int %s[%s]; /* %s */\n",curname,dim1,curcomment);
      }
      n_elements++;
    }
<TEMPLATE>^{CHARACTER}|{MATERIAL} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      if (strlen(dim) == 0) {
        varsave(-1);
        fprintf(frdf,
                "        %s(index).%s = chvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
                "        inum = inum + 1\n");
        fprintf(finc,
                "        character %s*80  ! %s\n",curname,curcomment);
        fprintf(frdc,
                "  strcpy(%s[index].%s,chvar[inum++]);\n",curstruct,curname);
        fprintf(fh,"  char %s[80]; /* %s */\n",curname,curcomment);
        strsub(curcomment,"\"","'");
        nguiel++;
        if (*curtype == *chmaterial) {
            fprintf(fgui,"    \"%s\", \"material\", \"%s\",\n",curname,curcomment);
        } else {
            fprintf(fgui,"    \"%s\", \"char\", \"%s\",\n",curname,curcomment);
        }
        fprintf(fxdr,"  if (xdrs->x_op == XDR_ENCODE) {\n");
        fprintf(fxdr,"    ln = strlen(dbobj->%s); }\n",curname);
        fprintf(fxdr,"  if (!xdr_int(xdrs,&ln)) return 0;\n");
        fprintf(fxdr,"  xdrstring = dbobj->%s;\n",curname);
        fprintf(fxdr,"  if (!xdr_string(xdrs,&xdrstring,ln)) return 0;\n",
           curname);
        n_elements++;
      } else {
        int i; for (i=0;i<ndim;i++) varsave(i);
        fprintf(frdf,"        do i=1,%s\n",dim);
        fprintf(frdf,"          %s(index).%s(i) = chvar(inum) ! %s\n",
                curstruct,curname,curcomment);
        fprintf(frdf,"          inum = inum + 1\n         enddo\n");
        fprintf(finc,"        character*80 %s(%s)  ! %s\n",curname,dim,curcomment);
        fprintf(frdc,"  for (i=0;i<%s;i++) strcpy(%s[index].%s[i],chvar[inum++]);\n",
                dim,curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  char %s[%s][80]; /* %s */\n",curname,dim1,curcomment);
        strsub(curcomment,"\"","'");
        for (i=0;i<ndim;i++) {
          nguiel++;
          if (curtype == "material") {
            fprintf(fgui,"    \"%s(%d)\", \"char\", \"%s\",\n",curname,i+1,curcomment);
          } else {
            fprintf(fgui,"    \"%s(%d)\", \"material\", \"%s\",\n",curname,i+1,curcomment);
          }
        }
        for (i=0;i<ndim;i++) {
            fprintf(fxdr,"  if (xdrs->x_op == XDR_ENCODE) {\n");
            fprintf(fxdr,"    ln = strlen(dbobj->%s[%d]); }\n",curname,i);
            fprintf(fxdr,"  if (!xdr_int(xdrs,&ln)) return 0;\n");
            fprintf(fxdr,"  xdrstring = dbobj->%s[%d];\n",curname,i);
            fprintf(fxdr,"  if (!xdr_string(xdrs,&xdrstring,ln)) return 0;\n",
              curname,i);
        }
        n_elements = n_elements + ndim;
      }      
    }
<COMMAND>^{CHARACTER}|{MATERIAL} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      varsave(-1);
      if (strlen(dim) == 0) {
        fprintf(frdf,
         "        %s_%s = chvar(inum) ! %s\n",curstruct,curname,curcomment);
        fprintf(frdf,
         "        inum = inum + 1\n");
        fprintf(finc,
         "        character %s_%s*80  ! %s\n",curstruct,curname,curcomment);
        fprintf(frdc,
         "  strcpy(%s.%s,chvar[inum++]);\n",curstruct,curname);
        fprintf(fh,"  char %s[80]; /* %s */\n",curname,curcomment);
      } else {
        fprintf(frdf,
         "        do i=1,ndim  ! %s\n",curcomment);
        fprintf(frdf,
         "          %s_%s(i) = chvar(inum) ! %s\n",
                curstruct,curname,curcomment);
        fprintf(frdf,
         "          inum = inum + 1\n");
        fprintf(frdf,
         "        enddo\n");
        fprintf(finc,
         "        character %s_%s(%s)*80  ! %s\n",
                curstruct,curname,dim,curcomment);
        fprintf(frdc,
         "  int i=0; while (i<ndim) {strcpy(%s.%s[i],chvar[inum++]);i++;}\n",
                curstruct,curname);
        strcpy(dim1,dim); strsub(dim1,",","][");
        fprintf(fh,"  char %s[%s][80]; /* %s */\n",curname,dim1,curcomment);
      }
      n_elements++;
    }
<STRUCTURE>^{END}  {  /* $$$ fh output */
      close_makes(curstruct);
      ++npgmlines;
      BEGIN(0);
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      fprintf(finc,"      end structure\n");
      fprintf(finc,"      record /%s_s/ %s\n",curstruct,curstruct);
      fprintf(finc,"      common /%s_c/ %s\n",curstruct,curstruct);
      fprintf(fh,"} %s_s;\n",curstruct);
      if (cray) {
          fprintf(fh,"extern %s_s %s_C;\n",curstruct,stupper(curstruct));
          fprintf(fh,"%s_s *%s = &%s_C;\n",curstruct,curstruct,stupper(curstruct));
      } else {
          fprintf(fh,"extern %s_s %s_c_;\n",curstruct,stlower(curstruct));
          fprintf(fh,"%s_s *%s = &%s_c_;\n",curstruct,curstruct,stlower(curstruct));
      }
             }
<TEMPLATE>^{END}  {
      ++npgmlines;
      BEGIN(0);
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(finitf,"* %s\n",line1);
      fprintf(finitc,"/* %s */\n",line1);
      fprintf(fh,"} %s_s;\n",curstruct);
      fprintf(frdc,"}\n");
      fprintf(finitf,
         "      n_entries(%d) = %d ! entries in template\n",
              n_templates,n_elements);
      fprintf(finc,"      end structure\n");
      if (!internal_mode) {
        fprintf(finc,
        "      integer n_el_%s\n",curstruct);
        fprintf(finc,
        "      parameter(n_el_%s=%d)\n",curstruct,n_elements);
        fprintf(fh,
        "static const int n_el_%s=%d;\n",curstruct,n_elements);
      }
      fprintf(fgui,"  }, %d, \"%s\",\n",nguiel,parent);
      fprintf(fxdr,"  return 1;\n}\n\n");
             }
<COMMAND>^{END}  {  /* $$$ fh */
      ++npgmlines;
      BEGIN(0);
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      fprintf(frdf,"        call %s\n",uroutine);
      fprintf(frdc,"  %s();\n",uroutine);
      fprintf(frdc,"}\n");
      fprintf(finc,
      "      integer n_el_%s\n",curstruct);
      fprintf(finc,
      "      parameter(n_el_%s=%d)\n",curstruct,n_elements);
      fprintf(fh,
      "static const int n_el_%s=%d;\n",curstruct,n_elements);
             }
^{INTEGER}  {
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                printf("Declaration of %s ignored,not in structure\n",curname);
              }
^{REAL}      {
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                printf("Declaration of %s ignored,not in structure\n",curname);
              }
^{DOUBLE}    {
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                printf("Declaration of %s ignored,not in structure\n",curname);
              }
^{INDEX} {
      ++npgmlines;
      dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
      idxlst = values; /* list of index mnemonics */
      /* go through the list, building param names using curvar */
      n1=0; arg1=idxlst; curval=idxlst;
      while(curval = strtok(arg1," /\n")) {
          /* turn mnemonic into variable name */
          if (strlen(curname)>0 && curname[0] != '-') {
            fprintf(finc,"      integer %s_%s\n",curname,curval);
            fprintf(finc,"      parameter( %s_%s = %d) ! %s\n",
                    curname,curval,n1+1,curcomment);
            fprintf(fh,"static const int %s_%s = %d; /* %s */\n",
                    curname,curval,n1,curcomment);
          } else {
            fprintf(finc,"      integer %s\n",curval);
            fprintf(finc,"      parameter( %s = %d) ! %s\n",
                    curval,n1+1,curcomment);
            fprintf(fh,"static const int %s = %d; /* %s */\n",
                    curval,n1,curcomment);
          }
          arg1=NULL; n1++;
      }
      }
^{DIMENSION} {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                fprintf(finc,"      integer %s\n",curname);
                fprintf(finc,"      parameter( %s = %s) ! %s\n",
                        curname,values,curcomment);
                fprintf(fh,"#define %s %s   /* %s */\n",
                        curname,values,curcomment);
              }
^{STRUCTURE} {
                close_makes(curstruct);
                nvars=0; nvarsc=0;
                ++npgmlines;
                BEGIN(STRUCTURE);
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                strcpy(curstruct, curname);
                fprintf(finc,"\n***** structure %s *****\n",curstruct);
                fprintf(finc,"      structure /%s_s/\n",curstruct);
                fprintf(fh,"\n/***** structure %s *****/\n",curstruct);
                fprintf(fh,"\ntypedef struct _%s_s {\n",curstruct);
                fprintf(finitf,"\n***** structure %s *****\n",curstruct);
                fprintf(finitc,"\n/***** structure %s *****/\n",curstruct);
                is_template = 0; is_command = 0;
                strcpy(cstruct,curstruct);
              }
^{TEMPLATE}  {
                close_makes(curstruct);
                n_templ_entries = 0;
                new_template = 1;
                fixed_size = 0;
                nvars=0; nvarsc=0;
                parent[0]='\0';
                nguiel = 0;
                ++npgmlines;
                BEGIN(TEMPLATE);
                n_templates++;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                strcpy(curstruct, curname);
                template_size[0]='\0';
                if (ndim > 0) {
                    strcpy(template_size,dim);
                    fixed_size = ndim;
                    if (fixed_size < 2) fixed_size = 2;
                }
                check_finc_fh();
                fprintf(finc,"\n***** template %s *****\n",curstruct);
/* Adding maximum dimension allowed, so that we can protect ourself against
   overwrites (P.L.) */
                if (ndim > 0) {
                  fprintf(finc,"      integer MAXNUM_%s\n",curstruct);                
                  fprintf(finc,"      parameter(MAXNUM_%s = %s)\n",
                                        curstruct, template_size);
                }                        
                fprintf(finc,"      structure /%s_s/\n",curstruct);
                fprintf(fh,"\n/***** template %s *****/\n",curstruct);
                if (ndim > 0) 
                   fprintf(fh,
                           "#define MAXNUM_%s %s\n", curstruct, template_size);
                fprintf(fh,"\ntypedef struct _%s_s {\n",curstruct);
                fprintf(finitf,"\n***** template %s *****\n",curstruct);
                fprintf(finitf,"      template_name(%d) = '%s'\n",
                        n_templates,curstruct);
                fprintf(finitc,"\n/***** template %s *****/\n",curstruct);
                fprintf(frdf,
                "      else if (varname.eq.'TEMPLATE_%s') then\n",curstruct);
                fprintf(frdf,
                "        inum = 1\n");
/*                fprintf(frdf,
                "        index = index_for(objname) ! objname is instance name\n"); */
                fprintf(frdf,"        index = n_instance\n");
/* protect ourself against  overwrites (P.L.), July 1996 */
                fprintf(frdf,"        if(index .gt. %s) then \n",
                                                            template_size);
                fprintf(frdf,"           print *, 'Attempting to overwrite structure %s '\n", curstruct);                                          
                fprintf(frdf,"           print *, 'Current Index = ', index,\n");
                fprintf(frdf,"     &        ',  Maximum allowed %s'\n", template_size);
                fprintf(frdf,
                 "           print *, '   This is a fatal error, stopping' \n");
                fprintf(frdf,"           stop \n");
                fprintf(frdf,"         end if \n");                                 
                fprintf(frdf,"        n_obj_%s = n_instance\n",curstruct);
                fprintf(frdc,
                "if ( !strcmp(varname,\"TEMPLATE_%s\") ) {\n",curstruct);
                fprintf(frdc,
                "  inum = 0; iok = 1;\n");
                fprintf(frdc,
                "  getmembers(n_el_%s);\n",curstruct);
                fprintf(frdc,"  index = n_instance-1;\n");
                fprintf(frdc,"  *n_obj_%s = n_instance;\n",curstruct);
                fprintf(fgui,"\"%s\", {\n",curstruct);
                fprintf(fxdrinc,"\nbool_t xdr_%s(XDR *xdrs, %s_s *dbobj);\n",curstruct,
                        curstruct);
                fprintf(fxdr,"bool_t xdr_%s(XDR *xdrs, %s_s *dbobj)\n{\n",curstruct,
                        curstruct);
                fprintf(fxdr,"  ui = 0;\n");
                is_template = 1; is_command = 0;
                n_elements = 0;
              }
^{RECORD}  {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                strcpy(template_size,dim);
                strcpy(curstruct, curname);
                new_template = 1;
                n_templ_entries = 0;
                declare_record = 1;
                if (strlen(values) == 0) {
                  close_makes(curstruct);
                } else {
                  close_makes(values);
                }
                declare_record = 0;
           }
^{CHILD}|{NEST} {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                if (*curtype == *chnest) {
                  if (strlen(dim) == 0) {
                    fprintf(finc,"        record /%s_s/ %s\n",curname,values);
                    fprintf(fh,"  %s_s %s;\n",curname,values);
                    fprintf(fxdr,"  if (!xdr_%s(xdrs,&(dbobj->%s))) return 0;\n",
                      curname,values);
                  } else {
                    fprintf(finc,"        record /%s_s/ %s(%s)\n",curname,values,dim);
                    fprintf(fh,"  %s_s %s[%s];\n",curname,values,dim);
                    strsub(dim,",","*");
                    fprintf(fxdr,"  for (i=0;i<%s;i++)\n",dim);
                    fprintf(fxdr,"    if (!xdr_%s(xdrs,&(dbobj->%s[i]))) return 0;\n",
                      curname,values);
                  }
                }
                strsub(curcomment,"\"","'");
                nguiel++;
                fprintf(fgui,"    \"%s\", \"child\", \"%s\",\n",curname,curcomment);
            }
^{PARENT} {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                strcpy(parent,curname);
          }
^{COMMAND}  {      /* $$$ support user fn. being in either Fortran or C */
                close_makes(curstruct);
                nvars=0; nvarsc=0;
                ++npgmlines;
                BEGIN(COMMAND);
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                strcpy(uroutine,values); /* name of user routine */
                strcpy(curstruct, curname);
                fprintf(finc,"***** command %s *****\n",curstruct);
                fprintf(fh,"/***** command %s *****/\n",curstruct);
                fprintf(fh,"extern int %s(void);\n",uroutine);
                fprintf(fh,"\ntypedef struct _%s_s {\n",curstruct);
                fprintf(frdf,
                "      else if (varname.eq.'COMMAND_%s') then\n",curstruct);
                fprintf(frdf,
                "        inum = 1\n");
                fprintf(frdf,
                "        ndim = nvars\n");
                fprintf(frdc,
                "if (varname==\"COMMAND_%s\") {\n",curstruct);
                fprintf(frdc,
                "  ndim = nvars; iok=1;\n");
                fprintf(frdc,
                "  getmembers(n_el_%s);\n",curstruct);
                is_template = 0; is_command = 1;
                n_elements = 0;
              }
^{DEFINE}      {    
      /* $$$ like the original make; requires a name for the instantiation */
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                fprintf(finitf,"* %s\n",line1);
                fprintf(finitc,"/* %s */\n",line1);
                objname = strtok(values," ");
                valpnt = objname + strlen(objname)+1;
                indx++;
                indxtot++;
                fprintf(fh,"extern %s_s %s_%s;\n",curstruct,curstruct,objname);
                n = 0; while (n<n_elements) {
                    /* strtok sticks in '\0'; have to remove it */
                  if (n>0) {
                    curval[strlen(curval)]=' ';
                    curnum[strlen(curnum)]=' ';
                    curnumc[strlen(curnumc)]=' ';
                  }
                  n1=0; arg1=valpnt; while(n1<=n) {
                    curval = strtok(arg1," /\n"); 
                    /* strtok sticks in '\0'; have to remove it */
                    if (n1<n) curval[strlen(curval)]=' '; arg1=NULL; n1++;}

                  n1=0; arg1=varlistc; while(n1<=n) {
                    curnumc = strtok(arg1," /\n");
                    printf("%s\n",curnumc);
                    if (n1<n) curnumc[strlen(curnumc)]=' '; arg1=NULL; n1++;}
                  varlistc[nvarsc-1] = ' '; /* replace trailing blank */
                  varlistc[nvarsc] = '\0'; /* replace the terminator */
                  fprintf(finitc,
                  "  %s_%s.%s = %s; /* %s */\n",curname,objname,curnumc,
                          curval,curcomment);

                  n1=0; arg1=varlist; while(n1<=n) {
                    curnum = strtok(arg1," /\n");
                    printf("%s\n",varlistc);
                    if (n1<n) curnum[strlen(curnum)]=' '; arg1=NULL; n1++;}
                  varlist[nvars-1] = ' '; /* replace trailing blank */
                  varlist[nvars] = '\0'; /* replace the terminator */
                  /* for Fortran init, "->' in char values */
                  n1=0; while (n1<strlen(curval))
                    {if (curval[n1]=='"') curval[n1]='\''; n1++;}
                  fprintf(finitf,
                  "      %s(%d).%s = %s ! %s\n",curname,indx,curnum,
                          curval,curcomment);
                  n++;
                }
                fprintf(finitf,
                "      template_object(%d) = '%s_%s' ! internal use\n",
                indxtot,curstruct,objname);
                fprintf(finitf,
                "      index_object(%d) = %d ! internal use\n",indxtot,indx);
              }
^{MAKE}      {  /* No name for the instantiation */
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                fprintf(finitf,"* %s\n",line1);
                fprintf(finitc,"/* %s */\n",line1);
                valpnt = values;
                n=0; nq=0; while (values[n]!='\0') {
                    if (values[n]=='"') nq++;
                    if (values[n]==' '&&nq%2==0) values[n]='@';
                    n++;
                }
                /* printf("%s\n",values); */
                indx++;
                indxtot++;
                n = 0; while (n<n_elements) {
                    /* strtok sticks in '\0'; have to remove it */
                  if (n>0) {
                    curval[strlen(curval)]='@';
                    curnum[strlen(curnum)]=' ';
                    curnumc[strlen(curnumc)]=' ';
                  }
                  n1=0; arg1=valpnt; while(n1<=n) {
                    curval = strtok(arg1,"@/\n"); 
                    /* strtok sticks in '\0'; have to remove it */
                    if (n1<n) curval[strlen(curval)]='@'; arg1=NULL; n1++;}

                  n1=0; arg1=varlistc; while(n1<=n) {
                    curnumc = strtok(arg1," /\n");
                    if (n1<n) curnumc[strlen(curnumc)]=' '; arg1=NULL; n1++;}
                  varlistc[nvarsc-1] = ' '; /* replace trailing blank */
                  varlistc[nvarsc] = '\0'; /* replace the terminator */
                  /* char or non-char? */
                  ischar = 0;
                  n1=0; while (n1<strlen(curval))
                    {if (curval[n1]=='"') ischar=1; n1++;}
                  if (ischar == 0)
                    fprintf(finitc,
                    "  %s[%d].%s = %s; /* %s */\n",curname,indx-1,curnumc,
                          curval,curcomment);
                  else
                    fprintf(finitc,
                      "  strcpy(%s[%d].%s,%s); /* %s */\n",curname,indx-1,
                      curnumc,curval,curcomment);

                  n1=0; arg1=varlist; while(n1<=n) {
                    curnum = strtok(arg1," /\n");
                    if (n1<n) curnum[strlen(curnum)]=' '; arg1=NULL; n1++;}
                  varlist[nvars-1] = ' '; /* replace trailing blank */
                  varlist[nvars] = '\0'; /* replace the terminator */
                  /* for Fortran init, "->' in char values */
                  n1=0; while (n1<strlen(curval))
                    {if (curval[n1]=='"') curval[n1]='\''; n1++;}
                  fprintf(finitf,
                  "      %s(%d).%s = %s ! %s\n",curname,indx,curnum,
                          curval,curcomment);
                  n++;
                }
                fprintf(finitf,
                "      template_object(%d) = '----' ! internal use\n",
                indxtot);
              }
^{CALL}      {
/* nothing really to do because there is no initialization for commands */
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
              }
^{PROVIDE} {
/* provide an include file in the generated code */
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                fprintf(finc,"#include \"%s.inc\"\n",curname);
                fprintf(fh,"#include \"%s.h\"\n",curname);
           }
^{INCLUDE} {
/* include dbin source from another file */
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                  /* open specified file and redirect input */
                yyinlist[inlist] = yyin;
                inlist++;
                strcpy(fname,dbpath);
                fpnt = strcat(fname,curname);
                  /* trim '"' if present */
                for (n=0;n<strlen(fpnt);n++) if (fpnt[n]=='"') fpnt[n]=' ';
                if (print_listing) printf("Include file \"%s\"\n",fpnt);
                if (access(fpnt,F_OK)!=0) {
                    printf("dbin error: file %s does not exist.\n",fpnt); return 1;}
                yyinlist[inlist] = fopen(fpnt,"r");
                yyin = yyinlist[inlist];
           }
^{INCNAME} {
/* redirect .inc, .h to a new include file */
                close_makes(curstruct);
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                if (incfile_open) {
                  fprintf(finc,"\n#endif\n");
                  fprintf(fh,"\n#endif\n");
                }
                incfile_open = 1;
                /* open specified file and redirect input */
                if (finc!=finc_original) fclose(finc);
                if (fh!=fh_original) fclose(fh);
                strcpy(incfname,curname);
                if (!internal_mode) {
                  fpnt = strcat(incfname,"_db.inc");
                } else {
                  fpnt = strcat(incfname,".inc");
                }
                finc = fopen(fpnt,"w");
                /* Add the include to the original .inc,.h files */
                fprintf(finc_original,"#include \"%s\"\n",fpnt);
                strcpy(incfname,curname);
                if (!internal_mode) {
                  fpnt = strcat(incfname,"_db.h");
                } else {
                  fpnt = strcat(incfname,".h");
                }
                fprintf(fh_original,"#include \"%s\"\n",fpnt);
                fh = fopen(fpnt,"w");
                fprintf(finc,"#ifndef _%s_INC\n",curname);
                fprintf(finc,"#define _%s_INC\n\n",curname);
                fprintf(fh,"#ifndef _%s_INC\n",curname);
                fprintf(fh,"#define _%s_INC\n\n",curname);
           }

^{DATABASE} {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                strcpy(dbname, curname);
                /* parse the db version number from the values field */
                arg1 = strtok(values," \n");
                strcpy(dbin_dbvsn,arg1);
                printf("Processing database %s version %s\n",dbname,
                       dbin_dbvsn);
                doheaders();
              }
^{FFREAD}     {
                ++npgmlines;
                BEGIN(FFREAD);
                yyout = fopen("ffread.dat", "w" );
              }
^{FFEND} {
                ++npgmlines;
                BEGIN(0);
                yyout = stdout;
              }
^{FILEEND} {
                ++npgmlines;
                BEGIN(0);
                yyout = stdout;
              }
<FFREAD>^{ANY} {
               ECHO; fprintf(yyout,"\n");
               }
^{FILE}     {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                BEGIN(FFREAD);
                yyout = fopen(curname, "w" );
              }
^{MODE} {
                ++npgmlines;
                dbinparse(yytext,curtype,curname,curvar,curcomment,dim);
                if (*curname == *chinternal) {
                    internal_mode = 1;
                    printf("dbin usage mode: Definition of program data structures\n");
                }
            }
^{END}       {
                close_makes(curstruct);
/*
                fprintf(frdc,"if (iok==0 && varname[0]!='\\0')\n");
                fprintf(frdc,
                "  fprintf(stdout,\"dbin error: unknown: %s\\n\",varname);\n",
                        "%s");
*/
                fprintf(frdc,"}\n");
                fprintf(fxdrall,"}\n");
                if (incfile_open) {
                  fprintf(finc,"\n#endif\n");
                  fprintf(fh,"\n#endif\n");
                }
                fprintf(fgui,"\"end_of_file\", { \" \", \" \", \" \"}, 1\n};\n");
                ++npgmlines;
             }

%%

/****************************************************************************/
main(int argc,char* argv[])
{
#include <unistd.h>
  int n, i;
  strcpy(dbin_dbvsn,"0000");

  print_listing = 0;
  cray = 0;
  inlist = 0;
  /* if dbin filename is on command line... */
  if (argc>1) {
    printf("Reading database %s\n",argv[1]);
    /* Extract path from the db filename */
    getpath(argv[1]);
    if (access(argv[1],F_OK)!=0) {
        printf("dbin error: file %s does not exist.\n",argv[1]); return 1;}
    yyin = fopen(argv[1],"r");
  }  else {
    dbpath[0] = '\n';
  }
  /* check for options */
  if (argc>0) {
    for (i=0;i<argc;i++) {
      if (!strcmp(argv[i],"-list")) print_listing = 1;
      if (!strcmp(argv[i],"-help")) {
        printf("Usage: dbin dbfile.db [-list] [-help] [-cray]\n");
        printf("       -list: Print listing of db file during execution\n");
        printf("       -cray: Build Cray-compatible code\n");
      }
      if (!strcmp(argv[i],"-cray")) {
        printf("dbin: Building Cray-compatible code. Valid for Cray only.\n");
        cray = 1;
      }
    }
  }
  yylex();
  while (inlist != 0) {
    if (inlist > 0) inlist--;
    yyin = yyinlist[inlist];
    yylex();
    /* yyrestart(); */
  }
  docloseout();

  printf("Directive lines in database file: %d\n",npgmlines);
}

/****************************************************************************/
dbinparse(char *str, char *typ, char *nam, char *var, char *com, char *dim)
{

/* Parse line for the name and comment */

  int c, nc, nt, ncm, nd, npv, len1, after_cont, after_com, got_token, ii;

  len1 = strcspn(str,"/");
  if (len1>=MAXLINE)
    {
      printf("truncated line at %d chars:\n%s\n",MAXLINE,str);
      len1=MAXLINE-1;
    }
  strncpy(line1,str,len1); line1[len1] = '\0';
  if (print_listing == 1) printf("TheLine-->\"%s\"<--TheLine\n",str);

  /* zap any comments following line continuation chars */
  after_cont = after_com = 0;
  for (nc=0;nc<strlen(str);nc++) {
      if (str[nc] == '/') after_cont = 1;
      if (str[nc] == '!') after_com = 1;
      if (str[nc] == '\n') after_cont = after_com = 0;
      if (after_cont && after_com) str[nc] = ' ';
  }

  nc = nt = nn = nd = nv = ncm = npv = ndim = 0;

/* initial whitespace, type, whitespace */
  while ((str[nc] == ' ') || (str[nc] == '\t')) { ++nc; }
  while ((str[nc] != ' ') && (str[nc] != '\t')) { typ[nt++] = str[nc++]; }
  typ[nt] = '\0';
  while ((str[nc] == ' ') || (str[nc] == '\t')) { ++nc; }
/* name, whitespace, dimension? */
  while ((str[nc] != ' ') && (str[nc] != '\t') && (str[nc] != '(' )
         && (nc < strlen(str))) { var[nn] = str[nc]; nam[nn++] = str[nc++]; }
  while ((str[nc] == ' ') || (str[nc] == '\t')
         && (nc < strlen(str))) { ++nc; }
  if (str[nc] == '(') {  /* have a dimensioned array */
    ndim = 1;
    /* get dimension */
    while (str[++nc] != ')') { dim[nd++] = str[nc] ;}
    nc++;
  }
/* skip over value(s) to comment */
  got_token = 0;
  while ((str[nc] != '!') && (nc < strlen(str))) {
    values[npv] = str[nc];
    if ((values[npv] != ' ') && (values[npv] != '\t')) got_token++;
    if (got_token != 0) npv++;   /* start building values only when token is encountered */
    nc++;
  }
/* trim trailing blanks from values */
  got_token = 0;
  for (ii=npv-1;ii>=0;ii--) {
    if ((values[ii] != ' ') && (values[ii] != '\t')) got_token++;
    if (got_token == 0) npv=ii;
  }
  values[npv] = '\0';
/* comment */
  while (((str[nc] == '!') || (str[nc] == '\t'))
         && (nc < strlen(str))) { ++nc; }
  while (nc <= strlen(str)) { com[ncm++] = str[nc++]; }
/* terminate (or, if empty, zero out) the strings */
  nam[nn] = '\0';
  var[nn] = '\0';
  dim[nd] = '\0';
  if (!internal_mode) ndim = strtol(dim,(char**)NULL,0); /* nd returns as dimension */
  nv = nn;
  com[ncm] = '\0';
  stlower(typ);
  stlower(nam);
}

/*****************************************************************************/
yywrap()
{
return (1);
}

/*****************************************************************************/
doheaders()
{

  /* Fortran include file for declarations */
  strcpy(fname,dbname);
  if (!internal_mode) {
    strcat(fname,"_db.inc");
  } else {
    strcat(fname,"_dst.inc");
  }
  finc = fopen(fname, "w");
  finc_original = finc;
  fprintf(finc,"*\n***   dbin v%d Fortran include file ***\n",idbin_version);
  fprintf(finc,"***   Database %s \n*\n",dbname);
  fprintf(finc,"      integer idbin_version   ! dbin version number\n");
  fprintf(finc,"      parameter (idbin_version = %d)\n*\n",idbin_version);
  fprintf(finc,"      character*(*) dbin_%s_dbvsn ! database version number\n",
          dbname);
  fprintf(finc,"      parameter (dbin_%s_dbvsn  = '%s')\n",dbname,dbin_dbvsn);

  /* Fortran read routine */
  strcpy(fname,dbname); strcat(fname,"_read.F");
  if (internal_mode) strcpy(fname,"/dev/null");
  frdf = fopen(fname, "w");
  fprintf(frdf,"      subroutine %s_read(fname)\n",dbname);
  fprintf(frdf,"*\n***   Database read routine ***\n*\n");
  fprintf(frdf,"*\n*       Generated automatically using the dbin tool.\n*\n");
  fprintf(frdf,"*       Not to be modified by user.\n*\n");
  fprintf(frdf,"      implicit none\n");
  fprintf(frdf,"      character*(*) fname\n");
  fprintf(frdf,"C\n");
  comheadf(frdf);
  fprintf(frdf,"      logical end_of_file\n");
  fprintf(frdf,"      integer index_for\n");
  fprintf(frdf,"      external index_for\n");
  fprintf(frdf,"      integer istat, inum, index, i, ndim\n");
  fprintf(frdf,"      character previous_varname*(db_chlen)\n");
  fprintf(frdf,"      save previous_varname\n");
  fprintf(frdf,"      data previous_varname/'Empty'/\n");
  fprintf(frdf,"      integer MAXNUM_DBINERRORS\n");
  fprintf(frdf,"      parameter (MAXNUM_DBINERRORS = 10)\n");
  fprintf(frdf,"      integer num_dbinerrors\n");
  fprintf(frdf,"*\n");
  fprintf(frdf,"      call %s_init\n",dbname);
  fprintf(frdf,"  100 call dbin_getrec(fname,end_of_file,istat)\n");
  fprintf(frdf,"      if (end_of_file) goto 999\n");
  /* Handling of error message from dbin_getrec */
  fprintf(frdf,"       if (istat.ne.0) then\n");
  fprintf(frdf,"          num_dbinerrors = num_dbinerrors + 1\n");
  fprintf(frdf,"          if (istat .eq. 2) then \n");
  fprintf(frdf,"            print *, ' Probably filename error, Stop '\n");
  fprintf(frdf,"            stop\n"); 
  fprintf(frdf,"          else \n");
  fprintf(frdf,"            print *, ' Unknow error  in DBIN, istat = ', istat\n");
  fprintf(frdf,"          end if\n");
  fprintf(frdf,"          if (num_dbinerrors .ge. MAXNUM_DBINERRORS) then\n");
  fprintf(frdf,"           print *, ' Maximum number of error reached, stop '\n");
  fprintf(frdf,"           stop\n");
  fprintf(frdf,"          else \n");
  fprintf(frdf,"           goto 100\n");
  fprintf(frdf,"          end if\n");
  fprintf(frdf,"      end if\n");
  fprintf(frdf,"*     \n");
/* Checking now the group rule: if the varname changed, the index must be */   
/* set to 1 to start filling a new array of structures. */ 
  fprintf(frdf,"      if((previous_varname .ne. varname) .and.\n");
  fprintf(frdf,"     &    (n_instance .ne. 1)) then\n");
  fprintf(frdf,"        print*, ' Fatal error in DBIN read : '\n");
  fprintf(frdf,"        print*, ' Unexpected change of Data structure name '\n");
  fprintf(frdf,"        print*, ' Previous Data structure ', previous_varname\n");
  fprintf(frdf,"        print*, ' Current Data structure ', varname\n");
  fprintf(frdf,"        print*, ' Index to struct. array = ', n_instance\n");
  fprintf(frdf,"        stop\n");
  fprintf(frdf,"      else \n");
  fprintf(frdf,"        previous_varname = varname\n");
  fprintf(frdf,"      end if \n");
  fprintf(frdf,"      if (varname.eq.'fake_name') then ! match name\n");

  /* C include file */
  strcpy(fname,dbname);
  if (!internal_mode) {
    strcat(fname,"_db.h");
  } else {
    strcat(fname,"_dst.h");
  }
  fh = fopen(fname, "w");
  fh_original = fh;
  fprintf(fh,"/***   dbin v%d C include file ***/\n",idbin_version);
  fprintf(fh,"/***   Database %s   ***/\n",dbname);
/*   fprintf(fh,"#ifndef %s_H\n",dbname);   */
/*   fprintf(fh,"#define %s_H\n\n",dbname); */
  fprintf(fh,"#include <string.h>\n");
  /* fprintf(fh,"extern \"C\" {\n"); */
  fprintf(fh,"static const int dbin_version=%d;   /* dbin version number */\n",
          idbin_version);
  fprintf(fh,"static const char* dbin_%s_dbvsn=\"%s\";  /* db version number */\n",
          dbname,dbin_dbvsn);
  /* fprintf(fh,"}\n"); */

  /* C read routine */
  strcpy(fname,dbname); strcat(fname,"Read.c");
  if (internal_mode) strcpy(fname,"/dev/null");
  frdc = fopen(fname, "w");
  fprintf(frdc,"/***  Database read routine  ***/\n");
  fprintf(frdc,"/***    Generated automatically using the dbin tool. */\n");
  fprintf(frdc,"/***    Not to be modified by user. */\n");
  fprintf(frdc,"#include <stdio.h>\n");
  comheadc(frdc);
  /* fprintf(frdc,"#include \"%sGlobal.h\"\n",dbname); */
  fprintf(frdc,"void dbin_getrec(char* fname[],void (*)(void));\n");
  fprintf(frdc,"void %s_interpret();\n",dbname);
  fprintf(frdc,"void %sInit();\n",dbname);
  fprintf(frdc,"void getmembers(long);\n\n",dbname);
  /* fprintf(frdc,"extern \"C\"{\n"); */
  fprintf(frdc,"void %sRead(char* fname)\n{\n",dbname);
  fprintf(frdc,"  void (*pf)(); /* pointer to interpreter */\n");
  fprintf(frdc,"  pf = &%s_interpret;\n",dbname);
  fprintf(frdc,"  %sInit();\n",dbname);
  fprintf(frdc,"  dbin_getrec(&fname,pf);\n",dbname);
  fprintf(frdc,"}\n");
  if (cray)
    fprintf(frdc,"void %READ(char* fname)\n{\n",stupper(dbname));
  else
    fprintf(frdc,"void %sread_(char* fname)\n{\n",stlower(dbname));
  fprintf(frdc,"  *(strstr(fname,\" \"))='\\0';\n");
  fprintf(frdc,"  %sRead(fname);\n}\n",dbname);
  /* fprintf(frdc,"}\n");  for extern "C" */
  fprintf(frdc,"void %s_interpret()\n{\n",dbname);
  fprintf(frdc,"int inum, index, i, ndim, iok;\niok=0;\n");

  /* Fortran init routine */
  strcpy(fname,dbname); strcat(fname,"_init.F");
  if (internal_mode) strcpy(fname,"/dev/null");
  finitf = fopen(fname, "w");
  fprintf(finitf,"      subroutine %s_init\n",dbname);
  fprintf(finitf,"*\n***   Database default init routine ***\n*\n");
  fprintf(finitf,"*\n*       Generated automatically using the dbin tool.\n*\n");
  fprintf(finitf,"*       Not to be modified by user.\n*\n");
  fprintf(finitf,"      implicit none\n");
  comheadf(finitf);

  /* C init routine */
  strcpy(fname,dbname); strcat(fname,"Init.c");
  if (internal_mode) strcpy(fname,"/dev/null");
  finitc = fopen(fname, "w");
  fprintf(finitc,"/***  Database default init routine  ***/\n");
  fprintf(finitc,"/***  Generated automatically using the dbin tool. */\n");
  fprintf(finitc,"/***  Not to be modified by user. */\n");
  comheadc(finitc);
  fprintf(finitc,"void %sInit() {\n",dbname);
  
  /* GUI menu definition routine */
  strcpy(fname,dbname); strcat(fname,"GUI.h");
  if (internal_mode) strcpy(fname,"/dev/null");
  fgui = fopen(fname, "w");
  fprintf(fgui,"/***  GUI code for dbin database interaction  ***/\n");
  fprintf(fgui,"/***  Generated automatically using the dbin tool. */\n");
  fprintf(fgui,"/***  Not to be modified by user. */\n");
  fprintf(fgui,"static struct element_keys {\n");
  fprintf(fgui,"  char *name;\n");
  fprintf(fgui,"  struct parameter_definition {\n");
  fprintf(fgui,"    char *name;\n");
  fprintf(fgui,"    char *value_type;\n");
  fprintf(fgui,"    char *comment;\n");
  fprintf(fgui,"  } parameters[MAX_NUM_PARAMETERS];\n");
  fprintf(fgui,"  int num_parameters;\n");
  fprintf(fgui,"  char *parent;\n");
  fprintf(fgui,"} geo_keys[] = {\n");

  /* XDR I/O definition routine for MCFIO package */
  strcpy(fname,dbname); strcat(fname,"XDR.c");
  fxdr = fopen(fname, "w");
  fprintf(fxdr,"/***  XDR code for dbin database I/O  ***/\n");
  fprintf(fxdr,"/***  Generated automatically using the dbin tool. */\n");
  fprintf(fxdr,"/***  Not to be modified by user. */\n");
  fprintf(fxdr,"#include \"%sXDRinc.h\"\n",dbname);
  fprintf(fxdr,"static int *idat, ln, i;\n");
  fprintf(fxdr,"static u_int ui;\n");
  fprintf(fxdr,"static float *dat;\n");
  fprintf(fxdr,"static double *ddat;\n");
  fprintf(fxdr,"static char* xdrstring;\n");
  fprintf(fxdr,"\n");
  
  /* XDR I/O manager routine for MCFIO package */
  strcpy(fname,dbname); strcat(fname,"XDRmgr.c");
  fxdrmgr = fopen(fname, "w");
  fprintf(fxdrmgr,"/***  XDR manager code for dbin database I/O  ***/\n");
  fprintf(fxdrmgr,"/***  Generated automatically using the dbin tool. */\n");
  fprintf(fxdrmgr,"/***  Not to be modified by user. */\n");
  fprintf(fxdrmgr,"#include \"%sXDRinc.h\"\n",dbname);
  fprintf(fxdrmgr,"static int i;\n\n");
  
  /* XDR I/O routine for entire database */
  strcpy(fname,dbname); strcat(fname,"XDRall.c");
  fxdrall = fopen(fname, "w");
  fprintf(fxdrall,"/***  XDR I/O for entire dbin database ***/\n");
  fprintf(fxdrall,"/***  Generated automatically using the dbin tool. */\n");
  fprintf(fxdrall,"/***  Not to be modified by user. */\n");
  fprintf(fxdrall,"#include \"%sXDRinc.h\"\n\n",dbname);
  fprintf(fxdrall,"void %s_xdr_all(XDR* xdrs);\n\n",dbname);
  fprintf(fxdrall,"void %s_xdr_all(XDR* xdrs)\n{\n",dbname);
  
  /* XDR I/O include file for MCFIO package */
  strcpy(fname,dbname); strcat(fname,"XDRinc.h");
  fxdrinc = fopen(fname, "w");
  fprintf(fxdrinc,"/***  XDR include file for dbin database I/O  ***/\n");
  fprintf(fxdrinc,"/***  Generated automatically using the dbin tool. */\n");
  fprintf(fxdrinc,"/***  Not to be modified by user. */\n");
  if (!internal_mode) {
    fprintf(fxdrinc,"#include \"%s_db.h\"\n",dbname);
  } else {
    fprintf(fxdrinc,"#include \"%s_dst.h\"\n",dbname);
  }
  fprintf(fxdrinc,"#include <stdio.h>\n");
  fprintf(fxdrinc,"#include <rpc/types.h>\n");
  fprintf(fxdrinc,"#include <rpc/xdr.h>\n");
  fprintf(fxdrinc,"#include <sys/types.h>\n");
  fprintf(fxdrinc,"#include \"mcfio_Dict.h\"\n");
  fprintf(fxdrinc,"#include \"mcf_xdr.h\"\n");

}

/*****************************************************************************/

docloseout()
{

  fprintf(frdf,"      else\n");
  fprintf(frdf,
    "        print *,'dbin error: unidentified parameter: ',varname\n");
  fprintf(frdf,"      endif\n");
  fprintf(frdf,"      goto 100\n");
  fprintf(frdf,"  999 continue\n");
  fprintf(frdf,"      end\n");

  /*   fprintf(fh,"\n#endif\n"); */

  fprintf(finitf,"      n_templates = %d\n",n_templates);
  fprintf(finitf,"      n_totobjs = %d\n",indxtot);
  fprintf(finitf,"      end\n");
  fprintf(finitc,"}\n");

}

varsave(int idm)
{
    int nch=0;
    int nc = 0;
    while (curname[nc] != '\0') {varlist[nvars++] = curname[nc++];}
    nc = 0;
    while (curname[nc] != '\0') {varlistc[nvarsc++] = curname[nc++];}
    if (idm >= 0) {
        varlist[nvars++] = '(';
        nch=sprintf(&varlist[nvars],"%d",idm+1);
        varlist[nvars+nch] = ')';
        nvars=nvars+nch+1;

        varlistc[nvarsc++] = '[';
        nch=sprintf(&varlistc[nvarsc],"%d",idm);
        varlistc[nvarsc+nch] = ']';
        nvarsc=nvarsc+nch+1;
    }
    varlist[nvars++] = ' ';
    varlist[nvars] = '\0';
    varlistc[nvarsc++] = ' ';
    varlistc[nvarsc] = '\0';
}

close_makes(char *instname) {
    if (internal_mode != 0) {
        if (new_template>0 && strlen(template_size)>0) n_templ_entries++;
    } else {
        n_templ_entries++;
    }
    if (print_listing) printf("close_makes: n_templ_entries %d, new_template %d, mode %d\n",
                              n_templ_entries, new_template,internal_mode);
    if (new_template > 0) {
        fprintf(finitf,"      n_obj_%s=%d\n",curstruct,indx);
        fprintf(finitc,"*n_obj_%s=%d;\n",curstruct,indx);
        
        if (indx<=0) indx=1;
        if (fixed_size > 0) indx = fixed_size;
        if (internal_mode) {
            if (strlen(template_size)>0 || declare_record == 1) {
                if (strlen(template_size)==0) {
                  fprintf(finc,"      integer n_obj_%s\n",instname);
                  fprintf(finc,"      parameter (n_obj_%s=1)\n",instname);
                  fprintf(finc,"      record /%s_s/ %s\n",
                          curstruct,instname);
                  fprintf(finc,
                    "      common /%s_c/ %s\n",instname,instname);
                } else {
                  fprintf(finc,"      integer n_obj_%s\n",instname);
                  /* dummy word to ensure alignment */
                  fprintf(finc,"      integer idm%s\n",instname);
                  fprintf(finc,"      record /%s_s/ %s(%s)\n",
                          curstruct,instname,template_size);
                  fprintf(finc,
                    "      common /%s_c/\n     +  n_obj_%s, idm%s, %s\n",
                          instname,instname,instname,instname);
                }
            }
        } else {
            fprintf(finc,"      integer n_obj_%s\n",curstruct);
            /* dummy word to ensure alignment */
            fprintf(finc,"      integer idm%s\n",instname);
            fprintf(finc,"      record /%s_s/ %s(%d)\n",
                    curstruct,instname,indx);
            fprintf(finc,"      common /%s_c/\n     +  n_obj_%s, idm%s, %s\n",
                    instname,instname,instname,instname);
        }
        if (strlen(template_size)>0 || declare_record ==1) {
            fprintf(fxdrinc,"int %s_xdr_io(XDR* xdrs);\n",instname);
            fprintf(fxdrall,"%s_xdr_io(xdrs);\n",instname);
            fprintf(fxdrmgr,"int %s_xdr_io(XDR* xdrs)\n{\n",instname);
            fprintf(fxdrmgr,"  (void) xdr_int(xdrs,n_obj_%s);\n",instname);
            if (strlen(template_size)>0)
              fprintf(fxdrmgr,"  for (i=0;i<*n_obj_%s;i++)\n",instname);
            else
              fprintf(fxdrmgr,"  i=0;\n");
            fprintf(fxdrmgr,"    if (!xdr_%s(xdrs,&%s[i])) return 0;\n",
                    curstruct,instname);
            fprintf(fxdrmgr,"  return 1;\n}\n\n");
        }
        if (n_templ_entries == 1 || declare_record == 1) {
            /* fprintf(fh,"extern \"C\" {\n"); */
            if (internal_mode) {
                if (strlen(template_size)>0 || declare_record == 1) {
                    fprintf(fh,"extern struct %s_c {\n",instname);
                    fprintf(fh,"  int n_obj_%s;\n",instname);
                    fprintf(fh,"  int idm%s;\n",instname);
                    fprintf(fh,"  %s_s %s[1];\n",curstruct,instname);
                    if (cray) {
                        fprintf(fh,"} %s_C;\n",stupper(instname));
                        fprintf(fh,"static int *n_obj_%s = &(%s_C.n_obj_%s);\n",
                                instname,stupper(instname),instname);
                        fprintf(fh,"static %s_s *%s = &%s_C.%s[0];\n",
                                curstruct,stupper(instname),instname,instname);
                    } else {
                        fprintf(fh,"} %s_c_;\n",stlower(instname));
                        fprintf(fh,"static int *n_obj_%s = &(%s_c_.n_obj_%s);\n",
                                instname,stlower(instname),instname);
                        fprintf(fh,"static %s_s *%s = &%s_c_.%s[0];\n",
                                curstruct,stlower(instname),instname,instname);
                    }
                }
            } else {
                fprintf(fh,"extern struct %s_c {\n",instname);
                fprintf(fh,"  int n_obj_%s;\n",instname);
                fprintf(fh,"  int idm%s;\n",instname);
                fprintf(fh,"  %s_s %s[1];\n",curstruct,instname);
                if (cray) {
                        fprintf(fh,"} %s_C;\n",stupper(instname));
                        fprintf(fh,"static int *n_obj_%s = &(%s_C.n_obj_%s);\n",
                                instname,stupper(instname),instname);
                        fprintf(fh,"static %s_s *%s = &%s_C.%s[0];\n",
                                curstruct,stupper(instname),instname,instname);
                    } else {
                        fprintf(fh,"} %s_c_;\n",stlower(instname));
                        fprintf(fh,"static int *n_obj_%s = &(%s_c_.n_obj_%s);\n",
                                instname,stlower(instname),instname);
                        fprintf(fh,"static %s_s *%s = &%s_c_.%s[0];\n",
                                curstruct,stlower(instname),instname,instname);
                    }
            }
        }
        indx = 0;
        new_template = 0;
    }
}

comheadf(FILE *fl) {
  fprintf(fl,"#include \"%s_db.inc\"\n",dbname);
  fprintf(fl,"#include \"dbin.inc\"\n");
}

comheadc(FILE *fl){
  fprintf(fl,"#include \"%s_db.h\"\n",dbname);
  fprintf(fl,"extern int n_instance;\n");
  fprintf(fl,"extern double dvar[100];\n");
  fprintf(fl,"extern float rvar[100];\n");
  fprintf(fl,"extern int nvars;\n");
  fprintf(fl,"extern char chvar[20][80];\n");
  fprintf(fl,"extern char varname[80], objname[80];\n");
}

nam2var(){
  int i, ln;
  strcpy(curvarc,curvar);
  /* C variable name */
  strcpy(curvarc,curstruct);
  ln = strlen(curvarc);
  curvarc[ln] = '.';
  i=0; while (i<nv) {curvarc[ln+1+i]=curvar[i];i++;}
  curvarc[ln+1+nv] = '\0';
  /* Fortran variable name */
  curvar[nv++] = '_';
  strcpy(curvar+nv,curstruct);
  curvar[ln+1+nv] = '\0';
}

getpath(char* dbfile) {
  int lnpath;
  char* froot;
  froot = strrchr(dbfile,'/');
  if (froot==NULL) {froot = dbfile;} else {froot = froot +1;}
  lnpath = strlen(dbfile) - strlen(froot);
  strncpy(dbpath,dbfile,lnpath);
  dbpath[lnpath]='\0';
  printf("Database file %s, path %s\n",froot,dbpath);
}

char * stlower(char* st) {
  int i=0;
  while (st[i] != '\0') {
    if (st[i] >= 'A' && st[i] <= 'Z') st[i] = st[i] + 'a' - 'A';
    i++;
  }
  return st;
}

char * stupper(char* st) {
  int i=0;
  while (st[i] != '\0') {
    if (st[i] >= 'a' && st[i] <= 'z') st[i] = st[i] + 'A' - 'a';
    i++;
  }
  return st;
}

void strsub(char* str, char* sub, char* repl)
{
/* for each char in sub that appears in str, substitute repl */
/* do it without doing a malloc for a new string, cuz I said so */
int i, j, k, l, ioff=0;
for (i=0;i<=strlen(str)+ioff;i++) 
    for (j=0;j<strlen(sub);j++)
        if (str[i]==sub[j])
            for (k=0;k<strlen(repl);k++)
                {
                    if (k>0)
                        for (l=strlen(str)+ioff+k;l>=i;l--)
                            str[l+1]=str[l];
                    str[i] = repl[k];
                    i++; ioff++;
                }
}
/*
** Added by P.L., to recover gracefully if one attempts to start a template
** without decalring a database. 
*/
void check_finc_fh()
{
    if ((finc == NULL) || (fh == NULL)) {
      printf("DBin error: Uninitialized file descriptor \n");
      printf("            Probable cause: missing database declaration \n");
      printf("            Ending dbin here! \n");
      exit(2);
      }
}  
