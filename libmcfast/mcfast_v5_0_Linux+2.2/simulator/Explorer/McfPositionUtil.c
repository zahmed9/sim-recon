#include "Mcf_Explorer_typedefs.h"
#include "McfPositionUtil.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
float GetLength(struct Position v1, struct Position v2){
/*returns the length of the difference of two vectors*/
struct Vector temp;
  MakeVect(&v1,&v2,&temp);
  return GetMagn(temp); 
}
double GetCos(struct Vector v1, struct Vector v2){  
   return (GetDot(v1,v2)/(GetMagn(v1)*GetMagn(v2)));
}
double GetDot(struct Vector v1, struct Vector v2){
   return (v1.i*v2.i+v1.j*v2.j+v1.k*v2.k);
}
double GetMagn(struct Vector v1){
   return  (sqrt(v1.i*v1.i+v1.j*v1.j+v1.k*v1.k));
}
void MakeVect(struct Position *p1, struct Position *p2, struct Vector *v1){
  v1->i = p1->x - p2->x; 
  v1->j = p1->y - p2->y; 
  v1->k = p1->z - p2->z; 
}
