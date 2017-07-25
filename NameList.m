function [FileName,PathName] = NameList(Option, Memoryfile, DialogTitle, FilterSpec, DefaultName)
%----------------------------------------------------------
% Description:Function that implements uigetfile
% and uiputfile with memory of last location of last
% put or get file. Script is very flexible and can accept a range of 1 to 5
% inputs.
% Configuration Control:
% Version :V1
%	  :Inital release
% Version :V2
% 	  : Added try and catch when trying to reach memory directory.
%	  : Added variable number of inputs and a swtich nargin default statements
%	  : Added documentation, comments and examples
%
%----------------------------------------------------------
% Date: 9_29_06
%----------------------------------------------------------
% Created by:Rami Neseem
%----------------------------------------------------------
% Inputs:
%             FilterSpec: determines the initial display of files and can
%             include the * wildcard. For example, '*.m' lists all the MATLAB
%             DialogTitle:appears in the File name field
%             DefaultName:default file name
%             Option:use  'get' to use uigetfile
%                       and  'put' to use uiputfile
%             Memoryfile: used to store last location visited
% % Ouputs:
%             FileName:
%             PathName:
%----------------------------------------------------------
%Example:
% get a file with NameList
% [FileNameIn,PathNameIn]= NameList('get','SourceMemory.mem','Select File to Open', '*.*','');
% out a file with NameList
% [FileNameIn,PathNameIn]= NameList('put','DestinationMemory.mem','Select File to Write', '*.*','');
% for a quick call, use [FileNameIn,PathNameIn]= NameList('get','SourceMemory.mem') or
% [FileNameIn,PathNameIn]= NameList('put','DestinationMemory.mem')
% see uigetfile and uiputfile for extended help
%----------------------------------------------------------
base=pwd; %set directory to current directory
% allow for different number of input parameters and
% set default parameters accordingly
switch (nargin)
    case 1
        switch (Option)
            case 'get'
                DialogTitle='Select File to Open';
                Memoryfile='File2ReadMemory.mem';
            case 'put'
                DialogTitle='Select File to Write';
                Memoryfile='File2WriteMemory.mem';
            otherwise
                error('NameList.m Options are put or get');
        end
        FilterSpec='*.*';
        DefaultName='';
    case 2
        switch (Option)
            case 'get'
                DialogTitle='Select File to Open';
            case 'put'
                DialogTitle='Select File to Write';
            otherwise
                error('NameList.m Options are put or get');
        end
        FilterSpec='*.*';
        DefaultName='';
    case 3
        FilterSpec='*.*';
        DefaultName='';
    case 4
        DefaultName='';
end


% check if memory file exists
if exist(Memoryfile)
    fid=fopen(Memoryfile,'r');
    NewPath=fgetl(fid); % get stored path from memory file
    if strcmp(NewPath,'')
        NewPath=base;
    elseif  isnumeric(NewPath)
        NewPath=base;
    end

else % create memory file
    fid=fopen(Memoryfile,'w');
    fprintf(fid,'%s',base);% write current path to memory file
    NewPath=base;
end
fclose(fid);





switch (Option)

    case 'get'
        % making sure new path stored in memory file exists and can be reached
        % if not use current directory
        try
            cd (NewPath);
        catch
            cd (base);
        end
        [FileName,PathName]=uigetfile(FilterSpec,DialogTitle,DefaultName);
        if isequal(FileName,0) || isequal(PathName,0)
            cd(base);
            return
        else
            cd (base);
            fid=fopen(Memoryfile,'w');
            fprintf(fid,'%s',PathName);

            fclose(fid);
        end


    case 'put'
        % making sure new path stored in memory file exists and can be reached
        % if not use current directory
        try
            cd (NewPath);
        catch

            cd (base);
        end
        [FileName,PathName] =uiputfile(FilterSpec,DialogTitle, DefaultName);
        if isequal(FileName,0) || isequal(PathName,0)
            cd(base);
            return
        else
            cd (base);
            % open and store path used above in memory file for used next time
            % function is called
            fid=fopen(Memoryfile,'w');
            fprintf(fid,'%s',PathName);
            fclose(fid);
        end

    otherwise
        error('NameList.m Options are put or get');
end
return
%--------------------------------------------------------------------