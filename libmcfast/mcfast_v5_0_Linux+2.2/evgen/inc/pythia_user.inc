      character*10 frame     !Frame of collision (CMS, LAB)
      character*10 beam      !Beam particle (P, PBAR, etc)
      character*10 target    !Target (P, PBAR, etc)

      common/pythia_user1/
     *  frame, beam, target

      double precision cms_energy        !cms energy
      integer maxev          !# events to generate
      integer maxpr          !# events to print out

      common/pythia_user2/
     *  cms_energy,
     *  maxev,
     *  maxpr

      character*120 pygvlst
      integer npygv

      common/pythia_user3/npygv,pygvlst(50)
