// StdHepXDR.cc
//
// Purpose: initialize and read or write an XDR input stream
//

#include <iostream.h>
#include <rpc/types.h>
#include <rpc/xdr.h>
#include <vector>

#include "StdStreams.hh"
#include "StdRun.hh"
#include "StdHepDictionary.hh"
#include "mcfio_Dict.h"
#include "mcfio.hh"

extern "C" {
 int xdr_stdhep_();
 int xdr_stdhep_multi_();
 int xdr_stdhep_cm1_();
}

// counters should be encapsulated with I/O piece
struct StdCount {
    int nWritten;        // number of events written 
    int nRead;         // number of events read 
};
StdCount stdCntr;

StdHep::Streams iostrm( -1 );	// list of XDR streams for internal use

int StdHep::Run::StdHepInitReadXDR( char*filename, int& ntries, int& istr )
{
   int ierr;

   PrintStdVersion;

   mcfioC_Init();
   ierr = StdHep::Run::StdHepOpenReadXDR( filename, ntries, istr );
   return ierr;
   
}

int StdHep::Run::StdHepOpenReadXDR( char*filename, int& ntries, int& istr )
{
   int ixdrstream;

   PrintStdVersion;

   ixdrstream = mcfioC_OpenReadDirect(filename);

   StdHep::StreamElement elem( ixdrstream, filename );
   iostrm.appendStream( elem );
   istr = iostrm.NumberOfStreams() + 1;
   iostrm.setNumberOfStreams( istr );
   cout << "opened " << filename << endl;
   if (ixdrstream == -1) {
        cerr << " StdHepReadXDROpen: cannot open input file " << 
	            filename <<  endl;
        return -1;
   }
    
   char date[80], title[255], comment[255];
   int dlen, tlen, clen;
   int numblocks, blkids[50];
   mcfioC_InfoStreamChar(ixdrstream, MCFIO_CREATIONDATE, date, &dlen);
   mcfioC_InfoStreamChar(ixdrstream, MCFIO_TITLE, title, &tlen);
   mcfioC_InfoStreamChar(ixdrstream, MCFIO_COMMENT, comment, &clen);
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_NUMEVTS, &ntries);
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_NUMBLOCKS, &numblocks);
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_BLOCKIDS, blkids);
   stdCntr.nRead = stdCntr.nWritten = 0;
   cout << " StdHepReadXDROpen: successfully opened input stream " << 
               ixdrstream << endl;
   cout << "          title: " << title << endl;
   cout << "          date: " << date << endl;
   cout << "          events: " << ntries << endl;
   cout << "          blocks per event: " << numblocks << endl;

    return 0;
   
}

int StdHep::Run::StdHepReadXDR( int& ilbl, int istr, StdHep::Event* & evt )
{
   int ixdrstream;
   int i, istat, numblocks, blkids[50];
   static int first=1;
   if( first == 1 ) {
      first=0;
      PrintStdVersion();
   }
   StdHep::StreamElement elem = iostrm.IOSreams(istr);
   ixdrstream = elem.XDRStream();
   // cout << "get next event in stream " << ixdrstream << endl;
   if(mcfioC_NextEvent(ixdrstream) != MCFIO_RUNNING) {
       mcfioC_InfoStreamInt(ixdrstream, MCFIO_STATUS, &istat);
       if(istat == MCFIO_EOF) {
	   cerr << "     StdHepReadXDR: end of file found\n";
           return 1;
       } else {
           cerr << "     StdHepReadXDR: unrecognized status - stop\n";
           return 2;
       }
   }
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_NUMBLOCKS, &numblocks);
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_BLOCKIDS, blkids);
   for (i = 0; i < numblocks; i++) {
       // cout << "process block of type " << blkids[i] << endl;
       if (blkids[i] == MCFIO_STDHEP) {
           StdHepZero(evt);
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEP,xdr_stdhep_) != -1) {
               ilbl = 1;
               if (StdHepTempCopy(2,ixdrstream,evt) == 0) {
		   stdCntr.nRead++;
                   return 0;
	       }
           }
       } else if (blkids[i] == MCFIO_STDHEPM) {
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEPM,xdr_stdhep_multi_) != -1) {
               ilbl = 2;
               if (StdHepFtoCXX(ixdrstream,evt) == 0) {
		   stdCntr.nRead++;
                   return 0;
	       }
           }
       } else if (blkids[i] == MCFIO_STDHEPBEG) {
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEPBEG,xdr_stdhep_cm1_) != -1) {
               ilbl = 100;
	       evt = 0;
               StdHepFtoCM(*this);
	       return 0;
           }
       } else if (blkids[i] == MCFIO_STDHEPEND) {
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEPEND,xdr_stdhep_cm1_) != -1) {
               ilbl = 200;
	       evt = 0;
               StdHepFtoCM(*this);
	       return 0;
           }
       }
   }
   return 1;
   
}

