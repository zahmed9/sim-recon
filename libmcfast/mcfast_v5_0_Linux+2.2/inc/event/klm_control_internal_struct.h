#ifndef KLM_CONTROL_INTERNAL_STRUCT_H
#define KLM_CONTROL_INTERNAL_STRUCT_H

/*

   Rob Kutschke, Oct. 22, 1998.

   Variables which control the operation of the Kalman filter.

   These variables are not public and are for internal use only.

 */

typedef struct Klm_control_internal_s *klm_control_internal_ptr;

typedef struct Klm_control_internal_s  {
    int pass;                          /* Pass 1 or 2 of a multi-pass fit. */
    int direction;                     /* Direction of fit this pass.      */
} klm_control_internal_s;

#endif
