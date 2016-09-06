function varargout = erwinjr(varargin)
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

% Begin initialization code - DO NOT EDIT
addpath([pwd '\erwinjr_src'],'-begin')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @erwinjr_OpeningFcn, ...
                   'gui_OutputFcn',  @erwinjr_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before erwinjr is made visible.
function erwinjr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to erwinjr (see VARARGIN)

% Choose default command line output for erwinjr
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

setappdata(0,'hErwinJr',gcf);
hErwinJr = getappdata(0,'hErwinJr');
handles.hErwinJr = hErwinJr;

data.button = mesgdlg;
if strcmp(data.button,'meh')
    delete(hObject);
    return;
end

set(handles.descDisplay,'String','Structure Description'); %set default for description display field in top left of gui
    data.fileDesc = 'Structure Description';
data.xres = 1;
set(handles.xpointsDisplay,'String',[num2str(data.xres) 'ang']); %initialization value for the number of solve points in the spatial direction
data.Eres = 0.5;
set(handles.EpointsDisplay,'String',[num2str(data.Eres) ' meV']); %intialization for number of energy points
data.Temp = 300;
data.TempFoM = 220;
set(handles.EfieldDisplay,'String','0 kV/cm');
    data.Efield = 0.001;
set(handles.materialDisplay,'Value',4);
    data.material = 4;
data.regionNum = 1;
data.wellWidths = 1;
data.barrierSwitch = 0;
data.arSwitch = 0;
data.doping = 0;
data.divider = 0;
data.thickstates = 2.5;
data.thinstates = 1.5;
data.sc_count = 0;
data.padding = 0;
data.wfNormArea = 4.5e-10;
data.InGaAsx = 0.53;
data.AlInAsx = 0.52;
stcomp.Eoffset = 0.520;
data.Eoffset = 0.520;
data.inputmode = 0;
data.total_doping = 0;
data.solver = 'SolverH';
set(handles.display_Solver,'Value',3);
data.layermod = 0;
data.showSCplots = 0;
data.fileName = '';
data.mainPlotmod = 10;
data.Ld = 0;
data.PlotPeriods = 1;
data.flagLvalley = 0;
data.flagXvalley = 0;

data.undoSwitch = 0;
data.undo1 = [];
data.undo2 = [];
data.PsiSqr = [];
data.PsiSqrPlot = [];

data.ARsensitivity = 0.40;
data.PrettyPlotFactor = 0.0005;

% Enter constants into program
data.e0 = 1.60217653e-19;  %electron charge
data.eps0 = 8.85e-12;
data.me=9.10938188e-31;   %free electron mass (kg)
data.hbar = 6.6260693e-34/(2*pi); %Planck's constant (J s)
data.kb = 1.386505e-23 / data.e0; %eV/K
%  End constants

data.colors = [0,0,1;
          0,0.5,0;
          1,0,0;
          0,0.6,0.6;
          0.75,0,0.75;
          0.2,0.2,0.2;
          0.75,0.75,0];
      
%initialize background colors of info boxes to gray      
set(handles.endiffDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.arEnergiesDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.selfconDisp,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.stateinfoDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
if ~strcmp(data.button,'yip'); delete(hObject); return; end
set(handles.strainDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.display_FoM3,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.display_Lplength,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));


% try
%     load 'lastconfig.mat'
%     
% catch
%     
% end


setappdata(handles.hErwinJr,'stcomp',stcomp);
guidata(hObject, handles);
setappdata(handles.hErwinJr,'data',data);

    
% UIWAIT makes erwinjr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = erwinjr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figureh
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
try
varargout{1} = handles.output;
catch
end


function wellDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to wellDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wellDisplay as text
%        str2double(get(hObject,'String')) returns contents of wellDisplay as a double
data = getappdata(handles.hErwinJr,'data');
if get(handles.selfconButton,'Value')
    errordlg('Cannot update structure in self-consistent mode.')
    region = get(handles.regionList,'Value');
    set(handles.wellDisplay,'String',num2str(data.wellWidths(region)));
    guidata(hObject,handles);
    return
end
region = get(handles.regionList,'Value');
newWidth = str2double(get(handles.wellDisplay,'String'));
data.wellWidths(region) = newWidth;
data.layermod = 1;
guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function wellDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wellDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in barrierCheck.
function barrierCheck_Callback(hObject, eventdata, handles)
% hObject    handle to barrierCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of barrierCheck
data = getappdata(handles.hErwinJr,'data');
barrier = get(handles.barrierCheck,'Value');
region = get(handles.regionList,'Value');
data.barrierSwitch(region) = barrier;
data.layermod = 1;
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes on button press in arCheck.
function arCheck_Callback(hObject, eventdata, handles)
% hObject    handle to arCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of arCheck
data = getappdata(handles.hErwinJr,'data');
ar = get(handles.arCheck,'Value');
region = get(handles.regionList,'Value');
data.arSwitch(region) = ar;
data.layermod = 1;
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);


function descDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to descDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of descDisplay as text
%        str2double(get(hObject,'String')) returns contents of descDisplay as a double
data = getappdata(handles.hErwinJr,'data');
data.fileDesc = get(handles.descDisplay,'String');
data.layermod = 1;
guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);


% --- Executes during object creation, after setting all properties.
function descDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filepathDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to filepathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepathDisplay as text
%        str2double(get(hObject,'String')) returns contents of filepathDisplay as a double


% --- Executes during object creation, after setting all properties.
function filepathDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in regionList.
function regionList_Callback(hObject, eventdata, handles)
% hObject    handle to regionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns regionList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from regionList
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function regionList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
stcomp = getappdata(handles.hErwinJr,'stcomp');
% if isempty(stcomp) && data.material(1) == 4
%     updateStrainButton_Callback(hObject, eventdata, handles);
%     stcomp = getappdata(handles.hErwinJr,'stcomp');
% end

scale_factor = 1;

data.x=data.xnew;

% implementation of undo button option
if get(handles.undoButton,'Value') == 1
    flp = data.undo1;
    data.undo1 = data.undo2;
    data.undo2 = flp;
    try
        data.regionNum = data.undo1(:,1);
        data.wellWidths = data.undo1(:,2);
        data.barrierSwitch = data.undo1(:,3);
        data.arSwitch = data.undo1(:,4);
        data.material = data.undo1(:,5);
        data.doping = data.undo1(:,6);

        guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);
        refreshRegionList(hObject, eventdata, handles);
        set(handles.undoButton,'Value',0);
        data = getappdata(handles.hErwinJr,'data');
    catch
        errorstring{1} = 'No previous solution exists.';
        errorstring{2} = 'Uncheck the ''Undo'' button and run again.';
        errordlg(errorstring,'Error');
        return
    end
else
    data.undo2 = data.undo1;
    data.undo1 = ones(length(data.regionNum),5);
    data.undo1(:,1) = data.regionNum;
    data.undo1(:,2) = data.wellWidths;
    data.undo1(:,3) = data.barrierSwitch;
    data.undo1(:,4) = data.arSwitch;
    data.undo1(:,5) = data.material;
    data.undo1(:,6) = data.doping;
end

%handle self-consistent functionality
if get(handles.selfconButton,'Value') == 1
    %if data.sc_count == -1, means go back to previous sc solution
    if data.sc_count == -1
        %do nothing to potentional
        data.sc_count = 0;
    else
        %if previous run was self-consistent, reset potential
        data.sc_count = 0;
        setappdata(handles.hErwinJr,'data',data);
        set(handles.selfconButton,'Value',0)
        guidata(hObject, handles);
        refreshRegionList(hObject, eventdata, handles);
        data = getappdata(handles.hErwinJr,'data');
        set(handles.selfconButton,'Value',1)
        guidata(hObject, handles);

        %turn on self-consistent solution
        data.sc_count = 1;
        sc_divisions = find(data.divider == 1);

        %initialize values
        data.itertn = 1;
        convergence_track = [];
        data.voltage_track = [];
        Vp = [];
    end
end

%set Vcxold for self consistent solution
% load('voltage.mat')
% data.Vcx = data.Vcx + voltage * data.e0;
Vcxold = []; Vcxold = data.Vcx;
original_Vcx = []; original_Vcx = data.Vcx;

%set Xdoping variable for self consistent solution
%Xdoping is doping value for each x point
widthsum = [0;cumsum(data.wellWidthsLong)/sum(data.wellWidthsLong)];
Xdoping = zeros(data.xpoints,1);
Xdoping(1) = data.dopingLong(1);
dopingregion = transpose(find(data.dopingLong ~= 0));
for m = dopingregion
    maxchange = round((data.xpoints-1)*widthsum(m+1))+1;
    minchange = round((data.xpoints-1)*widthsum(m)+1)+1;
    if minchange == 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    Xdoping(minchange:maxchange) = data.dopingLong(m);
end
Xdoping(isnan(Xdoping)) = 0;
if get(handles.period1Button,'Value') == 1
    periods = 1;
elseif get(handles.period2Button,'Value') == 1
    periods = 2;
else
    periods = 3;
end
% dopant_charge = Xdoping*1e23 * scale_factor; %array, positive charge from stationary dopant ions
% total_doping = sum(Xdoping*1e23*data.xres) / periods;
% data.total_doping = total_doping;
setappdata(handles.hErwinJr,'data',data);



    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Material Parameters
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    data.Egx = zeros(data.xpoints,1);
    data.Mcx = zeros(data.xpoints,1);
    data.ESOx = zeros(data.xpoints,1);
    data.Epx = zeros(data.xpoints,1);
    data.Fx  = zeros(data.xpoints,1);
    refractiven = zeros(data.xpoints,1);
    
    indx = find(data.Xmaterial == 2);  %For InGaAs-AlInAs system
        data.Egx(indx) = 0.816 + data.XIn(indx)*0.65 - 4e-4*data.Temp*data.Temp/(data.Temp+145);  % Temp dependence from JAP art
        data.Mcx(indx) = (0.0427+data.XIn(indx)*0.0333)*data.me;  %From original Lifetime program
        refractiven(indx) = 3.485 - 0.287*data.XIn(indx);  %from drude.m GaAs: 3.485   , AlInAs: 3.198
        %Ep = .0253 * ones(data.xpoints,1);            %From JAP V89, p.5815

    indx = find(data.Xmaterial == 3);       %For ZnCdMgSe-ZnCdSe system (added 7/20/06)
        data.Egx(indx) = 2.08 + data.XIn(indx)*0.95;  % from William @ CCNY
%         data.Egx = 2.1 + data.XIn*0.9;  % from Hong @ CCNY
        data.Mcx(indx)=(0.128+data.XIn(indx)*0.053)*data.me;  %From Hong @ CCNY
        refractiven(indx) = 2.72 - 0.38*data.XIn(indx);  % from Hong @ CCNY
        %data.Ep = .024;            %aproximation
        
    indx = find(data.Xmaterial == 6);       %For ZnCdSe-ZnMgSe system (added 7/21/07)
        data.Egx(indx) = 2.08 + data.XIn(indx)*1.50;  % from William @ CCNY
        data.Mcx(indx)=(0.128+data.XIn(indx)*0.095)*data.me;
        refractiven(indx) = 2.72 - 0.38*data.XIn(indx);
        %data.Ep = .024;            %aproximation      
        
    indx = find(data.Xmaterial == 7);       %For GaAs/AlGaAs system (added 02/28/2008)
    if sum(indx)
        data.Egx(indx) = (2*stcomp.EgLH(2) + stcomp.EgSO(2))./3 .* data.XIn2(indx) + (2*stcomp.EgLH(1) + stcomp.EgSO(1))./3 .* (1-data.XIn2(indx));
        data.Mcx(indx) = stcomp.me0(2) .* data.me .* data.XIn2(indx) + stcomp.me0(1) .* data.me .* (1-data.XIn2(indx));
        refractiven(indx) = 2.72 - 0.38*data.XIn(indx);    
    end
        
    indx = find(data.Xmaterial == 4);       %Strain compensation
    if sum(indx)
        data.Egx(indx)=stcomp.EgLH(1)*abs(data.XIn(indx)-1) + stcomp.EgLH(2)*data.XIn(indx);
        data.ESOx(indx)=stcomp.ESO(1)*abs(data.XIn(indx)-1) + stcomp.ESO(2)*data.XIn(indx);
        data.Mcx(indx)=stcomp.me(1)*abs(data.XIn(indx)-1) + stcomp.me(2)*data.XIn(indx);
        data.Epx(indx)=stcomp.Ep(1)*abs(data.XIn(indx)-1) + stcomp.Ep(2)*data.XIn(indx);
        data.Fx(indx) =stcomp.F(1)*abs(data.XIn(indx)-1) + stcomp.F(2)*data.XIn(indx);
        refractiven(indx) = 3.485 - 0.287*data.XIn(indx);  %WRONG
    end
    if sum(indx)
        data.Egx(indx)=stcomp.EgLH(2)*data.XIn2(indx) + stcomp.EgLH(1)*(1-data.XIn2(indx));
        data.ESOx(indx)=stcomp.ESO(2)*data.XIn2(indx) + stcomp.ESO(1)*(1-data.XIn2(indx));
        data.Mcx(indx)=data.me*(stcomp.me(2)*data.XIn2(indx) + stcomp.me(1)*(1-data.XIn2(indx)));
        data.Epx(indx)=stcomp.Ep(2)*data.XIn2(indx) + stcomp.Ep(1)*(1-data.XIn2(indx));
        data.Fx(indx)=stcomp.F(2)*data.XIn2(indx) + stcomp.F(1)*(1-data.XIn2(indx));
        refractiven(indx) = 3.485 - 0.287*data.XIn(indx);  %WRONG
    end    

    indx = find(data.Xmaterial == 5);       %Strain compensation
    if sum(indx)
        data.Egx(indx)=stcomp.EgLH(3)*abs(data.XIn(indx)-1) + stcomp.EgLH(4)*data.XIn(indx);
        data.ESOx(indx)=stcomp.ESO(3)*abs(data.XIn(indx)-1) + stcomp.ESO(4)*data.XIn(indx);
        data.Mcx(indx)=stcomp.me(3)*abs(data.XIn(indx)-1) + stcomp.me(4)*data.XIn(indx);
        data.Epx(indx)=stcomp.Ep(3)*abs(data.XIn(indx)-1) + stcomp.Ep(4)*data.XIn(indx);
        data.Fx(indx) =stcomp.F(3)*abs(data.XIn(indx)-1) + stcomp.F(4)*data.XIn(indx);
        refractiven(indx) = 3.485 - 0.287*data.XIn(indx);  %WRONG
    end
    if sum(indx)
        data.Egx(indx)=stcomp.EgLH(4)*data.XIn2(indx) + stcomp.EgLH(3)*(1-data.XIn2(indx));
        data.ESOx(indx)=stcomp.ESO(4)*data.XIn2(indx) + stcomp.ESO(3)*(1-data.XIn2(indx));
        data.Mcx(indx)=data.me*(stcomp.me(4)*data.XIn2(indx) + stcomp.me(3)*(1-data.XIn2(indx)));
        data.Epx(indx)=stcomp.Ep(4)*data.XIn2(indx) + stcomp.Ep(3)*(1-data.XIn2(indx));
        data.Fx(indx)=stcomp.F(4)*data.XIn2(indx) + stcomp.F(3)*(1-data.XIn2(indx));
        refractiven(indx) = 3.485 - 0.287*data.XIn(indx);  %WRONG
    end    
    
    if sum(find(data.materialLong == 3)) || sum(find(data.materialLong == 6))  %if material is II-VI
        data.epsstatic = 6.5;
        data.epshighf = 5.7;
        data.hwlo = 0.031;
        data.kp0 = 46.3;
    else  %if material is III-V
        data.epsstatic = 13.9;
        data.epshighf = 11.6;
        data.hwlo = 0.034;
        data.kp0 = 64;
    end


    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % end Material Parameters
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmpi(data.solver,'SolverD')
    data.solver = 'SolverH';
    set(handles.display_Solver,'Value',3);
end
    
% start of solver loop
while 1 %the loop runs until a break occurs

    nonp = 1;  % If 1, incorporate nonparabolicity, if 0, don't.
    Ecf = max(data.Vcx); %Sets maximum E for cond band to highest value in data.Vcx
    Eco=min(data.Vcx);  %sets minimum E value
    
    data.xpoints = length(data.Vcx);
    data.padding = 0;

    %add in padding around potential to reduce number of upper junk states
    %data.Vcx(data.xpoints:data.xpoints+data.padding) = Ecf;
    if strcmp(data.button,'yip'), else close(handles.figure1); end
    %data.XIn(data.xpoints:data.xpoints+data.padding) = 1;
    %data.xpoints = data.xpoints + data.padding;
    
    try
        if data.itertn > 2
            axes(haxc) %give focus to sc convergence plot
            pause(0.2)
        end
    catch
    end
    

    data.EigenE = [];
    data.Psi = [];
    data.PsiSqr = [];
    data.PsiSqrPlot = [];
    data.McE = [];


    %call to wavefunction solver
    switch data.solver
        case 'SolverD'

            setappdata(handles.hErwinJr,'data',data);
            [numEigStates,data.EigenE, data.Psi, data.McE] = solverD(data.xres,data.xpoints,data.Vcx,...
                data.Mcx,data.Egx,nonp,data.Xmaterial,Epsc,Eco,Ecf,data.Efield,data.Epoints);
            data.EigenE = data.EigenE';
            data.McE = data.McE';
            wfNormArea = data.wfNormArea;
            setappdata(handles.hErwinJr,'data',data);

        case 'SolverL'

            setappdata(handles.hErwinJr,'data',data);
            [numEigStates, data.EigenE, data.Psi] = solverL(hObject, eventdata, handles);
            data.EigenE = data.EigenE';
            wfNormArea = data.wfNormArea;

        case 'SolverH'
            
            setappdata(handles.hErwinJr,'data',data);
            [numEigStates, data.EigenE, data.Psi, data.McE] = solverH(data.xres,data.xpoints,data.Vcx,...
                data.Mcx,data.Egx,data.ESOx,data.Fx,data.Xmaterial,data.Epx,Eco,Ecf,data.Efield,data.Epoints);
            if isempty(data.EigenE)
                errordlg('No solutions found');
                return
            end
            data.EigenE = data.EigenE';
            data.McE = data.McE';
            wfNormArea = data.wfNormArea;
            setappdata(handles.hErwinJr,'data',data);
            
    end
    

    %take out points from potential padding
    data.xpoints = data.xpoints - data.padding;
    data.Vcx = data.Vcx(1:data.xpoints);
    data.XIn = data.XIn(1:data.xpoints);
    refractiven = refractiven(1:data.xpoints);
    data.Mcx = data.Mcx(1:data.xpoints);
    data.Egx = data.Egx(1:data.xpoints);
    data.ESOx = data.ESOx(1:data.xpoints);
    data.Epx = data.Epx(1:data.xpoints);
    data.Fx = data.Fx(1:data.xpoints);
    data.Psi = data.Psi(1:data.xpoints,:);

    %square and scale wavefunction for nice plot on energy diagram
    data.PsiSqr = data.Psi.^2 * wfNormArea; %4.5e-10 is arbitrary normalization for nice plot
    data.PsiSqrPlot = data.PsiSqr;

    %implement pretty plot
    for q = 1:length(data.EigenE)
        firstpoint = find(data.PsiSqrPlot(:,q) > data.PrettyPlotFactor,1,'first');
        lastpoint = find(data.PsiSqrPlot(:,q) > data.PrettyPlotFactor,1,'last');
        data.PsiSqrPlot(:,q) = data.PsiSqr(:,q) + data.EigenE(1,q);
        data.PsiSqrPlot(1:firstpoint,q) = NaN;
        data.PsiSqrPlot(lastpoint:data.xpoints,q) = NaN;
    end

    %transpose matrices so in format needed to plot
    %data.PsiSqr = data.PsiSqr';
    %data.PsiSqrPlot = data.PsiSqrPlot';

    %if self consistent solution button isn't checked, don't loop
    if data.sc_count == 0;  %get(handles.selfconButton,'Value') == 0 && 
        setappdata(handles.hErwinJr,'data',data);
        break
    end

