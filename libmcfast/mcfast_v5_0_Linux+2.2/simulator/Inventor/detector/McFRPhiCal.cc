#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoTransform.h>
#include "grDevType.hh"
#include "McFRPhiCal.hh"
#include "hepvis/SoMcFConsKit.hh"
#include "hepvis/SoG4Cons.hh"
#include <iostream.h>

McFRPhiCal::McFRPhiCal(void)
{
//nominal calorimeter!
    calData.z0 =     0.0; 
    calData.zLength = 200.0; 
    calData.rMin[0] = 10.0;
    calData.rMin[1] = 10.0; 
    calData.rMax[0] = 50.0; 
    calData.rMax[1] = 50.0;
    calData.nPhi = 64;
    calData.nEta = 20;
    name = new char[100];
    return;
}
McFRPhiCal::~McFRPhiCal()
{
}
McFRPhiCal::McFRPhiCal(float pos, float zlen, float radmin[2],
                       float radmax[2], int nphi, int neta, char *string)
{ 
    calData.z0 = pos; 
    calData.zLength = zlen; 
    calData.rMin[0] = radmin[0];
    calData.rMin[1] = radmin[1]; 
    calData.rMax[0] = radmax[0]; 
    calData.rMax[1] = radmax[1];
    calData.nPhi = nphi;
    calData.nEta = neta;
    strcpy(name, string);
    return;
}

void McFRPhiCal::setCalData(projectiveCalData data)
{
    calData.z0 = data.z0; 
    calData.zLength = data.zLength; 
    calData.rMin[0] = data.rMin[0];
    calData.rMin[1] = data.rMin[1]; 
    calData.rMax[0] = data.rMax[0]; 
    calData.rMax[1] = data.rMax[1];
    calData.nPhi = data.nPhi;
    calData.nEta = data.nEta ;
    return;
}

void McFRPhiCal::setFullRepresentation(SoSeparator *full)
{

}
void McFRPhiCal::setPreviewRepresentation(SoSeparator *prev)
{
    SoMcFConsKit *calConsKit = new SoMcFConsKit();
               
    SoG4Cons *calCons = (SoG4Cons *) calConsKit->getPart("cons", TRUE);
    calCons->fRmin1 = this->calData.rMin[0];
    calCons->fRmin2 = this->calData.rMin[1];
    calCons->fRmax1 = this->calData.rMax[0];
    calCons->fRmax2 = this->calData.rMax[1];
    calCons->fDz = this->calData.zLength/2.;
    
    calCons->generateAlternateRep();
    calConsKit->generateAlternateRep();
    prev->addChild(calConsKit);

}
void McFRPhiCal::setCellIndices(int icr1, int icr2, 
                                      SoCoordinate3 *coords)
{
     float dR = (calData.rMax[0] - calData.rMin[0])/calData.nEta;
     float x[8], y[8], z[8];
     int iR = icr2;
     
       //use 1/2 segment
       x[0] =  (dR*iR+calData.rMin[0])*cos(M_PI/calData.nPhi);
       y[0] = -(dR*iR+calData.rMin[0])*sin(M_PI/calData.nPhi);
       z[0] =  - 0.5*calData.zLength;
     
       y[1] = - y[0]; x[1] = x[0]; z[1] = z[0]; 
       
       x[4] =  (dR*iR+calData.rMin[0])*cos(M_PI/calData.nPhi);
       y[4] = -(dR*iR+calData.rMin[0])*sin(M_PI/calData.nPhi);
       z[4] =  0.5*calData.zLength;
     
       y[5] = - y[4]; x[5] = x[4]; z[5] = z[4]; 
       
       x[3] =   (dR*(iR+1)+calData.rMin[0])*cos(M_PI/calData.nPhi);
       y[3] =  -(dR*(iR+1)+calData.rMin[0])*sin(M_PI/calData.nPhi);
       z[3] =  - 0.5*calData.zLength;
     
       y[2] = - y[3]; x[2] = x[3]; z[2] = z[3]; 

       x[7] =   (dR*(iR+1)+calData.rMin[0])*cos(M_PI/this->calData.nPhi);
       y[7] =  -(dR*(iR+1)+calData.rMin[0])*sin(M_PI/this->calData.nPhi);
       z[7] =   0.5*calData.zLength;
     
       y[6] = - y[7]; x[6] = x[7]; z[6] = z[7]; 
      
        for (int i = 0; i < 8; i++)
        coords->point.set1Value(i,x[i],y[i],z[i]);
	return;
      

}
void McFRPhiCal::setCellTransform(int icr1, int icr2, 
                                         SoTransform *transform)
{
    int nPhi = this->calData.nPhi;
    float angle = (2*icr1*M_PI)/nPhi + M_PI/nPhi;
    
    transform->rotation.setValue(SbVec3f(0.0, 0.0, 1.0), angle);
    return;
}    
void McFRPhiCal::setDetectorTranslation(SoTransform *transform)
{
      transform->translation.setValue(0.,0.0, this->calData.z0);
      return;
 
}
