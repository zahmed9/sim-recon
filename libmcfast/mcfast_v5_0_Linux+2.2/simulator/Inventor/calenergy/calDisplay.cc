#include <Inventor/nodes/SoSphere.h>
#include <iostream.h>
#include <Inventor/nodes/SoNode.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/nodes/SoSwitch.h>
#include "mcfEnergyScaleWindow.hh"
#include "calDisplay.hh"
#include "towerHit.hh"
#include "energyRep.hh"
#include "calPlotManager.hh"
#include "SoMcFCalEnergyKit.hh"
#include "calorCommon.hh"

int calDisplay::ncal = 0;
int *calDisplay::pical = NULL;
float *calDisplay::threshold = NULL;

void calDisplay::makeCalPlot(SoSeparator *root, PlotTypes calEtype, 
                             calDispInfo Info)
{
     calEnergy = new SoSeparator;
     SoSwitch *calGeom = new SoSwitch;
     calGeom->whichChild = SO_SWITCH_NONE;

     SoSeparator *hitCells;
     int i;
     if (calEtype == NOPLOT) return;
     ncal = NumCalorProj();
     if( pical == NULL)
     {
       pical = new int[ncal];
     }
     if( threshold == NULL)
     {
       threshold = new float[ncal];
     }
          
     for(i=0; i<ncal; i++)
     {
      *(pical+i) = i + 1; 
      *(threshold+i) = 0.05;
     }
     calPlotManager *manager = new calPlotManager;
     calorPlot = manager->PlotType(calEtype);
     if(calorPlot != NULL)
     {
       calGeom->addChild(makeCalGeometry(ncal, pical));
       hitCells = makeCalEnergy(Info);
       calEnergy->addChild(calGeom);
       calEnergy->addChild(hitCells);
       if( Info.dispFrame == ON ) calGeom->whichChild = 0;
       root->addChild(calEnergy); 
     }
     
}
void calDisplay::updateCalPlot(SoSeparator *root, PlotActions Action, 
                               calDispInfo Info)
{
     SoNode *tmp;
     SoSwitch *sw;
     SoSeparator *sep;
     
     
     if(calorPlot == NULL) return;  // no active plot

     //The calorimeter energy plot should have two nodes:
     //One node is the calorimeter frame and is a switched node
     //The other holds the cells.

     int numChild = calEnergy->getNumChildren();
     if(numChild != 2)
     {
      cout << "Error in CalDisplay!!" << endl;
      cout << "The number of children for the calorimeter plot"
           << "is incorrect"<< endl;
      cout << "Contact cope@fnal" << endl;  
      return;
     }
     for(int i = 0; i < numChild; i++)
     {
       tmp = (SoNode *) calEnergy->getChild(i);
       if(tmp->isOfType(SoSwitch::getClassTypeId()))
       {
          sw = (SoSwitch *) tmp;
       }
       else if(tmp->isOfType(SoSeparator::getClassTypeId()))
       {
          sep = (SoSeparator *) tmp;
       }

     }


     if(Action == REMOVEFRAME)
     {
       sw->whichChild = SO_SWITCH_NONE;
       return;
     } 
     else if(Action == ADDFRAME)
     {

       sw->whichChild = 0;
       return;
     }
     else if(Action == NEXTEVENT )
     {
       sep = makeCalEnergy( Info );
       calEnergy->replaceChild(1, sep );
       return;
     }
     else if(Action == NEWPARAMETERS)
     {
        updateCalEnergy( sep ,Info);
        return;
     }
     return;
}
SoSeparator *calDisplay::makeCalEnergy(calDispInfo Info)
{
   SoSeparator *hits; 
   if(calorPlot != NULL)
   {
       hits = calorPlot->MakeEnergyPlot();
       SbName *calHName = new SbName("CalorimeterEnergy");
       hits->setName(*calHName);
       updateCalEnergy(hits, Info);
   }
   return hits;

}
void calDisplay::updateCalEnergy(SoSeparator *hits, calDispInfo Info)
{
      
    Widget main = SoXt::getTopLevelWidget();
    mcfEnergyScaleWindow *energyScaleWindow = 
             mcfEnergyScaleWindow::energyScaleWindow(main);

   float max = energyScaleWindow->GetScaleMax();
   
   SoSeparator *sep = NULL;
   SoSwitch *sw;
   SoNode *tmp;
   int numChild = hits->getNumChildren();
   
   //The eta plot has an additional level of separator
   for(int j = 0; j < hits->getNumChildren(); j++)
   {
      tmp = (SoNode *) hits->getChild(j);
      if(tmp->isOfType(SoSwitch::getClassTypeId())) 
      {
         sep = hits;
         break;
      }
      else if(tmp->isOfType(SoSeparator::getClassTypeId()))
      {
         sep = (SoSeparator *) tmp;
         break;
      }
      
    }
   if(sep == NULL)
   {
      cout << "No hits available! " << endl;
      return;
   }
 
   for(int i = 0; i < sep->getNumChildren(); i++)
   {
       tmp = (SoNode *) sep->getChild(i);
       if(tmp->isOfType(SoSwitch::getClassTypeId()))
       {
          sw = (SoSwitch *) tmp;
          sw->whichChild = SO_SWITCH_NONE;
          tmp = sw->getChild(0);
          if(tmp->isOfType(SoMcFCalEnergyKit::getClassTypeId()))
          {
             SoMcFCalEnergyKit *kit = (SoMcFCalEnergyKit *) tmp;
             float cellEnergy=0;
             if(Info.dispEorEt == TRANSMOM )
             {             
               cellEnergy = kit->cellEt.getValue();
             }
             else
             {
               if(Info.hadEnergy == ON) 
                   cellEnergy += kit->hadEnergy.getValue(); 
               if(Info.emEnergy == ON)  
                   cellEnergy += kit->emEnergy.getValue(); 
               if(Info.minEnergy == ON) 
                   cellEnergy += kit->minEnergy.getValue();

             } 
             if( cellEnergy > Info.threshold)
             {
                sw->whichChild = 0;
                kit->defineCellColor(cellEnergy, max);               
             }
          }
       }
      
   }
   return;
}
SoSeparator *calDisplay::makeCalGeometry(int ncal, int *pical)
{
   SoSeparator *frame;
   if(calorPlot != NULL)
   {
       frame = calorPlot->MakePlotFrame(ncal, pical);
       SbName *calFName = new SbName("CalorimeterFrame");
       frame->setName(*calFName);
   }
   
   return frame;
}
SoSeparator *calDisplay::FindCalEnergy(void)
{
   return (SoSeparator *)SoNode::getByName("CalorimeterEnergy");
}
