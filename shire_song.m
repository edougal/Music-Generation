% plays the lord of the rings
%
% loads notes, durations, and octaves from shiresong.xlsx, generates flute
% notes using "note" function, string notes using "string_accomp" function
% and horn notes using "horn" function.
%

clear all
close all

fileToRead1 = 'shiresong.xlsx';

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

%length(n)
%length(t)
%length(octave)


fileToRead1 = 'stringaccomp.xlsx';

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

% ------ break

for i = 1:(length(textdata)-1)
    
n1{i} = textdata{1,1+i};
n2{i} = textdata{2,1+i};
n3{i} = textdata{3,1+i};

end

t1 = data(1,:);
octave1 = data(2,:);
octave2 = data(3,:);
octave3 = data(4,:);

fs = 100000;
s = [];

% ------ synthesis


for i = 1:length(n)

    f1 = flute(n{i},fs,3,t(i),octave(i));
    s = [s f1];

end

s3 = [];

% does the acommpaniement

for i = 1:length(n1)

    f2 = string_accomp(n1{i},fs,3,t1(i),octave1(i));
    f3 = string_accomp(n2{i},fs,3,t1(i),octave2(i));
    f4 = string_accomp(n3{i},fs,3,t1(i),octave3(i));
 
    s3 = [s3 f2+f3+f4];
    
end

s3 = [s3 zeros(1,length(s)-length(s3))] / 4;

s = s + s3;

% ---------- horn music

fileToRead1 = 'horns.xlsx';

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

n = {};
t = [];
octave = [];

for i = 1:(length(textdata)-1)
    
n{i} = textdata{1,1+i};

end
t = data(1,:);
octave = data(2,:);

for i = 1:length(n)

    s = [s horn(n{i},fs,3,t(i),octave(i))];

end

soundsc(s,fs)

wavwrite(s,fs,32,'shire_song.wav')
