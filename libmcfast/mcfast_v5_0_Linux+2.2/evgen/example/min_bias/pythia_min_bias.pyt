!Minimium Bias Event modeled as "All QCD Processes"

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
pygive         MSEL=2            !Select "All QCD" matrix element
