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
 gHtml->MakeClass("TMCFastTOF");
}
