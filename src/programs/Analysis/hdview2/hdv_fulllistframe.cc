
#include <iostream>
#include <iomanip>
#include <sstream>
#include <cmath>
#include <fstream>
using namespace std;

#include <pthread.h>

#include <TRACKING/DMCThrown.h>
#include "hdv_fulllistframe.h"
#include "hdview2.h"
#include "MyProcessor.h"
#include "FDC/DFDCGeometry.h"
#include "FCAL/DFCALGeometry.h"
#include "DVector2.h"
#include "HDGEOMETRY/DGeometry.h"
#include "PID/DPhoton.h"

#include <TPolyMarker.h>
#include <TLine.h>
#include <TMarker.h>
#include <TBox.h>
#include <TVector3.h>
#include <TGeoVolume.h>
#include <TGeoManager.h>
#include <TGLabel.h>
#include <TGComboBox.h>
#include <TGButton.h>
#include <TGButtonGroup.h>
#include <TGTextEntry.h>
#include <TArrow.h>
#include <TLatex.h>
#include <TColor.h>
#include <TG3DLine.h>

extern JApplication *japp;
//TGeoVolume *MOTHER = NULL;
//TGeoCombiTrans *MotherRotTrans = NULL;

extern int GO;


//-------------------
// Constructor
//-------------------
hdv_fulllistframe::hdv_fulllistframe(hdv_mainframe *hdvmf, const TGWindow *p, UInt_t w, UInt_t h):TGMainFrame(p,w,h)
{
	this->hdvmf = hdvmf;

	// First, define all of the of the graphics objects. Below that, make all
	// of the connections to the methods so these things will work!

	// The main GUI window is divided into three sections, top, middle, and bottom.
	// Create those frames here.
	TGLayoutHints *hints = new TGLayoutHints(kLHintsNormal|kLHintsExpandX|kLHintsExpandY, 5,5,5,5);
	TGLayoutHints *lhints = new TGLayoutHints(kLHintsNormal, 2,2,2,2);
	TGLayoutHints *rhints = new TGLayoutHints(kLHintsCenterY|kLHintsRight, 2,2,2,2);
	TGLayoutHints *chints = new TGLayoutHints(kLHintsCenterY|kLHintsCenterX, 2,2,2,2);
	TGLayoutHints *bhints = new TGLayoutHints(kLHintsBottom|kLHintsCenterX, 2,2,2,2);
	TGLayoutHints *xhints = new TGLayoutHints(kLHintsNormal|kLHintsExpandX, 2,2,2,2);
	TGLayoutHints *yhints = new TGLayoutHints(kLHintsNormal|kLHintsExpandY, 2,2,2,2);
	TGLayoutHints *dhints = new TGLayoutHints(kLHintsLeft|kLHintsCenterY, 0,0,0,0);
	TGLayoutHints *ehints = new TGLayoutHints(kLHintsNormal, 2,2,0,0);
	TGLayoutHints *thints = new TGLayoutHints(kLHintsTop|kLHintsCenterX, 2,2,0,0);
	TGLayoutHints *lxhints = new TGLayoutHints(kLHintsLeft|kLHintsExpandX, 2,2,0,0);
	TGHorizontalFrame *topframe = new TGHorizontalFrame(this, w, h);
	TGHorizontalFrame *botframe = new TGHorizontalFrame(this, w, h);
	AddFrame(topframe, lhints);
	AddFrame(botframe, chints);

	TGGroupFrame *partinfoframe = new TGGroupFrame(topframe, "Particles", kVerticalFrame);
	TGGroupFrame *displayoptsframe = new TGGroupFrame(topframe, "Display Options", kVerticalFrame);
	topframe->AddFrame(partinfoframe, lhints);
	topframe->AddFrame(displayoptsframe, lhints);


	//========== Close Button ===========
	TGTextButton *close = new TGTextButton(botframe,	"Close");
	botframe->AddFrame(close, chints);

	//&&&&&&&&&&&&&&&& Connections
	close->Connect("Clicked()","hdv_fulllistframe", this, "DoClose()");

	// Finish up and map the window
	SetWindowName("Hall-D Event Viewer Full Particle Listing");
	SetIconName("HDView");


	MapSubwindows();
	Resize(GetDefaultSize());
}

//-------------------
// DoClose
//-------------------
void hdv_fulllistframe::DoClose(void)
{
	UnmapWindow();
}


