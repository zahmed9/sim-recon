// Author: David Lawrence  June 25, 2004
//
//
// hd_ana.cc
//

#include "MyProcessor.h"
#include "DEventLoop.h"
#include "DFactory_DMCTrackHists.h"

//-----------
// main
//-----------
int main(int narg, char *argv[])
{
	// Instantiate our event processor
	MyProcessor myproc;

	// Instantiate an event loop object
	DEventLoop eventloop(narg, argv);

	// Add DMCTrackHists factory as processor so it automatically
	// gets called every event.
	eventloop.AddFactory(new DFactory_DMCTrackHists());

	// Run though all events, calling our event processor's methods
	eventloop.Run(&myproc);
	
	return 0;
}

