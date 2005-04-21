
#ifndef _MYMAINFRAME_H_
#define _MYMAINFRAME_H_

// This class is made into a ROOT dictionary ala rootcint.

#include <TGApplication.h>
#include <TGFrame.h>
#include <TGClient.h>
#include <TCanvas.h>
#include <TGComboBox.h>
#include <TGLabel.h>
#include <TThread.h>

class MyMainFrame:public TGMainFrame {

	public:
		enum displayType{
			dtNone,
			dtLines,
			dtHoughDensity,
			dtSlopeDensity,
			dtInterceptDensity,
			dtPhiVsZ,
			dtHits
		};

		MyMainFrame(const TGWindow *p, UInt_t w, UInt_t h);
		~MyMainFrame(){};
		
		// Slots for ROOT GUI
		void DoQuit(void);
		void DoPrev(void);
		void DoNext(void);
		void DoTimer(void);
		void DoSetDisplay(Int_t);

		// Other (non-slot) methods
		void Update(void);
		inline void SetGrid(int s){maincanvas->SetGridx(s);maincanvas->SetGridy(s);}
		inline Int_t GetDisplayType(void){return display->GetSelected();}
		
		
	private:
		TCanvas *maincanvas;
		TGComboBox *display;
		TGLabel *eventno, *filename;
		const char* sourcename;
			
	ClassDef(MyMainFrame,1)
};


#endif //_MYMAINFRAME_H_
