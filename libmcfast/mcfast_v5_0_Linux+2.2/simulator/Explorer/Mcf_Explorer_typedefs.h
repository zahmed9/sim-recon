#ifndef EXPLORER
#define EXPLORER
#include <cx/DataTypes.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/Geometry.h>
#endif
/********************************************************************************
* 										*
* PATLIB_typedefs.h - Explorer - Dave Swoboda - 9/2/94	                        *
* mcf_explorer_typedefs.h 2/22/95      				                *
*										*
* Goal:	Construct a structure on which we can build simple utilities to		*
* 	exchange mcfast detector elements, in order to feed various graphical	*
* 	engines, such as SciAn or Explorer.  We do not whish to call directly	*
*       Explorer routines, but create a "buffer" structure, to keep with mcfast	*
*       with mcfast pure and simple, without explicit graphics stuff		*
*										* 
********************************************************************************/

/*      
Further technical notes:
 
COLOR:	The color convention follows something almost standard nowadays : the RGB 
	scheme. The f. p. numbers ranging from 0. to 1., refering to a relative 
	Red, Blue and Green intensity. e.g. Green is (0., 1., 0.), Yellow is 
        (1., 1., 0.) and so forth. 
                
TRANSP:	The transparency is a f.p. number between 0. and 1., If 1., the object 
        is a solid fill, if 0., you don't see it, I guess.. In between, the 
        rendering becomes system dependent
        
TREE:	Provision is made for establishing a hierachical tree. The first version 
	of the utility routines will not support that option, e.g., all the 
	objects will have 0 children, and the parent index is set to 0.
        
ROT:	The rotation matrix has clearly some redundant information, but not
        choosing a straight 3X3 matrix will lead to infinite discussion about
        rotation axis, vs Euler angle, vs Geant rotation...  
*/

#ifndef GR_TYPES_DEFINED
#define GR_TYPES_DEFINED
typedef enum _grvolumeType {
    BOX, CONE, ARROW, PLANE, WIRE 
} grvolumeType;
typedef enum _grdevType{
  BMPIPE,ABSORBER, ABSORBERXY, DIPOLE,SOLENOID,
  DRTCHMB, SIBAR, SIDISK, SIXY, FWTRK,
  CAL, XYCAL, MUON, ZRECT
} grdevType;
#define WRITE 1
#define READ 0
#define X_ROTATION 0.
#define Y_ROTATION 0.
#define Z_ROTATION 1.
#define SHEER  0.9
#define OPAQUE 0.5
#define MATTE  0.0
#define DEFAULT_NSIDES 12
#define CUT 1
#define NOCUT 0
#define FRAME 1
#define NOFRAME 0
#define ANGLE_BEGIN 0.0
#define ANGLE_END 360.0
typedef enum _grvolumeVis{
 INVISIBLE, SOLID, WIREFRAME
} grvolumeVis;
#define MaxDetectors 300;
#endif
#ifndef Pos
#define Pos
typedef struct Position{
    double x;
    double y;
    double z;
}Position;
#endif
#ifndef Vec
#define Vec
typedef struct Vector{
    double i;
    double j;
    double k;
}Vector;
#endif
#ifndef Mom
#define Mom
typedef struct Momentum{
     double px;
     double py;
     double pz;
}Momentum;
#endif
#ifndef GR_COLORS_DEFINED
#define GR_COLORS_DEFINED
typedef enum _grColorType {
    GR_RED, GR_PEACH, GR_YELLOW, GR_LTGREEN, GR_GREEN, GR_BLUEGREEN,
        GR_CYAN, GR_LTBLUE, GR_BLUE, GR_MAGENTA, GR_INDIGO, GR_VIOLET,
            GR_WHITE, GR_GREY, GR_BLACK
} grColorType;
#endif
/*******************************************************************************
******************************* Shape struct **********************************
*******************************************************************************/
#ifndef Rgb
#define Rgb
typedef struct grRgb{
   double red;
   double green;
   double blue;
}grRgb;
#endif
#ifndef Display
#define Display
typedef struct grDisplay{
    long visibility;
    long nsides;
    long cutaway;
    double angle_begin;
    double angle_end;
    double transparency;
    struct grRgb color;
}grDisplay;
#endif
#ifndef Trace
#define Trace
typedef struct grTrace{
    long id;
    int stable;              /* is the particle stable?*/
    long charge;             
    long trace_type;
    long tracedisp;
    long hitdisp;
    double eta;
    double px,py,pz;
    double mass;
    double p;
    double pt;
    struct grRgb color;       /*color scheme used at moment*/
    struct grRgb tcolor;       /*color scheme according to charge*/
    struct grRgb hcolor;       /*color scheme according to particle heritage*/
    struct grRgb scolor;       /*color scheme according to quark composition*/
    cxGeo geotag;
    int mother;
    int firstdaughter;
    int lastdaughter;
    long userData;             /* I'm not sure...*/   
}grTrace;
#endif
#ifndef ParColor
#define ParColor
typedef struct grParColor{
    long id;
    long num;
    struct grRgb color;       /*color scheme according to traces*/
}grParColor;
#endif
#ifndef Event
#define Event
typedef struct grEvent{
    int eventNum;
    int nParticles;
    grTrace *particles;
    /*Widget tree;*/
    int *treehead;      
}grEvent;
#endif

