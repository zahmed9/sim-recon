!
! GlueX Spectrometer command file for MCFast.
!
max_ev    25000                    !Max number of events
!max_ev    25                    !Max number of events
max_print 4                      !max # events to print
! Change the geofile location below to the value of $HDFAST_DIR 
! note that mcfast needs that actual name and not the env var.
!file_geo $HDFAST_DIR/HDFast.geo       !Geometry file
file_geo   HDFast.db       !Geometry file
ranseed  0                     !Random seeds =0 use time()
file_type 1                      !MCFio input file; 1 = StdHep file.
file_in input.evt                  !data files: enter either 
mcfio_out output.evt      ! Output file.
batch ON
!
make_decays FALSE
make_pair_convert FALSE
trace_integrated TRUE
trk_max_turns 1


