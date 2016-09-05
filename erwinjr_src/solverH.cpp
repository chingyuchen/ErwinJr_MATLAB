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


/*
 * =============================================================
 * Schrodinger Solver for 1D Quantum Wells
 * Implementation by Kale J. Franz
 * last updated 19 Sept 2008
 * =============================================================
 */

#include "mex.h"
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "matrix.h"

void normalize(double Eq, double *deltax, double *xpoints, int xval, double *Vcx, double *Egx, double *Mset, double *Psi, double *Mc);
//Eq: energy of current state Psi (scalar)
//deltax: xresolution in meters (scalar)
//xpoints: number of x-axis points (scalar)
//Vcx: potential in Joules for every x point (array)
//Egx: bandgap matrix in Joules for every x point (array)
//Psi: wavefunction value at every x point (array)

void PsiFn(double Eq, double * deltax, double * xpoints,
double * Vcx, double * Mcx, double *Mset, double * Egx, double * ESO, double * F,
double * material, double * Ep, double * EboundMin, double * Efield, int job, double * Psi);
//Mcx: effective mass for every x point (array)
//ESO: split off energy from light hole valence band
//material: not currently used
//Ep: for strain compensated effective mass

/* Computational subroutine */
void solverH(double * deltax, double * xpoints, double * Vcx, double * Mcx,
double * Egx, double * ESO, double * F, double * material, double * Ep,
double * EboundMin, double * EboundMax, double * Efield, double * numEpoints,
double * numEigStates, double * EigEnergies, double * EigPsi, double *McE)
//EboundMin: minimum energy point (scalar)
//EboundMax: maximum energy point (scalar)
//Efield: applied electric field (scalar)
//numEpoints: number of E-axis points (scalar)
//numEigStates: first output, number of eigen energy states found (scalar)
//EigEnergies: second output, Energy in Joules of each eigenstate (array of size 1 x numEigStates)
//EigPsi: third output, normalized wavefunctions (not squared) (array of size xpoints x numEigStates)
{
    int b=0, b_prev=0;
    double Emin = *EboundMin;
    double deltaE = (*EboundMax - *EboundMin) / *numEpoints;
    double EInc=0, Eq_prev=0;
    double Eq;
    double e0 = 1.602e-19;
    
    int EigStateCounter = 0;
    
    double *Psi;
    Psi = (double *)mxCalloc(int(*xpoints), sizeof(double));
    int *bVals;
    bVals = (int *)mxCalloc(int(*xpoints), sizeof(int));
    double *Mset;
    Mset = (double *)mxCalloc(int(*xpoints), sizeof(double));
    double *Mc;
    Mc = (double *)mxCalloc(1, sizeof(double));
    
    int q=0;
    int p=0, badstatecount=0;
    int xval=0;
    
    int job = 1;  // job determines which phase of PsiFn to use: the eigenvalue identification phase or the eigenvalue iterration phase
    
    //first stage of the program
    //for every Eq point given by EboundMin:deltaE:EboundMax, the function PsiFn computes a corresponding Psi
    //when the last value of Psi -- Psi(xpoints) -- changes signs, the Eq value is flagged
    //  this flagged value corresponds to one eigenvalue
    for(q=0; q < int(*numEpoints); q++)
    {
        Eq = Emin + q * deltaE;
        PsiFn(Eq, deltax, xpoints, Vcx, Mcx, Mset, Egx, ESO, F, material, Ep, EboundMin, Efield, job, Psi);
        
        //if Psi(xpoints) changes signs, flag the current Eq value
        // OR if xmax < xpoints, use xmax
        //     where xmax = 2*Emax[eV]/(E[kV/cm]*1e5) - E[J]/(E[kV/cm]*1e5*e0)
        
        if (*(Psi+int(*xpoints)-1) < 0)
            b = -1;
        if (*(Psi+int(*xpoints)-1) > 0)
            b = 1;
        
        if( b_prev !=0 && b != b_prev)  // b_prev=0 means first time through
        {
            *(EigEnergies + EigStateCounter) = Emin + (q-1) * deltaE;
            *(bVals + EigStateCounter) = b;
            EigStateCounter++;
            
//             mexPrintf("  q : %d   Eq : %g   ",q,Eq/e0);
//             mexPrintf("  Psi_last : %g   ",*(Psi+xval));
//             mexPrintf("b:%d   EigEnergy : %g  state : %d \n",b,*(EigEnergies + EigStateCounter), EigStateCounter); //, 
        }
        
        b_prev = b;
        
    }
    
    *numEigStates = EigStateCounter;
    
    //second stage of program
    //for every Eq value that was flagged in the first stage, now we go back
    //  and refine the energy to find the exact energy where Psi(xpoints) = 0
    //  this is the true eigen energy
    //the Psi value for this eigen energy is saved in EigPsi after being normalized
    job = 2;
    for(q=0; q < EigStateCounter; q++)
    {
        EInc = deltaE / 2;
        Eq = *(EigEnergies+q) + EInc;
        b = -*(bVals+q);
        int compare = 0;
        
        int j=0, jmax=0;
        //iteration process to converge on Psi(xpoints) = 0
        do{
            Eq_prev = Eq;
            PsiFn(Eq, deltax, xpoints, Vcx, Mcx, Mset, Egx, ESO, F, material, Ep, EboundMin, Efield, job, Psi);
            
            compare = *(Psi+int(*xpoints)-1) < 0 ? -1 : 1;  //*(Psi+q) ? 0 : ( *(Psi+q) < 0 ? -1 : 1);
            if( compare == b)  //signs of Psi & b are equal
                Eq = Eq + EInc;
            else
            {
                EInc = EInc/2;
                Eq = Eq - EInc;
            }
            j++;
            if(j == 250)
                mexPrintf("State %d had problems converging in energy.",q+1);
        }while(abs((Eq-Eq_prev)/abs(Eq_prev)) > 1e-15);
        if(j >= 250)
            mexPrintf("  %d iterations performed\n",j);
        // mexPrintf("State: %d  EigenE: %g\n",q,Eq);
        
        //xval = static_cast<int> (ceil((2* *EboundMax - Eq) / (*Efield * 1e5 * e0) / *deltax));  //if used, must fix units
        xval = *xpoints; // commenting out this line puts a "diagonal ceiling" on the solve space
        //mexPrintf("xval: %d\n",xval);
        
        normalize(Eq, deltax, xpoints, xval, Vcx, Egx, Mset, Psi, Mc); // normalize and square
        
        //here I insert a routine to removes states where psi(xpoints-1) != 0
        //these are false states that the first routine erronously identifies as eigen states
//         if( (*(Psi+int(*xpoints)-2)**(Psi+int(*xpoints)-2) - *(Psi+int(*xpoints)-1)**(Psi+int(*xpoints)-1)) < 0 
//         &&  (*(Psi+int(*xpoints)-3)**(Psi+int(*xpoints)-3) - *(Psi+int(*xpoints)-2)**(Psi+int(*xpoints)-2)) < 0)
        if( (*(Psi+int(*xpoints)-2)**(Psi+int(*xpoints)-2) - *(Psi+int(*xpoints)-1)**(Psi+int(*xpoints)-1)) / (*(Psi+int(*xpoints)-3)**(Psi+int(*xpoints)-3) - *(Psi+int(*xpoints)-2)**(Psi+int(*xpoints)-2)) > 1
        //( abs(*(Psi+int(*xpoints)-1)) > abs(1.1**Psi) || abs(*(Psi+int(*xpoints)-1)) < abs(0.9**Psi) )
           && 0)
         {
            badstatecount = badstatecount+1;
        }
        else
        {
            p = q - badstatecount;
            *(EigEnergies+p) = Eq;
            *(McE+p) = *Mc;
            
            j = p * int(*xpoints);
            memcpy(&EigPsi[j],Psi,int(*xpoints)*sizeof(double));
        }
    }
    
    *numEigStates = *numEigStates - badstatecount;
    
    mxFree(Mc);
    mxFree(Psi);
    mxFree(bVals);
    mxFree(Mset);
}

