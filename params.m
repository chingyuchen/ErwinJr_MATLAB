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


function params(handles)
c = getappdata(handles.hErwinJr,'StrainConstants');
data = getappdata(handles.hErwinJr,'data');

c.Temp=data.Temp;

% GaAs constants
 %from Vurgaftman
 c.alc_GaAs = 5.65325 + 3.88e-5*(c.Temp-300); %Å at 80 K
 c.c11_GaAs = 1221; %GPa
 c.c12_GaAs = 566;  %GPa
 c.EgG_GaAs = 1.519; %eV at 0 K 
 c.EgL_GaAs = 1.815; %eV
 c.EgX_GaAs = 1.981; %eV
 c.VBO_GaAs = -0.80; %eV
 c.DSO_GaAs = 0.341; %eV Delta_SO from top of valence band
 c.acG_GaAs = -7.17; %eV
 c.acL_GaAs = -4.91; %eV, NextNano DB
 c.acX_GaAs = -0.16; %eV, NaxtNano DB
 c.av_GaAs  = -1.16; %eV, valence band deformation potential
 c.b_GaAs   = -2.0;  %eV, Pikus Burr Uniaxial Strain deformation potential
 c.XiG_GaAs = 0; %eV, uniaxial deformation potential, NextNano DB
 c.XiL_GaAs = 6.5; %eV
 c.XiX_GaAs = 14.26; %eV
 c.me0_GaAs = 0.067; %1/m0
 c.Ep_GaAs  = 28.8; %eV
 c.F_GaAs   = -1.94;
 c.alG_GaAs = 0.5405e-3; %eV/K, Varshni alpha(Gamma)
 c.beG_GaAs = 204; %K, Varshni beta(Gamma)
 c.alX_GaAs = 0.460e-3;
 c.beX_GaAs = 204;
 c.alL_GaAs = 0.605e-3;
 c.beL_GaAs = 204;
 
% InAs constants
 %from Vurgaftman
 c.alc_InAs = 6.0583 + 2.74e-5*(c.Temp-300);
 c.c11_InAs = 832.9;
 c.c12_InAs = 452.6;
 c.EgG_InAs = 0.417;
 c.EgL_InAs = 1.133;
 c.EgX_InAs = 1.433;
 c.VBO_InAs = -0.59;
 c.DSO_InAs = 0.39;
 c.acG_InAs = -5.08;
 c.acL_InAs = -3.89; %eV, NextNano DB
 c.acX_InAs = -0.08; %eV, NextNano DB
 c.av_InAs  = -1.00;
 c.b_InAs   = -1.8;
 c.XiG_InAs = 0;
 c.XiL_InAs = 11.35;
 c.XiX_InAs = 3.7;
 c.me0_InAs = 0.026;
 c.Ep_InAs  = 21.5;
 c.F_InAs   = -2.9;
 c.alG_InAs = 0.276e-3; 
 c.beG_InAs = 93; 
 c.alX_InAs = 0.276e-3;
 c.beX_InAs = 93;
 c.alL_InAs = 0.276e-3;
 c.beL_InAs = 93;
  
 
% AlAs constants
 %from Vurgaftman
 c.alc_AlAs = 5.6611 + 2.90e-5*(c.Temp-300);
 c.c11_AlAs = 1250;
 c.c12_AlAs = 534;
 c.EgG_AlAs = 3.099;
 c.EgL_AlAs = 2.46;
 c.EgX_AlAs = 2.24;
 c.VBO_AlAs = -1.33;
 c.DSO_AlAs = 0.28;
 c.acG_AlAs = -5.64;
 c.acL_AlAs = -3.07; %NextNano DB
 c.acX_AlAs = 2.54;  %NextNano DB
 c.av_AlAs  = -2.47;
 c.b_AlAs   = -2.3;
 c.XiG_AlAs = 0;
 c.XiL_AlAs = 11.35;
 c.XiX_AlAs = 6.11;
 c.me0_AlAs = 0.15;
 c.Ep_AlAs  = 21.1;
 c.F_AlAs   = -0.48;
 c.alG_AlAs = 0.855e-3;
 c.beG_AlAs = 530;
 c.alX_AlAs = 0.70e-3;
 c.beX_AlAs = 530;
 c.alL_AlAs = 0.605e-3;
 c.beL_AlAs = 204;
 
 
% InP constants
 c.alc_InP = 5.8697+2.79e-5*(c.Temp-300);

% InGaAs constants
 c.EgG_InGaAs = 0.477;
 c.EgL_InGaAs = 0.33;
 c.EgX_InGaAs = 1.4;
 c.VBO_InGaAs = -0.38;
 c.DSO_InGaAs = 0.15;
 c.acG_InGaAs = 2.61;
 c.acL_InGaAs = 2.61; %NextNano DB
 c.acX_InGaAs = 2.61; %NextNano DB
 c.me0_InGaAs = 0.0091;
 c.Ep_InGaAs  = -1.48;
 c.F_InGaAs   = 1.77;
 
% AlInAs constants
 c.EgG_AlInAs = 0.70;
 c.EgL_AlInAs = 0;
 c.EgX_AlInAs = 0;
 c.VBO_AlInAs = -0.64;
 c.DSO_AlInAs = 0.15;
 c.acG_AlInAs = -1.4;
 c.acL_AlInAs = -1.4; %NextNano DB
 c.acX_AlInAs = -1.4; %NextNano DB
 c.me0_AlInAs = 0.049;
 c.Ep_AlInAs  = -4.81;
 c.F_AlInAs   = -4.44;
 
 % AlGaAs constants
 c.EgG_AlGaAs = -0.127+1.310 * [data.InGaAsx data.AlInAsx];
 c.EgL_AlGaAs = 0.055;
 c.EgX_AlGaAs = 0;
 c.VBO_AlGaAs = 0;
 c.DSO_AlGaAs = 0;
 c.acG_AlGaAs = 0;
 c.acL_AlGaAs = 0;
 c.acX_AlGaAs = 0;
 c.me0_AlGaAs = 0;
 c.Ep_AlGaAs  = 0;
 c.F_AlGaAs   = 0;
 
 setappdata(handles.hErwinJr,'StrainConstants',c);