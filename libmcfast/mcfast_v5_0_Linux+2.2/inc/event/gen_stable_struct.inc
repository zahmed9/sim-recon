#ifndef GEN_STABLE_STRUCT
#define GEN_STABLE_STRUCT

c  Structure for "stable" generated particles, i.e. those which are
c  either stable or decay in flight later.
c
c  Status has the following meaning
c    =   1  stable
c    =   2  decayed in generator
c    =   3  Used by event generator ("documentation line")
c    = 201  Decay in flight
c    = 202  gamma conversion
c    = 203  Bremsstrahllung
c    = 204  Punch through
c    = 205  Shower particle

      structure /gen_stable_s/
        real    q          !Charge
        integer status     !Status (see above)
        integer pdgtype    !PDG particle type
        integer stbtype    !Stable particle type
        integer hep        !Position in HEPEVT list
      end structure
#endif