#ifndef Shape
#define Shape

typedef struct grShape {

    /* START GENERAL STRUCT SHARED BY ALL GEOM */
    struct grShape *pnext_link;
    int		type;		/* type of volume 				*/
    int 	id_number;	/* Identifies item to users */
    int         devtype;         /* type of device */			
    char        * name;		/* name, to refer to an element or medium	*/
    int 	id_parent;	/* The parent id number				*/
    int 	num_child;	/* The number of children			*/
    int 	* children;	/* The childs					*/
    float 	xpos;		/* The x position of the object (center)   	*/
    float 	ypos;		/* The y position                          	*/
    float 	zpos;		/* The z position                          	*/
    float 	rotation[3];	/* The rotation matrix                    	*/
    float 	color[3];	/* The RGB color				*/
    float 	transparency;	/* Transparency					*/
    int 	visibility;	/* If flag set to 0, graphics not drawn*/
    int    	cutaway; 	/* If flag set to 1, show cutaway*/
    float       angle_begin;     /* start angle for cut view */
    float       angle_end;     /* end angle for cut view */
    int         nsides;          /* number of polygons to represent tube */
    int         frame;           /* allow for framing detectors*/
    /* Allow for box type geometry */

    float 	xlen_out[2];    /* The outer box length in X                 */
    float 	ylen_out[2];	/* The outer box length in Y                 */
    float	zlen_out[2];    /* The outer box length in Z  		     */
    float 	xlen_inn[2];    /* The inner box length in X                 */
    float 	ylen_inn[2];	/* The inner box length in Y                 */
    float	zlen_inn[2];    /* The inner box length in Z 	             */  
    /* Allow for cone type geometry */
    float 	half_z;		/* The half length along the z axis       	*/
    float 	rad_in_lowz;	/* The inner radius at the lowz side		*/
    float 	rad_out_lowz;	/* The outer radius at the lowz side		*/
    float 	rad_in_hiz;	/* The inner radius at the hiz side		*/
    float 	rad_out_hiz;	/* The outer radius at the hiz side		*/
      

} grShape;
#endif

/******************************************************************************/
/* grGeneral - The common part for all the volume			      */
/******************************************************************************/

#ifndef GENERAL
#define GENERAL

typedef struct _grGeneral {

    /* START GENERAL STRUCT SHARED BY ALL GEOM */

    int		type;		/* type of volume 				*/
    int 	id_number;	/* Identifies item to users 			*/
    char        * name;		/* name, to refer to an element or medium	*/
    int 	id_parent;	/* The parent id number				*/
    int 	num_child;	/* The number of children			*/
    int 	* children;	/* The childs					*/
    float 	xpos;		/* The x position of the object (center)   	*/
    float 	ypos;		/* The y position                          	*/
    float 	zpos;		/* The z position                          	*/
    float 	rotation[3];	/* The rotation matrix                    	*/
    float 	color[3];	/* The RGB color				*/
    float 	transparency;	/* Transparency					*/
    int 	visibility;	/* If flag set to 0, the graphics not drawn	*/
    int         cutaway;        /* if flag set to 1, use cutaway view */
    float       angle_begin;     /* start angle for cut view */
    float       angle_end;     /* end angle for cut view */
    int         nsides;          /* number of polygons to represent tube */
} grGeneral;

#endif

