#ifndef MCFDETECTOR
#define MCFDETECTOR
#include "McFDetDevice.hh"
#include <string.h>

//this class will interface to the McFast geometry common blocks 
//leave everything as public since they will be set after construction and
//set/methods seem like needless overhead. 

//eventually anticipate methods that print out the detector parameters 
// and provides some reality checking of the devices.
class McFDetector
{
    public:
       
       McFDetDevice deviceId;  //corresponds to internal device number
       int whichOne;           //which specific device
       char name[100];         //it's name.
       McFDetector(void)
       {
            deviceId = NODEVICE;
            whichOne = 0;
       }
       
};
#endif
