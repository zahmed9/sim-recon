// $Id$
//
//    File: DAnalysisResults_factory.cc
// Created: Tue Aug  9 14:29:24 EST 2011
// Creator: pmatt (on Linux ifarml6 2.6.18-128.el5 x86_64)
//

#ifdef VTRACE
#include "vt_user.h"
#endif

#include "DAnalysisResults_factory.h"

//------------------
// init
//------------------
jerror_t DAnalysisResults_factory::init(void)
{
	dDebugLevel = 0;
	dMinThrownMatchFOM = 5.73303E-7;
	return NOERROR;
}

//------------------
// brun
//------------------
jerror_t DAnalysisResults_factory::brun(jana::JEventLoop *locEventLoop, int runnumber)
{
	dApplication = dynamic_cast<DApplication*>(locEventLoop->GetJApplication());

	gPARMS->SetDefaultParameter("ANALYSIS:DEBUGLEVEL", dDebugLevel);

	vector<const DReaction*> locReactions;
	Get_Reactions(locEventLoop, locReactions);

	vector<const DMCThrown*> locMCThrowns;
	locEventLoop->Get(locMCThrowns);

	//MAKE CONTROL HISTOGRAMS
	string locHistName, locHistTitle;
	const DReaction* locReaction;
	TDirectoryFile* locDirectoryFile;
	string locReactionName;
	TH1D* loc1DHist;
	TH2D* loc2DHist;
	size_t locNumActions;

	dApplication->RootWriteLock(); //to prevent undefined behavior due to directory changes, etc.
	{
		string locOutputFileName = "hd_root.root";
		if(gPARMS->Exists("OUTPUT_FILENAME"))
			gPARMS->GetParameter("OUTPUT_FILENAME", locOutputFileName);
		TFile* locFile = (TFile*)gROOT->FindObject(locOutputFileName.c_str());
		if(locFile == NULL)
		{
			cout << "ERROR: OUTPUT HISTOGRAM FILE " << locOutputFileName << " NOT FOUND IN DAnalysisResults_factory::brun(). ABORTING." << endl;
			abort();
		}
		locFile->cd("");

		for(size_t loc_i = 0; loc_i < locReactions.size(); ++loc_i)
		{
			locReaction = locReactions[loc_i];
			locReactionName = locReaction->Get_ReactionName();
			locNumActions = locReaction->Get_NumAnalysisActions();

			deque<string> locActionNames;
			for(size_t loc_j = 0; loc_j < locNumActions; ++loc_j)
				locActionNames.push_back(locReaction->Get_AnalysisAction(loc_j)->Get_ActionName());

			const char* locDirName = locReactionName.c_str();
			locFile->cd();
			locDirectoryFile = static_cast<TDirectoryFile*>(locFile->GetDirectory(locDirName));
			if(locDirectoryFile == NULL)
				locDirectoryFile = new TDirectoryFile(locDirName, locDirName);
			locDirectoryFile->cd();

			locHistName = "NumEventsSurvivedAction";
			loc1DHist = static_cast<TH1D*>(locDirectoryFile->Get(locHistName.c_str()));
			if(loc1DHist == NULL)
			{
				locHistTitle = locReactionName + string(";;# Events Survived Action");
				loc1DHist = new TH1D(locHistName.c_str(), locHistTitle.c_str(), locNumActions + 2, -0.5, locNumActions + 2.0 - 0.5); //+2 for input & # tracks
				loc1DHist->GetXaxis()->SetBinLabel(1, "Input"); // a new event
				loc1DHist->GetXaxis()->SetBinLabel(2, "Has Particle Combos"); // at least one DParticleCombo object before any actions
				for(size_t loc_j = 0; loc_j < locActionNames.size(); ++loc_j)
					loc1DHist->GetXaxis()->SetBinLabel(3 + loc_j, locActionNames[loc_j].c_str());
			}
			dHistMap_NumEventsSurvivedAction_All[locReaction] = loc1DHist;

			if(!locMCThrowns.empty())
			{
				locHistName = "NumEventsWhereTrueComboSurvivedAction";
				loc1DHist = static_cast<TH1D*>(locDirectoryFile->Get(locHistName.c_str()));
				if(loc1DHist == NULL)
				{
					locHistTitle = locReactionName + string(";;# Events Where True Combo Survived Action");
					loc1DHist = new TH1D(locHistName.c_str(), locHistTitle.c_str(), locNumActions + 1, -0.5, locNumActions + 1.0 - 0.5); //+1 for # tracks
					loc1DHist->GetXaxis()->SetBinLabel(1, "Has Particle Combos"); // at least one DParticleCombo object before any actions
					for(size_t loc_j = 0; loc_j < locActionNames.size(); ++loc_j)
						loc1DHist->GetXaxis()->SetBinLabel(2 + loc_j, locActionNames[loc_j].c_str());
				}
				dHistMap_NumEventsWhereTrueComboSurvivedAction[locReaction] = loc1DHist;
			}

			locHistName = "NumCombosSurvivedAction";
			loc2DHist = static_cast<TH2D*>(locDirectoryFile->Get(locHistName.c_str()));
			if(loc2DHist == NULL)
			{
				double* locBinArray = new double[55];
				for(unsigned int loc_j = 0; loc_j < 6; ++loc_j)
				{
					for(unsigned int loc_k = 1; loc_k <= 9; ++loc_k)
						locBinArray[loc_j*9 + loc_k - 1] = double(loc_k)*pow(10.0, double(loc_j));
				}
				locBinArray[54] = 1.0E6;

				locHistTitle = locReactionName + string(";;# Particle Combos Survived Action");
				loc2DHist = new TH2D(locHistName.c_str(), locHistTitle.c_str(), locNumActions + 1, -0.5, locNumActions + 1 - 0.5, 54, locBinArray); //+1 for # tracks
				delete[] locBinArray;
				loc2DHist->GetXaxis()->SetBinLabel(1, "Has Particle Combos"); // at least one DParticleCombo object before any actions
				for(size_t loc_j = 0; loc_j < locActionNames.size(); ++loc_j)
					loc2DHist->GetXaxis()->SetBinLabel(2 + loc_j, locActionNames[loc_j].c_str());
			}
			dHistMap_NumCombosSurvivedAction[locReaction] = loc2DHist;

			locHistName = "NumCombosSurvivedAction1D";
			loc1DHist = static_cast<TH1D*>(locDirectoryFile->Get(locHistName.c_str()));
			if(loc1DHist == NULL)
			{
				locHistTitle = locReactionName + string(";;# Particle Combos Survived Action");
				loc1DHist = new TH1D(locHistName.c_str(), locHistTitle.c_str(), locNumActions + 1, -0.5, locNumActions + 1 - 0.5); //+1 for # tracks
				loc1DHist->GetXaxis()->SetBinLabel(1, "Minimum # Tracks"); // at least one DParticleCombo object before any actions
				for(size_t loc_j = 0; loc_j < locActionNames.size(); ++loc_j)
					loc1DHist->GetXaxis()->SetBinLabel(2 + loc_j, locActionNames[loc_j].c_str());
			}
			dHistMap_NumCombosSurvivedAction1D[locReaction] = loc1DHist;
			locDirectoryFile->cd("..");
		}
		locFile->cd(""); //return to base directory
	}
	dApplication->RootUnLock(); //unlock

	//auto-detect whether the DReaction is expected to be the entire reaction or a subset
	if(!locMCThrowns.empty())
	{
		for(size_t loc_i = 0; loc_i < locReactions.size(); ++loc_i)
		{
			bool locExactMatchFlag = true;
			if(locReactions[loc_i]->Get_ReactionStep(0)->Get_InitialParticleID() != Gamma)
				locExactMatchFlag = false;
			else
			{
				Particle_t locMissingPID = Unknown;
				if(locReactions[loc_i]->Get_MissingPID(locMissingPID))
				{
					if(!Is_FinalStateParticle(locMissingPID))
						locExactMatchFlag = false;
				}
			}
			dMCReactionExactMatchFlags[locReactions[loc_i]] = locExactMatchFlag;
			dTrueComboCuts[locReactions[loc_i]] = new DCutAction_TrueCombo(locReactions[loc_i], dMinThrownMatchFOM, locExactMatchFlag);
			dTrueComboCuts[locReactions[loc_i]]->Initialize(locEventLoop);
		}
	}

 	vector<const DEventRFBunch*> locEventRFBunches;
	locEventLoop->Get(locEventRFBunches, "Combo"); //for ordering histograms in the output file

 	vector<const DParticleCombo*> locParticleCombos;
	locEventLoop->Get(locParticleCombos, "PreKinFit"); //for ordering histograms in the output file

	return NOERROR;
}

