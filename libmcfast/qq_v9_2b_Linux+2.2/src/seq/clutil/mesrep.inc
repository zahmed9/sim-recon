*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:52  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/04  20:58:42  zfiles
* first version of seq in CVS
*
*
*CMZ :  1.01/02 17/05/89  12.23.45  by  CLEO II Librarian
*-- Author :    R. Namjoshi   18/07/88
*
* MSSUCC - Message severity is SUCCESS
* MSINFO - Message severity is INFORMATION
* MSWARN - Message severity is WARNING
* MSERRO - Message severity is ERROR
* MSFATA - Message severity is FATAL  -- Skips current event
* MSABOR - Message severity is ABORT  -- Aborts the job
* CHMESS - Text of current message
*
      CHARACTER*(*) MSSUCC,             MSINFO
      PARAMETER(    MSSUCC = 'SUCCESS', MSINFO = 'INFORMATION' )
      CHARACTER*(*) MSWARN,             MSERRO
      PARAMETER(    MSWARN = 'WARNING', MSERRO = 'ERROR'       )
      CHARACTER*(*) MSFATA,             MSABOR
      PARAMETER(    MSFATA = 'FATAL'  , MSABOR = 'ABORT'       )
*
      CHARACTER*132   CHMESS
      COMMON /MESREP/ CHMESS
*
