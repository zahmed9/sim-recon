      subroutine mcp_set_readtype(status)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Check to see if we have data or sufficient info to generate events
c   internally and set the flag mcp_read_data.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "mcp_params.inc"
#include "gnr_params.inc"

c     Caling argument
      integer status

c     Local variables
      integer nsig, nback
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call dtf_number(1, nsig)
      call dtf_number(2, nback)

      mcp_read_data = (nsig+nback) .gt. 0

      if(mcp_read_data) then
        write(6,5001) nsig, nback
 5001   format(/'Total of ',i3,' signal files and ',i3,' background ',
     *          'files to process.')
        status = 0

      else

        if( gnr_ntype .eq. 0) then
           write(6,5002)
           write(mcp_llpt,5002)
 5002      format(//'No data files to read and no particles to ',
     *              'generate internally. Quitting...')
           status = 1

        else
           write(6,5003)
           write(mcp_llpt,5003)
 5003      format(72('*'),
     *            /'No data files present. Data will be generated ',
     *             'internally by mcfast.', /,72('*'))
           status = 0

        endif

      endif

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:56  garren
c add hooks to initialize user trigger code
c