% begin Self Consistent
    if sum(data.divider) == 0
        if isempty(get(handles.display_Iregion,'String')) || isempty(get(handles.display_IIregion,'String'))
            errordlg('Injector wells must be specified.','Region ID Error');
            return
        end
        if str2num(get(handles.display_Iregion,'String')) > length(data.wellWidths) || str2num(get(handles.display_IIregion,'String')) > length(data.wellWidths)
            errordlg('Specified injector wells do not exist.','Region ID Error');
            return
        end
    end
    
    electron_distribution = [];
    electron_charge = [];
    dopant_charge = [];
    sigma = [];
    Esigma = [];
    widthsum = []; 
    oset = [];
    o = [];
    
    widthsum = [];
    widthsum = [0;cumsum(data.wellWidthsLong)/sum(data.wellWidthsLong)];
    if sum(data.divider)
        if mod(sum(data.dividerLong),2) ~= 0
            errordlg('Must have even number of dividers for self-consistent solution.');
            return
        end
        periods = sum(length(find(data.dividerLong==1)))/2;
        divisions = [];
        divisions = find(data.dividerLong == 1);
    end

    %find states with probability in injector region
    dopant_charge = Xdoping*1e23 * scale_factor; %array, positive charge from stationary dopant ions
          % defines doping at each x point in units of m^-3
    total_doping = sum(Xdoping*1e23*data.xres*1e-10) / periods;  %total doping per period
    data.total_doping = total_doping;
    electron_distribution = zeros(length(data.x),periods);
    
    %figure out which states are populated, then assign that
    %population distribution to electron_charge

    for n=1:periods
        if sum(data.divider) == 0
            Iregion = str2num(get(handles.display_Iregion,'String')) + length(data.wellWidths)*(n-1);
            IIregion = str2num(get(handles.display_IIregion,'String')) + length(data.wellWidths)*(n-1);
            if isempty(get(handles.display_ARwell,'String'))
                IIIregion = Iregion;
            else
                IIIregion = str2num(get(handles.display_ARwell,'String')) + length(data.wellWidths)*(n-1);
            end
        else
            IIregion = divisions(2*n-1);
            Iregion = divisions(2*n);
            if isempty(find(data.divider == 2,1))
                IIIregion = Iregion;
            else
                IIIregionlist = find(data.dividerLong == 2);
                IIIregion = IIIregionlist(n);
            end
        end
        
        %xIIwell is for finding first, lowest electron state
        xIIwell = zeros(1,data.xpoints);
        maxchange = round(data.xpoints*widthsum(Iregion+1))+1;
        minchange = round(data.xpoints*widthsum(IIregion))-1;
        if minchange <= 0
            minchange = 1;
        end
        if maxchange >= data.xpoints
            maxchange = data.xpoints;
        end
        xIIwell(1,minchange:maxchange) = 1;
        
        %xIIwell2 is for finding all electron states, including those that
        %might be in the active region
        xIIwell2 = zeros(1,data.xpoints);
        maxchange = round(data.xpoints*widthsum(IIIregion+1))+1;
        minchange = round(data.xpoints*widthsum(IIregion))-1;
        if minchange <= 0
            minchange = 1;
        end
        if maxchange >= data.xpoints
            maxchange = data.xpoints;
        end
        xIIwell2(1,minchange:maxchange) = 1;
            

        %find "floor" energy level where electrons sit
        o(n)=1;
        while sum(xIIwell' .* data.PsiSqr(:,o(n))) / sum(data.PsiSqr(:,o(n))) < 0.10 ...
                || isnan(sum(xIIwell' .* data.PsiSqr(:,o(n))) / sum(data.PsiSqr(:,o(n))))
            o(n) = o(n) + 1;
        end

        %set of all upper states
        oset(1,n) = find((data.EigenE(o(n))-0.035) < data.EigenE,1,'first'); %o(n);
        o(n)=oset(1,n); %o(n)+1;
        statenum(n) = 0;
        while o(n) <= length(data.EigenE) && 0.300 > abs(data.EigenE(o(n)) - data.EigenE(oset(1,n))) %find all states less than 250 meV from floor state
            if sum(xIIwell2' .* data.PsiSqr(:,o(n))) / sum(data.PsiSqr(:,o(n))) > 0.01
                statenum(n) = statenum(n)+1;
                oset(statenum(n),n) = o(n);
            end
            o(n)=o(n)+1;
        end
        o(n)=oset(1,n);
    end

    PsiSqr=[]; PsiSqr=0;
    for n=1:periods
        PsiSqr = PsiSqr + data.PsiSqr(:,o(n))/sum(data.PsiSqr(:,o(n)));
    end
    
    %find electron distribution
    for n = 1:periods
        n2d = 0;
        statenum(n) = 0;
        mc = data.McE(o(n)) * data.me; %in kg
        ef0 = total_doping * pi * data.hbar^2 / mc / data.e0; %in eV  %2D Fermi energy at T = 0, Davies p.33    %total doping 4.5*^16 cm-3
        efT = data.kb * data.TempFoM * log( exp(ef0 / data.kb / data.TempFoM) - 1); %2D Fermi Energy at T > 0

        numstates = find(oset(:,n)==0,1,'first');
        if isempty(numstates)
            numstates = length(oset(:,n));
        else
            numstates = numstates-1;
        end

        ostateweight = zeros(1,numstates);
        for q = 1:numstates
            ostateweight(q) = 1 / (exp(((data.EigenE(oset(q,n))-data.EigenE(oset(1,n)))-efT) / data.kb / data.TempFoM) + 1);%Fermi distribution;
            electron_distribution(:,n) = electron_distribution(:,n) + data.PsiSqr(:,oset(q,n)) * ostateweight(q);
        end
    end
    if n > 1
        electron_distribution = sum(electron_distribution,2);
    end
    
    electron_distribution = electron_distribution / sum(electron_distribution);
    
    electron_charge = electron_distribution * sum(dopant_charge);
    sigma = (-electron_charge + dopant_charge) * data.xres*1e-10; %mult by e0 delayed till later

    Esigma(length(sigma),1) = 0;
    for z= 1:length(sigma)
        Esigma(z)=sum(sigma(1:z))-sum(sigma(z+1:end));
    end
    Esigma = Esigma * data.e0;
    eps = refractiven.^2';
    eps = mean(eps);
    Efield = Esigma ./ (2 .* eps) / data.eps0;
    voltage = cumsum(Efield) * data.xres*1e-10; 

% figure('Name','voltage'); plot(data.x,voltage)
'pause';


    data.voltage_track(:,data.itertn) = voltage;
    
%     figure('Name','voltage'); plot(data.x,voltage)
    
    data.VcxPlot = data.Vcx;
    
    if data.itertn == 1
        Vp = data.voltage_track(:,data.itertn);
        convergence = sum(abs(data.voltage_track(:,data.itertn))) / data.xpoints * 1e3;
        convergence = NaN;
    elseif data.itertn < 7
        convergence = sum(abs(data.voltage_track(:,data.itertn)-data.voltage_track(:,data.itertn-1))) / data.xpoints * 1e3;
        %         Vp = conv_factor * (data.voltage_track(:,data.itertn) - data.voltage_track(:,data.itertn-1)) + Vp;

        Vp = 0.5 * (data.voltage_track(:,data.itertn) + data.voltage_track(:,data.itertn-1));
        %         if abs(convergence) < 0.1
        %         else
        %                     Vp = data.voltage_track(:,data.itertn-1) + conv_factor * (data.voltage_track(:,data.itertn)-data.voltage_track(:,data.itertn-1));
        %         end
    elseif data.itertn < 12
        convergence = sum(abs(data.voltage_track(:,data.itertn)-data.voltage_track(:,data.itertn-1))) / data.xpoints * 1e3;
        Vp = (data.voltage_track(:,data.itertn) + data.voltage_track(:,data.itertn-1) + data.voltage_track(:,data.itertn-2)) / 3;
    elseif data.itertn < 16
        convergence = sum(abs(data.voltage_track(:,data.itertn)-data.voltage_track(:,data.itertn-1))) / data.xpoints * 1e3;
        Vp = (data.voltage_track(:,data.itertn) + data.voltage_track(:,data.itertn-1) + data.voltage_track(:,data.itertn-2) + data.voltage_track(:,data.itertn-3)) / 4;        
    else
        convergence = sum(abs(data.voltage_track(:,data.itertn)-data.voltage_track(:,data.itertn-1))) / data.xpoints * 1e3;
        Vp = (data.voltage_track(:,data.itertn) + data.voltage_track(:,data.itertn-1) + data.voltage_track(:,data.itertn-2) + data.voltage_track(:,data.itertn-3) + data.voltage_track(:,data.itertn-4)) / 5;        
    end
    
    convergence_track(data.itertn) = convergence;
    %     set(handles.selfconDisp,'BackgroundColor','white');
    if data.itertn == 0
    elseif data.itertn == 1
        hc = figure(20);
        set(gcf,'Name','convergence');
        postn = get(gcf,'Position');
        postn(1) = 100;
        postn(2) = 100;
        set(gcf,'Position',postn);
        plot(convergence_track,'o-');
        haxc = gca;
        set(haxc,'HandleVisibility','on');
        set(handles.selfconDisp,'String',['conv(' num2str(data.itertn) ') = ' num2str(convergence,'%11.3g')]);
    else
        plot(haxc,convergence_track,'o-')
        set(handles.selfconDisp,'String',['conv(' num2str(data.itertn) ') = ' num2str(convergence,'%11.3g')]);
    end
    
    %     if abs(convergence) < 1
    %         conv_factor = 0.5 * conv_factor;
    %     end


    if get(handles.selfconButton,'Value') == 0 || data.itertn > str2num(get(handles.display_scmax,'String'))
        
        set(handles.display_scmax,'Visible','on');
        set(handles.selfconDisp,'Visible','on');
        set(handles.text22,'Visible','on');
        set(handles.text23,'Visible','on');
        set(handles.display_slnreturn,'Visible','on');
        set(handles.button_Go,'Visible','on');
        
        figure(21)
        set(gcf,'Name','voltage'); plot(data.x,Vp)
        xlabel ('Position (?')
        ylabel ('Poisson Correction (eV)')

        %plot detailed self-consistent plots
        if data.showSCplots == 1
            figure(22)
            set(gcf,'Name','charge'); plot(data.x,electron_charge,data.x,dopant_charge)
            figure(23)
            set(gcf,'Name','sigma'); plot(data.x,sigma)
            figure(24)
            set(gcf,'Name','Efield'); plot(data.x,Efield)
            %             figure('Name','convergence'); plot(convergence_track)
        end
        
        % set return to solution options to visible
        
        set(handles.selfconButton,'Value',1)
        data.sc_count = 0;
        break
    end
    
    data.itertn=data.itertn+1;

    data.Vcx = original_Vcx + Vp;
    setappdata(handles.hErwinJr,'data',data);
    refreshRegionList(hObject, eventdata, handles);
    data = getappdata(handles.hErwinJr,'data');
    
    
%     figure('Name','voltage'); plot(data.x,voltage)
%     figure('Name','charge'); plot(data.x,electron_charge,data.x,dopant_charge)
%     figure('Name','sigma'); plot(data.x,sigma)
%     figure('Name','Efield'); plot(data.x,Efield)
%     figure('Name','convergence'); plot(convergence_track)
    

%     if data.sc_count < 2
%         charge_Vold = voltage;
%         data.VcxPlot = data.Vcx;
%         data.Vcx = original_Vcx + voltage; %added in 0.5* and makes the SL structure converge, but not on correct solution
%         data.sc_count = data.sc_count+1;
%         setappdata(handles.hErwinJr,'data',data);
%         refreshRegionList(hObject, eventdata, handles);
%         data = getappdata(handles.hErwinJr,'data');
% %         plotfigureButton_Callback(hObject, eventdata, handles);
%         continue
%     elseif data.sc_count >= 2
%         data.sc_count = 1;
%         data.itertn=data.itertn+1;
%         
%         if data.itertn < str2num(get(handles.display_scmax,'String'))
%             data.VcxPlot = data.Vcx;
%             data.Vcx = original_Vcx + 0.5*voltage + 0.5*charge_Vold;
%             data.voltage_track(:,data.itertn) = 0.5*voltage + 0.5*charge_Vold;
%         end
% %         figure('Name','voltage'); plot(data.x,0.5*voltage + 0.5*charge_Vold)
%         
%         setappdata(handles.hErwinJr,'data',data);
%         refreshRegionList(hObject, eventdata, handles);
%         data = getappdata(handles.hErwinJr,'data');
% %         plotfigureButton_Callback(hObject, eventdata, handles);
%         
%         convergence = sum(abs(voltage-charge_Vold)) / data.xpoints * 1e3;
%         convergence_track(data.itertn) = convergence;
% 
% %         convergence = sum(abs(data.Vcx - Vcxold));
%         Vcxold = data.Vcx;
% 
%         set(handles.selfconDisp,'BackgroundColor','white');
%         set(handles.selfconDisp,'String',['conv(' num2str(data.itertn) ')=' num2str(convergence,'%11.3g')]);
% 
%         setappdata(handles.hErwinJr,'data',data);
%         
%         if scale_factor >= 1
%             convergence_val = 0.05;
%         else
%             convergence_val = 0.5;
%         end
% 
%         if convergence <= convergence_val || get(handles.selfconButton,'Value') == 0 || data.itertn >= str2num(get(handles.display_scmax,'String'))
%             
%             if data.itertn == str2num(get(handles.display_scmax,'String'))
%                 [junk, idx] = min(convergence_track);
%                 data.Vcx = original_Vcx + data.voltage_track(:,idx);
%                 data.sc_count = 3;
%                 data.itertn = data.itertn+1;
%                 setappdata(handles.hErwinJr,'data',data);
%                 refreshRegionList(hObject, eventdata, handles);
%                 data = getappdata(handles.hErwinJr,'data');
%                 continue
%             end
%             
%             if data.itertn > str2num(get(handles.display_scmax,'String')) && idx > 0
%                 set(handles.selfconDisp,'String',['conv(' num2str(idx) ')=' num2str(convergence_track(idx),'%11.3g')]);
%             end
% 
%             data.VcxPlot = data.Vcx;
%             setappdata(handles.hErwinJr,'data',data);
%             refreshRegionList(hObject, eventdata, handles);
%             data = getappdata(handles.hErwinJr,'data');
%             
%             if scale_factor == 1
%                 figure('Name','voltage'); plot(data.x,voltage)
%                 xlabel ('Position (?')
%                 ylabel ('Poisson Correction (eV)')
% 
%                 %plot detailed self-consistent plots
%                 if data.showSCplots == 1
%                     figure('Name','charge'); plot(data.x,electron_charge,data.x,dopant_charge)
%                     figure('Name','sigma'); plot(data.x,sigma)
%                     figure('Name','Efield'); plot(data.x,Efield)
%                     figure('Name','convergence'); plot(convergence_track)
%                 end
%                 
%                 break
%             end
%             %             scale_factor = scale_factor+0.2;
% %             if scale_factor > 1
% %                 scale_factor = 1;
% %             end
%         end
%     end

% end self consistent
end


try
    %select active region states to make bold in plot
    data.xAR(isnan(data.xAR)) = 0;
    data.ARstates = zeros(numEigStates,1);
    for q = 1:length(data.EigenE)
        data.ARstates(q) = sum(data.PsiSqr(:,q) .* data.xAR) / sum(data.PsiSqr(:,q));
    end
    data.ARstates = data.ARstates > data.ARsensitivity;
    data.ARstateNums = find(data.ARstates == 1);

    %display energies of active region states given in input box arStatesDisplay
    states = get(handles.arStatesDisplay,'String');
    if iscell(states) == 1
        states = str2num(states{1})';
    end
    if ischar(states) == 1
        states = str2num(states)';
    end
    if isempty(states) == 0 && isnumeric(states) == 1
        states = sort(states);
        numEs = sum(1:(length(states)-1));
        counter = 1;
        q = length(states);
        while q > 1
            j=q-1;
            while j >= 1
                outString(counter) = {['E' num2str(states(q)) num2str(states(j)) ' = '...
                    num2str((data.EigenE(1,data.ARstateNums(states(q)))-...
                    data.EigenE(1,data.ARstateNums(states(j)))),'%6.1f')]};
                j=j-1;
                counter=counter+1;
            end
            q=q-1;
        end
        set(handles.arEnergiesDisplay,'String',outString);
        set(handles.arEnergiesDisplay,'BackgroundColor',[1 1 1]);
    end
catch
    lasterror
end
%pass values to handles.hErwinJr
% setappdata(handles.hErwinJr,'Psi',data.Psi);
% setappdata(handles.hErwinJr,'EigenE',data.EigenE);
% setappdata(handles.hErwinJr,'ARstateNums',data.ARstateNums);
% setappdata(handles.hErwinJr,'PsiSqrPlot',PsiSqrPlot);

guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);





function EfieldDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to EfieldDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of EfieldDisplay as text
%        str2double(get(hObject,'String')) returns contents of EfieldDisplay as a double
data = getappdata(handles.hErwinJr,'data');
Edisp = get(handles.EfieldDisplay,'String');
Edisp = strrep(Edisp,'kV/cm','');
Edisp = strrep(Edisp,' ','');
data.Efield = str2double(Edisp);
set(handles.EfieldDisplay,'String',[num2str(Edisp),' kV/cm']);
data.layermod = 1;
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function EfieldDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EfieldDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xpointsDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to xpointsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xpointsDisplay as text
%        str2double(get(hObject,'String')) returns contents of xpointsDisplay as a double
data = getappdata(handles.hErwinJr,'data');
xdisp = get(handles.xpointsDisplay,'String');
xdisp = strrep(xdisp,'ang','');
xdisp = strrep(xdisp,' ','');
data.xres = str2double(xdisp);
data.layermod = 1;
set(handles.xpointsDisplay,'String',[num2str(data.xres) ' ang']);

if mod(1/data.xres,1) ~= 0
    strng{1} = 'Best results when 1/x_resolution is an integer.';
    strng{2} = '(e.g. 1 ? 0.5 ? 0.25 ? 0.1 ? etc.)';
    h=errordlg(strng,'Warning');
    uiwait(h);
end


% xdisp = get(handles.xpointsDisplay,'String');
% xdisp = strrep(xdisp,'xpoints','');
% xdisp = strrep(xdisp,':','');
% xdisp = strrep(xdisp,' ','');
% data.xpoints = str2double(xdisp);
% set(handles.xpointsDisplay,'String',['xpoints: ' num2str(xdisp)]);
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function xpointsDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpointsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EpointsDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to EpointsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EpointsDisplay as text
%        str2double(get(hObject,'String')) returns contents of EpointsDisplay as a double
data = getappdata(handles.hErwinJr,'data');
Endisp = get(handles.EpointsDisplay,'String');
Endisp = strrep(Endisp,'meV','');
Endisp = strrep(Endisp,' ','');
data.Eres = str2double(Endisp);
set(handles.EpointsDisplay,'String',[num2str(data.Eres) ' meV']);
% Endisp = strrep(Endisp,'Epoints','');
% Endisp = strrep(Endisp,':','');
% Endisp = strrep(Endisp,' ','');
% data.Epoints = str2double(Endisp);
% set(handles.EpointsDisplay,'String',['Epoints: ' num2str(Endisp)]);
data.layermod = 1;
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function EpointsDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EpointsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in saveasButton.
function saveasButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveasButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in addaboveButton.
function addaboveButton_Callback(hObject, eventdata, handles)
% hObject    handle to addaboveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
region = get(handles.regionList,'Value');
if region ~= 1
    data.wellWidths = [data.wellWidths(1:region-1);0;data.wellWidths(region:length(data.wellWidths))];
    data.regionNum = 1:(length(data.regionNum)+1);
    data.arSwitch = [data.arSwitch(1:region-1);0;data.arSwitch(region:length(data.arSwitch))];
    data.barrierSwitch = [data.barrierSwitch(1:region-1);0;data.barrierSwitch(region:length(data.barrierSwitch))];
    data.material = [data.material(1:region-1);data.material(region);data.material(region:length(data.material))];
    data.doping = [data.doping(1:region-1);data.doping(region);data.doping(region:length(data.doping))];
    data.divider = [data.divider(1:region-1);data.divider(region);data.divider(region:length(data.divider))];
else
    data.wellWidths = [0; data.wellWidths];
    data.regionNum = 1:(length(data.regionNum)+1);
    data.arSwitch = [0; data.arSwitch];
    data.barrierSwitch = [0; data.barrierSwitch];
    data.material = [data.material(region); data.material];
    data.doping = [data.doping(region); data.doping];
    data.divider = [data.divider(region); data.divider];
end
data.regionNum';

uicontrol(handles.regionList);
data.layermod = 1;
set(handles.display_Lplayers,'String','');
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes on button press in addbelowButton.
function addbelowButton_Callback(hObject, eventdata, handles)
% hObject    handle to addbelowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
region = get(handles.regionList,'Value');
if region ~= length(data.wellWidths)
    data.wellWidths = [data.wellWidths(1:region);0;data.wellWidths(region+1:length(data.wellWidths))];
    data.regionNum = 1:(length(data.regionNum)+1);
    data.arSwitch = [data.arSwitch(1:region);0;data.arSwitch(region+1:length(data.arSwitch))];
    data.barrierSwitch = [data.barrierSwitch(1:region);0;data.barrierSwitch(region+1:length(data.barrierSwitch))];
    data.material = [data.material(1:region);data.material(region);data.material(region+1:length(data.material))];
    data.doping = [data.doping(1:region);data.doping(region);data.doping(region+1:length(data.doping))];
    data.divider = [data.divider(1:region);data.divider(region);data.divider(region+1:length(data.divider))];
else
    data.wellWidths = [data.wellWidths; 0];
    data.regionNum = 1:(length(data.regionNum)+1);
    data.arSwitch = [data.arSwitch; 0];
    data.barrierSwitch = [data.barrierSwitch; 0];
    data.material = [data.material; data.material(region)];
    data.doping = [data.doping; data.doping(region)];
    data.divider = [data.divider; data.divider(region)];
end
data.regionNum';
data.layermod = 1;
set(handles.display_Lplayers,'String','');
guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

if length(data.regionNum) > 2
    set(handles.regionList,'Value',region+1);    
end
uicontrol(handles.regionList);
guidata(hObject,handles);

% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
data = getappdata(handles.hErwinJr,'data');
region = get(handles.regionList,'Value');
numrows = length(data.wellWidths);
numrowsd = numrows-1;

if numrows > 1
    if region == 1
        data.wellWidths = data.wellWidths(2:numrows);
        data.arSwitch = data.arSwitch(2:numrows);
        data.barrierSwitch = data.barrierSwitch(2:numrows);
        data.material = data.material(2:numrows);
        data.doping = data.doping(2:numrows);
        data.divider = data.divider(2:numrows);
    elseif region == numrows
        data.wellWidths = data.wellWidths(1:numrowsd);
        data.arSwitch = data.arSwitch(1:numrowsd);
        data.barrierSwitch = data.barrierSwitch(1:numrowsd);
        data.material = data.material(1:numrowsd);
        data.doping = data.doping(1:numrowsd);
        data.divider = data.divider(1:numrowsd);
    else
        data.wellWidths = [data.wellWidths(1:region-1);data.wellWidths(region+1:numrows)];
        data.arSwitch = [data.arSwitch(1:region-1);data.arSwitch(region+1:numrows)];
        data.barrierSwitch = [data.barrierSwitch(1:region-1);data.barrierSwitch(region+1:numrows)];
        data.material = [data.material(1:region-1);data.material(region+1:numrows)];
        data.doping = [data.doping(1:region-1);data.doping(region+1:numrows)];
        data.divider = [data.divider(1:region-1);data.divider(region+1:numrows)];
    end

    data.layermod = 1;
    data.regionNum = transpose(1:(numrows-1));
    set(handles.display_Lplayers,'String','');
    guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);
    refreshRegionList(hObject, eventdata, handles);
end

uicontrol(handles.regionList);

% --------------------------------------------------------------------
function refreshRegionList(hObject, eventdata, handles)
data = getappdata(handles.hErwinJr,'data');

%set material of each region to the first
% if sum(data.material(1) ~= data.material(2:end))
%     data.material(:) = data.material(1);
% end

%build regionList string
regionString = num2cell(ones(length(data.regionNum),1));
divdp = 0;
for q = 1:length(data.regionNum)
    if q < 10
        spacer = ' ';
    else
        spacer = '';
    end
    if data.wellWidths(q) < 10
        spacer2 = '  ';
    elseif data.wellWidths(q) < 100
        spacer2 = ' ';
    else
        spacer2 = '';
    end
    if data.barrierSwitch(q) == 1
        barrier = ' b';
    else
        barrier = '  ';
    end
    if data.arSwitch(q) == 1
        ar = ' A';
    else
        ar = '  ';
    end
    if data.doping(q) == 0 || isnan(data.doping(q))
        dop = '  ';
    else
        dop = ' d';
    end
    if data.divider(q) == 1 && divdp ~= 1
        divd = '-';
        divdp = 1;
    elseif divdp == 1
        divd = ' ';
        if data.divider(q) == 1
            divd = '-';
            divdp = 0;
        end
    elseif data.divider(q) == 0
        divd = ':';
        divdp = 0;
    else
        divd = '~';
        divdp = 2;
    end    
    regionString{q} = [spacer num2str(data.regionNum(q)) divd spacer2 num2str(data.wellWidths(q)) ...
        barrier ar dop];
end

% set values of linked boxes associated with the particular region currently selected in the regionList box
region = get(handles.regionList,'Value');
if double(region) > length(data.wellWidths)
    region = length(data.wellWidths);
    set(handles.regionList,'Value',region);
end
if data.arSwitch(region) == 1
    set(handles.arCheck,'Value',1)
else
    set(handles.arCheck,'Value',0)
end
if data.barrierSwitch(region) == 1
    set(handles.barrierCheck,'Value',1)
else
    set(handles.barrierCheck,'Value',0)
end
set(handles.wellDisplay,'String',num2str(data.wellWidths(region)));
set(handles.materialDisplay,'Value',data.material(region));
set(handles.regionList,'String',regionString);
set(handles.dopDisplay,'String',num2str(data.doping(region),'%10.1f'));

% create regions for 1x, 2x, or 3x solving
if get(handles.display_periods,'Value') == 1
    data.wellWidthsLong = data.wellWidths;
    data.barrierSwitchLong = data.barrierSwitch;
    data.arSwitchLong = data.arSwitch;
    data.materialLong = data.material;
    data.regionNum = data.regionNum;
    data.dopingLong = data.doping;
    data.dividerLong = data.divider;
elseif get(handles.display_periods,'Value') == 2
    data.wellWidthsLong = [data.wellWidths;data.wellWidths];
    data.barrierSwitchLong = [data.barrierSwitch;data.barrierSwitch];
    data.arSwitchLong = [data.arSwitch;data.arSwitch];
    data.materialLong = [data.material;data.material];
    data.dopingLong = [data.doping;data.doping];
    data.dividerLong = [data.divider;data.divider];
    data.regionNumLong = 1:2*length(data.regionNum);
elseif get(handles.display_periods,'Value') == 3
    data.wellWidthsLong = [data.wellWidths;data.wellWidths;data.wellWidths];
    data.barrierSwitchLong = [data.barrierSwitch;data.barrierSwitch;data.barrierSwitch];
    data.arSwitchLong = [data.arSwitch;data.arSwitch;data.arSwitch];
    data.materialLong = [data.material;data.material;data.material];
    data.dopingLong = [data.doping;data.doping;data.doping];    
    data.dividerLong = [data.divider;data.divider;data.divider];
    data.regionNumLong = 1:3*length(data.regionNum);
elseif get(handles.display_periods,'Value') == 4
    data.wellWidthsLong = [data.wellWidths;data.wellWidths;data.wellWidths;data.wellWidths];
    data.barrierSwitchLong = [data.barrierSwitch;data.barrierSwitch;data.barrierSwitch;data.barrierSwitch];
    data.arSwitchLong = [data.arSwitch;data.arSwitch;data.arSwitch;data.arSwitch];
    data.materialLong = [data.material;data.material;data.material;data.material];
    data.dopingLong = [data.doping;data.doping;data.doping;data.doping];    
    data.dividerLong = [data.divider;data.divider;data.divider;data.divider];
    data.regionNumLong = 1:4*length(data.regionNum);
elseif get(handles.display_periods,'Value') == 5
    data.wellWidthsLong = [data.wellWidths;data.wellWidths;data.wellWidths;data.wellWidths;data.wellWidths];
    data.barrierSwitchLong = [data.barrierSwitch;data.barrierSwitch;data.barrierSwitch;data.barrierSwitch;data.barrierSwitch];
    data.arSwitchLong = [data.arSwitch;data.arSwitch;data.arSwitch;data.arSwitch;data.arSwitch];
    data.materialLong = [data.material;data.material;data.material;data.material;data.material];
    data.dopingLong = [data.doping;data.doping;data.doping;data.doping;data.doping];    
    data.dividerLong = [data.divider;data.divider;data.divider;data.divider;data.divider];
    data.regionNumLong = 1:5*length(data.regionNum);
end

%set values dealing with x direction
%data.xf = sum(data.wellWidthsLong)*(10^(-10));  %sets final x position to sum of layer thicknesses in potential file, in Angstroms
%data.xres = data.xf/data.xpoints;     % size of each step in x (angstroms), also called xmesh or deltax in other parts of the program

data.xnew = transpose(0:data.xres:sum(data.wellWidthsLong));
data.xpoints = length(data.xnew);
set(handles.display_xpoints,'String',['xpoints: ' num2str(data.xpoints+1)]);

%for each x point, determine if well or barrier, assign to XIn
widthsum = [0;cumsum(data.wellWidthsLong)/sum(data.wellWidthsLong)];
  %widthsum is the cumulative percentage of each region
  %when one value of widthsum is multiplied by xpoints, you get a transition
  %point between 2 regions
% data.XIn = ones(data.xpoints,1); %initialize XIn to 1 for array of size xpoints
% wellregion = find(data.barrierSwitchLong == 0); %finds all regions marked as wells
% for m = transpose(wellregion) %for all well regions, set XIn to zero
%     maxchange = round(data.xpoints*widthsum(m+1));
%     minchange = round(data.xpoints*widthsum(m));
%     if minchange == 0
%         minchange = 1;
%     end
%     if maxchange >= data.xpoints
%         maxchange = data.xpoints;
%     end    
%     data.XIn(minchange:maxchange,1) = 0;
% end
data.XIn = zeros(data.xpoints,1); %initialize XIn to 0 for array of size xpoints
data.XIn(1) = data.barrierSwitchLong(1);
barrierregion = find(data.barrierSwitchLong == 1); %finds all regions marked as wells
uptick = zeros(1,length(barrierregion));
downtick = zeros(1,length(barrierregion));
cnt = 1;
for m = transpose(barrierregion) %for all well regions, set XIn to zero
    maxchange = round((data.xpoints-1)*widthsum(m+1))+1;
    minchange = round((data.xpoints-1)*widthsum(m))+2;
    if minchange == 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    data.XIn(minchange:maxchange,1) = 1;
    uptick(cnt) = minchange-1;
    downtick(cnt) = maxchange;
    cnt=cnt+1;
end
% uptick=uptick(2:end);
% downtick=downtick(1:end-1);

data.XIn2 = zeros(1,data.xpoints);
cnt=0;
if data.Ld > 0
    for q = 1:length(downtick)
        data.XIn2 = data.XIn2 + 1 ./ (1+exp(-(data.xres*(1:data.xpoints) - data.xres*(uptick(q)))/data.Ld));
        data.XIn2 = data.XIn2 + 1 ./ (1+exp((data.xres*(1:data.xpoints) - data.xres*(downtick(q)))/data.Ld));        
        cnt=cnt+1;
    end
    data.XIn2=data.XIn2'-cnt;
else
    data.XIn2 = data.XIn;
end

%make array to enable making designated active regions bold when Vcx is plottted
data.xAR = zeros(data.xpoints,1);
data.xAR(1:length(data.xAR)) = NaN;
ARregion = find(data.arSwitchLong == 1); 
for m = transpose(ARregion)
    maxchange = round((data.xpoints-1)*widthsum(m+1))+2;
    minchange = round((data.xpoints-1)*widthsum(m))+1;
    if minchange <= 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    data.xAR(minchange:maxchange,1) = 1;
end

%this makes an array that enables the currently selected region in
%regionList to be bold & blue when Vcx is plotted
xREGION = zeros(data.xpoints,1);
xREGION(1:length(xREGION)) = NaN;
region=get(handles.regionList,'Value');
if get(handles.display_periods,'Value') == 2
    region = [region, region + length(data.wellWidths)];
elseif get(handles.display_periods,'Value') == 3
    region = [region, region + length(data.wellWidths), region + 2*length(data.wellWidths)];
elseif get(handles.display_periods,'Value') == 4
    region = [region, region + length(data.wellWidths), region + 2*length(data.wellWidths), region + 3*length(data.wellWidths)];
elseif get(handles.display_periods,'Value') == 5
    region = [region, region + length(data.wellWidths), region + 2*length(data.wellWidths), region + 3*length(data.wellWidths), region + 4*length(data.wellWidths)];
end
for m = region
    maxchange = round((data.xpoints-1)*widthsum(m+1))+2;
    minchange = round((data.xpoints-1)*widthsum(m))+1;
    if minchange <= 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    xREGION(minchange:maxchange) = 1;
end

%make material array
data.Xmaterial = zeros(data.xpoints,1);
data.Xmaterial(1) = data.materialLong(1);
for q = 2:7
    indx = find(data.materialLong == q);
    for m = indx'
        maxchange = round((data.xpoints-1)*widthsum(m+1))+1;
        minchange = round((data.xpoints-1)*widthsum(m))+2;
        if minchange <= 0
            minchange = 1;
        end
        if maxchange >= data.xpoints
            maxchange = data.xpoints;
        end
        data.Xmaterial(minchange:maxchange,1) = q;
    end
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Material Parameters
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if data.sc_count == 0 && get(handles.selfconButton,'Value') == 0
    data.Vcx = zeros(length(data.xnew),1);
    data.VGx = zeros(length(data.xnew),1);
    data.VXx = zeros(length(data.xnew),1);
    data.VLx = zeros(length(data.xnew),1);
    
    %For InGaAs-AlInAs system
    indx = find(data.Xmaterial == 2);
    data.Vcx(indx)=(double(data.XIn(indx))*0.520 - data.xnew(indx) .* data.Efield .* 10^-5);
    %For II-VI ZnMgCdSe-ZnCdSe system
    indx = find(data.Xmaterial == 3);
    data.Vcx(indx)=(double(data.XIn(indx))*0.779-data.xnew(indx) .* data.Efield .* 10^-5); %William's composition 70625   0.779   0.91
        %     data.Vcx=(double(data.XIn)*0.72-data.xnew .* data.Efield .* 10^5)*data.e0;  Hong's composition
    %For ZnMgSe/ZnCdSe
    indx = find(data.Xmaterial == 6);
    data.Vcx(indx)=(double(data.XIn(indx))*1.20-data.xnew(indx) .* data.Efield .* 10^-5); %from William's 70919 email    
    
    %For GaAs/AlGaAs
    indx = find(data.Xmaterial == 7);
    if sum(indx)
        setappdata(handles.hErwinJr,'data',data); 
        updateStrainButton_Callback(hObject, eventdata, handles);
        data = getappdata(handles.hErwinJr,'data');
        stcomp = getappdata(handles.hErwinJr,'stcomp');
            data.Vcx(indx) = stcomp.EcG(2)*data.XIn2(indx) + stcomp.EcG(1)*(1-data.XIn2(indx)) - data.xnew(indx) .* data.Efield .* 10^-5;
            data.VXx(indx) = stcomp.EcX(2)*data.XIn2(indx) + stcomp.EcX(1)*(1-data.XIn2(indx)) - data.xnew(indx) .* data.Efield .* 10^-5;
            data.VLx(indx) = stcomp.EcL(2)*data.XIn2(indx) + stcomp.EcL(1)*(1-data.XIn2(indx)) - data.xnew(indx) .* data.Efield .* 10^-5;       
    end
    
    indx1 = find(data.material == 4);
    indx2 = find(data.material == 5);
    if (sum(indx1) + sum(indx2))
        setappdata(handles.hErwinJr,'data',data);
        updateStrainButton_Callback(hObject, eventdata, handles);
        data = getappdata(handles.hErwinJr,'data');
        stcomp = getappdata(handles.hErwinJr,'stcomp');
        indx1 = find(data.Xmaterial == 4);
        indx2 = find(data.Xmaterial == 5);
        %need to convert data.material to an xarray using widthsum
        %         data.Vcx(indx1)=(double(data.XIn(indx1))*(stcomp.Eoffset2-stcomp.Eoffset1)-stcomp.Eoffset1 - data.xnew(indx1) .* data.Efield .* 10^-5);  %for strain compensated InGaAs/AlInAs
        %         data.Vcx(indx2)=(double(data.XIn(indx2))*(stcomp.Eoffset4-stcomp.Eoffset3)-stcomp.Eoffset3 - data.xnew(indx2) .* data.Efield .* 10^-5);
        if ~isempty(indx1)
            data.Vcx(indx1) = stcomp.EcG(2)*data.XIn2(indx1) + stcomp.EcG(1)*(1-data.XIn2(indx1)) - data.xnew(indx1) .* data.Efield .* 10^-5;
            data.VXx(indx1) = stcomp.EcX(2)*data.XIn2(indx1) + stcomp.EcX(1)*(1-data.XIn2(indx1)) - data.xnew(indx1) .* data.Efield .* 10^-5;
            data.VLx(indx1) = stcomp.EcL(2)*data.XIn2(indx1) + stcomp.EcL(1)*(1-data.XIn2(indx1)) - data.xnew(indx1) .* data.Efield .* 10^-5;
        end
        if ~isempty(indx2)
            data.Vcx(indx2) = stcomp.EcG(4)*data.XIn2(indx2) + stcomp.EcG(3)*(1-data.XIn2(indx2)) - data.xnew(indx2) .* data.Efield .* 10^-5;
            data.VXx(indx2) = stcomp.EcX(4)*data.XIn2(indx2) + stcomp.EcX(3)*(1-data.XIn2(indx2)) - data.xnew(indx2) .* data.Efield .* 10^-5;
            data.VLx(indx2) = stcomp.EcL(4)*data.XIn2(indx2) + stcomp.EcL(3)*(1-data.XIn2(indx2)) - data.xnew(indx2) .* data.Efield .* 10^-5;
        end
    else %no strained material
        if data.Xmaterial(1) ~= 7
            set(handles.strainDisplay,'String','');
        end
    end
    %     figure(12); plot(data.xnew, data.Vcx);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Material Parameters
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.VcxPlot = data.Vcx;
else
%     data.sc_count = 0;
end


%set number of Epoints
data.Epoints = round((max(data.Vcx) - min(data.Vcx)) * 1000 / data.Eres);
set(handles.display_Epoints,'String',['Epoints: ' num2str(data.Epoints)]);


%necessary for undo button to work correctly
% setappdata(handles.hErwinJr,'Vcx',data.Vcx);
% setappdata(handles.hErwinJr,'XIn',data.XIn);
% setappdata(handles.hErwinJr,'wellWidthsLong',data.wellWidthsLong);
% setappdata(handles.hErwinJr,'barrierSwitchLong',data.barrierSwitchLong);
% PsiSqrPlot = getappdata(handles.hErwinJr,'PsiSqrPlot');

%calculate Lp and %InGaAs
if isempty(get(handles.display_Lplayers,'String'))
    set(handles.display_Lplayers,'String',['1,' num2str(length(data.regionNum))]);
end
data.Lplayers = sort(str2num(get(handles.display_Lplayers,'String')));
data.Lp = sum(data.wellWidths(data.Lplayers(1):data.Lplayers(2)));
InGaAsl = sum((-1)*double((data.barrierSwitch(data.Lplayers(1):data.Lplayers(2))-1)) .* data.wellWidths(data.Lplayers(1):data.Lplayers(2)));
data.percentInGaAs = InGaAsl / data.Lp * 100;
dispstring1{1} = ['Lp = ' num2str(data.Lp) ' ang'];
dispstring1{2} = ['InGaAs = ' num2str(data.percentInGaAs,'%10.1f') '%'];
if sum(data.doping)
    dispstring1{3} = ['n = ' num2str(sum(data.wellWidths(data.doping ~= 0) .* data.doping(data.doping ~= 0)) / data.Lp,'%10.3g') ' x 10^17'];
end
set(handles.display_Lplength,'String',dispstring1);

%plot everything on main axes
axes(handles.mainAxes);
cla;
set(handles.mainAxes,'XMinorTick','on','YGrid','on');
line1=plot(data.xnew,data.VcxPlot,'black');
xlabel ('Position (?')
set(line1,'linewidth',1);
hold on
line2=plot(data.xnew,data.xAR.*data.VcxPlot,'black');
set(line2,'linewidth',2.5);
hold on
line3=plot(data.xnew,xREGION.*data.VcxPlot,'blue');
set(line3,'linewidth',3);
if data.flagXvalley
    line4=plot(data.xnew,data.VXx,'r--');
    set(line4,'linewidth',1.5);
end
if data.flagLvalley
    line5=plot(data.xnew,data.VLx,'g--');
    set(line5,'linewidth',1.5);
end
% line6=plot(data.xnew,data.VGx,'b--');
% set(line6,'linewidth',1.5);
try %ifexists(data.x)
    if length(data.PsiSqrPlot) == length(data.x)
        hold on
        set(handles.mainAxes,'ColorOrder',data.colors);
        wfPlot = plot(data.x(mod(1:end,data.mainPlotmod)==1), data.PsiSqrPlot(mod(1:end,data.mainPlotmod)==1,:),'linewidth',2);
        %wfPlot = plot(data.x*1e10, data.PsiSqrPlot,'linewidth',2);
        %ylim([min(data.Vcx)/data.e0 max(data.Vcx)/data.e0]);
        %ylim([-0.52 0.52]);
        %ylim('auto');
        data.hPsiSqrPlot = wfPlot;
        try
            if sum(data.ARstates) > 0
                prop_name(1) = {'linewidth'};
                setwidth = ones(length(data.EigenE),1).*data.thinstates;
                setwidth(data.ARstates > 0) = data.thickstates;
                prop_values = num2cell(setwidth);
                set(wfPlot,prop_name,prop_values);
            end
        catch
        end
        hold on
    end
catch
end
guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);


% --- Executes on selection change in materialDisplay.
function materialDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to materialDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns materialDisplay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from materialDisplay
data = getappdata(handles.hErwinJr,'data');
matdisp = get(handles.materialDisplay,'Value');

if matdisp == 1
    menu_SetLayers_Callback(hObject, eventdata, handles);
    data=getappdata(handles.hErwinJr,'data');
    data.layermod = 1;
    setappdata(handles.hErwinJr,'data',data)
    return
else
    region = get(handles.regionList,'Value');
    data.material(region) = matdisp;
    data.layermod = 1;
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function materialDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to materialDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in undoButton.
function undoButton_Callback(hObject, eventdata, handles)
% hObject    handle to undoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tempDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to tempDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of tempDisplay as text
%        str2double(get(hObject,'String')) returns contents of tempDisplay as a double



% --- Executes during object creation, after setting all properties.
function tempDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on key press over regionList with no controls selected.
function regionList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to regionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

keypressed = get(handles.figure1,'CurrentCharacter');  %keyinfo; %keyinfo is a dll file that returns an ASCII code for each key press

% Determine if Enter or arrow right was pressed
if double(keypressed) == 13 %|| keypressed(1) == 39 %13 is the ascii value for Enter
    uicontrol(handles.wellDisplay);
end

% Determine if 'a' was pressed
if strcmp(keypressed,'a')
    ar = get(handles.arCheck,'Value');
    if ar == 1
        ar = 0;
    else
        ar = 1;
    end
    set(handles.arCheck,'Value',ar);
    region = get(handles.regionList,'Value');
    data.arSwitch(region) = ar;
    guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
    refreshRegionList(hObject, eventdata, handles);
end

%Determine if 'b' was pressed
if strcmp(keypressed,'b')
    barrier = get(handles.barrierCheck,'Value');
    if barrier == 1
        barrier = 0;
    else
        barrier = 1;
    end
    set(handles.barrierCheck,'Value',barrier);
    region = get(handles.regionList,'Value');
    data.barrierSwitch(region) = barrier;
    guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
    refreshRegionList(hObject, eventdata, handles);
end

%Determine if 'd' was pressed
if strcmp(keypressed,'d')
    region = get(handles.regionList,'Value');
    if data.divider(region) == 2
        data.divider(region) = 0;
    elseif data.divider(region) == 1
        data.divider(region) = 2;
    else %if data.divider(region) == 0
        data.divider(region) = 1;
    end
    guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
    refreshRegionList(hObject, eventdata, handles);
end

%Determine if 'e' was pressed
if strcmp(keypressed,'e')
    uicontrol(handles.dopDisplay);
end



% --- Executes on key press over wellDisplay with no controls selected.
function wellDisplay_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to wellDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

keypressed = get(handles.figure1,'CurrentCharacter');
% Determine whether Enter was pressed
if double(keypressed) == 13 %13 is the ascii value for Enter
    position = get(handles.regionList,'Value');
    if position ~= length(data.wellWidths)
        position = position+data.inputmode;
    end
    uicontrol(handles.regionList);
    set(handles.regionList,'Value',position);
end

% Determine whether Enter was pressed
% if (keypressed(1) == 40 || kepressed(1) == 220) %down arrow, '\' key
%     position = get(handles.regionList,'Value');
%     if position ~= length(handles.wellWidths)
%         position = position;
%     end
%     set(handles.regionList,'Value',position);
% end


function arEnStates_Callback(hObject, eventdata, handles)
% hObject    handle to arEnStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arEnStates as text
%        str2double(get(hObject,'String')) returns contents of arEnStates as a double


% --- Executes during object creation, after setting all properties.
function arEnStates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arEnStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function arEnergiesDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to arEnergiesDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arEnergiesDisplay as text
%        str2double(get(hObject,'String')) returns contents of arEnergiesDisplay as a double


% --- Executes during object creation, after setting all properties.
function arEnergiesDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arEnergiesDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in zoomButton.
function zoomButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.panButton,'Value') == 1
    pan off
    set(handles.panButton,'Value',0)
