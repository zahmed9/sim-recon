c   Information used by programs which parse input for MC
c   For now just contains info needed to handle nested "include" statements

      integer cmd_maxlun           !Max # of nested includes
      parameter (cmd_maxlun = 10)

      integer cmd_lun              !Current unit number
      integer cmd_nlun             !Number of unit numbers assigned
      integer cmd_lunlist          !List of unit numbers

      common/cmd_parse1/
     *  cmd_lun,
     *  cmd_nlun,
     *  cmd_lunlist(cmd_maxlun)
