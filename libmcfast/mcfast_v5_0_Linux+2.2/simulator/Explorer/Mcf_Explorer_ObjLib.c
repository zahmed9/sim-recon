/******************************************************************************/
/* PATLIB_ObjLibExplorer.c - Dave Swoboda - 9/2/94                            */ 
/* Mcf_Explorer_ObjLib.c                                                      */
/* renamed 2/22/95 A. Boehnlein                			              */
/******************************************************************************/

/**************************/
/* STANDARD INCLUDE FILES */
/**************************/
#include <math.h>

/*************************************/
/* EXPLORER AND mcf_explorer INCLUDE FILES */
/*************************************/
#ifndef EXPLORER
#define EXPLORER
#include <cx/DataTypes.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/Geometry.h>
#include <cx/Lookup.h>
#endif

#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_prototypes.h"
#include "Mcf_Explorer_externs.h"

/* color */
float col[4] = {1.0,1.0,1.0,1.0};

/*************************************/
/* GEANT EMULATED GEOMETRY FUNCTIONS */
/*************************************/

/******************************************************************************/
/* B O X   B O X   B O X   B O X   B O X   B O X   B O X   B O X   B O X   B O*/
/******************************************************************************/
void geantBOX(int geo, float half_x, float half_y, float half_z)
{
    /*printf("ENTER: geant_BOX()\n");*/

    verts[0]  = -half_x; verts[1]  = -half_y; verts[2]  = -half_z; 
    verts[3]  = -half_x; verts[4]  =  half_y; verts[5]  = -half_z; 
    verts[6]  =  half_x; verts[7]  =  half_y; verts[8]  = -half_z; 
    verts[9]  =  half_x; verts[10] = -half_y; verts[11] = -half_z; 
    verts[12] = -half_x; verts[13] = -half_y; verts[14] =  half_z; 
    verts[15] = -half_x; verts[16] =  half_y; verts[17] =  half_z; 
    verts[18] =  half_x; verts[19] =  half_y; verts[20] =  half_z; 
    verts[21] =  half_x; verts[22] = -half_y; verts[23] =  half_z; 

    /*printf("ENTER: geant_BOX()\n");*/
    return;
}
/******************************************************************************/
/* B O X   B O X   B O X   B O X   B O X   B O X   B O X   B O X   B O X   B O*/
/******************************************************************************/
void geantBOX2(int geo, float *xlen, float *ylen, float *zlen, float *vert)
{
    /*printf("ENTER: geant_BOX2()\n");*/

    vert[0]  = xlen[0]; vert[1]  = ylen[0]; vert[2]  = zlen[0]; 
    vert[3]  = xlen[0]; vert[4]  = ylen[1]; vert[5]  = zlen[0]; 
    vert[6]  = xlen[1]; vert[7]  = ylen[1]; vert[8]  = zlen[0]; 
    vert[9]  = xlen[1]; vert[10] = ylen[0]; vert[11] = zlen[0]; 
    vert[12] = xlen[0]; vert[13] = ylen[0]; vert[14] = zlen[1]; 
    vert[15] = xlen[0]; vert[16] = ylen[1]; vert[17] = zlen[1]; 
    vert[18] = xlen[1]; vert[19] = ylen[1]; vert[20] = zlen[1]; 
    vert[21] = xlen[1]; vert[22] = ylen[0]; vert[23] = zlen[1]; 

    /*printf("ENTER: geant_BOX2()\n");*/
    return;
}

/******************************************************************************/
/* T U B E   T U B E   T U B E   T U B E   T U B E   T U B E   T U B E   T U  */
/******************************************************************************/

void geantTUBE(int geo, float rad_in, float rad_out, float half_z)
{
    geantCONS(geo, half_z, rad_in, rad_out, rad_in, rad_out, 0.0, 360.0,12);
}

/******************************************************************************/
/* T U B S   T U B S   T U B S   T U B S   T U B S   T U B S   T U B S   T U  */
/******************************************************************************/

