#!/bin/csh
#
# Source this file to get necessary products for building stdhep.
#
 setup cern 2000
 if ( `ups list gtools | grep current | wc -l` > 0) then
   setup gtools		# for gmake
 endif
 setup stdhep v4_08
 setup isajet v7_37
 setup herwig v6_1
 setup qq v9_2b
 setup lund v6_129a
 setup clhep v1_4	# for StdHepC++
 setup egcs 		# for StdHepC++
 setup histo
 if ( `ups list dpmjet v2_4 | grep dpmjet | wc -l` > 0) then
     setup dpmjet v2_4
 endif
 if ( `ups list phojet v1_05e | grep phojet | wc -l` > 0) then
     setup phojet v1_05e
 endif
