      subroutine mcp_help

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Type out the help text when the user types "mcfast -h"
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
 5000 format(//
     *'This is the fast Monte Carlo "mcfast". It is executed by ',
     *'typing'/
     */
     *'        mcfast [-f command_file] [-l lpt_file] [-hb Hbook_file]'/
     */
     *'where  command_file = name of file containing job directives'/
     *'       lpt_file     = name of ASCII output file'/
     *'       Hbook_file   = name of output Hbook file'/
     */
     *'Note: if the command file is not specified, mcfast accepts'/
     *'directives from the terminal, terminated by a ^D (end of file).'/
     *'This is very convenient when running multiple jobs in batch.'/
     */
     *'You can get online help on running mcfast by typing'/
     */
     *'        mcfast -h'/
     */
     *'with no other arguments.'/
     */
     *'During execution, mcfast checks the user''s terminal every'/
     *'event to see if anything has been typed. Commands can be'/
     *'abbreviated to the minimum necessary for uniqueness. Type'/
     *'"help" during execution to get a list of commands. Note'/
     *'that if you type "user", the routine usr_command is'/
     *'called. You can provide this routine to print out any'/
     *'information you want while the program is running.')

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:51  garren
c add hooks to initialize user trigger code
c
