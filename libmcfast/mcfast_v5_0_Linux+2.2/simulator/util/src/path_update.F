      subroutine path_update(w, mass, step, path)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Updates the path of a track by a step
c
c  Inputs:
c  w        w track structure
c           Track parameters
c
c  mass     DFLOAT variable
c           Mass of particle
c
c  step     DFLOAT variable
c           Step size to increment
c
c  path     path structure
c           Initial path information
c
c  Output:
c  path     path structure
c           Output path information
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "const.inc"

c     Calling arguments
      record /wtrack_struct/ w
      DFLOAT mass, step
      record /path_struct/ path

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      path.arc = path.arc + step
      path.time = path.time + step * w.E / (w.p * clight)
      path.tau = path.tau + step * mass / (w.p * clight)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:56  garren
c add rcs log line
c
