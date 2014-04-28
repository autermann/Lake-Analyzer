
time = datenum(datestr('2009-05-02 10:00', 'yyyy-mm-dd HH:MM'))

level = 0.54
windSpeed = 5.080;
bthFileName = '../Data-Single/Sparkling.bth'
wtrFileName = '../Data-Single/Sparkling.wtr'
salFileName = NaN;
totalDepth = 20;
windHeight = 2;
maxWaterTemp = 40;
minWaterTemp =-12;
metaMinSlope =0.05;
mixedTempDifferential =.0;
mixedTempDifferential =.5;

[ St, uSt, Ln, W, wTemp, wndSpd, metaT, metaB, thermD, SthermD, SmetaB, SmetaT, SuSt, SLn, SW, N2, SN2, T1, ST1 ] ...
	= Run_LA_WPS_Single(time, bthFileName, level, windSpeed, wtrFileName, salFileName, totalDepth, windHeight, ...
							maxWaterTemp,  minWaterTemp, metaMinSlope,  mixedTempDifferential)