/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFZRectWaferKit                                           */
/* Description:      Represents a silicon XY  plane                          */
/* Author:           Amber Boehnlein 1/11/97                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFZRectWaferKit_hh_
#define __SoMcFZRectWaferKit_hh__
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
class SoSFNode;
class SoMcFZRectWaferKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFZRectWaferKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(appearance);
  SO_KIT_CATALOG_ENTRY_HEADER(transform);
  SO_KIT_CATALOG_ENTRY_HEADER(wafer);
   

public:

  // Constructor, required
  SoMcFZRectWaferKit();

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
  
  //clear out the pick info
  void static resetPick(void);

  
  //A number to get the hit information
  int hitid;

private: 

  // This is needed as well
  void createInitialTree();

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFZRectWaferKit();
  
  //callback function for printing out data
  static void printHit(void *userData, SoEventCallback *eventCB);
};

#endif
