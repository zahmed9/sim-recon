      subroutine cmd_getitems(in_string, list_num, list_type,
     *                        list_read, list_item, clist_item, error)

c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c 
c  Parses an input_string into a list of numbers and strings. The read stops
c  at the end of the line or when the "!" comment character is encountered.
c 
c  Inputs
c
c   in_string   character variable
c               Input string we are trying to parse
c
c   list_num    integer variable
c               Max # items to be read. Length of list_type
c
c   list_type   integer array
c               specifies type of items to be read (length = list_num)
c                 0 = string
c                 1 = integer
c                 2 = logical
c                 3 = real
c                 4 = octal
c                 5 = hex
c 
c  Outputs
c
c   list_read   integer variable
c               number of items actually read. Length of list.
c
c   list_item   mixed array (real and integer)
c               returned list of items actually read (length = list_read)
c               if the item was a string, list_item(i) points to the location
c               in clist_item where the string is located
c
c   clist_item  character array
c               returned list of character items read.
c               clist_item is 1-1 with list_item
c
c   error       integer variable
c               > 0 if an error occurred during read
c 
c  author:    Paul Avery  Mar. 1, 1994  11.35.35
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "cmd_datatype.inc"

c     Externals
      integer  cmd_integer, cmd_logical, cmd_octal, cmd_hex
      real     cmd_real
      external cmd_integer, cmd_logical, cmd_octal, cmd_hex
      external cmd_real

c     calling arguments
      character*(*) in_string
      integer list_num, list_type(*), list_read, list_item(*)
      character clist_item(*)*(*)
      integer error
c
c     local variables
      integer i, ix, error_get, error_value, nstring
      character*80 out_strings(50)
      real x

      equivalence (ix, x)
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Clear stuff returned to user
      list_read = 0
      error = 0
      do i=1,list_num
        list_item(i) = 0
        clist_item(i) = ' '
      enddo

c     Parse the input string into separate strings. The info will be
c     unpacked from these separate strings.
      nstring = list_num
      call cmd_parse(in_string, nstring, out_strings, error_get)
      if(error_get .ne. 0) goto 9999

c     Extract the info from the list of strings
      list_read = min(list_num, nstring)
      do 100 i=1,list_read

        error_value = 0

c     string
        if(list_type(i) .eq. typ_str) then
          continue

c     integer
        else if(list_type(i) .eq. typ_int) then
          ix = cmd_integer(out_strings(i), error_value)

c     logical
        else if(list_type(i) .eq. typ_log) then
          ix = cmd_logical(out_strings(i), error_value)

c     real
        else if(list_type(i) .eq. typ_flt) then
          x = cmd_real(out_strings(i), error_value)

c     octal
        else if(list_type(i) .eq. typ_oct) then
          ix = cmd_octal(out_strings(i), error_value)

c     hex
        else if(list_type(i) .eq. typ_hex) then
          ix = cmd_hex(out_strings(i), error_value)

c     illegal
        else
          goto 9999
        endif

c     everything ok, add to list
        if(error_value .eq. 0) then
          if(list_type(i) .gt. 0) then
            list_item(i) = ix
          else
            clist_item(i) = out_strings(i)
          endif

c     error reading, quit
        else
          goto 9999
        endif

 100  continue

c     Normal exit
 1000 return

c     Error exit
 9999 error = 1

      return
      end
