      character*(*) function int_to_char(num)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*                                                                      *
*    Converts an integer into an equivalent character string.          *
*                                                                      *
*  Input:                                                              *
*                                                                      *
*     num : (integer) - The number to convert                          *
*                                                                      *
*  Return:                                                             *
*                                                                      *
*     int_to_char : (char) - The character string representing num     *
*                                                                      *
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c Calling Variables
      integer num

c Local Variables
      integer num2, next, loop, magn, index
      character*50 char2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      num2 = num
      if (num2 .ne. 0) then
         loop = int(log10(abs(float(num2))))
      else
         int_to_char = '0'
         return
      end if

      do magn = loop, 0, -1
         next = int(num2/(10**magn))
         index = loop + 1 - magn
         char2(index:index) = char(next + 48)
         num2 = num2 - next*10**(magn)
      end do

      int_to_char = char2(1:loop+1)

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.3  1997/03/10 22:07:34  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:49  eugenio
cadd cInitial revision
cadd c
c
