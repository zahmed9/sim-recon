/**********************************************/
/* PATLIB_globalloc.h - Dave Swoboda - 9/2/94 */
/* mcf_explorer_globalloc.h 2/22/95           */
/**********************************************/

/********************************/
/* Global resolution definition */
/********************************/
#define SEGMENTS 13 

/************************/
/* GLOBAL GEOMETRY DATA */
/************************/
int 	num_verts;		/* number of x-y-z triplets */
int	num_connections;	/* */
float	*verts; 		/* x,y,z tripplets */
int	*tube_list;
int 	connections[] = {0,1,2,3,0,-1,3,2,6,7,3,-1,7,6,5,4,7,-1,4,5,1,0,4,-1,
			1,5,6,2,1,-1,0,3,7,4,0,-1};

float grColors[16][3] = {
    {1.0,0.0,0.0},      /* red          */
    {1.0,0.5,0.0},      /* orange       */
    {1.0,0.5,0.5},      /* peach        */
    {1.0,1.0,0.0},      /* yellow       */
    {0.5,1.0,0.5},      /* ltgreen      */
    {0.0,1.0,0.0},      /* green        */
    {0.0,1.0,0.5},      /* bluegreen    */
    {0.0,1.0,1.0},      /* cyan         */
    {0.0,0.5,1.0},      /* ltblue       */
    {0.0,0.0,1.0},      /* blue         */
    {1.0,0.0,0.5},      /* magenta      */
    {0.5,0.0,1.0},      /* indigo       */
    {1.0,0.0,1.0},      /* violet       */
    {1.0,1.0,1.0},      /* white        */
    {0.5,0.5,0.5},      /* grey         */
    {0.25,0.25,0.25}    /* black        */
};

/****************/
/* SETTUP LISTS */
/****************/
#ifndef GEOMSTUFF
#define GEOMSTUFF
grGeneral *     GeomList[1000];
int             GeomNumber;
#endif

#define GR_MAX_NAME_LENGTH 80

/* state values for controls and indicators */
#define VALUE_SET 1
#define VALUE_NOT_SET 0
#define VALUE_UNDERFLOW (-1)
#define VALUE_OVERFLOW (-2)
