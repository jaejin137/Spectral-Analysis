function [wcoh, wtxy] = calculate_wavelet_coherence(x, y, fs, wavname, plotType)
%
% FILENAME: {file name, not function name}
% calculate_wavelet_coherence.m
%
% FUNCTIONS: {all functions defined in this file}
% self.
%
% DEPENDENCIES: {all dependencies including third party toolbox}
% Signal Processing Toolbox
% 
% DESCRIPTION: {What does this do?}
% This function calculate coherence between two signals using wavelet
% analysis.
%
% INPUT: {What input arguments does this function take?}
% x and y: two signals
% fs: sampling frequency
% wavname: wavelet name, "morse", "amor", or "bump" 
% plotType: type of result plot, 1: basic, 2: with phase arrow
% 
% OUTPUT: {What output does this function make?}
% wcoh: magnitude-squared wavelet coherence
% wtxy: cross-wavelet transform of signal x and y
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
% Reference papers:
% Continuous Wavelet Transform:
% Lilly, Jonathan M. "Element Analysis: A Wavelet-Based Method for Analysing
% Time-Localized Events in Noisy Time Series." Proceedings of the Royal Society A:
% Mathematical, Physical and Engineering Sciences 473, no. 2200 (April 30, 2017):
% 20160776. https://doi.org/10.1098/rspa.2016.0776.
% Wavelet Coherence:
% Maraun, D., J. Kurths, and M. Holschneider. "Nonstationary Gaussian processes
% in wavelet domain: Synthesis, estimation and significance testing." Physical
% Review E 75. 2007, pp. 016707-1–016707-14
%
    
    % Wavelet transform of each signal
    [wtx,~] = cwt(x,wavname,fs,'TimeBandwidth',60,'VoicesPerOctave',32);
    [wty,~] = cwt(y,wavname,fs,'TimeBandwidth',60,'VoicesPerOctave',32);
    
    % Cross-wavelet transform of signal x and y
    wtxy = wtx.*conj(wty);

    % Plot the results using pcolor function
    figure
    %pcolor((1:length(x))/fs,f,abs(wtxy));
    pcolor(abs(wtxy));
    shading interp;
    set(gca,'yscale','log');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Cross-Wavelet Transform');
    colorbar;
    % 

    % Calculate wavelet coherence and plot the result
    switch plotType
        case 1
            % Wavelet coherence of signal x and y
            [wcoh,~,f,coi] = wcoherence(x,y,fs);
            % Plot the coherence and cone of influence
            figure
            pcolor((1:length(x))/fs,f,wcoh);
            shading interp;
            set(gca,'yscale','log');
            xlabel('Time (s)');
            ylabel('Frequency (Hz)');
            title('Wavelet Coherence');
            hold on;
            plot((1:length(x))/fs,coi,'k','linewidth',2); % plot cone of influence
            hold off;
            colorbar;

        case 2
            % Plot the coherence, phase arrows and cone of influence
            wcoherence(x,y,fs)
    end

    
end

