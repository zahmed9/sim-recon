#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <clas_cern.h>
#define MAXHISTO 100000




void hlimit(int size)
{
  hlimit_(&size);
}


void hrput(int id, char *file, char *opt)
{
  hrput_(&id,file,opt,strlen(file),strlen(opt));
}


void hf1(int id, float data, float weight)
{
  hf1_(&id,&data,&weight);
}


void hf2(int id,float data1,float data2,float weight)
{
  hf2_(&id,&data1,&data2,&weight);
}

void hdelet(int id)
{
	hdelet_(&id);
}

void hrin( int id, int icycle , int iofset )
{
        hrin_( &id, &icycle, &iofset);
}

void hfn(int id, float data[])
{
  hfn_(&id,&data[0]); 
}

void hfithn(int id, char *chfun, char *chopt, int np, float par[],
        float step[], float pmin[], float pmax[], float sigpar[], float *chi2)
{
  hfithn_(&id, chfun, chopt, &np, par, step, pmin, pmax, sigpar, chi2,
	  strlen(chfun), strlen(chopt));

}

void hunpak(int histo,float contents[],char choice[], int num)
{
  hunpak_(&histo,contents,choice,&num,strlen(choice));
}

void hidopt( int id, char *chopt)
{
        hidopt_( &id, chopt ,  strlen( chopt));
}

void hpak(int histo,float contents[])
{
  hpak_(&histo,contents);
}

void hrget( int id, char *chfile, char *chopt)
{
  hrget_( &id, chfile, chopt, strlen(chfile), strlen(chopt));
}

void hldir(char dir[],char flag[])
{
  hldir_(dir,flag,strlen(dir),strlen(flag));
}

void hmdir(char dir[],char flag[])
{
  hmdir_(dir,flag,strlen(dir),strlen(flag));
}

void hcdir(char dir[],char flag[])
{
  hcdir_(dir,flag,strlen(dir),strlen(flag));
}

/*
void hplzon(int x, int y, int num, char *opt)
{
  hplzon_(&x, &y, &num, opt, strlen(opt));
}

void hplcon(int histonum, int x, int y)
{
  hplcon_(&histonum, &x, &y);
}
*/

void hropen(int lun, char *name, char*filename, char*status, int stor,
        int istat)
{
        hropen_(&lun, name, filename, status, &stor, &istat, strlen(name),
                strlen(filename), strlen(status));
        /*warning the value of istat will be lost*/
        return;
}

void hrout(int num, int icycle, char*opt)
{
        hrout_(&num, &icycle, opt, strlen(opt));
        return;
}

void hrend(char*filename)
{
        hrend_(filename, strlen(filename));
        return;
}


void hreset(int no, char* opt)
{
        hreset_(&no, opt, strlen(opt));
        return;
}

void hbook2(int no, char*name, int xbins, float xmin, float xmax, int ybins,
                 float ymin, float ymax, float weight)
{
  hbook2_(&no, name, &xbins, &xmin, &xmax, &ybins,&ymin, &ymax, &weight, strlen(name));
}


void hbook1(int no, char*name, int nbins, float min, float max, float v)
{
  hbook1_(&no, name, &nbins, &min, &max, &v, strlen(name));
}

void hfill(int no, float xvalue, float yvalue, float weight)
{
        hfill_(&no, &xvalue, &yvalue, &weight);
}




