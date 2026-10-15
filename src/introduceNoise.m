function pn = introduceNoise(p,N,SNR)
%INTRODUCENOISE N noisy copies of each row of p.
%   Adds white Gaussian noise of power SNR (in dBW) to every parameter.
pn = [];
for i=1:N
    noise = sqrt(10^(SNR/10))*randn(size(p,1),size(p,2));
    pn = [pn; p + noise]; %#ok<AGROW>
end
