#!/bin/csh
# copy useful include files to a common area
# edit them to remove #defined lines and include relative paths
# This is the OSF1 version of include.mk.
#
cd $QQ_DIR/src/inc

rm *

cp $QQ_DIR/src/qqlib/seq/mcbrat.inc mcbrat.inc
cp $QQ_DIR/src/qqlib/seq/qqinc.inc qqinc.inc
cp $QQ_DIR/src/qqlib/seq/mcmxcp.inc mcmxcp.inc

cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/mcgen.inc > mcgen.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/mcjet.inc > mcjet.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqmxcp.inc > qqmxcp.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqbfld.inc > qqbfld.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqbmst.inc > qqbmst.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqbrat.inc > qqbrat.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqbuffer.inc > qqbuffer.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqcntl.inc > qqcntl.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqevnt.inc > qqevnt.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqfile.inc > qqfile.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqinfo.inc > qqinfo.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqipcd.inc > qqipcd.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqipft.inc > qqipft.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqluns.inc > qqluns.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqmisc.inc > qqmisc.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqpars.inc > qqpars.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqprop.inc > qqprop.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqsngl.inc > qqsngl.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqspcm.inc > qqspcm.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqtrak.inc > qqtrak.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/seq/clinc/qqvrtx.inc > qqvrtx.inc
cpp -P -DCLEO_CDGDOC -DNONCLEO_DOUBLE -I$QQ_DIR/src $QQ_DIR/src/qqlib/seq/qqwjet.inc > qqwjet.inc
