//  -*- C++ -*-

/*
 * Copyright (C) 1990,91   Silicon Graphics, Inc.
 *
 _______________________________________________________________________
 ______________  S I L I C O N   G R A P H I C S   I N C .  ____________
 |
 |   $Revision$
 |
 |   Description:
 |	This file contains the class description for the SoXtColorPatch.
 |
 |   Author(s)	: Alain Dumesny
 |
 ______________  S I L I C O N   G R A P H I C S   I N C .  ____________
 _______________________________________________________________________
 */

#ifndef  _SO_XT_COLOR_PATCH_
#define  _SO_XT_COLOR_PATCH_

#include <Inventor/Xt/SoXtGLWidget.h>
#include <Inventor/SbColor.h>


//////////////////////////////////////////////////////////////////////////////
//
//  Class: SoXtColorPatch
//
//	This class simply draws a 3D looking patch of color.
//
//////////////////////////////////////////////////////////////////////////////

// C-api: prefix=SoXtColPatch
class SoXtColorPatch : public SoXtGLWidget {

  public:
    
    SoXtColorPatch(
	Widget parent = NULL,
	const char *name = NULL, 
	SbBool buildInsideParent = TRUE);
    ~SoXtColorPatch();
    
    //
    // set/get routines to specify the patch top color
    //
    // C-api: name=setCol
    void		setColor(const SbColor &rgb);
    // C-api: name=getCol
    const SbColor &	getColor()	{ return color; }
  
  protected:

    // This constructor takes a boolean whether to build the widget now.
    // Subclasses can pass FALSE, then call SoXtSlider::buildWidget()
    // when they are ready for it to be built.
    SoEXTENDER
    SoXtColorPatch(
	Widget parent,
	const char *name, 
	SbBool buildInsideParent, 
	SbBool buildNow);
    
  private:
    
    // redefine to do ColorPatch specific things
    virtual void    redraw();
    virtual void    sizeChanged(const SbVec2s &newSize);
    
    // local variables
    SbColor	color;

    // this is called by both constructors
    void constructorCommon(SbBool buildNow);
};


#endif  // _SO_XT_COLOR_PATCH_
