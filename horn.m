% Horn Sound
%
% Coefficients from http://iie.fing.edu.uy/~rocamora/wind_synthesis/doc/
%



function s = horn(pitch,fs,duration,quarter,octave)

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

F = zeros(length(tvec),10);

%v = 1/(ff/500)*[0.17, 0, 0.63, 0, 0.57, 0, 0.98, 0, 0.56, 0, 0.38, 0.19, 0.05, 0.03, 0.02, 0.01]';
v = 1/(ff/20)*[6.236 12.827 21.591 11.401 3.570 2.833 3.070 1.053 0.773 1.349 0.819 0.369 0.362 0.165 0.124 0 0.026 0.042]';
for k = 1:length(v)
    F(:,k) = sin(2*pi*(k-1)*ff*tvec);
end

s = (F*v)';

t = [(duration*quarter)*.6 (duration*quarter)*.7 (duration*quarter)*.8 (duration*quarter)*.9];
a = [1 .9 .8 .7 .7];

len = duration*quarter;

s = s.*[1.2*(sin(pi* [tau:tau:len/2]) ) ...
						ones(1, length([len/2:tau:len]) - 1) ];
s = (s./max(s))*.7;
if octave == 3
   s = s*.2; 
end
y = ADSR(t,a,'exponential',tvec);
s = s.*y;

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
        
        y(m) = a(3)*exp(-.05*lambda*(tvec(m)-t(3)));
        
    end     
            
else
    display('failure, type should be "exponential" or "linear"')
    return    
end

%plot(t,a,'r-')
%hold on

%plot(tvec,y,'b*')

return




