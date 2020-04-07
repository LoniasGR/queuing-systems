clc;
clear all;
close all;
pkg load statistics

%% Poisson Distribution

% Step A

# TASK: In a common diagram, design the Probability Mass Function of Poisson 
# processes with lambda parameters 3, 10, 50. In the horizontal axes, choose k 
# parameters between 0 and 70. 


k = 0:1:70;
lambda = [3, 10, 30, 50];

for i=1:columns(lambda)
  poisson(i,:) = poisspdf(k,lambda(i));
endfor

colors = 'rbkm';
figure(1);
hold on;

for i=1:columns(lambda)
  if (i == 3)
    continue
  endif
  stem(k, poisson(i,:), colors(i), 'linewidth', 1.2);
endfor

hold off;

title('Probability density function of Poisson processes');
xlabel('x values');
ylabel('probability');
legend('\lambda = 3','\lambda = 10', '\lambda = 50');

% Step B

# TASK: regarding the poisson process with parameter lambda 30, compute its mean 
# value and variance

index = find(lambda == 30);
chosen = [poisson(index,:)];

mean_value = 0;

for i=0:(columns(poisson(index,:))-1)
  mean_value = mean_value + i.*poisson(index,i+1);
endfor

disp('mean value of Poisson with lambda 30 is');
disp(mean_value);

second_moment = 0;
for i=0:(columns(poisson(index,:))-1)
  second_moment = second_moment + i.*i.*poisson(index,i+1);
endfor

variance = second_moment - mean_value.^2;

display("Variance of Poisson with lambda 30 is");
display(variance);

% Step C

# TASK: consider the convolution of the Poisson distribution with lambda 10 with 
# the Poisson distribution with lambda 50. 

first = find(lambda==10);
second = find(lambda==50);
poisson_first = poisson(first, :);
poisson_second = poisson(second, :);

composed = conv(poisson_first,poisson_second);
new_k = 0:1:(2*70);

figure(2);
hold on;

stem(k,poisson_first(:),colors(1),'linewidth',1.2);
stem(k,poisson_second(:),colors(2),'linewidth',1.2);
stem(new_k,composed,'mo','linewidth',2);

hold off;

title('Convolution of two Poisson processes');
xlabel('k values');
ylabel('Probability');
legend('\lambda=10','\lambda=50','new process');

% Step D

# TASK: show that Poisson process is the limit of the binomial distribution.

k = 0:1:70;

lambda = 30;
n =[30, 60, 90, 120]; 
p = lambda./n;

figure(3);

hold on;
for i=1:4
  binomial = binopdf(k,n(i),p(i));
  stem(k,binomial,colors(i),'linewidth',1.2);
endfor

title('Poisson process as the limit of the binomial process');
xlabel('k values');
ylabel('Probability');
legend('n=30','n=60','n=90','n=120');

hold off;

%% Exponantial Distribution

% Step A

k = 0:0.00001:8;
lambda_frac = [0.5, 1, 3];

for i = 1:columns(lambda_frac)
  exponential(i,:) = exppdf(k, lambda_frac(i));
endfor

colors = 'rbkm';
figure(4);
hold on;

for i=1:columns(lambda_frac)
  plot(k, exponential(i,:), colors(i), 'linewidth', 1.2);
end

hold off;

title('probability density function of Exponential processes');
xlabel('k values');
ylabel('probability');
legend('1/\lambda = 0.5','1/\lambda = 1','1/\lambda = 3');

% Step B

for i=1:columns(lambda_frac)
      exp_cdf(i,:) = expcdf(k, lambda_frac(i));
endfor

figure(5);
hold on;

for i=1:columns(lambda_frac)
  plot(k, exp_cdf(i,:), colors(i), 'linewidth', 1.2);
endfor

hold off;

title('cumulative density function of Exponential processes');
xlabel('k values');
ylabel('probability');
legend('1/\lambda = 0.5','1/\lambda = 1','1/\lambda = 3');

% Step C

lambda_frac_2 = 2.5;


for i = 1:columns(lambda_frac_2);
  exponential_cdf_2(i,:) = expcdf(k, lambda_frac_2);
endfor

disp('The value of P(x > 30000) is');
disp(1 - exponential_cdf_2(1,30000));

disp('The value of P(x > 50000 | x > 20000) is');
disp((1-exponential_cdf_2(1,50000))/(1-exponential_cdf_2(1,20000)));

%% Poisson counting process

% Part A

lambda = 5;
samples = 100;

N_t = exprnd(1/lambda, 1, samples);

% Each element of the new matrix is the time we waited from the moment we 
% started counting until the i-th event happened.
for i = 2:length(N_t)
    N_t(1,i) = N_t(1,i) + N_t(1,i-1);
endfor

figure(6);
stairs(N_t);
xlabel('Events');
ylabel('Time (s)');

% Part B

% We calculate the number of events happening for every second of the process
% and then we average them out.

sample_b = [100, 200, 300, 500, 1000, 10000];
N_t_2 = cell(6,1);
time_frame = 1.0;

for j = 1:columns(sample_b)
  N_t_2{j,1} = exprnd(1/lambda, 1, sample_b(j));

  % Each element of the new matrix is the time we waited from the moment we 
  % started counting until the i-th event happened.
  for i = 2:length(N_t_2{j,1})
      N_t_2{j,1}(i) = N_t_2{j,1}(i) + N_t_2{j,1}(i-1);
  endfor
endfor


for j = 1:columns(sample_b)
  
  events_per_sec = [1];
  time_frame = 1.0;

  for i = 1:length(N_t_2{j,1})
      if N_t_2{j,1}(i) <= time_frame
          events_per_sec(uint8(time_frame)) = ...
              events_per_sec(uint8(time_frame)) + 1;
      else
          time_frame = time_frame + 1.0;
          events_per_sec = [events_per_sec 1];
      end
  end
  
  disp('Number of samples');
  disp(sample_b(j));
  disp('Average number of events per sec');
  disp(mean(events_per_sec));
endfor