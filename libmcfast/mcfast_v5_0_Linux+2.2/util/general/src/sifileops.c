/*  VAX/DEC CMS REPLACEMENT HISTORY, Element SIFILEOPS.C
*  *7    27-JUN-1994 09:54:36 LSEXTON "Fix compiler error"
*  *6    24-JUN-1994 15:42:30 LSEXTON "Fix memory leak"
*  *5    24-JUN-1994 15:26:04 LSEXTON "Routines rewriten by Randy also add SIDELE"
*  *4    12-MAY-1994 14:45:41 MARKL "Incorporate sirena."
*  *3     8-NOV-1993 16:03:56 MARKL "Changing long names to short."
*  *2    12-SEP-1991 14:28:16 FLAVIA "Implement for IRIX"
*  *1    15-JUL-1991 11:50:29 TROEMEL "AIX file ops library"
*  VAX/DEC CMS REPLACEMENT HISTORY, Element SIFILEOPS.C
*	=======================================================
*	S_I$Library - S_I C language equivalent file operations
*	=======================================================
*
*	Language:-
*	==========
*       C Language
*
*	Modulename:-
*	============
*	S_I$CMS:SIFILEOPS.C
*
*	Description:-
*	=============
*	This library contains a Special UNIX Utility Subroutine
*	for the CDF Packages. The following Subroutines are included:-
*
*	SIFLOP		Open a C language stream file
*			Accepts an integer and two character string arguments:
*			   [1]: integer to contain a FILE *.
*			   [2]: The file name
*			   [3]: The I/O mode, e.g. 'r', 'w', 'w+', 'rw'
*				See `man fopen' or VAX C RTL equivalent.
*
*	SIFLRD		Reads from stream file into a buffer
*			Accepts the following areguments:
*			   [1]: integer containing a FILE *.
*			   [2]: buffer area (not a character string)
*				Use %REF(character_string)
*			   [3]: integer record length expected
*			   [4]: integer to contain amount actually read
*			   [5]: integer: 0 for fread, 1 for fgets
*
*	SIFLWT		Write to stream file from a buffer
*			Accepts the following areguments:
*			   [1]: integer containing a FILE *.
*			   [2]: buffer area (not a character string)
*				Use %REF(character_string)
*			   [3]: integer record length to be written
*			   [4]: integer to contain amount actually written
*				less line termination for fputs mode.
*			   [5]: integer: 0 for fwrite, 1 for fputs
*
*	SIFLCL		Close a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*
*	SIFLSH		Flush a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*
*	SIFEOF		Check for EOF on a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*
*	SIFERR		Check for ERROR on a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*
*	SIFCER		Clears ERROR indication on a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*			N.B. This is a subroutine; there is no return value.
*
*	SISEEK		Seek a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*			   [2]: integer containing positioning amount
*			   [3]: integer containing positioning method
*
*	SITELL		Determine current position of a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*
*	SISIZE		Determine the current size of a file
*			N.B. file may need to be closed to get correct size.
*			Accepts a character string argument:
*			   [1]: A file name
*
*	SIFSIZ		Determine the current size of a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a FILE *.
*
*	SISLEP		Close a C language stream file
*			Accepts an integer:
*			   [1]: integer containing a number of seconds to sleep
*
*	SIRENA		Renames a file (due to VAX semantics, the file
*			should be closed)
*			Accepts two character string arguments:
*			   [1]: The current name for the file.
*			   [2]: The new name for the file.
*
*	SIDELE		Deletes a file (due to VAX semantics, the file
*			should be closed)
*			Accepts a character string argument:
*			   [1]: The name for the file.
*
*	Author:-
*	========
*	Randolph J. Herber
*	CD/OSS for CDF
*	Fermilab
*
*	Creation Date : 23 Jun 1994  (Total rewrite)
*	===========================
*
**********************************************************************/

/*********************************************************************
* C preprocessing to include system headers, etc.
*
*
**********************************************************************/

#include <stdio.h>
#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)
#include <sys/types.h>
#include <string.h>
#include <malloc.h>
#include <sys/stat.h>
#else
#ifdef VAX
#include ssdef
#include string
#include stdlib
#include stat
#include <descrip.h>
#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Internal service routines
*
*
**********************************************************************/

static int
fortstrlen(char *str, int dcllen)
{
	register len = dcllen;
	if(dcllen >= 1) {
		for(--len; len >= 0; --len) {
			if(str[len] != ' ') {
				return len+1;
			}
		}
	}
	return 0;
}