void DAnalysisResults_factory::Get_Reactions(jana::JEventLoop* locEventLoop, vector<const DReaction*>& locReactions) const
{
	// Get list of factories and find all the ones producing
	// DReaction objects. (A simpler way to do this would be to
	// just use locEventLoop->Get(...), but then only one plugin could
	// be used at a time.)
	locReactions.clear();
	vector<JFactory_base*> locFactories = locEventLoop->GetFactories();
	for(size_t loc_i = 0; loc_i < locFactories.size(); ++loc_i)
	{
		JFactory<DReaction>* locFactory = dynamic_cast<JFactory<DReaction>* >(locFactories[loc_i]);
		if(locFactory == NULL)
			continue;
		if(string(locFactory->Tag()) == "Thrown")
			continue;

		// Found a factory producing DReactions. The reaction objects are
		// produced at the init stage and are persistent through all event
		// processing so we can grab the list here and append it to our
		// overall list.
		vector<const DReaction*> locReactionsSubset;
		locFactory->Get(locReactionsSubset);
		locReactions.insert(locReactions.end(), locReactionsSubset.begin(), locReactionsSubset.end());
	}
}

//------------------
// evnt
//------------------
jerror_t DAnalysisResults_factory::evnt(jana::JEventLoop* locEventLoop, int eventnumber)
{
#ifdef VTRACE
	VT_TRACER("DAnalysisResults_factory::evnt()");
#endif

	if(dDebugLevel > 0)
		cout << "Begin event " << eventnumber << " analysis." << endl;

	vector<const DReaction*> locReactions;
	Get_Reactions(locEventLoop, locReactions);

 	vector<const DParticleCombo*> locParticleCombos;
	locEventLoop->Get(locParticleCombos);

	vector<const DMCThrown*> locMCThrowns;
	locEventLoop->Get(locMCThrowns);

	const DReaction* locReaction;
	DAnalysisResults* locAnalysisResults;
	DAnalysisAction* locAnalysisAction;

	if(dDebugLevel > 0)
		cout << "Total # PostKinFit DParticleCombos: " << locParticleCombos.size() << endl;

	//organize the combos by dreaction
	map<const DReaction*, set<const DParticleCombo*> > dCombosByReaction;
	for(size_t loc_j = 0; loc_j < locParticleCombos.size(); ++loc_j)
		dCombosByReaction[locParticleCombos[loc_j]->Get_Reaction()].insert(locParticleCombos[loc_j]);

	for(size_t loc_i = 0; loc_i < locReactions.size(); ++loc_i)
	{
		locReaction = locReactions[loc_i];
		locAnalysisResults = new DAnalysisResults();
		locAnalysisResults->Set_Reaction(locReaction);

		if(dCombosByReaction.find(locReaction) == dCombosByReaction.end())
		{
			_data.push_back(locAnalysisResults);
			continue;
		}

		set<const DParticleCombo*>& locSurvivingParticleCombos = dCombosByReaction[locReaction];

		//find the true particle combo
		const DParticleCombo* locTrueParticleCombo = NULL;
		if(dTrueComboCuts.find(locReaction) != dTrueComboCuts.end())
		{
			set<const DParticleCombo*>::iterator locIterator = locSurvivingParticleCombos.begin();
			for(; locIterator != locSurvivingParticleCombos.end(); ++locIterator)
			{
				if(!(*dTrueComboCuts[locReaction])(locEventLoop, *locIterator))
					continue;
				locTrueParticleCombo = *locIterator;
				break;
			}
		}
		int locLastActionTrueComboSurvives = (locTrueParticleCombo != NULL) ? -1 : -2; //-1/-2: combo does/does-not exist

		if(dDebugLevel > 0)
			cout << "Evaluating DReaction: " << locReaction->Get_ReactionName() << endl;
		if(dDebugLevel > 0)
			cout << "# DParticleCombos in this DReaction: " << locSurvivingParticleCombos.size() << endl;

		//execute the actions
		size_t locNumAnalysisActions = locReaction->Get_NumAnalysisActions();
		deque<size_t> locNumParticleCombosSurvivedActions;
		bool locPreKinFitActionFlag = true;
		size_t locNumPreKinFitActions = 0;
		for(size_t loc_j = 0; loc_j < locNumAnalysisActions; ++loc_j)
		{
			if(locSurvivingParticleCombos.empty())
				break;

			locAnalysisAction = locReaction->Get_AnalysisAction(loc_j);
			if(locPreKinFitActionFlag)
			{
				if(locAnalysisAction->Get_UseKinFitResultsFlag())
					locPreKinFitActionFlag = false; //need kinfit results: this and all proceeding actions have not yet been performed: do them!
				else
				{
					++locNumPreKinFitActions;
					continue; //already performed by DAnalysisResults_factory_PreKinFit
				}
			}

			size_t locNumPreActionParticleCombos = locSurvivingParticleCombos.size();
			if(dDebugLevel > 0)
				cout << "Execute Action # " << loc_j + 1 << ": " << locAnalysisAction->Get_ActionName() << " on " << locSurvivingParticleCombos.size() << " surviving DParticleCombos." << endl;
			(*locAnalysisAction)(locEventLoop, locSurvivingParticleCombos); //EXECUTE!
			locNumParticleCombosSurvivedActions.push_back(locSurvivingParticleCombos.size());
			if(locSurvivingParticleCombos.find(locTrueParticleCombo) != locSurvivingParticleCombos.end())
				locLastActionTrueComboSurvives = loc_j;

			if(dDebugLevel > 0)
				cout << locNumPreActionParticleCombos - locNumParticleCombosSurvivedActions.back() << " combos failed the action." << endl;
		}

		set<const DParticleCombo*>::iterator locIterator = locSurvivingParticleCombos.begin();
		for(; locIterator != locSurvivingParticleCombos.end(); ++locIterator)
			locAnalysisResults->Add_PassedParticleCombo(*locIterator);

		//fill histograms & trees
		dApplication->RootWriteLock();
		{
			for(size_t loc_j = 0; loc_j < locNumParticleCombosSurvivedActions.size(); ++loc_j)
			{
				if(locNumParticleCombosSurvivedActions[loc_j] > 0)
				{
					dHistMap_NumEventsSurvivedAction_All[locReaction]->Fill(loc_j + locNumPreKinFitActions + 2); //+2 because 0 is initial (no cuts at all), and 1 is min #tracks
					dHistMap_NumCombosSurvivedAction[locReaction]->Fill(loc_j + locNumPreKinFitActions + 1, locNumParticleCombosSurvivedActions[loc_j]); //+1 because 0 is min #tracks
				}
				for(size_t loc_k = 0; loc_k < locNumParticleCombosSurvivedActions[loc_j]; ++loc_k)
					dHistMap_NumCombosSurvivedAction1D[locReaction]->Fill(loc_j + locNumPreKinFitActions + 1); //+1 because 0 is min #tracks
			}
			for(int loc_j = 0; loc_j <= locLastActionTrueComboSurvives; ++loc_j)
				dHistMap_NumEventsWhereTrueComboSurvivedAction[locReaction]->Fill(loc_j + locNumPreKinFitActions + 1); //+1 because 0 is min #tracks
		}
		dApplication->RootUnLock();

		_data.push_back(locAnalysisResults);
	}

	if(dDebugLevel > 0)
		cout << "End of event " << eventnumber << " analysis." << endl;
	return NOERROR;
}


//------------------
// erun
//------------------
jerror_t DAnalysisResults_factory::erun(void)
{
	return NOERROR;
}

//------------------
// fini
//------------------
jerror_t DAnalysisResults_factory::fini(void)
{
	return NOERROR;
}


