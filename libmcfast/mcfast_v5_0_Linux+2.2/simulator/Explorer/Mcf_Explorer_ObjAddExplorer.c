/******************************************************************************/
/* PATLIB_ObjAddExplorer.c - Dave Swoboda - 9/2/94			      */
/*  modified to handle wire frame option  (visibility = 2)  plm 1-31-95       */
/*  Mcf_Explorer_ObjAddExplorer.c 2/22/95                                     */
/******************************************************************************/

/*******************************
** Explorer Geometry Includes **
*******************************/
#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_prototypes.h"
#include "Mcf_Explorer_externs.h"

/*#include <cx/Geometry.h>*/		/* for cxGeoColorAdd */
/* Standard functions */
#include <math.h>  use for rotations

/*********************
** GLOBAL VARIABLES **
*********************/
/*extern int geo;*/
extern float col[4];

void GeomDrawObject(grShape * igr)
{

int i;
float *vert; /* vertices */
int   *conn; /* connections to vertices*/
int   num_vert;
int   num_conn;
int   box_type;
double phi;
double cosalpha;
double cosbeta;
double cosgamma;
static int ObjNum = 0;
printf("ENTER: GeomDrawObject\n");
    cxGeoXformPush();
    ObjNum++;
    cxGeoLabelAdd(igr->name); 
    cxGeoTranslate(igr->xpos, igr->ypos, igr->zpos);
    cxGeoColorAdd(1,igr->color,CX_GEO_PER_OBJECT);
    cxGeoTransparencyAdd(1,&igr->transparency,CX_GEO_PER_OBJECT);
/*  Setup for rotation: Rotations are handled local to the object, but are
    explained once here where the angles are defined.
    First rotate about the Z axis by phi, the angle of rotation in the
    x-y plane:  phi = tan-1(cos beta/cos alpha), then rotate by gamma about
    the perpendicular to the direction of the object in the x-y plane*/

    cosalpha = igr->rotation[0]; cosbeta = igr->rotation[1]; cosgamma =
    igr->rotation[2];
    phi = atan2(cosbeta,cosalpha);   


    
/*               
	cxGeoRotate(igr->rotation[0],1.0,0.0,0.0);
	cxGeoRotate(igr->rotation[1],0.0,1.0,0.0);
	cxGeoRotate(igr->rotation[2],0.0,0.0,1.0);
*/

    printf("geomdraw, rad_in_lowz,rad_out_lowz %s,%f,%f,%f,%f\n",
        igr->name,igr->rad_in_lowz,igr->rad_out_lowz,igr->rad_in_hiz,
                  igr->rad_out_hiz);
        
	if (igr->type == BOX) {
	    box_type =
	    inner_box(igr->xlen_inn,igr->ylen_inn,igr->zlen_inn,
	              igr->xlen_out,igr->ylen_out,igr->zlen_out,
	              &num_vert,&num_conn);
	    printf("box type =%d\n",box_type);
	    vert = (float *) malloc((num_vert*3) * sizeof(float));
	    conn = (int   *) malloc((num_conn)   * sizeof( int ));
	    geantBOX2(1,igr->xlen_out,igr->ylen_out,
	                         igr->zlen_out,&vert[0]);
	    geantBOX2(1,igr->xlen_inn,igr->ylen_inn,
	                         igr->zlen_inn, &vert[24]);
	     box_connections(box_type,conn);	          	                  	          	    
	    if (igr->visibility == 1){
    		    cxGeoPolysDefine(num_vert,vert,num_conn,conn);
    		    cxGeoRotate(phi,0.0,0.0,1.0);
                    cxGeoRotate(acos(cosgamma),cos(phi),-sin(phi),0.0);
	    } else if (igr->visibility ==2){
    		    cxGeoLinesDefine(num_vert,vert,num_conn,conn);
    		    cxGeoRotate(phi,0.0,0.0,1.0);
                    cxGeoRotate(acos(cosgamma),cos(phi),-sin(phi),0.0);
	    }
	    free (vert); free (conn);
	} else if  (igr->type == CONE) {
            if(igr->cutaway == 1){
                igr->angle_begin =   0.;
                igr->angle_end   = 360.;
            }
	    if (igr->visibility == 1)
	    {
		    num_verts = 4*(igr->nsides+1); num_connections = ((igr->nsides*20)+10);
		    verts 	= (float *) malloc((num_verts*3) * sizeof(float));
		    tube_list	= (int *) malloc((num_connections) * sizeof(int));
    	            geantCONS(1, igr->half_z, igr->rad_in_lowz, igr->rad_out_lowz,
    	    		    igr->rad_in_hiz, igr->rad_out_hiz,
    	    		    igr->angle_begin,igr->angle_end,igr->nsides);
		    cxGeoPolysDefine(num_verts, verts, num_connections, tube_list);
	            cxGeoRotate(phi,0.0,0.0,1.0);
                    cxGeoRotate(acos(cosgamma),-cos(phi),sin(phi),0.0);
		    free(verts); free(tube_list);
	    } else if (igr->visibility == 2)
	    {
		    num_verts = 4*(igr->nsides+1); num_connections = ((igr->nsides*20)+10);
		    verts 	= (float *) malloc((num_verts*3) * sizeof(float));
		    tube_list	= (int *) malloc((num_connections) * sizeof(int));
    	            geantCONS(1, igr->half_z, igr->rad_in_lowz, igr->rad_out_lowz,
    	    		    igr->rad_in_hiz, igr->rad_out_hiz,
    	    		    igr->angle_begin,igr->angle_end,igr->nsides);
		    cxGeoLinesDefine(num_verts, verts, num_connections, tube_list);
	            cxGeoRotate(phi,0.0,0.0,1.0);
                    cxGeoRotate(acos(cosgamma),-cos(phi),sin(phi),0.0);
		    free(verts); free(tube_list);
	    }  
  
	}

        if ( cxDataAllocErrorGet() ) cleanup_selected();
    cxGeoXformPop();
printf("LEAVE: GeomDrawObject\n");
}
