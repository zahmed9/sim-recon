/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoCalEnergyKit                                            */
/* Description:      Calorimeter Cell Kit                                    */
/* Author:           Amber Boehnlein January 9, 1997                         */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFCalEnergyKit_hh_
#define __SoMcFCalEnergyKit_hh_
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
#include <Inventor/fields/SoSFNode.h>
#include <Inventor/fields/SoSFFloat.h>
struct projectiveCalData;
class McFProjectiveCal;
class SoMcFCalEnergyKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFCalEnergyKit);
  ////////////////////////////////////////////
  SoSFNode alternateRep;
  ////////////////////////////////////////////
  SO_KIT_CATALOG_ENTRY_HEADER(callbackList);
  SO_KIT_CATALOG_ENTRY_HEADER(topSeparator);
  SO_KIT_CATALOG_ENTRY_HEADER(calCellKit);
   

public:

   SoSFFloat minEnergy;
   SoSFFloat hadEnergy;
   SoSFFloat emEnergy;
   SoSFFloat cellEt;
  // Constructor, required
  SoMcFCalEnergyKit();

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
  //set the color of the cell based on energy
  void defineCellColor(float energy, float maxEnergy);
  static void resetPick(void);

private: 

  // This is needed as well
  void createInitialTree();

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFCalEnergyKit();
  //reset to clear selection
  static void resetSelected(void);
  static void selectCB(void *userData, SoEventCallback *eventCB);

};

#endif
