//This is an example of inheriting from a property node form the 
//Inventor toolmaker p. 29

#include <Inventor/SbColor.h>
#include <Inventor/fields/SoSFColor.h>
#include <Inventor/fields/SoSFFloat.h>
#include <Inventor/nodes/SoSubNode.h>

class SoGlow : public SoNode
{
    SO_NODE_HEADER(SoGlow);
    
    public:

      //member data
      SoSFColor color;      //color of glow
      SoSFFloat brightness;  //amount of glow (0-1)
      
      //Initializes this class for use in scene graphs.  This 
      //should be called after database initialization and before
      //any instance of this node is constructed
      
      static void initClass(void);
      
      //Constructor is public
      SoGlow();
      
    protected:
      //There implement supported actions.  The only actions that
      //deal with materials are the callback and GL render actions.
      //We will inherit all other action methods from SoNode
      
      virtual void GLRender(SoGLRenderAction *action);
      virtual void callback(SoCallbackAction *action);
      
      //this implements generic traversal of Glow node, used in both of the
      //above methods
      
      virtual void doAction(SoAction *action);
      
    private:
      //Destructor is private to prevent subversion of the reference counting
      //mechanism
      
      virtual ~SoGlow();
      
      //member data that holds the emissive color
      
      SbColor   emissiveColor;
};
