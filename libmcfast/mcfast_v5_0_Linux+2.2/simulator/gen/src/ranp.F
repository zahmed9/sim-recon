      real function ranp(iseed)

C For MCFast - pass through to rann

      integer iseed
      real rann
      external rann

      ranp = rann(0)

      return
      end
