#include "etaCalPlot.hh"
#ifndef SOTRANSFORMS
#define SOTRANSFORMS
#include <Inventor/nodes/SoRotation.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoMaterial.h>
#endif
etaCalPlot::etaCalPlot(void)
{
    eventInformation *eventInfo = eventInformation::eventInfo();
    energy = eventInfo->calEtaEnergy();
}
SoSeparator *etaCalPlot::MakeEnergyPlot(void)
{
    
    SoSeparator *calHits = new SoSeparator;
     
    SoRotationXYZ *zRotation = new SoRotationXYZ;
    zRotation->axis = SoRotationXYZ::Z;
    zRotation->angle = M_PI/2.;

    calHits->addChild(zRotation);

    SoRotationXYZ *Rotation = new SoRotationXYZ;
    Rotation->axis = SoRotationXYZ::X;
    Rotation->angle = M_PI/2.;
    
    calHits->addChild(Rotation);

    calHits->addChild(FillInEnergy());
    return calHits;

}
SoSeparator *etaCalPlot::MakePlotFrame(int ncal, int *pical)
{
    SoSeparator *calFrame = new SoSeparator;
    SoSeparator *cells = new SoSeparator;
    SoSeparator *frame = new SoSeparator;
    SoSeparator *solid = new SoSeparator;
    SoDrawStyle *frameStyle = new SoDrawStyle;

    frameStyle->style = SoDrawStyle::LINES;
 
    SoMaterial *calColor = new SoMaterial;
    calColor->diffuseColor.setValue(0.0,0.0,0.0);

    Calorimeter *cal = new Calorimeter;
    cells = cal->calEtaView(ncal,pical);
    
    frame->addChild(frameStyle);
    frame->addChild(calColor);
    frame->addChild(cells);
    
    SoDrawStyle *solidStyle = new SoDrawStyle;
    solidStyle->style = SoDrawStyle::FILLED;
    solid->addChild(solidStyle);
    solid->addChild(cells);
    SoRotationXYZ *zRotation = new SoRotationXYZ;
    zRotation->axis = SoRotationXYZ::Z;
    zRotation->angle = M_PI/2.;

    calFrame->addChild(zRotation);
    
    SoRotationXYZ *Rotation = new SoRotationXYZ;
    Rotation->axis = SoRotationXYZ::X;
    Rotation->angle = M_PI/2.;

    calFrame->addChild(Rotation);

    calFrame->addChild(frame);
    calFrame->addChild(solid);
    delete cal;

    return calFrame;

}
