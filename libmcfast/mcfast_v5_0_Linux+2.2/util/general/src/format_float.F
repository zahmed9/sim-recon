      subroutine format_float(value, width, dmax, form)

      implicit none
************************************************************************
*                                                                      *
*  Compute the format descriptor for a double precision real number    *
*   in the form Fwidth.d                                               *
*                                                                      *
* Inputs:                                                              *
*                                                                      *
*     value (double): the number to be fit to the bin                  *
*     width (int)   : the number of characters wide the column is      *
*     dmax  (int)   : the maximum number of decimal places allowed     *
*                                                                      *
* Output:                                                              *
*                                                                      *
*     form (char) : the format descriptor including a space            *
*                                                                      *
************************************************************************

c     Calling arguments
      integer width, w, nsigdig, dmax
      double precision value
      character*6 form

c     Local variables
      character*2 int_to_char
      external int_to_char

      integer magn, signs, decimal, zero, d, space
      double precision log10, nsig, val, xlog, power

c     Initialization of variables
      decimal = 1
      zero    = 1
      signs   = 0
      space   = 1

************************************************************************

c     Compute correction for a negative number
      if (value .lt. 0.) signs = -1

c     Shorten the output if exactly equal to 0
      if (value .eq. 0.) then
         d = 0
         form = 'f'//int_to_char(width)//'.0'
         return
      end if

c     Find the magnitude of the variable and compute the corresponding
c     number of decimal places including corrections for the decimal
c     place, the presence of a first 0 in decimal numbers and the sign

      xlog = log10(abs(value))
      magn = int(xlog) + 1
      if (xlog  .lt. 0.) then
         d = width - decimal - zero - space + signs
         if (d .gt. dmax) d = dmax
      else
         d = width - magn - decimal - space + signs
         if (d .lt. 0) d = 0
         if (d .gt. dmax) d = dmax
      end if

      form = 'f'//int_to_char(width)//'.'//int_to_char(d)

      return
         
      end

c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.5  1997/03/10 22:02:47  garren
cadd rcs log
c

