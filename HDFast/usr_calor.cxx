//*-- author :    Paul Eugenio  5-April-1999

////////////////////////////////////////////////////////////////////////
//
//             usr_calor.cxx
//             =================================
//
//  This routine :
//    - dumps the mcfast (ver 4_2) calorimetry hits 
//  Example usage ( Called from a C routine ):
//    if(debug) usr_dumpCalor();
//  
////////////////////////////////////////////////////////////////////////
 

#include <iostream.h>
#include <fstream.h>
#include <stdlib.h>
#include <CalorInfo.hh>
#include <CalorInfoTrack.hh>
#include <CalorSignal.hh>


struct cal_hit_tracks_t {
  int tr_num; 
  float percent_e_tot; 
};

struct cal_hit_t {
  int icr1; 
  int icr2; 
  float e_mip;
  float e_em;  
  float e_had; 
  int status; 
  int n_tracks;
  struct cal_hit_tracks_t *info_tr; 
};
  
struct cal_hits_t {
  int nCalHits;
  cal_hit_t **CalorHits;
};

extern "C" void usr_calor(struct cal_hits_t *Calor)
{
  /*
   struct cal_hits_t {
     int nCalHits;
     cal_hit_t **CalorHits;
   };  
   */

  static int FirstCall=TRUE;
  static CalorInfo *info = NULL;
  if(FirstCall){
    info = CalorInfo::getCalorInfo();
    cerr<<"Number of Calorimeters: "
	<< info->numberOfCalorimeters()<<endl;
    
  }
  CalorSignal **grid=NULL;
  vector<CalorCellAddress> HitList;
  vector<CalorInfoTrack> InfoTrack;
  vector<const DenseMedium *>::const_iterator iter;
  //iterEnd = info->listOfCalorimeters().end();
 
  //for(iter=info->listOfCalorimeters().begin();iter!=iterEnd;iter++){
  iter=info->listOfCalorimeters().begin();
      if(FirstCall)
	cerr<<"Calorimeter segmentation type is "
	    <<info->segmentationType(*iter) <<endl;
      Calor->nCalHits=0;
      HitList = info->listOfHits(*iter);
      if((Calor->nCalHits= HitList.size()))
	grid = info->gridOfCells(*iter);
      // now alloc memory for an array of hit pointers
      Calor->CalorHits = (struct cal_hit_t **)malloc(
			    (Calor->nCalHits)*sizeof(struct cal_hit_t *));
      // now malloc for each cal_hit_t struct
      for(int ihit=0;ihit<Calor->nCalHits;ihit++){
	Calor->CalorHits[ihit] = (struct cal_hit_t *)malloc(
			      sizeof(struct cal_hit_t));
	int X1CellIndex =  HitList[ihit].address[0];
	int X2CellIndex =  HitList[ihit].address[1];
	Calor->CalorHits[ihit]->icr1 = X1CellIndex;
	Calor->CalorHits[ihit]->icr2 = X2CellIndex;
	Calor->CalorHits[ihit]->e_mip = grid[X1CellIndex][X2CellIndex].eMIP();
	Calor->CalorHits[ihit]->e_em = grid[X1CellIndex][X2CellIndex].eEM();
	Calor->CalorHits[ihit]->e_had = grid[X1CellIndex][X2CellIndex].eHAD();
	Calor->CalorHits[ihit]->status = -1;// no longer used

	InfoTrack = grid[X1CellIndex][X2CellIndex].infoTracks();
	Calor->CalorHits[ihit]->n_tracks = InfoTrack.size();

	// now malloc for struct cal_hit_tracks_t *info_tr
	Calor->CalorHits[ihit]->info_tr = (struct cal_hit_tracks_t *)malloc(
					  (Calor->CalorHits[ihit]->n_tracks)*
					  sizeof(struct cal_hit_tracks_t));
	for(int itrk =0;itrk< Calor->CalorHits[ihit]->n_tracks ;itrk++){
	  Calor->CalorHits[ihit]->info_tr[itrk].tr_num =
	    InfoTrack[itrk].trackID;
	  Calor->CalorHits[ihit]->info_tr[itrk].percent_e_tot=
	    InfoTrack[itrk].percentOfTotalEnergy;
	  
	}
	
      }

      //}
  FirstCall=FALSE;

}

extern "C" int isaBCALgamma(int hepIndex){
  
  CalorInfo *info = CalorInfo::getCalorInfo();
  CalorSignal **grid=NULL;
  vector<CalorCellAddress> HitList;
  vector<CalorInfoTrack> InfoTrack;
  vector<const DenseMedium *>::const_iterator iter;    
  iter=info->listOfCalorimeters().begin();// there is only one calor
  HitList = info->listOfHits(*iter);

  int found =0;
  if(HitList.size()) {
    grid = info->gridOfCells(*iter);
    int nhits=HitList.size();
    for(int ihit=0;ihit<nhits;ihit++){
      int X1CellIndex =  HitList[ihit].address[0];
      int X2CellIndex =  HitList[ihit].address[1];
      InfoTrack = grid[X1CellIndex][X2CellIndex].infoTracks();
      int ntrks =  InfoTrack.size() ;
      for(int itrk =0;itrk< ntrks ;itrk++)
	if( hepIndex==InfoTrack[itrk].trackID )
	  found =1;
    }
  }
  return found;
}
