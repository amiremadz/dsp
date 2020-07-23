%% Lab 3 - Your Name - MAT 275 Lab
% Introduction to Numerical Methods for Solving ODEs

%% Exercise 1

% Read the instructions in your lab pdf file carefully!

% Part (a)

% NOTE: We often define the right-hand side of an ODE as some function, say f,
% in terms of the input and output variables in the ODE. For example,
% dy/dt = f(t,y) = 3.25y. Although the ODE does not explicitly depend on t, it does
% so implicitly, since y is a function of t. Therefore, t is an input variable of f. 

% Define ODE function f for your version of the lab.

% Define vector t of time-values over the interval in your version of the lab,
% to compute analytical solution vector.

% Create vector of analytical solution values at corresponding t values.

% NOTE: In your version of the lab you were given table in problem1(a), which
% you need to fill out. This table has four different values of N - call them
% Nsmall, Nmed, Nlarge and Nhuge (where, of course, Nsmall < Nmed < Nlarge < Nhuge).
% For the following steps, please use notation consistent with the protocol
% and appropriate for your version of the lab. 
% For example, if in your version Nsmall=5 timesteps, then use the variable name t5
% to represent the vector of t-points in the solution with number of steps N=5.
% Also, if in your version Nlarge=500 timesteps, use variable name y500 
% to represent the numerical solution vector produced from Euler's method, and use
% the name e500 to denote the corresponding error.
% In the following comments, I refer to "Euler's method" as "forward Euler's method," which
% is more precise since there is also a backward Euler's method. I use
% "IVP" as an abbreviation for Initial Value Problem, which for our purposes here
% means an ODE with associated initial condition.

% Solve IVP numerically using forward Euler's method with Nsmall timesteps (use variable names as instructed).

% Solve IVP numerically using forward Euler's method with Nmed timesteps (use variable names as instructed).

% Solve IVP numerically using forward Euler's method with Nlarge timesteps (use variable names as instructed).

% Solve IVP numerically using forward Euler's method with Nhuge timesteps (use variable names as instructed).

% In the following steps, we define error as exact - numerical solution value at the last time step


% Compute numerical solution error at the last time step for forward Euler with Nsmall timesteps (use variable names as instructed).

% Compute numerical solution error at the last time step for forward Euler with Nmed timesteps (use variable names as instructed).

% Compute numerical solution error at the last time step for forward Euler with Nlarge timesteps (use variable names as instructed).

% Compute numerical solution error at the last time step for forward Euler with Nhuge timesteps (use variable names as instructed).

% Compute ratio of errors between N=Nsmall and N=Nmed. 

% Compute ratio of errors between N=Nmed and N=Nlarge.

% Compute ratio of errors between N=Nlarge and N=Nhuge. 

% NOTE: To complete the following table, simply run this section after
% you've finished the steps above and copy and paste your errors and ratios
% into the follwing display commands. Make sure you re-align each column
% after entering in values so that it looks pretty. 

% FILL OUT THE TABLE BELOW 
% Display the table of errors and ratios of consecutive errors for the 
% numerical solution at t=tfinal (the last element in the solution vector). 
% REPLACE words "Nsmall", "Nmed", "Nlarge" and "Nhuge" by the 
% appropriate numbers of steps you were given in your version of the lab.
% Also, note that in your version of the lab you already have some values
% entered in the table, to help you check your code is correct.
% You need to fill out all the cells in the table!

disp('----------------------------------------------')
disp('| N    |  approximation  |  error   | ratio  |')
disp('|------|-----------------|----------|--------|')
disp('| Nsmall   |             |          |  N/A   |')
disp('| Nmed   |              |          |         |')
disp('| Nlarge  |             |          |         |')
disp('| Nhuge |              |          |         |')
disp('----------------------------------------------')

%%
% Part (b). Your answer here. Notice that by not adding a title to this 
% section and skipping to the next line to start our comment, this comment 
% will display in black (not green) when we publish it. 

%%
% Here, we can add another paragraph to our essay answer for part (b) by 
% once again partitioning off a new section with no title and beginning our
% comment on the second line of the section.

%%
% Part (c). Your answer here. 

%% Exercise 2

% Read the instructions in your lab pdf file carefully!

% Part (a)

% Plot slopefield for the new ODE  using the given commands. 

%%
% Part (b)

% Define vector t of time-values over the  given interval  to define 
% analytical solution vector.

% Create vector of analytical solution values at corresponding t values.

% NOTE: The "hold on" command in the segment of code to plot the slope
% field indicates to MATLAB to add future plots to the same window unless
% otherwise specified using the "hold off" command.

% Plot analytical solution vector with slopefield from (a). 

%%
% Part (c)

% NOTE: Recall we can define the right-hand side of an ODE as some function 
% f. In the case of a one-dimensional autonomous ODE, we may define f such
% that dy/dt = f(t,y).

% Define ODE function.

% Compute numerical solution to IVP with N timesteps using forward Euler.

% Plot numerical solution with analytical solution from (b) and slopefield
% from (a) using circles to distinguish between the approximated data
% (i.e., the numerical solution values) and actual (analytical) solution.

hold off;  % end plotting in this figure window

%%
% Your response to the essay question for part (c) goes here. Please do not
% answer the question with "the numerical solution is inaccurate because 
% the stepsize is too big" or "because there are not enough points in the 
% numerical solution." What is it about this particular solution that makes 
% forward Euler so inaccurate for this stepsize? Think about it.

%%
% Part (d)

% Define new grid of t and y values at which to plot vectors for slope field.

% Plot slope field  corresponding to the new grid.

% Define vector t of time-values over the given interval to define analytical soution vector.

% Create vector of analytical solution values at corresponding t values.


% Define ODE function.

% Compute numerical solution to IVP with the given timesteps using forward Euler. 

% plot numerical solution together with slope field and analytical solution

%%
% Your essay answer goes here.

%% Exercise 3

% Read the instructions in your lab pdf file carefully!

% Display contents of impeuler M-file.
type 'impeuler.m'

% NOTE: Make sure you document your code in impeuler.m appropriately for full credit.

% Define ODE function. 

% Compute numerical solution to IVP with Nsmall timesteps using "improved Euler."

%%
% How does your output compare to that in the protocol?

%% Exercise 4

% Read the instructions in your lab pdf file carefully!

% NOTE: Here, we repeat all the steps from parts (a) and (b) in exercise 1, but we use
% "improved Euler" instead of forward Euler (or regular Euler). Make sure
% to document your code appropriately.

% Part (a)


% Part (b)


%% Exercise 5

% Read the instructions in your lab pdf file carefully!

% NOTE: Here, we repeat all the steps from exercise 2, except using
% improved Euler rather than forward Euler. Remember code doc. 


%% 
% Congratulations, you're done!