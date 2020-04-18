pkg load queueing;
pkg load statistics;


clc;
clear all;
close all;

% M/M/1 queue analysis

samples = 51;

lambda = 5 * ones(1, samples-1);
mu = linspace(5,10, samples);
mu = mu(2:end);

[U, R, Q, X, ~] = qsmm1(lambda, mu);

% Utilization to serving rate plot

figure(1);
plot(mu, U);
ylabel('\rho', 'Rotation', 0);
xlabel('\mu');
grid on;
title('Server utilization - serving rate plot with \lambda = 5');

% Average delay to serving rate plot
% E(T) = \frac{1}{mu - lambda}

figure(2);
plot(mu, R);
ylabel('E(T)', 'Rotation', 50);
xlabel('\mu');
grid on;
title('Average delay - serving rate plot with \lambda = 5');

% Average number of requests to server serving rate plot

figure(3);
plot(mu, Q);
ylabel('n(t)', 'Rotation', 45);
xlabel('\mu');
grid on;
title('Average number of requests - serving rate plot with \lambda = 5');

% Throughput to server serving rate plot

figure(4);
plot(mu, X);
ylabel('Thrpt', 'Rotation', 60);
xlabel('\mu');
grid on;
title('Throughput - serving rate plot with \lambda = 5');

%% Comparing systems with two servers

% M/M/2
lambda = 10;
mu = 10;

[~, R, ~, ~, ~] = qsmmm(lambda, mu, 2);

disp(['The average delay for M/M/2 with mu = 10 is ', num2str(R)]);

% 2 M/M/1

lambdas = [5, 5];
mus = [10, 10];

[~, R, ~, ~, ~] = qsmm1(lambdas, mus);


disp(['The average delay for 2x M/M/1 with mu = 10 is ', num2str(mean(R))]);

%% system M/M/1/4
lambda = 5;
mu = 10;
states = [0,1,2,3,4]; % system with capacity 4 states
initial_state = [1,0,0,0,0];

% births and deaths
births_B = ones(1,4);
for i = 1:length(births_B)
  births_B(i) = lambda/i;
endfor

deaths_D = mu *  ones(1,4);

% step i.
% get the transition matrix of the birth-death process
transition_matrix = ctmcbd(births_B,deaths_D);

disp('The trainsition matrix is:');
disp(transition_matrix);

% step ii.
% get the ergodic probabilities of the system
P = ctmc(transition_matrix);

disp('The ergodic probabilities are:');
disp(P);

% plot the ergodic probabilities (bar for bar chart)
figure(5);
bar(states,P,"r",0.5);

% step iii
% average number of customers in the system
avg_customers = sum(states.*P);

disp('The average number of customers is:');
disp(avg_customers);

% step v
% Transient probabilities for all states
for i = 1:length(states)
  Prob = 0;
  index = 0;
  TMax = 50
  for T=0:0.01:50
    index = index + 1;
    Pi = ctmc(transition_matrix,T,initial_state);
    Prob(index) = Pi(i);
    if (abs(Pi(i) - P(i)) < 0.01 * P(i))
      break;
    endif
  endfor

  T = 0:0.01:T;
  figure(5+i);
  plot(T,Prob,"r","linewidth",1.3);
  title(["Transient response for state ", num2str(i-1)])
  xlabel("Time");
  ylabel("Probability");
endfor

% step vi

% Transient probabilities for all states
j = 0;
for mu = [1, 5, 20]
  j= j+1;
  deaths_D = mu *  ones(1,4);
  transition_matrix = ctmcbd(births_B,deaths_D);
  P = ctmc(transition_matrix);
  hf = figure(10+j);
  
  for i = 1:length(states)
    Prob = [];
    index = 0;
    for T=0:0.01:100
      index = index + 1;
      Pi = ctmc(transition_matrix,T,initial_state);
      Prob(index) = Pi(i);
      if (abs(Pi(i) - P(i)) < 0.01 * P(i))
        break;
      endif
    endfor

    T = 0:0.01:T;
    subplot(3,2,i);
    plot(T,Prob,"r","linewidth",1.3);
    title(["Transient response for state ", num2str(i-1)])
    xlabel("Time");
    ylabel("Probability");
  endfor
endfor