/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoD0Circle                                               */
/* Description:      Represents the McFCons  Geometry entity                 */
/* Author:           Amber Boehnlein May 5, 1997                             */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef __SoD0Circle_hh_
#define __SoD0Circle_hh__
#include <Inventor/fields/SoSFNode.h>
#include <Inventor/fields/SoSFBool.h>
#include <Inventor/nodes/SoShape.h>

class SoSFNode;
class SoD0Circle:public SoShape {

  // The following is required:
  SO_NODE_HEADER(SoD0Circle);
 
public:


  // //  draws a circle with fixed radius
  // //
  // //      fRadius of circle


  // Always use Inventor Fields. This allows Inventor to detect a change to
  // the data field and take the appropriate action; e.g., redraw the scene.

  SoSFFloat fRadius;   
  SoSFBool  smoothDraw;            // slightly better render, worse performance
  SoSFNode  alternateRep;          // the alternate representation, required

  // Constructor, required
  SoD0Circle();

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
  virtual ~SoD0Circle();

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