end

status = get(handles.zoomButton,'Value');
if status == 1
    zoom on
else
    zoom off
end

% --- Executes on button press in zoomoutButton.
function zoomoutButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomoutButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom out

% --- Executes on button press in plotfigureButton.
function plotfigureButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotfigureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

fighan=figure;
set(fighan,'DefaultAxesColorOrder',data.colors);
% set(fighan,'DefaultAxesColorOrder',[0 0 0]);
if length(data.PsiSqrPlot) == data.xpoints
    hold on
    wfPlot = plot(data.x-425, data.PsiSqrPlot/1e-3+data.Efield*425*1e-2);
    set(wfPlot,'LineWidth',2.5)
%     set(gca,'XLim',[-125 567],'YLim',[-700 1000])
    set(gcf,'Position',[100 100 560*2 420*2])
%     if sum(data.ARstates) > 0
%         prop_name(1) = {'linewidth'};
%         setwidth = ones(length(data.EigenE),1).*data.thinstates;
%         setwidth(data.ARstates > 0) = data.thickstates;
%         prop_values = num2cell(setwidth);
% 
%         set(wfPlot,prop_name,prop_values);
%     else
%         prop_name(1) = {'linewidth'};
%         setwidth = ones(length(data.EigenE),1).*data.thinstates;
%         prop_values = num2cell(setwidth);
% 
%         set(wfPlot,prop_name,prop_values);
%     end
    hold on
