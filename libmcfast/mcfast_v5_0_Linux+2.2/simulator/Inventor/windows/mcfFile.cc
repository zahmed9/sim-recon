#include <stdio.h>
#include <unistd.h>
#include <stdio.h>
#include <stdio.h>
#include <iostream.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCamera.h>
#include <Inventor/nodes/SoDirectionalLight.h>
#include <Inventor/actions/SoWriteAction.h>
#include <Inventor/actions/SoGLRenderAction.h>
#include "mcfDisplayList.hh"
#include "displayTypes.hh"
#include "mcfFile.hh"
#include "eventInformation.hh"
extern "C" {
#include "DialogF.h"
}
//create storage for statics
int mcfFile::stream = -999;
int mcfFile::eventnumber = -999;
char mcfFile::filename[MAXPATHLEN];
SoInput mcfFile::externalGeometry = NULL;

void mcfFile::GetOpenAndReadMcfio(Widget parent)
{
    int status;
     if(stream >= 0)
    {
       Mcf_CloseStream(stream);
    }
       SetFileDialogDefaultPattern("*.evt");
       if (GetExistingFilename (parent,
                       "Mcfio File to Open:",filename ) 
                         == GFN_CANCEL) 
                            return;
                        
   stream = OpenMcfioFile(filename);
   if(stream < 0) return;
   status = GetNextEvent();
   return;
            
}

int mcfFile::GetEvent(int nevent)
{   
    int status;
    Widget parent = SoXt::getTopLevelWidget();

    if (stream < 0) 
    {
      DialogF(DF_ERR, parent, 1, 
	   "Please open Mcfio file", "Acknowledged"); 

      return -1;
    }
    status = Mcf_ReadSpecEvent(stream,nevent);
    eventnumber = nevent;
    if(status < 0)
    {
      DialogF(DF_ERR, parent, 1, 
	   "Error reading %s, event = %d", "Acknowledged", 
		                 filename, eventnumber);
      return -1;
    }
    return status;

}int mcfFile::GetNextEvent(void)
{   
    int status;
    Widget parent = SoXt::getTopLevelWidget();

    if (stream < 0) 
    {
      DialogF(DF_ERR, parent, 1, 
	   "Please open Mcfio file", "Acknowledged"); 

      return -1;
    }
    int nevent;
    status = Mcf_ReadEvent(stream,&nevent);
    eventnumber = nevent;
    if(status < 0)
    {
      DialogF(DF_ERR, parent, 1, 
	   "Error reading %s, event = %d", "Acknowledged", 
		                 filename, eventnumber);
      return -1;
    }
    return status;

}
int mcfFile::OpenMcfioFile(char *filename)
{
   int strm;
   strm = Mcf_OpenFile(filename);
   if(strm < 0)
   {
     Widget parent = SoXt::getTopLevelWidget();
     DialogF(DF_ERR, parent, 1, 
     	  "Error opening %s", "Acknowledged",filename);
     return -999;
   }
   return strm;
}

extern "C" {
void mcfastRead(char* fname);
}

void mcfFile::GetOpenAndReadDbin(Widget parent)
{
       SetFileDialogDefaultPattern("*.db");
       if (GetExistingFilename (parent,
                       "Db File to Open:",filename ) 
                         == GFN_CANCEL) 
                            return;
                        
   if(strstr(filename,".db") == NULL)
   {
     DialogF(DF_ERR, parent, 1, 
     	  "%s does not have standard extension", "Acknowledged",filename);
     return;
   }
   readDbin(filename);
   return;

}
void mcfFile::GetOpenAndReadIV(Widget parent)
{
    char ivFilename[MAXPATHLEN];
       SetFileDialogDefaultPattern("*.iv");
       if (GetExistingFilename (parent,
                       "IV format Geometry File to Open:",ivFilename ) 
                         == GFN_CANCEL) 
                            return;
                        
   if(strstr(ivFilename,".iv") == NULL)
   {
     DialogF(DF_ERR, parent, 1, 
     	  "%s does not have standard extension", "Acknowledged",filename);
     return;
   }
   externalGeometry.openFile(ivFilename);
   return;

}
void mcfFile::OutputInventorFile(Widget parent, SoSeparator *root)
{
    char filename[MAXPATHLEN];
       if (GetNewFilename (parent,
                       "iv file for output:",filename ) 
                         == GFN_CANCEL) 
                            return;
     writeInventorFile(filename, root);
     return;
    
}
void mcfFile::OutputPostscriptFile(Widget parent, SoSeparator *root,
                                   SoXtViewer *viewer)
{
//    char filename[MAXPATHLEN];
//       if (GetNewFilename (parent,
//		     ".ps file for output:",filename ) 
//		       == GFN_CANCEL) 
//			 return;
//     writePostscriptFile(filename, root, viewer);
     
      DialogF(DF_INF, parent, 1, 
	   "Sorry!  Save an inventor file and contact cope@fnal", "Ok"); 
     return;
    
}
void mcfFile::writeInventorFile(char *filename, SoSeparator *root)
{
    SoWriteAction myAction;
    myAction.getOutput()->openFile(filename);
    myAction.getOutput()->setBinary(FALSE);
    myAction.apply(root);
    myAction.getOutput()->closeFile();
    return;
}
void mcfFile::writePostscriptFile(char *filename, SoSeparator *root,
                                  SoXtViewer *viewer)
{
   return;
}
