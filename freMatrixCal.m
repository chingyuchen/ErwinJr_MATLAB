%{
Copyright (c) 2012-2016, Ching-Yu Chen
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
// THIS SOFTWARE IS PROVIDED BY Ching-Yu Chen ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL Ching-Yu Chen BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}

% Construct the frequency matrix of a given states array
function [freMatrix] = freMatrixCal(statesArry, psi, eigenE, xpoints, xRes, Vcx, Mcx, Egx, Temper, phononnum)
    
    epsstatic = 13.9;
    epshighf = 11.6;
    hwlo = 0.034;
    kp0 = 64;

    statesNum = size(statesArry, 2);
    maxIn = max(statesArry);
    freMatrix(maxIn, maxIn) = 0;  % The array size is the max index of the state in the states array, which mean the highest energy level in the chosen two stages
    
    for i = 1 : statesNum
        for j = (i + 1) : statesNum      
            if statesArry(i) > statesArry(j)
                lf = lifetime(psi(:, statesArry(i)), eigenE(statesArry(i)), psi(:, statesArry(j)), eigenE(statesArry(j)),...
                            xpoints, xRes, Vcx, Mcx, Egx, Temper, epsstatic,...
                            epshighf, hwlo, kp0);   
                freHL = 1 / lf;
                freLH = freHL * (phononnum / (1 + phononnum));
                freMatrix(statesArry(i), statesArry(j)) = freHL;  % rate from i to j
                freMatrix(statesArry(j), statesArry(i)) = freLH;  % rate from j to i
            else
                lf = lifetime(psi(:, statesArry(j)), eigenE(statesArry(j)), psi(:, statesArry(i)), eigenE(statesArry(i)),...
                            xpoints, xRes, Vcx, Mcx, Egx, Temper, epsstatic,...
                            epshighf, hwlo, kp0);   
                freHL = 1 / lf;
                freLH = freHL * (phononnum / (1 + phononnum));
                freMatrix(statesArry(i), statesArry(j)) = freLH;  % rate from i to j
                freMatrix(statesArry(j), statesArry(i)) = freHL;  % rate from j to i
            end
        end
    end
    save('freMatrix.txt','freMatrix','-ascii');
end