### Create_Noisy_Auditory
Adds pink noise in specified SNRs to audio file and normalizes volume

Desired SNRs can be specified in dB. Script creates pink noise, adds it to audio file, evaluates SNR by calculating power of the noise and the signal and increases or deacreases sound pressure of noise if necessary/until desired SNR is reached. Normalizes to the max of the noisy audio track.
