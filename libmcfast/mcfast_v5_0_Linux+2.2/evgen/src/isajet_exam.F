      subroutine evgen_start
C
C     JTDKY = +/- unit number for decay table file.
C                 If it is negative, decay table is not printed.
C     JTEVT = +/- unit number for output event file.
C                 If it is negative, only stable particles are written on it.
C     JTCOM =     unit number for command file.
C     JTLIS =     unit number for listing.
C
      IMPLICIT NONE
C
#include "stdhep.inc"
#include "stdlun.inc"
#include "file_names.inc"
#include "qq_flag.inc"
C
      COMMON/ITAPES/ITDKY,ITEVT,ITCOM,ITLIS
      INTEGER   ITDKY,ITEVT,ITCOM,ITLIS
      COMMON/IDRUN/IDVER,IDG(2),IEVT,IEVGEN
      INTEGER   IDVER,IDG,IEVT,IEVGEN
      COMMON/PRIMAR/NJET,SCM,HALFE,ECM,IDIN(2),NEVENT,NTRIES,NSIGMA
      INTEGER   NJET,IDIN,NEVENT,NTRIES,NSIGMA
      REAL      SCM,HALFE,ECM
      COMMON/ISLOOP/NEVOLV,NFRGMN,IEVOL,IFRG
      INTEGER NEVOLV,NFRGMN,IEVOL,IFRG
      SAVE /ITAPES/,/IDRUN/,/PRIMAR/,/ISLOOP/
      COMMON/PRTOUT/NEVPRT,NJUMP
      SAVE /PRTOUT/
      INTEGER   NEVPRT,NJUMP
C
C...   local variables
      INTEGER NQUARK,LQUARK(50)
      INTEGER LOK,IKEEP,ISEED,NH1,NDIF,istream,maxev
      INTEGER JTDKY,JTEVT,JTCOM,JTLIS,IFL,ILOOP,INDEC
      DOUBLE PRECISION SEED
      CHARACTER*132 ISADEC
      LOGICAL OK,DONE

      data maxev/10000/

      SAVE ILOOP,JTDKY,JTEVT,JTCOM,JTLIS,istream

      EXTERNAL ALDATA
C
C          Initialize ISAJET
C
      JTDKY=-1
      JTEVT=-2
      JTCOM=21
      JTLIS=22
C initialize HEP logical units
      LNHWRT=23
      LNHRD=0
      LNHDCY=0
      LNHOUT=JTLIS

C set file names if blank
      if(file_input .eq. ' ')   file_input = 'isajet_exam.isa'
      if(file_lpt .eq. ' ')     file_lpt = 'isajet_exam.lpt'
      if(file_evt_wrt .eq. ' ') file_evt_wrt = 'isajet_exam.evt'

C  point to standard decay tables
      CALL GETENV( 'ISAJET_DECAY', ISADEC)
      IF(ISADEC.EQ.' ')THEN
        CALL GETENV( 'ISAJET_DIR', ISADEC )
        IF ( ISADEC .EQ. ' ' ) THEN
           ISADEC = 'isadecay.dat'
        ELSE
           INDEC   = INDEX ( ISADEC , ' ' ) - 1
           ISADEC  = ISADEC(:INDEC) // '/isadecay.dat'
        ENDIF
      ENDIF

C open files
      open(unit=1,file=isadec,status='old',err=9991)
      open(unit=jtcom,file=file_input,status='old',err=9992)
      open(unit=jtlis,file=file_lpt,status='new',err=9993)
C...   Open the event output file 
      call stdxwinit(file_evt_wrt,'EVGEN with Isajet and QQ',
     1               maxev,istream,lok)
      if(lok.ne.0) go to 9994

C call initialization
      CALL ISAINI(JTDKY,JTEVT,JTCOM,JTLIS)
C book histograms
      CALL bookhistos
C set random number seed
      call get_ranseed_from_time(ISEED)
      SEED = ISEED
      CALL RANFST(SEED)
C initialize QQ if appropriate
      if(lqq) call STDQQUSET
C
C          Read instructions; terminate for STOP command or error.
C
 201  IFL=0
      CALL ISABEG(IFL)
      IF(IFL.NE.0)THEN

C... call user's end-of-job routine
        call usr_end_job

        CALL HRPUT(0,file_hbk,'N')

C...print histograms
        CALL HOUTPU(LNHOUT)
        CALL HISTDO
      ENDIF
      IF(IFL.NE.0) STOP

C          Write begin-run record
      CALL STDFLISXSEC
      CALL stdxwrt(100,istream,lok)
C
C          Event loop
C
      ILOOP=1
 301  CONTINUE
C        Generate one event - discard if .NOT.OK
      CALL ISAEVT(ILOOP,OK,DONE)
      IF(OK)THEN
C
        CALL ISAHEP(1)
        NH1 = NHEP
C
        call usr_filter_preqq(IKEEP)

C
C...do we want to keep this event?
        IF(IKEEP.EQ.1)THEN


C...      do QQ decay
C...      search HEPEVT list for particles which QQ can decay
C...      one by one, decay these particles and add the results to the
C...      HEPEVT common
          if(lqq) CALL STDDECAYQQ

          CALL STDFLISXSEC
C...do we want to keep this event?
          call usr_filter_postqq(IKEEP)
          IF(IKEEP.EQ.1)THEN
            IF(ILOOP.LE.NEVPRT) CALL HEPLST(1)
C...
            CALL STDQUARKLST(5,NQUARK,50,LQUARK)
            CALL HF1(1,FLOAT(NQUARK)+0.5,1.0)                
            CALL HFILL(2,FLOAT(NHEP)+0.5,0.,1.0)
            if(lqq)then
              NDIF = NHEP - NH1
              CALL HFILL(3,FLOAT(NH1)+0.5,0.,1.0)
              CALL HFILL(4,FLOAT(NDIF)+0.5,0.,1.0)
            endif
            call usr_end_event

C...   Write the event to disk
            CALL stdxwrt(1,istream,lok)
            ILOOP=ILOOP+1
          ENDIF
        ENDIF
      ENDIF
      IF(.NOT.DONE) GO TO 301
C
C          Calculate cross section and luminosity
C
      CALL ISAEND
C          Write end-of-run record
      CALL STDFLISXSEC
      call stdxwrt(200,istream,lok)
C...   Close up shop
      call stdxend(istream)
      GO TO 201

c     Come here if error opening isajet decay file
9991  write(6,5001) isadec
5001  format('Error opening isajet decay file ',a)
      stop

c     Come here if error opening input command file
9992  write(6,5002) file_input
5002  format('Error opening input command file file ',a)
      stop

c     Come here if error opening output print file
9993  write(6,5003) file_lpt
5003  format('Error opening output print file ',a)
      stop

c     Come here if error opening output event file
9994  write(6,5004) file_evt_wrt
5004  format('Error opening output event file ',a)
      stop

      END

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.8  1998/06/25 15:49:00  bphyslib
c add all necessary changes from v3_3
c
