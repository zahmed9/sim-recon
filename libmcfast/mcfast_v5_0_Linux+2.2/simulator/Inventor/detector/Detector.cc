#include "McFDetectorTreeList.hh"
#include "McFDetDevice.hh"
#include "Detector.hh"
//make the head of the detector tree a dummy called detector
void Detector(void)
{
//make the head of the detectors

    McFDetectorTreeList *detector = new McFDetectorTreeList;
    detector->detector.deviceId = HEAD;
    detector->detector.whichOne = 0;
    strcpy(detector->detector.name, "Detector");
    return;
 
}
