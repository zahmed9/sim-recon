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
*CMZ :  1.04/00 22/09/94  00.06.59  by  Paul Avery
*-- Author :
*
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*                      QQBRAT.INC
*
*                Information on decay channels
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
#if defined(CLEO_CDGDOC)
*                 Decay information per particle
*  IPLIST(1,*)    Pntr to first entry in MLLIST/BRLIST per particle (0=stable)
*        (2,*)    # of decay channels per particle (0 if stable)
*        (3,*)    Pntr to first entry in CPLIST per particle (0=no CP decays)
*        (4,*)    # of CP eigenstate channels in CPLIST
#endif

      INTEGER IPLIST
      COMMON/QQBRA1/
     *  IPLIST(4,-20:MCNUM)


#if defined(CLEO_CDGDOC)
*                 Decay information per channel
*  NBRLST         # of decay channels defined
*  BRLIST(*)      Branching fraction per channel (in cumulative order)
*  AGLIST(7,*)    User defined parameters for channel. For 2 body decays they
*                 specify the angular distribution:
*                   dN/dcos(theta) = A1 + ... + A7*cos(theta)**6
*  MLLIST(1-9,*)  Decay information per channel
*         1       # daughters
*         2       pointer to first daughter position in IDLIST
*         3       MATRX = matrix element ID  number
*         4       Number of helicity states defined
*         5       Number of helicity angular distributions
*         6       Pointer to first helicity state in HELPRB (0 if none)
*         7       Pointer to helicity angular dist. list HELANG (0 if none)
*         8       Pointer to corresponding entry in CPLIST (CP eig. BR list)
*         9       Sum of daughter type ID's. Used in inclusive B decays
*  LCPTAG(*)      TRUE if daughter decays to be carried out as tag + CP eig.
*
#endif

      INTEGER NBRLST, MLLIST
      LOGICAL LCPTAG
      REAL BRLIST, AGLIST
      COMMON/QQBRA2/
     *  NBRLST,
     *  BRLIST(MCHANS), AGLIST(7,MCHANS), MLLIST(9,MCHANS),
     *  LCPTAG(MCHANS)


#if defined(CLEO_CDGDOC)
*                 Daughter list pointed to by all channels
*  NDGHTR         Total number of daughters defined
*  IDLIST(*)      List of daughters
#endif

      INTEGER NDGHTR, IDLIST
      COMMON/QQBRA3/
     *  NDGHTR, IDLIST(MCDTRS)


#if defined(CLEO_CDGDOC)
*                 Helicity ang. distributions (set by ANGULAR_HELICITY commd.)
*  NHLANG         Length of HELANG list
*  HELANG(*)      Helicity of this decay
*  COFANG(7,*)    A1, A2, etc. used in dN/dcos = A1 + ... + A7*cos(theta)**6
#endif

      INTEGER NHLANG
      REAL HELANG, COFANG
      COMMON/QQBRA4/
     *  NHLANG, HELANG(MHLANG), COFANG(7,MHLANG)


#if defined(CLEO_CDGDOC)
*                 Helicity state probability list (set by HELICITY command)
*  NHLPRB         Length of HELPRB
*  IHLPRB(*)      Pointer to first daughter helicity in HELLST
*  HELPRB(*)      Probability (stored in cumulative order)
#endif

      INTEGER NHLPRB, IHLPRB
      REAL HELPRB
      COMMON/QQBRA5/
     *  NHLPRB, IHLPRB(MHLPRB), HELPRB(MHLPRB)


#if defined(CLEO_CDGDOC)
*                 Helicity states of certain daughters
*  NHLLST         Length of HELLST
*  HELLST(*)      List of helicities (pointed to by IHLPRB(I))
#endif

      INTEGER NHLLST
      REAL HELLST
      COMMON/QQBRA6/
     *  NHLLST, HELLST(MHLLST)


#if defined(CLEO_CDGDOC)
*                 List of CP eigenstatechannels
*  NCPLST         Number of CP eigenstate channels
*  CPLIST(*)      CP branching fraction per channel (in cumulative order)
*  ICPLST(*)      Pointer to corresponding entry in MLLIST
*  CPSNPH(*)      CP sin(phi) per channel
#endif

      INTEGER NCPLST, ICPLST
      REAL CPLIST, CPSNPH
      COMMON/QQBRA7/
     *  NCPLST, CPLIST(MCPLST), ICPLST(MCPLST), CPSNPH(MCPLST)


#if defined(CLEO_CDGDOC)
*  NFDECA         # of decay files read in
*  CFDECA(*)      List of decay files read in
#endif
      INTEGER NFDECA
      COMMON/QQBRA8/
     *  NFDECA

      CHARACTER*80 CFDECA
      COMMON/QQBRA9/
     *  CFDECA(MFDECA)
