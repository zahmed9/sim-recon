#ifndef CERENK_STRUCT
#define CERENK_STRUCT

c   Threshold Cerenkov detector definition. Several of these can be defined
c   at one time, each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

      structure /cerenk_struct/
        real eta_min		!Min eta
        real eta_max		!Max eta
        real pth_el		!P threshold for electrons
        real pth_mu		!P threshold for muons
        real pth_pi		!P threshold for pions
        real pth_ka		!P threshold for kaons
        real pth_pr		!P threshold for protons
        character*40 name	!Name of device
      end structure
#endif
