/*******************************************************/
/* PATLIB_externs.h - Explorer - Dave Swoboda - 9/2/94 */
/* mcf_explorer.h 2/22/95                              */
/*******************************************************/

#define SEGMENTS 12

extern grGeneral    * GeomList[1000];
extern int		GeomNumber;

extern int	num_verts;              /* number of x-y-z triplets */
extern int	num_connections;        /* */
extern float	*verts;                 /* x,y,z tripplets */
extern int	*tube_list;
extern int	connections[];

extern float grColors[16][3];
