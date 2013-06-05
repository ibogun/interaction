function [ res ] = findMostCorrelated( d )
%FINDMOSTCORRELATED Find the most correlated trajectory with object
%   From the trajectories of the left and right hand (l,r respectively)
%   find the one which is the most correlated with the trajectory of the
%   object, o.
%
%   Input:
%
%   d               -           object of type 'dataEntry'
%
%   Output:
%
%   res             -           trejectory, either l or r, which is the 
%       most correlated with o
%
%   author: Ivan Bogun


% object
o=d.trajectoryObject;
o=o.singlePointArray;

% left hand
l=d.trajectoryLefthand;
l=l.singlePointArray;

% right hand
r=d.trajectoryRighthand;
r=r.singlePointArray;


[~,p1]=corr(o(:),l(:));
[~,p2]=corr(o(:),r(:));

if (p2<p1)
    res=r;
else
    res=l;
end

% [n,m]=size(res);
% 
% % subtract the mean
% 
% m=mean(res);
% for i=1:n
%     res(i,:)=res(i,:)-m;
% end

end

