#ifndef CONICALDETECTORDATA
#define CONICALDETECTORDATA
//this is the structure for passing conical detector information, like
//muon systems and absorbers between mcfast structures and display

struct  ConicalDetectorData
{
         float z0;
         float zlen;
         float rminZlow;
         float rminZhigh;
         float rmaxZlow;
         float rmaxZhigh;
};
#endif
