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

% The program calculate the IC of electron density on the enery level based
% on the total doped electron density, the integration of the Fermi
% distribution and the DOS and the probability of the state in the doped
% area.

function nIC = nICAll(xAvg, eigenE, Efield, McE, psi, xRes, normSquPsi, x0, x1, wellWidths, nn, Temper)

    e0 = 1.60217653e-19;  % electron charge
    me = 9.10938188e-31;   % free electron mass (kg)
    h = 6.6260693e-34;  % Planck's constant (J s)
    kb = 1.386505e-23 / e0; % eV / K
    mn = 0.065 * me;
    ni = 6.3 * (10 ^ 11); % intrinsic carrier concentration at 300 K, unit (1/cm^3), http://www.ioffe.ru/SVA/NSM/Semicond/GaInAs/bandstr.html, should be (10^11), assume that it is doped to (10^17)

    NcFactor = 2 * ((2 * pi * mn * kb * e0 / (h * h)) ^ (3 / 2)) / (10 ^ 6); % m^3 to cm^3, kb unit is (e), electron charge
    NcRT = NcFactor * (300 ^ 1.5);
    NcT = NcFactor * (Temper ^ 1.5);
    dopex0 = sum(wellWidths) + x0; % doping position start point in the period, unit angstrom
    dopex1 = sum(wellWidths) + x1; % doping end point in the period, unit angstrom
    dopex0index = dopex0 / xRes; % doping position start point index
    dopex1index = dopex1 / xRes; % doping position end point index
    nperiod = nn * (dopex1 - dopex0) * (10 ^ (-8)); % total electron density in one peiod per unit area

    deltaEcfi = kb * 300 * log(NcRT / ni); % unit eV, energy difference between conduction band and non-doped Fermi level
    deltaEffi = kb * 300 * log(nn / ni); % unit eV, assume fully ionized at RT

    biasEc = 0.08 - Efield .* (xAvg) .* (10 ^ 5);   % bias energy of active region, unit eV, (10^-5) change bias unit from (kV/cm) into (V/m)
    dE = 0.0001 .* e0;  % integrate energy unit in J, 0.0001 eV = 0.1 meV = (0.0001V * e0) J

    statesNum = size(psi, 2);
    offsetCB = 520 / 0.1;  % CB offset in unit [0.1meV]
    kbT = kb * Temper;
    gFactor = (4 * pi * me) / (h * h);
    for q = 1 : statesNum
        addup = 0;
        for i = 1 : offsetCB
            f(i) = 1 ./ (1.+ exp(((eigenE(q) - biasEc(q)) + deltaEcfi + ((dE / e0) * i)) ./ kbT));
            g(i) = gFactor * McE(q);
            addup = addup + g(i).* f(i).* dE;
        end
        nICFG(q) = addup;   % initial conditions for electrons distrubution = integrate(density of quantum states * fermi distribution), unit#/m^3
        nDopedProb(q) = (psi(dopex0index : dopex1index, q)' * psi(dopex0index : dopex1index, q) * xRes * (10 ^ -10)) ./ normSquPsi(q);
        nICWeight(q) =  nICFG(q) * nDopedProb(q);
    end

    nICWeightTotal = sum (nICWeight);
    nICWeight = nICWeight ./ nICWeightTotal;
    nIC = nperiod .* nICWeight;

end

%{
% METHOD 2----------20150330------------------------------------------------------- 
niT = NcT * exp(-1 * deltaEcfi / (data.kb * Temper))
nnT = niT * exp(deltaEffi / (data.kb * Temper))
assignin('base', 'nnT', nnT) 
save('nnT.txt','nnT','-ascii')

nperiod2 = nnT * (dopex1 - dopex0) * (10 ^ (-8)); % total electron density in one peiod per unit area
assignin('base', 'nperiod2', nperiod2) 
save('nperiod2.txt','nperiod2','-ascii')

deltaEcff = deltaEcfi - deltaEffi
biasEcDoped = 0.08 - data.Efield .* ((dopex0 + dopex1) * (10 ^ -10) / 2) .* (10 ^ 5) % bias energy of doped area, unit eV, (10^-5) change bias unit from (kV/cm) into (V/m)

for q = 1 : k
    addup = 0;
    for i = 1 : 5200
        f(i) = 1 ./ (1.+ exp(((data.EigenE(periodindex(q)) - biasEcDoped) + deltaEcff + ((dE / data.e0) .* i)) ./ (data.kb .* Temper)));
        g(i) = ((4 * pi * data.McE(periodindex(q)) .* data.me) ./ ((data.hbar * 2 * pi) ^ 2));
        addup = addup + g(i) .* f(i) .* dE;
    end
    nIC2(q) = addup;   % initial conditions for electrons distrubution = integrate(density of quantum states * fermi distribution), unit#/m^3
end
assignin('base', 'nIC2', nIC2) 
save('Initialcondition2.txt','nIC2','-ascii')
nICtotal2 = sum (nIC2);
assignin('base', 'nICtotal2', nICtotal2) 
save('nICtotal2.txt','nICtotal2','-ascii')
nICsolve = nIC2;
%}


