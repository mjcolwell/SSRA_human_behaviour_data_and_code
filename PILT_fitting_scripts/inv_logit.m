function [ out ] = inv_logit( innum, direction )
%inv_logit retuns the logit (inverse logistic) of input. If direction = 1 then perform
%inv logit

if nargin < 2
    direction=0;
end

if direction==0 
    if innum < 0 | innum > 1
        error('inverse logit only defined for numbers between 0 and 1');
    end
    out=-log((1./innum)-1);
elseif direction ==1
    out=1./(1+exp(-innum));
    
else
    error('direction must be 0 or 1')
end


end

