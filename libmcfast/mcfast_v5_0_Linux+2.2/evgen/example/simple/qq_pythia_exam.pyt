!B production: 900 GeV pbar on p

file_lpt       qq_pythia_exam.lpt   !Output print file
file_evt_wrt   qq_pythia_exam.evt   !File to write events
file_hbk       qq_pythia_exam.rz    !Hbook output
maxev          1000              !# of events to generate
frame          CMS               !Select center of mass frame
beam           PBAR              !Beam particle 1
target         P                 !Beam particle 2
cms_energy     1800.0            !Center of mass energy
ranseed        0                 !Set random seed using time of day
pygive         MSEL=5            !B production with massive matrix elements
pygive         MSTJ(21)=0        !Switch off particle decays, but keep fragmentation - jetset
qq                               ! use QQ for decays
qq_user_file   user.dec          !QQ user decay file