void geantTUBS(int geo, float rad_in, float rad_out, float half_z, float phi_begin, float phi_end)
{
    geantCONS(geo, half_z, rad_in, rad_out, rad_in, rad_out, phi_begin,
    phi_end,12);
}

/******************************************************************************/
/* C O N E   C O N E   C O N E   C O N E   C O N E   C O N E   C O N E   C O N*/
/******************************************************************************/

void geantCONE(int geo, float half_z, float rad_in_low, float rad_out_low,
                float rad_in_high, float rad_out_high)
{
     geantCONS(geo, half_z, rad_in_low, rad_out_low, rad_in_high, rad_out_high,
     		0.0, 360.0, 12);
}

/******************************************************************************/
/* C O N S   C O N S   C O N S   C O N S   C O N S   C O N S   C O N S   C O N*/
/******************************************************************************/

void geantCONS(int geo, float half_z, float rad_in_low, float rad_out_low,
                float rad_in_high, float rad_out_high,
                float phi_begin, float phi_end, int nsides)
{
float phi_angle, theta, thinc, twopi_by_360, value, x;
int connect, n;

    /*printf("ENTER: geantCONS()\n");*/

    phi_angle = phi_end - phi_begin;
    thinc = phi_angle/nsides; 
    theta = phi_begin;
    twopi_by_360 = 6.2831853/360;

    /* Load up polygonal vertices */
    for (n = 0; n < (12*(nsides+1)); n+=12)
    {

	value = theta * twopi_by_360;

	/* Inside tube */
        verts[n]    = rad_in_low*fcos(value);
        verts[n+1]  = rad_in_low*fsin(value);
	verts[n+2]  = -half_z;
	verts[n+3]  = rad_in_high*fcos(value);
	verts[n+4]  = rad_in_high*fsin(value);
	verts[n+5]  = half_z; 

	/* Outside tube */
        verts[n+6]  = rad_out_low*fcos(value);
        verts[n+7]  = rad_out_low*fsin(value);
	verts[n+8]  = -half_z;
	verts[n+9]  = rad_out_high*fcos(value);
	verts[n+10] = rad_out_high*fsin(value);
	verts[n+11] = half_z; 
        /*printf("cons vert, %d,%f, %f\n", n, verts[n], verts[n+6]);*/
        theta       = theta + thinc; 
    }
    
    /* Load up vertice polygon connections array */
    connect = 0;
/*    if (rad_out_high == rad_in_high &&
        rad_out_low  == rad_in_low ){
        printf ("pipe has same inner and outer radius\n");
        for (n = 0; n < (nsides*5); n += 5){
        tube_list[n]   = connect+4;
        tube_list[n+1] = connect+0;
        tube_list[n+2] = connect+1;
        tube_list[n+3] = connect+5;
        tube_list[n+4] = -1;  
        connect =+ 4;         
        } 
    }else {*/
      for (n = 0; n < (nsides*20); n+= 20){
	/* inside tube */
        tube_list[n]   = connect+4;
        tube_list[n+1] = connect+0;
        tube_list[n+2] = connect+1;
        tube_list[n+3] = connect+5;
        tube_list[n+4] = -1;

	/* outside tube */
        tube_list[n+5] = connect+6;
        tube_list[n+6] = connect+2;
        tube_list[n+7] = connect+3;
        tube_list[n+8] = connect+7;
        tube_list[n+9] = -1;

	/* zero face */
        tube_list[n+10] = connect;
        tube_list[n+11] = connect+4;
        tube_list[n+12] = connect+6;
        tube_list[n+13] = connect+2;
        tube_list[n+14] = -1;	

	/* one face */
        tube_list[n+15] = connect+1;
        tube_list[n+16] = connect+3;
        tube_list[n+17] = connect+7;
        tube_list[n+18] = connect+5;
        tube_list[n+19] = -1;        
        
        connect += 4;
      /*}*/
    }
    if ((phi_end - phi_begin) == 360.0)
    {
	printf("CONS: NOT DRAWING ENDFACES!\n");
        for (n = 0; n < 10; n++)
        {
            tube_list[(nsides*20)+n] = -1;
        }
    }
    else						/* If tube is closed, do not draw above faces */ 
    {
	printf("CONS: Drawing End Faces\n");
	/* add 0,2,3,1 face */
	tube_list[(nsides*20)]   = 0;
	tube_list[(nsides*20)+1] = 2;
	tube_list[(nsides*20)+2] = 3;
	tube_list[(nsides*20)+3] = 1;
	tube_list[(nsides*20)+4] = -1;

	/* add last face */
	tube_list[(nsides*20)+5] = (nsides*4);
	tube_list[(nsides*20)+6] = (nsides*4)+1;
	tube_list[(nsides*20)+7] = (nsides*4)+3;
	tube_list[(nsides*20)+8] = (nsides*4)+2;
	tube_list[(nsides*20)+9] = -1;
    }    
            
    /*printf("LEAVE: geantCONS()\n");*/
    return;
}

