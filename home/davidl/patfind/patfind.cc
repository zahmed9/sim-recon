// Author: David Lawrence  June 25, 2004
//
//
// hd_ana.cc
//

#include <TApplication.h>

#include "MyProcessor.h"
#include "DEventLoop.h"

#include "hdv_mainframe.h"

TCanvas *maincanvas=NULL;
DEventLoop *eventloop=NULL;
MyProcessor *myproc = NULL;
hdv_mainframe *hdvmf=NULL;

//-----------
// main
//-----------
int main(int narg, char *argv[])
{
	// Instantiate an event loop object this has to be done BEFORE
	// creating the TApplication object since that modifes the argument list.
	eventloop = new DEventLoop(narg, argv);

	// Open Window
	TApplication app("HDView", &narg, argv);
	hdvmf = new hdv_mainframe(gClient->GetRoot(), 600, 600);
	
	// This is done AFTER creating the TApplication object so when the
	// init routine is called, the window will be mapped and it can
	// draw the detectors.
	myproc = new MyProcessor();
	eventloop->AddProcessor(myproc);
	eventloop->Init();

	// Hand control to ROOT event loop
	app.Run();
	
	// Close out event loop
	eventloop->Fini();
	
	// clean up
	delete myproc;
	delete hdvmf;
	
	return 0;
}

//-------------------
// hdv_getevent
//-------------------
derror_t hdv_getevent(void)
{
	// Read in next event. 
	derror_t err;
	err = eventloop->OneEvent();
	
	if(err!=NOERROR)return err;
		

	return NOERROR;
}
