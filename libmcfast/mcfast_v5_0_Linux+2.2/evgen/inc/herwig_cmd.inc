
      integer nstring_list, ival_string
      real val_string
      character*15 string_list
      common/herwig_r2/nstring_list,
     *                 ival_string(2,100),
     *                 val_string(2,100)
      common/herwig_r3/string_list(100)

      integer mcommand
      parameter (mcommand = 28)
      character cmdlist*15
      common/herwig_r4/cmdlist(mcommand)