void normalize(double Eq, double *deltax, double *xpoints, int xval, double *Vcx, double *Egx, double *Mset, double *Psi, double *Mc)
{
    double e0 = 1.602e-19;
    double m0 = 9.109e-31;
    double a;
    double Psi_Int = 0, Psi_Int2 = 0, Psi_Sqr = 0, Mcx_Int = 0;
    int q = 0;
    
    //normalization takes nonparabolicity into account
    for(q=0; q < *xpoints; q++)
    {
        Psi_Sqr = *(Psi+q) * *(Psi+q) * (1 + ((Eq-*(Vcx+q)) / (Eq-*(Vcx+q)+*(Egx+q))));
        Psi_Int = Psi_Int + Psi_Sqr;
        Mcx_Int = Mcx_Int + *(Mset+q) * Psi_Sqr / m0;
    }
    
    *Mc = Mcx_Int / Psi_Int;
    
    if(xval < *xpoints)
    {
        for(q=xval; q < *xpoints; q++)
            Psi_Int2 = Psi_Int2 + *(Psi+q) * *(Psi+q) * (1 + ((Eq-*(Vcx+q)) / (Eq-*(Vcx+q)+*(Egx+q))));
//         mexPrintf("xval: %d   Psidiv: %g\n",xval,Psi_Int2 / Psi_Int);
        if(Psi_Int2 / Psi_Int > 0.05)
            *(Psi+int(*xpoints)-1) = 1e30;
    }
    
    a = 1 / sqrt( *deltax *1e-10 * Psi_Int);
    for(q=0; q < *xpoints; q++)
        *(Psi+q) = a * *(Psi+q);
    

}


