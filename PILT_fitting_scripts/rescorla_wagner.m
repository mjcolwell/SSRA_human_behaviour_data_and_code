function [r]=rescorla_wagner(Y,alpha,start)
%[r]=rescorla_wagner(Y,alpha,start)
%[r]=rescorla_wagner(Y,alpha)  (start is assumed to be 0.5
% Output is probability estimate

if(nargin<3) start=0.5;end
r=zeros(size(Y));
r(1)=start;
for i=2:size(r);
  r(i)=r(i-1)+alpha*(Y(i-1)-r(i-1));
end