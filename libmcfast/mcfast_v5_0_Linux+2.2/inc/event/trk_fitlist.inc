      integer trk_mlist
      parameter (trk_mlist = 1000)

      integer trk_nlist             !# of tracks to fit
      integer trk_list             !List of tracks to fit in HepEvt

      common/trk_list1/
     *   trk_nlist,
     *   trk_list(trk_mlist)
