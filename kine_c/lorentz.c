/*
*
*  lorentz.c
*
*/

#include <math.h>
#include <stdlib.h>
#include <ntypes.h>
#include <kinematics.h>

float beta2gamma(float beta)
{
  float gamma;

  gamma = 1 / sqrt(1 - pow(beta,2));

  return gamma;
}

float gamma2beta(float gamma)
{
  float beta;

  beta = sqrt(1 - 1 / pow(gamma,2));

  return beta;
}

float p2gamma(vector4_t p)
{
  float gamma;

  gamma = p.t / v4mass(p);

  return gamma;
}

float p2beta(vector4_t p)
{
  float beta;

  beta = v3mag(p.space) / p.t;
  
  return beta;
}

float beta_p_2mass(float p, float beta){
  return(p/(beta2gamma(beta)*beta));
}

vector4_t v4boost(vector3_t beta, vector4_t p)
{
  float magbeta,gamma,betasq,factor,beta_dot_p;
  vector3_t first, second, third, sum;
  vector3_t add[3];
  vector4_t boost;

  magbeta = v3mag(beta);
  gamma = beta2gamma(magbeta);
  betasq = pow(magbeta,2);
  factor = (gamma - 1) / betasq;
  beta_dot_p = v3dot(beta,p.space);

  first = p.space;
  second = v3mult((factor * beta_dot_p),beta);
  third = v3mult(-(gamma * p.t),beta);

  sum = v3add(first, second);
  sum = v3add(sum, third);

  boost.t = gamma * (p.t - beta_dot_p);
  boost.space = sum;

  return boost;
}
/*---------------------------------------------------------------------------*/
#ifndef ELECTRON_MASS
  #define ELECTRON_MASS     0.00051100 
#endif
#ifndef PROTON_MASS
  #define PROTON_MASS       0.93827
#endif

vector4_t Lab2ResonanceFrame(float BeamEnergy, vector4_t Electron4, vector4_t V4){

  /* Rotates the 4-vector V4 into the ep->R->epX resonance center of mass frame, with the 
     z-direction along the virtual photon direction, and the x-z plane in the electron scattering 
     plane.  y-direction is Beam X ScatteredElectron.
     This is done in two stages: 1) first rotate in the lab CM frame so that z-axis is parallel 
     with virtual photon direction, then 2) boost to resonance rest frame.
     This routine hasn't been fully tested yet.

     input:  BeamEnergy : beam energy (GeV) in lab frame
             Electron4  : scattered electron in lab frame
     output: V4         : input vector in lab frame to be rotated to resonance frame 
     author: Richard A Thompson
             University of Pittsburgh                                                        
  */

  int i,j ;
  float RotationMatrix[3][3];                /* rotation matrix to rotate lab frame with z along 
					        virtual photon direction           */
  vector3_t Coord3[3] = {{1.0, 0.0, 0.0},    /* coordinate system axes             */
			 {0.0, 1.0, 0.0},                    
			 {0.0, 0.0, 1.0}};
  vector3_t NewCoord3[3];                    /* The rotated axes                   */
  vector3_t ResonanceBeta3;                  /* beta 3-vector for the resonance    */
  vector4_t Beam4, Photon4, Target4, Resonance4;    /* in lab frame                */
  vector4_t RotatedV4, RotatedResonance4;           /* in resonance frame          */

  /* initialize 4 vectors */
  Beam4.space.x = Beam4.space.y = 0.;
  Beam4.space.z = sqrt(BeamEnergy*BeamEnergy - ELECTRON_MASS*ELECTRON_MASS);
  Beam4.t       = BeamEnergy;
  Target4.space.x = Target4.space.y = Target4.space.z = 0.0;
  Target4.t       = PROTON_MASS;
  Photon4    = v4sub(Beam4, Electron4);
  Resonance4 = v4add(Photon4, Target4);
  
  /*    STEP 1: rotate lab frame  */
  /* first form vectors for the new coordinate system */
  NewCoord3[2] = Photon4.space;                         /* z is photon direction */
  NewCoord3[1] = v3cross(Beam4.space, Electron4.space); /* y is perp. to electron plane */
  NewCoord3[0] = v3cross(NewCoord3[1], NewCoord3[2]);      
  /* form the rotation matrix */
  for(i=0; i<3; i++){
    for(j=0; j<3; j++){
      RotationMatrix[i][j] = v3cos_angle(NewCoord3[i], Coord3[j]);
    }
  }
  /* rotate resonance and V4 - there must be a more clever way to do this */
  for(i=0; i<3; i++){
    float * PtrV                = &(V4.space.x);      /* pointers for easy matrix multiplication */
    float * PtrRotatedV         = &(RotatedV4.space.x);
    float * PtrResonance        = &(Resonance4.space.x);
    float * PtrRotatedResonance = &(RotatedResonance4.space.x);
    PtrRotatedV[i]         = 0.0;
    PtrRotatedResonance[i] = 0.0;
    for(j=0; j<3; j++){
      PtrRotatedV[i]         += RotationMatrix[i][j]*PtrV[j];
      PtrRotatedResonance[i] += RotationMatrix[i][j]*PtrResonance[j];
    }
  }
  RotatedV4.t = V4.t;
  RotatedResonance4.t = Resonance4.t;

  /*    STEP 2: boost to the resonance center of mass */
  ResonanceBeta3.x = RotatedResonance4.space.x/RotatedResonance4.t;
  ResonanceBeta3.y = RotatedResonance4.space.y/RotatedResonance4.t;
  ResonanceBeta3.z = RotatedResonance4.space.z/RotatedResonance4.t;
  RotatedV4 = v4boost(ResonanceBeta3, RotatedV4);
  return RotatedV4;
}