end
try
    line1=plot(data.x-425,data.VcxPlot*1000+data.Efield*425*1e-2,'black');
    set(line1,'linewidth',1);
    xlabel ('Position (?');
    ylabel ('Energy (meV)');
    hold on
catch
    line1=plot(data.xnew,data.VcxPlot*1000,'black');
    set(line1,'linewidth',1);
    xlabel ('Position (?');
    ylabel ('Energy (meV)');
    hold on
end

% --- Executes on button press in energydiffButton.
function energydiffButton_Callback(hObject, eventdata, handles)
% hObject    handle to energydiffButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [X,Y] = ginput(2);
if get(handles.panButton,'Value') == 1
    pan off
    set(handles.panButton,'Value',0)
end

data = getappdata(handles.hErwinJr,'data');

h = data.hPsiSqrPlot;
N = 2;
TEST = 1;

state=[0;0];
X=get(h,'XData');
Y=get(h,'YData');
XScale=diff(get(handles.mainAxes,'XLim'));
YScale=diff(get(handles.mainAxes,'YLim'));

for j=1:N
    [x(j),y(j),button]=ginput(1);
    if button==1
        r = zeros(length(X),1);
        for q = 1:length(X)
           r(q) =min(sqrt(((X{q}-x(j))./XScale).^2+((Y{q}-y(j))./YScale).^2));
        end
        [junk,q] = min(r);
        r=sqrt(((X{q}-x(j))./XScale).^2+((Y{q}-y(j))./YScale).^2);
        [temp,i]=min(r);
        xclick=x(j);
        yclick=y(j);
        state(j)=q;
        x(j)=X{q}(i);
        y(j)=min(Y{q}); %(i);
        if TEST
            k=0:.1:3.*pi;
            hold on;
            plot(XScale.*r(i).*sin(k)+xclick,YScale.*r(i).*cos(k)+yclick,'r');
            line([xclick x(j)],[yclick y(j)],'color','r');
            line([xclick xclick],[yclick y(j)],'color','r');
        end
    end
end
state = sort(state);
endiff = (y(2)-y(1))*1e3;
set(handles.endiffDisplay,'String',['E' num2str(state(2)) num2str(state(1)) ' = ' num2str(abs(endiff),'%6.1f') ' meV']);
set(handles.endiffDisplay,'BackgroundColor',[1 1 1]);
set(handles.getStates,'String',[num2str(state(2)) ',' num2str(state(1))]);


% --- Executes on button press in autodestructButton.
function autodestructButton_Callback(hObject, eventdata, handles)
% hObject    handle to autodestructButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
data.PsiSqrPlot = [];
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);
set(handles.endiffDisplay,'String','');
set(handles.endiffDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.arEnergiesDisplay,'String','');
set(handles.arEnergiesDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.selfconDisp,'String','');
set(handles.selfconDisp,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.stateinfoDisplay,'String','');
set(handles.stateinfoDisplay,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.display_FoM3,'String','');
set(handles.display_FoM3,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
set(handles.display_Lplength,'String','');
set(handles.display_Lplength,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));


% --- Executes on button press in period1Button.
function period1Button_Callback(hObject, eventdata, handles)
% hObject    handle to period1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of period1Button
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes on button press in period2Button.
function period2Button_Callback(hObject, eventdata, handles)
% hObject    handle to period2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of period2Button
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes on button press in period3Button.
function period3Button_Callback(hObject, eventdata, handles)
% hObject    handle to period3Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of period3Button
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);



% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on Close Request
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

if data.layermod == 1
    if isempty(data.fileName)
        msg_string{1} = ['Your new design has not been saved.'];
    else
        msg_string{1} = ['The design in ' data.fileName ' has changed.'];
    end
    msg_string{2} = '';
    msg_string{3} = 'Do you want to save the current changes?';
    answr = questdlg(msg_string,'ErwinJr','Yes','No','Cancel','Yes');
    
    switch answr
        case 'Yes'
            menuSaveAs_Callback(hObject, eventdata, handles);
            closereq
        case 'No'
            closereq
        case 'Cancel'
            return
        otherwise
            return
    end
else
    closereq
end


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
stcomp = getappdata(handles.hErwinJr,'stcomp');
try
    [data.fileName,data.pathName] = NameList('put','path.mem','Select File to Write', '*.qcl',data.fileName); %uiputfile('*.qcl');
catch
    [data.fileName,data.pathName] = NameList('put','path.mem','Select File to Write', '*.qcl');
end
if isequal(data.fileName,0) || isequal(data.pathName,0)
    return
else

    fid = fopen([data.pathName data.fileName], 'wt');
    fprintf(fid,['Description:' data.fileDesc '\n']);
    fprintf(fid,'Efield:%g\n',data.Efield);
    fprintf(fid,'xres:%g\n',data.xres);
    fprintf(fid,'Eres:%g\n',data.Eres);
    fprintf(fid,'InGaAsx:%g\n',data.InGaAsx);
    fprintf(fid,'AlInAsx:%g\n',data.AlInAsx);
    fprintf(fid,'InGaAsx2:%g\n',data.InGaAsx2);
    fprintf(fid,'AlInAsx2:%g\n',data.AlInAsx2);
    fprintf(fid,'Solver:%s\n',data.solver);
    fprintf(fid,'Temp:%g\n',data.Temp);
    fprintf(fid,'TempFoM:%g\n',data.TempFoM);
    fprintf(fid,'PlotPeriods:%g\n',data.PlotPeriods);
    fprintf(fid,'DiffLeng:%g\n',data.Ld);
    fprintf(fid,'regionNum\twellWdiths\tbarrierSwitch\tarSwitch\tmaterial\tdoping\tdivider\n');
    for q = 1:length(data.regionNum)
        fprintf(fid,'%d\t%g\t%d\t%d\t%d\t%g\t%d\n',data.regionNum(q),...
            data.wellWidths(q),data.barrierSwitch(q),data.arSwitch(q),...
            data.material(q),data.doping(q),data.divider(q));
    end
    fclose(fid);

    set(handles.filepathDisplay,'String',[data.pathName data.fileName]);

end

data.layermod = 0;
setappdata(handles.hErwinJr,'data',data);




% --------------------------------------------------------------------
function menuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[fileName,pathName] = uigetfile('*.qcl');
data = getappdata(handles.hErwinJr,'data');

if data.layermod == 1
    if isempty(data.fileName)
        msg_string{1} = ['Your new design has not been saved.'];
    else
        msg_string{1} = ['The design in ' data.fileName ' has changed.'];
    end
    msg_string{2} = '';
    msg_string{3} = 'Do you want to save the current changes?';
    answr = questdlg(msg_string,'ErwinJr','Yes','No','Cancel','Yes');
    
    switch answr
        case 'Yes'
            menuSaveAs_Callback(hObject, eventdata, handles);
        case 'No'
        case 'Cancel'
            return
        otherwise
            return
    end
else
end

[data.fileName,data.pathName] = NameList('get','path.mem','Select File to Open', '*.qcl','');
if isequal(data.fileName,0) || isequal(data.pathName,0)
    return
else
    set(handles.display_Lplayers,'String','');
    set(handles.selfconButton,'Value',0);
    set(handles.display_Iregion,'String','')
    set(handles.display_IIregion,'String','')
    data.sc_count = 0;
    
    fid = fopen([data.pathName data.fileName]);
    
    fileDesc = textscan(fid, 'Description:%s', 1, 'delimiter', '\n');
    data.fileDesc = char(fileDesc{1}); %description of data file
    Efield = textscan(fid, 'Efield:%f', 'delimiter', '\n');
    data.Efield = Efield{1}; %Electric field
    xpoints = textscan(fid, '%s', 1, 'delimiter', ':');
    xpointsval = textscan(fid, '%f', 1, 'delimiter', '\n');
    Epoints = textscan(fid, '%s', 1, 'delimiter', ':');
    Epointsval = textscan(fid, '%f', 1, 'delimiter', '\n');
    if strcmp(data.button,'yip'), else close(handles.figure1); end
    InGaAsx = textscan(fid, 'InGaAsx:%f', 1, 'delimiter', '\n');
    data.InGaAsx = double(InGaAsx{1}); %InGaAs In composition
    AlInAsx = textscan(fid, 'AlInAsx:%f', 1, 'delimiter', '\n');
    data.AlInAsx = double(AlInAsx{1}); %AlInAs In composition
    InGaAsx2 = textscan(fid, 'InGaAsx2:%f', 1, 'delimiter', '\n');
%     if ~isempty(InGaAsx2{1})
        data.InGaAsx2 = double(InGaAsx2{1}); %InGaAs In composition
%     end
    AlInAsx2 = textscan(fid, 'AlInAsx2:%f', 1, 'delimiter', '\n');
%     if ~isempty(AlInAsx2{1})
        data.AlInAsx2 = double(AlInAsx2{1}); %AlInAs In composition