int StdHep::Run::StdHepReadMultiXDR( int& ilbl, int istr, StdHep::Event* & evt )
{
   int ixdrstream;
   int i, istat, numblocks, blkids[50];
   static int first=1;
   if( first == 1 ) {
      first=0;
      PrintStdVersion();
   }
   StdHep::StreamElement elem = iostrm.IOSreams(istr);
   ixdrstream = elem.XDRStream();
   // cout << "get next event in stream " << ixdrstream << endl;
   if(mcfioC_NextEvent(ixdrstream) != MCFIO_RUNNING) {
       mcfioC_InfoStreamInt(ixdrstream, MCFIO_STATUS, &istat);
       if(istat == MCFIO_EOF) {
	   cerr << "     StdHepReadXDR: end of file found\n";
           return 1;
       } else {
           cerr << "     StdHepReadXDR: unrecognized status - stop\n";
           return 2;
       }
   }
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_NUMBLOCKS, &numblocks);
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_BLOCKIDS, blkids);
   for (i = 0; i < numblocks; i++) {
       if (blkids[i] == MCFIO_STDHEP) {
           // don't zero the event - the user does that
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEP,xdr_stdhep_) != -1) {
               ilbl = 1;
               if (StdHepTempCopy(2,ixdrstream,evt) == 0)
		   stdCntr.nRead++;
               return 0;
           }
       // Look for begin and end run records before checking for a multiple collision record
       // This avoids extraneous error messages
       } else if (blkids[i] == MCFIO_STDHEPBEG) {
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEPBEG,xdr_stdhep_cm1_) != -1) {
               ilbl = 100;
               StdHepFtoCM(*this);
               return 0;
           }
       } else if (blkids[i] == MCFIO_STDHEPEND) {
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEPEND,xdr_stdhep_cm1_) != -1) {
               ilbl = 200;
               StdHepFtoCM(*this);
               return 0;
           }
       } else if (blkids[i] == MCFIO_STDHEPM) {
           if (mcfioC_Block(ixdrstream,MCFIO_STDHEPM,xdr_stdhep_multi_) != -1) {
	       cout << "StdHepReadMultiXDR: This event from stream " <<
	             istr << " is already a multiple collision event" << endl;
	       cout << "StdHepReadMultiXDR: The event object will be re-initialized" << endl;
               ilbl = 2;
               if (StdHepFtoCXX(ixdrstream,evt) == 0)
		   stdCntr.nRead++;
               return 0;
           }
       }
   }
   return 1;
}

//
// output begins here
//

int StdHep::Run::StdHepInitWriteXDR(char *filename, char *title, int ntries, int& ist)
{
   int ixdrstream;
   int numblocks = 4;
   int blkids[50];
   char *comment = '\0';
   static int first=1;
   if( first == 1 ) {
      first=0;
      PrintStdVersion();
   }

   mcfioC_Init();

   blkids[0] = MCFIO_STDHEP;
   blkids[1] = MCFIO_STDHEPM;
   blkids[2] = MCFIO_STDHEPBEG;
   blkids[3] = MCFIO_STDHEPEND;

   stdCntr.nWritten = 0;
   ixdrstream =  mcfioC_OpenWriteDirect(filename, title, comment,
                   ntries, blkids, numblocks);
   StdHep::StreamElement elem( ixdrstream, filename );
   iostrm.appendStream( elem );
   ist = iostrm.NumberOfStreams() + 1;
   iostrm.setNumberOfStreams( ist );
   if (ixdrstream == -1) {
       cerr << " StdHepInitWriteXDR: cannot open output file " << filename << endl;
       return -1;
       }
   cout << " StdHepInitWriteXDR: I/O initialized for StdHep only" << endl;
   return 0;
}

