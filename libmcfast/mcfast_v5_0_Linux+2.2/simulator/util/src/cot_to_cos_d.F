      real*8 function cot_to_cos_d ( c )
c
c Given cotangent(theta), return cosine(theta).
c
      ! Cotangent(theta)
      real*8 c

      cot_to_cos_d = c / sqrt ( 1.  + c*c )
      end
