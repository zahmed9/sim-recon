#include <iostream.h>
#include <Vec.h>

#include <drift.h>

/* function prototypes */

void Process();

/*---------------end of function prototypes ---------------------------*/

main(int argc,char **argv)
{
  
  Process();

}

void Process()
{

  driftChamber DC[100];
  int idc = 0;
  float rx,ry,rz,nx,ny,nz,cx,cy,cz,r,dnorm,spacing;

  while (cin >> rx >> ry >> rz >> nx >> ny >> nz >> cx >> cy >> cz >> r >> dnorm >> spacing) {
    DC[idc++].set(threeVec(rx,ry,rz),threeVec(nx,ny,nz),threeVec(cx,cy,cz),r,dnorm,spacing);
  }

}


    
