/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcfTraceKit                                           */
/* Description:      Represents a trace                                      */
/* Author:           Amber Boehnlein 9/3 /97                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFTraceKit_hh_
#define __SoMcFTraceKit_hh__
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
class SoSFNode;
class SoMcFTraceKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFTraceKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(Appearance);
  SO_KIT_CATALOG_ENTRY_HEADER(Transform);
  SO_KIT_CATALOG_ENTRY_HEADER(Coord3);
  SO_KIT_CATALOG_ENTRY_HEADER(LineSet);
  SO_KIT_CATALOG_ENTRY_HEADER(PointSet);
   

public:

  // Constructor, required
  SoMcFTraceKit();

  // This is required
  virtual SbBool affectsState() const;

  // Class Initializer, required
  static void initClass();

  // Generate AlternateRep, required.  Generating an alternate representation
  // must be done upon users request.  It allows an Inventor program to read
  // back the file without requiring *this* code to be dynamically linked. 
  // If the users expects that *this* code will be dynamically linked, he
  // need not invoke this method.  
  virtual void generateAlternateRep();

  // We better be able to clear it, too!
  virtual void clearAlternateRep();
  
  //a reset for the pick information
  static void resetPick(void);

  
  //A number to get the trace information
  int traceid;

private: 

  // This is needed as well
  void createInitialTree();

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFTraceKit();
  
  //callback function for printing out data
  static void printTrace(void *userData, SoEventCallback *eventCB);
};

#endif
