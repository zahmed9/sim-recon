/*-----------------------------Hepvis----------------------------------------*/
/*                                                                           */
/* Node:             SoXtHepViewer                                           */
/* Description:      Viewer Class                                            */
/* Author:           Jeff Kallenbach Apr 16 1997                             */
/*                                                                           */
/*---------------------------------------------------------------------------*/
#ifndef SoXtHepViewer_H
#define SoXtHepViewer_H
#include <Inventor/Xt/SoXtComponent.h>
#include <Inventor/Xt/viewers/SoXtFullViewer.h>
#include <Inventor/SoPrimitiveVertex.h>
#include <Inventor/SbLinear.h>
#include <Xm/PushB.h>
class SoXtExaminerViewer;
class SoXtPlaneViewer;
class SoXtWalkViewer;
class SoXtFlyViewer;
class SoXtPrintDialog;
class SoSeparator;
class SoNode;
class SoGroup;
class SoLabel;
class SoEnvironment;
class SoDirectionalLight;
class SoPerspectiveCamera;
class SoXtColorEditor;
class SbColor;
class SoText2;
class SoTimerSensor;



class SoXtHepViewer: public SoXtComponent
{
  
public:

  typedef int (*QuitCallbackProc) (void *);
  typedef enum {EXAMINER, PLANE, WALK, FLY} ViewStyle;

  //
  // Constructor
  //
  SoXtHepViewer(Widget parent=NULL, 
		const char *name="Hepvis Viewer", 
		SbBool buildInsideParent=TRUE);
  //
  // Destructor
  //
  virtual ~SoXtHepViewer();
  
  virtual void setSceneGraph(SoNode *); 
  virtual SoNode *getSceneGraph() const; 

  //
  // Access to the viewer:
  //
  virtual SoXtFullViewer *getCurrentViewer() const;
  virtual SoXtFullViewer *getViewer(int viewNumber) const;

  //
  // Access to the top menu bar:
  //
  virtual Widget getMenuBar() const;
  
  //
  // Access to the text window
  //
  virtual void addText(char *TextItem);
  virtual void clearText();
  virtual void showTextArea();
  virtual void hideTextArea();
  
  //
  // Resize window
  //
  virtual void resizeMain(short hgt, short wid);
  
  //
  // Callbacks
  //
  virtual void setQuitCallback (QuitCallbackProc procedure, void * call_data);

protected:
  
  //
  // These are for printing...
  //
  SoXtPrintDialog *printDialog;
  static void printCallback(Widget w, XtPointer callData, 
XmPushButtonCallbackStruct *callbackStruct);
  static void print(SoXtHepViewer *);
  static void beforePrint(void *, SoXtPrintDialog *);
  static void afterPrint(void *, SoXtPrintDialog *);
  static void saveIVCallback(Widget w, XtPointer callData, 
XmPushButtonCallbackStruct *callbackStruct);
  static void saveIV(Widget, void *, XmFileSelectionBoxCallbackStruct *);  

  //
  // This "Exits"
  //
  static void invokeQuit (Widget w, XtPointer callData, XmPushButtonCallbackStruct *callbackStruct);

  //
  // These are for the file dialog...
  //
  static void openCallback(Widget w, XtPointer callData, 
              XmPushButtonCallbackStruct *callbackStruct);
  static void open(Widget, void *, XmFileSelectionBoxCallbackStruct *);  
  static int  quitCallback(void *);
  //
  // Check for valid input
  //
  static void verifyNumeric(Widget, XtPointer, XmTextVerifyCallbackStruct *);

  //
  // This is for error messages:
  //
  void setErrorMessage (char *);

  //
  // These are for editing the background color
  //
  static void editBackgroundColor(Widget w, XtPointer clientData, XmPushButtonCallbackStruct *callData);
  static void backgroundColorCB(void *This, const SbColor *color);

  //
  // This spawns a new view
  //
  static void spawnView
    (Widget w, XtPointer clientData, XmPushButtonCallbackStruct *);

  //
  // This toggles Antialiasing
  //
  static void toggleAACB
   (Widget w, XtPointer callData, XmToggleButtonCallbackStruct 
*callbackStruct);

  //
  // This toggles Perf Meter
  //
  static void togglePMCB
   (Widget w, XtPointer callData, XmToggleButtonCallbackStruct 
*callbackStruct);

