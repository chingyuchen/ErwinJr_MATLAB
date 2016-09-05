% Copyright (c) 2007-2008, Kale J. Franz
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code or derivatives thereof must retain the 
%       above copyright notice, this list of conditions and the following
%       disclaimer.
%     * Redistributions in binary form, and any binary file that is compiled 
%       from a derivative of this source code, must reproduce the above 
%       copyright notice, this list of conditions and the following disclaimer 
%       in the documentation and/or other materials provided with the 
%       distribution.
%     * Any publication, presentation, or other publicly or privately 
%       presented work having made use of or benefited from this software or 
%       derivatives thereof must explicitly name Kale J. Franz in a section 
%       dedicated to acknowledgements or name Kale J. Franz as a co-author 
%       of the work.
%     * Any use of this software that directly or indirectly contributes to 
%       work or a product for which the user is or will be remunerated must be 
%       further licensed through the Princeton Univeristy Office of Technology 
%       Licensing and the Princeton Univeristy Mid-Infrared Photonics Lab led 
%       by Professor Claire Gmachl prior to the transaction of said 
%       remuneration.  
% 
% THIS SOFTWARE IS PROVIDED BY Kale J. Franz ''AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL Kale J. Franz BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


function straincalc(handles, h)

params(handles);

st.h = h;

c = getappdata(handles.hErwinJr,'StrainConstants');
% st = getappdata(handles.hErwinJr,'stcomp');
data = getappdata(handles.hErwinJr,'data');

%only 1 set of materials for now
st.h = st.h(1:2);
% st.a_perp = st.a_perp(1:2);
% st.eps_perp = st.eps_perp(1:2);
% st.a0 = st.a0(1:2);
% st.eps_parallel = st.eps_parallel(1:2);
% st.c11 = st.c11(1:2);
% st.c12 = st.c12(1:2);

%calculations

st.a0(1) = data.InGaAsx*c.alc_AlAs  + (1-data.InGaAsx)*c.alc_GaAs;
st.a0(2) = data.AlInAsx*c.alc_AlAs  + (1-data.AlInAsx)*c.alc_GaAs;

st.a_parallel = c.alc_GaAs;

st.eps_parallel = st.a_parallel ./ st.a0 - 1; %Walle eqn 1b

st.c11(1) = data.InGaAsx*c.c11_AlAs + (1-data.InGaAsx)*c.c11_GaAs;
st.c11(2) = data.AlInAsx*c.c11_AlAs + (1-data.AlInAsx)*c.c11_GaAs;

st.c12(1) = data.InGaAsx*c.c12_AlAs + (1-data.InGaAsx)*c.c12_GaAs;
st.c12(2) = data.AlInAsx*c.c12_AlAs + (1-data.AlInAsx)*c.c12_GaAs;

st.a_perp  = st.a0 .* (1 - 2* st.c12 ./ st.c11 .* st.eps_parallel); %Walle eqn 2a

st.eps_perp = st.a_perp./st.a0 - 1; %Walle eqn 2b

st.mismatch = 100 * sum(st.h.*st.eps_perp) / sum(st.h);

