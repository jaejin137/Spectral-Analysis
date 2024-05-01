%% This script calculates phase locking values for a multichannel lfp data.
%%
%% Demonstrated functions:
%% generate_fake_lfp, calculate_plv

warning('off')

addpath(['..' filesep 'data'])

% Signal spec
fs = 2000;  % sampling rate
T = 2;  % signal length in time [seconds]
M = 8; % Number of channels
N = 10; % Number of trials
freq = [4 20 1]; % frequencies of carrier signals and modulation([f1,f2,fmod])
amp = [1 .5 .2]; % amplitude of carrier signals and modulation([amp1,amp2,ampMod])
phaseDiff = [pi/2 pi/2]; % fixed phase difference in signals between channels
noise = {'pink' .1}; % noise type and noise level ({noiseType,noiseLevel})

% Generate artifical LFP data
[lfp, t] = generate_fake_lfp(fs, T, M, N, freq, amp, phaseDiff, noise);

% Define the frequency band of interest for phase
phaseBand = [1 50]; % Hz


% Calculate PLV
[plv] = calculate_plv(lfp, t, fs, phaseBand);
