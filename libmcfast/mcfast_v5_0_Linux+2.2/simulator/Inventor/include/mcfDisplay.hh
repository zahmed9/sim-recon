#include "calDisplayInfo.hh"
#include "traceDisplayInfo.hh"
#include "calDisplay.hh"
#include "traceDisplay.hh"
#include "detectorDisplay.hh"
#include "hitsDisplay.hh"
#include "mcfPlotDefine.hh"
#include "displayTypes.hh"
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoSelection.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#ifndef MCFDISPLAY
#define MCFDISPLAY
class mcfDisplay
{
   private:
        displayType calHitPlot;
        displayType tracePlot;
        displayType detectorPlot;
        displayType hitsPlot;
        displayType ivPlot;
        calDispInfo calInfo;
        traceDispInfo traceInfo;
        hitsDispInfo hitsInfo;
        SoSeparator *geometry;
        calDisplay *cdisplay;
        traceDisplay *tdisplay;
        detectorDisplay *ddisplay;
        hitsDisplay *hdisplay;
                
   public:
        mcfDisplay(void)
        {
            plotTypeInitialize(&calHitPlot);
            plotTypeInitialize(&tracePlot);
            plotTypeInitialize(&detectorPlot);
            plotTypeInitialize(&hitsPlot);
            plotTypeInitialize(&ivPlot);
            calDispInfoInitialize(calHitPlot, &calInfo);
            traceDispInfoInitialize(&traceInfo);
            hitsDispInfoInitialize(&hitsInfo);
            geometry = new SoSeparator;
            cdisplay = new calDisplay;
            tdisplay = new traceDisplay;
            ddisplay = new detectorDisplay;
            hdisplay = new hitsDisplay;
        }
        mcfDisplay(mcfPlotDefine &plot)
        {
            plotTypeSet(plot.calHits, &calHitPlot);
            plotTypeSet(plot.traces, &tracePlot);
            plotTypeSet(plot.detector, &detectorPlot);
            plotTypeSet(plot.trackHits, &hitsPlot);
            plotTypeSet(plot.ivFile, &ivPlot);
            calDispInfoInitialize(calHitPlot, &calInfo);
            traceDispInfoInitialize(&traceInfo);
            hitsDispInfoInitialize(&hitsInfo);            
            geometry = new SoSeparator;
            cdisplay = new calDisplay;
            tdisplay = new traceDisplay;
            ddisplay = new detectorDisplay;
            hdisplay = new hitsDisplay;
        }
        ~mcfDisplay(void);
        void changeCalDisplay( displayType cdisp )
        {
            plotTypeSet(cdisp, &calHitPlot); return;
             
        }
        void changeTraceDisplay( displayType tdisp )
        {
            plotTypeSet(tdisp, &tracePlot);
        }
        void changeHitsDisplay( displayType hdisp )
        {
            plotTypeSet(hdisp, &hitsPlot);
        }
        traceDispInfo getTraceInfo( void )
        {
           return traceInfo;
        }
        hitsDispInfo getHitsInfo( void )
        {
           return hitsInfo;
        }
        calDispInfo getCalInfo( void )
        {
           return calInfo;
        }
         void changeCalInfo( calDispInfo cinfo )
        {
            calDispInfoSet(cinfo, &calInfo); return;
             
        }
        void changeTraceInfo( traceDispInfo tinfo )
        {
            traceDispInfoSet(tinfo, &traceInfo);
        }
        void changeHitsInfo( hitsDispInfo tinfo )
        {
            hitsDispInfoSet(tinfo, &hitsInfo);
        }
        void updateMcfTraceDisplay(traceDispInfo tinfo);
        void updateMcfCalHitDisplay(calDispInfo cinfo);
        void updateMcfHitsDisplay(hitsDispInfo tinfo);
        void updateMcfCalHitDisplay(void);
        void makeMcfDisplay(SoXtViewer *Viewer);
        void updateMcfDisplay(void);
        SoSeparator *getGeometry(void)
        {
            return geometry;
        }
        PlotTypes calPlotType(void)
        {
           return calHitPlot.type;
        }
        PlotTypes tracePlotType(void)
        {
           return tracePlot.type;
        }
        PlotTypes detectorPlotType(void)
        {
           return detectorPlot.type;
        }
};
#endif
