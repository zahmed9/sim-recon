#ifndef KLM_CONTROL_STRUCT_H
#define KLM_CONTROL_STRUCT_H

/*

   Rob Kutschke, Oct. 22, 1998.

   Variables which control the operation of the Kalman filter.

 */

/* Legal values of the direction control flag. */
enum klm_dir {INWARDS, OUTWARDS, IN_THEN_OUT, OUT_THEN_IN};

typedef struct Klm_control_s *klm_control_ptr;

typedef struct Klm_control_s  {
    Kptr Kp_start_in;       /* Starting point for inward fit.             */
    Kptr Kp_stop_out;       /* Stopping point for inward fit.             */
    Kptr Kp_start_out;      /* Starting point for outward fit.            */
    Kptr Kp_stop_in;        /* Starting point for outward fit.            */
    int num_nodes;          /* Number of nodes in the fit.                */
    int nhit;               /* Number of hits in the fit.                 */
    enum klm_dir direction; /* Direction of fit.                          */
    int smooth;             /* Enable smoothing.                          */
    int residuals;          /* Compute residuals.                         */
    int dedx;               /* Enable energy loss in material.            */
    int scat;               /* Enable multiple scattering in material.    */
    int hit_in_fit;         /* Compute saved track parameters with local
                               hit included in the in the fit, or not.    */
    int fresh_start;        /* Initialize covariance matrix, chisq,
                               and hit count or add to input values.      */
    int hep;                /* Copy of hep track number, for debugging.   */
} klm_control_s;

#endif
