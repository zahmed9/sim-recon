{
//
// A macro to create the TMCFast html docs
//
 #include <iostream.h>

 gSystem->Load("libTMCFast.so"); 
 THtml html;
 gHtml->MakeClass("TMCFastHepEvt");
 gHtml->MakeClass("TMCFastHepParticle");
 gHtml->MakeClass("TMCFastOfflineTrack");
 gHtml->MakeClass("TMCFastCalorHits");
 gHtml->MakeClass("TMCFastCalorimeter");
 gHtml->MakeClass("TCalHitTracks");
 gHtml->MakeClass("TMCParticle");
 gHtml->MakeClass("TMCesr");
 gHtml->MakeClass("TLGDsmears"); 
 gHtml->MakeClass("TLGDparticle");
 gHtml->MakeClass("TMCFastTraceEvent");
 gHtml->MakeClass("TMCFastTraceParticle");
 gHtml->MakeClass("TMCFastTracePoint");

}
