/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFDetectorTreeKit                                    */
/* Description:      Detector tree kit for McFast detectors                  */
/* Author:           Joe Boudreau Nov 11 1996                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef SOMCFDETECTORTREEKIT
#define SOMCFDETECTORTREEKIT
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
#include <Inventor/SoPath.h>
#include <Inventor/SoNodeKitPath.h>
#include <Inventor/fields/SoSFInt32.h>
#include <Inventor/fields/SoSFString.h>
#include "McFDetDevice.hh"
class SoSFNode;
class SoMcFDetectorTreeKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFDetectorTreeKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;  
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(pickStyle);
  SO_KIT_CATALOG_ENTRY_HEADER(appearance);
  SO_KIT_CATALOG_ENTRY_HEADER(units);
  SO_KIT_CATALOG_ENTRY_HEADER(transform);
  SO_KIT_CATALOG_ENTRY_HEADER(texture2Transform);
  SO_KIT_CATALOG_ENTRY_HEADER(childList);
  SO_KIT_CATALOG_ENTRY_HEADER(previewSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(fullSeparator);
   

public:

  // Constructor, required
  SoMcFDetectorTreeKit();

  // This is required
  virtual SbBool affectsState() const;

  // Class Initializer, required
  static void initClass();

  // Turn the preview on or off
  virtual void setPreview(SbBool Flag);

  // Do not display
  virtual void setOff(void); 

  // Return the preview state
  virtual SbBool getPreview() const;
    
  //is the state visible?
  virtual SbBool isVisible() const;

  // Return the preview Separator
  virtual SoSeparator *getPreviewSeparator() const;

  // Return the full Separator
  virtual SoSeparator *getFullSeparator() const;
  // Generate AlternateRep, required.  Generating an alternate representation
  // must be done upon users request.  It allows an Inventor program to read
  // back the file without requiring *this* code to be dynamically linked. 
  // If the users expects that *this* code will be dynamically linked, he
  // need not invoke this method.  
  virtual void generateAlternateRep();

  // We better be able to clear it, too!
  virtual void clearAlternateRep();

  // data to keep track of detectors
    SoSFString name;
    SoSFInt32 id;
    McFDetDevice device;
    int whichDevice; 

protected:

  // This is needed as well
  void createInitialTree();

  // This is the callback function that will be 
  // added to the callback list
  static void   expand   (void *userData, SoEventCallback *eventCB);
  static void   contract (void *userData, SoEventCallback *eventCB);
  static void   color    (void *userData, SoEventCallback *eventCB);
  static void   wire     (void *userData, SoEventCallback *eventCB);
  static void   gone     (void *userData, SoEventCallback *eventCB);
  static void   solid    (void *userData, SoEventCallback *eventCB);
  static void   selectCB (void *userData, SoEventCallback *eventCB);
  
 //return selected kit to orignal state
  static void resetSelected(void);
  
 //get SoMcFDetectorTreeKit from pick
 
  static SoMcFDetectorTreeKit *findAncestorNode(SoNodeKitPath *path){
  // Find the one that's been picked.  This is the lowest
  //detector tree kit in the hierarchy.
    SoNode *ancestorNode=NULL;
    for (int i=0;i<path->getLength();i++) {
        ancestorNode  = path->getNodeFromTail(i);
        if (ancestorNode->isOfType(SoMcFDetectorTreeKit::getClassTypeId())) 
            return (SoMcFDetectorTreeKit *) ancestorNode;
    }
    return NULL;
  }
  
  //virtual functions for getting detector specific information
  
  //virtual SoMcFDetectorTreeKit *sameAs( void ) = 0;

  void whoAmI(char *string){
     strcpy(string, "I am an SoMcFDetectorTreeKit");
     return;
  }
  

private:
  // Destructor.  Required.  Always Private.
  virtual ~SoMcFDetectorTreeKit();

};

#endif
