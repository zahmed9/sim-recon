#include <cx/DataTypes.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/Geometry.h>
#include <cx/Lookup.h>
#include "Mcf_Explorer_typedefs.h"
#include "Mcf_Explorer_prototypes.h"
#include "Mcf_Explorer_externs.h"


void AddNormals(int num_vert, float *pvert){
struct Vector d1, d2;
struct Vector norm;
struct Vector *face;
struct Vector *normal;
unsigned int side;

    face = (struct Vector *) malloc ((num_vert/2.) * sizeof(struct Vector));
    normal = (struct Vector *) malloc ((num_vert) * sizeof(struct Vector));

    /* loop over the faces and find the normals to each face */ 
    /* What an indexing horror!  Will convert to vertex structures as time
       permits asb */
       printf("pvert = %f,%f%f\n",pvert[0],pvert[1],pvert[2]);
       for (side = 0; side < 3*(num_vert/2); side +=3){
          d1.i = pvert[2*side+0] - pvert[2*side+3];
          d1.j = pvert[2*side+1] - pvert[2*side+4];
          d1.k = pvert[2*side+2] - pvert[2*side+5];
          d2.i = pvert[2*side+3] - pvert[2*side+6];
          d2.j = pvert[2*side+4] - pvert[2*side+7];
          d2.k = pvert[2*side+5] - pvert[2*side+8];          
          GetNormal(&d1,&d2,&norm);
          face[side/3].i = norm.i;
          face[side/3].j = norm.j;
          face[side/3].k = norm.k;
        }
         for(side = 0; side < num_vert/2.; side++){
           if(side == 0){
             norm.i = face[side].i + face[num_vert/2].i;
             norm.j = face[side].j + face[num_vert/2].j;
             norm.k = face[side].k + face[num_vert/2].k;
           }else{
             norm.i = face[side].i + face[side-1].i;
             norm.j = face[side].j + face[side-1].j;
             norm.k = face[side].k + face[side-1].k;
           }
          printf("normals = %f,%f,%f\n",norm.i,norm.j,norm.k);           
           VectNormalize(&norm);
           normal[2*side+0].i = norm.i;
           normal[2*side+0].j = norm.j;
           normal[2*side+0].k = norm.k;
           normal[2*side+1].i = norm.i;
           normal[2*side+1].j = norm.j;
           normal[2*side+1].k = norm.k;
           }
/*        GeoNormalAdd(num_vert,normal);*/
        free(face); free(normal);
        return;
}
void GetNormal(struct Vector *v1, struct Vector *v2,  struct Vector *v3){
/* input two vectors, v1, v2 */
/* returns the normalized cross product of two vectors v3*/
     v3->i = v1->j*v2->k - v1->k*v2->j;
     v3->j = v1->k*v2->i - v1->i*v2->k;
     v3->k = v1->i*v2->j - v1->j*v2->i;     
     VectNormalize(v3);     
     return;       
}
int VectNormalize(struct Vector *vect){
   /* normalizes a vector-- replaces input v[i] with normalized vpri[i] */
   float d;
   d = sqrt(vect->i*vect->i + vect->j*vect->j + vect->k*vect->k);
      if (d == 0.0){
        printf("error normalizing vector!\n");
        return -1;
      }
      vect->i /= d; vect->j /= d; vect->k /= d;
      return 0;
}
int GeoNormalAdd(int nnormal, struct Vector *v){
int n;
float *pv;
  if(n < 1){
    return -1;
    }
  pv = (float *) malloc((nnormal*3)*sizeof(float));  
  for(n=0; n<nnormal; n++){
     pv[(3*n)+0] = v[n].i;
     pv[(3*n)+1] = v[n].j;
     pv[(3*n)+2] = v[n].k;    
  }
  cxGeoNormalAdd(nnormal, pv, CX_GEO_PER_VERTEX);
  free (pv);
  return 0; 
}
