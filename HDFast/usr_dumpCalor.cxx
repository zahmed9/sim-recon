//*-- author :    Paul Eugenio  5-April-1999
////////////////////////////////////////////////////////////////////////
//
//             usr_dumpCalor.cxx
//             =================================
//
//  This routine :
//    - dumps the mcfast (ver 4_2) calorimetry hits 
//  Example usage ( Called from a C routine ):
//    if(debug) usr_dumpCalor();
//  
////////////////////////////////////////////////////////////////////////
 

#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <CalorInfo.hh>
#include <CalorInfoTrack.hh>
#include <CalorSignalMC.hh>
using namespace std;

#define TRUE 1
#define FALSE 0

extern "C" void usr_dumpCalor(void)
{

  static int FirstCall=TRUE;
  static CalorInfo *info = NULL;
  if(FirstCall){
    info = CalorInfo::getCalorInfo();
    cerr<<"Number of Calorimeters: "
	<< info->numberOfCalorimeters()<<endl;
    
  }
  CalorSignalMC ***grid=NULL;
  vector<CalorCellAddress> HitList;
  vector<CalorInfoTrack> InfoTrack;
  vector<const DenseMedium *>::const_iterator iter,
    iterEnd = info->listOfCalorimeters().end();
 
  
  for(iter=info->listOfCalorimeters().begin();iter!=iterEnd;iter++)
    {
      if(FirstCall)
	cerr<<"Calorimeter segmentation type is "
	    <<info->segmentationType(*iter) <<endl;
      int nhits =0;
      HitList = info->listOfHits(*iter);
      if((nhits = HitList.size()))
	grid = info->pGridOfCells(*iter);
      cerr<<"Found "<<nhits<<" hits\n";
      for(int ihit =0;ihit<nhits;ihit++){
	int X1CellIndex =  HitList[ihit].address[0];
	int X2CellIndex =  HitList[ihit].address[1];
	double E= grid[X1CellIndex][X2CellIndex]->getE();


	cerr<<"Cell index (X1,X2): ( "<<X1CellIndex<<", "
	    <<X2CellIndex<<") E: "
	    <<E<<endl;
	InfoTrack = grid[X1CellIndex][X2CellIndex]->getInfoTracks();
	int ntracks = 0;
	ntracks = InfoTrack.size();
	cerr<<"\tFound "<<ntracks<<" track(s) contributing to the hit\n";
	for(int itrk =0;itrk<ntracks;itrk++){
	 int  TrackHepIndex = InfoTrack[itrk].trackID;
	 double EMIP = InfoTrack[itrk].EMIP;
	 double EEM = InfoTrack[itrk].EEM;
	 double EHAD = InfoTrack[itrk].EHAD;

	 cerr<<"\t\tTrackHepIndex: "<<TrackHepIndex<<endl;
	 cerr<<"\t\t\tEnergy MIP: "<<EMIP<<endl;
	 cerr<<"\t\t\tEnergy EM: "<<EEM<<endl;
	 cerr<<"\t\t\tEnergy HAD: "<<EHAD<<endl;

	}
      }
    }
  FirstCall=FALSE;

}

