// Author: David Lawrence  June 25, 2004
//
//
// hd_ana.cc
//

#include <TApplication.h>

#include "MyMainFrame.h"
#include "MyProcessor.h"
#include "DEventLoop.h"


DEventLoop *eventloop = NULL;
MyProcessor *myproc = NULL;
MyMainFrame *mmf = NULL;

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
	mmf = new MyMainFrame(gClient->GetRoot(), 800, 800);
	
	// Create a MyProcessor
	myproc = new MyProcessor();
	eventloop->AddProcessor(myproc);
	eventloop->Init();

	// Hand control to ROOT event loop
	app.Run();
	
	// Close out event loop
	eventloop->Fini();
	
	// clean up
	delete myproc;
	delete mmf;
	
	return 0;
}

