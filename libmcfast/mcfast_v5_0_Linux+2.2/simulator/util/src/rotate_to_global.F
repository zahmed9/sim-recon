
      subroutine rotate_to_global(xyz_loc,c_p,s_p,c_t,s_t,xyz_glob)
c
c     Julia V. Yarba ; 4-1-96
c
      implicit none

c
c     Calling variables
c
c     Input :
c
      double precision xyz_loc(3), c_p, s_p, c_t, s_t
c
c     Output :
c
      double precision xyz_glob(3)

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      xyz_glob(1) =  xyz_loc(1)*c_p*c_t
     *            -  xyz_loc(2)*s_p
     *            +  xyz_loc(3)*c_p*s_t
      xyz_glob(2) =  xyz_loc(1)*s_p*c_t
     *            +  xyz_loc(2)*c_p
     *            +  xyz_loc(3)*s_p*s_t
      xyz_glob(3) = -xyz_loc(1)*s_t
     *            +  xyz_loc(3)*c_t

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:57  garren
c add rcs log line
c
