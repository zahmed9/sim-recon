#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/SoInput.h>
#include <stdarg.h>
#ifndef XMSTUFF
#define XMSTUFF
#include <Xm/Xm.h>
#include <Xm/RowColumn.h>
#include <Xm/MainW.h>
#endif
#ifndef NIRVANA
#define NIRVANA
#include "misc.h"
#include "getfiles.h"
#endif
#include "McfReadEvent.h"
#define MAXPATHLEN     255
extern "C" {
void mcfastRead(char* fname);
}
class mcfFile
{
   private:
         static char filename[MAXPATHLEN]; 
         static int stream;  //only support one stream open at a time
         static int eventnumber;
         static SoInput externalGeometry;
   public:
        mcfFile(void)
        {
        }
        static void GetOpenAndReadMcfio(Widget parent);
        static int GetEvent(int nevent);
        static int GetNextEvent(void);
        static int OpenMcfioFile(char *filename);
        static void GetOpenAndReadDbin(Widget parent);
        static void GetOpenAndReadIV(Widget parent);
        void OutputInventorFile(Widget parent, SoSeparator *root);
        void OutputPostscriptFile(Widget parent, SoSeparator *root,
                                  SoXtViewer *viewer);
        static int getEventNumber(void)
        {
           return eventnumber;
        }
        static void setFilename(char *file)
        {
            strcpy(filename, file);
        }
        static int dbin(void)
        {
           if(strstr(filename, ".db")) return 1;
           return 0;
        }
        static void setStream(int str)
        {
            stream = str;
        }
        static void readDbin(char *filename)
        {
            mcfastRead(filename);
            return;
        }
        static char *getNameOfFile(void)
        {
            if(strstr(filename, ".db")) return &filename[0];
            if(stream >= 0) return &filename[0];
            return NULL;
        }
        void writeInventorFile(char *filename, SoSeparator *root);
        void writePostscriptFile(char *filename, SoSeparator *root,
                                  SoXtViewer *viewer);
        static SoInput getExternalGeometry(void)
        {
           return externalGeometry;
        }        
};
