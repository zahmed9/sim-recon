// Author: David Lawrence  June 25, 2004
//
//
// MyProcessor.cc
//

#include <iostream>
using namespace std;

#include <TLorentzVector.h>

#include "hdview.h"
#include "MyProcessor.h"
#include "hddm.h"

extern TCanvas *maincanvas;
extern DEventLoop *eventloop;


//------------------------------------------------------------------
// evnt 
//------------------------------------------------------------------
derror_t MyProcessor::evnt(int eventnumber)
{

	// Delete objects from previous event
	for(int i=0;i<Nellipse;i++)delete ellipse[i];
	for(int i=0;i<Nhelix;i++)delete helix[i];
	for(int i=0;i<Ncdctracks;i++)delete cdchits3D[i];
	Nellipse = Nhelix = Ncdctracks = 0;
	
	// Create 3D polymarkers from CDChits
	CDChit_t *CDChit = hddm->CDChits->CDChit;
	CDCtrack_t *CDCtrack = hddm->CDCtracks->CDCtrack;
	int last_track = -1;
	for(Ncdchits=0; Ncdchits<hddm->CDChits->nrows; Ncdchits++, CDChit++){
		
		TVector3 *v = &CDChit->pos;
		if(CDChit->track != last_track){
		
			// create new polymarker for track
			last_track = CDChit->track;
			cdchits3D[Ncdctracks] = new TPolyMarker3D();
			
			// create new helix for track
			if(Nhelix<10){
				TLorentzVector *p = &CDCtrack[Ncdctracks].p;
				float B=-2.0*0.593/197.326; // empirical
				helix[Nhelix] = new THelix(0, 0, -190.0, p->X(), p->Y(), p->Z(), CDCtrack[Ncdctracks].q*B);
				helix[Nhelix]->SetRange(-190,200);
				helix[Nhelix]->SetLineColor(Ncdctracks+2);
				helix[Nhelix++]->Draw();
			}
			Ncdctracks++;
		}
		
		// Add hit to polymarker
		cdchits3D[Ncdctracks-1]->SetNextPoint(v->x(), v->y(), v->z()-250.0);
		cout<<__FILE__<<":"<<__LINE__<<" x="<<v->x()<<" y="<<v->y()<<" z="<<v->z()<<endl;
	}
	for(int i=0;i<Ncdctracks;i++){
		cout<<__FILE__<<":"<<__LINE__<<" nhits="<<cdchits3D[i]->GetLastPoint()<<endl;
		cdchits3D[i]->SetMarkerColor(i+2);
		cdchits3D[i]->SetMarkerSize(0.4);
		cdchits3D[i]->SetMarkerStyle(20);
		cdchits3D[i]->Draw();
	}
	
	cout<<"Next Event"<<endl;
	cout<<"\t Ncdctracks="<<hddm->CDCtracks->nrows<<endl;

	return NOERROR;
}

