/*
 * hitStart - registers hits for Start counter
 *
 *	This is a part of the hits package for the
 *	HDGeant simulation program for Hall D.
 *
 *	version 1.0 	-Richard Jones July 16, 2001
 *
 * Programmer's Notes:
 * -------------------
 * 1) In applying the attenuation to light propagating down to the end
 *    of the counters, there has to be some point where the attenuation
 *    factor is 1.  I chose it to be the midplane, so that in the middle
 *    of the counters the attenuation factor is 1.
 * 2) In applying the propagation delay to light propagating down to the
 *    end of the counters, there has to be some point where the timing
 *    offset is 0.  I chose it to be the midplane, so that for hits in
 *    the middle of the counter the t values measure time-of-flight from
 *    the t=0 of the event.
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include <hddm_s.h>
#include <geant3.h>
#include <bintree.h>

#define ATTEN_LENGTH	150.
#define C_EFFECTIVE	15.
#define TWO_HIT_RESOL	25.
#define MAX_HITS 	100
#define THRESH_MEV      0.150

binTree_t* startCntrTree = 0;
static int paddleCount = 0;
static int pointCount = 0;


/* register hits during tracking (from gustep) */

void hitStartCntr (float xin[4], float xout[4],
                   float pin[5], float pout[5], float dEsum,
                   int track, int stack, int history)
{
   float x[3], t;
   float dx[3], dr;
   float dEdx;
   float xlocal[3];
   float xvrtx[3];

   x[0] = (xin[0] + xout[0])/2;
   x[1] = (xin[1] + xout[1])/2;
   x[2] = (xin[2] + xout[2])/2;
   t    = (xin[3] + xout[3])/2 * 1e9;
   transformCoord(x,"global",xlocal,"local");
   dx[0] = xin[0] - xout[0];
   dx[1] = xin[1] - xout[1];
   dx[2] = xin[2] - xout[2];
   dr = sqrt(dx[0]*dx[0] + dx[1]*dx[1] + dx[2]*dx[2]);
   if (dr > 1e-3)
   {
      dEdx = dEsum/dr;
   }
   else
   {
      dEdx = 0;
   }

   /* post the hit to the truth tree */

   if (history == 0)
   {
      int mark = (1<<30) + pointCount;
      void** twig = getTwig(&startCntrTree, mark);
      if (*twig == 0)
      {
         s_StartCntr_t* stc = *twig = make_s_StartCntr();
         s_StcTruthPoints_t* points = make_s_StcTruthPoints(1);
         stc->stcTruthPoints = points;
         points->in[0].primary = (stack == 0);
         points->in[0].track = track;
         points->in[0].t = t;
         points->in[0].z = x[2];
         points->in[0].r = sqrt(x[0]*x[0]+x[1]*x[1]);
         points->in[0].phi = atan2(x[1],x[0]);
         points->in[0].dEdx = dEdx;
         points->mult = 1;
         pointCount++;
      }
   }

   /* post the hit to the hits tree, mark sector as hit */

   if (dEsum > 0)
   {
      int nhit;
      s_StcHits_t* hits;
      int sector = getsector_();
      float phim = atan2(xvrtx[1],xvrtx[0]);
      float dpath = xlocal[2]+(10.2-xlocal[0])*0.4;
      float tcorr = t + dpath/C_EFFECTIVE;
      float dEcorr = dEsum * exp(-dpath/ATTEN_LENGTH);
      int mark = sector;
      void** twig = getTwig(&startCntrTree, mark);
      if (*twig == 0)
      {
         s_StartCntr_t* stc = *twig = make_s_StartCntr();
         s_StcPaddles_t* paddles = make_s_StcPaddles(1);
         paddles->mult = 1;
         paddles->in[0].sector = sector;
         paddles->in[0].stcHits = hits = make_s_StcHits(MAX_HITS);
         stc->stcPaddles = paddles;
         paddleCount++;
      }
      else
      {
         s_StartCntr_t* stc = *twig;
         hits = stc->stcPaddles->in[0].stcHits;
      }

      for (nhit = 0; nhit < hits->mult; nhit++)
      {
         if (fabs(hits->in[nhit].t - tcorr) < TWO_HIT_RESOL)
         {
            break;
         }
      }
      if (nhit < hits->mult)		/* merge with former hit */
      {
         hits->in[nhit].t = 
                      (hits->in[nhit].t * hits->in[nhit].dE + tcorr * dEcorr)
                    / (hits->in[nhit].dE += dEcorr);
      }
      else if (nhit < MAX_HITS)		/* create new hit */
      {
         hits->in[nhit].t = tcorr ;
         hits->in[nhit].dE = dEcorr;
         hits->mult++;
      }
      else
      {
         fprintf(stderr,"HDGeant error in hitStart: ");
         fprintf(stderr,"max hit count %d exceeded, truncating!\n",MAX_HITS);
         exit(2);
      }
   }
}

/* entry point from fortran */

void hitstartcntr_(float* xin, float* xout,
                   float* pin, float* pout, float* dEsum,
                   int* track, int* stack, int* history)
{
   hitStartCntr(xin,xout,pin,pout,*dEsum,*track,*stack,*history);
}


/* pick and package the hits for shipping */

s_StartCntr_t* pickStartCntr ()
{
   s_StartCntr_t* box;
   s_StartCntr_t* item;

   if ((paddleCount == 0) && (pointCount == 0))
   {
      return HDDM_NULL;
   }

   box = make_s_StartCntr();
   box->stcPaddles = make_s_StcPaddles(paddleCount);
   box->stcTruthPoints = make_s_StcTruthPoints(pointCount);
   while (item = (s_StartCntr_t*) pickTwig(&startCntrTree))
   {
      s_StcPaddles_t* paddles = item->stcPaddles;
      int paddle;
      s_StcTruthPoints_t* points = item->stcTruthPoints;
      int point;

      for (paddle=0; paddle < paddles->mult; ++paddle)
      {
         int m = box->stcPaddles->mult;

         s_StcHits_t* hits = paddles->in[paddle].stcHits;

         /* compress out the hits below threshold */
         int i,iok;
         for (iok=i=0; i < hits->mult; i++)
         {
            if (hits->in[i].dE >= THRESH_MEV/1e3)
            {
               if (iok < i)
               {
                  hits->in[iok] = hits->in[i];
               }
               ++iok;
            }
         }
         if (iok)
         {
            hits->mult = iok;
            box->stcPaddles->in[m] = paddles->in[paddle];
            box->stcPaddles->mult++;
         }
         else if (hits != HDDM_NULL)
         {
            FREE(hits);
         }
      }
      if (paddles != HDDM_NULL)
      {
         FREE(paddles);
      }

      for (point=0; point < points->mult; ++point)
      {
         int m = box->stcTruthPoints->mult++;
         box->stcTruthPoints->in[m] = item->stcTruthPoints->in[point];
      }
      if (points != HDDM_NULL)
      {
         FREE(points);
      }
      FREE(item);
   }

   paddleCount = pointCount = 0;

   if ((box->stcPaddles != HDDM_NULL) &&
       (box->stcPaddles->mult == 0))
   {
      FREE(box->stcPaddles);
      box->stcPaddles = HDDM_NULL;
   }
   if ((box->stcTruthPoints != HDDM_NULL) &&
       (box->stcTruthPoints->mult == 0))
   {
      FREE(box->stcTruthPoints);
      box->stcTruthPoints = HDDM_NULL;
   }
   if ((box->stcPaddles->mult == 0) &&
       (box->stcTruthPoints->mult == 0))
   {
      FREE(box);
      box = HDDM_NULL;
   }
   return box;
}
