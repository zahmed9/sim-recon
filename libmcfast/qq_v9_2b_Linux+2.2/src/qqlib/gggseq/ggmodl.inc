*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:36  zfiles
* first version of qqlib in CVS
*
*
*CMZ :  1.03/15 24/05/91  10.00.33  by  R.A.FULTON
*-- Author :    R.A.FULTON   04/12/90
#if defined(CLEO_CDGDOC)
C*******************************************************
C          TWO-PHOTON FINAL STATE PRODUCTION PARAMETERS.
C           DEFAULTS ARE SHOWN IN PARENS (D=VALUE)
C
C MODE2G: determines the process:  (D=0)
C         = 0      generate only photon-photon cms
C                pair production models from bkt (pr d4, 1532):
C         = 1      lepton pairs
C         = 2      spin-0 meson pairs (born approximation)
C                hadronic models:
C         = 3      resonance production
C         = 5      quark jets (gg -> qqbar, qqg lund fragmentation
C
C NTAG2G: determines tagging mode:  (D=0)
C         = 0      no tagging
C         = 1      single tag
C         = 2      double tag
C
C ELEC2G  If true the only generate scattered electrons
C KFRES:  KF code for resonance to be produced.
C IRES2G: =   Index of resonance or pair , or pattern of quarks
C             for model 5 ires2g is an integer designating quark
C             types to use. (e.g. 1=u, 11=du, 1111=csdu, 1000=c,
C             etc. D=1111)
C
C JRES2G: = spin of resonance
C LHRS2G: = helicity of resonance
C JPAR2G: = parity of resonance
C                           FOR MODE2G=3
C                 EMX2G   = maximum gg mass (all models; D = ECM)
C                 EMN2G   = minimum gg mass (all models; D = 1.0GeV)
C                 COS2GX  = maximum c.m.s. two-body cosine
C                            (models 1, 2, 3, and 5; D = .999)
C                 BWMG2G  = resonance mass range to generate
C                            (in width units; model 3; D=5)
C               X2G0,X2G1 = sigma gg (nb) = X2G0+X2G1/W
C                            (D=300.,800.; model 0 uses only X2G0,
C                 EPAMAX  = upper limit on internal monte carlo
C                            weight. If set negative, GGDEPA will try
C                            to estimate a value for you. (all models)
C
C************************************************************
#endif
      INTEGER    MODE2G, NTAG2G, IRES2G, JRES2G, LHRS2G
      INTEGER    JPAR2G, KFRES
      REAL       COS2GX, PAIR2G, XMRS2G, WMRS2G, TBMI2G
      REAL       TBMA2G, BWMG2G
      LOGICAL    ELEC2G
C
      COMMON/GGMODL/ MODE2G, NTAG2G, KFRES, JRES2G, LHRS2G,
     +    JPAR2G, COS2GX, PAIR2G, IRES2G, XMRS2G, WMRS2G,
     +    TBMI2G, TBMA2G, BWMG2G, ELEC2G
      SAVE /GGMODL/
