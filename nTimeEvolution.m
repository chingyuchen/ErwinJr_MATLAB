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

% The program calculate the time evolution of the electron distribution on
% each level with the given time step [ps], end time [ps], rate equation 
% coeffiecient and initial conditions.  
% The actual time evoltion would be calculated in (0.1 * dt) time 
% step, but save in dt time step.

function [nTE, nTEPer, nss, nssSysStates, nsDiff] = nTimeEvolution(dt, tEnd, reqnC, nIC, numSysState, periIn, nonPeriIn)
    tEnd = tEnd / dt;  % change the tEnd unit from [ps] to number of time step
    dt = dt * (10 ^ -12) * 0.1; % unit s
    dimen = size(reqnC, 1);
    nssSysStates(numSysState) = 0;
    nss(dimen) = 0;
    nt = nIC;
    ns = sum(nt);  % total doped sheet density
    
    nt = nt';
    for t = 1 : tEnd   %from 0.01 ps to 10 ps
        nt = ((reqnC * dt + eye(dimen)) ^ 10) * nt; % n(t + dt * 10) = ((I + [dn/dt] * dt) ^ 10) * n(t)
        nTE(t, :) = nt;
        
        nsDiff(t) = sum(nt) - ns; % The deviation of ns after dt of evolution
        nt = nt - (nsDiff(t) / dimen); % Calibrate n(t) by subtracting the deviation of the (sheet denisty / states)
    end
    nTEPer = nTE ./ ns;

    for i = 1 : dimen
        nssSysStates(periIn(i)) = nTE(tEnd, i);
        nssSysStates(nonPeriIn(i)) = nTE(tEnd, i);
        nss(i) = nTE(tEnd, i);
    end
end