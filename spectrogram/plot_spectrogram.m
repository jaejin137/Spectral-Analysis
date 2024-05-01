function [] = plot_spectrogram(signal, fs, length, overlap)
%
% FILENAME: {file name, not function name}
% plot_spectrogram.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function plots a spectrogram of 1 dimensional signal.
%
% INPUT: {What input arguments does this function take?}
% signal: signal
% fs: sampling frequency
% length: Hamming window length
% overlap: window overlap
% 
% OUTPUT: {What output does this function make?}
% n/a
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
    
    % Use a Hamming window of length 256 and 50% overlap
    window = hamming(length);
    %noverlap = 128;
    noverlap = overlap*length;
    
    % Compute the spectrogram using the short-time Fourier transform
    %[s,f,t] = spectrogram(signal, window, noverlap, [], fs);
    figure
    % Automatic plot
    %spectrogram(signal, window, noverlap, [], fs, 'yaxis');
    % Manual plot
    [~,F,T,P] = spectrogram(signal, window, noverlap, [],fs, 'yaxis');
    imagesc(T, F, 10*log10(P+eps)) % add eps like pspectrogram does
    axis xy
    ylabel('Frequency (Hz)')
    xlabel('Time (s)')
    h = colorbar;
    h.Label.String = 'Power/frequency (dB/Hz)';
    title('Spectrogram');
    
end


