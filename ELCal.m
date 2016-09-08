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

% The program calultate the EL of the system.

function [zero] = ELCal(nssLO, nssIR, nssWIR, psi, periIn, eigenE, xpoints, Vcx, Mcx, Egx)
    c0 = 299792458; 
    e0 = 1.60217653e-19;
    h = 6.6260693e-34;
    statesNum = size(periIn, 2);
    
    count = 1;
    for i = 1 : statesNum
        for j = 1 : (periIn(i) - 1)
            dp = dipole(psi(:, periIn(i)), eigenE(periIn(i)), psi(:, j), eigenE(j),...
                 xpoints, Vcx, Mcx, Egx);
            if abs(dp) > 0.1
                ELInform(count, 1) = c0 / ((eigenE(periIn(i)) - eigenE(j)) * e0 / h) * (10 ^ 6);  % wavelength unit um
                times = abs(((eigenE(periIn(i)) - eigenE(j)) .^ 4) * (dp ^ 2));  
                ELInform(count, 2) = abs(times * nssWIR(i));        % intensity, wIR
                ELInform(count, 3) = abs(times * nssLO(i));     % intensity, LO
                ELInform(count, 4) = abs(times * nssIR(i));     % intensity, IR
                ELInform(count, 5) = periIn(i);  % upper level index
                ELInform(count, 6) = j;   % lower level index
                ELInform(count, 7) = dp;  % dipole
                ELInform(count, 8) = (eigenE(periIn(i)) - eigenE(j)) * (10 ^ 3); % energy difference unit meV
                ELInform(count, 9) = nssWIR(i);   % n_ss
                ELInform(count, 10) = nssLO(i); 
                ELInform(count, 11) = nssIR(i); 
            end
            count = count + 1;
        end
    end
    
    % normalization
    maxELwIR = max(ELInform(:, 2));
    ELInform(:, 2) = ELInform(:, 2) ./ maxELwIR;
    maxELLO = max(ELInform(:, 3));
    ELInform(:, 3) = ELInform(:, 3) ./ maxELLO;
    maxELIR = max(ELInform(:, 4));
    ELInform(:, 4) = ELInform(:, 4) ./ maxELIR;
    
    save('ELInform.txt','ELInform','-ascii')
    
    parameterEL = ['wavelength (um) ' 'ELwIR ' 'ELLO ' 'ELIR ' 'upper level ' 'lower level ' 'dipole ' 'energy ' 'nsswIR ' 'nssLO ' 'nssIR '];
    fid = fopen('ELparameters.txt', 'wt');
    fprintf(fid, '%s', parameterEL);
    fclose(fid);
    zero = 0;
end