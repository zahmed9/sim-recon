*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:52  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/04  20:58:52  zfiles
* first version of seq in CVS
*
*
*CMZ :  1.02/29 01/12/92  15.00.03  by  Nobu Katayama
*CMZ :  1.01/86 28/02/91  17.46.36  by  Karen Lingel, Physicist
*CMZ :  1.01/36 05/02/90  17.04.00  by  Nobu Katayama
*-- Author :
C     CLEO-I COMMON block for storing logical unit numbers and flags
C     This INCLUDE file is a relic from the PDP-11 online data acquisition
C     system, which was carried over to the offline data analysis.
C     Many of the flags have not been used for ten years.
C
C     NBM:1/19/83:ADDED /CLUNS/STAFLG FOR PRINTOUT OF STATUS
C
C       27-AUG-86 RMN  ADDED LUNMTI, LUNMTO FOR MTIN, MTOUT
C
* LUNIN  - Tape or disk logical unit for event input
* LUNOUT - Tape or disk logical unit for event output
* LUNLPT - Line printer logical unit
* LUNTTY - Terminal logical unit (superceded by LUNTTI, LUNTTO below)
* LUNTMP - Logical unit for temporarily opened files
*
*   These detector-oriented logical flags originally were used to
*   tag whether detector diagnostics should be spewed in the online
*   program (the PDP-11 debugger was too primitive to be used)
*
* DRFLG  - Drift chamber diagnostic flag
* IZFLG  - Inner Z chamber diagnostic flag
* ESFLG  - Endcap shower chamber diagnostic flag
* OZFLG  - Outer Z chamber diagnostic flag
* TRFLG  - Trigger diagnostic flag
* DXFLG  - DEDX chamber diagnostic flag
* TFFLG  - Time of flight counter diagnostic flag
* RSFLG  - Rutgers shower chamber diagnostic flag
* CSFLG  - Cerenkov shower chamber diagnostic flag
* LMFLG  - Luminosity monitor diagnostic flag
* MUFLG  - Muon chamber diagnostic flag
* ONLF1  - ??
* WTFLG  - Output event writing is enabled (logical flag)
* MTAFLG - Writing to magtape is enabled (logical flag)
* AUTOUT - Automatically print LOG file at end of run (online flag)
* DETFLG - Flag indicates whether job is running detached
* MAFLG  - Match program diagnostic flag
* STAFLG - Should status be printed out at end of run?
*
*   Improved assignment of logical units
*
* LUNTTI - Logical unit for terminal keyboard input
* LUNTTO - Logical unit for terminal screen output
* LUNMTI - Tape or disk logical unit for input
* LUNMTO - Tape or disk logical unit for output
C
      LOGICAL   DRFLG , IZFLG , ESFLG , OZFLG , TRFLG , DXFLG , TFFLG ,
     1          RSFLG , CSFLG , LMFLG , MUFLG , ONLF1 , WTFLG , MTAFLG,
     2          AUTOUT, DETFLG, MAFLG , STAFLG
C
      INTEGER   LUNIN , LUNOUT, LUNLPT, LUNTTY, LUNTMP, LUNTTI, LUNTTO,
     1          LUNMTI, LUNMTO
C
      COMMON /CLUNS/ LUNIN , LUNOUT, LUNLPT, LUNTTY, LUNTMP, DRFLG ,
     1               IZFLG , ESFLG , OZFLG , TRFLG , DXFLG , TFFLG ,
     2               RSFLG , CSFLG , LMFLG , MUFLG , ONLF1 , WTFLG ,
     3               MTAFLG, AUTOUT, DETFLG, MAFLG , STAFLG,
     4               LUNTTI, LUNTTO, LUNMTI, LUNMTO
      SAVE   /CLUNS/