st.EgG(1) = data.InGaAsx*c.EgG_AlAs + (1-data.InGaAsx)*c.EgG_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.EgG_AlGaAs(1);
st.EgL(1) = data.InGaAsx*c.EgL_AlAs + (1-data.InGaAsx)*c.EgL_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.EgL_AlGaAs;
st.EgX(1) = data.InGaAsx*c.EgX_AlAs + (1-data.InGaAsx)*c.EgX_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.EgX_AlGaAs;
st.VBO(1) = data.InGaAsx*c.VBO_AlAs + (1-data.InGaAsx)*c.VBO_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.VBO_AlGaAs;
st.DSO(1) = data.InGaAsx*c.DSO_AlAs + (1-data.InGaAsx)*c.DSO_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.DSO_AlGaAs;
st.me0(1) = data.InGaAsx*c.me0_AlAs + (1-data.InGaAsx)*c.me0_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.me0_AlGaAs;
st.acG(1) = data.InGaAsx*c.acG_AlAs + (1-data.InGaAsx)*c.acG_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.acG_AlGaAs;
st.acL(1) = data.InGaAsx*c.acL_AlAs + (1-data.InGaAsx)*c.acL_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.acL_AlGaAs;
st.acX(1) = data.InGaAsx*c.acX_AlAs + (1-data.InGaAsx)*c.acX_GaAs - data.InGaAsx*(1-data.InGaAsx)*c.acX_AlGaAs;
st.Ep(1)  = data.InGaAsx*c.Ep_AlAs  + (1-data.InGaAsx)*c.Ep_GaAs  - data.InGaAsx*(1-data.InGaAsx)*c.Ep_AlGaAs;
st.F(1)   = data.InGaAsx*c.F_AlAs   + (1-data.InGaAsx)*c.F_GaAs   - data.InGaAsx*(1-data.InGaAsx)*c.F_AlGaAs;
st.XiX(1) = data.InGaAsx*c.XiX_AlAs + (1-data.InGaAsx)*c.XiX_GaAs;
st.b(1)   = data.InGaAsx*c.b_AlAs   + (1-data.InGaAsx)*c.b_GaAs;
st.av(1)  = data.InGaAsx*c.av_AlAs  + (1-data.InGaAsx)*c.av_GaAs;
st.alG(1)  = data.InGaAsx*c.alG_AlAs  + (1-data.InGaAsx)*c.alG_GaAs;
st.beG(1)  = data.InGaAsx*c.beG_AlAs  + (1-data.InGaAsx)*c.beG_GaAs;
st.alL(1)  = data.InGaAsx*c.alL_AlAs  + (1-data.InGaAsx)*c.alL_GaAs;
st.beL(1)  = data.InGaAsx*c.beL_AlAs  + (1-data.InGaAsx)*c.beL_GaAs;
st.alX(1)  = data.InGaAsx*c.alX_AlAs  + (1-data.InGaAsx)*c.alX_GaAs;
st.beX(1)  = data.InGaAsx*c.beX_AlAs  + (1-data.InGaAsx)*c.beX_GaAs;

st.EgG(2) = data.AlInAsx*c.EgG_AlAs + (1-data.AlInAsx)*c.EgG_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.EgG_AlGaAs(2);
st.EgL(2) = data.AlInAsx*c.EgL_AlAs + (1-data.AlInAsx)*c.EgL_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.EgL_AlGaAs;
st.EgX(2) = data.AlInAsx*c.EgX_AlAs + (1-data.AlInAsx)*c.EgX_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.EgX_AlGaAs;
st.VBO(2) = data.AlInAsx*c.VBO_AlAs + (1-data.AlInAsx)*c.VBO_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.VBO_AlGaAs;
st.DSO(2) = data.AlInAsx*c.DSO_AlAs + (1-data.AlInAsx)*c.DSO_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.DSO_AlGaAs;
st.me0(2) = data.AlInAsx*c.me0_AlAs + (1-data.AlInAsx)*c.me0_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.me0_AlGaAs;
st.acG(2) = data.AlInAsx*c.acG_AlAs + (1-data.AlInAsx)*c.acG_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.acG_AlGaAs;
st.acL(2) = data.AlInAsx*c.acL_AlAs + (1-data.AlInAsx)*c.acL_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.acL_AlGaAs;
st.acX(2) = data.AlInAsx*c.acX_AlAs + (1-data.AlInAsx)*c.acX_GaAs - data.AlInAsx*(1-data.AlInAsx)*c.acX_AlGaAs;
st.Ep(2)  = data.AlInAsx*c.Ep_AlAs  + (1-data.AlInAsx)*c.Ep_GaAs  - data.AlInAsx*(1-data.AlInAsx)*c.Ep_AlGaAs;
st.F(2)   = data.AlInAsx*c.F_AlAs   + (1-data.AlInAsx)*c.F_GaAs   - data.AlInAsx*(1-data.AlInAsx)*c.F_AlGaAs;
st.XiX(2) = data.AlInAsx*c.XiX_AlAs + (1-data.AlInAsx)*c.XiX_GaAs;
st.b(2)   = data.AlInAsx*c.b_AlAs   + (1-data.AlInAsx)*c.b_GaAs;
st.av(2)  = data.AlInAsx*c.av_AlAs  + (1-data.AlInAsx)*c.av_GaAs;
st.alG(2)  = data.AlInAsx*c.alG_AlAs  + (1-data.AlInAsx)*c.alG_GaAs;
st.beG(2)  = data.AlInAsx*c.beG_AlAs  + (1-data.AlInAsx)*c.beG_GaAs;
st.alL(2)  = data.AlInAsx*c.alL_AlAs  + (1-data.AlInAsx)*c.alL_GaAs;
st.beL(2)  = data.AlInAsx*c.beL_AlAs  + (1-data.AlInAsx)*c.beL_GaAs;
st.alX(2)  = data.AlInAsx*c.alX_AlAs  + (1-data.AlInAsx)*c.alX_GaAs;
st.beX(2)  = data.AlInAsx*c.beX_AlAs  + (1-data.AlInAsx)*c.beX_GaAs;


