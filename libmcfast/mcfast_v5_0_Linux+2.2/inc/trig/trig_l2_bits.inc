C----------------------------------------------------------------------
C-
C-   Created  21-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
C Include L1_ANDOR.PARAMS
C>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       integer l2trig_bits_max
       parameter (l2trig_bits_max = 32) !Maximum number of triggers
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       record /trig_bit_struct/ trig_l2_bits
       common /trig_l2_bits/ trig_l2_bits(0:l2trig_bits_max-1)

