#include "displayTypes.hh"
#ifndef TRACEDISPLAYTYPES
#define TRACEDISPLAYTYPES
enum {TRACE, TRACK, NEUTR, PARENT, ALL};
struct traceDispInfo
{
  int PlotTrack;
  int PlotTrace;
  int PlotNeutr;
  double EtaMin; 
  double EtaMax;
  int MomType;
  double MomMin;
  int itrack;       //identifier for track
  int trackAction;  // what to do to track (turn it off, turn on hits)
  PlotActions Action;       //overall action
  PlotTypes PlotType;     //type of plot
};
#endif
