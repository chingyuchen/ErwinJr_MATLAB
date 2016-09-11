// Copyright (c) 2007-2008, Kale J. Franz
// Copyright (c) 2012-2016, Ching-Yu Chen
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code or derivatives thereof must retain the 
//       above copyright notice, this list of conditions and the following
//       disclaimer.
//     * Redistributions in binary form, and any binary file that is compiled 
//       from a derivative of this source code, must reproduce the above 
//       copyright notice, this list of conditions and the following disclaimer 
//       in the documentation and/or other materials provided with the 
//       distribution.
//     * Any publication, presentation, or other publicly or privately 
//       presented work having made use of or benefited from this software or 
//       derivatives thereof must explicitly name Kale J. Franz in a section 
//       dedicated to acknowledgements or name Kale J. Franz as a co-author 
//       of the work.
//     * Any use of this software that directly or indirectly contributes to 
//       work or a product for which the user is or will be remunerated must be 
//       further licensed through the Princeton Univeristy Office of Technology 
//       Licensing and the Princeton Univeristy Mid-Infrared Photonics Lab led 
//       by Professor Claire Gmachl prior to the transaction of said 
//       remuneration.  
// 
// THIS SOFTWARE IS PROVIDED BY Kale J. Franz ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL Kale J. Franz BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



/* tauij =  
 *    lifetime(Psii, EigenEi/e0, Psij, EigenEj/e0, xpoints, deltax, Vcx/e0, Mcx, Egx,  
 *             Temp, epsstatic, epshighf, hwlo, kp0);
 * =============================================================
 * Lifetime program, adapted from Ferreira & Bastard  PRB 40 1074 (1989)
 * 
 * Physics by Daniel Wasserman
 * Implementation by Kale J. Franz
 * last updated 14 Feb 2007
 * Refraction and Modified by Ching-Yu Chen, 6 Sep 2016
 * =============================================================
 */
#include <ctime>
using namespace std;
#include "mex.h"
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
//Psii: wavefunction value Psi_i(x) at every x point (array)
//Psij: wavefunction value Psi_j(x) at every x point (array)
//EigenEi: eigen energy for wavefunction Psi_i (scalar)
//EigenEj: eigen energy for wavefunction Psi_j (scalar)
//xpoints: number of x-axis points (scalar)
//Vcx: potential in Joules for every x point (array)
//Mcx: effective mass for every x point (array)
//Egx: bandgap matrix in Joules for every x point (array)
//Temp: temperature in K (scalar)
//epsstatic: the static dielectric constant (epsilon_0), depends on material (scalar)
//epshighf: the high frequency dielectric constant (eps_infinity), depends on material (scalar)
//hwlo: hbar*omega_LO, the LO phonon energy in meV, depends on material (scalar)
//kp0: some constant that I don't know what is right now, depends on material (scalar)
//tauij: output (scalar)
void lifetime(double * Psii, double * EigenEi, double * Psij, double * EigenEj,
              int xpoints, double deltax, double * Vcx, double * Mcx,
              double * Egx, double * Temp, double * epsstatic, double * epshighf,
              double hwlo, double * kp0, double * tauij, double *Qp, double *Iij, double *Mi)
{
    
    //constants
    double hbar = 6.626e-34 / 2 / 3.141592653589793;
    double e0 = 1.602E-19;
    double m0 = 9.109E-31;
    double eps0 = 8.85E-12;
    
    //Phonon Emission calc
    // Given the zero electric field mass(x), which is only material dependence over the space, here we need to calculate the effective mass after applying the electric field.
    // The ion electron interaction due to the ion motion caused by the electric field is treated as purterbation. Applying the kp theory, one can find the energy dependent of effective mass.
    // But don't we always assume that k = 0?
  
    double dmi;  // effective mass differentials
    for (int i = 0; i < xpoints; i++) {
        dmi = Mcx[i] * (1 + ((*EigenEi - hwlo) - Vcx[i]) / Egx[i]) * (deltax * Psii[i] * Psii[i]); // based on kp approximation. equation (3.1.14), (3.1.26), book quatum cascade laser, Jerome
        *Mi = *Mi + dmi;
    }
    
    // Qp is defined as the phonon wavevector of phonon emission, Bastard Eq. (11b), eq.2.65 in Franz thesis
    double Ediff = *EigenEi - *EigenEj;
    if ((Ediff - hwlo) == 0) {
        *Qp = 0;
    } else {
        *Qp = sqrt(2* *Mi / hbar / hbar * std::abs(Ediff - hwlo) * e0);
    }
   
    double *expArray = new double[xpoints];
    if (*Qp == 0) {
        double expDeltaX = deltax;
        expArray[1] = deltax;
        for (int i = 0; i < xpoints; i++) {
            expArray[i] = expArray[i - 1] + expDeltaX;
        }        
    } else {
        double expDeltaX = exp(-*Qp * deltax);
        expArray[1] = 1;
        for (int i = 2; i < xpoints; i++) {
            expArray[i] = expArray[i - 1] * expDeltaX;
        }       
    }   
    
    // Kale thesis eqn 2.69
    double *PsiSqu = new double[xpoints];
    for (int i = 0; i < xpoints; i++) {
        PsiSqu[i] = Psii[i] * Psij[i];
    }
    
    for (int i = 0; i < xpoints; i++) {
        double dI = 0.0;
        int x = 0;        
        for (int j = i; j > 0; j--) {
            dI += expArray[j] * PsiSqu[x];
            x++;
        }
        for (int j = 0; j < xpoints - i; j++) {
            dI += expArray[j] * PsiSqu[x];
            x++;
        }        
        *Iij = *Iij + (PsiSqu[i] * dI);         
    }
    *Iij *= (deltax * deltax);
    
    double inversetauij;
    if (Qp == 0) {
        inversetauij = *Mi * (e0 / hbar * e0 / hbar) * ( hwlo * e0 / hbar ) / (4 * eps0 ) * ( 1 / *epshighf -  1 / *epsstatic) * ( *Iij );    
    } else {
        inversetauij = *Mi * (e0 / hbar * e0 / hbar) * ( hwlo * e0 / hbar ) / (4 * eps0 ) * ( 1 / *epshighf -  1 / *epsstatic) * ( *Iij / *Qp );    
    }
     *tauij = 1e12 / inversetauij;   // Ching-Yu: 1 / ps * ((10 ^ 12) * ps / s) = 1 / s
    //temperature dependent
    if (*Temp > 0) {
        *tauij = *tauij / (1+1 / (exp(e0 * hwlo / (*Temp * 1.381e-23)) - 1)); // from Bastard Eq. (15)  Ching-Yu: tauij=tauij/(1+n)
    }
}


