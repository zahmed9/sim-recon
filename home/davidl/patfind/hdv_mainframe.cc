
#include <iostream>
#include <iomanip>
using namespace std;

#include <pthread.h>

#include "derror.h"
#include "hdv_mainframe.h"
#include "MyProcessor.h"

#include <TPolyMarker3D.h>
#include <TLine.h>
#include <TMarker.h>
#include <TVector3.h>
#include <TGeoVolume.h>
#include <TGeoManager.h>

extern TCanvas *maincanvas;

TGeoVolume *MOTHER = NULL;
TGeoCombiTrans *MotherRotTrans = NULL;

extern derror_t hdv_getevent(void);

extern MyProcessor *myproc;


//-------------------
// Constructor
//-------------------
hdv_mainframe::hdv_mainframe(const TGWindow *p, UInt_t w, UInt_t h):TGMainFrame(p,w,h)
{
	fLayout = new TGLayoutHints(kLHintsCenterX | kLHintsCenterY);

	emcanvas = new TRootEmbeddedCanvas("Main Canvas",this,w, w, kSunkenFrame, GetWhitePixel());
	emcanvas->SetScrolling(TGCanvas::kCanvasNoScroll);
	AddFrame(emcanvas, fLayout);
	
	TGHorizontalFrame *buttonframe = new TGHorizontalFrame(this, w, 50);
	AddFrame(buttonframe, fLayout);

	next		= new TGTextButton(this,"&Next",			2);
	density	= new TGTextButton(this,"&Density",		3);
	lines		= new TGTextButton(this,"&Lines",		4);
	phi_vs_z	= new TGTextButton(this,"&Phi vs. Z",	7);
	slope		= new TGTextButton(this,"&Slope", 		5);
	offset	= new TGTextButton(this,"&Offset",		6);
	gifs		= new TGTextButton(this,"&GIFs",			8);
	hits		= new TGTextButton(this,"&Hits",			9);
	quit		= new TGTextButton(this,"&Quit",			1);
	quit->SetCommand(".q");
	
	buttonframe->AddFrame(next, fLayout);
	buttonframe->AddFrame(density, fLayout);
	buttonframe->AddFrame(lines, fLayout);
	buttonframe->AddFrame(phi_vs_z, fLayout);
	buttonframe->AddFrame(slope, fLayout);
	buttonframe->AddFrame(offset, fLayout);
	buttonframe->AddFrame(hits, fLayout);
	buttonframe->AddFrame(gifs, fLayout);
	buttonframe->AddFrame(quit, fLayout);
	
	MapSubwindows();
	Layout();
	SetWindowName("Hall-D Track Pattern Finder");
	SetIconName("PatFind");
	MapWindow();

	maincanvas = emcanvas->GetCanvas();
	maincanvas->cd(0);
	maincanvas->Range(-300.0,-300.0,300.0, 300.0);	
}

//-------------------
// ProcessMessage
//-------------------
Bool_t hdv_mainframe::ProcessMessage(Long_t msg, Long_t parm1, Long_t parm2)
{
	derror_t err;

	switch(msg>>8){
		case kC_COMMAND:
			switch(msg&0xff){
				case kCM_BUTTON:
					switch(parm1){
						case 2: //Next
							err = hdv_getevent();
							break;
						case 3: //Density
							myproc->densityPlot();
							break;
						case 4: //Lines
							myproc->evnt(0);
							break;
						case 5: //Slope
							myproc->PlotSlope();
							break;
						case 6: //Offset
							myproc->PlotOffset();
							break;
						case 7: //Phi vs. Z
							myproc->PlotPhiVsZ();
							break;
						case 8: //GIFs
							MakeGIFs();
							break;
						case 9: //Hits
							myproc->DrawHits();
							break;
						default:
							cout<<"parm1="<<parm1<<endl;
					}
					break;
			}
			break;
	}
}

//-------------------
// MakeGIFs
//-------------------
void hdv_mainframe::MakeGIFs(void)
{
	static int event=1;
	
	char fname[256];
	
	sprintf(fname,"patfind_lines_%02d.gif",event);
	myproc->evnt(0);
	maincanvas->SaveAs(fname);

	sprintf(fname,"patfind_density_%02d.gif",event);
	myproc->densityPlot();
	maincanvas->SaveAs(fname);

	sprintf(fname,"patfind_slope_%02d.gif",event);
	myproc->PlotSlope();
	maincanvas->SaveAs(fname);

	sprintf(fname,"patfind_offset_%02d.gif",event);
	myproc->PlotOffset();
	maincanvas->SaveAs(fname);

	sprintf(fname,"patfind_phi_vs_z_%02d.gif",event);
	myproc->PlotPhiVsZ();
	maincanvas->SaveAs(fname);

	sprintf(fname,"patfind_hits_%02d.gif",event);
	myproc->DrawHits();
	maincanvas->SaveAs(fname);

	event++;
}


