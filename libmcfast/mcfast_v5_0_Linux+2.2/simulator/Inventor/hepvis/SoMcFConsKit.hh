/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFConsKit                                       */
/* Description:      Easy way of browsing through a tree of detectors        */
/* Author:           Joe Boudreau Nov 11 1996                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFConsKit_hh_
#define __SoMcFConsKit_hh__
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
class SoSFNode;
class SoMcFConsKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFConsKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(appearance);
  SO_KIT_CATALOG_ENTRY_HEADER(transform);
  SO_KIT_CATALOG_ENTRY_HEADER(cons);


public:

  // Constructor, required
  SoMcFConsKit();

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

private: 

  // This is needed as well
  void createInitialTree();

  // This is the callback function that will be 
  // added to the callback list
  static void   cutView (void *userData, SoEventCallback *eventCB);
  static void   color    (void *userData, SoEventCallback *eventCB);

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFConsKit();

};

#endif
