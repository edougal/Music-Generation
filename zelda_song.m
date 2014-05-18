
% plays the legend of zelda song
%
% loads notes, durations, and octaves from zelda.xlsx, generates flute
% notes using "note" function
%
%



clear all
close all

fileToRead1 = 'zelda.xlsx';

sheetName='Sheet1';
[numbers, strings] = xlsread(fileToRead1, sheetName);
if ~isempty(numbers)
    newData1.data =  numbers;
end
if ~isempty(strings)
    newData1.textdata =  strings;
end

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end
% ------- break


for i = 1:(length(textdata)-1)
    
n{i} = textdata{1,1+i};

end
t = data(1,:);
octave = data(2,:);

fs = 100000;
s = [];

for i = 1:length(n)

    s = [s flute(n{i},fs,2,t(i),octave(i))];

end
 
soundsc(s,fs)
wavwrite(s,fs,32,'zelda.wav')

