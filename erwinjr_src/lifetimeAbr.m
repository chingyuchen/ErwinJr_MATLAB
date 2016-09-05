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

function tauij = lifetimeAbr(state1, state2)

hErwinJr = getappdata(0,'hErwinJr');
data = getappdata(hErwinJr,'data');
states = [state1 state2];
states = sort(states);

cutoff_factor = 0.0005;

firstx1 = find(data.PsiSqr(:,states(1)) > cutoff_factor,1,'first');
lastx1 = find(data.PsiSqr(:,states(1)) > cutoff_factor,1,'last');
firstx2 = find(data.PsiSqr(:,states(2)) > cutoff_factor,1,'first');
lastx2 = find(data.PsiSqr(:,states(2)) > cutoff_factor,1,'last');

if firstx1 < firstx2
    firstx = firstx1;
else
    firstx = firstx2;
end

if lastx1 > lastx2
    lastx = lastx1;
else
    lastx = lastx2;
end

% firstx = floor(firstx - 0.1 * data.xpoints * data.xres);
% lastx = floor(lastx + 0.1 * data.xpoints * data.xres);

if firstx > lastx
    lt = 1e20;
    return
end

% firstx1 = 1;
% lastx1 = data.xpoints;
% firstx2 = 1;
% lastx2 = data.xpoints;

% lt = lifetime(data.Psi(firstx:lastx,states(2)), data.EigenE(states(2)), data.Psi(firstx:lastx,states(1)), data.EigenE(states(1)),...
%           length(firstx:lastx)+1, data.xres, data.Vcx(firstx:lastx), data.Mcx(firstx:lastx), data.Egx(firstx:lastx), data.Temp, data.epsstatic,...
%           data.epshighf, data.hwlo, data.kp0)
% 
tic
lt = lifetime(data.Psi(:,states(2)), data.EigenE(states(2)), data.Psi(:,states(1)), data.EigenE(states(1)),...
          data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
          data.epshighf, data.hwlo, data.kp0)      
toc

%  new code

tic

m0 = 9.109E-31;

Psii = data.Psi(:,state2);
Psij = data.Psi(:,state1);

Qp = sqrt(2*data.McE(state2)*m0* data.e0 / data.hbar.^2 * (data.EigenE(state2)-data.EigenE(state1)-data.hwlo));

% Iij = 0;
% for n = 1:data.xpoints
%     for m = 1:data.xpoints
%         dIij = Psii(m) * Psij(m) * exp(-Qp*abs(data.x(n)-data.x(m))*1e-10) * Psii(n) * Psij(n) * (data.xres*1e-10).^2;
%         Iij = Iij + dIij;
%     end
% end

[nmatx,mmatx]=meshgrid(data.x,data.x');
Iij = sum(sum((Psii .* Psij) * (Psii .* Psij)' .* exp(-Qp*abs(nmatx-mmatx)*1e-10) * (data.xres*1e-10).^2));

% PsiTPsii=0;
% PsiTPsij=0;
% for q = 1:data.xpoints
%     PsiTPsii = PsiTPsii + Psii(q) * ((data.EigenE(state2)-data.Vcx(q))/(data.EigenE(state2)-data.Vcx(q)+data.Egx(q))) * Psii(q) * data.xres*1e-10;
%     PsiTPsij = PsiTPsij + Psij(q) * ((data.EigenE(state1)-data.Vcx(q))/(data.EigenE(state1)-data.Vcx(q)+data.Egx(q))) * Psij(q) * data.xres*1e-10;
% end

PsiTPsii = sum(Psii.^2 .* ((data.EigenE(state2)-data.Vcx)./(data.EigenE(state2)-data.Vcx+data.Egx)) .*  data.xres*1e-10);
PsiTPsij = sum(Psij.^2 .* ((data.EigenE(state1)-data.Vcx)./(data.EigenE(state1)-data.Vcx+data.Egx)) .*  data.xres*1e-10);

inversetauij = (data.McE(state2)*m0*(data.e0/data.hbar).^3 * data.hwlo/(4* data.eps0 * data.kp0))*(1e-10*Iij/(1e-10*Qp)) * (1+PsiTPsii)*(1+PsiTPsij);

tauij = 1e12/inversetauij;
toc


