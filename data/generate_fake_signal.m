function [x, t] = generate_fake_signal(fs, T, freq, amp, mod, noise)
%
% FILENAME: {file name, not function name}
% generate_fake_signal.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox, Audio Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function generates a fake 1-dimensional signal with pink noise
% or white gaussian noise.
%
% INPUT: {What input arguments does this function take?}
% fs: sampling frequency
% T: total time in seconds
% freq: frequency vector, [f1,f2,fCoup]
% amp: amplitudes vector, [amp1,amp2]
% mod: modulation vector, [frequency,amplitude,jitter amplitude]
% noise: noise definition cell, {noiseType noiseLevel}
%   noiseType: 'pink' or 'gaussian' white noise
%   noiseLevel: any number
% 
% OUTPUT: {What output does this function make?}
% x: signal vector
% t: time vector
%
% AUTHOR: {Who wrote this code?}
% Jaejin Lee
%
% CONTACT: {preferred contact information}
% jaejin@umn.edu
%
% VERSION: {What is the curent version? Convention: major.minor.bugfixes}
% 0.1.1
%
% CREATED: {When was this code first created?}
% June, 2023
%
% UPDATED: {When was this code last updated?}
% June, 2023
%
% TAG: {What keywords can this be found with?}
% SPECTRAL
%
% REMARKS: {Any remarks to be noted to use this file}
% n/a.
%

    % Assign parameters
    t = (0:1/fs:T-1/fs);
    f1 = freq(1); % frequency of carrier signal 1
    f2 = freq(2); % frequency of carrier signal 2
    fCoup = freq(3); % frequecy of phase coupled signal 
    amp1 = amp(1); % amplitude of carrier signal 1
    amp2 = amp(2); % amplitude of carrier signal 2
    ampCoup = amp(3); % amplitude of phase coupled signal
    modFreq = mod(1); % modulation frequency
    modAmp = mod(2); % slow modulation amplitude
    jitAmp = mod(3); % jitter in slow modulation
    noiseType = noise{1};
    noiseLevel = noise{2};

    % Generate a time vector
    % x = amp1*sin(2*pi*f1*t) + amp2*sin(2*pi*f2*t) ...
    %     + modAmp*(sin(2*pi*modFreq*t)+jitAmp*randn(size(t)));
    x1 = amp1*sin(2*pi*f1*t);
    x1_phase = angle(hilbert(x1));
    x2 = amp2*sin(2*pi*f2*t);
    x2_phase = angle(hilbert(x2));
    xCoup = ampCoup*x1_phase.*sin(2*pi*fCoup*t)/pi;
    xCoup_phase = angle(hilbert(xCoup));
    xmod = modAmp*(sin(2*pi*modFreq*t)+jitAmp*randn(size(t)));

    x = x1 + x2 + xCoup + xmod;

    figure;
    % Add some noise to the signal using the pinknoise function
    subplot(2,2,2)
    switch noiseType
        case 'pink'
            noise = 20*noiseLevel*pinknoise(fs*T)'; % scale factor = 20
            [~,freqVec,~,psd] = spectrogram(noise,round(0.05*fs),[],[],fs);
            meanPSD = mean(psd,2);
            semilogx(freqVec,db(meanPSD,"power"))
            title("PSD of Pink Noise")
            xlabel('Frequency (Hz)')
            ylabel('PSD (dB/Hz)')
        case 'gaussian'
            noise = .5*noiseLevel*randn(fs*T,1)'; % scale factor = .5
            pspectrum(noise)
            title("PSD of Gaussian White Noise")
        otherwise
            warning('Unknown noise type. No noise added')
            noise = 0;
    end
    x = x + noise;

    % Get phase of the total signal
    %x_phase = angle(hilbert(x));
    
    % Plot the amplitude of signal in time domain
    subplot(2,2,1)
    plot(t, x, 'r')
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Artificial Signal');

    % Plot the phase of signal in time domain
    subplot(2,2,3)
    plot(t, x1_phase, 'g')
    ylim([-pi pi])
    xlabel('Time (s)');
    ylabel('Phase (radian)');
    title('Phase of Carrier Signal1');

    subplot(2,2,4)
    plot(t, x2_phase, 'g')
    ylim([-pi pi])
    xlabel('Time (s)');
    ylabel('Phase (radian)');
    title('Phase of Carrier Signal2');

end
