#include "mcfast_db.h"
#include <stdio.h>

void getmat(char* name, int* indx);

void prgeom(FILE* fl);
void prgeom_(FILE* fl);

void prgeom_(FILE* fl)
{
    prgeom(stdout);
}

void prgeom(FILE* fl)
{
    int i, j, indx;
    fprintf(fl,"Geometry Info\n");
    fprintf(fl,"Detector %s, Type %s\n", detector[0].name,
            detector[0].geom_id);
    fprintf(fl,"Materials:    %3d declared.\n",*n_obj_material);
    for (i=0;i<*n_obj_material;i++) {
        fprintf(fl,"  %-10s a=%-7.5G z=%-7.5G dens=%-7.5G\n",material[i].name,
                material[i].a,material[i].z,material[i].density);
    }
    fprintf(fl,"Mixtures:     %3d declared.\n",*n_obj_mixture);
    for (i=0;i<*n_obj_mixture;i++) {
        fprintf(fl,"  %-10s Nmat=%-5d",mixture[i].name,
                mixture[i].nmat);
        for (j=0;j<mixture[i].nmat;j++) {
            getmat(mixture[i].matnames[j],&indx);
            fprintf(fl," %8s (%G)",material[indx].name,mixture[i].prop[j]);
        }
        fprintf(fl,"\n");
    }
    fprintf(fl,"Beam pipe:    %3d declared.\n",*n_obj_bpipe);
    for (i=0;i<*n_obj_bpipe;i++) {
        fprintf(fl,"  %-6s r=%5.3G,%-5.3G  z0=%5.3G  zlen=%5.3G\n",
                bpipe[i].name,bpipe[i].rmin,bpipe[i].rmax,bpipe[i].z0,
                bpipe[i].zlen);
    }
    fprintf(fl,"Absorber:     %3d declared.\n",*n_obj_absorber);
    for (i=0;i<*n_obj_absorber;i++) {
      fprintf(fl,"  %-6s %s Mat=%s rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      absorber[i].name,absorber[i].shape,absorber[i].material,
      absorber[i].rmin[0],absorber[i].rmax[0],
      absorber[i].rmin[1],absorber[i].rmax[1],
      absorber[i].z0,absorber[i].zlen);
    }
    fprintf(fl,"Dipole:       %3d declared.\n",*n_obj_dipole);
    for (i=0;i<*n_obj_dipole;i++) {
      fprintf(fl,"  %-6s Mat=%s B=%5.3G x=%5.3G,%-5.3G y=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      dipole[i].name,dipole[i].mat_fill,dipole[i].bfield,
      dipole[i].xmin,dipole[i].xmax,
      dipole[i].ymin,dipole[i].ymax,
      dipole[i].z0,dipole[i].zlen);
    }
    fprintf(fl,"Solenoid:     %3d declared.\n",*n_obj_solenoid);
    for (i=0;i<*n_obj_solenoid;i++) {
        fprintf(fl,"  %-6s Mat=%s r=%5.3G,%-5.3G  z0=%5.3G  zlen=%5.3G\n",
                solenoid[i].name,solenoid[i].mat_fill,
                solenoid[i].rmin,solenoid[i].rmax,solenoid[i].z0,solenoid[i].zlen);
        fprintf(fl,"     rlo \"%s\" rhi \"%s\" zlo \"%s\" zhi \"%s\"\n",
                solenoid[i].mat_boun[0],solenoid[i].mat_boun[1],solenoid[i].mat_boun[2],
                solenoid[i].mat_boun[3]);
    }
    fprintf(fl,"Drift cham:   %3d declared.\n",*n_obj_drift);
    if (*n_obj_drift>0) {
      for (i=0;i<*n_obj_drift;i++) {
        fprintf(fl,"  %-6s Mat=%s Nano,cath=%d,%-d r=%5.3G,%-5.3G  z0=%5.3G  zlen=%5.3G\n",
                drift[i].name,drift[i].material,
                drift[i].num_anode,drift[i].num_cathode,
                drift[i].rmin,drift[i].rmax,drift[i].z0,drift[i].zlen);
      }
      fprintf(fl,"    Total anodes:         %3d declared.\n",*n_obj_layerdrfano);
      fprintf(fl,"    Total anode offsets:  %3d declared.\n",*n_obj_offsetdrfano);
      fprintf(fl,"    Total cathodes:       %3d declared.\n",*n_obj_layerdrfcatho);
    }
    fprintf(fl,"Si barrel:    %3d declared.\n",*n_obj_sibarrel);
    if (*n_obj_sibarrel>0) {
      for (i=0;i<*n_obj_sibarrel;i++) {
        fprintf(fl,"  %-6s Nlay=%d z0=%G\n",sibarrel[i].name,sibarrel[i].nlyr,
           sibarrel[i].z0_global);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersib);
      fprintf(fl,"    Total wafers:         %3d declared.\n",*n_obj_wafer);
    }
    fprintf(fl,"Si disks:     %3d declared.\n",*n_obj_sidisk);
    if (*n_obj_sidisk>0) {
      for (i=0;i<*n_obj_sidisk;i++) {
        fprintf(fl,"  %-6s Nlay=%d z0=%G\n",sidisk[i].name,sidisk[i].nlyr,
           sidisk[i].zpos);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersidi);
      fprintf(fl,"    Total wedges:         %3d declared.\n",*n_obj_wedge);
    }
    fprintf(fl,"Si XY:        %3d declared.\n",*n_obj_sixy);
    if (*n_obj_sixy>0) {
      for (i=0;i<*n_obj_sixy;i++) {
        fprintf(fl,"  %-6s Nlay=%d z0=%G\n",sixy[i].name,sixy[i].nly,
           sixy[i].zpos);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layersixy);
    }
    fprintf(fl,"Forw tracker: %3d declared.\n",*n_obj_ftrk);
    if (*n_obj_ftrk>0) {
      for (i=0;i<*n_obj_ftrk;i++) {
        fprintf(fl,"  %-6s Mat=%s Nly=%d x=%5.3G,%-5.3G y=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
        ftrk[i].name,ftrk[i].mat_fill,ftrk[i].nlyr,
        ftrk[i].xmin,ftrk[i].xmax,
        ftrk[i].ymin,ftrk[i].ymax,
        ftrk[i].z0,ftrk[i].zlen);
      }
      fprintf(fl,"    Total layers:         %3d declared.\n",*n_obj_layerftrk);
    }
    fprintf(fl,"EM cal:       %3d declared.\n",*n_obj_emcal);
    for (i=0;i<*n_obj_emcal;i++) {
      fprintf(fl,"  %-6s %s Mat=%s Np,e=%3d,%-3d rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      emcal[i].name,emcal[i].shape,emcal[i].material,
      emcal[i].nphi,emcal[i].neta,
      emcal[i].rmin[0],emcal[i].rmax[0],
      emcal[i].rmin[1],emcal[i].rmax[1],
      emcal[i].z0,emcal[i].zlen);
    }
    fprintf(fl,"Had cal:      %3d declared.\n",*n_obj_hadcal);
    for (i=0;i<*n_obj_hadcal;i++) {
      fprintf(fl,"  %-6s %s Mat=%s Np,e=%3d,%-3d rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      hadcal[i].name,hadcal[i].shape,hadcal[i].material,
      hadcal[i].nphi,hadcal[i].neta,
      hadcal[i].rmin[0],hadcal[i].rmax[0],
      hadcal[i].rmin[1],hadcal[i].rmax[1],
      hadcal[i].z0,hadcal[i].zlen);
    }
    fprintf(fl,"Muon:         %3d declared.\n",*n_obj_muon);
    for (i=0;i<*n_obj_muon;i++) {
      fprintf(fl,"  %-6s %s Mat=%s rlo=%5.3G,%-5.3G rhi=%5.3G,%-5.3G z0=%5.3G zlen=%5.3G\n",
      muon[i].name,muon[i].shape,muon[i].material,
      muon[i].rmin[0],muon[i].rmax[0],
      muon[i].rmin[1],muon[i].rmax[1],
      muon[i].z0,muon[i].zlen);
    }
}
