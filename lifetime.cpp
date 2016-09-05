// Copyright (c) 2007-2008, Kale J. Franz
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
 * =============================================================
 */

#include "mex.h"
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void lifetime(double * Psii, double * EigenEi, double * Psij, double * EigenEj,
              int xpoints, double deltax, double * Vcx, double * Mcx,
              double * Egx, double * Temp, double * epsstatic, double * epshighf,
              double hwlo, double * kp0, double * tauij)
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
{
    
    //constants
    double hbar = 6.626e-34 / 2 / 3.141592653589793;
    double e0 = 1.602E-19;
    double m0 = 9.109E-31;
    double eps0 = 8.85E-12;
    
    //generic counters
    int q = 0, m = 0, n = 0;
    
    //convert energies and potentials from Jouls to eV
//     *EigenEi = *EigenEi / e0;
//     *EigenEj = *EigenEj / e0;
//     for(q = 0; q < xpoints; q++)
//         *(Vcx+q) = *(Vcx+q) / e0;
    
    double Ediff = *EigenEi - *EigenEj;
    
    //if energy difference between states is less than a phonon, this program can't calculate the lifetime
    if (Ediff < hwlo)
        *tauij = 1e20;
    else
    {
        //Phonon Emission calc
        
        //need to find average effective mass for each state
        double Mi=0, Mj=0;  // average effective masses for states m & n
        double dmi, dmj;  // effective mass differentials
        for(q = 0; q < xpoints; q++)
        {
            if(*EigenEi > Vcx[q])
                dmi = Mcx[q] * (1 + ((*EigenEi-hwlo)-Vcx[q]) / Egx[q]) * (deltax * Psii[q]*Psii[q]);
            else
                dmi = Mcx[q] * (1 - (Vcx[q]-(*EigenEi-hwlo)) / Egx[q]) * (deltax * Psii[q]*Psii[q]);
            Mi = Mi + dmi;
           
//             if(*EigenEj > Vcx[q])
//                 dmj = Mcx[q] * (1 + ((*EigenEj-hwlo)-Vcx[q]) / Egx[q]) * (deltax * Psij[q]*Psij[q]);
//             else
//                 dmj = Mcx[q] * (1 - (Vcx[q]-(*EigenEj-hwlo)) / Egx[q]) * (deltax * Psij[q]*Psij[q]);
//             Mj = Mj + dmj;
        }
        
//         mexPrintf("Mi: %g  e0: %g  hbar: %g   Ediff:%g    hwlo: %g\n",Mi,e0,hbar,Ediff,hwlo);

        //Qp is phonon wavevector for phonon emission
        // from Bastard Eq. (11b)
        double Qp = sqrt(2*Mi*e0 / hbar / hbar * (Ediff-hwlo)); //assume kinitial = 0 (fast intrasubband relaxation)

        //End Phonon Emission calc
              
//         //Phonon absorption calc
//         //need to find average effective mass for each state
//         double Mjabs=0, Miabs=0;
//         for(q = 0; q < xpoints; q++)
//         {
//             if(*EigenEi > Vcx[q])
//                 dmi = Mcx[q] * (1+((*EigenEi+hwlo)-Vcx[q]) / Egx[q]) * (deltax * Psii[q]*Psii[q]);
//             else
//                 dmi = Mcx[q] * (1 - (Vcx[q] - (*EigenEi+hwlo)) / Egx[q]) * (deltax * Psii[q]*Psii[q]);
//             Miabs = Miabs + dmi;
//             
//             if(*EigenEj > Vcx[q])
//                 dmj = Mcx[q] * (1+((*EigenEj+hwlo)-Vcx[q]) / Egx[q]) * (deltax * Psij[q]*Psij[q]);
//             else
//                 dmj = Mcx[q] * (1 - (Vcx[q] - (*EigenEj+hwlo)) / Egx[q]) * (deltax * Psij[q]*Psij[q]);
//             Mjabs = Mjabs + dmj;
//         }
//         //Qpabs is phonon wavevector for phonon absorption
//         double Qpabs = sqrt(2*Miabs*e0 / hbar / hbar *(Ediff+hwlo));
//         //End Phonon absorption calc
        
        //calc Iij for phonon emission
        // from Bastard Eq. (14)
        double Iij = 0; 
        double dIij; //Iij differential
        double x1, x2;
        for(n = 0; n < xpoints; n++)
        {
            x1 = n * deltax;
            for(m = 0; m < xpoints; m++)
            {
                x2 = m * deltax;
                dIij = Psii[m] * Psij[m] * exp(-Qp*abs(x1-x2)) * Psii[n] * Psij[n] * deltax * deltax;
                Iij = Iij + dIij;
            }
        }
        
//         mexPrintf("Qp: %g   Iij: %g\n",Qp,Iij);
        //end calc Iij for phonon emission
       
        //calc Iij for phonon abs
//         double Iijabs = 0;
//         for(n = 0; n < xpoints; n++)
//         {
//             x1 = n * deltax;
//             for(m = 0; m < xpoints; m++)
//             {
//                 x2 = m * deltax;
//                 dIij = Psii[m] * Psij[m] * exp(-Qpabs*abs(x1-x2)) * Psii[n] * Psij[n] * deltax * deltax;
//                 Iijabs = Iijabs + dIij;
//             }
//            
//         }
        //end calc Iij for phonon abs
        
        double PsiTPsii = 0, PsiTPsij = 0;
        double inversetauij;
//         double inversetauijabs;
        for(q = 0; q < xpoints; q++)
        {
            PsiTPsii = PsiTPsii + Psii[q] * ((*EigenEi-Vcx[q])/(*EigenEi-Vcx[q]+Egx[q])) * Psii[q] * deltax;
            PsiTPsij = PsiTPsij + Psij[q] * ((*EigenEj-Vcx[q])/(*EigenEj-Vcx[q]+Egx[q])) * Psij[q] * deltax;
        }
        
//         mexPrintf("PsiTPsii: %g   PsiTPsij: %g\n",PsiTPsii,PsiTPsij);
         
        // from Bastard Eq. (11a)
        inversetauij = (Mi*(e0/hbar*e0/hbar*e0/hbar) * hwlo/(4*eps0 * *kp0))*(1e-10*Iij/(1E-10*Qp)) * (1+PsiTPsii)*(1+PsiTPsij);
//         inversetauijabs = (Miabs*(e0/hbar*e0/hbar*e0/hbar) * hwlo/(4*eps0* *kp0))*(1e-10*Iijabs/(1E-10*Qpabs)) * (1+PsiTPsii)*(1+PsiTPsij);
        *tauij = 1e12/inversetauij;
//         *tauijabs = 1e12/inversetauijabs; //value not reported out right now
        
//         mexPrintf("inversetauij: %g   tauij: %g\n",inversetauij,*tauij);
        
        //temperature adjustment to lifetime
//        if(*Temp > 0)
//            *tauij = *tauij / (1+2 / (exp(e0* hwlo/(*Temp*1.381e-23))-1)); // from Bastard Eq. (15)
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
    double * tauij;
    
  /* Check for the proper number of arguments. */
    //  if (nrhs != 4)
    //    mexErrMsgTxt("Two inputs required.");
    //  if (nlhs > 1)
    //    mexErrMsgTxt("Too many output arguments.");
    
  /* Check that both inputs are row vectors. */
    //  if (mxGetM(prhs[0]) != 1 || mxGetM(prhs[2]) != 1 || mxGetM(prhs[3]) != 1)
    //    mexErrMsgTxt("Both inputs must be row vectors.");
    //  rows = 3;
    
  /* Check that both inputs are complex. */
    //  if (!mxIsComplex(prhs[0]) || !mxIsComplex(prhs[3]))
    //    mexErrMsgTxt("Inputs must be complex.\n");
    
  /* Get the length of each input vector. */
    //  Vcx_length = mxGetN(prhs[0]);
    
  /* Get pointers to real and imaginary parts of the inputs. */
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
    
    //rescale if needed
    double *Psii, *Psij, *Vcx, *Mcx, *Egx;
    double hwlo, deltax;
    hwlo = *hwlop;
    int xpoints;
    if(*deltaxp * 4 < 1)
    {
        xpoints = int(floor(*xpointsp / 4));
        Psii = (double *)mxCalloc(xpoints, sizeof(double));
        Psij = (double *)mxCalloc(xpoints, sizeof(double));
        Vcx = (double *)mxCalloc(xpoints, sizeof(double));
        Mcx = (double *)mxCalloc(xpoints, sizeof(double));
        Egx = (double *)mxCalloc(xpoints, sizeof(double));
        deltax = *deltaxp * 4 * 1e-10;
        for(int q = 0; q < xpoints; q++)
        {
            *(Psii+q) = (*(Psiip+4*q)+*(Psiip+4*q+1)+*(Psiip+4*q+2)+*(Psiip+4*q+3))/4;
            *(Psij+q) = (*(Psijp+4*q)+*(Psijp+4*q+1)+*(Psijp+4*q+2)+*(Psijp+4*q+3))/4;
            *(Vcx+q) = *(Vcxp+4*q);
            *(Mcx+q) = *(Mcxp+4*q);
            *(Egx+q) = *(Egxp+4*q);
        }
    }
    else if(*deltaxp * 3 < 1)
    {
        xpoints = int(floor(*xpointsp / 3));
        Psii = (double *)mxCalloc(xpoints, sizeof(double));
        Psij = (double *)mxCalloc(xpoints, sizeof(double));
        Vcx = (double *)mxCalloc(xpoints, sizeof(double));
        Mcx = (double *)mxCalloc(xpoints, sizeof(double));
        Egx = (double *)mxCalloc(xpoints, sizeof(double));
        deltax = *deltaxp * 3 * 1e-10;
        for(int q = 0; q < xpoints; q++)
        {
            *(Psii+q) = (*(Psiip+3*q)+*(Psiip+3*q+1)+*(Psiip+3*q+2))/3;
            *(Psij+q) = (*(Psijp+3*q)+*(Psijp+3*q+1)+*(Psijp+3*q+2))/3;
            *(Vcx+q) = *(Vcxp+3*q);
            *(Mcx+q) = *(Mcxp+3*q);
            *(Egx+q) = *(Egxp+3*q);
        }
    }
    else if(*deltaxp * 2 < 1)
    {
        xpoints = int(floor(*xpointsp / 2));
        Psii = (double *)mxCalloc(xpoints, sizeof(double));
        Psij = (double *)mxCalloc(xpoints, sizeof(double));
        Vcx = (double *)mxCalloc(xpoints, sizeof(double));
        Mcx = (double *)mxCalloc(xpoints, sizeof(double));
        Egx = (double *)mxCalloc(xpoints, sizeof(double));
        deltax = *deltaxp * 2 * 1e-10;
        for(int q = 0; q < xpoints; q++)
        {
            *(Psii+q) = (*(Psiip+2*q)+*(Psiip+2*q+1))/2;
            *(Psij+q) = (*(Psijp+2*q)+*(Psijp+2*q+1))/2;
            *(Vcx+q)  = (*(Vcxp+2*q) +*(Vcxp+2*q+1) )/2;
            *(Mcx+q)  = (*(Mcxp+2*q) +*(Mcxp+2*q+1) )/2;
            *(Egx+q)  = (*(Egxp+2*q) +*(Egxp+2*q+1) )/2;
        }
    }
    else
    {
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
    }
    
  /* Call the C subroutine. */
    lifetime(Psii, EigenEi, Psij, EigenEj, xpoints, deltax, Vcx, Mcx, Egx, 
             Temp, epsstatic, epshighf, hwlo, kp0, tauij);

    mxFree(Psii);
    mxFree(Psij);
    mxFree(Vcx);
    mxFree(Mcx);
    mxFree(Egx);
    
    return;
    
}