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

function ButtonName=authdlg()

CBString='uiresume(gcbf)';
ciData = [];
ciMap = [];
term_str = [];
load 'rsc.mat'
    
 
%     termfile=fopen('erwinjr_src\terms.txt','r');
%     if termfile == -1 %license.txt has been removed
%         [termfile,status] = urlread('http://www.kfranz.com/erwinjr/terms.txt');
%         if status == 0 %no we connection
%             term_str = lic_str;
%         else
%             term_str=[];
%             term_str = textscan(termfile,'%s','Delimiter','\n','Whitespace','');
%             term_str = term_str{1};
%         end
%     else
%         term_str=[];
%         term_str{1} = fgets(termfile);
%         while term_str{end} ~= -1
%             term_str{end+1} = fgets(termfile);
%         end
%         fclose(termfile);
%         term_str(end)=[];
%     end
%     term_str{1} = '';

if isempty(term_str)
    term_str{1} = '';
    term_str{2} = 'Copyright (c) 2007-2008, Kale J. Franz';
    term_str{3} = 'All rights reserved.';
    term_str{4} = '';
    term_str{5} = 'Go to http://www.kalefranz.com/erwinjr/license.txt for the full license file.';
end

  fighan=figure('Name','ErwinJr','IntegerHandle','off','NumberTitle','off');
%     set(fighan,'WindowStyle','modal','Visible','off');
    screenSize = get(0,'ScreenSize');
    height = 500;
    width = 680;
    set(fighan,'ToolBar','none','MenuBar','none', 'Resize','off',...
        'Position',[floor(screenSize(3)/2-width/2) floor(screenSize(4)/2-height/2) width height]);

    height=182; width=542; figSize=get(fighan,'Position');
    axes('Units','pixels','Position',[floor(figSize(3)/2-width/2) floor(figSize(4)-height-10) width height],'Visible','off')
%     [ciData,ciMap] = imread('erwinjrgif.gif');
%     ciMap=ciMap(1:12,:);
%     ciMap(end,:) = get(gcf,'Color');
%     ciMap(1,:)   = get(gcf,'Color');
%     imshow(logo,ciMap)
    image(ciData); colormap(ciMap)
    axis off
    axis image


    hlist = uicontrol('Style','listbox','String',term_str);
    set(hlist,'Units','normalized','Position',[0.02 0.2 0.96 0.40],'BackgroundColor',[1 1 1])
    set(hlist,'SelectionHighlight','off','Min',0,'Max',0)
    set(hlist,'FontName','Courier New','FontSize',10)

    hbuttonAccept = uicontrol(        ...
        'FontWeight',   'bold',       ...
        'Style',        'pushbutton', ...
        'String',       'I Accept',   ...
        'Tag',          'yip',     ...
        'Units',        'normalized', ...
        'Position',     [0.21 0.02 0.18 0.06], ...
        'KeyPressFcn',  @doControlKeyPress, ...
        'CallBack',     CBString      ...
        );
    
    hbuttonFull = uicontrol(        ...
        'Style',        'pushbutton', ...
        'String',       'Read Full License',   ...
        'Tag',          'readfull',     ...
        'Units',        'normalized', ...
        'Position',     [0.41 0.02 0.18 0.06], ...
        'KeyPressFcn',  @doControlKeyPress, ...
        'CallBack',     {@doFullLicense,hlist}  ...
        );

    
    hbuttonClose = uicontrol( ...
        'FontWeight',   'bold',       ...
        'Style',        'pushbutton', ...
        'String',       'Close',      ...
        'Tag',          'meh',      ...
        'Units',        'normalized', ...
        'Position',     [0.61 0.02 0.18 0.06], ...
        'KeyPressFcn',  @doControlKeyPress, ...
        'CallBack',     CBString      ...        
    );

    pos = [0.2 0.11 0.6 0.05];
    h = uicontrol('Style','Text','Units','normalized','Position',pos);
    textstr{1} = 'By clicking "I Accept" or otherwise continuing use, you acknowledge compliance with and accept the full license terms and conditions for the use of this software.';
    [outstring,newpos] = textwrap(h,textstr);
    set(h,'String',outstring,'BackgroundColor',get(gcf,'Color'))

    

    set(fighan,'ToolBar','none','MenuBar','none');
    set(fighan ,'WindowStyle','modal','Visible','on');
    drawnow;

% uicontrol(hbuttonAccept)

if ishandle(fighan)
  % Go into uiwait if the figure handle is still valid.
  % This is mostly the case during regular use.
  uiwait(fighan);
end

% Check handle validity again since we may be out of uiwait because the
% figure was deleted.
if ishandle(fighan)
  ButtonName=get(get(fighan,'CurrentObject'),'Tag');
  doDelete;
else
  ButtonName='';
end

  function doFigureKeyPress(obj, evd)  %#ok
    switch(evd.Key)
      case {'g'}
          uiresume(gcbf);
      case 'escape'
        doDelete
    end
  end

  function doControlKeyPress(obj, evd)  %#ok
    switch(evd.Key)
      case {'g'}
          uiresume(gcbf);
      case 'escape'
        doDelete
    end
  end

  function doDelete(varargin)  %#ok
    delete(fighan);
  end

    function doFullLicense(obj, evd, hlist, lic_str)
        licfile=fopen('erwinjr_src\license.txt','r');
        if licfile == -1 %license.txt has been removed
            [licfile,status] = urlread('http://www.kfranz.com/erwinjr/license.txt');
            if status == 0 %no we connection
                lic_str{1} = '';
                lic_str{2} = 'Copyright (c) 2007-2008, Kale J. Franz';
                lic_str{3} = 'All rights reserved.';
                lic_str{4} = '';
                lic_str{5} = 'Go to http://www.kalefranz.com/erwinjr/license.txt for the full license file.';
            else
                lic_str=[];
                lic_str = textscan(licfile,'%s','Delimiter','\n','Whitespace','');
                lic_str = lic_str{1};
            end
        else
            lic_str=[];
            lic_str{1} = fgets(licfile);
            while lic_str{end} ~= -1
                lic_str{end+1} = fgets(licfile);
            end
            fclose(licfile);
            lic_str(end)=[];
        end
        lic_str{1} = '';

        set(hlist,'String',lic_str)
    end

end
