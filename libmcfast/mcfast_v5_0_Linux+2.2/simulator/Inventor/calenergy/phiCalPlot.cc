#include "phiCalPlot.hh"
SoSeparator *phiCalPlot::MakePlotFrame(int ncal, int *pical)
{
    SoSeparator *calFrame = new SoSeparator;

    Calorimeter *cal = new Calorimeter;
    calFrame->addChild(cal->calPhiView(ncal,pical));
    delete cal;

    return calFrame;

}
