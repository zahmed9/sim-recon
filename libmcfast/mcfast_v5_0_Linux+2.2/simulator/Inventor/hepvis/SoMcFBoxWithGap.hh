/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoMcFBoxWithGap                                         */
/* Description:      Represents the dipoles, X-Y Calorimeters                */
/* Author:           Amber Boehnlein 1/31/97                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoMcFBoxWithGap_hh_
#define __SoMcFBoxWithGap_hh__
#include <Inventor/fields/SoSFNode.h>
#include <Inventor/fields/SoSFBool.h>
#include <Inventor/nodes/SoShape.h>

class SoSFNode;
class SoMcFBoxWithGap:public SoShape {

  // The following is required:
  SO_NODE_HEADER(SoMcFBoxWithGap);
 
public:

  //This is box with a gap in the middle.  In McFast it is used represent
  //dipole magnets and X-Y calorimeters.

  // Always use Inventor Fields. This allows Inventor to detect a change to
  // the data field and take the appropriate action; e.g., redraw the scene.

  SoSFFloat fDxInner;                  
  SoSFFloat fDxOuter;
  SoSFFloat fDyInner;
  SoSFFloat fDyOuter;
  SoSFFloat fDzInner;
  SoSFFloat fDzOuter;
  SoSFNode  alternateRep;          // the alternate representation, required

  // Constructor, required
  SoMcFBoxWithGap();

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
  virtual ~SoMcFBoxWithGap();

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
