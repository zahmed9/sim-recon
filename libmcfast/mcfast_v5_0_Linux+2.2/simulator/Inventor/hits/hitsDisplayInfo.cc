#include "hitsDisplayInfo.hh"
void hitsDispInfoInitialize( hitsDispInfo *temp)
{
   //set up defaults for trace plot
   temp->showSilBarrelHits = TRUE;   //not debugged yet
   temp->showSilDiskHits = TRUE;   
   temp->showSilXYHits = TRUE;   
   return;
}
void hitsDispInfoSet( hitsDispInfo set, hitsDispInfo *temp)
{
   temp->showSilBarrelHits = set.showSilBarrelHits;   
   temp->showSilDiskHits = set.showSilDiskHits; 
   temp->showSilXYHits  = set.showSilXYHits;  
   return;
}
