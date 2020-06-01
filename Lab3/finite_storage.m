function [arrivals, P, P_block, mean_cl_time, mean_wait_time]  = ...
  finite_storage (lambda, debugging, seed, variable_mu)
% M/M/1/10 simulation. We will find the probabilities of the first states.
% Note: Due to ergodicity, every state has a probability >0.
   
  if seed
    rand("seed", 1);
  endif
  % to measure the total number of arrivals
  total_arrivals = 0; 
    
  % holds the current state of the system
  current_state = 0; 
  
  % will help in the convergence test
  previous_mean_clients = 0; 
  index = 0;
  
  mu = 5;
  
  % the threshold used to calculate probabilities
  threshold = lambda/(lambda + mu); 
  
  % holds the transitions of the simulation in transitions steps
  transitions = 0; 
  
  while transitions >= 0
    % one more transitions step     
    transitions = transitions + 1;
    
    if variable_mu
      mu = 1 * (current_state + 1);  
      threshold = lambda/(lambda + mu); 
    endif
  
    if debugging
      disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
      printf('Iteration number: %d.\n', transitions);
      printf('Current state is %d.\n', current_state);
      printf('Total number of arrivals is %d.\n', total_arrivals);
      P = 0;
      to_plot = 0;
      P_block = 0;
    endif
    
    % check for convergence every 1000 transitions steps
    if mod(transitions,1000) == 0 
      index = index + 1;
      for i=1:1:length(arrivals)
          % calcuate the probability of every state in the system
          P(i) = arrivals(i)/total_arrivals; 
          
      endfor
          P_block = P(length(arrivals)) * lambda; 
          
      % calculate the mean number of clients in the system
      mean_clients = 0;
      for i=1:1:length(arrivals)
         mean_clients = mean_clients + (i-1).*P(i);
      endfor
      
      mean_wait_time(index) = mean_clients./(lambda*(1-P(length(arrivals))));
      mean_cl_time(index) = mean_clients;
      
      % convergence test 
      if abs(mean_clients - previous_mean_clients)...
        < 0.001 * previous_mean_clients || transitions > 1000000 
        break;
      endif
      
      previous_mean_clients = mean_clients;
      
    endif
    
    % generate a random number (Uniform distribution)
      random_number = rand(1, seed);
    
    % arrival
    if (current_state == 0 || random_number < threshold) && (current_state < 10)
      total_arrivals = total_arrivals + 1;
      
      if debugging
        printf('We have an arrival.\n')
      endif
      
      try 
        % to catch the exception if variable arrivals(i) is undefined. 
        % Required only for systems with finite capacity.
        % increase the number of arrivals in the current state
        if current_state == 10
          continue
        else
          arrivals(current_state + 1) = arrivals(current_state + 1) + 1; 
          current_state = current_state + 1;
        endif
      catch
        arrivals(current_state + 1) = 1;
        current_state = current_state + 1;
      end
    else 
     % departure
     if debugging
        printf('We have a departure.\n');
      endif
      
      if current_state != 0 % no departure from an empty system
        current_state = current_state - 1;
      endif
    endif
    
    if (debugging == true) && (transitions > 30)
      break
    endif
  endwhile
endfunction
