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

% The program take the index of the upper levels and lower levels and
% calculate the broadening including intra, inter of total between every
% two states.

function [zero] = broadening(upInArry, lowInArry, McE, eigenE, correllength, roughfactor, psiIFR, normSquPsi)

    e0 = 1.60217653e-19;  % electron charge
    me = 9.10938188e-31;   % free electron mass (kg)
    hbar = 6.6260693e-34 / (2 * pi);  % Planck's constant (J s)

    deltaU = 520 * (10 ^ -3) * e0;  
    factorWFS = 2 * me * e0 / (hbar * hbar);
    partFactorIB = roughfactor * (deltaU * deltaU) / (0.001 * e0); 

    Nup = size(upInArry, 2);
    Nlow = size(lowInArry, 2);

    interBroad(Nup, Nlow) = 0;
    intraBroad(Nup, Nlow) = 0;
    totalBroad(Nup, Nlow) = 0;

    for i = 1 : Nup
        for j = 1 : Nlow  
            wavefacsqua = factorWFS * McE(upInArry(i)) * (eigenE(upInArry(i)) - eigenE(lowInArry(j)));
            factorInterBro = partFactorIB * exp(-1 * (correllength * correllength) * (wavefacsqua) / 4);
            interBroad(i, j) = factorInterBro * McE(upInArry(i)) .* ((psiIFR(:, upInArry(i)) .^ 2)' * (psiIFR(:, lowInArry(j)) .^ 2)) / (normSquPsi(upInArry(i)) * normSquPsi(lowInArry(j)));

            probfactor = ((psiIFR(:, upInArry(i)) .^ 2) ./ normSquPsi(upInArry(i))) - ((psiIFR(:, lowInArry(j)) .^ 2) ./ normSquPsi(lowInArry(j)));
            intraBroad(i, j) = partFactorIB * McE(upInArry(i)) .* (probfactor' * probfactor); % unit meV

            totalBroad(i, j) = 0.5 .* (interBroad(i, j) + intraBroad(i, j));
        end
    end

    fileNameInter = strcat('interBroad.txt');
    fileNameIntra = strcat('intraBroad.txt');
    fileNameTotal = strcat('totalBroad.txt');

    save(fileNameInter,'interBroad','-ascii')
    save(fileNameIntra,'intraBroad','-ascii')    
    save(fileNameTotal,'totalBroad','-ascii')

    assignin('base', 'interBroad', interBroad)
    assignin('base', 'intraBroad', intraBroad)
    assignin('base', 'totalBroad', totalBroad)
    zero = 0;
end