static char *
makeCstr(char *str, int dcllen)
{
	register len = fortstrlen(str,dcllen);
	register char *cp;
	if((cp = (char *) malloc(len+1))) {
		(void) memcpy(cp,str,len);
		cp[len] = '\0';
		return cp;
	}
	return (char *)0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFLOP

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FILENAME	(Character)	File name
	FILEMODE	(Character)	File access mode

	Return Parameters:-
	===================
	FD		(Integer)	FILE *
	SIFLOP		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siflop_(int *FILEp,char *filename,char *filemode,int namelen,int modelen)
{

#else
#ifdef VAX

int
siflop(int *FILEp,struct dsc$descriptor *filenamedv,
	struct dsc$descriptor *filemodedv)
{
	char *filename = filenamedv->dsc$a_pointer;
	char *filemode = filemodedv->dsc$a_pointer;
	int namelen = filenamedv->dsc$w_length;
	int modelen = filemodedv->dsc$w_length;

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*	N.B.: The routine starts in the conditional code above.!
*
**********************************************************************/

	char *name = makeCstr(filename,namelen);
	char *mode = makeCstr(filemode,modelen);
	int  returncode;

	returncode = (*FILEp = (int)fopen(name,mode)) ? 0 : -1;

	free(name);
	free(mode);

	return returncode;
}

/*********************************************************************
*
	Name:-
	=============
	SIFLRD

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *
	BUFFER		(Character)     buffer area (not a character string)
	LRECL		(Integer)	amount to be read
	MODE		(Integer)	mode: 0 - fread, 1 - fgets

	Return Parameters:-
	===================
	NDAT		(Integer)	amount actually read
	SIFLRD		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siflrd_(int *FILEp,char *buffer,int *lrecl,int *ndat,int *mode)

#else
#ifdef VAX

int
siflrd(int *FILEp,char *buffer,int *lrecl,int *ndat,int *mode)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	FILE *fp = (FILE *) *FILEp;

	if(*mode == 1) {
		register char *ptr = fgets(buffer,*lrecl,fp);
		if(ferror(fp)) {
			clearerr(fp);
			*ndat = 0;
			return -1;
		}
		/* ndat is in characters */
		*ndat = strlen(buffer) - 1;  /* exclude trailing \n */
	} else {
		/* ndat is in blocks */
		*ndat = fread(buffer,*lrecl,1,fp);
		if(ferror(fp)) {
			clearerr(fp);
			*ndat = 0;
			return -1;
		}
	}
	if(feof(fp)) {
		*ndat = 0;
		return 1;
	}
	return 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFLWT

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *
	BUFFER		(Character)     buffer area (not a character string)
	LRECL		(Integer)	amount to be written
	MODE		(Integer)	mode: 0 - fwrite, 1 - fputs

	Return Parameters:-
	===================
	NDAT		(Integer)	amount actually written
	SIFLWT		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siflwt_(int *FILEp,char *buffer,int *lrecl,int *ndat,int *mode)

#else
#ifdef VAX

int
siflwt(int *FILEp,char *buffer,int *lrecl,int *ndat,int *mode)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	FILE *fp = (FILE *) *FILEp;

	if(*mode == 1) {
		char *cp = (char *)malloc(*lrecl+2);
		register int actlen;
		if(!cp) {
			*ndat = 0;
			return -1;
		}
		strncpy(cp,buffer,*lrecl);
		actlen = strlen(cp);
		cp[actlen] = '\n';
		cp[actlen+1] = '\0';
		(void) fputs(cp,fp);
		free(cp);
		if(ferror(fp)) {
			clearerr(fp);
			*ndat = 0;
			return -1;
		}
		/* ndat is in characters */
		*ndat = actlen;
	} else {
		/* ndat is in blocks */
		*ndat = fwrite(buffer,*lrecl,1,fp);
		if(ferror(fp) || *ndat != 1) {
			clearerr(fp);
			*ndat = 0;
			return -1;
		}
	}
	return 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFLCL

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	SIFLCL		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siflcl_(int *FILEp)

#else
#ifdef VAX

int
siflcl(int *FILEp)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	return fclose((FILE *)*FILEp) ? -1 : 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFLSH

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	SIFLSH		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siflsh_(int *FILEp)

#else
#ifdef VAX

int
siflsh(int *FILEp)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	return fflush((FILE *)*FILEp) ? -1 : 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFEOF

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	SIFEOF		(Integer)	0  Not EOF
					1  EOF

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sifeof_(int *FILEp)

#else
#ifdef VAX

int
sifeof(int *FILEp)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	return feof((FILE *)*FILEp) ? 1 : 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFERR

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	SIFERR		(Integer)	0  No error
					1  Error

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siferr_(int *FILEp)

#else
#ifdef VAX

int
siferr(int *FILEp)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	return ferror((FILE *)*FILEp) ? 1 : 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIFCER

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	None

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

void
sifcer_(int *FILEp)

#else
#ifdef VAX

void
sifcer(int *FILEp)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	clearerr((FILE *)*FILEp);
	return;
}

