****************************************************************************
*  Hbook information
****************************************************************************

      character*150 hbk_file        !Hbook summary file
      character*150 hbk_topdir      !Hbook top directory
      integer hbk_lun               !Unit number used by Hbook

      common/mcp_hbook1/
     *  hbk_file,
     *  hbk_topdir

      common/mcp_hbook2/
     *  hbk_lun
