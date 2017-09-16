function reset_all(quickLearn)

global m_lambda
global qhat
global bhat 
global b_rhs
global q_rhs


qhat = [1,0,0,0]';
bhat = [0,0,0]';
b_rhs = [0,0,0]';
q_rhs = [0,0,0,0];


if(quickLearn)
   m_lambda = 0;
else
    m_lambda = 1;    
end



end