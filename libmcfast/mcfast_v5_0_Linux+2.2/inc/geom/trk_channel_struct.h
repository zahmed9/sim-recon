#ifndef TRK_CHANNEL_STRUCT_H
#define TRK_CHANNEL_STRUCT_H

/*

   Rob Kutschke, Sept 24, 1998.

   Structure to identify a hit detector element, both logically
   and as an electronics channel number.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change 
            trk_channel_struct.inc !

   -------------------------------------------------------- 

*/



typedef struct _trk_channel_s {
  int devtype;   /* Type of device                                           */
  int devnum;    /* Device # of this type (i.e., may be more than 1)         */
  int devlayer;  /* Layer # (or plane #) in device                           */
  int devwid[4]; /* Info within layer (wire, plane, strip, etc.)             */
  int channel;   /* Address of electronic channel (computed from above info. */
} trk_channel_s;

#endif

/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:40  eugenio
 *  Initial revision
 *
 *  Revision 1.2  2000/01/12 00:00:15  mcbride
 *  increase devwid array to 4 elements for alignment
 *
 * Revision 1.1  1998/09/25  02:45:40  kutschke
 * New file. Derived from .inc version.
 *
 *
 */
