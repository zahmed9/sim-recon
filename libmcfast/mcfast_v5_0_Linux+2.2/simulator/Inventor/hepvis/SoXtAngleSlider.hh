#include <Inventor/Xt/SoXtComponent.h>

class SoG4Cons;
class SoSFFloat;

/********************************************************************/
/*     SoXtAngleSlider.hh                                           */
/*                                                                  */
/*     This class makes two sliders for interactive control of      */
/*     the angles used to make conical and tubular sections.        */
/*     This allows for interactive cutaway views.                   */
/*                                                                  */
/*     Written January 13, 1997   Amber Boehnlein, FNAL CD          */
/********************************************************************/

#ifndef _SOXTANGLESLIDER_
#define _SOXTANGLESLIDER_

class SoXtAngleSlider : public SoXtComponent
{

   public:
      // Constructor
      SoXtAngleSlider(
         Widget parent = NULL,
         const char *name = NULL,
         SbBool BuildInsideParent = TRUE);
         
     ~SoXtAngleSlider(); //I'm confused about why the component 
                      //destructors are public...
      
      void attachSliders(SoG4Cons *c); 
      SbBool isAttached(void)
      {
         return ( ( cons != NULL ) );
      }              

   private:
      Widget buildWidget(Widget parent);
      
      SoG4Cons *cons;      
      Widget SPhiSlider;  //The slider widgets 
      Widget FPhiSlider;
      
      static void angleCB(Widget, XtPointer, XtPointer);  //callBack function

         
}; 

#endif 
