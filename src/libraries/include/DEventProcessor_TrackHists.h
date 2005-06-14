// $Id$
//
//    File: DEventProcessor_TrackHists.h
// Created: Sun Apr 24 06:45:21 EDT 2005
// Creator: davidl (on Darwin Harriet.local 7.8.0 powerpc)
//

#ifndef _DEventProcessor_TrackHists_
#define _DEventProcessor_TrackHists_

#include <TH1.h>
#include <TH2.h>

#include "DFactory.h"
#include "DEventProcessor.h"
#include "DEventLoop.h"

class DEventProcessor_TrackHists:public DEventProcessor{

	public:
		DEventProcessor_TrackHists();
		~DEventProcessor_TrackHists();
		void FillAll(float what, float theta, float phi, float p, float weight=1.0);
		void EffVsX(TH1F *out, TH2F* in);

		enum{
			NHITS_THROWN =1,
			NHITS_FOUND,
			NHITS_THROWN_AND_FOUND,
			NHITS_FOUND_DIFFERENT,
			NHITS_THROWN_UNUSED,
			NTHROWN,
			NFOUND,
			NFITTABLE,
			NMATCHED,

			R_FOUND_TO_FITTABLE,
			R_THROWN_AND_FOUND_TO_THROWN,
			R_THROWN_AND_FOUND_TO_FOUND,
			R_MATCHED_TO_FITTABLE,
			
			NBINS
		};
		
		TH1F *stats;
		TH2F *stats_vs_theta, *stats_vs_phi, *stats_vs_p;
		TH2F *dp_over_p_vs_p, *dp_over_p_vs_theta;
		TH1F *eff_vs_theta, *eff_vs_phi, *eff_vs_p;

	private:
		derror_t init(void);	///< Invoked via DEventProcessor virtual method
		derror_t evnt(DEventLoop *loop, int eventnumber);	///< Invoked via DEventProcessor virtual method
		derror_t erun(void);					///< Invoked via DEventProcessor virtual method

};

#endif // _DEventProcessor_TrackHists_

