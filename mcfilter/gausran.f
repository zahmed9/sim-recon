c
      real function gausran(x)
      z=0.
      do i=1,12
         z=z+ranf()
      enddo
      gausran=z-6.
      return
      end
