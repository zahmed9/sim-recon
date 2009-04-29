/*
 *  hdds-root_h :   this is a copy of hdds-root modified to generate a header file
 *                  for the DRootGeom class
 *  
 *  Original Verions: B. Zihlmann Sun Feb 15 12:48:59 EST 2009
 *  Based on hdds-root by Edward Bras, November 1 2003.
 *  Based on hdds-geant by Richard Jones, May 19 2001.
 *
 *  Notes:
 *  ------
 * 1. Output is sent to standard out through the ordinary c++ i/o library.
 * 2. As a by-product of using the DOM parser to access the xml source,
 *    hdds-geant verifies the source against the schema before translating it.
 *    Therefore it may also be used as a validator of the xml specification
 *    (see the -v option).
 */

#define APP_NAME "hdds-root"

#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/XMLString.hpp>
#include <xercesc/util/XMLStringTokenizer.hpp>
#include <xercesc/sax/SAXParseException.hpp>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/framework/LocalFileFormatTarget.hpp>
#include <xercesc/dom/DOM.hpp>
#include <xercesc/util/XercesDefs.hpp>
#include <xercesc/sax/ErrorHandler.hpp>

using namespace xercesc;

#include "XString.hpp"
#include "XParsers.hpp"
#include "hddsCommon.hpp"

#include <assert.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <iomanip>
#include <vector>
#include <list>

#define X(str) XString(str).unicode_str()
#define S(str) str.c_str()

int first_volume_placement = 0;

void usage()
{
    std::cerr
         << "Usage:    " << APP_NAME << " [-v] {HDDS file}"
         << std::endl <<  "Options:" << std::endl
         << "    -v   validate only" << std::endl;
}

class RootMacroWriter : public CodeWriter
{
 public:
   RootMacroWriter() {};
   void createHeader();
   void createTrailer();
   int createMaterial(DOMElement* el);  // generate code for materials
   int createSolid(DOMElement* el,
                   Refsys& ref);    	// generate code for solids
   int createRotation(Refsys& ref);     // generate code for rotations
   int createVolume(DOMElement* el,
                    Refsys& ref);   	// generate code for placement
   int createDivision(XString& divStr,
                      Refsys& ref);	// generate code for divisions
   void createGetFunctions(DOMElement* el,
                     XString& ident);   // generate code for identifiers
};


int main(int argC, char* argV[])
{
   try
   {
      XMLPlatformUtils::Initialize();
   }
   catch (const XMLException& toCatch)
   {
      XString message(toCatch.getMessage());
      std::cerr
           << APP_NAME << " - error during initialization!"
           << std::endl << S(message) << std::endl;
      return 1;
   }

   if (argC < 2)
   {
      usage();
      return 1;
   }
   else if ((argC == 2) && (strcmp(argV[1], "-?") == 0))
   {
      usage();
      return 2;
   }

   XString xmlFile;
   bool rootMacroOutput = true;
   int argInd;
   for (argInd = 1; argInd < argC; argInd++)
   {
      if (argV[argInd][0] != '-')
         break;

      if (strcmp(argV[argInd], "-v") == 0)
         rootMacroOutput = false;
      else
         std::cerr
              << "Unknown option \'" << argV[argInd]
              << "\', ignoring it\n" << std::endl;
   }

   if (argInd != argC - 1)
   {
      usage();
      return 1;
   }
   xmlFile = argV[argInd];

#if defined OLD_STYLE_XERCES_PARSER
   DOMDocument* document = parseInputDocument(xmlFile,false);
#else
   DOMDocument* document = buildDOMDocument(xmlFile,false);
#endif
   if (document == 0)
   {
      std::cerr
           << APP_NAME << " - error parsing HDDS document, "
           << "cannot continue" << std::endl;
      return 1;
   }

   DOMNode* docEl;
   try {
      docEl = document->getDocumentElement();
   }
   catch (DOMException& e) {
      std::cerr << "Woops " << e.msg << std::endl;
      return 1;
   }

   DOMElement* rootEl = document->getElementById(X("everything"));
   if (rootEl == 0)
   {
      std::cerr
           << APP_NAME << " - error scanning HDDS document, " << std::endl
           << "  no element named \"everything\" found" << std::endl;
      return 1;
   }

   if (rootMacroOutput)
   {
      RootMacroWriter fout;
      fout.translate(rootEl);
   }

   XMLPlatformUtils::Terminate();
   return 0;
}

