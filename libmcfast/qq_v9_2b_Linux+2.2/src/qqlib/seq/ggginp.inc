*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:50  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:32  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.03/15 24/05/91  09.55.35  by  R.A.FULTON
*-- Author :    R.A.FULTON   04/12/90
#if defined(CLEO_CDGDOC)
C*******************************************************
C             Two-photon final state production parameters.
C               defaults are shown in parens (D=value)
C..MODLGG
C                    Two-photon model to be use
C                = 0   Generate center of mass only
C                = 1   Lepton pairs
C                = 2   Spin 0 Meson pairs
C                = 3   Resonance production
C                = 4   Open for use( have a suggestion ?)
C                = 5   Multi-hadron production( Not working )
C
C GENERAL ENTRIES
C..NTAGGG
C                        Number of detected beam-leptons
C                = 0   No tagging is done, beam-leptons may appear in detector
C                       but are not required
C                = 1   Single tagging, at least one beam-lepton in region
C                       defined by (TG1LGG, TG1HGG)
C                = 2   Double tagging, both beam-leptons found in region
C                       defined by (TG1LGG, TG1HGG) and (TG2LGG, TG2HGG)
C
C..ELONLY         Logical for saving only the scattered electrons in the event
C
C MODEL or PREVIOUS ENTRY SPECIFIC ENTRIES
C..KRESGG
C                            MODEGG = 1,2,3
C                 KRESGG = Particle ID code as found in DEFDEC
C                           pairs => anti-KRESGG is choosen as partner
C..JRESGG
C                              MODEGG = 3
C                 If no entry, value found in DEFDEC is used
C                 If no entry found in DEFDEC, JRESGG = -99
C..JPARGG
C                              MODEGG = 3
C                 If no entry, value found in DEFDEC is used
C                 If no entry found in DEFDEC, JPARGG = -99
C..LHRSGG
C                              MODEGG = 3
C                         ( D:LHRSGG = -99 )
C..EPAGG
C                 Max weight for events in throw-away method. If default
C                 used, 200 to 400 events are tested and
C                 EPAGG = 1.5 x EPAMAX is used.
C..WMINGG
C                 Min generated gamma-gamma mass
C..WMAXGG
C                 Max generated gamma-gamma mass
C..TG1LGG
C                 Min tagging angle(radians) for lepton 1
C                       can NOT be 0 for NTAGGG = 1
C..TG1HGG
C                 Max tagging angle(radians) for lepton 1
C..TG2LGG
C                 Min tagging angle(radians) for lepton 2
C                       only valid for NTAGGG = 2
C..TG2HGG
C                 Max tagging angle(radians) for lepton 2
C                       only valid for NTAGGG = 2
C..ANGUGG
C                 Anti-tagging angle(relevant only for NTAGGG = 1 )
C                     must have  ANGUGG </= TG1LGG
C------------------------- MODEGG = 5 ---------------------------------
C..F2TPGG
C                    Multihadronic final state model
C                = 1  not used
C                = 2  F2 structure function = alpha*abs(Q)
C                = 3  VDM only; normalized to SIG0GG at Q*Q = 0
C                = 4  QPM only; Based on formula of Budnev et al.
C                = 5  F2 structure function = alpha*ln(Q*Q/LAMBDA*LAMBDA)
C                          LAMBDA = 0.2 Gev/c
C                = 6  3-Jet model only; from Kessler et al.
C                = 7  VDM + QPM + 3-Jet together;
C                         VDM normalized to SIG0GG as 3 above
C                = 8  VDM + QPM together;
C                         VDM normalized to SIG0GG as 3 above
C..SIG0GG
C                 Value of VDM cross section at Q*Q = 0
C..NQRKGG
C                 Number of possible quark flavours
C..IQRKGG
C                 Flavour number of allowed flavour if NQRKGG = 1
C                = 1 u
C                = 2 d
C                = 3 s
C                = 4 c
C..EXPSGG
C                 average rms Pt of qq wrt gamma-gamma axis in CM system
C                  for VDM.
C..PTBRGG
C                 Min value of Pt allowed for 3-Jet model.(D = 2.0 Gev/c)
C..GVDMGG
C                 Logical, TRUE => Use form-factor for VDM according to
C                       rho + omega + phi parts.
C..RHOPGG
C                 Logical, TRUE => Only include rho contribution in VDM
C..TRGMGG
C                 Logical, TRUE => Include target-mass effects in QPM.
C..LMTLGG
C                 Logical, TRUE => use other polarizations besides TT
C************************************************************
#endif
      INTEGER    MODLGG, NTAGGG, KRESGG, JRESGG, JPARGG, LHRSGG
      INTEGER    F2TPGG, NQRKGG, IQRKGG
      REAL       EPAGG, WMINGG, WMAXGG, TG1LGG, TG1HGG
      REAL       TG2LGG, TG2HGG, ANGUGG, EXPSGG, PTBRGG, SIG0GG
      LOGICAL    GVDMGG, RHOPGG, TRGMGG, LMTLGG, ELONLY
C
      COMMON/GGGINP/ MODLGG, NTAGGG, KRESGG, JRESGG, JPARGG, LHRSGG,
     +    F2TPGG, NQRKGG, IQRKGG, EPAGG, WMINGG, WMAXGG,
     +    TG1LGG, TG1HGG, TG2LGG,
     +    TG2HGG, ANGUGG, EXPSGG, PTBRGG, GVDMGG, RHOPGG, TRGMGG,
     +    LMTLGG, SIG0GG, ELONLY
