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




/* z32 = dipole(Psim,EigenEm,Psin,EigenEn,xpoints,Vcx,Mcx,Egx)
 * =============================================================
 * This function calculates the effective optical dipole matrix element for
 *    an intersubband transition between states m & n
 * Physics by Daniel Wasserman
 * Implementation by Kale J. Franz
 * last updated 70819
 * =============================================================
 */

#include "mex.h"
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "matrix.h"

void Dipole(double * Psim, double * EigenEm, double * Psin, double * EigenEn,
            double * xpoints, double * Vcx, double * Mcx, double * Egx, double * z32)
//Psim: wavefunction value Psi_m(x) at every x point (array)
//Psin: wavefunction value Psi_n(x) at every x point (array)
//EigenEm: eigen energy for wavefunction Psi_m (scalar)
//EigenEn: eigen energy for wavefunction Psi_n (scalar)
//xpoints: number of x-axis points (scalar)
//Mcx: effective mass for every x point (array)
//Vcx: potential in Joules for every x point (array)
//Egx: bandgap matrix in Joules for every x point (array)
//z32: output, the optical dipole matrix element between Psi_m & Psi_n (scalar)

{
    double hbar = 6.626e-34 / 2 / 3.141592653589793;
    double m0 = 9.109e-31;
    double e0 = 1.602e-19;
    
    double dipole, z = 0;
    double Mcxm, Mcxn;
    double wmn = (*EigenEm - *EigenEn) / hbar * e0;
    
    for(int k = 0; k < *xpoints-1; k++)
    {
        //The following if statement incorporates nonparabolicity into the
        //effective masses of electrons and holes.  This is the two-band
        //model, as opposed to the three band model,  Described in Phys. Rev.
        //  B., V35, p.7770
        //Because we are dealing with two seperate effective masses, create a
        //joint effective mass
        
        if(*EigenEm > *(Vcx + k))
            Mcxm = *(Mcx + k) * (1 + (*EigenEm - *(Vcx + k)) / (*(Egx + k)));
        else
            Mcxm = *(Mcx + k) * (1 - (*(Vcx + k) - *EigenEm) / (*(Egx + k)));
        if (*EigenEn > *(Vcx + k))
            Mcxn = *(Mcx + k) * (1 + (*EigenEn - *(Vcx + k)) / (*(Egx + k)));
        else
            Mcxn = *(Mcx+k) * (1 - (*(Vcx + k) - *EigenEn) / (*(Egx + k)));
        
        //Dipole calculation uses derivation from PRB, v50, p8663, Sirtori, Faist, Capasso 
        dipole = 0.5 * hbar / (Mcxm * wmn) * ( (*(Psim+k)+*(Psim+k+1))/2 * (*(Psin+k+1)-*(Psin+k)) )  //k+1 will give the wrong result; invalid index
               + 0.5 * hbar / (Mcxn * wmn) * ( (*(Psim+k)+*(Psim+k+1))/2 * (*(Psin+k+1)-*(Psin+k)) );
        z += dipole;
    }
    
    *z32 = z * 1e10;  //converts to angstroms
}


/* The gateway routine. */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    double * Psim, * Psin;
    double * EigenEm, * EigenEn;
    double * xpoints;
    double * Mcx, * Vcx, * Egx;
    double * z32;
    
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
    Psim = mxGetPr(prhs[0]);
    EigenEm = mxGetPr(prhs[1]);
    Psin = mxGetPr(prhs[2]);
    EigenEn = mxGetPr(prhs[3]);
    xpoints = mxGetPr(prhs[4]);
    Vcx = mxGetPr(prhs[5]);
    Mcx = mxGetPr(prhs[6]);
    Egx = mxGetPr(prhs[7]);
    
  /* Create a new array and set the output pointer to it. */
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    z32 = mxGetPr(plhs[0]);
    
  /* Call the C subroutine. */
    Dipole(Psim, EigenEm, Psin, EigenEn, xpoints, Vcx, Mcx, Egx, z32);
    
    return;
}