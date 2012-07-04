#include <b1piAmpCheck.h>


b1piAmpCheck::b1piAmpCheck(){}

b1piAmpCheck::b1piAmpCheck(Kinematics &evt)
{
  SetEvent(evt);
}


TLorentzVector&
b1piAmpCheck::Hep2T(const HepLorentzVector &v1, TLorentzVector &v2)
{
  v2.SetXYZT(v1.px(),v1.py(),v1.pz(),v1.e());
  return v2;
}


/**
 * This function sets the 4 vectors of an event.
 * Seven vectors must be given in all:
 * beam photon, recoil proton and the 5 pions
 * starting from the bachelor and from there
 * in order down the tree. The calculation
 * are run automatically when a new event is loaded.
 */

void
b1piAmpCheck::SetEvent(Kinematics &evt, bool findParMatch) 
{
  assert(evt.particleList().size()==7);

  if(findParMatch){
    double bestOmegaMass=999;
    int pi0_ind=0,rhopip_ind=0,rhopim_ind=0;
    
    for(unsigned int i=2 ; i<7 ; ++i){
      if(evt.particle(i).m()>.137) continue; //find the one pi0

      for(unsigned int k=2 ; k<7 ; ++k){
	if(k == i) continue;
	  
	for(unsigned int m=k+1 ; m<7 ; ++m){
	  if(m == i) continue;
	
	  HepLorentzVector candOmega(evt.particle(i)+evt.particle(k)+evt.particle(m));
	  
	  if(fabs(candOmega.m()-.783) < fabs(bestOmegaMass-.783)){
	    bestOmegaMass = candOmega.m();
	    pi0_ind = i; rhopip_ind = k; rhopim_ind = m;
	  }

	}
      }
    }

    Hep2T(evt.particle(pi0_ind), m_omegas_pi);

    Hep2T(evt.particle(rhopip_ind), m_rhos_pip);
    Hep2T(evt.particle(rhopim_ind), m_rhos_pim);	    

    m_rho = m_rhos_pim + m_rhos_pip;
    m_omega= m_rho + m_omegas_pi;

    double bestb1Mass=999;
    int b1spi_ind=0;

    for(int k=2 ; k<7 ; ++k){
      if(k==pi0_ind || k==rhopip_ind || k==rhopim_ind) continue;

      TLorentzVector pidummy;
      Hep2T(evt.particle(k), pidummy);

      TLorentzVector candb1(m_omega + pidummy);
      if(fabs(candb1.M()-1.23) < fabs(bestb1Mass-1.23)){
	bestb1Mass = candb1.M();
	b1spi_ind = k;
      }
    }

    Hep2T(evt.particle(b1spi_ind), m_b1s_pi);
    
    for(int k=2 ; k<7 ; ++k){
      if(k==pi0_ind || k==rhopip_ind || k==rhopim_ind || k==b1spi_ind) continue;
      Hep2T(evt.particle(k), m_Xs_pi);
    }
    
  }else{
    Hep2T(evt.particle(6), m_rhos_pip);
    Hep2T(evt.particle(5), m_rhos_pim);
    
    Hep2T(evt.particle(4), m_omegas_pi);
    
    Hep2T(evt.particle(3), m_b1s_pi);
    
    Hep2T(evt.particle(2), m_Xs_pi);
    
    m_rho = m_rhos_pim + m_rhos_pip;
    m_omega= m_rho + m_omegas_pi;
  }


  m_b1= m_omega + m_b1s_pi;
  m_X = m_b1 + m_Xs_pi;

  Hep2T(evt.particle(0), m_beam);
  Hep2T(evt.particle(1), m_recoil);


  ProcKin();
}



TLorentzVector&
b1piAmpCheck::MoveToRF(TLorentzVector &parent,
		       TLorentzVector &daughter)
{
  daughter.RotateZ(-parent.Phi());
  daughter.RotateY(-parent.Theta());
  daughter.Boost(0,0,-parent.Beta());

  return daughter;
}

void
b1piAmpCheck::ProcKin()
{

  //Resonance RF, Godfried-Jackson frame
  TLorentzRotation XRFboost( -m_X.BoostVector() );

  TLorentzVector beam_XRF   = XRFboost * m_beam;
  TLorentzVector recoil_XRF = XRFboost * m_recoil;
  
  //Define coordinate system
  TVector3 zGJ = beam_XRF.Vect().Unit();
  TVector3 yGJ = zGJ.Cross(recoil_XRF.Vect()).Unit();
  TVector3 xGJ = yGJ.Cross(zGJ);
  
  TLorentzVector b1_XRF      = XRFboost * m_b1;
  TLorentzVector omega_XRF   = XRFboost * m_omega;
  TLorentzVector rho_XRF     = XRFboost * m_rho;
  TLorentzVector rhos_pip_XRF= XRFboost * m_rhos_pip;  


  TVector3 ang_b1( (b1_XRF.Vect()).Dot(xGJ),
		   (b1_XRF.Vect()).Dot(yGJ),
		   (b1_XRF.Vect()).Dot(zGJ) );
  
  m_X_phi=ang_b1.Phi();
  m_X_cosTheta=ang_b1.CosTheta();
  
  
  TLorentzVector omega_b1RF(MoveToRF(b1_XRF, omega_XRF));
  TLorentzVector rho_omegaRF(MoveToRF(omega_b1RF,
				      MoveToRF(b1_XRF, rho_XRF)));
  TLorentzVector rhos_pip_rhoRF(MoveToRF(rho_omegaRF,
					 MoveToRF(omega_b1RF,
						  MoveToRF(b1_XRF,rhos_pip_XRF))));
 
  m_b1_phi=omega_b1RF.Phi();
  m_b1_cosTheta=omega_b1RF.CosTheta();
  
  m_omega_phi=rho_omegaRF.Phi();
  m_omega_cosTheta=rho_omegaRF.CosTheta();
  
  m_rho_phi=rhos_pip_rhoRF.Phi();
  m_rho_cosTheta=rhos_pip_rhoRF.CosTheta();  
  
}
