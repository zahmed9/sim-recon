#include "threeDPlot.hh"
SoSeparator *threeDPlot::MakePlotFrame(int ncal, int *)
{
    SoSeparator *calFrame = new SoSeparator;
    calFrame->ref();

    Calorimeter *cal = new Calorimeter;
    calFrame->addChild(cal->calSimpleView(ncal));
    delete cal;
    calFrame->unrefNoDelete();
    return calFrame;

}
