/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFXYPlaneKit                                         */
/* Description:      Represents a XY Plane                                   */
/* Author:           Amber Boehnlein 1/11/97                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef SOMCFXYPLANEKIT
#define SOMCFXYPLANEKIT
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
class SoSFNode;
class SoMcFXYPlaneKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFXYPlaneKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(Appearance);
  SO_KIT_CATALOG_ENTRY_HEADER(Transform);
  SO_KIT_CATALOG_ENTRY_HEADER(Plane);
   

public:

  // Constructor, required
  SoMcFXYPlaneKit();

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

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFXYPlaneKit();

};

#endif