%     end
    solver = textscan(fid, 'Solver:%s', 1, 'delimiter', '\n');
    if ~isempty(solver{1})
        data.solver = char(solver{1});
    end
    Temp = textscan(fid, 'Temp:%f', 1, 'delimiter', '\n');
    if ~isempty(Temp{1})
        data.Temp = double(Temp{1});
    end
    TempFoM = textscan(fid, 'TempFoM:%f', 1, 'delimiter', '\n');
    if ~isempty(TempFoM{1})
        data.TempFoM = double(TempFoM{1});
    end
    PlotPeriods = textscan(fid, 'PlotPeriods:%f', 1, 'delimiter', '\n');
    if ~isempty(PlotPeriods{1})
        data.PlotPeriods = double(PlotPeriods{1});
    end
    DiffLeng = textscan(fid, 'DiffLeng:%f', 1, 'delimiter', '\n');
    if ~isempty(DiffLeng{1})
        data.Ld = double(DiffLeng{1});
    end
    
    textscan(fid, '%s', 1, 'delimiter', '\n'); %throw away description line  
    regionData = textscan(fid, '%d %f %d %d %d %f %d', 'delimiter', '\t');
    data.regionNum     = regionData{1}; %strata region index
    data.wellWidths    = regionData{2}; %array size regionNum of region widths
    data.barrierSwitch = regionData{3}; %array size regionNum that describes region as barrier or not
    data.arSwitch      = regionData{4}; %array size regionNum that describes whether region is part of the active region
    data.material      = regionData{5}; %array size regionNum that gives material for each layer
    data.doping        = regionData{6}; %doping * 10^17 cm-3
    data.divider       = regionData{7}; %divider for calculating self consistent doping regions

    fclose(fid);

    clear regionData;
    
    if strcmp(char(xpoints{1}),'xpoints')
        %data.xpoints = double(xpointsval{1}); %number of x points to use in calculations
        %set(handles.display_xpoints,'String',['xpoints: ' num2str(data.xpoints)]);
        data.xres = 0.25;
        set(handles.xpointsDisplay,'String',[num2str(data.xres) ' ang']);
    else
        data.xres = double(xpointsval{1});
        set(handles.xpointsDisplay,'String',[num2str(data.xres) ' ang']);
    end
    
    if strcmp(char(Epoints{1}),'Epoints')
        data.Epoints = double(Epointsval{1}); %number of energy points to use in calculation
        data.Eres = 0.5;
        set(handles.EpointsDisplay,'String',[num2str(data.Eres) ' meV']);
    else
        data.Eres = double(Epointsval{1});
        set(handles.EpointsDisplay,'String',[num2str(data.Eres) ' meV']);
    end
    
    if data.material(1) == 4 && data.material(2) ~= 4 && data.material(2) ~= 5
        data.material(:) = 4;
    end
    
    data.doping(isnan(data.doping)) = 0;
  
    guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);

    set(handles.filepathDisplay,'String',[data.pathName data.fileName]);
    set(handles.descDisplay,'String',data.fileDesc);
    set(handles.EfieldDisplay,'String',[num2str(data.Efield),' kV/cm']);
    set(handles.AlInAsxDisplay,'String',num2str(data.AlInAsx,'%11.3f'));
    set(handles.InGaAsxDisplay,'String',num2str(data.InGaAsx,'%11.3f'));
    set(handles.display_AlInAsx2,'String',num2str(data.AlInAsx2,'%11.3f'));
    set(handles.display_InGaAsx2,'String',num2str(data.InGaAsx2,'%11.3f'));
    set(handles.display_periods,'Value',data.PlotPeriods);
    set(handles.display_Solver,'Value',strmatch(data.solver,get(handles.display_Solver,'String')))
    
    data.layermod = 0;
    data.PsiSqrPlot = [];
    data.PsiSqr = [];
    data.Psi = [];
    guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
    if data.material(1) == 4
        refreshRegionList(hObject, eventdata, handles);
        updateStrainButton_Callback(hObject, eventdata, handles);
    else
        set(handles.strainDisplay,'String','');
    end
    refreshRegionList(hObject, eventdata, handles);
    zoomoutButton_Callback(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function menuProgram_Callback(hObject, eventdata, handles)
% hObject    handle to menuProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuRun_Callback(hObject, eventdata, handles)
% hObject    handle to menuRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
runButton_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function menuHelp_Callback(hObject, eventdata, handles)
% hObject    handle to menuHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuAbout_Callback(hObject, eventdata, handles)
% hObject    handle to menuAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg = {'Copyright 2007 - 2008';'';'Program Author';'Kale Franz';'   kfranz@ieee.org';'';'Special thanks to';' Sean Gooding';' Anthony J. Hoffman';' Dan Wasserman'};
helpdlg(msg,'About ErwinJr')



% --------------------------------------------------------------------
function menuARfactor_Callback(hObject, eventdata, handles)
% hObject    handle to menuARfactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.ARsensitivity)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg('Energy State Selection Sensitivity: Specify 0 - 1','Active Region',1,default,options);
if isempty(answer) == 0
    data.ARsensitivity = str2num(answer{1});
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    runButton_Callback(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function menuExportPotential_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportPotential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
[fileName,pathName] = NameList('put','path.mem','Export Potential File', '*.csv');
if isequal(fileName,0) || isequal(pathName,0)
    return
end
fid = fopen([pathName fileName], 'wt');
for q = 1:data.xpoints
    fprintf(fid,'%g,%g\n',data.x(q),data.VcxPlot(q));
end
fclose(fid);



% --------------------------------------------------------------------
function menuPrettyPlotFactor_Callback(hObject, eventdata, handles)
% hObject    handle to menuPrettyPlotFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.PrettyPlotFactor)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg('Pretty Plot Factor (default: 0.0005)','Plot Control',1,default,options);
if isempty(answer) == 0
    data.PrettyPlotFactor = str2num(answer{1});
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
%     runButton_Callback(hObject, eventdata, handles);
end




% --- Executes on button press in panButton.
function panButton_Callback(hObject, eventdata, handles)
% hObject    handle to panButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.zoomButton,'Value') == 1
    set(handles.zoomButton,'Value',0)
    zoom off
end
if get(handles.panButton,'Value') == 1
    pan on
else
    pan off
end


% --------------------------------------------------------------------
function menuPotentialPadding_Callback(hObject, eventdata, handles)
% hObject    handle to menuPotentialPadding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.padding)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg('Potential padding points (reduces high energy junk states)','Plot Control',1,default,options);
if isempty(answer) == 0
    data.padding = str2num(answer{1});
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    runButton_Callback(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function menuExportWaves_Callback(hObject, eventdata, handles)
% hObject    handle to menuExportWaves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
data.PsiSqrPlot = [data.x data.PsiSqrPlot];

[fileName,pathName] = NameList('put','path.mem','Export Wave Functions to File', '*.csv');
if isequal(fileName,0) || isequal(pathName,0)
    return
end
dlmwrite([pathName fileName], data.PsiSqrPlot);



% --------------------------------------------------------------------
function menuLineWidths_Callback(hObject, eventdata, handles)
% hObject    handle to menuLineWidths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.thickstates),num2str(data.thinstates)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
prompt={'Line thickness for active region states',...
        'Line thickness for non-active region states'};
name='Plot Control';
answer = inputdlg(prompt,name,1,default,options);
if isempty(answer) == 0
    data.thickstates = str2num(answer{1});
    data.thinstates = str2num(answer{2});
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    runButton_Callback(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function menuSave_Callback(hObject, eventdata, handles)
% hObject    handle to menuSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
stcomp = getappdata(handles.hErwinJr,'stcomp');

while 1 %run until break

    if strcmp(get(handles.filepathDisplay,'String'), 'File Path')
        [data.fileName,data.pathName] = NameList('put','path.mem','Select File to Write', '*.qcl'); %uiputfile('*.qcl');
        pathstring = [data.pathName data.fileName];
        if isequal(data.fileName,0) || isequal(data.pathName,0)
            break
        set(handles.filepathDisplay,'String',[data.pathName data.fileName]);
        end
    else
        pathstring = get(handles.filepathDisplay,'String');
    end

    fid = fopen(pathstring, 'wt');
    fprintf(fid,['Description:' data.fileDesc '\n']);
    fprintf(fid,'Efield:%g\n',data.Efield);
    fprintf(fid,'xres:%g\n',data.xres);
    fprintf(fid,'Eres:%g\n',data.Eres);
    fprintf(fid,'InGaAsx:%g\n',data.InGaAsx);
    fprintf(fid,'AlInAsx:%g\n',data.AlInAsx);
    fprintf(fid,'InGaAsx2:%g\n',data.InGaAsx2);
    fprintf(fid,'AlInAsx2:%g\n',data.AlInAsx2);
    fprintf(fid,'Solver:%s\n',data.solver);
    fprintf(fid,'Temp:%g\n',data.Temp);
    fprintf(fid,'TempFoM:%g\n',data.TempFoM);
    fprintf(fid,'PlotPeriods:%g\n',data.PlotPeriods);
    fprintf(fid,'DiffLeng:%g\n',data.Ld);
    fprintf(fid,'regionNum\twellWdiths\tbarrierSwitch\tarSwitch\tmaterial\tdoping\tdivider\n');
    for q = 1:length(data.regionNum)
        fprintf(fid,'%d\t%g\t%d\t%d\t%d\t%g\t%d\n',data.regionNum(q),...
            data.wellWidths(q),data.barrierSwitch(q),data.arSwitch(q),...
            data.material(q),data.doping(q),data.divider(q));
    end
    fclose(fid);

    break
end

data.layermod = 0;
setappdata(handles.hErwinJr,'data',data);



function igstate_Callback(hObject, eventdata, handles)
% hObject    handle to igstate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of igstate as text
%        str2double(get(hObject,'String')) returns contents of igstate as a double


% --- Executes during object creation, after setting all properties.
function igstate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to igstate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dopDisplay_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to dopDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

keypressed = get(handles.figure1,'CurrentCharacter');
% Determine whether Enter was pressed
if double(keypressed) == 13 %13 is the ascii value for Enter
    position = get(handles.regionList,'Value');
    if position ~= length(data.wellWidths)
        position = position+data.inputmode;
    end
    uicontrol(handles.regionList);
    set(handles.regionList,'Value',position);
end


function dopDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to dopDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dopDisplay as text
%        str2double(get(hObject,'String')) returns contents of dopDisplay as a double
data = getappdata(handles.hErwinJr,'data');
region = get(handles.regionList,'Value');
newDop = str2double(get(handles.dopDisplay,'String'));
data.doping(region) = newDop;
data.layermod = 1;
guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function dopDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dopDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selfconButton.
function selfconButton_Callback(hObject, eventdata, handles)
% hObject    handle to selfconButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.selfconButton,'Value') == 0
    data = getappdata(handles.hErwinJr,'data');
    data.sc_count = 0;
    setappdata(handles.hErwinJr,'data',data);
    set(handles.display_scmax,'Visible','off');
    set(handles.selfconDisp,'Visible','off');
    set(handles.text22,'Visible','off');
    set(handles.text23,'Visible','off');
    set(handles.display_slnreturn,'Visible','off');
    set(handles.display_slnreturn,'String','');
    set(handles.button_Go,'Visible','off');
    
else
    set(handles.display_scmax,'Visible','on');
    set(handles.selfconDisp,'Visible','on'); 
    set(handles.text22,'Visible','on');
end



% --------------------------------------------------------------------
function menuTemp_Callback(hObject, eventdata, handles)
% hObject    handle to menuTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.Temp),num2str(data.TempFoM)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
varbls{1} = 'Temperature (K)';
varbls{2} = 'FoM Temperature (K)';
answer = inputdlg(varbls,'Temperature',1,default,options);
if isempty(answer) == 0
    data.Temp = str2num(answer{1});
    data.TempFoM = str2num(answer{2});
    data.layermod = 1;
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    refreshRegionList(hObject, eventdata, handles);
%     runButton_Callback(hObject, eventdata, handles);
end


% --------------------------------------------------------------------
function menuwfArea_Callback(hObject, eventdata, handles)
% hObject    handle to menuwfArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.wfNormArea,'%10.2e')};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg('Set normalized area of wavefuctions (default: 4.5e-10)','Wavefunction Area',1,default,options);
if isempty(answer) == 0
    data.wfNormArea = str2num(answer{1});
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    runButton_Callback(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function menuPlot_Callback(hObject, eventdata, handles)
% hObject    handle to menuPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function getStates_Callback(hObject, eventdata, handles)
% hObject    handle to getStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of getStates as text
%        str2double(get(hObject,'String')) returns contents of getStates as a double


% --- Executes during object creation, after setting all properties.
function getStates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to getStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stateinfoButton.
function stateinfoButton_Callback(hObject, eventdata, handles)
% hObject    handle to stateinfoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

states = str2num(get(handles.getStates,'String'))';
states = sort(states);

lt = lifetime(data.Psi(:,states(2)), data.EigenE(states(2)), data.Psi(:,states(1)), data.EigenE(states(1)),...
          data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
          data.epshighf, data.hwlo, data.kp0);
      
dp = dipole(data.Psi(:,states(2)), data.EigenE(states(2)), data.Psi(:,states(1)), data.EigenE(states(1)),...
        data.xpoints,data.Vcx,data.Mcx,data.Egx); 

showString{1} = ['E' num2str(states(2)) num2str(states(1)) ' = ' num2str((data.EigenE(states(2))-data.EigenE(states(1)))*1e3,'%10.3g')];
showString{2} = ['z' num2str(states(2)) num2str(states(1)) ' = ' num2str(dp,'%10.3g')];
showString{3} = ['t' num2str(states(2)) num2str(states(1)) ' = ' num2str(lt,'%10.3g')];

set(handles.stateinfoDisplay,'BackgroundColor','white');
set(handles.stateinfoDisplay,'String',showString);
        


% --------------------------------------------------------------------
function menuRunSeries_Callback(hObject, eventdata, handles)
% hObject    handle to menuRunSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

button = questdlg('WARNING: Only click ''Yes'' if you know what you''re doing!','WARNING: Run Series','Yes','Cancel','Yes');
if strcmp(button,'Cancel') == 1
    return
end

% fid = fopen([data.pathName 'runSeriesData_' num2str(round(rand*10000)) '.txt'], 'wt');
% fprintf(fid,'r2\tr3\tr4\tr5\tr6\tr7\tr8\tE87\tE76\tE75\tE65\tE54\tE53\tE51\tFoM\n');

r2 = 8:1:12;
r3 = 6:1:9;
r4 = 38:2:48;
r5 = 11:1:15;
r6 = 34:2:44;
r7 = 11:1:15;
r8 = 28:2:38;

% r2 = 108:109;
% r3 = 6;
% r4 = 92:93;
% r5 = 6;
% r6 = 128:129;
% r7 = 6;
% r8 = 52:53;

r2 = [34 37 39 42];  %70702
r3 = [36 39 43];
r4 = [34 38 41];

r2 = 6:0.5:9;
r3 = 10:0.5:15;

data.FoMmatrix = zeros(length(r2),length(r3));

counter = 1;
for q2 = 1:length(r2)
    for q3 = 1:length(r3)
        data.wellWidths(2) = r2(q2);
        data.wellWidths(3) = r3(q3);

        guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);

        refreshRegionList(hObject,eventdata,handles);
        runButton_Callback(hObject, eventdata, handles);
        data=getappdata(handles.hErwinJr,'data');

        E32 = data.EigenE(4) - data.EigenE(3); 

        lt = lifetime(data.Psi(:,4), data.EigenE(4), data.Psi(:,3), data.EigenE(3),...
          data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
          data.epshighf, data.hwlo, data.kp0);

        lt1 = 0;
        for q = 3-1:-1:1
                lftme = lifetime(data.Psi(:,3), data.EigenE(3), data.Psi(:,q), data.EigenE(q),...
                    data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
                    data.epshighf, data.hwlo, data.kp0);
                if isfinite(lftme)
                    lt1 = lt1 + 1/lftme;
                else
                end
        end
        lt1 = 1/lt1;

        lt2 = 0;
        for q = 4-1:-1:1
        lftme = lifetime(data.Psi(:,4), data.EigenE(4), data.Psi(:,q), data.EigenE(q),...
                data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
                data.epshighf, data.hwlo, data.kp0);
            if isfinite(lftme)
                lt2 = lt2 + 1/lftme;
            end
        end
        lt2 = 1/lt2;
        dp = dipole(data.Psi(:,4), data.EigenE(4), data.Psi(:,3), data.EigenE(3),...
            data.xpoints,data.Vcx,data.Mcx,data.Egx); 
    
        FoM = lt2 * (1 - lt1/lt) * dp^2

        data.FoMmatrix(q2,q3) = FoM .* E32;

        counter = counter+1;
        set(handles.getStates,'String',num2str(counter));
    end
end


% fclose(fid);
set(handles.getStates,'String','');
helpdlg('Run Series complete','Done');

setappdata(handles.hErwinJr,'data',data);



% --- Executes on button press in fomButton.
function fomButton_Callback(hObject, eventdata, handles)
% hObject    handle to fomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FoMButton.
function FoMButton_Callback(hObject, eventdata, handles)
% hObject    handle to FoMButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
states = str2num(get(handles.getStates,'String'))';
states = sort(states);

%----Ching-Yu added interface roughness intersuband scattering-------------
% Parameters
roughmean = 0.15 * (10 ^ -9); % interface roughness mean height, unit meter, 0.15 nm
correllength = 60 * (10 ^ -10); % correlation length, unit meter, 60 angstrom
roughfactor = pi .* (data.McE .* data.me) ./ (data.hbar ^ 2) .* (correllength ^ 2) .* (roughmean ^ 2); % matrix of the factor of intersubband scattering due to interface roughness, pi*effmass/(hbar^2)*(correllength^2)*(roughmean^2), matrix of states
deltaU = 520 * (10 ^ -3) * data.e0;  % band offset, 520meV, unit J

% Calculate each state norm
statesNum = size(data.Psi,2);
for j = 1 : statesNum
    normalPsi(j) = data.Psi(:,j)' * data.Psi(:,j);
end
normalPsi = normalPsi * data.xres * (10 ^-10);

% Find the interface positions and save in an array interfacePosi, starting
% from the first period end to the third period end. Then save the corresponding index to interfaceIndex 
structure = data.wellWidths';
wellsNum = size(structure , 2);
interfacePosi(1) = 0;  % Starting from the interface of the end of the first period
count = 2;
for i = 1 : 3
    for j = 1 : wellsNum
      interfacePosi(count) = interfacePosi(count - 1) + structure(j);
      count = count + 1;
    end
end
interfacePosi(1) = 1;
interfaceIndex = interfacePosi ./ data.xres; % the index of interfaces between InGaAs and InAlAs

% Save the probability on interface in array IRpsi, IRpsi(interfaceorder, states)  
interfaceNum = size(interfaceIndex , 2);
for i = 1 : interfaceNum
    IRpsi(i, :) = data.Psi(interfaceIndex(i), :); 
end

