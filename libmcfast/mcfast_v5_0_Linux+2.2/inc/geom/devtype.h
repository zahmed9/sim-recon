#ifndef DEVTYPE_H
#define DEVTYPE_H

/*

   Rob Kutschke, Oct. 26, 1998.

   Definitions of device types


   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            devtype.h !

   --------------------------------------------------------

*/

static const int jdev_silbarrel   =  1;  /* Barrel silicon.                  */
static const int jdev_sildisk     =  2;  /* Forward silicon 
                                            (circular z planes).             */
static const int jdev_driftbarrel =  3;  /* Barrel drift chamber.            */
static const int jdev_driftplane  =  5;  /* Forward drift plane.             */
static const int jdev_pixelbarrel =  6;  /* Barrel pixel detector.           */
static const int jdev_pixelplane  =  7;  /* Forward pixel detector 
                                            (rectangular).                   */
static const int jdev_emcal       =  8;  /* EM calorimeter.                  */
static const int jdev_hadcal      =  9;  /* Hadron calorimeter.              */
static const int jdev_muon        = 10;  /* Muon detector.                   */
static const int jdev_silplane    = 11;  /* Forward silicon 
                                            (rectangular z planes).          */
#endif
