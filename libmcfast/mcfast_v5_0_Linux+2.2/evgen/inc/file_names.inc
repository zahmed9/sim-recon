C----------------------------------------------------------------------------
      character*250 file_lpt,file_evt_wrt,file_evt_rd,
     1              file_dcy,file_input,file_hbk,jetset_decay_file
      common/genfnm/ file_lpt,file_evt_wrt,file_evt_rd,
     1              file_dcy,file_input,file_hbk,jetset_decay_file
      save /genfnm/
C
C     file_lpt       	-    output line printer file
C     file_evt_wrt   	-    output event file
C     file_evt_rd    	-    input event file
C     file_dcy       	-    input decay file
C     file_input     	-    input command file
C     file_hbk       	-    hbook output *.rz file
C     jetset_decay_file	-    jetset decay file 
C                            (default is $EVGEN_DIR/input/jetset.dcy)
C----------------------------------------------------------------------------
