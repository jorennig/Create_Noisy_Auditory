clc
clear all
close all

% Get movie names
audio_files = dir('*.wav');
audio_files = {audio_files(:).name}';

noise_level = [-2,-4,-8,-12,-16,-20,-24,-28,-32]; % desired SNRs in dB
noise_start = 0.5;

% Normalize and add noise
for i = 1:numel(audio_files)

    % Read audio data
    [aud,fs] = audioread(audio_files{i});
    
    [pks,locs] = findpeaks(aud(:,1));
    aud_s = aud(locs(1):locs(end),:);
    
    % Create pink noise
    p_noise = pinknoise(length(aud_s))';
    p_noise = p_noise/max(abs(p_noise)); % normalize noise
    
    for j = 1:numel(noise_level)
        
        aud_n = aud;
            
        noise_c = noise_start;
        SNR_db = 0;
        while round(SNR_db) ~= noise_level(j)
            
            p_noise_n = p_noise*noise_c;

            % Get signal to noise ratio
            power_signal = 1/length(aud_n(:,1)) * sum(aud_n(:,1).^2); % power of original signal        
            power_noise = 1/length(p_noise_n) * sum(p_noise_n.^2); % power of noise signal

            %power_signal_tot(j) = power_signal;
            %power_noise_tot(j) = power_noise;

            SNR_db = 10*log(power_signal/power_noise);
            
            if round(SNR_db) > noise_level(j)
                noise_c = noise_c + 0.01;
            elseif round(SNR_db) < noise_level(j)
                noise_c = noise_c - 0.01;
            end
            
            %SNR_db2(j) = 10*log(power_signal)/10*log(power_noise);
            %SNR(j) = power_signal/power_noise;

        end
        
        SNR_db_tot(j) = SNR_db;

        aud_n(:,1) = aud_n(:,1) + p_noise_n;
        aud_n(:,2) = aud_n(:,2) + p_noise_n;
        
        % Normalize audio with added noise
        aud_n(:,1) = aud_n(:,1)/max(abs(aud_n(:,1)));
        aud_n(:,2) = aud_n(:,1)/max(abs(aud_n(:,2)));
        %aud_n = aud_n*0.9;
        
        audiowrite([audio_files{i}(1:end-4) '_' num2str(round(SNR_db)) '_dB.wav'],aud_n,fs);
        
    end
    
end
