#include <cx/Geometry.h>
#include <cx/DataAccess.h>
#include "McfGeomUtil.h"
#define True 1
#define False 0
void open_display(cxGeometry **geoOut)
{
    cxGeometry *geoLocal;
    static GeomInitDone = False;

    printf("ENTER: open_display()\n");
    
    if(GeomInitDone == False ) { 
       cxGeoInit();
       printf("initializing geometry\n");
       GeomInitDone = True;
    }

    /* Initialize geometry object and prepare for data; */
    cxDataAllocErrorClear();
    geoLocal = cxGeoNew();
    if( cxDataAllocErrorGet() ) cleanup_geometry(geoLocal);
    cxGeoBufferSelect(geoLocal);
    cxGeoRoot();
    if( cxDataAllocErrorGet() ) cleanup_selected(geoLocal);
    cxGeoDelete();
    if( cxDataAllocErrorGet() ) cleanup_selected(geoLocal);

    *geoOut = geoLocal;
printf("LEAVE: open_display()\n");
}



/********************************************/
/* Display close down and output procedures */
/********************************************/
void geom_exit(cxGeometry *geoOut)
{
printf("\n\n\nENTER: geom_exit()\n");
    cxGeoBufferClose(geoOut);
printf("LEAVE: geom_exit()\n");
return;
}

/* Clean up geometry if out of memory */
void cleanup_selected(cxGeometry *geoLocal)
{
    cxGeoBufferClose(geoLocal);
    cleanup_geometry(geoLocal);
    return;    
}

void cleanup_geometry(cxGeometry *geoLocal)
{
    cxDataRefDec(geoLocal);
    return;
}
