/*
*
*  vector3.c
*
*/

#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <ntypes.h>
#include <kinematics.h>

float v3dot(vector3_t v1,vector3_t v2)
{
  float dot;
  
  dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;

  return dot;
}

vector3_t v3cross(vector3_t v1,vector3_t v2)
{
  vector3_t cross;

  cross.x = v1.y * v2.z - v1.z * v2.y;
  cross.y = v1.z * v2.x - v1.x * v2.z;
  cross.z = v1.x * v2.y - v1.y * v2.x;

  return cross;
}


float v3magsq(vector3_t v)
{
  float magsq;

  /*  magsq = v3mag(v); */
  /*  magsq *= magsq; */
  magsq = (v.x)*(v.x) + (v.y)*(v.y) + (v.z)*(v.z);

  return magsq;
}

float v3mag(vector3_t v)
{
  float mag;

  mag = sqrt((v.x)*(v.x) + (v.y)*(v.y) + (v.z)*(v.z));

  return mag;
}

float v3radius(vector3_t v)
{
  float radius;

  radius = sqrt( (v.x)*(v.x) + (v.y)*(v.y));

  return radius;
}

vector3_t v3norm(vector3_t v)
{
  vector3_t norm;
  float mag = v3mag(v);

  norm.x = v.x / mag;
  norm.y = v.y / mag;
  norm.z = v.z / mag;

  return norm;
}

void v3dir(vector3_t v,float *theta_p,float *phi_p)
{
  float r=v3mag(v),rho;

  rho = sqrt(v.x*v.x + v.y*v.y);

  *theta_p = acos(v.z / r);
  *phi_p = acos(v.x / rho);
  if(v.y < 0) 
    *phi_p = 2 * PI - *phi_p;
}

void v3dir_deg(vector3_t v,float *theta_p,float *phi_p)
{
  float r=v3mag(v),rho;

  rho = sqrt(v.x *v.x + v.y*v.y);

  *theta_p = acos(v.z / r) * 180 / PI;
  *phi_p = acos(v.x / rho) * 180 / PI;
  if(v.y < 0) 
    *phi_p = 360 - *phi_p;
}

float v3cos_angle(vector3_t v1,vector3_t v2)
{
  float cosine;

  cosine = v3dot(v1,v2)/(v3mag(v1)*v3mag(v2));

  return cosine;
}

float v3angle(vector3_t v1,vector3_t v2)
{
  float angle;

  angle = acos(v3dot(v1,v2)/(v3mag(v1)*v3mag(v2)));

  return angle;
}

float v3angle_deg(vector3_t v1,vector3_t v2)
{
  float angle;

  angle = acos(v3dot(v1,v2)/(v3mag(v1)*v3mag(v2))) * 180 / PI;

  return angle;
}

vector3_t v3add(vector3_t v1,vector3_t v2)
{
  vector3_t sum;

  sum.x = v1.x + v2.x;
  sum.y = v1.y + v2.y;
  sum.z = v1.z + v2.z;

  return sum;
}

vector3_t v3sub(vector3_t v1,vector3_t v2)
{
  vector3_t diff;

  diff.x = v1.x - v2.x;
  diff.y = v1.y - v2.y;
  diff.z = v1.z - v2.z;

  return diff;
}

vector3_t v3mult(float factor,vector3_t v)
{
  vector3_t mult;

  mult.x = v.x * factor;
  mult.y = v.y * factor;
  mult.z = v.z * factor;

  return mult;
}

vector3_t v3div(float divisor,vector3_t v)
{
  vector3_t div;

  div.x = v.x / divisor;
  div.y = v.y / divisor;
  div.z = v.z / divisor;

  return div;
}

vector3_t xyz2v3(void *xyz){
  vector3_t v3;
  return(*((vector3_t *)(xyz)));
}

void v3print(FILE *stream, vector3_t vec){
  fprintf(stream, "x: %f, y:%f, z:%f\n", vec.x, vec.y, vec.z);
}
