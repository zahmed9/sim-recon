/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoHandleBoxKit                                          */
/* Description:      Use a handlebox to crop the objects displayed           */
/* Author:           Amber Boehnlein Aug. 27, 1997                           */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoHandleBoxKit_hh_
#define __SoHandleBoxKit_hh__
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
class SoSFNode;
class SoHandleBoxKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoHandleBoxKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(childList);
  SO_KIT_CATALOG_ENTRY_HEADER(cropSwitch);
  SO_KIT_CATALOG_ENTRY_HEADER(fullSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(cropSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(handleBoxSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(handleBox);
   

public:
  SoSFVec3f size;
  SoSFVec3f center;

  // Constructor, required
  SoHandleBoxKit();

  // This is required
  virtual SbBool affectsState() const;

  // Class Initializer, required
  static void initClass();

  // Turn the crop/not crop on or off
  virtual void setCrop(SbBool Flag);

  // Return the crop/not crop state
  virtual SbBool getCrop() const;

  // Turn the handleBoxDragger on or off
  virtual void setBoxVisible(SbBool Flag);

  // Return the  handleBoxDragger state
  virtual SbBool getBoxVisible() const;


  // Generate AlternateRep, required.  Generating an alternate representation
  // must be done upon users request.  It allows an Inventor program to read
  // back the file without requiring *this* code to be dynamically linked. 
  // If the users expects that *this* code will be dynamically linked, he
  // need not invoke this method.  
  virtual void generateAlternateRep();

  // We better be able to clear it, too!
  virtual void clearAlternateRep();

private: 
  //flag for first enable of the handlebox.
  //On first enable, make handlebox big enough to hold all object
  //On subsequent enables, leave handlebox at last user defined setting
  SbBool firstTime;
  
  // This is needed as well
  void createInitialTree();

  // This is the callback function that will be 
  // added to the callback list
  static void   EnableHandleBox(void *userData, SoEventCallback *eventCB);
  static void   DisableHandleBox(void *userData, SoEventCallback *eventCB);
  static void   FullView(void *userData, SoEventCallback*eventCB);
  static void   HandleBoxPick(void *userData, SoEventCallback *eventCB);
  
  //This is to generate what goes under the cropped separator
  void generateCrop(void);
  void calculateBoxSize(void);

  // Destructor.  Required.  Always Private.
  virtual ~SoHandleBoxKit();

};

#endif
