clc;
clear;
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

[~, columns] = size(lambda_frac);
exponential = cell(columns,1);
for i = 1:columns
  exponential{i,1} = exppdf(k, lambda_frac(i));
end

colors = 'rbkm';
figure(4);
hold on;

for i=1:columns
  plot(k, exponential{i,1}, colors(i), 'linewidth', 1.2);
end

hold off;

title('probability density function of Exponential processes');
xlabel('k values');
ylabel('probability');
legend('1/\lambda = 0.5','1/\lambda = 1','1/\lambda = 3');

% Step B

exp_cdf = cell(columns, 1);
for i=1:columns
      exp_cdf{i,1} = expcdf(k, lambda_frac(i));

end

figure(5);
hold on;

for i=1:columns
  plot(k, exp_cdf{i,1}, colors(i), 'linewidth', 1.2);
end

hold off;

title('cumulative density function of Exponential processes');
xlabel('k values');
ylabel('probability');
legend('1/\lambda = 0.5','1/\lambda = 1','1/\lambda = 3');

% Step C

lambda_frac_2 = 2.5;

[~, columns] = size(lambda_frac_2);
exponential_cdf_2 = cell(columns,1);

for i = 1:columns
  exponential_cdf_2{i,1} = expcdf(k, lambda_frac(i));
end

disp('The value of P(x > 30000) is');
disp(1 - exponential_cdf_2{1,1}(30000));

disp('The value of P(x > 50000 | x > 20000) is');
disp((1-exponential_cdf_2{1,1}(50000))/(1-exponential_cdf_2{1,1}(20000)));

% Step D

mu1 = 2;
mu2 = 1;
samples = 5000;

X1 = exprnd(mu1, 1, samples);
X2 = exprnd(mu2, 1, samples);

Y = min(X1, X2);

disp('The mean of Y is');
disp(mean(Y));

maximum_observation = max(Y);
number_of_classes = 50;
width_of_class = maximum_observation / number_of_classes;

[NN, XX] = hist(Y, number_of_classes);

NN_without_free_variables = NN/width_of_class/samples;

figure(6);
hold on;
bar(XX, NN_without_free_variables);
plot(XX, NN_without_free_variables, 'r', 'linewidth', 1.3);

xlabel('classes');
ylabel('frequency');
hold off;

%% Poisson Distribution

% Part A
lambda = 5;
samples = 100;

N_t = exprnd(1/lambda, 1, samples);

% Each element of the new matrix is the time we waited from the moment we 
% started counting until the i-th event happened.
for i = 2:length(N_t)
    N_t(1,i) = N_t(1,i) + N_t(1,i-1);
end

figure(7);
stairs(N_t);
xlabel('Events');
ylabel('Time (s)');

% Part B

time_frame = 1.0;
events_per_sec = 0;
for i = 1:length(N_t)
    if N_t(1,i) <= time_frame
        events_per_sec(uint8(time_frame)) = ...
            events_per_sec(uint8(time_frame)) + 1;
    else
        time_frame = time_frame + 1.0;
        events_per_sec(uint8(time_frame)) = 1;
    end
end

disp('Average number of events per sec');
disp(mean(events_per_sec));

% Part C

time_49 = 0;
time_50 = 0;
for i = 1:1:100
    N_t = exprnd(1/lambda, 1, samples);
    time_49 = time_49 + N_t(1, 50);
    time_50 = time_50 + N_t(1, 51);
end

disp('Average time between 49th and 50th event');
disp(time_49/100);

disp('Average time between 50th and 51st event');
disp(time_50/100);



