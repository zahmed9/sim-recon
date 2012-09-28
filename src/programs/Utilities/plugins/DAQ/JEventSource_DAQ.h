// $Id$
//
//    File: JEventSource_DAQ.h
// Created: Tue Aug  7 15:22:29 EDT 2012
// Creator: davidl (on Darwin harriet.jlab.org 11.4.0 i386)
//

#ifndef _JEventSource_DAQ_
#define _JEventSource_DAQ_

#include <map>
#include <vector>
#include <queue>
#include <list>
using std::map;
using std::vector;
using std::queue;

#include <JANA/jerror.h>
#include <JANA/JEventSource.h>
#include <JANA/JEvent.h>

#include <evioFileChannel.hxx>
#include <evioUtil.hxx>
using namespace evio;

#include "DModuleType.h"
#include "Df250PulseIntegral.h"
#include "Df250StreamingRawData.h"
#include "Df250WindowSum.h"
#include "Df250PulseRawData.h"
#include "Df250TriggerTime.h"
#include "Df250PulseTime.h"
#include "Df250WindowRawData.h"
#include "DF1TDCHit.h"


class JEventSource_DAQ: public jana::JEventSource{
	public:
		JEventSource_DAQ(const char* source_name);
		virtual ~JEventSource_DAQ();
		virtual const char* className(void){return static_className();}
		static const char* static_className(void){return "JEventSource_DAQ";}
		
		jerror_t GetEvent(jana::JEvent &event);
		void FreeEvent(jana::JEvent &event);
		jerror_t GetObjects(jana::JEvent &event, jana::JFactory_base *factory);
	
	private:
		
		int32_t last_run_number;
		
		evioChannel *chan;
		map<tagNum, MODULE_TYPE> module_type;

		bool AUTODETECT_MODULE_TYPES;
		bool DUMP_MODULE_MAP;

		// Utility class to hold pointers to containers for
		// all types of data objects we produce. This gets passed
		// into bank processor methods so that they can append
		// to the lists. Note that the naming scheme here needs to
		// include the exact name of the class with a "v" in front
		// and an "s" in back. (See #define in JEventSource_DAQ.cc
		// for more details.)
		class ObjList{
		public:
			
			int32_t run_number;
			
			vector<Df250PulseIntegral*>    vDf250PulseIntegrals;
			vector<Df250PulseRawData*>     vDf250PulseRawDatas;
			vector<Df250PulseTime*>        vDf250PulseTimes;
			vector<Df250StreamingRawData*> vDf250StreamingRawDatas;
			vector<Df250TriggerTime*>      vDf250TriggerTimes;
			vector<Df250WindowRawData*>    vDf250WindowRawDatas;
			vector<Df250WindowSum*>        vDf250WindowSums;
			vector<DF1TDCHit*>             vDF1TDCHits;
		};
	
		// EVIO events with more than one DAQ event ("blocked" or
		// "entangled" events") are parsed and have the events
		// stored in the following container so they can be dispensed
		// as needed.
		queue<ObjList*> stored_events;
	
		int32_t GetRunNumber(evioDOMTree *evt);
		MODULE_TYPE GuessModuleType(evioDOMNodeP bankPtr);
		void DumpModuleMap(void);
		
		void MergeObjLists(list<ObjList*> &events1, list<ObjList*> &events2);

		void ParseEVIOEvent(evioDOMTree *evt, uint32_t run_number);
		void Parsef250Bank(evioDOMNodeP bankPtr, list<ObjList*> &events);
		void Parsef125Bank(evioDOMNodeP bankPtr, list<ObjList*> &events);
		void ParseF1TDCBank(evioDOMNodeP bankPtr, list<ObjList*> &events);
		void ParseTSBank(evioDOMNodeP bankPtr, list<ObjList*> &events);
		void ParseTIBank(evioDOMNodeP bankPtr, list<ObjList*> &events);

		// f250 methods
		void MakeDf250WindowRawData(ObjList *objs, uint32_t rocid, uint32_t slot, uint32_t itrigger, const uint32_t* &iptr);
		void MakeDf250PulseRawData(ObjList *objs, uint32_t rocid, uint32_t slot, uint32_t itrigger, const uint32_t* &iptr);

	
};

#endif // _JEventSourceGenerator_DAQ_
