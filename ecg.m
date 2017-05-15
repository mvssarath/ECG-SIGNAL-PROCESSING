% first we load the Given Raw ECG signal and plot it on a graph and denote
% the number of samples present in the signal
clear winopt1;
sig1=load('ecg.txt');
plot(sig1);
xlabel('samples');
ylabel('activity');
title('Raw ECG Signal');

% we measure the length of the signal for further calculations the length
% of the signal in this case is the duration of the signal 
filename='ecg.txt';
% N=1;
% [~,Fs]=textread(filename,N);
fs=100;
L=length(sig1);

% now we denote the possible samples on the plot using a matlab command
% hold on;
% plot(sig1,'R0');

%  After detecting the length and sampling rate of the signal we then
%  proceed to the first step in the algorithm that is passing it through a
%  FFT transformation and lower frequencies are removed.

fftres=fft(sig1);
fftres(1: round(length(fftres)/fs))=0;
fftres(end-round(length(fftres)/fs) : end)=0;
% after the FFT transformation accordinf to the algorithm we get back the
% original signal by running a inverse FFt on the FFT
correction=real(ifft(fftres));
% passing the FFT treated signal into a windowed signal whosse size is
% determined by the input automatically

windowsize=floor(fs*L/1000);
if rem(windowsize,2)==0
    windowsize=windowsize+1;
end

filter1=winopt1(correction,windowsize);
% scaling the ecg
peak1=filter1/(max(filter1)/7);
% filtering thus obtained ecg by a threshold filter
for data=1:1:length(peak1)
    if peak1(data)<4
        peak1(data)=0;
    else
        peak1(data)=1;
    end
end
position=find(peak1);
dist=position(2)-position(1);
for data=1:1:length(positions)-1
    if positions(data+1)-positions(data)<dist
        dist=position(data+1)-position(data);
    end
end
% setting the filter window size
dist2=floor(0.04*fs);
if rem(dist2,2)==0
    dist2=dist2+1;
end
windowsize=2*dist-dist2;
% passing the output onto a second filter
filter2=winopt2(correction,winsize);
peak2=filter2;
for data 1:1:length(peak2)
    if peak2(data)<4
        peak2(data)=0;
    else
        peak2(data)=1;
    end
end

% determining the Heart Rate Beats per minute
beats=0;
for k=2: length(sig)-1
    if(sig(k)>sig(k-1) & sig(k)>sig(k+1)&sig(k)>1)
      peaks=k;
      beats=beats+1;
    end
end
fs=100;
N=length(sig1);
duration_in_sec=N/fs;
duration_in_min=duration_in_sec/60;
BPM=beats/duration_in_min;
% plotting the entire operation
figure(ECG);set(ecg,'name',strcat(plotname, '-stage'));
% plotting the original data
subplot(3,2,1);plot((sig1,min(sig1))/(max(sig1)-min(sig1)));
title('Original Raw ECG');
% After passing into the FFT the output is as follows
subplot(3,2,2);plot((correction,min(correction))/(max(correction)-min(correction)));
title('After FFT');
% after passing into threshold filter
subplot(3,2,3);stem((filter1,min(filter1))/(max(filter1)-min(filter1)));
title('After Thresholdfilter');
% after passing into the final second filter
subplot(3,2,4);stem((filter2,min(filter2))/(max(filter2)-min(filter2)));
title('detection of peaks');

