****************************************************************************
*  Files used in mcfast
****************************************************************************

      integer mcp_len
      parameter (mcp_len = 150)     !# characters in file names

      character*(mcp_len)
     *   mcp_fileout,               !Output StdHep file (if any)
     *   mcp_filelpt,               !File containing program output
     *   mcp_filecmd,               !File containing input commands
     *   mcp_filegeo,               !File containing detector geometry
     *   mcp_fileqqdecay,           !File containing QQ particle definitions
     *   mcp_fileqquser             !File containing QQ particle definitions
      common/mcp_files1/
     *  mcp_fileout,
     *  mcp_filelpt,
     *  mcp_filecmd,
     *  mcp_filegeo,
     *  mcp_fileqqdecay,
     *  mcp_fileqquser
