
#include <iostream>
#include <iomanip>
using namespace std;

#include <TTimer.h>
#include <TGButton.h>
#include <TGTextEntry.h>
#include <TRootEmbeddedCanvas.h>

#include "MyProcessor.h"
#include "MyMainFrame.h"
#include "DEventLoop.h"

extern MyProcessor *myproc;
extern DEventLoop *eventloop;
extern int DONE;

//-------------------
// Constructor
//-------------------
MyMainFrame::MyMainFrame(const TGWindow *p, UInt_t w, UInt_t h):TGMainFrame(p,w,h)
{
	TGLayoutHints *defHints = new TGLayoutHints(kLHintsCenterX | kLHintsCenterY | kLHintsExpandX | kLHintsExpandY ,2,2,2,2);
	TGLayoutHints *defHintsX = new TGLayoutHints(kLHintsExpandX ,2,2,2,2);
	TGLayoutHints *defHintsLeft = new TGLayoutHints(kLHintsLeft ,2,2,2,2);
	TGLayoutHints *defHintsRight = new TGLayoutHints(kLHintsRight ,2,2,2,2);
	TGLayoutHints *noHints = new TGLayoutHints(kLHintsNoHints ,2,2,2,2);

	//------------------ Top Frame ------------------
	TGHorizontalFrame *topframe = new TGHorizontalFrame(this, w, 50);
	AddFrame(topframe,new TGLayoutHints(kLHintsCenterX | kLHintsCenterY | kLHintsExpandX ,5,5,5,5));
		
			TGTextButton	*save			= new TGTextButton(	topframe, "  &Save  ");
			TGTextButton	*saveall		= new TGTextButton(	topframe, "Save &All");
			TGLabel			*displaylab	= new TGLabel(			topframe, "Display:");
								 display		= new TGComboBox(		topframe, "Lines",dtLines);
			TGTextButton	*quit			= new TGTextButton(	topframe, "&Quit");

			topframe->AddFrame(save,			new TGLayoutHints(kLHintsLeft, 2,2,2,2));
			topframe->AddFrame(saveall,		new TGLayoutHints(kLHintsLeft, 2,2,2,2));
			topframe->AddFrame(displaylab,	new TGLayoutHints(kLHintsNoHints, 50,2,2,2));			
			topframe->AddFrame(display,		new TGLayoutHints(kLHintsNoHints, 2,2,2,2));			
			topframe->AddFrame(quit,			new TGLayoutHints(kLHintsRight, 2,2,2,2));
			
			display->Select(dtLines);
			display->Resize(150,20);
			
			display->AddEntry("Lines", dtLines);
			display->AddEntry("Hough Density", dtHoughDensity);
			display->AddEntry("Slope Density", dtSlopeDensity);
			display->AddEntry("z-intercept Density", dtInterceptDensity);
			display->AddEntry("Phi vs. z", dtPhiVsZ);
			display->AddEntry("Detector Hits", dtHits);
	
	//------------------ Middle Frame ------------------
	int canvas_size = 400;
	TGHorizontalFrame *middleframe = new TGHorizontalFrame(this, w, canvas_size);
	AddFrame(middleframe, defHintsX);
	
		// Statistics frame
		TGGroupFrame *statsframe = new TGGroupFrame(middleframe,"Stats", kHorizontalFrame);
		middleframe->AddFrame(statsframe, noHints);
			TGVerticalFrame *statleft = new TGVerticalFrame(statsframe, 100, canvas_size);
			TGVerticalFrame *statright = new TGVerticalFrame(statsframe, 100, canvas_size);
			statsframe->AddFrame(statleft, noHints);
			statsframe->AddFrame(statright, noHints);
			
			TGLabel *filelab = new TGLabel(statleft, "File:");
						filename = new TGLabel(statright, "----- <none> -----");
			TGLabel *eventlab = new TGLabel(statleft, "Event:");
			         eventno = new TGLabel(statright, "--------");
	
			statleft->AddFrame(filelab, defHintsRight);
			statright->AddFrame(filename, defHintsLeft);
			statleft->AddFrame(eventlab, defHintsRight);
			statright->AddFrame(eventno, defHintsLeft);

		// Main Canvas
		TRootEmbeddedCanvas *emcanvas = new TRootEmbeddedCanvas("Main Canvas",middleframe,canvas_size, canvas_size, kSunkenFrame, GetWhitePixel());
		emcanvas->SetScrolling(TGCanvas::kCanvasNoScroll);
		middleframe->AddFrame(emcanvas, noHints);
		maincanvas = emcanvas->GetCanvas();

		// Options frame
		TGGroupFrame *optionsframe = new TGGroupFrame(middleframe, "Options", kVerticalFrame);
		middleframe->AddFrame(optionsframe, defHints);

	//------------------ Bottom Frame ------------------
	TGHorizontalFrame *bottomframe = new TGHorizontalFrame(this, w, 50);
	AddFrame(bottomframe, defHints);

		TGTextButton	*prev			= new TGTextButton(	bottomframe, "<<Prev");
		TGTextButton	*gotobut		= new TGTextButton(	bottomframe, "Go to event");
		TGTextEntry		*gotoen		= new TGTextEntry(	bottomframe, "");
		TGTextButton	*next			= new TGTextButton(	bottomframe, "Next>>");

		bottomframe->AddFrame(prev,			new TGLayoutHints(kLHintsLeft, 50,50,2,2));
		bottomframe->AddFrame(gotobut,		new TGLayoutHints(kLHintsLeft, 50,2,2,2));
		bottomframe->AddFrame(gotoen,			new TGLayoutHints(kLHintsLeft,  2,50,2,2));
		bottomframe->AddFrame(next,			new TGLayoutHints(kLHintsRight, 50,50,2,2));
		
		gotoen->SetEnabled(kFALSE);

	// Connect signals and slots
	quit->Connect("Clicked","MyMainFrame", this, "DoQuit()");
	display->Connect("Selected(Int_t)", "MyMainFrame", this, "DoSetDisplay(Int_t)");
	prev->Connect("Clicked()", "MyMainFrame", this, "DoPrev()");
	next->Connect("Clicked()", "MyMainFrame", this, "DoNext()");

	// Set up timer to call the DoTimer() method repeatedly
	// so events can be automatically advanced.
	TTimer *timer = new TTimer();
	timer->Connect("Timeout()", "MyMainFrame", this, "DoTimer()");
	timer->Start(1000, kFALSE);

	SetWindowName("Hall-D Tracking Single Event Diagnostic Utility");
	SetIconName("HD TSEDU");
	MapSubwindows();
	Resize(GetDefaultSize());
	MapWindow();
	
	sourcename = NULL;
	if(GetDisplayType()<0)display->Select(dtLines);
}


//-------------------
// Update
//-------------------
void MyMainFrame::Update(void)
{

	// Update canvas
	maincanvas->Update();
	
	// Update event number
	char str[32];
	sprintf(str, "%d", eventloop->eventnumber());
	eventno->SetText(str);

	// Update filename (if needed)
	const char* sname = eventloop->GetSourceName();
	if(sname != sourcename){
		sourcename = sname;
		filename->SetText(sourcename);
	}
}

//-------------------
// DoQuit
//-------------------
void MyMainFrame::DoQuit(void)
{
	gApplication->Terminate(0);
}

//-------------------
// DoNext
//-------------------
void MyMainFrame::DoNext(void)
{
	eventloop->OneEvent();
}

//-------------------
// DoPrev
//-------------------
void MyMainFrame::DoPrev(void)
{
	eventloop->GotoEvent(eventloop->eventnumber()-1);
	DoNext();
}

//-------------------
// DoSetDisplay
//-------------------
void MyMainFrame::DoSetDisplay(Int_t id)
{
	if(eventloop->eventnumber()>0) 
		myproc->evnt(eventloop->eventnumber());
}

//-------------------
// DoTimer
//-------------------
void MyMainFrame::DoTimer(void)
{

}

