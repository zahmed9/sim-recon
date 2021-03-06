// $Id$
//
//    File: DReaction_factory_trackeff_missing.cc
// Created: Wed Feb 25 08:58:19 EST 2015
// Creator: pmatt (on Linux pmattdesktop.jlab.org 2.6.32-504.8.1.el6.x86_64 x86_64)
//

#include "DReaction_factory_trackeff_missing.h"
#include "DCustomAction_TrackingEfficiency.h"

//------------------
// init
//------------------
jerror_t DReaction_factory_trackeff_missing::init(void)
{
	// Make as many DReaction objects as desired
	DReactionStep* locReactionStep = NULL;
	DReaction* locReaction = new DReaction("TrackEff_MissingProton"); //needs to be a unique name for each DReaction object, CANNOT (!) be "Thrown"

	// DOCUMENTATION:
	// ANALYSIS library: https://halldweb1.jlab.org/wiki/index.php/GlueX_Analysis_Software
	// DReaction factory: https://halldweb1.jlab.org/wiki/index.php/Analysis_DReaction

	/**************************************************** TrackEff_MissingProton Reaction Steps ****************************************************/

	//Required: DReactionSteps to specify the channel and decay chain you want to study
		//Particles are of type Particle_t, an enum defined in sim-recon/src/libraries/include/particleType.h

	//Example: g, p -> pi+, pi-, (p)
	locReactionStep = new DReactionStep();
	locReactionStep->Set_InitialParticleID(Gamma);
	locReactionStep->Set_TargetParticleID(Proton);
	locReactionStep->Add_FinalParticleID(PiPlus);
	locReactionStep->Add_FinalParticleID(PiMinus);
	locReactionStep->Add_FinalParticleID(Proton, true); //true: proton missing
	locReaction->Add_ReactionStep(locReactionStep);
	dReactionStepPool.push_back(locReactionStep); //register so will be deleted later: prevent memory leak

	/**************************************************** TrackEff_MissingProton Control Settings ****************************************************/

	// Recommended: Type of kinematic fit to perform (default is d_NoFit)
		//fit types are of type DKinFitType, an enum defined in sim-recon/src/libraries/ANALYSIS/DKinFitResults.h
	locReaction->Set_KinFitType(d_P4AndVertexFit); //simultaneously constrain apply four-momentum conservation, invariant masses, and common-vertex constraints

	// Highly Recommended: When generating particle combinations, reject all photon candidates with a PID confidence level < 5.73303E-7 (+/- 5-sigma)
	// locReaction->Set_MinPhotonPIDFOM(5.73303E-7);

	// Highly Recommended: When generating particle combinations, reject all charged track candidates with a PID confidence level < 5.73303E-7 (+/- 5-sigma)
	// locReaction->Set_MinChargedPIDFOM(5.73303E-7);

	// Highly Recommended: When generating particle combinations, reject all beam photons that match to a different RF bunch (delta_t > 1.002 ns)
	locReaction->Set_MaxPhotonRFDeltaT(2.004); //beam bunches are every 4.008 ns, (2.004 should be minimum cut value)

	// Optional, use with caution: When generating particle combinations, but after the Photon/RF Delta-t cut, reject all combos with more than this # of beam photons
		//useful for missing-particle studies when you need a very pure sample of events
		//however, this can cut away a lot of signal events too
	locReaction->Set_MaxNumBeamPhotonsInBunch(1);

	// Highly Recommended: Cut on number of extra "good" tracks. "Good" tracks are ones that survive the "PreSelect" (or user custom) factory.
		// Current (09/26/2014): "Good" tracks have a detector-hit match, and tracking FOM > 0.0027 (+/- 3 sigma). 
		// Important: Keep cut large: Can have many ghost and accidental tracks that look "good"
	locReaction->Set_MaxExtraGoodTracks(1);

	/************************************************** TrackEff_MissingProton Pre-Combo Custom Cuts *************************************************/

	// Highly Recommended: Very loose DAnalysisAction cuts, applied just after creating the combination (before saving it)
	// Example: Missing mass squared of proton
	locReaction->Add_ComboPreSelectionAction(new DCutAction_MissingMassSquared(locReaction, false, -0.1, 2.56));

	/**************************************************** TrackEff_MissingProton Analysis Actions ****************************************************/

	// Recommended: Analysis actions automatically performed by the DAnalysisResults factories to histogram useful quantities.
		//These actions are executed sequentially, and are executed on each surviving (non-cut) particle combination 
		//Pre-defined actions can be found in ANALYSIS/DHistogramActions.h and ANALYSIS/DCutActions.h

	// PID & Kinematics
	locReaction->Add_AnalysisAction(new DHistogramAction_PID(locReaction));

//INSERT TIGHT TIMING PID CUT HERE WHEN READY!!!! // Want as clean of an event sample as possible.
	locReaction->Add_AnalysisAction(new DCutAction_CutProtonPiPlusdEdx(locReaction, 2.0, true));

	// Tight cut on track quality
	locReaction->Add_AnalysisAction(new DCutAction_TrackHitPattern(locReaction, 2, 4)); //args: locMinHitRingsPerCDCSuperlayer, locMinHitPlanesPerFDCPackage

	// Missing Mass Squared
	locReaction->Add_AnalysisAction(new DHistogramAction_MissingMassSquared(locReaction, false, 1064, -0.1, 2.56));

	// Kinematic Fit Results
	locReaction->Add_AnalysisAction(new DHistogramAction_KinFitResults(locReaction, 0.05)); //5% confidence level cut on pull histograms only
//	locReaction->Add_AnalysisAction(new DCutAction_KinFitFOM(locReaction, 0.05)); //5% confidence level cut //require kinematic fit converges

	// Missing Mass Squared
	locReaction->Add_AnalysisAction(new DHistogramAction_MissingMassSquared(locReaction, false, 1064, -0.1, 2.56, "Post-KinFit"));

locReaction->Add_AnalysisAction(new DCutAction_BeamEnergy(locReaction, true, 2.0, 3.0)); //true: fill histograms with kinematic-fit particle data

	// Kinematics
	locReaction->Add_AnalysisAction(new DHistogramAction_ParticleComboKinematics(locReaction, true)); //true: fill histograms with kinematic-fit particle data
	locReaction->Add_AnalysisAction(new DHistogramAction_TrackVertexComparison(locReaction));

	// Tracking Efficiency
	locReaction->Add_AnalysisAction(new DCustomAction_TrackingEfficiency(locReaction, true, 1)); //1: 1 vertex-z bin

	_data.push_back(locReaction); //Register the DReaction with the factory


	/**************************************************** TrackEff_MissingPiMinus Reaction Steps ****************************************************/

	locReaction = new DReaction("TrackEff_MissingPiMinus"); //needs to be a unique name for each DReaction object, CANNOT (!) be "Thrown"

	//Required: DReactionSteps to specify the channel and decay chain you want to study
		//Particles are of type Particle_t, an enum defined in sim-recon/src/libraries/include/particleType.h

	//Example: g, p -> pi+, p, (pi-)
	locReactionStep = new DReactionStep();
	locReactionStep->Set_InitialParticleID(Gamma);
	locReactionStep->Set_TargetParticleID(Proton);
	locReactionStep->Add_FinalParticleID(PiPlus);
	locReactionStep->Add_FinalParticleID(Proton);
	locReactionStep->Add_FinalParticleID(PiMinus, true); //true: pi- missing
	locReaction->Add_ReactionStep(locReactionStep);
	dReactionStepPool.push_back(locReactionStep); //register so will be deleted later: prevent memory leak

	/**************************************************** TrackEff_MissingPiMinus Control Settings ****************************************************/

	// Recommended: Type of kinematic fit to perform (default is d_NoFit)
		//fit types are of type DKinFitType, an enum defined in sim-recon/src/libraries/ANALYSIS/DKinFitResults.h
	locReaction->Set_KinFitType(d_P4AndVertexFit); //simultaneously constrain apply four-momentum conservation, invariant masses, and common-vertex constraints

	// Highly Recommended: When generating particle combinations, reject all photon candidates with a PID confidence level < 5.73303E-7 (+/- 5-sigma)
	// locReaction->Set_MinPhotonPIDFOM(5.73303E-7);

	// Highly Recommended: When generating particle combinations, reject all charged track candidates with a PID confidence level < 5.73303E-7 (+/- 5-sigma)
	// locReaction->Set_MinChargedPIDFOM(5.73303E-7);

	// Highly Recommended: When generating particle combinations, reject all beam photons that match to a different RF bunch (delta_t > 1.002 ns)
	locReaction->Set_MaxPhotonRFDeltaT(2.004); //beam bunches are every 4.008 ns, (2.004 should be minimum cut value)

	// Optional, use with caution: When generating particle combinations, but after the Photon/RF Delta-t cut, reject all combos with more than this # of beam photons
		//useful for missing-particle studies when you need a very pure sample of events
		//however, this can cut away a lot of signal events too
	locReaction->Set_MaxNumBeamPhotonsInBunch(1);

	// Highly Recommended: Cut on number of extra "good" tracks. "Good" tracks are ones that survive the "PreSelect" (or user custom) factory.
		// Current (09/26/2014): "Good" tracks have a detector-hit match, and tracking FOM > 0.0027 (+/- 3 sigma).
		// Important: Keep cut large: Can have many ghost and accidental tracks that look "good"
	locReaction->Set_MaxExtraGoodTracks(1);

	/************************************************** TrackEff_MissingPiMinus Pre-Combo Custom Cuts *************************************************/

	// Highly Recommended: Very loose DAnalysisAction cuts, applied just after creating the combination (before saving it)
	// Example: Missing mass squared of proton
	locReaction->Add_ComboPreSelectionAction(new DCutAction_MissingMassSquared(locReaction, false, -0.2, 0.2));

	/**************************************************** TrackEff_MissingPiMinus Analysis Actions ****************************************************/

	// Recommended: Analysis actions automatically performed by the DAnalysisResults factories to histogram useful quantities.
		//These actions are executed sequentially, and are executed on each surviving (non-cut) particle combination
		//Pre-defined actions can be found in ANALYSIS/DHistogramActions.h and ANALYSIS/DCutActions.h

	// PID & Kinematics
	locReaction->Add_AnalysisAction(new DHistogramAction_PID(locReaction));

//INSERT TIGHT TIMING PID CUT HERE WHEN READY!!!! // Want as clean of an event sample as possible.
	locReaction->Add_AnalysisAction(new DCutAction_CutProtonPiPlusdEdx(locReaction, 2.0, true));

	// Tight cut on track quality
	locReaction->Add_AnalysisAction(new DCutAction_TrackHitPattern(locReaction, 2, 4)); //args: locMinHitRingsPerCDCSuperlayer, locMinHitPlanesPerFDCPackage

	// Missing Mass Squared
	locReaction->Add_AnalysisAction(new DHistogramAction_MissingMassSquared(locReaction, false, 800, -0.2, 0.2));

	// Kinematic Fit Results
	locReaction->Add_AnalysisAction(new DHistogramAction_KinFitResults(locReaction, 0.05)); //5% confidence level cut on pull histograms only
//	locReaction->Add_AnalysisAction(new DCutAction_KinFitFOM(locReaction, 0.05)); //5% confidence level cut //require kinematic fit converges

	// Kinematics
	locReaction->Add_AnalysisAction(new DHistogramAction_ParticleComboKinematics(locReaction, true)); //true: fill histograms with kinematic-fit particle data
	locReaction->Add_AnalysisAction(new DHistogramAction_TrackVertexComparison(locReaction));

	// Missing Mass Squared
	locReaction->Add_AnalysisAction(new DHistogramAction_MissingMassSquared(locReaction, false, 800, -0.2, 0.2, "Post-KinFit"));

	// Tracking Efficiency
	locReaction->Add_AnalysisAction(new DCustomAction_TrackingEfficiency(locReaction, true, 1)); //1: 1 vertex-z bin

	_data.push_back(locReaction); //Register the DReaction with the factory


	/**************************************************** TrackEff_MissingPiPlus Reaction Steps ****************************************************/

	locReaction = new DReaction("TrackEff_MissingPiPlus"); //needs to be a unique name for each DReaction object, CANNOT (!) be "Thrown"

	//Required: DReactionSteps to specify the channel and decay chain you want to study
		//Particles are of type Particle_t, an enum defined in sim-recon/src/libraries/include/particleType.h

	//Example: g, p -> pi-, p, (pi+)
	locReactionStep = new DReactionStep();
	locReactionStep->Set_InitialParticleID(Gamma);
	locReactionStep->Set_TargetParticleID(Proton);
	locReactionStep->Add_FinalParticleID(PiMinus);
	locReactionStep->Add_FinalParticleID(Proton);
	locReactionStep->Add_FinalParticleID(PiPlus, true); //true: pi+ missing
	locReaction->Add_ReactionStep(locReactionStep);
	dReactionStepPool.push_back(locReactionStep); //register so will be deleted later: prevent memory leak

	/**************************************************** TrackEff_MissingPiPlus Control Settings ****************************************************/

	// Recommended: Type of kinematic fit to perform (default is d_NoFit)
		//fit types are of type DKinFitType, an enum defined in sim-recon/src/libraries/ANALYSIS/DKinFitResults.h
	locReaction->Set_KinFitType(d_P4AndVertexFit); //simultaneously constrain apply four-momentum conservation, invariant masses, and common-vertex constraints

	// Highly Recommended: When generating particle combinations, reject all photon candidates with a PID confidence level < 5.73303E-7 (+/- 5-sigma)
	// locReaction->Set_MinPhotonPIDFOM(5.73303E-7);

	// Highly Recommended: When generating particle combinations, reject all charged track candidates with a PID confidence level < 5.73303E-7 (+/- 5-sigma)
	// locReaction->Set_MinChargedPIDFOM(5.73303E-7);

	// Highly Recommended: When generating particle combinations, reject all beam photons that match to a different RF bunch (delta_t > 1.002 ns)
	locReaction->Set_MaxPhotonRFDeltaT(2.004); //beam bunches are every 4.008 ns, (2.004 should be minimum cut value)

	// Optional, use with caution: When generating particle combinations, but after the Photon/RF Delta-t cut, reject all combos with more than this # of beam photons
		//useful for missing-particle studies when you need a very pure sample of events
		//however, this can cut away a lot of signal events too
	locReaction->Set_MaxNumBeamPhotonsInBunch(1);

	// Highly Recommended: Cut on number of extra "good" tracks. "Good" tracks are ones that survive the "PreSelect" (or user custom) factory.
		// Current (09/26/2014): "Good" tracks have a detector-hit match, and tracking FOM > 0.0027 (+/- 3 sigma).
		// Important: Keep cut large: Can have many ghost and accidental tracks that look "good"
	locReaction->Set_MaxExtraGoodTracks(1);

	/************************************************** TrackEff_MissingPiPlus Pre-Combo Custom Cuts *************************************************/

	// Highly Recommended: Very loose DAnalysisAction cuts, applied just after creating the combination (before saving it)
	// Example: Missing mass squared of proton
	locReaction->Add_ComboPreSelectionAction(new DCutAction_MissingMassSquared(locReaction, false, -0.2, 0.2));

	/**************************************************** TrackEff_MissingPiPlus Analysis Actions ****************************************************/

	// Recommended: Analysis actions automatically performed by the DAnalysisResults factories to histogram useful quantities.
		//These actions are executed sequentially, and are executed on each surviving (non-cut) particle combination
		//Pre-defined actions can be found in ANALYSIS/DHistogramActions.h and ANALYSIS/DCutActions.h

	// PID & Kinematics
	locReaction->Add_AnalysisAction(new DHistogramAction_PID(locReaction));

//INSERT TIGHT TIMING PID CUT HERE WHEN READY!!!! // Want as clean of an event sample as possible.
	locReaction->Add_AnalysisAction(new DCutAction_CutProtonPiPlusdEdx(locReaction, 2.0, true));

	// Tight cut on track quality
	locReaction->Add_AnalysisAction(new DCutAction_TrackHitPattern(locReaction, 2, 4)); //args: locMinHitRingsPerCDCSuperlayer, locMinHitPlanesPerFDCPackage

	// Missing Mass Squared
	locReaction->Add_AnalysisAction(new DHistogramAction_MissingMassSquared(locReaction, false, 800, -0.2, 0.2));

	// Kinematic Fit Results
	locReaction->Add_AnalysisAction(new DHistogramAction_KinFitResults(locReaction, 0.05)); //5% confidence level cut on pull histograms only
//	locReaction->Add_AnalysisAction(new DCutAction_KinFitFOM(locReaction, 0.05)); //5% confidence level cut //require kinematic fit converges

	// Kinematics
	locReaction->Add_AnalysisAction(new DHistogramAction_ParticleComboKinematics(locReaction, true)); //true: fill histograms with kinematic-fit particle data
	locReaction->Add_AnalysisAction(new DHistogramAction_TrackVertexComparison(locReaction));

	// Missing Mass Squared
	locReaction->Add_AnalysisAction(new DHistogramAction_MissingMassSquared(locReaction, false, 800, -0.2, 0.2, "Post-KinFit"));

	// Tracking Efficiency
	locReaction->Add_AnalysisAction(new DCustomAction_TrackingEfficiency(locReaction, true, 1)); //1: 1 vertex-z bin

	_data.push_back(locReaction); //Register the DReaction with the factory

	return NOERROR;
}

//------------------
// fini
//------------------
jerror_t DReaction_factory_trackeff_missing::fini(void)
{
	for(size_t loc_i = 0; loc_i < dReactionStepPool.size(); ++loc_i)
		delete dReactionStepPool[loc_i]; //cleanup memory
	return NOERROR;
}

