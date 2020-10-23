clear;clc
if ~exist('weather_data', 'dir')
       mkdir('weather_data')
end
% This script generates an hourly climate data file between the two chosen
% date. For this project, this script has been used to generate climate
% data for the summer and winter periods of 2019 specifically.

% This script is a thoroughly modded and adapted version or the script
% created for the IAM weather data project; it pulls it's files from the
% unh weather page.
%% Save Files
startDate = '2019-01-01';
endDate = '2019-12-31';
d = datetime(startDate);
count = 1;

while datetime(endDate) >= d
    dateRange(count,1) = day(d,'dayofyear');
    dateRange(count,2) = year(d);
    d.Day = d.Day + 1;
    count = count+1;
end


for i = 1:size(dateRange,1)
    day = dateRange(i,1);
    year = dateRange(i,2);
    filename = sprintf('weather_data_%d_%d.txt', year, day);
    if isfile(sprintf('weather_data/%s',filename))   %.... check, so you don't download more than once
        fprintf('already have the file |%s|\n',filename);%  %s is used to input
        %   the filename into the error statement
    else%   get the file from the web
        url = sprintf('http://www.weather.unh.edu/data/%d/%d.txt', year, day);
        outname = websave(sprintf('weather_data/%s',filename),url);% Saves the file to a
        %subfolder based on the url and filename arguments
        fprintf('got weather data file |%s|\n',outname);
    end
end
%% Open Files
globalCount = 0;
count = -1;

timestamp = zeros(1,1440*length(dateRange));
tempC = zeros(1,1440*length(dateRange));

for i = 1:size(dateRange,1)
    day = dateRange(i,1);
    year = dateRange(i,2);
    filename = sprintf('weather_data_%d_%d.txt',year ,day);
    fid1=fopen(sprintf('weather_data/%s',filename));  %.... open the file, MATLAB assigns an ID. This ID
    %is the read access ID, -1 if it can't open, 0 is standard input
    count=-1;           %   Line counter. Interates every loop of the 
    %while loop; this counts the lines that have been analysed by the loop
    while ~feof(fid1)   %   Test for end of file (EOF) Returns a 1 if the
    %file has been completely read
        line=fgetl(fid1);  %get the next line, removes any new line 
        %       characters. Iterates automatically. When it gets to the last 
        %       line feof returns 0
        count=count+1;
        if count==0; continue; end   %  skip the header line 
        %  header line in the file:
        %  Datetime,RecNbr,WS_mph_Avg,PAR_Den_Avg,WS_mph_S_WVT,WindDir_SD1_WVT,AirTF_Avg,Rain_in_Tot,RH,WindDir_D1_WVT
        la=split(line,',');     %.... split the line on commas, store in array 
        %la ,this allows us to separate the data into smaller, more discrete, chunks
        
        tempC(count+globalCount) = (str2double(la(7)) - 32)*5/9;
        timestamp(count+globalCount) = posixtime(datetime(la(1)));  %..... epoch time seconds since 1/1/1970 00:00
    end
    fclose(fid1);
    fprintf('%d\n',(day + 365*(year - dateRange(1,2)) - dateRange(1,1)))
    globalCount = count+globalCount;
end
%% Save Variables to file
% converting the variables to hourly values
% indexArray = 1:length(tempC);
% hourIndices = mod(indexArray,60) ~= 1;
% tempC(hourIndices) = [];
% timestamp(hourIndices) = [];

save('weather_2019','timestamp','tempC')
%% PLOT TEST
taxis = datetime(timestamp,'convertfrom','posixtime');

plot(taxis,tempC)
