The xerces-c package is no longer maintained in the GlueX source code
tree.  The package is actively maintained by apache.org and the 
documentation on installation and use is very good.

Many of the packages in the Hall D source code repository expect
to find a copy of libxerces-c.so in the local $CVSROOT/lib.$TARGET
that is built for the target platform.  If this is not already present
in your installation, go to the following link and download it.

   http://xml.apache.org/xerces-c

If you find a binary distribution available for your platform then
you can download that and copy libxerces-c.so directly into your
cvs lib.$TARGET folder.  If not, then follow the directions on the
web to build it from sources.  The procedures are straight forward.

The Hall D packages are currently verified against version

   xerces-c 2.3.0