wavefacsqua = 2 * data.McE(states(2)) .* data.me * (data.EigenE(states(2)) - data.EigenE(states(1))) * data.e0 / (data.hbar ^ 2);
IRinverself = roughfactor(states(2)) * (deltaU ^ 2) * ((IRpsi(:,states(2)) .^ 2)' * (IRpsi(:,states(1)) .^ 2)) / (normalPsi(states(2)) * normalPsi(states(1))) * exp(-1 * (correllength ^ 2) * (wavefacsqua) / 4) / data.hbar; % Yenting's thesis eqn 4.11
tauIRul = 1 / IRinverself; % unit s
tauIRul = tauIRul * (10 ^ 12); % unit ps
%----Ching-Yu added end---------------------------------------------------

lftme = 0;
lt = 0;
lt1 = 0;
lto = 0;
lt2 = 0;
ltuo = 0;
%-------Ching-Yu, parameters definition-----------------
%  There are two states being chosen, one is defined as upper and the other
%  one is defined as the lower 
%   lt = LO phonon scattering time from the upper level to the lower
%   lt1 = inverse lifetime of the lower level before considering the
%         scattering from the lower level to the higher energy levels
%   lt1o = lifetime of the lower level, inverse of lt1, without considering
%          scattering into higer levels
%   lt1 = inverse lifetime of the lower level considered scattering to higher levels 
%   lt2 = invrse upper level lifetime not considering scattering to higher levels  
%   ltuo = the upper level lifetime not considering scattering to higher
%          levels
%   lt2 = lifetime considered scattering to higher levels

%Ching-Yu
phononnum = (exp(data.hwlo / (data.kb * data.Temp)) - 1) ^ (-1);    % Ching-Yu add, phonon population number, Bastard eqn(15), boson distribution of LO phonon,  hwlo=0.034 eV for III-V, data.kb unit eV/K

assignin('base', 'phononnum', phononnum)
% use lifetime calculation again lt = lifetime = LO scattering time from the upper level to the lower level
ltloscatt = lifetime(data.Psi(:, states(2)), data.EigenE(states(2)), data.Psi(:, states(1)), data.EigenE(states(1)),...
           data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
           data.epshighf, data.hwlo, data.kp0);  % Ching-Yu Change lifetime into lifetim1 function

 lt1 = 0;   % Ching-Yu: summing up. lt1 = lower level lifetime, it only considers scattering to the energy levels in the lower order but using new function liftime1, infact the order of the energy levels is lower energy to higher energy
 
 % 20140424 Ching-Yu added

 lt(1) = 0;
 lt(2) = 0;
 ltIR(1) = 0;
 ltIR(2) = 0;
 ltwIR(1) = 0;
 ltwIR(2) = 0;
 ltn(1) = 0;
 ltn(2) = 0;
 lto(1) = 0;
 lto(2) = 0;

 for i = 1 : 2
    order = 1;
    lftme = 0;
    lowerLimit = states(i) - 21;
    if lowerLimit < 0
        lowerLimit = 1;
    end
    
    for q = (states(i) - 1) : -1 : lowerLimit  %Ching-Yu: states(1) is the chosen lower level, in the "for loop", it sum up the scattering lifetime to the lower levels
       if abs(dipole(data.Psi(:, states(i)), data.EigenE(states(i)), data.Psi(:, q), data.EigenE(q),...  % Ching-Yu: if states are in the order of less than 12 difference to the lower laser level and if the dipole moment is larger than 0.05, then consider its scattering
             data.xpoints,data.Vcx,data.Mcx,data.Egx)) > 0.05
            lftme = lifetime(data.Psi(:, states(i)), data.EigenE(states(i)), data.Psi(:, q), data.EigenE(q),...
               data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
               data.epshighf, data.hwlo, data.kp0); 
           
            wavefacsqua = 2 * data.McE(states(i)) .* data.me * (data.EigenE(states(i)) - data.EigenE(q)) * data.e0 / (data.hbar ^ 2);
            IRinverself = roughfactor(states(i)) * (deltaU ^ 2) * ((IRpsi(:, states(i)) .^ 2)' * (IRpsi(:, q) .^ 2)) / (normalPsi(states(i)) * normalPsi(q)) * exp(-1 * (correllength ^ 2) * (wavefacsqua) / 4) / data.hbar; % Yenting's thesis eqn 4.11
            tauIR = 1 / IRinverself * (10 ^ 12); % unit ps
                     
            if isfinite(lftme)
               lt(i) = lt(i) + (1/lftme); % sum LO phonon scattering rate.
               ltIR(i) = ltIR(i) + (1 / tauIR);  % sum interface roughness scattering rate.
               ltwIR(i) = ltwIR(i) + (1 / lftme) + (1 / tauIR); % sum LO phonon and interface roughness scattering rate. 
            end
              
            if i == 1 % lower level
              lftimecal1(order,1) = states(i);   % from the lower level
              lftimecal1(order,2) = q;           % to the q level
              lftimecal1(order,3) = lftme;       % LO phonon scattering time from the lower level to the q level, unit ps
              lftimecal1(order,4) = lt(i);       % LO phonon scattering rate summansion of the lower level from depopulation level to the q level, unit  (1/ps) 
              lftimecal1(order,5) = 1./lt(i);    % LO phonon scattering lifetime summansion of the lower level from the depopulation level to the q level, unit ps
              lftimecal1(order,6) = tauIR;       % IR intersubband scattering time from the lower level to the q level, unit ps
              lftimecal1(order,7) = ltIR(i);      % sum of IFR scattering rate, unit (1/ps)
              lftimecal1(order,8) = ltwIR(i);    % LO phonon and IR scattering rate summansion of the lower level from the depopulation level to the q level, unit (ps) 
              lftimecal1(order,9) = 1./ltwIR(i); % LO phonon and IR scattering lifetime summansion of the lower level from the depopulation level to the q level, unit (1/ps) 
            else % upper level, same process as above
              lftimecal2(order,1) = states(i);
              lftimecal2(order,2) = q;
              lftimecal2(order,3) = lftme;
              lftimecal2(order,4) = lt(i);
              lftimecal2(order,5) = 1./lt(i);
              lftimecal2(order,6) = tauIR ;
              lftimecal2(order,7) = ltIR(i);      % sum of IFR scattering rate, unit (1/ps)
              lftimecal2(order,8) = ltwIR(i);
              lftimecal2(order,9) = 1./ltwIR(i);
            end
       end
       order = order + 1;
    end
  
    % Ching-Yu add, considering scattering to higher energy level
    lto(i) = 1 ./ lt(i);    % Ching-Yu: inverse sum up inversed lifetime, lower laser level lifetime before considering scattering to higher energy level
    statesNum = size(data.Psi, 2);
    upperLimit = states(i) + 21;
    if upperLimit > statesNum
        upperLimit = statesNum;
    end
    
    for q = (states(i) + 21) : -1 : upperLimit
        if abs(dipole(data.Psi(:,states(i)), data.EigenE(states(i)), data.Psi(:,q), data.EigenE(q),...
             data.xpoints,data.Vcx,data.Mcx,data.Egx)) > 0.05
             lftme = lifetime(data.Psi(:,q), data.EigenE(q), data.Psi(:,states(i)), data.EigenE(states(i)),...
             data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
             data.epshighf, data.hwlo, data.kp0);   % Ching-Yu: Ei,Ej switch
             if isfinite(lftme)
                 lt(i) = lt(i) + (1 / lftme) / (1 + phononnum) * (phononnum);   % Ching-Yu add factor (phononnum), Bastard eqn(15), the lifetime program always calculate from higher to lower, so to transfer need to times back the factor    
                 ltwIR(i) = ltwIR(i) + (1 / lftme) / (1 + phononnum) * (phononnum);
             end
             
             if i==1 % for the lower level
                 lftimecal1(order,1) = states(i);
                 lftimecal1(order,2) = q;
                 lftimecal1(order,3) = lftme;
                 lftimecal1(order,4) = lt(i);
                 lftimecal1(order,5) = 1./lt(i);
             else  % for the upper level
                 lftimecal2(order,1) = states(i);   % from the upper level
                 lftimecal2(order,2) = q;           % to the q level
                 lftimecal2(order,3) = lftme;       % LO phonon scattering time from the upper level to the q level, unit ps
                 lftimecal2(order,4) = lt(i);       % LO phonon scattering rate summansion of the upper level from the (upper+24) level to the q level, unit ps 
                 lftimecal2(order,5) = 1./lt(i);    % LO phonon scattering lifetime summansion of the upper level from the (upper+24) level to the q level, unit (1/ps)        
             end
            
             order = order + 1;
        end
    end
    
    ltn(i) = 1 ./ lt(i);
    ltnIR(i) = 1 ./ ltIR(i);
    ltnwIR(i) = 1 ./ ltwIR(i);
 end 

%--------------------------------------------------------------------------

assignin('base', 'lftimecal1', lftimecal1)
save('lftimecal1.txt','lftimecal1','-ascii')
type('lftimecal1.txt')

assignin('base', 'lftimecal2', lftimecal2)
save('lftimecal2.txt','lftimecal2','-ascii')
type('lftimecal2.txt')

dp = dipole(data.Psi(:,states(2)), data.EigenE(states(2)), data.Psi(:,states(1)), data.EigenE(states(1)),...
        data.xpoints,data.Vcx,data.Mcx,data.Egx); 
 
 taueff = ltn(2).* (1 - ltn(1) ./ ltloscatt);    
 FoM = taueff * dp ^ 2;    % Ching-Yu: FoM is (effectivelifetime * (dipolemoment ^ 2)) = upperlifetime * (1 - lowerlifetime / LOscatteringtime upperlower)
 taueffIR = ltnIR(2).* (1 - ltnIR(1) ./ tauIRul);
 FoMIR = taueffIR * dp ^ 2;  % only considering IFR scattering 
 tscattul = (1 /((1 / ltloscatt) + (1 / tauIRul)));
 taueffwIR = ltnwIR(2).* (1 - ltnwIR(1) ./ tscattul);
 FoMwIR = taueffwIR * dp ^ 2;  % include interface roughness intersubband scattering 
 FoMo = lto(2).* (1 - lto(1) ./ ltloscatt) * dp ^ 2;   % Ching-Yu add, original FoM without considering scattering to higher energy levels
 FoMstar = FoM * (data.EigenE(states(2)) - data.EigenE(states(1))); % in cm / A

showString{1} = ['E' num2str(states(2)) num2str(states(1)) ' = ' num2str((data.EigenE(states(2)) - data.EigenE(states(1))) * 1e3,'%10.3g')];    %energy difference
showString{2} = ['z' num2str(states(2)) num2str(states(1)) ' = ' num2str(dp,'%10.3g')]; % dipole moment
showString{3} = ['t' num2str(states(2)) num2str(states(1)) ' = ' num2str(ltloscatt,'%10.3g')];  % LO scattering time from upper to lower
showString{4} = ['tIR' num2str(states(2)) num2str(states(1)) ' = ' num2str(tauIRul,'%10.3g')]; % Intersubband interface roughness scattering time from upper to lower
showString{5} = ['twIR' num2str(states(2)) num2str(states(1)) ' = ' num2str(tscattul,'%10.3g')];
showString{6} = ['t' num2str(states(2)) ' = ' num2str(ltn(2),'%10.3f')]; % upper lifetime, only considering LO phonon scattering
showString{7} = ['t' num2str(states(1)) ' = ' num2str(ltn(1),'%10.3f')]; % lower lifetime, only considering LO phonon scattering
showString{8} = ['teff' num2str(states(2)) num2str(states(1)) ' = ' num2str(taueff,'%10.3g')];
showString{9} = ['tIR' num2str(states(2)) ' = ' num2str(ltnIR(2),'%10.3f')]; % upper lifetime, considering IFR scattering
showString{10} = ['tIR' num2str(states(1)) ' = ' num2str(ltnIR(1),'%10.3f')]; % lower lifetime, considering IFR scattering
showString{11} = ['teffIR' num2str(states(2)) num2str(states(1)) ' = ' num2str(taueffIR,'%10.3g')];
showString{12} = ['twIR' num2str(states(2)) ' = ' num2str(ltnwIR(2),'%10.3f')]; % upper lifetime, considering IFR and LO phonon scattering
showString{13} = ['twIR' num2str(states(1)) ' = ' num2str(ltnwIR(1),'%10.3f')]; % lower lifetime, considering IFR and LO phonon scattering
showString{14} = ['teffwIR' num2str(states(2)) num2str(states(1)) ' = ' num2str(taueffwIR,'%10.3g')];
showString{15} = ['FoM = ' num2str(FoM,'%10.0f')];
showString{16} = ['FoMIR = ' num2str(FoMIR,'%10.0f')];
showString{17} = ['FoMwIR = ' num2str(FoMwIR,'%10.0f')];
showString{18} = ['FoM* = ' num2str(FoMstar,'%10.1f')];

showString{19} = ['t2o' num2str(states(1)) ' = ' num2str(lto(2),'%10.3f')];  %Ching-Yu Add
showString{20} = ['t1o' num2str(states(2)) ' = ' num2str(lto(1),'%10.3f')];  %Ching-Yu Add
showString{21} = ['FoMo = ' num2str(FoMo,'%10.0f')];
% lifetime calculated end

set(handles.stateinfoDisplay,'BackgroundColor','white');
set(handles.stateinfoDisplay,'String',showString);




% --- Executes on button press in updateStrainButton.
function updateStrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateStrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
stcomp = getappdata(handles.hErwinJr,'stcomp');

%set all compositions to 0 if box is empty
data.InGaAsx = str2num(get(handles.InGaAsxDisplay,'String'));
if isempty(data.InGaAsx)
    data.InGaAsx = 0;
end
data.AlInAsx = str2num(get(handles.AlInAsxDisplay,'String'));
if isempty(data.AlInAsx)
    data.AlInAsx = 0;
end
data.InGaAsx2 = str2num(get(handles.display_InGaAsx2,'String'));
if isempty(data.InGaAsx2)
    data.InGaAsx2 = 0;
end
data.AlInAsx2 = str2num(get(handles.display_AlInAsx2,'String'));
if isempty(data.AlInAsx2)
    data.AlInAsx2 = 0;
end

% divide up material types

switch data.material(1)
    case {4, 5}
        %make all materials are either type 4 or 5
        if sum(data.material~=4 & data.material~=5)
            errordlg('All materials must be either InGaAs/AlInAs strained 1 or InGaAs/AlInAs strained 2', ...
                'ErwinJr error','modal')
            return
        end
        
        %find amount of each composition
        indx = [find(data.material == 4)];
        stcomp.h(2) = sum(double(data.barrierSwitchLong(indx)) .* data.wellWidthsLong(indx));
        stcomp.h(1) = sum(data.wellWidthsLong(indx)) - stcomp.h(2);
        indx = find(data.material == 5);
        stcomp.h(4) = sum(double(data.barrierSwitchLong(indx)) .* data.wellWidthsLong(indx));
        stcomp.h(3) = sum(data.wellWidthsLong(indx)) - stcomp.h(4);

        if stcomp.h(1)+stcomp.h(2) ~= 0 && ...
                (isempty(get(handles.InGaAsxDisplay,'String')) ||  ...
                 isempty(get(handles.AlInAsxDisplay,'String')) )
            strng{1} = 'Compositions must be specified for material 1.';
            strng{2} = 'Setting to InP lattice match by default.';
            h=errordlg(strng);
            uiwait(h);
            data.InGaAsx = 0.530;
            set(handles.InGaAsxDisplay,'String',num2str(data.InGaAsx,'%11.3f'))
            data.AlInAsx = 0.520;
            set(handles.AlInAsxDisplay,'String',num2str(data.AlInAsx,'%11.3f'))
        end

        if stcomp.h(3)+stcomp.h(4) ~= 0 && ...
                (isempty(get(handles.display_InGaAsx2,'String')) ||  ...
                 isempty(get(handles.display_AlInAsx2,'String')) )
            strng{1} = 'Compositions must be specified for material 2.';
            strng{2} = 'Setting to InP lattice match by default.';
            h=errordlg(strng);
            uiwait(h);
            data.InGaAsx2 = 0.530;
            set(handles.display_InGaAsx2,'String',num2str(data.InGaAsx2,'%11.3f'))
            data.AlInAsx2 = 0.520;
            set(handles.display_AlInAsx2,'String',num2str(data.AlInAsx2,'%11.3f'))
        end
        
        %set up GUI fields
        set(handles.text8,'String','InGaAs x')
        set(handles.text7,'String','InAlAs x')
        if (isempty(get(handles.display_InGaAsx2,'String')) ||  ...
                isempty(get(handles.display_AlInAsx2,'String')) ) %Using 2nd material composiition?
            set(handles.text21,'String','InGaAs x'); set(handles.text21,'Visible','off')
            set(handles.text20,'String','InAlAs x'); set(handles.text20,'Visible','off')
            set(handles.display_InGaAsx2,'Visible','off')
            set(handles.display_AlInAsx2,'Visible','off')
        else
            set(handles.text21,'String','InGaAs x'); set(handles.text21,'Visible','on')
            set(handles.text20,'String','InAlAs x'); set(handles.text20,'Visible','on')
            set(handles.display_InGaAsx2,'Visible','on')
            set(handles.display_AlInAsx2,'Visible','on')
        end
        
        setappdata(handles.hErwinJr,'data',data);
        setappdata(handles.hErwinJr,'stcomp',stcomp);
        straincalc(handles);
        stcomp = getappdata(handles.hErwinJr,'stcomp');

        % build strain display string
        q=0;
        q=q+1; displayString{q} = 'in-plane strain';
        if ~isempty(get(handles.InGaAsxDisplay,'String'))
            q=q+1; displayString{q} = ['InGaAs1 = ' num2str(stcomp.eps_perp(1)*100,'%12.2f')];
        end
        if ~isempty(get(handles.AlInAsxDisplay,'String'))
            q=q+1; displayString{q} = ['AlInAs1 = ' num2str(stcomp.eps_perp(2)*100,'%12.2f')];
        end
        if ~isempty(get(handles.display_InGaAsx2,'String'))
            q=q+1; displayString{q} = ['InGaAs2 = ' num2str(stcomp.eps_perp(3)*100,'%12.2f')];
        end
        if ~isempty(get(handles.display_AlInAsx2,'String'))
            q=q+1; displayString{q} = ['AlInAs2 = ' num2str(stcomp.eps_perp(4)*100,'%12.2f')];
        end

    case 7
        %make all materials are either type 7 GaAs/AlGaAs
        if sum(data.material~=7)
            errordlg('All material layers must be GaAs/AlGaAs', ...
                'ErwinJr error','modal')
            return
        end
        
        %set up GUI fields
        set(handles.text8,'String','well Al x')
        set(handles.text7,'String','barrier Al x')
        set(handles.text21,'String','well Al x'); set(handles.text21,'Visible','off');  %only one set of materials for now
        set(handles.text20,'String','barrier Al x'); set(handles.text20,'Visible','off');
        set(handles.display_InGaAsx2,'Visible','off')
        set(handles.display_AlInAsx2,'Visible','off')
        
        %find amount of each composition
        indx = [find(data.material == 7)];
        stcomp.h(2) = sum(double(data.barrierSwitchLong(indx)) .* data.wellWidthsLong(indx));
        stcomp.h(1) = sum(data.wellWidthsLong(indx)) - stcomp.h(2);

        if stcomp.h(1)+stcomp.h(2) ~= 0 && ...
                (isempty(get(handles.InGaAsxDisplay,'String')) ||  ...
                isempty(get(handles.AlInAsxDisplay,'String')) )
            strng{1} = 'Compositions must be specified for material 1.';
            strng{2} = 'Setting to GaAs/AlAs default.';
            h=errordlg(strng);
            uiwait(h);
            data.InGaAsx = 0;
            set(handles.InGaAsxDisplay,'String',num2str(data.InGaAsx,'%11.3f'))
            data.AlInAsx = 1;
            set(handles.AlInAsxDisplay,'String',num2str(data.AlInAsx,'%11.3f'))
        end
        

        setappdata(handles.hErwinJr,'data',data);
        straincalcAlGaAs(handles, stcomp.h);
        stcomp = getappdata(handles.hErwinJr,'stcomp');

        % build strain display string
        q=0;
        % q=q+1; displayString{q} = 'in-plane strain';
        if ~isempty(get(handles.InGaAsxDisplay,'String'))
            q=q+1; displayString{q} = ['well1 = ' num2str(stcomp.eps_perp(1)*100,'%12.2f')];
        end
        if ~isempty(get(handles.AlInAsxDisplay,'String'))
            q=q+1; displayString{q} = ['barrier1 = ' num2str(stcomp.eps_perp(2)*100,'%12.2f')];
        end
        if ~isempty(get(handles.display_InGaAsx2,'String'))
            q=q+1; displayString{q} = ['well2 = ' num2str(stcomp.eps_perp(3)*100,'%12.2f')];
        end
        if ~isempty(get(handles.display_AlInAsx2,'String'))
            q=q+1; displayString{q} = ['barrier2 = ' num2str(stcomp.eps_perp(4)*100,'%12.2f')];
        end
        
    otherwise
        errordlg('material error')
        return
end
%kale

% continue building strain display string
% q=q+1; displayString{q} = '- - -';
% q=q+1; displayString{q} = 'lattice constants';
% q=q+1; displayString{q} = ['aperp = ' num2str(stcomp.a_perp,'%12.3f')];
% q=q+1; displayString{q} = ['apara = ' num2str(stcomp.a_parallel,'%12.3f')];
% q=q+1; displayString{q} = 'effective masses';
% if ~isempty(get(handles.InGaAsxDisplay,'String')) && ~isempty(get(handles.AlInAsxDisplay,'String'))
%     q=q+1; displayString{q} = ['w/b1 = ' num2str(stcomp.me(1),'%12.2f') ' / ' num2str(stcomp.me(2),'%12.2f')];
% end
% if ~isempty(get(handles.display_InGaAsx2,'String')) && ~isempty(get(handles.display_AlInAsx2,'String'))
%     q=q+1; displayString{q} = ['w/b2 = ' num2str(stcomp.me(3),'%12.2f') ' / ' num2str(stcomp.me(4),'%12.2f')];
% end

q=q+1; displayString{q} = '- - -';
if ~isempty(get(handles.InGaAsxDisplay,'String')) && ~isempty(get(handles.AlInAsxDisplay,'String'))
    q=q+1; displayString{q} = ['Eoffset1 = ' num2str((stcomp.EcG(2) - stcomp.EcG(1))*1000,'%12.1f')];
end
if ~isempty(get(handles.display_InGaAsx2,'String')) && ~isempty(get(handles.display_AlInAsx2,'String'))
    q=q+1; displayString{q} = ['Eoffset2 = ' num2str((stcomp.EcG(4) - stcomp.EcG(3))*1000,'%12.1f')];
end
displayString{q+1} = ['mismatch% = ' num2str(stcomp.mismatch,'%12.3f')];

set(handles.strainDisplay,'String',displayString);
setappdata(handles.hErwinJr,'stcomp',stcomp);
% data.InGaAsx = data.InGaAsx;
% data.AlInAsx = data.AlInAsx;
guidata(hObject,handles); setappdata(handles.hErwinJr,'data',data);


function InGaAsxDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to InGaAsxDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InGaAsxDisplay as text
%        str2double(get(hObject,'String')) returns contents of InGaAsxDisplay as a double
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
updateStrainButton_Callback(hObject, eventdata, handles);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function InGaAsxDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InGaAsxDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AlInAsxDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to AlInAsxDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AlInAsxDisplay as text
%        str2double(get(hObject,'String')) returns contents of AlInAsxDisplay as a double
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
updateStrainButton_Callback(hObject, eventdata, handles);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function AlInAsxDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlInAsxDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function menuInputMode_Callback(hObject, eventdata, handles)
% hObject    handle to menuInputMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

str{1} = 'Default: no advance';
str{2} = 'Bulk input: advance one';
[selection,ok] = listdlg('PromptString','Select input mode:','ListSize',[160 40],'InitialValue',data.inputmode+1,'SelectionMode','single','ListString',str);

if ok == 1 && selection == 1;
    data.inputmode = 0;
elseif ok == 1 && selection == 2;
    data.inputmode = 1;
else
    data.inputmode = data.inputmode;
end

guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);

            
            




function display_Lplayers_Callback(hObject, eventdata, handles)
% hObject    handle to display_Lplayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_Lplayers as text
%        str2double(get(hObject,'String')) returns contents of display_Lplayers as a double
refreshRegionList(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function display_Lplayers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_Lplayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function display_FoMupper_Callback(hObject, eventdata, handles)
% hObject    handle to display_FoMupper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_FoMupper as text
%        str2double(get(hObject,'String')) returns contents of display_FoMupper as a double


% --- Executes during object creation, after setting all properties.
function display_FoMupper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_FoMupper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_FoMlower_Callback(hObject, eventdata, handles)
% hObject    handle to display_FoMlower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_FoMlower as text
%        str2double(get(hObject,'String')) returns contents of display_FoMlower as a double


% --- Executes during object creation, after setting all properties.
function display_FoMlower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_FoMlower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonFoM2.
function buttonFoM2_Callback(hObject, eventdata, handles)
% hObject    handle to buttonFoM2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% upperStates = str2num(get(handles.display_FoMupper,'String'))';
% upperStates = sort(upperStates);
% lowerStates = str2num(get(handles.display_FoMlower,'String'))';
% lowerStates = sort(lowerStates);
% 
% dp2 = 0;
% for upper = upperStates'
%     for lower = lowerStates'
%        dp2 = dp2 + dipole(data.Psi(:,upper)', data.EigenE(upper), data.Psi(:,lower)', data.EigenE(lower),...
%           data.xpoints,data.Vcx,data.Mcx,data.Egx)^2;
%     end
% end
% dp2
% 
% 
% t32 = 0;
% for upper = upperStates'
%     for lower = lowerStates(length(lowerStates))
%        t32 = t32 + 1 / length(upperStates) / lifetime(data.Psi(:,upper)', data.EigenE(upper)/data.e0, data.Psi(:,lower)', data.EigenE(lower)/data.e0,...
%           data.xpoints, data.xres, data.Vcx/data.e0, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
%           data.epshighf, data.hwlo, data.kp0);
%     end
% end
% t32 = 1/t32
% 
% 
% t3 = 0;
% lt1 = 0;
% for upper = upperStates'
%     for q = upper-1:-1:1
%         lt1 = lt1 + 1/lifetime(data.Psi(:,upper)', data.EigenE(upper)/data.e0, data.Psi(:,q)', data.EigenE(q)/data.e0,...
%             data.xpoints, data.xres, data.Vcx/data.e0, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
%             data.epshighf, data.hwlo, data.kp0);
%     end
%     t3 = t3 + lt1 / length(upperStates);
%     lt1 = 0;
% end
% t3 = 1/t3
% 
% t2 = 0;
% lower = lowerStates(length(lowerStates));
% for q = lower-1:-1:1
%     t2 = t2 + 1/lifetime(data.Psi(:,lower)', data.EigenE(lower)/data.e0, data.Psi(:,q)', data.EigenE(q)/data.e0,...
%         data.xpoints, data.xres, data.Vcx/data.e0, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
%         data.epshighf, data.hwlo, data.kp0);
% end
% t2 = 1/t2
% 
% showString{1} = [num2str(dp2 * t3 * (1-t2/t32),'%12.0f')];
% 
% set(handles.display_FoM2,'BackgroundColor','white');
% set(handles.display_FoM2,'String',showString);
        




function display_Iregion_Callback(hObject, eventdata, handles)
% hObject    handle to display_Iregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_Iregion as text
%        str2double(get(hObject,'String')) returns contents of display_Iregion as a double


% --- Executes during object creation, after setting all properties.
function display_Iregion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_Iregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonFoM3.
function buttonFoM3_Callback(hObject, eventdata, handles)
% hObject    handle to buttonFoM3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

%makes you press FoM button twice after FoM has been run already
if get(handles.buttonFoM3,'Value') == 0
   set(handles.buttonFoM3,'Value',0)
   return
end

if isempty(get(handles.display_Iregion,'String')) || isempty(get(handles.display_IIregion,'String')) || isempty(get(handles.display_ARwell,'String'))
    errordlg('Must indicate wells for FoM calculation.','FoM Error')
end

widthsum = [0;cumsum(data.wellWidthsLong)/sum(data.wellWidthsLong)];
IIregion = str2num(get(handles.display_IIregion,'String'));
Iregion = str2num(get(handles.display_Iregion,'String'));
ARregion = str2num(get(handles.display_ARwell,'String'));
if get(handles.period3Button,'Value') == 1
    Iregion = Iregion + length(data.regionNum);
    IIregion = IIregion + length(data.regionNum);
    ARregion = ARregion + length(data.regionNum);
end
    
xIwell = zeros(data.xpoints,1);

    maxchange = round(data.xpoints*widthsum(Iregion+1))+1;
    minchange = round(data.xpoints*widthsum(Iregion))-1;
    if minchange <= 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    xIwell(minchange:maxchange) = 1;
xARwell = zeros(data.xpoints,1);
    maxchange = round(data.xpoints*widthsum(ARregion+1))+1;
    minchange = round(data.xpoints*widthsum(ARregion))-1;
    if minchange <= 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    xARwell(minchange:maxchange) = 1;    
xIIwell = zeros(data.xpoints,1);
    maxchange = round(data.xpoints*widthsum(Iregion+1))+1;
    minchange = round(data.xpoints*widthsum(IIregion))-1;
    if minchange <= 0
        minchange = 1;
    end
    if maxchange >= data.xpoints
        maxchange = data.xpoints;
    end    
    xIIwell(minchange:maxchange) = 1;

%find first energy level in injector well, which is the first upper state
q=1;
while sum(xIwell .* data.PsiSqr(:,q)) / sum(data.PsiSqr(:,q)) < 0.02 ...
        || isnan(sum(xIwell .* data.PsiSqr(:,q)) / sum(data.PsiSqr(:,q)))
    q = q + 1;
end
%find "floor" energy level where electrons sit
o=1;
while sum(xIIwell .* data.PsiSqr(:,o)) / sum(data.PsiSqr(:,o)) < 0.05 ...
        || isnan(sum(xIIwell .* data.PsiSqr(:,o)) / sum(data.PsiSqr(:,o)))
    o = o + 1;
end

%find first lower state
p = q-1;
while ...%dipole(data.Psi(:,q), data.EigenE(q), data.Psi(:,p), data.EigenE(p),data.xpoints,data.Vcx,data.Mcx,data.Egx)^2 < 1 || ...
        sum(xARwell .* data.PsiSqr(:,p)) / sum(data.PsiSqr(:,p)) < 0.08
    p=p-1;
end

%for current calculations only
%q=o;

%initial transition energy
data.E0 = data.EigenE(q)-data.EigenE(p);

if data.E0 < 0.04
    showString{1} = 'error';
    set(handles.display_FoM3,'BackgroundColor','white');
    set(handles.display_FoM3,'String',showString);
    return
end

%set of upper states
data.qset = q;
q=q+1;
while 0.25 > abs(data.EigenE(q) - data.EigenE(data.qset(1)))
    if sum(xARwell .* data.PsiSqr(:,q)) / sum(data.PsiSqr(:,q)) > 0.015
        data.qset(length(data.qset)+1) = q;
    end
    q=q+1;
end
q=data.qset(1);

%set of all upper states
data.oset = o;
o=o+1;
while 0.25 > abs(data.EigenE(o) - data.EigenE(data.oset(1)))
    if (sum(xIIwell .* data.PsiSqr(:,o)) + sum(xARwell .* data.PsiSqr(:,o))) / sum(data.PsiSqr(:,o)) > 0.01
        data.oset(length(data.oset)+1) = o;
    elseif ~isempty(find(data.qset == o,1))
        data.oset(length(data.oset)+1) = o;
    end
    o=o+1;
end
o=data.oset(1);

%set of lower states
data.pset = p;
while 1.3*data.E0 > abs(data.EigenE(q) - data.EigenE(data.pset(length(data.pset))-1)) && ...
        sum(xARwell .* data.PsiSqr(:,data.pset(length(data.pset))-1)) / sum(data.PsiSqr(:,data.pset(length(data.pset))-1)) > 0.001
    data.pset(length(data.pset)+1) = data.pset(length(data.pset))-1;
end

%calculate dipoles
data.EL_Earray = linspace(0.7*data.E0,2*data.E0,9000);
data.EL_Parray = zeros(1,length(data.EL_Earray));
data.dp2 = zeros(length(data.pset),length(data.qset));
for m = 1:length(data.pset)
    for n = 1:length(data.qset)
       data.dp2(m,n) = dipole(data.Psi(:,data.qset(n)), data.EigenE(data.qset(n)), data.Psi(:,data.pset(m)), data.EigenE(data.pset(m)),...
           data.xpoints,data.Vcx,data.Mcx,data.Egx)^2;
       Etemp = data.EigenE(data.qset(n))-data.EigenE(data.pset(m));
       data.EL_Parray = data.EL_Parray + data.dp2(m,n) .* 1 ./ (1+ (Etemp - data.EL_Earray).^2 ./ ((0.1.*Etemp./2).^2));
    end
end

% figure(12)
% set(12,'Name','EL spectrum');
% plot(data.EL_Earray,data.EL_Parray);
% xlabel('Energy (eV)');


%find new E0
[junk,Emaxpoint] = max(data.EL_Parray);
data.E0 = data.EL_Earray(Emaxpoint);

%calculate line shape factor
data.gline = zeros(length(data.pset),length(data.qset));
for m = 1:length(data.pset)
    for n = 1:length(data.qset)
        data.gline(m,n) = 1 / (1+ (data.EigenE(data.qset(n))-data.EigenE(data.pset(m)) - data.E0)^2 / (0.1*data.E0/2)^2);
        %0.1*E0 / (2*pi) / ((data.EigenE(qset(n))-data.EigenE(pset(m)) - E0)^2 + (0.1*E0/2)^2);
          %gline = gline / (20 / E0 / pi);
    end
end

%truncate qset and pset
gl = data.gline .* data.dp2 < 3;
data.dp2 = data.dp2(sum(gl,2) ~= length(data.pset),sum(gl,1) ~= length(data.qset));
data.gline = data.gline(sum(gl,2) ~= length(data.pset),sum(gl,1) ~= length(data.qset));
data.qset = data.qset(sum(gl,1) ~= length(data.qset));
data.pset = data.pset(sum(gl,2) ~= length(data.pset));


% [val, ndxCol] = max(data.dp2);
% [val, ndxRow] = max(val);
% ndxCol = ndxCol(ndxRow);
% q = data.qset(ndxCol);
% p = data.pset(ndxRow);
% data.E0 = data.EigenE(q)-data.EigenE(p);

% %take out transition energies greater than 10% of transition
% Ens = zeros(length(data.pset),length(data.qset));
% for m = 1:length(data.pset)
%     for n = 1:length(data.qset)
%         Ens(m,n) = data.EigenE(data.qset(n))-data.EigenE(data.pset(m));
%     end
% end
% EnsMult = Ens;
% EnsMult(find(Ens/data.E0 > 1.1)) = 0;
% EnsMult(find(EnsMult ~= 0)) = 1;
% 
% %use EnsMult to remove unwanted states
% for m = length(data.pset):-1:1
%     if EnsMult(m,:) == 0
%         data.pset = [data.pset(1:m-1),data.pset(m+1:end)];
%     end
% end
% for n = length(data.qset):-1:1
%     if EnsMult(:,n) == 0
%         data.qset = [data.qset(1:n-1),data.qset(n+1:end)];
%     end
% end
% data.dp2 = data.dp2(1:length(data.pset),1:length(data.qset));
% EnsMult = EnsMult(1:length(data.pset),1:length(data.qset));

%upper state lifetimes
data.qsetLt = zeros(1,length(data.qset));
for n = 1:length(data.qset)
    lt1 = 0;
    for m = data.qset(n)-1:-1:1
        if abs(data.EigenE(data.qset(n))-data.EigenE(m)) > 0.055 && ...
                isempty(find(data.oset == m,1)) && ...
                sum(xIIwell .* data.PsiSqr(:,m)) / sum(data.PsiSqr(:,m)) < 0.02 && ...
                sum(xIwell .* data.PsiSqr(:,m)) / sum(data.PsiSqr(:,m)) < 0.10 && ...
                (data.qset(n) - m < 12 || ...
                abs(dipole(data.Psi(:,data.qset(n)), data.EigenE(data.qset(n)), data.Psi(:,m), data.EigenE(m),...
                data.xpoints,data.Vcx,data.Mcx,data.Egx)) > 0.05)    %0.055 meV hard coded, can be changed
            lftme = lifetime(data.Psi(:,data.qset(n)), data.EigenE(data.qset(n)), data.Psi(:,m), data.EigenE(m),...
                data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
                data.epshighf, data.hwlo, data.kp0);
            if isfinite(lftme)
                lt1 = lt1 + 1/lftme;
            end
        end
    end
    data.qsetLt(n) = 1/lt1;
end


%lower state lifetimes
data.psetLt = zeros(1,length(data.pset));
for n = 1:length(data.pset)
    lt1 = 0;
    for m = data.pset(n)-1:-1:1
        if data.pset(n) - m < 12 || abs(dipole(data.Psi(:,data.pset(n)), data.EigenE(data.pset(n)), data.Psi(:,m), data.EigenE(m),...
                data.xpoints,data.Vcx,data.Mcx,data.Egx)) > 0.05
            lftme = lifetime(data.Psi(:,data.pset(n)), data.EigenE(data.pset(n)), data.Psi(:,m), data.EigenE(m),...
                data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
                data.epshighf, data.hwlo, data.kp0);
            if isfinite(lftme)
                lt1 = lt1 + 1/lftme;
            else
            end
        end
    end
    data.psetLt(n) = 1/lt1;
end

%caculate injection weighting
% n2d = 0;
% statenum = 0;
% mc = 0.045 * data.me;  %need to put in real calculated mass
% total_doping = 2e15;
% ef0 = total_doping * pi * data.hbar^2 / mc; %2D Fermi energy at T = 0, Davies p.33    %total doping 4.5*^16 cm-3
% efT = data.kb * data.Temp * log( exp(ef0 / data.kb / data.Temp) - 1); %2D Fermi Energy at T > 0
% while n2d < total_doping && length(qset) > 1
%     statenum = statenum+1;
%     nj = mc * data.kb * data.Temp / pi / data.hbar^2 * log(1+exp((efT - data.EigenE(1,qset(statenum)))/data.kb/data.Temp)); %from Davies p. 134
%     n2d = n2d + nj
% end
% if length(qset) > 1
%     last_state_weight = 1 - (n2d - nj)/total_doping;
%     qset = qset(1:statenum);
%     Iweight = ones(1,length(qset));
%     Iweight(length(Iweight)) = last_state_weight;
%     Iweight = Iweight / sum(Iweight);
% else
%     Iweight = 1;
% end

% %calculate line shape factor
% data.gline = zeros(length(data.pset),length(data.qset));
% for m = 1:length(data.pset)
%     for n = 1:length(data.qset)
%         data.gline(m,n) = 1 / (1+ (data.EigenE(data.qset(n))-data.EigenE(data.pset(m)) - data.E0)^2 / (0.1*data.E0/2)^2);
%         %0.1*E0 / (2*pi) / ((data.EigenE(qset(n))-data.EigenE(pset(m)) - E0)^2 + (0.1*E0/2)^2);
%           %gline = gline / (20 / E0 / pi);
%     end
% end

%calculate Boltzmann factor
data.qsetBoltz = zeros(1,length(data.qset));
for n = 1:length(data.qset)
    data.qsetBoltz(n) = exp(-(data.EigenE(data.qset(n))-data.EigenE(data.qset(1))) / data.kb / data.TempFoM); % T set to 300K
end
%data.qsetBoltz = data.qsetBoltz / sum(data.qsetBoltz); %I don't think it should be normalized yet

% total_doping = data.total_doping;
% if total_doping == 0
%     total_doping = 4e15;
% end
% 
% mc = 0.045 * data.me;  %need to put in real calculated mass
% ef0 = total_doping * pi * data.hbar^2 / mc / data.e0; %2D Fermi energy at T = 0, Davies p.33    %total doping 4.5*^16 cm-3
% efT = data.kb * data.TempFoM * log( exp(ef0 / data.kb / data.TempFoM) - 1); %2D Fermi Energy at T > 0
% 
% data.osetBoltz = zeros(1,length(data.oset));
% data.osetLt = data.osetBoltz;
% for n = 1:length(data.oset)
%     data.osetBoltz(n) = 1 / (exp( ((data.EigenE(data.oset(n))-data.EigenE(data.oset(1)))-efT) / data.kb / data.TempFoM) + 1);%Fermi distribution;
%     ndx = find(data.oset(n) == data.qset);
%     if isempty(ndx)
%         data.osetLt(n) = 5e3;
%     else
%         data.osetLt(n) = data.qsetLt(ndx);
%     end
% end
% data.osetR = data.osetBoltz./data.osetLt / sum(data.osetBoltz./data.osetLt);
% data.qsetR = zeros(1,length(data.qset));
% for n = 1:length(data.qset)
%     ndx = find(data.qset(n) == data.oset);
%     if ~isempty(ndx)
%         data.qsetR(n) = data.osetR(ndx);
%     end
% end


%calculate t32
data.t32 = zeros(length(data.pset),length(data.qset));
for m = 1:length(data.pset)
    for n = 1:length(data.qset)
        data.t32(m,n) = lifetime(data.Psi(:,data.qset(n)), data.EigenE(data.qset(n)), data.Psi(:,data.pset(m)), data.EigenE(data.pset(m)),...
            data.xpoints, data.xres, data.Vcx, data.Mcx, data.Egx, data.Temp, data.epsstatic,...
            data.epshighf, data.hwlo, data.kp0);
    end
end

%pumping rate weighting factor
[junk, I1] = max(data.dp2,[],1);
[junk, I2] = max(junk,[],2);
pritranq = data.qset(I2);
pritranp = data.pset(I1(I2));

data.qsetBoltz(data.qset <= pritranq) = 1;

data.Rweight = (data.qsetBoltz ./ data.qsetLt) / sum(data.qsetBoltz ./ data.qsetLt);


%calculate Figure of Merit
data.FoM = zeros(length(data.pset),length(data.qset));
for m = 1:length(data.pset)
    for n = 1:length(data.qset)
        data.FoM(m,n) = data.Rweight(n) * data.qsetLt(n) * (1 - data.psetLt(m) / data.t32(m,n)) * data.dp2(m,n) * data.gline(m,n); %     * EnsMult(m,n)
    end
end

data.FoMsum = sum(sum(data.FoM));

showString{1} = ['upper states: ' num2str(data.qset)];
showString{2} = ['lower states: ' num2str(data.pset)];
showString{3} = ['E0 = ' num2str(data.E0*1000,'%11.1f') ' meV'];
showString{4} = ['FoM = ' num2str(data.FoMsum,'%12.1f') ' ps Å^2'];
showString{5} = ['FoM* = ' num2str(data.FoMsum*data.E0,'%12.1f') ' eV ps Å^2'];

set(handles.display_FoM3,'BackgroundColor','white');
set(handles.display_FoM3,'String',showString);

setappdata(handles.hErwinJr,'data',data);

'pause';




% --------------------------------------------------------------------
function menuStructurePlot_Callback(hObject, eventdata, handles)
% hObject    handle to menuStructurePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = getappdata(handles.hErwinJr,'data');

clear barriers indx indx2 indx3 wells

barriers = data.wellWidths(find(data.barrierSwitch==1));

indx = find(data.barrierSwitch==1);
indx2 = indx-1;
[X,Y] = meshgrid(indx, indx2);
indx3 = X(X==Y);
for q=1:length(indx3)-1
    barriers(indx==indx3(q)) = barriers(indx==indx3(q)) + barriers(indx2==indx3(q));
%     barriers(indx3(q)+1) = [];
%     indx3 = indx3-1;
end

% for q=1:length(indx3)
%     barriers = [barriers(1:find(indx==(indx3(q)-(q-1))));barriers(find(indx==(indx3(q)-(q-1))+2):end)];
% end

barriers(indx3(1:end-1)+1) = [];

barriers(end) = barriers(1) + barriers(end);
barriers = barriers(2:end);

wells = data.wellWidths(find(data.barrierSwitch==0));

scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)/6 scrsz(4)/3 scrsz(3)/1.5 scrsz(4)/3],'ToolBar','none')
subplot(1,2,1); p1 = plot(barriers,'o','MarkerFaceColor','b');
title('Barriers')
ylabel('barrier width (?')
set(gca,'YGrid','on')
subplot(1,2,2); plot(wells,'o','MarkerFaceColor','b');
title('Wells')
ylabel('well width (?')
set(gca,'YGrid','on')







