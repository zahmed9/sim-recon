!
! Cebaf Meson Spectrometer command file for MCFast.
!
max_ev    25000                    !Max number of events
max_print 4                      !max # events to print
!file_geo $CMS_MCFAST_DIR/CMS_v_1.0.db       !Geometry file
file_geo /home/halld/source/CMS_mcfast/CMS_v_1.0.db       !Geometry file
ranseed  0                       !Random seeds =0 use time()
file_type 1                      !MCFio input file; 1 = StdHep file.
file_in input.evt                  !data files: enter either 
mcfio_out output.evt      ! Output file.


batch ON
make_decays FALSE

