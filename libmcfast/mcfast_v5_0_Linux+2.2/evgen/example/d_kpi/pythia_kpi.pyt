!D production: 1000 GeV pbar on p

!These are commented out. They can be specified on the command line.
!These lines should only be used if you want to change them.
!file_lpt       pythia_exam.lpt   !Output print file
!file_evt_wrt   pythia_exam.evt   !File to write events
!file_hbk       pythia_exam.rz    !Hbook output
maxev          200               !# of events to generate
maxpr          5                 !# of events for which to make printout
frame          CMS               !Select center of mass frame
beam           PBAR              !Beam particle 1
target         P                 !Beam particle 2
cms_energy     2000.0            !Center of mass energy
ranseed        0                 !Set random seed using time of day
pygive         MSEL=4            !D production with massive matrix elements
! the two lines below are necessary for QQ production of D's
pygive         MSTJ(21)=0        !Switch off particle decays, but keep fragmentation - jetset
qq                               ! use QQ for decays	
qq_user_file   d_kpi.dec         !QQ user decay file