struct goo	// utility class for RootMacroWriter::createMaterial()
{
   double weight;
   Substance* sub;
};

int RootMacroWriter::createMaterial(DOMElement* el)
{
   int imate = CodeWriter::createMaterial(el);

   double a = fSubst.getAtomicWeight();
   double z = fSubst.getAtomicNumber();
   double dens = fSubst.getDensity();
   double radl = fSubst.getRadLength();
   double absl = fSubst.getAbsLength();
   double coll = fSubst.getColLength();
   double dedx = fSubst.getMIdEdx();
   XString matS = fSubst.getName();

   if (fSubst.fBrewList.size() == 0)
   {
      std::cout
           << "TGeoMaterial *mat" << imate 
           << "= new TGeoMaterial(\"" << S(matS) 
           << "\"," << a << "," << z << "," << dens << ");"
           << std::endl
           << "mat" << imate << "->SetUniqueID(" << imate << ");"
           << std::endl;
      if (dens > 0 && radl > 0)
      {
         std::cout
              << "mat" << imate 
              << "->SetRadLen(" << radl << "," << coll << ");"
              << std::endl;
      }
   }
   else
   {
      std::stringstream sout;
      struct goo gunk;
      gunk.weight = 1;
      gunk.sub = &fSubst;
      std::list<struct goo> gooStack;
      gooStack.push_back(gunk);
      int nelem = 0;
      while (gooStack.size() > 0)
      {
         gunk  = gooStack.front();
         gooStack.pop_front();
         if (gunk.sub->fBrewList.size() == 0)
         {
            sout << "mat" << imate 
                 << "->DefineElement(" << nelem++ << ","
                 << gunk.sub->getAtomicWeight() << ","
                 << gunk.sub->getAtomicNumber() << ","
                 << gunk.weight << ");" << std::endl;
         }
         else
         {
            std::list<Substance::Brew>::iterator iter;
            for (iter = gunk.sub->fBrewList.begin();
                 iter != gunk.sub->fBrewList.end();
                 ++iter)
            {
               struct goo slime;
               slime.weight = gunk.weight * iter->wfact;
               slime.sub = iter->sub;
               gooStack.push_back(slime);
            }
         }
      }
      std::cout
           << "TGeoMixture *mat" << imate 
           << "= new TGeoMixture(\"" << S(matS) 
           << "\"," << nelem << "," << dens << ");"
           << std::endl
           << "mat" << imate << "->SetUniqueID(" << imate << ");"
           << std::endl
           << sout.str();
   }
   return imate;
}