/* The gateway routine. */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    double * Psiip, * Psijp;
    double * EigenEi, * EigenEj;
    double * xpointsp, * deltaxp;
    double * Vcxp, * Mcxp, * Egxp;
    double * Temp, * epsstatic, * epshighf, * hwlop, * kp0;
    double * tauij, *Qp, *Iij, *Mi;
    
    Psiip = mxGetPr(prhs[0]);
    EigenEi = mxGetPr(prhs[1]);
    Psijp = mxGetPr(prhs[2]);
    EigenEj = mxGetPr(prhs[3]);
    xpointsp = mxGetPr(prhs[4]);
    deltaxp = mxGetPr(prhs[5]);
    Vcxp = mxGetPr(prhs[6]);
    Mcxp = mxGetPr(prhs[7]);
    Egxp = mxGetPr(prhs[8]);
    Temp = mxGetPr(prhs[9]);
    epsstatic = mxGetPr(prhs[10]);
    epshighf = mxGetPr(prhs[11]);
    hwlop = mxGetPr(prhs[12]);
    kp0 = mxGetPr(prhs[13]);
    
  /* Create a new array and set the output pointer to it. */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    tauij = mxGetPr(plhs[0]);    
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    Qp = mxGetPr(plhs[1]);    
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
    Iij = mxGetPr(plhs[2]);    
    plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
    Mi = mxGetPr(plhs[3]);    
    
    double *Psii, *Psij, *Vcx, *Mcx, *Egx;
    double hwlo, deltax;
    hwlo = *hwlop;
    int xpoints;
    
    
    xpoints = int(*xpointsp);
    Psii = (double *)mxCalloc(xpoints, sizeof(double));
    Psij = (double *)mxCalloc(xpoints, sizeof(double));
    Vcx = (double *)mxCalloc(xpoints, sizeof(double));
    Mcx = (double *)mxCalloc(xpoints, sizeof(double));
    Egx = (double *)mxCalloc(xpoints, sizeof(double));
    memcpy(Psij,Psiip,xpoints*sizeof(double));
    memcpy(Psii,Psijp,xpoints*sizeof(double));
    memcpy(Vcx,Vcxp,xpoints*sizeof(double));
    memcpy(Mcx,Mcxp,xpoints*sizeof(double));
    memcpy(Egx,Egxp,xpoints*sizeof(double));
    deltax = *deltaxp * 1e-10;

    
  /* Call the C subroutine. */
    lifetime(Psii, EigenEi, Psij, EigenEj, xpoints, deltax, Vcx, Mcx, Egx, 
             Temp, epsstatic, epshighf, hwlo, kp0, tauij, Qp, Iij, Mi);

    mxFree(Psii);
    mxFree(Psij);
    mxFree(Vcx);
    mxFree(Mcx);
    mxFree(Egx);
    
    return;
}