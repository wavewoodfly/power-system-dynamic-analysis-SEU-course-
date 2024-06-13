clc
clear
mpc=SEU2G5N;
[U theta Pi Qi]=ACpf(mpc);
theta=wrapToPi(theta)/pi*180;
time_domain