% for In0.53Ga0.47As, EcG = 0.2686396
%    use this as a zero point baseline

baseln = 0.622482142857143;

st.Pec = (2*st.eps_parallel+st.eps_perp) .* (st.acG);
st.Pe = 2*st.av .* (st.c11-st.c12) ./ st.c11 .* st.eps_parallel;
st.Qe = - st.b .* (st.c11+2*st.c12) ./ st.c11 .* st.eps_parallel;
st.Varsh = - st.alG*c.Temp.^2./(c.Temp+st.beG);

st.EcG = st.VBO + st.EgG + st.Pec + st.Pe + st.Varsh - baseln;

st.EcL = st.VBO + st.EgL + (2*st.eps_parallel+st.eps_perp) .* (st.acL+st.av) - baseln;

st.EcX = st.VBO + st.EgX + (2*st.eps_parallel+st.eps_perp).*(st.acX+st.av) + 2/3 .* st.XiX .* (st.eps_perp-st.eps_parallel) - baseln;

% calculations for effective mass
%  in part following Sugawara, PRB 48, 8102 (1993)

st.EgLH = st.EgG + st.Pec + st.Pe + st.Varsh - 1/2*(st.Qe - st.DSO + sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2));
st.EgSO = st.EgG + st.Pec + st.Pe + st.Varsh - 1/2*(st.Qe - st.DSO - sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2));
st.ESO  = sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2);

% st.alpha = (st.Qe + st.DSO + sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2)) ./ (2*sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2));
% st.beta = (-st.Qe - st.DSO + sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2)) ./ (2*sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2));
% st.alpha = st.alpha ./ sqrt(st.alpha.^2 + st.beta.^2);
% st.beta = st.beta ./ sqrt(st.alpha.^2 + st.beta.^2);

st.me = 1 ./ ((1+2*st.F) + st.Ep./st.EgLH.*(st.EgLH+2/3*st.ESO)./(st.EgLH + st.ESO));

% st.me2 = 1 ./ ((1+2*st.F) + st.Ep/3 .*( (sqrt(2)*st.alpha-st.beta).^2 ./ st.EgLH + (sqrt(2)*st.beta+st.alpha).^2 ./ (st.EgLH + st.ESO))); %using Igor's Ep instead of the calculated P2
% st.me3 = 1 ./ ((1+2*st.F) + st.Ep/3 .*( 2 ./ st.EgLH + 1 ./ (st.EgLH + st.ESO)));
% st.me4 = 1 ./ ((1+2*st.F) + st.Ep/3 .*( 2 ./ st.EgLH + 1 ./ (st.EgSO)));


%other code that I've junked for some reason or other

% st.EgAV = st.EgG - st.alG*c.Temp.^2./(c.Temp+st.beG) + (2*st.eps_parallel+st.eps_perp) .* (st.acG+st.av);
% st.EgEG = st.EgAV + 1/3*st.ESO;

% st.P2 = 1/2 .* (1./st.me0 - (1+2*st.F)/1) .* st.EgG .* (st.EgG+st.DSO) ./ (st.EgG+2/3*st.DSO); %strain independent

% st.P2 = 1/2 .* (1./st.me0 - (1+2*st.F)/1) .* st.EgLH .* (st.EgLH+st.ESO) ./ (st.EgLH+2/3*st.ESO);

% Pe = 2*st.acG .* (st.c11-st.c12) ./ st.c11 .* st.eps_parallel;
% Elh = -Pe + 1/2 * (st.Qe - st.DSO + sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2))


% Elh = -Pe + 1/2 * (st.Qe - st.DSO + sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2));
% Eso = -Pe + 1/2 * (st.Qe - st.DSO - sqrt(9*st.Qe.^2+2*st.Qe.*st.DSO+st.DSO.^2));

% st.me = 1 ./ ((1+st.F) + 2*st.P2/3 .*( (sqrt(2)*st.alpha-st.beta).^2 ./ st.EgLH + (sqrt(2)*st.beta+st.alpha).^2 ./ st.EgSO));
% st.me3 = 1 ./ ((2+2*st.F) + st.Ep.*(st.EgLH + 2/3*st.ESO) ./ st.EgLH ./ (st.EgLH + st.ESO) ); %using Igor's effective mass formula
% st.me4 = st.EgAV ./ st.Ep;

setappdata(handles.hErwinJr,'stcomp',st);
