// Author: David Lawrence  June 25, 2004
//
//
// hd_ana.cc
//

#include "MyProcessor.h"
#include "DApplication.h"
#include "DEventProcessor_TrackHists.h"
#include "DEventProcessor_MCStats.h"

//-----------
// main
//-----------
int main(int narg, char *argv[])
{
	// Instantiate our event processor
	MyProcessor myproc;
	
	// Instantiate a TrackHists event processor
	DEventProcessor_TrackHists trkHists;

	// Instantiate a MCStats event processor
	DEventProcessor_MCStats mcstats;

	// Instantiate an event loop object
	DApplication app(narg, argv);

	// Run though all events, calling our event processor's methods
	app.AddProcessor(&myproc);
	app.AddProcessor(&trkHists);
	app.AddProcessor(&mcstats);
	app.Run(NULL,3);
	
	return 0;
}

