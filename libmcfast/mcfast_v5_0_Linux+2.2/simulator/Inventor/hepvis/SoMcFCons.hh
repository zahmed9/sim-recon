/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFCons                                               */
/* Description:      Represents the McFCons  Geometry entity                 */
/* Author:           Amber Boehnlein May 5, 1997                             */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFCons_hh_
#define __SoMcFCons_hh__
#include <Inventor/fields/SoSFNode.h>
#include <Inventor/fields/SoSFBool.h>
#include <Inventor/fields/SoSFInt32.h>

#include <Inventor/nodes/SoShape.h>

class SoSFNode;
class SoMcFCons:public SoShape {

  // The following is required:
  SO_NODE_HEADER(SoMcFCons);
 
public:


  // // This shape is based on SoG4Cons, but allows the user to specify the
  // // the number of segments in phi  This is useful for representing the
  // // silicon disk wedges and cons shapes which need more/less fine 
  // // segmentation than SoG4Cons
  // // Member Data:
  // //
  // //      fRmin1  inside radius at  -fDz
  // //      fRmin2  inside radius at  +fDz
  // //      fRmax1  outside radius at -fDz
  // //      fRmax2  outside radius at +fDz
  // //      fDz     half length in z
  // //
  // //      fSPhi   starting angle of the segment in radians
  // //      fDPhi   delta angle of the segment in radians
  // //
  // //      nPhi  the number of phi segments the object


  // Always use Inventor Fields. This allows Inventor to detect a change to
  // the data field and take the appropriate action; e.g., redraw the scene.

  SoSFFloat fRmin1;   
  SoSFFloat fRmin2;   
  SoSFFloat fRmax1;
  SoSFFloat fRmax2;
  SoSFFloat fDz;
  SoSFFloat fSPhi;
  SoSFFloat fDPhi; 
  SoSFInt32 nPhi;            
  SoSFBool  smoothDraw;            // slightly better render, worse performance
  SoSFNode  alternateRep;          // the alternate representation, required

  // Constructor, required
  SoMcFCons();

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

protected:

  // computeBBox, required
  virtual void computeBBox(SoAction *action, SbBox3f &box, SbVec3f &center );

  // Generate Primitives, required
  virtual void generatePrimitives(SoAction *action);

  // GLRender, required
  virtual void GLRender(SoGLRenderAction *action); 

  // GetChildList, required whenever the class has hidden children
  virtual SoChildList *getChildren() const;


private: 

  // Destructor.  Required.  Always Private.
  virtual ~SoMcFCons();

  // Generate Children. Used to create the hidden children. Required whenever
  // the node has hidden children.  
  void generateChildren();  

  // Used to modify hidden children when a data field is changed. Required 
  // whenever the class has hidden children. 
  void updateChildren();

  // ChildList. Required whenever the class has hidden children.  
  SoChildList *children;

};

#endif
