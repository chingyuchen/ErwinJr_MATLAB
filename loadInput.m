%{
Copyright (c) 2012-2017, Ching-Yu Chen
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
//       derivatives thereof must explicitly name Ching-Yu Chen in a section 
//       dedicated to acknowledgements or name Ching-Yu Chen as a co-author 
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

%{
%{-------------------------------------------------------------------------
    File: loadInput.m
    Author: Ching-Yu Chen
    Description: The function load the inputCnofig.dat to set the input
    parameters for the models of IFR scattering, the time evolution of the 
    electron distribution and the scattering current.
-------------------------------------------------------------------------%}
%}

function [T, roughmean, correllength, nn, x0, x1, dt, tEnd, periodIndex, ...
    nonperiodIndex, upInArray, lowInArray, statesInArray, upperLaserIn, ...
    preUpIn] = loadInput()

    filename = fullfile(pwd, 'inputConfig.dat');
    fileID = fopen(filename);
   
    T = scanNum(fileID, 'T = %d [K] %*[^\n]') % tenperature
    roughmean = scanNum(fileID, 'roughmean = %f [m]  %*[^\n]') % interface roughness mean height, unit meter, 0.15 nm
    correllength = scanNum(fileID, 'correllength = %f [m]  %*[^\n]') % correlation length, unit meter, 60 angstrom

    textscan(fileID, '-%s%*[^\n]');
    nn = scanNum(fileID, 'nn = %f [#/cm3] %*[^\n]') % doping density
    x0 = scanNum(fileID, 'x0 = %d [angstrom] %*[^\n]') % doping initial position
    x1 = scanNum(fileID, 'x1 = %d [angstrom] %*[^\n]') % dopint end position
    
    textscan(fileID, '-%s%*[^\n]');
    dt = scanNum(fileID, 'dt = %f [ps] %*[^\n]') % time evoluion timestep
    tEnd = scanNum(fileID, 'tEnd = %d [ps] %*[^\n]') % time evoltion endtime
    periodIndex = scanArray(fileID, 'periodindex = %s') %indices of states in the chosen period
    nonperiodIndex = scanArray(fileID, 'nonperiodindex = %s') %indices of states in the next period
    upInArray = scanArray(fileID, 'upInArry = %s')
    lowInArray = scanArray(fileID, 'lowInArry = %s')
    
    % current calculation parameters.
    textscan(fileID, '-%s%*[^\n]');
    statesInArray = scanArray(fileID, 'statesInArry = %s') % the state used to calculate current, involving electron scattering through the interface.
    upperLaserIn = scanNum(fileID, 'upperLaserIn = %d %*[^\n]') % for recognizing the coresponding nss of the preUp 
    preUpIn = scanNum(fileID, 'preUpIn = %d %*[^\n]')  % The index of upper laser level in the previous period, in case that there are lots of electron on this level that also has obvious contribution to current density
    
    fclose(fileID);

end

function [num] = scanNum(fileID, scanFormat)
    scan = textscan(fileID, scanFormat);
    num = scan{1};
end

function [array] = scanArray(fileID, scanFormat) 
    scanCell = textscan(fileID, scanFormat, 1, 'delimiter', '\n');
    array = str2num(cell2mat(scanCell{1}));
end