cc -g -c Mcf_ReadEvent.c -I . -I$MCFIO_DIR/src \
-I$MCFAST_DIR/src/dst \
-I$MCFAST_DIR/src/io -I$STDHEP_INC \
-I$MCFAST_DIR/inc/event
f77 -g -c get_commons.F -I$MCFIO_DIR/src \
-I$MCFAST_DIR/src/dst \
-I$MCFAST_DIR/src/io -I$STDHEP_INC \
-I$MCFAST_DIR/inc/event