  //
  // This toggles the view
  //
  static void toggleViewCB
   (Widget w, XtPointer callData, XmToggleButtonCallbackStruct 
*callbackStruct);

  //
  // This toggles the transparency
  //
  static void toggleTransCB
   (Widget w, XtPointer callData,XmToggleButtonCallbackStruct *callbackStruct);

  //
  // This toggles the highlight style
  //
  static void toggleHLCB
   (Widget w, XtPointer callData, XmToggleButtonCallbackStruct 
*callbackStruct);

  //
  // This exits the program
  //
  static void close
   (Widget w, XtPointer callData, XmPushButtonCallbackStruct *callbackStruct);

  //
  // This toggles the lights
  //
  static void toggleLights
    (Widget w, XtPointer clientData, XmToggleButtonCallbackStruct *callData);

  //
  // This is for the scene
  //
  SoSeparator *ancestor;
  SoNode      *sceneGraph;

  //
  // This is the background color editor
  //
  SoXtColorEditor *_backgroundColorEditor;

  //
  // These are the lights
  //
  SoDirectionalLight *_leftFlood;
  SoDirectionalLight *_rightFlood;
  SoDirectionalLight *_topFlood;
  SoDirectionalLight *_bottomFlood;

  virtual void create(Widget);
  
  SoXtFullViewer      *_theFullViewer;
  SoXtExaminerViewer  *_theExaminerViewer;
  SoXtPlaneViewer     *_thePlaneViewer;
  SoXtWalkViewer      *_theWalkViewer;
  SoXtFlyViewer       *_theFlyViewer;

  Widget _MainWindow;
  Widget _panedWindow;
  Widget _theTextArea;
  Widget _filterForm;
  Widget _menuBar;
  Widget _fileMenuButton;
  Widget _fileMenu;
  Widget _openButton;
  Widget _saveButton;
  Widget _printButton;
  Widget _closeButton;
  Widget _quitButton;
  Widget _viewMenuButton;
  Widget _viewMenu;
  Widget _lightsButton;
  Widget _lightsMenu;
  Widget _headlightButton;
  Widget _leftFloodButton;
  Widget _rightFloodButton;
  Widget _topFloodButton;
  Widget _bottomFloodButton;
  Widget _transparencyButton;
  Widget _transparencyMenu;
  Widget _screenDoorButton;
  Widget _blendedButton;
  Widget _sortedButton;
  Widget _sortedBlendedButton;
  Widget _antialiasingButton;
  Widget _perfMeterButton;
  Widget _editBackgroundButton;
  Widget _highlightButton;
  Widget _highlightMenu;
  Widget _noHighlightButton;
  Widget _boxHighlightButton;
  Widget _linesHighlightButton;
  Widget _viewStyle;
  Widget _pulldownMenu;
  Widget _examinerButton;
  Widget _planeButton;
  Widget _walkButton;
  Widget _flyButton;
  Widget _newExaminerButton;
  Widget _newPlaneButton;
  Widget _newWalkButton;
  Widget _newFlyButton;
  
private: 
  
  static String         _defaultSoXtHepViewerResources[];
  
  //
  // Lights, camera, environment!
  //
  SoGroup 	    	*lightsCameraEnvironment;
  SoLabel 	    	*envLabel;
  SoEnvironment   	*environment;
  SoGroup 	    	*lightGroup;
  SoPerspectiveCamera   *perspectiveCamera;

  //
  // Callbacks
  //
  QuitCallbackProc _quitCallback;

  //
  // Perf Meter
  //
  static void instrumentScene(SoXtHepViewer *This);
  static void instrumentViewer(SoXtHepViewer *viewer);
  static void unInstrumentViewer(SoXtHepViewer *viewer);
  static void overlayViewportCB(void *, SoAction *);
  static void perfSensorCB(void *, SoSensor *);
  static void viewStartCB(void *, SoXtViewer *);
  static void countUpdatesCB(void *, SoAction *);
  static  int countTriangles(SoNode *);
  static void countTriangleCB(void *, SoCallbackAction *, 
		  const SoPrimitiveVertex *, const SoPrimitiveVertex *, 
		  const SoPrimitiveVertex *);

  SoTimerSensor *perfSensor;
  SoText2 *perfMeterText;
  int Metered;
  int numTris;
  int numFramesRendered;

  SbBool wasAnimating;
  SbTime startTime; 
  double lastFrames;

  void *_quitCallData;

};

#endif


