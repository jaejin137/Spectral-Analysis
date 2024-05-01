function [lfp, t] = generate_fake_lfp(fs, T, M, N, freq, amp, phaseDiff, noise)
%
% FILENAME: {file name, not function name}
% generate_fake_lfp.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function generates a fake multichannel, multi-trial lfp signal.
%
% INPUT: {What input arguments does this function take?}
% fs: sampling frequency
% T: total time in seconds
% fs: sampling frequency in Hz
% T: duration of each trial in seconds
% M: number of channels
% N: number of trials
% freq: frequencies of carrier signal and modulation
% amp: amplitudes of carrier signal and modulation
% noise: noise definition cell, {noiseType noiseLevel}
%   noiseType: 'pink' or 'gaussian' white noise
%   noiseLevel: any number
% snr: signal-to-noise ratio in dB
% 
% OUTPUT: {What output does this function make?}
% lfp: lfp signal array
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

    % Assign parameters
    f1 = freq(1);
    f2 = freq(2);
    fmod = freq(3);

    amp1 = amp(1);
    amp2 = amp(2);
    ampMod = amp(3); % modulation amplitude
    baseline = 0.5; % baseline of modulation

    phaseDiff1 = phaseDiff(1); % fixed phase difference between channels
    phaseDiff2 = phaseDiff(2); % fixed phase difference between channels

    noiseType = noise{1}; % noise type
    noiseLevel = noise{2}; % noise level
    %snr = 10; % fixed SNR

    
    % Time vector in seconds
    t = 0:1/fs:T-1/fs;
    
    % Preallocate array for M channel, N trial
    lfp = zeros(M,length(t),N);
    lfp_phase = zeros(M,length(t),N);
    
    % Loop over M channels and N trials
    for n = 1:N
        for m = 1:M
            % Sinusoidal signal with varying frequency and amplitude
            %x = sin(2*pi*f1*t) + sin(2*pi*f2*t); % carrier signal
            x1 = amp1*sin(2*pi*f1*t-(m-1)*phaseDiff1);
            %x1_phase = angle(hilbert(x1));
            x2 = amp2*sin(2*pi*f2*t-(m-1)*phaseDiff2);
            x = x1 + x2; % carrier signal
            a = baseline + ampMod*cos(2*pi*fmod*t); % amplitude modulation
            x = x.*a; % modulated signal
            lfp_phase(m,:,n) = angle(hilbert(x));
            
            % Add some random noise to the signal
            switch noiseType
                case 'pink'
                    noise = 50*noiseLevel*pinknoise(fs*T)'; % scale factor = 50
                case 'gaussian'
                    noise = noiseLevel*randn(fs*T,1)'; % white Gaussian noise
                otherwise
                    warning('Unknown noise type. No noise added')
                    noise = 0;
            end

            % noise = noise/std(noise)*std(x)/10^(snr/20); % scale noise to desired SNR
            x = x + noise; % noisy signal
            
            % Store the signal in the array
            lfp(m,:,n) = x;
        end
    end

    % Plot the first trial of each channel using subplot function
    figure;
    for m = 1:min(4,M)
        % Plot amplitude in time
        subplot(min(4,M),2,2*(m-1)+1);
        plot(t,squeeze(lfp(m,:,1)), 'r');
        xlabel('Time (s)');
        ylabel('Amplitude');
        title(sprintf('Amplitude of Channel %d Signal',m));

        % Plot phase in time
        subplot(min(4,M),2,2*m);
        plot(t,squeeze(lfp_phase(m,:,1)), 'g');
        ylim([-pi pi])
        xlabel('Time (s)');
        ylabel('Phase (radian)');
        title(sprintf('Phase of Channel %d Signal',m));
    end

end