/******************************************************************************/
/* C Y L   C Y L   C Y L   C Y L   C Y L   C Y L   C Y L   C Y L   C Y L   C Y*/
/******************************************************************************/

void geantCYL(int geo, float radius, float half_z, float phi_begin, float phi_end)
{
float phi_angle, theta, thinc, twopi_by_360, value, x;
int connect, n;

    /*printf("ENTER: geantCYL()\n");*/
   
    printf("radius = %f, half_z = %f, phi_begin = %f, phi_end = %f\n",
    		 radius, half_z, phi_begin, phi_end);

    phi_angle = phi_end - phi_begin;
    thinc = phi_angle/SEGMENTS; 
    theta = phi_begin;
    twopi_by_360 = 6.2831853/360;

    /* Load up polygonal vertices */
    for (n = 0; n < (6*(SEGMENTS+1)); n+=6)
    {

	value = theta * twopi_by_360;

	/* Inside tube */
        verts[n]    = radius*fcos(value);
        verts[n+1]  = radius*fsin(value);
	verts[n+2]  = -half_z;
	verts[n+3]  = radius*fcos(value);
	verts[n+4]  = radius*fsin(value);
	verts[n+5]  = half_z; 

        theta       = theta + thinc; 
    }

    for ( n = 0; n < (6*(SEGMENTS+1)); n++)
    {
        printf("verts[%d] = %f\n", n, verts[n]);
    }
       
    /* Load up vertice polygon connections array */
    connect = 0;
    for (n = 0; n < (SEGMENTS*5); n+= 5)
    {
	/* inside tube */
        tube_list[n]   = connect;
        tube_list[n+1] = connect+2;
        tube_list[n+2] = connect+3;
        tube_list[n+3] = connect+1;
        tube_list[n+4] = -1;

        connect += 2;
    }

    for (n = 0; n < (SEGMENTS*5); n++)
    {
	printf("tube_list[%d] = %d\n", n, tube_list[n]);
    }
    
    /*printf("LEAVE: geantCYL()\n");*/
    return;
}


/******************************************************************************/
/* A R R O W   A R R O W    A R R O W   A R R O W   A R R O W   A R R O W   A */
/******************************************************************************/

void geantARROW(int geo, float rad_stem, float rad_base, float half_z)
{
float z_stem, z_top;
    z_stem = half_z;
    z_top  = half_z/4.;
    cxGeoTranslate(0., 0., -1/20.*half_z);
    geantCONS(geo, z_stem, 0., rad_stem, 0., rad_stem, 0.0, 360.0,12);
    geantCONS(geo, z_top, 0., rad_base, 0., 0., 0.0, 360.0,12);
}

/******************************************************************************/
/* N O N   S U P P O R T E D   N O N   S U P P O R T E D   N O N   S U P P O R*/
/******************************************************************************/
