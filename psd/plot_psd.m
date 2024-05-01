function [] = plot_psd(signal, t, fs, func)
%
% FILENAME: {file name, not function name}
% plot_psd.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function plots a power spectrum density of 1 dimensional signal.
%
% INPUT: {What input arguments does this function take?}
% signal: signal
% t: time vector
% fs: sampling frequency
% func: function to use to plot PSD, 'pspectrum' or 'periodogram'
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

    % Load your signal data into a variable called x
    % Assume the sampling frequency is 2000 Hz
    %fs = 2000;
    
    % Compute the power spectrum using the periodogram function
    switch func
        case 'pspectrum'
            % Use pspectrum
            xTable = timetable(seconds(t'), signal');
            [Pxx,f] = pspectrum(xTable);
            
            % Plot the power spectrum in dB
            figure;
            plot(f,pow2db(Pxx));
            xlabel('Frequency (Hz)');
            ylabel('Power (dB)');
            title('Power Spectrum Density of Signal');
    
        case 'periodogram'
            % Use periodogram
            [Pxx,f] = periodogram(signal,[],[],fs);
            
            % Plot the power spectrum in dB
            figure;
            plot(f,pow2db(Pxx));
            xlabel('Frequency (Hz)');
            ylabel('Power/Frequency (dB/Hz)');
            title('Power Spectrum Density of Signal');

        otherwise
            warning('Unknown function type. No PSD plot created.')
    end

end
