#include "hitsDisplay.hh" 
SoSeparator *MakeSilDiskHits(void);
SoSeparator *MakeSilBarrelHits(void);
SoSeparator *MakeSilXYHits(void);
SoSeparator *MakeSilZRectHits(void);
void hitsDisplay::makeHitsDisplay(SoSeparator *root, displayType plot,
                                  hitsDispInfo hitsInfo)
{
     if ( plot.type == NOPLOT ) return;
     hits = new SoSeparator;
     hits->ref();
     if( hitsInfo.showSilDiskHits)
                hits->addChild(MakeSilDiskHits());
   
     if( hitsInfo.showSilBarrelHits)
               hits->addChild(MakeSilBarrelHits());

     if( hitsInfo.showSilXYHits)
     {
                 hits->addChild(MakeSilXYHits());
                 hits->addChild(MakeSilZRectHits());
     }
     
     root->addChild( hits );
     return;
     
}
void hitsDisplay::updateHitsDisplay(SoSeparator *root, displayType plot,
                              hitsDispInfo hitsInfo)
{
     if(plot.action == NOACTION || plot.type == NOPLOT) return;
     if(plot.action == NEXTEVENT || plot.action == NEWPARAMETERS)
     {
        if(hits != NULL) 
        {
            int children = hits->getNumChildren();
            for (int i = 0; i < children; i++)
            {
               hits->removeChild(children-(i+1));
            }
         
            if( hitsInfo.showSilDiskHits)
	              hits->addChild(MakeSilDiskHits());

            if( hitsInfo.showSilBarrelHits)
                   hits->addChild(MakeSilBarrelHits());

	    if( hitsInfo.showSilXYHits)
	    {
        	      hits->addChild(MakeSilXYHits());
                      hits->addChild(MakeSilZRectHits());
            }
         }
     }
     return;
}

