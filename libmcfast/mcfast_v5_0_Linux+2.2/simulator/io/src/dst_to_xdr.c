#include "mcfdatXDRinc.h"

#define MCFIO_DST 881

void mcfdat_xdr_all(XDR* xdrs);

bool_t dst_to_xdr(XDR *xdrs, int *blockid, int *ntot, char** version);

/* extern "C" { */
bool_t dst_to_xdr_(XDR *xdrs, int *blockid, int *ntot, char** version)
{
    bool_t iret;
    int number = 1;

    if (xdrs->x_op == XDR_ENCODE) { 
        if (*blockid != MCFIO_DST) {
          fprintf (stderr, "dst_to_xdr: Inconsistent Blockid %d on encode\n ", 
                     (*blockid));
          return FALSE;
        }
        *ntot = 1000; /* who knows */
        strcpy(*version, dbin_mcfdat_dbvsn); /* DB version from db file */
    } 
    iret =  ( xdr_int(xdrs, blockid) &&
     	      xdr_int(xdrs, ntot) &&
     	      xdr_string(xdrs, version, MCF_XDR_VERSION_LENGTH) &&
     	      xdr_int(xdrs, &number));
    if (!iret) {
        fprintf(stderr,"dst_to_xdr: Header write failure. Err = %d\n",iret);
        return iret;
    }
    
    if (xdrs->x_op == XDR_DECODE) {
        if ( *blockid != MCFIO_DST) {
          fprintf (stderr, "dst_to_xdr: Inconsistent Blockid %d on decode\n ", 
                   (*blockid));
          return FALSE;
        }
        if (strncmp(*version, dbin_mcfdat_dbvsn, 4) != 0) {
          fprintf (stderr, 
            "dst_to_xdr: WARNING: DB version mismatch. File: \"%s\"  DB: \"%s\"\n ", 
             *version, dbin_mcfdat_dbvsn,strncmp(*version, dbin_mcfdat_dbvsn, 4));
        }
    }

    mcfdat_xdr_all(xdrs);         /*  Data structure I/O */
}

bool_t DST_TO_XDR(XDR *xdrs, int *blockid, int *ntot, char** version)
    {
        return dst_to_xdr_(xdrs, blockid, ntot, version);
    }

/* }  extern "C" */

bool_t dst_to_xdr(XDR *xdrs, int *blockid, int *ntot, char** version)
{
    return dst_to_xdr_(xdrs, blockid, ntot, version);
}
