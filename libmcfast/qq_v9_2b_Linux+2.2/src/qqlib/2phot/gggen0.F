*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/20 12/08/91  11.31.57  by  R.A.FULTON
*CMZ :  1.03/15 24/05/91  10.04.24  by  R.A.FULTON
*-- Author :   R.A.FULTON
      SUBROUTINE GGGEN0
C*******************************************************************
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/ggmodl.inc"
C            Most information is past between the GGGENx routine using
C            the GENARG common block.
#include "qqlib/gggseq/genarg.inc"
C**********************************************************
C generate photons....photon energy spectrum is cheated to include
C                     energy dependence of photon-photon interaction.
C
      CALL GGGEN(.FALSE.)
C
      IF(ELEC2G)THEN
        CALL ELONLY
        GOTO 9000
      ENDIF
      IF(MODE2G .EQ. 0)THEN
C       CMS
        GOTO 9000
      ELSEIF(MODE2G .EQ. 1)THEN
C       Lepton Pair
        CALL GGGEN1
      ELSEIF(MODE2G .EQ. 2)THEN
C       Meson Pair
        CALL GGGEN2
      ELSEIF(MODE2G .EQ. 3)THEN
C       Resonance
        CALL GGGEN3
      ELSEIF(MODE2G .EQ. 4)THEN
C       Idontknow
        WRITE(*,'(''  MODEGG = 4 not implemented '')')
        STOP
      ELSEIF(MODE2G .EQ. 5)THEN
C       Multi-hadron
        WRITE(*,'(''  MODEGG = 5 not implemented '')')
        STOP
      ENDIF
C
C  end of generation...all models exit GGGEN0 from here
C
 9000 OK2G = OK2G + 1.
      RETURN
      END