void PsiFn(double Eq, double * deltax, double * xpoints,
double * Vcx, double * Mcx, double *Mset, double * Egx, double * ESO, double * F,
double * material, double * Ep, double *EboundMin, double *Efield, int job, double * Psi)
{
    double hbar = 6.626e-34 / 2 / 3.141592653589793;
    double m0 = 9.109e-31;
    double e0 = 1.602e-19;
    
    double McxE;
    double McxE2;
    
    int q = 0;
    
 //   int startpoint = int(*xpoints) - ceil( (Eq - *EboundMin)/(*Efield * *deltax)*1e5 + 200/(*deltax));
    int startpoint = 1;
    if (startpoint < 0)
        startpoint = 0;
    if (job ==2)
        startpoint = 1;
    
//     *Psi = 0;
//     *(Psi+1) = 1;
    
    for(q=0; q < int(*xpoints); q++)
    {
        if(int(*material) == 4 || int(*material) == 5)
            //No Approximation
            McxE = m0 / ((1+2* *(F+q)) + *(Ep+q)/3 * (2 / ((Eq-*(Vcx+q))+*(Egx+q)) + 1 / ((Eq-*(Vcx+q))+*(Egx+q)+*(ESO+q)) ));
        else
            McxE = *(Mcx+q) * (1 - (*(Vcx+q) - Eq) / *(Egx+q));
        
        *(Mset+q) = McxE;
        
        if(q>0)
            *(Mset+q-1) = (*(Mset+q-1) + *(Mset+q)) / 2;
    }
    
    for(q=0; q == startpoint; q++)
        *(Psi+q) = 0;
    *(Psi+startpoint) = 1;
    
    for(q=startpoint; q < int(*xpoints)-1; q++)
    {
        *(Psi+q+1) = ((2 * *deltax*1e-10 * *deltax*1e-10 / hbar / hbar * (*(Vcx+q) - Eq)*e0
                        + 1 / *(Mset+q) + 1 / *(Mset+q-1)) * *(Psi+q)
                        - *(Psi+q-1) / *(Mset+q-1)) * *(Mset+q);
    }
}



/* The gateway routine. */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    double * deltax, * Vcx, * Mcx;
    double * Egx, * ESO, * F, * material, * Ep;
    double * EboundMin, * EboundMax, * Efield;
    double * xpoints, * numEpoints;
    double * EigEnergies;
    double * EigPsi;
    double * numEigStates, *McE;
    
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
    deltax = mxGetPr(prhs[0]);
    xpoints = mxGetPr(prhs[1]);
    Vcx = mxGetPr(prhs[2]);
    Mcx = mxGetPr(prhs[3]);
    Egx = mxGetPr(prhs[4]);
    ESO = mxGetPr(prhs[5]);
    F   = mxGetPr(prhs[6]);
    material = mxGetPr(prhs[7]);
    Ep = mxGetPr(prhs[8]);
    EboundMin = mxGetPr(prhs[9]);
    EboundMax = mxGetPr(prhs[10]);
    Efield = mxGetPr(prhs[11]);
    numEpoints = mxGetPr(prhs[12]);
    
  /* Create a new array and set the output pointer to it. */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    numEigStates = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1,400, mxREAL);
    EigEnergies = mxGetPr(plhs[1]);
    plhs[2] = mxCreateDoubleMatrix(int(*xpoints),400, mxREAL);
    EigPsi = mxGetPr(plhs[2]);
    plhs[3] = mxCreateDoubleMatrix(1,400, mxREAL);
    McE = mxGetPr(plhs[3]);    
    
  /* Call the C subroutine. */
   
    solverH(deltax, xpoints, Vcx, Mcx, Egx, ESO, F, material, Ep, EboundMin,
        EboundMax, Efield, numEpoints, numEigStates, EigEnergies, EigPsi, McE);

    int EigEnergiesSize[1] = {int(*numEigStates)};
    mxSetDimensions(plhs[1],EigEnergiesSize,1);
    int EigPsiSize[2] = {int(*xpoints),int(*numEigStates)};
    mxSetDimensions(plhs[2],EigPsiSize,2);
    mxSetDimensions(plhs[3],EigEnergiesSize,1); 
    
    return;
}