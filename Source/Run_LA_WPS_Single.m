function [ St, uSt, Ln, W, wTemp, wndSpd, metaT, metaB, thermD, SthermD, ...
         SmetaB, SmetaT, SuSt, SLn, SW, N2, SN2, T1, ST1 ...
       ] = Run_LA_WPS_Single(time,...
            bthFileName, level, windSpeed, wtrFileName, salFileName,   ...
            totalDepth, windHeight,  maxWaterTemp,  minWaterTemp, ...
            metaMinSlope,  mixedTempDifferential)
  function writeFile(file, attr, value)
    fid = fopen(file, 'w');
    fprintf(fid, '%s\t%s\r\n', 'dateTime', attr);
    fprintf(fid, '%s\t%f\r\n', datestr(time, 'yyyy-mm-dd HH:MM'), value);
    fclose(fid);
  end

  inFileNames = struct('bthFileName', bthFileName, ...
                       'wtrFileName', wtrFileName);

  %% null inputs are encoded as NaN
  if ~isnan(salFileName)
      inFileNames.salFileName = salFileName;
  end

  if ~isnan(level)
    inFileNames.lvlFileName = [tempname '.lvl'];
    writeFile(inFileNames.lvlFileName, 'level(positive Z down)', level);
  end

  if ~isnan(windSpeed)
    inFileNames.wndFileName = [tempname '.wnd'];
    writeFile(inFileNames.wndFileName, 'windSpeed', windSpeed);
  end

  %% only require raw outputs
  outFileNames = struct('results',    [tempname '.out'], ...
                        'resultsWtr', [tempname '.out']);

  %% disable downsampling
  windAveraging = 1;
  layerAveraging = 1;
  outlierWindow = 1;
  minWindSpeed = -inf;
  maxWindSpeed = inf;
  outputResolution = 1;

  %% call LA
  LA({'St', 'uSt', 'Ln', 'W', 'wTemp', 'wndSpd', 'metaT', 'metaB', 'thermD', ...
      'SthermD', 'SmetaB', 'SmetaT', 'SuSt', 'SLn', 'SW', 'N2', 'SN2', 'T1', ...
      'ST1'},                                                                ...
    outputResolution, totalDepth, windHeight, windAveraging, layerAveraging, ...
    outlierWindow, maxWaterTemp, minWaterTemp, maxWindSpeed, minWindSpeed,   ...
    metaMinSlope, mixedTempDifferential, inFileNames, outFileNames, {}, 0, 1);

  %% delete temporary files

  %% read raw file
  fprintf('Reading results from %s\n', outFileNames.results);
  dat = readtable(outFileNames.results, 'FileType', 'text', 'Delimiter', '\t');

  %% return outputs
  St       = dat.St;
  uSt      = dat.uSt;
  Ln       = dat.Ln;
  W        = dat.W;
  wndSpd   = dat.wndSpd;
  metaT    = dat.metaT;
  metaB    = dat.metaB;
  thermD   = dat.thermD;
  SthermD  = dat.SthermD;
  SmetaB   = dat.SmetaB;
  SmetaT   = dat.SmetaT;
  SuSt     = dat.SuSt;
  SLn      = dat.SLn;
  SW       = dat.SW;
  N2       = dat.N2;
  SN2      = dat.SN2;
  T1       = dat.T1;
  ST1      = dat.ST1;
  wTemp    = outFileNames.resultsWtr;

  %% cleanup
  delete(outFileNames.results);
  if isfield(inFileNames, 'lvlFileName')
    delete(inFileNames.lvlFileName);
  end
  if isfield(inFileNames, 'wndFileName')
    delete(inFileNames.wndFileName);
  end
end