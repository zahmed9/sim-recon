#include <iostream.h>
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/SoPickedPoint.h>
#include <Inventor/SoPath.h>
#include <Inventor/nodes/SoLineSet.h>
#ifndef HANDLEPICK
#define HANDLEPICK
enum pickSelect {SELECT, DESELECT};
enum pickStyle  {LINES, FILLED};

const int MAXNAME = 40;
const int MAXSTRING = 1000;


//this set of routines handles the pick information.
SoSeparator *getMeaningfulSep(SoPath *path);
char *pickMessage(SoPath *path, pickSelect state);
void traceMessage(char *name, char *output);
void calorMessage(char *name, char *output);
void detectorMessage(char *name, char *output);
void materialHighlight(SoSeparator *base, pickSelect state, pickStyle pStyle);     
#endif
