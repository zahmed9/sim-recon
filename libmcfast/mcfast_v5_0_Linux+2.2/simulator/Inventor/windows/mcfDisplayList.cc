#include <iostream.h>
#include "mcfDisplayList.hh"
mcfDisplayList *mcfDisplayList::pHeadMcfDisplay = NULL;

 mcfDisplayList::~mcfDisplayList(void)
 {
     delete plot;
 }
   void mcfDisplayList::mcfFreeList(void)
   {
      mcfDisplayList *temp, *temp2;
      temp = pHeadMcfDisplay;
      while(temp != NULL)
      {
         temp2=temp->pNextMcfDisplay;
         delete temp;
         temp = temp2;
      }
      pHeadMcfDisplay = NULL; return;
   }
   void mcfDisplayList::mcfDispAddToList( mcfDisplayList *temp  )
   {
      mcfDisplayList *last, *temp2;
      if( pHeadMcfDisplay == NULL) 
      {
         pHeadMcfDisplay = temp;
      }
      else
      { 
//         last->pNextMcfDisplay = temp;
	   mcfDisplayList *lastNode = pHeadMcfDisplay;
	   last = pHeadMcfDisplay;
	   while( lastNode != NULL )
	   {
	     last = lastNode;
             lastNode = lastNode->pNextMcfDisplay;        
           }
           
      }
      temp2 = last;
      last->pNextMcfDisplay = temp;
      last = temp;
      last-> pPreMcfDisplay = temp2;
      
      return;
   }
   void mcfDisplayList::mcfDisplayDeleteFromList(void)
   {
      mcfDisplayList *temp = this;
      if(temp == pHeadMcfDisplay)
      {
         if(temp->pNextMcfDisplay == NULL)
         {
           pHeadMcfDisplay = NULL;
           delete temp;
         }
         else
         {
            pHeadMcfDisplay = temp->pNextMcfDisplay;
            delete temp; 
         }
         return;
      }
      mcfDisplayList *temp2,*temp3;
      temp2 = temp->pPreMcfDisplay;
      temp3 = temp->pNextMcfDisplay;
      if(temp2 != NULL) temp2->pNextMcfDisplay = temp3;
      if(temp3 != NULL) temp3->pPreMcfDisplay = temp2;
      delete temp; return;
   }
   void mcfDisplayList::mcfDisplayUpdateAll(displayType cdisp, 
                                            displayType tdisp,
                                            displayType hdisp)
   {
      mcfDisplayList *temp;
      temp = pHeadMcfDisplay;
      while( temp != NULL )
      {
        temp->plot->updatePlot(cdisp, tdisp, hdisp);
        temp = temp->pNextMcfDisplay;
      }
      return;
   }
   void mcfDisplayList::mcfDisplayUpdateAllCal(void)
   //this the function called to updated the scale energy
   {
      mcfDisplayList *temp;
      temp = pHeadMcfDisplay;
      while( temp != NULL )
      {
        temp->plot->updatePlotWindowCalHits();
        temp = temp->pNextMcfDisplay;
      }
      return;
   }
   mcfDisplayList *mcfDisplayList::findDisplay(mcfPlotWindow *plot)
   {
      mcfDisplayList *temp = pHeadMcfDisplay;
      while( temp != NULL )
      {
        if(temp->plot == plot ) return temp;
        temp = temp->pNextMcfDisplay;
        
      }
      cout << "mcfDisplayList::unable to find requested window in list\n";
      return NULL;
      
   }
   void mcfDisplayList::deleteDisplay(mcfPlotWindow *plot)
   {
       mcfDisplayList *temp = findDisplay(plot);
       temp->mcfDisplayDeleteFromList();
       return;
   }
