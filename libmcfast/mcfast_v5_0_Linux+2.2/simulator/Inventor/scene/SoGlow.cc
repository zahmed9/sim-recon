#include <Inventor/actions/SoCallbackAction.h>
#include <Inventor/actions/SoGLRenderAction.h>
#include <Inventor/bundles/SoMaterialBundle.h>
#include <Inventor/elements/SoEmissiveColorElement.h>
#include "hepvis/SoGlow.h"

SO_NODE_SOURCE(SoGlow);

void SoGlow::initClass()
{
    SO_NODE_INIT_CLASS(SoGlow, SoNode, "Node");
}

SoGlow::SoGlow()
{
   //Do standard constructor tasks
   SO_NODE_CONSTRUCTOR(SoGlow);
   
   //add "color" field to the field data.  The default value is white
   SO_NODE_ADD_FIELD(color, (1.0, 1.0, 1.0));
   
   //add brightness to the field state.  The default value is 0
   SO_NODE_ADD_FIELD(brightness, (0.0));
}

//destructor
SoGlow::~SoGlow()
{
}

//Implements GL render action
void SoGlow::GLRender(SoGLRenderAction *action)
{

   //Set the elements in the state correctly.  Note that we
   //prefix the call to doAction() with the class name.  This
   //avoids problems if someone derives a new class from the 
   //Glow node and inherits the GLRender() method; Glow's 
   //doAction will still be called in that case.
   
   SoGlow::doAction(action);
   
   //For efficiency, Inventor nodes make sure that the first
   //defined material is always in GL, so shapes do not have to 
   //send the first material each time.  (This keeps caches from
   //being dependent on material values in many cases.) The 
   //S0MaterialBundle class allows us to do this easily
   SoMaterialBundle mb(action);
   mb.forceSend(0);
   
}

//Implements callback action
void SoGlow::callback(SoCallbackAction *action)
{
   //Set the elements in the state correctly,
   SoGlow::doAction(action);
}

//Typical action implementation - it sets the correct elements
//in the action's traversal state.  We assume that the element
//has been enabled.  
void SoGlow::doAction(SoAction *action)
{
   //Make sure the brightness field is not ignored.
   
   if(!brightness.isIgnored())
   {
      emissiveColor = color.getValue() * brightness.getValue();
      SoEmissiveColorElement::set(action->getState(), this, \
      1, &emissiveColor);
   }
}
