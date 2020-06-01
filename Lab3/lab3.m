clc;
clear all;
close all;

[arrivals, P, P_block, to_plot, mean_wait_time] = ...
  finite_storage(5, false, true, true);

for i=1:1:length(arrivals)
  display(P(i));
endfor

figure(1);
plot(to_plot,"r","linewidth",1.3);
title("Average number of clients in the M/M/10 queue: Convergence");
xlabel("transitions in thousands");
ylabel("Average number of clients");

figure(2);
bar(P,'r',0.4);
title("Probabilities")

figure(3);
plot(mean_wait_time,"r","linewidth",1.3);
title("Average waiting time of clients in the M/M/10 queue: Convergence");
xlabel("transitions in thousands");
ylabel("Average wait time of clients");


disp('Sum of all probabilities is:')
disp(sum(P))