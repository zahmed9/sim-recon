#include <X11/StringDefs.h>
#include <X11/Intrinsic.h>
#include "displayTypes.hh"
#ifndef HITSDISPLAYINFO
#define HITSDISPLAYINFO

//This structure contains the information necessary to control a hit display

struct hitsDispInfo
{
    Boolean showSilBarrelHits;
    Boolean showSilDiskHits;
    Boolean showSilXYHits;
};
void hitsDispInfoInitialize( hitsDispInfo *temp);
void hitsDispInfoSet( hitsDispInfo set, hitsDispInfo *temp);
#endif
