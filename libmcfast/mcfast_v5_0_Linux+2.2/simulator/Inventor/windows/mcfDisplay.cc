#include <iostream.h>
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/actions/SoLineHighlightRenderAction.h>
#include <Inventor/nodes/SoOrthographicCamera.h>
#include <Inventor/nodes/SoPointLight.h>
#include "mcfDisplay.hh"
#include "mcfPlotWindow.hh"
#include "mcfPickInfoWindow.hh"
#include "ivFileDetPlot.hh"
#include "handlePick.hh"
mcfDisplay::~mcfDisplay(void)
{
    delete cdisplay; 
    delete tdisplay;
    delete ddisplay;
    delete hdisplay;

}
void mcfDisplay::makeMcfDisplay(SoXtViewer *Viewer)
{
    // add a camera and lights
    //SoOrthographicCamera *orthoCam = new SoOrthographicCamera;
    //geometry->addChild(orthoCam);

    //SoPointLight *ptLight = new SoPointLight;
    //geometry->addChild(ptLight);
    cdisplay -> makeCalPlot(geometry, calHitPlot.type, calInfo);
    tdisplay -> makeTraceDisplay(geometry, tracePlot, traceInfo );
    ddisplay -> makeDetPlot(geometry, detectorPlot.type);
    hdisplay -> makeHitsDisplay(geometry, hitsPlot, hitsInfo);
    //if(ivPlot.type == IVFILE) geometry->addChild(ivFileDetPlot::makeDetector());
    
    geometry->setName("Geometry");
    geometry->ref();

    SoXtExaminerViewer *Renderer = (SoXtExaminerViewer *)
                                       Viewer; 
    Renderer->setSceneGraph(geometry);
    Renderer->setTitle("McFast Display");
    Renderer->show();
    tracePlot.action = NOACTION;
    calHitPlot.action = NOACTION;
    hitsPlot.action = NOACTION;

}
void mcfDisplay::updateMcfDisplay(void)
{
    cdisplay -> updateCalPlot(geometry, calHitPlot.action, calInfo);
    tdisplay -> updateTraceDisplay(geometry, tracePlot, traceInfo);
    hdisplay -> updateHitsDisplay(geometry, hitsPlot, hitsInfo);
    tracePlot.action = NOACTION;
    calHitPlot.action = NOACTION;
    hitsPlot.action = NOACTION;
}
void mcfDisplay::updateMcfTraceDisplay(traceDispInfo tinfo)
{
    
    tracePlot.action = NEWPARAMETERS;
    changeTraceInfo( tinfo );
    tdisplay -> updateTraceDisplay(geometry, tracePlot, traceInfo);
    tracePlot.action = NOACTION;
}
void mcfDisplay::updateMcfHitsDisplay(hitsDispInfo tinfo)
{
    
    hitsPlot.action = NEWPARAMETERS;
    changeHitsInfo( tinfo );
    hdisplay -> updateHitsDisplay(geometry, hitsPlot, hitsInfo);
    hitsPlot.action = NOACTION;
}
void mcfDisplay::updateMcfCalHitDisplay(calDispInfo cinfo)
{
    
    calHitPlot.action = NEWPARAMETERS;
    if( cinfo.dispFrame != calInfo.dispFrame)
    {
       if( cinfo.dispFrame == ON ) calHitPlot.action = ADDFRAME;
       if( cinfo.dispFrame == OFF ) calHitPlot.action = REMOVEFRAME;

    }
    changeCalInfo( cinfo );
    cdisplay -> updateCalPlot(geometry, calHitPlot.action, calInfo);
    calHitPlot.action = NOACTION;
}
void mcfDisplay::updateMcfCalHitDisplay(void)
//this is the one that gets called when the energy scale changes
{
    
    calHitPlot.action = NEWPARAMETERS;
    if(cdisplay != NULL)
         cdisplay -> updateCalPlot(geometry, calHitPlot.action, calInfo);
    calHitPlot.action = NOACTION;
}