% --------------------------------------------------------------------
function menuRunFoMPlot_Callback(hObject, eventdata, handles)
% hObject    handle to menuRunFoMPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = getappdata(handles.hErwinJr,'data');

data.EfieldRange = inputdlg('Enter Efield values','FoM Efield scan');
data.EfieldRange = str2num(data.EfieldRange{1});

data.FoMRange = zeros(1,length(data.EfieldRange));
data.E0Range = data.FoMRange;
data.JRange = data.FoMRange;
data.FoMRange(:) = NaN;
setappdata(handles.hErwinJr,'data',data);

for hh = 1:length(data.EfieldRange)
    set(handles.EfieldDisplay,'String',num2str(data.EfieldRange(hh),'%11.1f'))
    guidata(hObject, handles);
    
    EfieldDisplay_Callback(hObject, eventdata, handles);
    
    refreshRegionList(hObject, eventdata, handles);
    
    runButton_Callback(hObject, eventdata, handles);
    
    buttonFoM3_Callback(hObject, eventdata, handles);
    
    data = getappdata(handles.hErwinJr,'data');
    
    data.FoMRange(hh) = data.FoMsum;
    data.E0Range(hh) = data.E0;

% commented code below is to calculate J    
%        data.osetBoltz = zeros(1,length(data.oset));
%        data.osetLt = data.osetBoltz;
%        for n = 1:length(data.oset)
%            data.osetBoltz(n) = exp(-(data.EigenE(data.oset(n))-data.EigenE(data.oset(1))) / data.kb / data.TempFoM); % T set to 300K
%            ndx = find(data.oset(n) == data.qset);
%            if isempty(ndx)
%                data.osetLt(n) = 5e3;
%            else
%                data.osetLt(n) = data.qsetLt(ndx);
%            end
%        end
%        data.osetBoltz = data.osetBoltz / sum(data.osetBoltz);
%     data.JRange(hh) = sum(data.e0 .* 4e11 * data.osetBoltz ./ (data.osetLt*1e-12) ./ 2) * 1e-3; %4e11 is hard-wired sheet density
    
    setappdata(handles.hErwinJr,'data',data);
