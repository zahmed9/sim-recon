#ifndef SoXtHepEventViewer_H
#define SoXtHepEventViewer_H
#include <Xm/PushB.h>
#include "hepvis/SoXtHepViewer.hh"

typedef int (*EventSelectCallbackProc) (int, int, void *);
typedef int (*FileOpenCallbackProc)    (char *, void *);
typedef int (*NextEventCallbackProc)   (void *);
typedef int (*RewindCallbackProc)      (void *);

class SoXtHepEventViewer: public SoXtHepViewer
{
  
public:

  // Constructor
  SoXtHepEventViewer(Widget parent=NULL, 
		     const char *name="Hepvis Event Viewer", 
		     SbBool buildInsideParent=TRUE);
  // Destructor
  virtual ~SoXtHepEventViewer();
  
  // Callback Functions
  virtual void setEventSelectCallback(EventSelectCallbackProc proceedure, void *call_data=NULL);
  virtual void setNextEventCallback  (NextEventCallbackProc   proceedure, void *call_data=NULL);
  virtual void setRewindCallback     (RewindCallbackProc      proceedure, void *call_data=NULL);
  virtual void setFileOpenCallback   (FileOpenCallbackProc    proceedure, void *call_data=NULL);

  // Set run and event number
  virtual void setRunNumber(int);
  virtual void setEventNumber(int);

protected:
  
  // These are for the file dialog...
  static void openCallback(Widget w, XtPointer callData, XmPushButtonCallbackStruct *callbackStruct);
  static void invokeFileOpen(Widget, void *, XmFileSelectionBoxCallbackStruct *);  

  // These are for event filtering
  static void invokeSelectEvent (Widget w, XtPointer callData, XmAnyCallbackStruct *callbackStruct);
  static void invokeNextEvent(Widget w, XtPointer callData, XmPushButtonCallbackStruct *callbackStruct);
  static void invokeRewind(Widget w, XtPointer callData, XmPushButtonCallbackStruct *callbackStruct);

  virtual void create(Widget);
  
  Widget _eventLabel;
  Widget _runLabel;
  Widget _eventNumberField;
  Widget _runNumberField;
  Widget _nextEventButton;
  Widget _rewindButton;
  Widget _openButton;
  
private: 
  
  static String         _defaultSoXtHepEventViewerResources[];
  
  // Callbacks
  
  EventSelectCallbackProc _eventSelectCallback;
  FileOpenCallbackProc    _fileOpenCallback;
  NextEventCallbackProc   _nextEventCallback;
  RewindCallbackProc      _rewindCallback;

  // Call data

  void *_eventSelectCallData;
  void *_fileOpenCallData;
  void *_nextEventCallData;
  void *_rewindCallData;

};

#endif

