#include <GL/glx.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <stdio.h>
#include <unistd.h>
#include <stdio.h>
#include "glp.h"

#include <iostream.h>
#include <Inventor/SoDB.h>
#include <Inventor/actions/SoGLRenderAction.h>
#include <Inventor/nodes/SoCube.h>
#include <Inventor/nodes/SoDirectionalLight.h>
#include <Inventor/nodes/SoLightModel.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoSphere.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <Inventor/nodes/SoSelection.h>
#include <Inventor/nodes/SoNode.h>
#include <Inventor/SbLinear.h>
#include <Inventor/SoDB.h>
#include <Inventor/nodes/SoPerspectiveCamera.h>
#include "getfiles.h"
static Bool GLPRINIT = FALSE;

GLfloat Black[3]= {0.0, 0.0, 0.0};
GLfloat White[3]= {1.0, 1.0, 1.0};
struct {
    char sfx[8];
    int otype;
} Octl[] = {
    "ps",	GLP_PS,
    "eps",	GLP_EPS,
    "cgm",	GLP_CGM,
    "hpgl",	GLP_HPGL,
};
static SoXtExaminerViewer *myViewer;


//Build an Inventor scene with two objects and some light
int  buildScene(SoGroup *root, char *filename)
{
   SoInput in;
      if( ! in.openFile(filename) )
    {
          cout<< "Can't open file " << filename <<" for read\n";
          return 1;
    }
     SoNode *n;
     while ((SoDB::read(&in, n) != FALSE) && (n != NULL) )
     {
       root ->addChild(n);
     }  
   
    return 0;
}


void selectionCB(void *, SoPath *path )
{
  //initialize glprint
    if(!GLPRINIT)
    {
      glpInit();
      GLPRINIT = TRUE;
    }
    char filename[1000];
       if (GetNewFilename (SoXt::getTopLevelWidget(),
		     ".ps file for output:",filename ) 
		       == GFN_CANCEL) 
			 return;

    const SbViewportRegion &vp = myViewer->getViewportRegion();
    const SbVec2s &imagePixSize = vp.getViewportSizePixels();

    short x, y;
    imagePixSize.getValue(x,y);

    SoSeparator *head = new SoSeparator;
    SoSeparator *root = (SoSeparator *) path->getHead();
    SoCamera *camera = myViewer->getCamera();

    head->addChild(camera);
    head->addChild(new SoLightModel);
    head->addChild(myViewer->getHeadlight());
    head->addChild(root);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    FILE *fp;
    if((fp = fopen(filename,"w")) == NULL) {
	fprintf(stderr,"Can't open file.\n");
	return;
    }

    glViewport(0,0,x,y);
    glpBeginPage(Octl[0].otype,"glx","","",fp);		
    glpSetPage(8.5,11.0,GLP_ORIENT_PORTRAIT,1,.25,.25,.25,.25);	
    glpSetDevice(GLP_DEVICE_TYPE_RGB,0);			
    glpSetViewport(GLP_VIEWPORT_FILL, NULL, White);
    glpBegin(GLP_3D_COLOR,25000); 
   
     
    SbViewportRegion myViewport(x, y);
    SoGLRenderAction myRenderAction(myViewport);
    myRenderAction.apply(head);

    glpEnd();
    glpEndPage();
    return;						
   
}
int main(int argc, char**argv)
{
char *filename = NULL;
  if(argc>1)
  {
    filename = argv[1];
  }
  else
  {
     cout << "No input file provided" << endl;
     cout << "Please supply an input file" << endl;
     return 1;
  }
  Widget myWindow = SoXt::init(argv[0]);
  if (myWindow == NULL) exit(1);
   
  SoSeparator *root = new SoSeparator;
  root->ref();
  if(buildScene(root,filename) == 1) return 1;   
  SoSelection *selection = new SoSelection;
  selection->ref();
  selection->policy = SoSelection::SINGLE;
  selection->setPickMatching(FALSE);
  selection->addSelectionCallback(selectionCB);
  selection->addChild(root);
  myViewer = new SoXtExaminerViewer (myWindow);  
  myViewer->setSceneGraph(selection);
  myViewer->setTitle("Examiner");
  myViewer->show();
  
  SoXt::show(myWindow);
  SoXt::mainLoop();
   return 0;
}