int StdHep::Run::StdHepWriteXDR(int ilbl, int ist, StdHep::Event* evnt )
{
   int iret = 0;
   static int first=1;

   if ((ilbl == 1) || (ilbl == 2)) {
       iret = StdHep::Run::StdHepWriteEventXDR(ilbl, ist, evnt );
   } else if ((ilbl == 100) || (ilbl == 200)) {
       iret = StdHep::Run::StdHepWriteCMXDR(ilbl, ist);
   } else {
       cout << "StdHepWriteXDR: don't know what to do with record type " 
             << ilbl << endl;
   }
   return iret;
}

int StdHep::Run::StdHepWriteCMXDR(int ilbl, int ist )
{
   int ixdrstream;

   StdHep::StreamElement elem = iostrm.IOSreams(ist);
   ixdrstream = elem.XDRStream();
   if (ilbl == 100) {
       StdHepCMtoF( *this );
       if (mcfioC_Block(ixdrstream, MCFIO_STDHEPBEG, xdr_stdhep_cm1_) == -1) {
           cerr << "StdHepWriteCMXDR: error writing cm1 information" << endl;
           return 2;
       }
   } else if (ilbl == 200) {
       StdHepCMtoF( *this );
       if (mcfioC_Block(ixdrstream, MCFIO_STDHEPEND, xdr_stdhep_cm1_) == -1) {
           cerr << "StdHepWriteCMXDR: error writting cm1 information" << endl;
           return 2;
       }
   } else {
       cerr << "StdHepWriteCMXDR: called with improper label " << ilbl << endl;
       return 3;
   }
   if (mcfioC_NextEvent(ixdrstream) == -1) {
       cerr << "StdHepWriteCMXDR: error writting cm1 xdr block" << endl;
       return 1;
   }
   return 0;
}

int StdHep::Run::StdHepWriteEventXDR(int ilbl, int ist, StdHep::Event* evt)
{
   int ixdrstream, evn, inum, iok;

   StdHep::StreamElement elem = iostrm.IOSreams(ist);
   ixdrstream = elem.XDRStream();
   evn = evt->Entries();
   inum = evt->EventNumber();

   if ((ilbl != 1) && (ilbl != 2)) {
       cerr << "StdHepWriteEventXDR: called with illegal label " << ilbl << endl;
       return 3;
   } else if ( evn <= 0) {
       cerr << "StdHepWriteEventXDR: event " << inum << " is empty" << endl;
       return 0;
   } else if (ilbl == 1) {
       if (StdHepTempCopy(1,ixdrstream,evt) != 0) {
           cerr << "StdHepWriteEventXDR: copy failed - event not written" << endl;
           return 4;
       }
       if (mcfioC_Block(ixdrstream, MCFIO_STDHEP, xdr_stdhep_) == -1) {
           cerr << "StdHepWriteEventXDR: error filling stdhep block for event " << inum << endl;
           return 2;
       }
       stdCntr.nWritten++;
       mcfioC_SetEventInfo(ixdrstream, MCFIO_STORENUMBER, &inum);
   } else if (ilbl == 2) {
       iok = StdHepCXXtoF( ist, evt );
       if (mcfioC_Block(ixdrstream, MCFIO_STDHEPM, xdr_stdhep_multi_) == -1) {
           cerr << "StdHepWriteEventXDR: error filling stdhep block for event " << inum << endl;
           return 2;
       }
       stdCntr.nWritten++;
       mcfioC_SetEventInfo(ixdrstream, MCFIO_STORENUMBER, &inum);
   }
   if (mcfioC_NextEvent(ixdrstream) == -1) {
       cerr << "StdHepWriteEventXDR: error writing event " << inum  << endl;
       return 1;
   }
   return 0;
}

void StdHep::Run::StdHepWriteEndXDR(int ist)
{
   int ixdrstream;
   int inum, ieff;

   StdHep::StreamElement elem = iostrm.IOSreams(ist);
   ixdrstream = elem.XDRStream();

   mcfioC_InfoStreamInt(ixdrstream, MCFIO_NUMWORDS, &inum);
   mcfioC_InfoStreamInt(ixdrstream, MCFIO_EFFICIENCY, &ieff);
   mcfioC_Close(ixdrstream);
   cout << "StdHepEndXDR: " << inum << " words i/o with " << ieff << " efficiency" << endl;
}
