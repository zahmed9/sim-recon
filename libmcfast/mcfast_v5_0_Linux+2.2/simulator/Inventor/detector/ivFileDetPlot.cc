#include <Inventor/SoInput.h>
#include <Inventor/SoDB.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/nodes/SoNode.h>
#include "ivFileDetPlot.hh"
#include "mcfFile.hh"
SoSeparator *ivFileDetPlot::detector = NULL;

SoSeparator *ivFileDetPlot::makeDetector(void)
{
    if(detector == NULL)
    {
	SoInput input = mcfFile::getExternalGeometry();
	detector = new SoSeparator;
	//if (input == NULL)
	//{
	//   mcfFile *file = new mcfFile;  
	//   file->GetOpenAndReadIV(SoXt::getTopLevelWidget());  
	//}
	input = mcfFile::getExternalGeometry();
	SoNode *n;
	while (( SoDB::read(&input, n) != FALSE) && ( n !=NULL ) )
	{
	   detector->addChild(n);
	}
    }	
    return detector;    
}
