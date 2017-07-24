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

% Construct the matrix JMatrixFow and JMatrixBack record each level
% scattering current contribution. Each of the column is the state to be scattered
% to, the rows are the states scattered from.

% to change: add freMatrix into input parameters.
function [JtotalWOPre] = JCalwoPre(nssIF, runIF, probAllL, probAllR, statesInArry, freMatrix)

    numStates = size(statesInArry, 2);
    Jtotal = 0;
    JMatrixFow(numStates, numStates) = 0;
    JMatrixBack(numStates, numStates) = 0;
    JNet(numStates, numStates) = 0;
    JStates(numStates) = 0;
    injEffiWOPre(numStates) = 0;
    
    for i = 1 : numStates                   % calculate current
        lf = 0;
        for j = (i + 1) : numStates  
              if statesInArry(i) > statesInArry(j)  % state i energy is higher than state j
                 freHL = freMatrix(statesInArry(i), statesInArry(j)); 
                 freLH = freMatrix(statesInArry(j), statesInArry(i));

                 %JtotalWOIF = JtotalWOIF + nssIF(i) * interfaceIn;

                 JMatrixFow(i, j) = nssIF(i) * probAllL(i) * probAllR(j) * freHL;  % from state i to state j, left to right, higher to lower.
                 JMatrixFow(j, i) = nssIF(j) * probAllL(j) * probAllR(i) * freLH;  % from state j to state i, left to right, lower to higher.
                 JMatrixBack(i, j) = nssIF(i) * probAllR(i) * probAllL(j) * freHL; % from state i to state j, right to left, higher to lower.
                 JMatrixBack(j, i) = nssIF(j) * probAllR(j) * probAllL(i) * freLH; % from state j to state i, right to left, lower to higher.               

              else if statesInArry(j) > statesInArry(i)  % state j energy is higher than state i
                 freHL = freMatrix(statesInArry(j), statesInArry(i));
                 freLH = freMatrix(statesInArry(i), statesInArry(j));

                 % JtotalWOIF(runIF) = JtotalWOIF(runIF) + nssIF(i) * freLH;

                 JMatrixFow(i, j) = nssIF(i) * probAllL(i) * probAllR(j) * freLH;  % from state i to state j, left to right, lower to higher.
                 JMatrixFow(j, i) = nssIF(j) * probAllL(j) * probAllR(i) * freHL;  % from state j to state i, left to right, higher to lower.
                 JMatrixBack(i, j) = nssIF(i) * probAllR(i) * probAllL(j) * freLH; % from state i to state j, right to left, lower to higher.
                 JMatrixBack(j, i) = nssIF(j) * probAllR(j) * probAllL(i) * freHL; % from state j to state i, right to left, higher to lower.

              end    
              Jtotal = Jtotal + JMatrixFow(i, j) + JMatrixFow(j, i) - JMatrixBack(i, j) - JMatrixBack(j, i);
        end
        end
   
    filecount= int2str(runIF);    
    preJMatrixFow = JMatrixFow;
    preJMatrixBack = JMatrixBack;
    paranamePreFow = 'preJMatrixFow.txt';
    paranamePreBack = 'preJMatrixBack.txt';
    filenamePreFow = strcat(filecount, paranamePreFow);
    filenamePreBack = strcat(filecount, paranamePreBack);
    save(filenamePreFow,'preJMatrixFow','-ascii');
    save(filenamePreBack,'preJMatrixBack','-ascii');
    
    JtotalWOPre = Jtotal * 1.6 * (10 ^ -10); % totalcurrent, unit (kA/cm^2); % totalcurrent, original unit [number / cm ^ 2 * ps]
    preJMatrixFow2 = JMatrixFow * 1.6 * (10 ^ -10);
    preJMatrixBack2 = JMatrixBack * 1.6 * (10 ^ -10);
    JMatrixFow = JMatrixFow * 1.6 * (10 ^ -10);  % unit (kA/cm^2)
    JMatrixBack = JMatrixBack * 1.6 * (10 ^ -10);  % unit (kA/cm^2)
    JNet = (JMatrixFow - JMatrixBack); % unit (kA/cm^2)
    
    for i = 1 : numStates 
         JStates(i) = sum(JNet(:, i)); % totalcurrent, unit (kA/cm^2); 
    end
   
    injEffiWOPre = JStates ./ JtotalWOPre;
    
    paranamePreFow2 = 'preJMatrixFow2.txt';
    paranamePreBack2 = 'preJMatrixBack2.txt';
    paranameFow = 'JMatrixFow.txt';
    paranameBack = 'JMatrixBack.txt';
    paranameJNet = 'JNet.txt';
    paranameJStates = 'JStates.txt';
    parainjEffiWOPre = 'injEffiWOPre.txt';
    
    filenamePreFow2 = strcat(filecount, paranamePreFow2);
    filenamePreBack2 = strcat(filecount, paranamePreBack2);
    filenameFow = strcat(filecount, paranameFow);
    filenameBack = strcat(filecount, paranameBack);
    filenameJNet = strcat(filecount, paranameJNet);
    filenameJStates = strcat(filecount, paranameJStates);
    fileinjEffiWOPre = strcat(filecount, parainjEffiWOPre);
    
    save(filenamePreFow2,'preJMatrixFow2','-ascii');
    save(filenamePreBack2,'preJMatrixBack2','-ascii');
    save(filenameFow,'JMatrixFow','-ascii');
    save(filenameBack,'JMatrixBack','-ascii');
    save(filenameJNet,'JNet','-ascii');
    save(filenameJStates,'JStates','-ascii');
    save(fileinjEffiWOPre,'injEffiWOPre','-ascii');
    
end