int RootMacroWriter::createSolid(DOMElement* el, Refsys& ref)
{
   int ivolu = CodeWriter::createSolid(el,ref);
   int imate = fSubst.fUniqueID;
   int iregion = ref.fRegionID;

   int ifield = 0;	// default values for tracking properties
   double fieldm = 0;	// are overridden by values specified in region tag
   double tmaxfd = 0;
   double stemax = -1;
   double deemax = -1;
   XString epsil = "0.001";
   double stmin = -1;
   if (ref.fRegion)
   {
      DOMNodeList* noBfieldL = ref.fRegion->getElementsByTagName(X("noBfield"));
      DOMNodeList* uniBfieldL = ref.fRegion->getElementsByTagName(X("uniformBfield"));
      DOMNodeList* mapBfieldL = ref.fRegion->getElementsByTagName(X("mappedBfield"));
      DOMNodeList* swimL = ref.fRegion->getElementsByTagName(X("swim"));
      if (noBfieldL->getLength() > 0)
      {
         ifield = 0;
         fieldm = 0;
      }
      else if (uniBfieldL->getLength() > 0)
      {
         DOMElement* uniBfieldEl = (DOMElement*)uniBfieldL->item(0);
         XString bvecS(uniBfieldEl->getAttribute(X("Bx_By_Bz")));
         std::stringstream str(S(bvecS));
         double B[3];
         str >> B[0] >> B[1] >> B[2];
         fieldm = sqrt(B[0]*B[0] + B[1]*B[1] + B[2]*B[2]);
         ifield = 2;
         tmaxfd = 1;
      }
      else if (mapBfieldL->getLength() > 0)
      {
         DOMElement* mapBfieldEl = (DOMElement*)mapBfieldL->item(0);
         XString bmaxS(mapBfieldEl->getAttribute(X("maxBfield")));
         fieldm = atof(S(bmaxS));
         ifield = 2;
         tmaxfd = 1;
         if (swimL->getLength() > 0)
         {
            DOMElement* swimEl = (DOMElement*)swimL->item(0);
            XString methodS(swimEl->getAttribute(X("method")));
            ifield = (methodS == "RungeKutta")? 1 : 2;
         }
      }
   }

   static int itmedCount = 0;
   int itmed = ++itmedCount;
   XString nameS(el->getAttribute(X("name")));
   XString matS(el->getAttribute(X("material")));
   XString sensiS(el->getAttribute(X("sensitive")));
   std::cout
        << "TGeoMedium *med" << itmed 
        << " = new TGeoMedium(\"" << S(nameS)
        << " " << S(matS) << "\"," << itmed << "," << imate << ","
        << (sensiS == "true" ? 1 : 0) << "," 
        << ifield << "," << fieldm << "," << tmaxfd << ","
        << stemax << "," << deemax << "," << epsil << "," << stmin << ");"
        << std::endl;

   Units unit;
   unit.getConversions(el);

   double par[99];
   int npar = 0;
   XString shapeS(el->getTagName());
   if (shapeS == "box")
   {
      shapeS = "BOX ";
      double xl, yl, zl;
      XString xyzS(el->getAttribute(X("X_Y_Z")));
      std::stringstream listr(xyzS);
      listr >> xl >> yl >> zl;

      npar = 3;
      par[0] = xl/2 * unit.cm;
      par[1] = yl/2 * unit.cm;
      par[2] = zl/2 * unit.cm;

      std::cout 
           << "TGeoVolume *" << S(nameS) 
           << "= gGeoManager->MakeBox(\"" << S(nameS) << "\",med"
           << itmed << "," << par[0] << "," << par[1] << ","
           << par[2] << ");" << std::endl;
   }
   else if (shapeS == "eltu")
   {
      shapeS = "ELTU";
      double ri, ro, zl, phi0, dphi;
      XString riozS(el->getAttribute(X("Rio_Z")));
      std::stringstream listr(riozS);
      listr >> ri >> ro >> zl;

      npar = 3;
      par[0] = ri * unit.cm;
      par[1] = ro * unit.cm;
      par[2] = zl/2 * unit.cm;

      std::cout
           << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakeEltu(\"" 
           << S(nameS) << "\",med" << itmed << "," 
           << par[0] << "," << par[1] << "," << par[2] << ");"
           << std::endl;

   }
   else if (shapeS == "tubs")
   {
      shapeS = "TUBS";
      double ri, ro, zl, phi0, dphi;
      XString riozS(el->getAttribute(X("Rio_Z")));
      std::stringstream listr(riozS);
      listr >> ri >> ro >> zl;
      XString profS(el->getAttribute(X("profile")));
      listr.clear(), listr.str(profS);
      listr >> phi0 >> dphi;

      npar = 5;
      par[0] = ri * unit.cm;
      par[1] = ro * unit.cm;
      par[2] = zl/2 * unit.cm;
      par[3] = phi0 * unit.deg;
      par[4] = (phi0 + dphi) * unit.deg;
      if (dphi*unit.deg == 360)
      {
         shapeS = "TUBE";
         npar = 3;
          
         std::cout
              << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakeTube(\"" 
              << S(nameS) << "\",med" << itmed << "," 
              << par[0] << "," << par[1] << "," << par[2] << ");"
              << std::endl;
      }
      else
      {
         std::cout
              << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakeTubs(\""
              << S(nameS) << "\",med" << itmed << "," << par[0] << ","
              << par[1] << "," << par[2] << "," << par[3] << "," << par[4]
              << ");" << std::endl;
      }
   }
   else if (shapeS == "trd")
   {
      shapeS = "TRAP";
      double xm, ym, xp, yp, zl;
      XString xyzS(el->getAttribute(X("Xmp_Ymp_Z")));
      std::stringstream listr(xyzS);
      listr >> xm >> xp >> ym >> yp >> zl;
      double alph_xz, alph_yz;
      XString incS(el->getAttribute(X("inclination")));
      listr.clear(), listr.str(incS);
      listr >> alph_xz >> alph_yz;

      npar = 11;
      double x = tan(alph_xz * unit.rad);
      double y = tan(alph_yz * unit.rad);
      double r = sqrt(x*x + y*y);
      par[0] = zl/2 * unit.cm;
      par[1] = atan2(r,1) * unit.deg/unit.rad;
      par[2] = atan2(y,x) * unit.deg/unit.rad;
      par[3] = ym/2 * unit.cm;
      par[4] = xm/2 * unit.cm;
      par[5] = xm/2 * unit.cm;
      par[6] = 0;
      par[7] = yp/2 * unit.cm;
      par[8] = xp/2 * unit.cm;
      par[9] = xp/2 * unit.cm;
      par[10] = 0;
      
      std::cout
           << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakeTrap(\""
           << S(nameS) << "\",med" << itmed << "," << par[0] << ","
           << par[1] << "," << par[2] << "," << par[3] << "," << par[4]
           << "," << par[5] << "," << par[6] << "," << par[7] << ","
           << par[8] << "," << par[9] << "," << par[10] << ");"
           << std::endl;
   }
   else if (shapeS == "pcon")
   {
      shapeS = "PCON";
      double phi0, dphi;
      XString profS(el->getAttribute(X("profile")));
      std::stringstream listr(profS);
      listr >> phi0 >> dphi;
      DOMNodeList* planeList = el->getElementsByTagName(X("polyplane"));

      npar = 3;
      par[0] = phi0 * unit.deg;
      par[1] = dphi * unit.deg;
      par[2] = planeList->getLength();
      for (int p = 0; p < planeList->getLength(); p++)
      {
         double ri, ro, zl;
         DOMNode* node = planeList->item(p);
         DOMElement* elem = (DOMElement*) node;
         XString riozS(elem->getAttribute(X("Rio_Z")));
         std::stringstream listr1(riozS);
         listr1 >> ri >> ro >> zl;
         par[npar++] = zl * unit.cm;
         par[npar++] = ri * unit.cm;
         par[npar++] = ro * unit.cm;
      }

      std::cout
           << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakePcon(\""
           << S(nameS) << "\",med" << itmed << "," << par[0] << ","
           << par[1] << "," << par[2] << ");" << std::endl;
      for (int mycounter=0; mycounter < par[2]; mycounter++)
      {
         std::cout
              << "  ((TGeoPcon*)" << S(nameS)
              << "->GetShape())->DefineSection(" << mycounter 
              << "," << par[3+3*mycounter] << "," << par[4+3*mycounter]
              << "," << par[5+3*mycounter] << ");" << std::endl;
      }
   }
   else if (shapeS == "pgon")
   {
      shapeS = "PGON";
      int segments;
      XString segS(el->getAttribute(X("segments")));
      segments = atoi(S(segS));
      double phi0, dphi;
      XString profS(el->getAttribute(X("profile")));
      std::stringstream listr(profS);
      listr >> phi0 >> dphi;
      DOMNodeList* planeList = el->getElementsByTagName(X("polyplane"));

      npar = 4;
      par[0] = phi0 * unit.deg;
      par[1] = dphi * unit.deg;
      par[2] = segments;
      par[3] = planeList->getLength();
      for (int p = 0; p < planeList->getLength(); p++)
      {
         double ri, ro, zl;
         DOMNode* node = planeList->item(p);
         DOMElement* elem = (DOMElement*) node;
         XString riozS(elem->getAttribute(X("Rio_Z")));
         std::stringstream listr1(riozS);
         listr1 >> ri >> ro >> zl;
         par[npar++] = zl * unit.cm;
         par[npar++] = ri * unit.cm;
         par[npar++] = ro * unit.cm;
      }

      std::cout 
           << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakePgon(\""
           << S(nameS) << "\",med" << itmed << "," << par[0] << ","
           << par[1] << "," << par[2] << "," << par[3] << ");" << std::endl;
      for (int mycounter=0; mycounter < par[3]; mycounter++)
      {
         std::cout
              << "  ((TGeoPgon*)" << S(nameS)
              << "->GetShape())->DefineSection(" << mycounter 
              << "," << par[4+3*mycounter] << "," << par[5+3*mycounter]
              << "," << par[6+3*mycounter] << ");" << std::endl;
      }
   }
   else if (shapeS == "cons")
   {
      shapeS = "CONS";
      double rim, rip, rom, rop, zl;
      XString riozS(el->getAttribute(X("Rio1_Rio2_Z")));
      std::stringstream listr(riozS);
      listr >> rim >> rom >> rip >> rop >> zl;
      double phi0, dphi;
      XString profS(el->getAttribute(X("profile")));
      listr.clear(), listr.str(profS);
      listr >> phi0 >> dphi;

      npar = 7;
      par[0] = zl/2 * unit.cm;
      par[1] = rim * unit.cm;
      par[2] = rom * unit.cm;
      par[3] = rip * unit.cm;
      par[4] = rop * unit.cm;
      par[5] = phi0 * unit.deg;
      par[6] = (phi0 + dphi) * unit.deg;
      if (dphi*unit.deg == 360)
      {
         shapeS = "CONE";
         npar = 5;

         std::cout
              << "TGeoVolume *" << S(nameS) << "= gGeoManager->MakeCone(\"" 
              << S(nameS) << "\",med" << itmed << "," 
              << par[0] << "," << par[1] << "," << par[2] 
              << par[3] << "," << par[4] << ");" << std::endl;
      }
      else
      {
         std::cout
              << "TGeoVolume *" << S(nameS)
              << "= gGeoManager->MakeCons(\"" << S(nameS) 
              << "\",med" << itmed << "," << par[0] << "," << par[1]
              << "," << par[2] << "," << par[3] << "," << par[4] << ","
              << par[5] << "," << par[6] << ");" << std::endl;
      }
   }
   else if (shapeS == "sphere")
   {
      shapeS = "SPHE";
      double ri, ro;
      XString rioS(el->getAttribute(X("Rio")));
      std::stringstream listr(rioS);
      listr >> ri >> ro;
      double theta0, theta1;
      XString polarS(el->getAttribute(X("polar_bounds")));
      listr.clear(), listr.str(polarS);
      listr >> theta0 >> theta1;
      double phi0, dphi;
      XString profS(el->getAttribute(X("profile")));
      listr.clear(), listr.str(profS);
      listr >> phi0 >> dphi;

      npar = 6;
      par[0] = ri * unit.cm;
      par[1] = ro * unit.cm;
      par[2] = theta0 * unit.deg;
      par[3] = theta1 * unit.deg;
      par[4] = phi0 * unit.deg;
      par[5] = (phi0 + dphi) * unit.deg;
      std::cout
           << "TGeoVolume *" << S(nameS) 
           << "= gGeoManager->MakeSphere(\"" << S(nameS) 
           << "\",med" << itmed << "," << par[0] << "," << par[1]
           << "," << par[2] << "," << par[3] << "," << par[4] << ","
           << par[5] << ");" << std::endl;
   }
   else
   {
      std::cerr
           << APP_NAME << " error: volume " << S(nameS)
           << " should be one of the valid shapes, not " << S(shapeS)
           << std::endl;
      exit(1);
   }

   if (nameS.size() > 4)
   {
      std::cerr
           << APP_NAME << " error: volume name " << S(nameS)
           << " should be no more than 4 characters long." << std::endl;
      exit(1);
   }

   return ivolu;
}

int RootMacroWriter::createRotation(Refsys& ref)
{
   int irot = CodeWriter::createRotation(ref);

   if (irot > 0)
   {
      double theta[3], phi[3];
      for (int i = 0; i < 3; i++)
      {
         double r = sqrt(ref.fRmatrix[0][i] * ref.fRmatrix[0][i]
                       + ref.fRmatrix[1][i] * ref.fRmatrix[1][i]);
         theta[i] = atan2(r, ref.fRmatrix[2][i]) * 180/M_PI;
         phi[i] = atan2(ref.fRmatrix[1][i], ref.fRmatrix[0][i]) * 180/M_PI;
      }
   
      std::cout
           << "TGeoRotation *rot" << irot
           <<" = new TGeoRotation(\"rot" << irot << "\","
           << theta[0] << "," << phi[0] << "," << theta[1] << ","
           << phi[1] << "," << theta[2] << "," << phi[2] << ");"
           << std::endl;
   } 
   return irot;
}

int RootMacroWriter::createDivision(XString& divStr, Refsys& ref)
{
   int ndiv = CodeWriter::createDivision(divStr,ref);

   XString motherS(ref.fMother->getAttribute(X("name")));
   std::cout
        << "TGeoVolume *" << divStr << "= "
        << S(motherS) << "->Divide(\"" << divStr << "\","
        << ref.fPartition.iaxis << "," << ref.fPartition.ncopy << ","
        << ref.fPartition.start << "," << ref.fPartition.step << ");"
        << std::endl;

   return ndiv;
}

int RootMacroWriter::createVolume(DOMElement* el, Refsys& ref)
{
   int icopy = CodeWriter::createVolume(el,ref);

   if (fPending)
   {
      XString nameS(el->getAttribute(X("name")));
      XString motherS(fRef.fMother->getAttribute(X("name")));
      int irot = fRef.fRotation;
      if (first_volume_placement == 0) 
      {
         std::cout
              << "gGeoManager->SetTopVolume(" << S(motherS) << ");"
              << std::endl;
         first_volume_placement = 1;
      }
      if (irot == 0) 
      {
         if ( (fRef.fOrigin[0] == 0) &&
              (fRef.fOrigin[1] == 0) &&
              (fRef.fOrigin[2] == 0))
         {
            std::cout
                 << S(motherS) << "->AddNode("
                 << S(nameS) << "," << icopy << ",gGeoIdentity);"
                 << std::endl;
         }
         else
         { 
            std::cout
                 << S(motherS) <<"->AddNode(" << S(nameS) << ","
                 << icopy << ",new TGeoTranslation(" 
                 <<  fRef.fOrigin[0] << "," 
                 <<  fRef.fOrigin[1] << "," 
                 <<  fRef.fOrigin[2] << "));" << std::endl;
         }
      }
      else
      {
         std::cout
              << S(motherS) <<"->AddNode(" << S(nameS)<< ","
              << icopy << ",new TGeoCombiTrans(" 
              << fRef.fOrigin[0] << "," 
              << fRef.fOrigin[1] << "," 
              << fRef.fOrigin[2] << "," << "rot" << irot
              <<"));" << std::endl;
      }
      fPending = false;
   }
   return icopy;
}

void RootMacroWriter::createHeader()
{
   CodeWriter::createHeader();

   std::cout
       << "TGeoManager * hddsroot()" << std::endl
       << "{" << std::endl
       << "//" << std::endl
       << "//  This file has been generated automatically via the " << std::endl
       << "//  utility hdds-root_h directly from main_HDDS.xml " << std::endl
       << "//   (see ROOT class TGeoManager for an example of use) " << std::endl
       << "//" << std::endl
       << " " << std::endl
       << "//-----------List of Materials and Mixtures--------------" << std::endl
       << " " << std::endl;
}

void RootMacroWriter::createTrailer()
{
   CodeWriter::createTrailer();
   std::cout
       << "gGeoManager->CloseGeometry();" << std::endl
       << "gGeoManager->SetTopVolume(\"SITE\");" << std::endl
       << "return gGeoManager;" << std::endl
       << "}" << std::endl;
}
