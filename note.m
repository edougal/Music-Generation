%
% flute sound
%
% Coefficients for additive synthesis and part of envelope taken from 
% http://www.ugcs.caltech.edu/~tasha/ 
%



function s = note(pitch,fs,duration,quarter,octave)

mult = 2^(octave-4);

pitches.('a') = 440;
pitches.('as') = 466.16;
pitches.('b') = 493.88;
pitches.('c') = 523.25;
pitches.('cs') = 554.37;
pitches.('d') = 587.33;
pitches.('ds') = 622.25;
pitches.('e') = 659.26;
pitches.('f') = 698.46;
pitches.('fs') = 739.99;
pitches.('g') = 783.99;
pitches.('gs') = 830.61;
pitches.('z') = 0;

ff = pitches.(pitch) * mult;


tau = 1/fs;
tvec = tau:tau:duration*quarter;

F = zeros(length(tvec),4);
for k = 1:4
    F(:,k) = sin(2*pi*(k-1)*ff*tvec);
end
v = [2.54, .245, .009, .00001]';

s = (F*v)';

t = [(duration*quarter)*.1 (duration*quarter)*.5 (duration*quarter)*.7 (duration*quarter)*.9];
a = [1 1 1 1];

len = duration*quarter;
sine_coefficient = [(sin((pi* [tau:tau:len/2]) / (len)) ) ...
						ones(1, length([len/2.0:tau:len])-1) ];

y = ADSR(t,a,'exponential',tvec);
s = s.*y;

if length(s) < length(sine_coefficient)
   sine_coefficient = sine_coefficient(1:length(s));
end

if length(s) > length(sine_coefficient)
   s = s(1:length(sine_coefficient));     
end

s = s.*sine_coefficient;

return


function [y] = ADSR(t,a,type,tvec)

y = zeros(1,length(tvec));
if strcmp(type,'linear')
    slopes = [a(1)/t(1) (a(2)-a(1))/(t(2)-t(1)) (a(3) - a(2))/(t(3) - t(2)) (a(4) - a(3))/(t(4)-t(3))];    
    for i = 2:length(tvec)
        if tvec(i) <= t(1)
            y(i) = y(i-1) + slopes(1)*(tvec(i)-tvec(i-1));
        elseif tvec(i) <= t(2)
            y(i) = y(i-1) + slopes(2) *(tvec(i)-tvec(i-1));
        elseif tvec(i) <= t(3)
            y(i) = y(i-1) + slopes(3)*(tvec(i)-tvec(i-1));
        else
            y(i) = y(i-1) + slopes(4)*(tvec(i)-tvec(i-1));                        
        end        
    end
%    return
elseif strcmp(type,'exponential')
    j = 1;

    lambda = log(2)/t(1);
     while(tvec(j) < t(1))
         y(j) = a(1)*(exp(lambda*tvec(j)) - 1);
         j = j + 1;
     end
     
    lambda = -log(a(2)/a(1))/(t(2)-t(1));

    while(tvec(j) < t(2))
         y(j) = a(1)*exp(-lambda*(tvec(j)-t(1)));
         j = j + 1;
    end

    lambda = -log(a(3)/a(2))/(t(3)-t(2));

    while(tvec(j) < t(3))
         y(j) = a(2)*exp(-lambda*(tvec(j)-t(2)));
         j = j + 1;
    end

    lambda = a(3)/(t(4) - t(3));
    
	for m = j:length(tvec)
        
        y(m) = a(3)*exp(-4*lambda*(tvec(m)-t(3)));
        
    end     
            
else
    display('failure, type should be "exponential" or "linear"')
    return    
end

%plot(t,a,'r-')
%hold on

%plot(tvec,y,'b*')

return




