#ifndef PROJECTIVECALDATA
#define PROJECTIVECALDATA

//I can't guess why I didn't use an enum----no time to try to track it down now.
    const int BARREL = 1;
    const int FORWARD = 2;
    const int BOX = 3;
    const int RPHI = 4;
    const int ZPHI = 5;
    const int NOTIMP = 6;
struct projectiveCalData
{
      float z0;       // Z position of the middle of the detector
      float zLength;  // length of the detector
      float rMin[2];  // inner radius at zmin and zmax
      float rMax[2];  // outer radius at zmin and zmax
      int nPhi;       // the number of phi segments
      int nEta;       // the number of eta segments

};
#endif
