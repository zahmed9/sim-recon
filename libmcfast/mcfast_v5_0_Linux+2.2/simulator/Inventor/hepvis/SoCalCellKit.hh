/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoCalCellKit                                            */
/* Description:      Calorimeter Cell Kit                                    */
/* Author:           Amber Boehnlein January 9, 1997                         */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFCalCellKit_hh_
#define __SoMcFCalCellKit_hh__
#include <Inventor/nodekits/SoBaseKit.h>
#include <Inventor/nodes/SoEventCallback.h>
struct projectiveCalData;
class SoSFNode;
class SoMcFCalCellKit:public SoBaseKit {

  // The following is required:
  SO_KIT_HEADER(SoMcFCalCellKit);
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
  SO_KIT_CATALOG_ENTRY_HEADER(block);
   

public:

   SoSFFloat cellEnergy;
   SoSFFloat cellEt;
   SoSFInt32 cellIeta;
   SoSFInt32 cellIphi;
   SoSFInt32 cellIcal;

  // Constructor, required
  SoMcFCalCellKit();

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

//user method for generating the cell representation
void generateCellRepresentation(int type, projectiveCalData calData); 

private: 

  // This is needed as well
  void createInitialTree();

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFCalCellKit();

  //cell vertices
  void setCellVertices(McFProjectiveCal *Calorimeter)
};

#endif
