function Run_LA( LakeName,Folder,skipLoad)
%----Author: Jordan S Read 2009 ----
%----version 3.3.1 2013-05-10 ------

if nargin < 3
    skipLoad = false;
end
clc; close all
done = false;
if ~skipLoad
    build_config(LakeName,Folder);
    while ~done
        pause(.4)
    end
    pause(0.1);
end

fprintf(['Reading ' LakeName '.lke file'])

[outPuts,outRs,maxZ,wndH,wndAv,lyrAv,outWn,wtrMx,wtrMn,...
    wndMx,wndMn,drhDz,Tdiff,plotYes,writeYes] = OpenCfg( LakeName,Folder );

fprintf('...completed\n\n') ;

inFileNames = struct(...
    'pltFileName', [Folder '/' LakeName '.plt'],...
    'bthFileName', [Folder '/' LakeName '.bth'],...
    'lvlFileName', [Folder '/' LakeName '.lvl'],...
    'wndFileName', [Folder '/' LakeName '.wnd'],...
    'wtrFileName', [Folder '/' LakeName '.wtr'],...
    'salFileName', [Folder '/' LakeName '.sal'] ...
);

outFileNames = struct(...
    'results',    [Folder '/' LakeName '_results.csv'],...
    'resultsWtr', [Folder '/' LakeName '_results_wtr.csv']...
);

for i = 1:numel(outPuts);
    outFileNames.([char(outPuts{i}) 'Fig']) = ...
        [Folder '/' LakeName '_' char(outPuts{i})];
end

pltMods = [];
if plotYes
    fprintf(['Checking for ' inFileNames.pltFileName ' file*'])
    oper = fopen(inFileNames.pltFileName);
    if eq(oper,-1)
        fprintf('...not found [*is optional]\n\n')
    else
        
        pltMods = pltFileOpen(inFileNames.pltFileName);
        fprintf('...completed\n');
    end
end


LA(outPuts,outRs,maxZ,wndH,wndAv,lyrAv,outWn,wtrMx,wtrMn,wndMx,wndMn,drhDz,...
    Tdiff,inFileNames,outFileNames,pltMods,plotYes,writeYes);
