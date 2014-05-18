%fileToRead1 = 'song.xlsx';


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


for i = 1:(length(textdata)-1)
    
n{i} = textdata{1,1+i};

end
t = data(1,:);
octave = data(2,:);

fs = 100000;
s = [];

length(n)
length(t)
length(octave)

for i = 1:length(n)

    s = [s horn(n{i},fs,3,t(i),octave(i))];

end
  
 soundsc(s,fs)

