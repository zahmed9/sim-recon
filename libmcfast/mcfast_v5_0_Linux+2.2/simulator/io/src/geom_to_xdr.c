#include "mcfastXDRinc.h"

#define MCFIO_GEOMETRY 880

void mcfast_xdr_all(XDR* xdrs);

bool_t geom_to_xdr(XDR *xdrs, int *blockid, int *ntot, char** version);

/* extern "C" { */
bool_t geom_to_xdr_(XDR *xdrs, int *blockid, int *ntot, char** version)
{
    bool_t iret;
    int number = 1;

    if (xdrs->x_op == XDR_ENCODE) { 
        fprintf (stdout, "geom_to_xdr: Writing geometry to McFio output\n ");
        if (*blockid != MCFIO_GEOMETRY) {
            fprintf (stderr, "geom_to_xdr: Inconsistent Blockid %d on encode\n ", 
                     (*blockid));
            return FALSE;
        }
        *ntot = 1000; /* who knows */
        strcpy(*version, dbin_mcfast_dbvsn); /* DB version from db file */
    } else {
        fprintf (stdout, "geom_to_xdr: Reading geometry from McFio input\n ");
    } 
    iret =  ( xdr_int(xdrs, blockid) &&
     	      xdr_int(xdrs, ntot) &&
     	      xdr_string(xdrs, version, MCF_XDR_VERSION_LENGTH) &&
     	      xdr_int(xdrs, &number));
    if (!iret) {
        fprintf(stderr,"geom_to_xdr: Header write failure. Err = %d\n",iret);
        return iret;
    }
    
    if (xdrs->x_op == XDR_DECODE) {
        if ( *blockid != MCFIO_GEOMETRY) {
            fprintf (stderr, "geom_to_xdr: Inconsistent Blockid %d on decode\n ", 
                     (*blockid));
            return FALSE;
        }
        if (strncmp(*version, dbin_mcfast_dbvsn, 4) != 0) {
            fprintf (stderr, 
               "geom_to_xdr: WARNING: DB version mismatch. File: \"%s\"  DB: \"%s\"\n ", 
               *version, dbin_mcfast_dbvsn);
        }
    }

    mcfast_xdr_all(xdrs);         /*  Database I/O */
}

bool_t GEOM_TO_XDR(XDR *xdrs, int *blockid, int *ntot, char** version)
    {
        return geom_to_xdr_(xdrs, blockid, ntot, version);
    }

/* }  extern "C" */

bool_t geom_to_xdr(XDR *xdrs, int *blockid, int *ntot, char** version)
{
    return geom_to_xdr_(xdrs, blockid, ntot, version);
}