end

scrsz = get(0,'ScreenSize');
figure('Name','Figure of Merit','Position',[scrsz(3)/6 scrsz(4)/3 scrsz(3)/1.5 scrsz(4)/3],'ToolBar','none')
subplot(1,2,1); plot(data.EfieldRange,data.FoMRange);
title('Figure of Merit')
xlabel('Electric Field (kV/cm)')
ylabel('FoM (ps Å^2)')
set(gca,'YGrid','on')
subplot(1,2,2); plot(data.EfieldRange,data.E0Range*1000);
title('Peak Emission Energy')
xlabel('Electric Field (kV/cm)')
ylabel('E_0 (meV)')
set(gca,'YGrid','on')

'pause';


function display_ARwell_Callback(hObject, eventdata, handles)
% hObject    handle to display_ARwell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_ARwell as text
%        str2double(get(hObject,'String')) returns contents of display_ARwell as a double


% --- Executes during object creation, after setting all properties.
function display_ARwell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_ARwell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_FoM3Info.
function button_FoM3Info_Callback(hObject, eventdata, handles)
% hObject    handle to button_FoM3Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

try
    showString{1} = 'FoM = \Sigma_u< R_u \Sigma_l \tau_u (1 - \tau_l/\tau_u_l) z_u_l^2 g(E_u_l)';
    showString{1} = '';
    showString{2} = '';
    showString{3} = ['upper states: ' num2str(data.qset)];
    showString{4} = ['lower states: ' num2str(data.pset)];
    showString{5} = '';
    showString{6} = ['upper state lifetimes: ' num2str(data.qsetLt,'%11.3f')];
    showString{7} = ['lower state lifetimes: ' num2str(data.psetLt,'%11.3f')];
    showString{8} = ['upper (column) to lower (rows) state lifetimes'];
    showString{9} = num2str(data.t32,'%11.2f');
    showString{10} = '';
    showString{11} = ['dipoles'];
    showString{12} = num2str(sqrt(data.dp2),'%11.2f');
    showString{13} = '';
    showString{14} = ['Boltzmann distribution: ' num2str(data.qsetBoltz,'%11.3f')];
    showString{15} = ['R weighting: ' num2str(data.Rweight,'%11.3f')];
    showString{16} = '';
    showString{17} = ['gline weighting'];
    showString{18} = num2str(data.gline,'%11.3f');
    showString{19} = '';
    showString{20} = 'individual FoM contributions';
    showString{21} = num2str(data.FoM,'%11.1f');
    showString{22} = '';
    showString{23} = ['E_0 = ' num2str(data.E0*1000,'%11.1f') ' meV'];
    showString{24} = ['FoM = ' num2str(data.FoMsum,'%12.1f') ' ps Å^2'];
    showString{25} = ['FoM* = ' num2str(data.FoMsum*data.E0,'%12.1f') ' eV ps Å^2'];
    showString{26} = ['g = ' num2str(data.FoMsum / data.Lp / 27.96 * 1000,'%11.1f') ' cm/kA'];

    CreateStruct.WindowStyle='non-modal';
    CreateStruct.Interpreter='tex';
    msgbox2(showString,'FoM details',CreateStruct);
    
    fighan=figure;
    screenSize = get(0,'ScreenSize');
    height = 600;
    width = 640;
    showString(1:2)=[];
    set(fighan,'ToolBar','none','MenuBar','none', ...
        'Position',[floor(screenSize(3)/2-width/2) floor(screenSize(4)/2-height/2) width height]);
    hlist = uicontrol('Style','listbox','String',showString);
    set(hlist,'Units','normalized','Position',[0.02 0.1 0.96 0.89],'BackgroundColor',[1 1 1])
    set(hlist,'SelectionHighlight','off','Min',0,'Max',0,'ListboxTop',3)
    set(hlist,'FontName','Courier New','FontSize',11)
    hbutton = uicontrol('Style','pushbutton','String','close', ...
                        'Callback','closereq','Units','normalized','Position',[0.45 0.02 0.1 0.06]);
    
% %     figure;
% licfile=fopen('license.txt','r');
% dispstr=[];
% dispstr{1} = fgets(licfile);
% while dispstr{end} ~= -1
%     dispstr{end+1} = fgets(licfile);
% end
% fclose(licfile);
% dispstr(end)=[];
% 
% figure
% screenSize = get(0,'ScreenSize');
% jList=javax.swing.JScrollPane(javax.swing.JList(dispstr));
% % jList.setFont(java.awt.Font('Courier New', 0, 12))
% jList.setFont(javax.swing.plaf.FontUIResource('Courier New',0,12))
% % jList.setFont('new','java.awt.Font("Courier New", 0, 12)');
% % jList.setFont(javax.swing.plaf.FontUIResource('Courier New','Courier New','plain',11))
% [hList,hComp]=javacomponent(jList,[100 100 400 300],gcf);


catch
    errordlg('No FoM information calculated','Error');
end

'pause';



% --- Executes on button press in button_RunLucent.
function button_RunLucent_Callback(hObject, eventdata, handles)
% hObject    handle to button_RunLucent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
solverL(hObject, eventdata, handles);




function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in display_Solver.
function display_Solver_Callback(hObject, eventdata, handles)
% hObject    handle to display_Solver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns display_Solver contents as cell array
%        contents{get(hObject,'Value')} returns selected item from display_Solver
data = getappdata(handles.hErwinJr,'data');

sol_str = get(handles.display_Solver,'String');
data.solver = char(sol_str(get(handles.display_Solver,'Value')));
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);



% --- Executes during object creation, after setting all properties.
function display_Solver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_Solver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function display_IIregion_Callback(hObject, eventdata, handles)
% hObject    handle to display_IIregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_IIregion as text
%        str2double(get(hObject,'String')) returns contents of display_IIregion as a double


% --- Executes during object creation, after setting all properties.
function display_IIregion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_IIregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function menuSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menuSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_SolverDSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menu_SolverDSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_SolverLSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menu_SolverLSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_SolverHSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menu_SolverHSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function menu_ReadMe_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ReadMe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    web('http://qcllab.princeton.edu/ErwinJr_ReadMe.htm','-notoolbar','-noaddressbox');
catch
    errordlg('The ReadMe file is a webpage.  Internet connection needed.','Connection Error')
end





function display_InGaAsx2_Callback(hObject, eventdata, handles)
% hObject    handle to display_InGaAsx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_InGaAsx2 as text
%        str2double(get(hObject,'String')) returns contents of display_InGaAsx2 as a double
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
updateStrainButton_Callback(hObject, eventdata, handles);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function display_InGaAsx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_InGaAsx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_AlInAsx2_Callback(hObject, eventdata, handles)
% hObject    handle to display_AlInAsx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_AlInAsx2 as text
%        str2double(get(hObject,'String')) returns contents of display_AlInAsx2 as a double
data = getappdata(handles.hErwinJr,'data');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
updateStrainButton_Callback(hObject, eventdata, handles);
refreshRegionList(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function display_AlInAsx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_AlInAsx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function menu_Set_Callback(hObject, eventdata, handles)
% hObject  s  handle to menu_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_SetLayers_Callback(hObject, eventdata, handles)
% hObject    handle to menu_SetLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

str{1} = '';
str{2} = 'InGaAs/AlInAs:InP';
str{3} = 'ZnCdSe/ZnMgCdSe';
str{4} = 'InGaAs/AlInAs strained 1';
str{5} = 'InGaAs/AlInAs strained 2';
str{6} = 'ZnCdSe/ZnMgSe';
str{7} = 'GaAs/AlGaAs';

[selection,ok] = listdlg('PromptString','Set all layers to:','ListSize',[190 120],'SelectionMode','single','ListString',str);

if ok == 1;
    switch selection
        case 1
            
        case 2
            data.material(:) = 2;
        case 3
            data.material(:) = 3;
        case 4
            data.material(:) = 4;
        case 5
            data.material(:) = 5;
        case 6
            data.material(:) = 6;
        case 7
            data.material(:) = 7;            
        otherwise
            
    end

end

guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);


% --------------------------------------------------------------------
function menu_scDetails_Callback(hObject, eventdata, handles)
% hObject    handle to menu_scDetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');

str{1} = 'Default: Do Not Show Detailed Plots';
str{2} = 'Show Detailed Plots';
[selection,ok] = listdlg('PromptString','Self Consistent Details','ListSize',[200 50],'InitialValue',data.showSCplots+1,'SelectionMode','single','ListString',str);

if ok == 1 && selection == 1;
    data.showSCplots = 0;
elseif ok == 1 && selection == 2;
    data.showSCplots = 1;
else
    data.showSCplots = data.showSCplots;
end

guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);



% --------------------------------------------------------------------
function menu_mainPlotmod_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mainPlotmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.mainPlotmod)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg('Plot every Xth point in main axes','Plot Control',1,default,options);
if isempty(answer) == 0
    data.mainPlotmod = str2num(answer{1});
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    refreshRegionList(hObject, eventdata, handles);
%     runButton_Callback(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function menu_addPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to menu_addPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
data.wellWidths = [data.wellWidths;data.wellWidths];
data.regionNum = transpose(1:length(data.wellWidths));
data.arSwitch = [data.arSwitch;data.arSwitch];
data.barrierSwitch = [data.barrierSwitch;data.barrierSwitch];
data.material = [data.material;data.material];
data.doping = [data.doping;data.doping];
data.divider = [data.divider;data.divider];
data.layermod = 1;
set(handles.display_Lplayers,'String','');
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);




function display_scmax_Callback(hObject, eventdata, handles)
% hObject    handle to display_scmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_scmax as text
%        str2double(get(hObject,'String')) returns contents of display_scmax as a double


% --- Executes during object creation, after setting all properties.
function display_scmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_scmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function menu_undo_Callback(hObject, eventdata, handles)
% hObject    handle to menu_undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.undoButton,'Value') == 1
    set(handles.undoButton,'Value',0)
    set(handles.menu_undo,'Checked','off')
else
    set(handles.undoButton,'Value',1)
    set(handles.menu_undo,'Checked','on')
end




function display_slnreturn_Callback(hObject, eventdata, handles)
% hObject    handle to display_slnreturn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_slnreturn as text
%        str2double(get(hObject,'String')) returns contents of display_slnreturn as a double


% --- Executes during object creation, after setting all properties.
function display_slnreturn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_slnreturn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_Go.
function button_Go_Callback(hObject, eventdata, handles)
% hObject    handle to button_Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_Go

data = getappdata(handles.hErwinJr,'data');

iteratn = str2num(get(handles.display_slnreturn,'String'));

if iteratn > data.itertn
    errordlg('Return solution does not exist.');
    return
end

data.sc_count = 0;
set(handles.selfconButton,'Value',0);
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles);
data = getappdata(handles.hErwinJr,'data');
set(handles.selfconButton,'Value',1);

if iteratn == 1
        Vp = data.voltage_track(:,iteratn);
    elseif iteratn < 7
        Vp = 0.5 * (data.voltage_track(:,iteratn) + data.voltage_track(:,iteratn-1));
    elseif iteratn < 12
        Vp = (data.voltage_track(:,iteratn) + data.voltage_track(:,iteratn-1) + data.voltage_track(:,iteratn-2)) / 3;
    elseif iteratn < 16
        Vp = (data.voltage_track(:,iteratn) + data.voltage_track(:,iteratn-1) + data.voltage_track(:,iteratn-2) + data.voltage_track(:,iteratn-3)) / 4;        
    else
        Vp = (data.voltage_track(:,iteratn) + data.voltage_track(:,iteratn-1) + data.voltage_track(:,iteratn-2) + data.voltage_track(:,iteratn-3) + data.voltage_track(:,iteratn-4)) / 5;        
end
    
    data.Vcx = data.Vcx + Vp;
    data.VcxPlot = data.Vcx;
    
    data.sc_count = -1;  %make sure potential isn't reset in runButton_callback
    
    setappdata(handles.hErwinJr,'data',data);
    
    refreshRegionList(hObject, eventdata, handles);
    pause(0.2)
    runButton_Callback(hObject, eventdata, handles);

    figure(21)
    set(gcf,'Name',['voltage from iteration ' num2str(iteratn)]); plot(data.x,Vp)
    xlabel ('Position (?')
    ylabel ('Poisson Correction (eV)')
    
    




% --------------------------------------------------------------------
function menu_ELplot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_ELplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function menu_DiffusionLength_Callback(hObject, eventdata, handles)
% hObject    handle to menu_DiffusionLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(handles.hErwinJr,'data');
default = {num2str(data.Ld)};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg('Material Diffusion Length (?','Solver Control',1,default,options);
if isempty(answer) == 0
    data.Ld = str2num(answer{1});
    data.layermod = 1;
end
guidata(hObject, handles); setappdata(handles.hErwinJr,'data',data);
if isempty(answer) == 0
    refreshRegionList(hObject, eventdata, handles);
%     runButton_Callback(hObject, eventdata, handles);
end



% --- Executes on selection change in display_periods.
function display_periods_Callback(hObject, eventdata, handles)
% hObject    handle to display_periods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns display_periods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from display_periods
data = getappdata(handles.hErwinJr,'data');
data.PlotPeriods = get(handles.display_periods,'Value');
data.layermod = 1;
setappdata(handles.hErwinJr,'data',data);
refreshRegionList(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function display_periods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_periods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function menu_plotValleys_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plotValleys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = getappdata(handles.hErwinJr,'data');

if data.flagLvalley && data.flagXvalley
    mode = 4;
elseif data.flagLvalley
    mode = 3;
elseif data.flagXvalley
    mode = 2;
else
    mode = 1;
end

str{1} = 'neither';
str{2} = 'X valley';
str{3} = 'L valley';
str{4} = 'X & L valleys';
[selection,ok] = listdlg('PromptString','Select input mode:','ListSize',[160 80],'InitialValue',mode,'SelectionMode','single','ListString',str);

if ok == 1 && selection == 4;
    data.flagLvalley = 1;
    data.flagXvalley = 1;
elseif ok == 1 && selection == 3;
    data.flagLvalley = 1;
    data.flagXvalley = 0;
elseif ok == 1 && selection == 2;
    data.flagLvalley = 0;
    data.flagXvalley = 1;
elseif ok == 1 && selection == 1;
    data.flagLvalley = 0;
    data.flagXvalley = 0;
else
    data.flagLvalley = data.flagLvalley;
    data.flagXvalley = data.flagXvalley;
end

setappdata(handles.hErwinJr,'data',data)
refreshRegionList(hObject, eventdata, handles)