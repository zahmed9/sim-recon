/***********************************************/
/* PATLIB_prototypes.h - Dave Swoboda - 9/2/94 */
/* mcf_explorer_prototypes.h 2/22/95           */
/***********************************************/
/*****************************************/
/* FORTRAN RECEPTOR FUNCTION DEFINITIONS */
/*****************************************/
void define_box2_f_(grGeneral *igr, int *ndet, char fstring[], 
                   float *xlen_out, float *ylen_out, float *zlen_out,
                   float *xlen_inn, float *ylen_inn, float *zlen_inn,                   
                   int flen);

void define_conetube_f_(grGeneral *igr, int *ndet, char fstring[], float *half_z, 
			float *rad_in_lowz, float *rad_out_lowz, 
			float *rad_in_hiz, float *rad_out_hiz, 
			int flen);
void define_arrow_f_(grGeneral *igr, int *ndet, char fstring[], float *axis_rot, 
                        float *alpha, float *rad_stem, float *rad_base,
			float *half_z, int flen);
			
void GeomDefineBox(grGeneral *igr, float half_x, float half_y, float half_z);

void GeomDefineBox2(grGeneral *igr, 
                   float *xlen_out, float *ylen_out, float *zlen_out,
                   float *xlen_inn, float *ylen_inn, float *zlen_inn);
                   
void GeomDefineTrd1(grGeneral *igr, float half_x_lowz, float half_x_hiz,
			float half_y, float half_z);

void GeomDefineTube(grGeneral *igr, float rad_in, float rad_out, 
			float half_z);

void GeomDefineTubs(grGeneral *igr, float rad_in, float rad_out, 
			float half_z, float phi_begin, float phi_end);

void GeomDefineCone(grGeneral *igr, float half_z, float rad_in_lowz, 
			float rad_out_lowz, float rad_in_hiz, float rad_out_hiz);

void GeomDefineCons(grGeneral *igr, float half_z, float rad_in_lowz, 
			float rad_out_lowz, float rad_in_hiz, float rad_out_hiz, 
			float phi_begin, float phi_end);

void GeomDefineCyl(grGeneral *igr, float radius, float half_z, 
			float phi_begin, float phi_end);

void GeomDefineArrow(grGeneral *igr, float *axis_rot, float alpha, 
                        float rad_stem, float rad_base, 
 			float half_z); 
			
void GeomDefineTrack(grGeneral *igr);

void GeomUpdate(grGeneral * igr);

void GeomDrawObject(grShape * igr);

char *getFortranString(char *fstring, int flen);

void box_connections( int box_type, int *ct); 

int inner_box ( float *xilen, float *yilen, float *zilen,
                float *xolen, float *yolen, float *zolen,
                int *num_vert, int *num_conn);
                
/*void AddNormals(int num_vert, float *pvert);
                
int VectNormalize(struct Vector *vect);              

void GetNormal(struct Vector *v1, struct Vector *v2, struct Vector *v3);

int GeoNormalAdd(int nnormal, struct Vector *v);*/

/******************************************************************************/
/* PATLIB_ObjLib.h - Dave Swoboda - 8/17/94			      */
/* mcf_explorer_ObjLib.h 2/22/95                                              */
/******************************************************************************/

/*************************/
/* function declarations */
/*************************/   
void geantBOX(int geo, float half_x, float half_y, float half_z);
void geantBOX2(int geo, float *xlen, float *ylen, float *zlen, float *vert);
void geantTUBE(int geo, float rad_in, float rad_out, float half_z);
void geantTUBS(int geo, float rad_in, float rad_out,
		float half_z, float phi_begin, float phi_end);
void geantCONE(int geo, float half_z, float rad_in_low, float rad_out_low,
		float rad_in_high, float rad_out_high);
void geantCONS(int geo, float half_z, float rad_in_low, float rad_out_low,
                float rad_in_high, float rad_out_high,
		float phi_begin, float phi_end, int nsides);
void geantCYL(int geo, float radius, float half_z, float phi_begin, 
		float phi_end);
void geantARROW(int geo, float rad_stem, float rad_base, float half_z);


void GeomShapeOut(int ndet);
int MakeDetectorList(int ndet,char *cstring);
int ModifyDetector(int idet, grDisplay r);
int GetDetectorParameters(int idet, grDisplay *pr);
int GetLink(int ndet, grShape **igr);
int GetDevNum(char *string);
int FreeDetList(void);
char *FindAllType(char *string);