/*********************************************************************
*
	Name:-
	=============
	SISEEK

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *
	OFFSET		(Integer)	positioning amount
	RELATIVE	(Integer)	method:
					   0 -- forward from beginning
					   1 -- from current location
					   2 -- backwards from end

	Return Parameters:-
	===================
	SISEEK		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
siseek_(int *FILEp,int *offset,int *method)

#else
#ifdef VAX

int
siseek(int *FILEp,int *offset,int *method)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	return fseek((FILE *)*FILEp,(long)*offset,*method) ? -1 : 0;
}

/*********************************************************************
*
	Name:-
	=============
	SITELL

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	SITELL		(Integer)	0   Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sitell_(int *FILEp)

#else
#ifdef VAX

int
sitell(int *FILEp)

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/

{
	long pos;
	return ((pos = ftell((FILE *)*FILEp)) == EOF) ? -1 : (int) pos;
}

/*********************************************************************
*
	Name:-
	=============
	SISIZE

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FILENAME	(Character)	File name

	Return Parameters:-
	===================
	SISIZE		(Integer)	>=0 Success
					-1  Generic Failure
					    Usually means no file

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sisize_(char *filename,int filenamelen)
{
	struct stat statbfr;

#else
#ifdef VAX

int
sisize(struct dsc$descriptor *filenamedv)
{
        char *filename = filenamedv->dsc$a_pointer;
        int filenamelen = filenamedv->dsc$w_length;
	stat_t statbfr;
#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*
*
**********************************************************************/
	int returncode;

	char *name = makeCstr(filename,filenamelen);
	returncode = stat(name,&statbfr) ? -1 : statbfr.st_size;
	free(filename);

	return returncode;
}

/*********************************************************************
*
	Name:-
	=============
	SIFSIZ

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FD		(Integer)	FILE *

	Return Parameters:-
	===================
	SIFSIZ		(Integer)	>=0 Success
					-1  Generic Failure
					    Usually means no file

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sifsiz_(int *FILEp)
{
	struct stat statbfr;

#else
#ifdef VAX

int
sifsiz(int *FILEp)
{
	stat_t statbfr;

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*	N.B.: The routine starts in the conditional code above.!
*
**********************************************************************/

	return fstat(fileno((FILE *)*FILEp),&statbfr) ? -1 : statbfr.st_size;
}

/*********************************************************************
*
	Name:-
	=============
	SISLEP

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	SECONDS	(Integer)	Sleep time in seconds

	Return Parameters:-
	===================
	SISLEP	(Integer)	0   Success

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sislep_(int *sleeptime)
{

#else
#ifdef VAX

int
sislep(int *sleeptime)
{

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*	N.B.: The routine starts in the conditional code above.!
*
**********************************************************************/

	sleep(*sleeptime);
	return 0;
}

/*********************************************************************
*
	Name:-
	=============
	SIRENA

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	OLDNAM  (Character)     Old file name
	NEWNAM  (Character)     New file name

	Return Parameters:-
	===================
	SIRENA                  0  Success
	                        -1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sirena_(char *old,char *new,int oldlen,int newlen)
{

#else
#ifdef VAX

int
sirena(struct dsc$descriptor *olddv,struct dsc$descriptor *newdv)
{
	char *old = olddv->dsc$a_pointer;
	char *new = newdv->dsc$a_pointer;
	int oldlen = olddv->dsc$w_length;
	int newlen = newdv->dsc$w_length;

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*	N.B.: The routine starts in the conditional code above.!
*
**********************************************************************/

	char *oldname = makeCstr(old,oldlen);
	char *newname = makeCstr(new,newlen);
	int  returncode;

	returncode = rename(oldname,newname) ? -1 : 0;

	free(oldname);
	free(newname);

	return returncode;
}

/*********************************************************************
*
	Name:-
	=============
	SIDELE

	Description:-
	=============
	This Subprogram is described above.

	Call Parameters:-
	=================
	FILENAME	(Character)	File name

	Return Parameters:-
	===================
	SIDELE		(Integer)	0  Success
					-1  Generic Failure

*/

/*********************************************************************
* C preprocessing to select UNIX or VMS routine coding
*
*
**********************************************************************/

#if defined(sgi) || defined(AIX) || defined(__osf__) || defined(sun) || defined(hpux) || defined(Linux)

int
sidele_(char *filestr,int len)
{

#else
#ifdef VAX

int
sidele(struct dsc$descriptor *filedv)
{
	char *filestr = filedv->dsc$a_pointer;
	int len = filedv->dsc$w_length;

#else
===== Deliberate compiler error:  Definition of symbols needed.
#endif
#endif

/*********************************************************************
* Main body of the routine.
*	N.B.: The routine starts in the conditional code above.!
*
**********************************************************************/

	char *filename = makeCstr(filestr,len);
	int  returncode;

	returncode = remove(filename) ? -1 : 0;

	free(filename);

	return returncode;
}
