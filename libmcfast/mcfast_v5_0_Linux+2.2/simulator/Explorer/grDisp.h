/* ntuBuild
** Creation Date : Sat Nov  4 13:04:38 1995
**  User Comments
** This ntuple descibes the display variables that can be modified in the Expl
** orer 
** Module DetDisplay
*/    
#define idet_max 1
typedef struct DetDisplayConfig_struct{
    char version[12]; /* Version token */
    int idet; /* Generalized Ntuple Multiplicity value */ 
    int            detnumber; /* number of the detector */
    int            visibility; /* Describes the display mode, 0 is invisible, 1 is solid, 2 is wireframe */
    int            nsides; /* describes the number of sides used to render the "cylinder" */
    int            frame; /* draw a frame around the object 0 for no, 1 for yes */
    int            cutaway; /* describes if the object is shown solid or cross sectional */
    float          angle_begin; /* start angle for the cut */
    float          angle_end; /* end angle for the cut */
    float          transparency; /* transparancy for solid objects 0 is opaque 1 is invisible */
    float          red; /* red component of the color */
    float          green; /* green component of the color */
    float          blue; /* blue component of the color */
    int fence; 
} DetDisplayConfig_struct; 
