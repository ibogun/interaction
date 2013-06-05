function [ first, last ] = localizeInteraction( d,dt,toPlot,distSigma,nCellsSigma )
%LOCALIZEINTERACTION Localize interaction
%   Assume that interaction is the continuous time when the distance from
%   the object to the hand performing interaction remains constant for some
%   period of time. Numerically we calculate it as a longest subsequence
%   when such condition holds
%
%
%   Input:
%       
%       d               -       object of the class 'dataEntry'
%       dt              -       threshold which defines 'how close the
%           trajectories should be'
%       toPlot          -       1 if the plot is necessary, 0 otherwise
%       distSigma       -       gaussian smoothing term hand to object
%           distances
%       nCellsSigma     -       gaussian smoothing for hand, object
%           trajectories
%
%   Output:
%
%       first           -       frame where the interaction started
%       last            -       frame where the interaction ended
%
%   author: Ivan Bogun


if nargin<4
    %  default parameters
    distSigma=7;
    nCellsSigma=7;
    
    if nargin<3
        toPlot=0;
    end
    if nargin<2
        dt=5;
    end
    
end



% get the right hand
hand=findMostCorrelated(d);

% get the object
o=d.trajectoryObject.singlePointArray;

x=hand(:,1);
y=hand(:,2);

o_x=o(:,1);
o_y=o(:,2);

t=1:length(x);

dx=diff(x);
dy=diff(y);

o_dx=diff(o_x);
o_dy=diff(o_y);


% convolution shift
nShift=floor(nCellsSigma/2);

% smoothing
gaussFilter = gausswin(nCellsSigma);
gaussFilter = gaussFilter / sum(gaussFilter); % Normalize.

% Do the blur.
dx = conv(dx, gaussFilter);
dy = conv(dy, gaussFilter);

dx=dx(nShift+1:end-nShift);
dy=dy(nShift+1:end-nShift);

x=conv(x,gaussFilter);
y=conv(y,gaussFilter);
x=x(nShift+1:end-nShift);
y=y(nShift+1:end-nShift);

o_x=conv(o_x,gaussFilter);
o_y=conv(o_y,gaussFilter);

o_dx=conv(o_dx,gaussFilter);
o_dy=conv(o_dy,gaussFilter);

o_x=o_x(nShift+1:end-nShift);
o_y=o_y(nShift+1:end-nShift);

o_dx=o_dx(nShift+1:end-nShift);
o_dy=o_dy(nShift+1:end-nShift);


% ploting
if (toPlot==1)
    subplot(2,1,1);
    plot(x);
    hold on;
    plot(y);
    hold on;
    plot(o_x,'r');
    plot(o_y,'r');
    ylabel('coordinates','FontSize',14);
    
    
    subplot(2,1,2);
    plot(t(2:end),dx);
    hold on;
    plot(t(2:end),dy);
    hold on;
    plot(t(2:end),o_dx,'r');
    plot(t(2:end),o_dy,'r');
    
    ylabel('coordinates','FontSize',14);
    
end


n=length(o_dx);
handObjectDistances=zeros(n,1);
hand_d=[x,y];
o_d=[o_x,o_y];

for i=1:n
    handObjectDistances(i)=norm(o_d(i,:)-hand_d(i,:));
end

% calculate distance vector and its velocities
handObjectDistancesVelocity=diff(handObjectDistances);
handObjectDistancesVelocity=conv(handObjectDistancesVelocity,gausswin(distSigma));

% helper variables to find the longest subsequence satisfying:
% abs(handObjectDistancesVelocity(i))<dt

first=0;
last=0;

% boolean var
isFirst=1;

currentFirst=0;
currentLast=0;


for i=1:length(handObjectDistancesVelocity)
    if (abs(handObjectDistancesVelocity(i))<dt)
        if (isFirst==1)
            currentFirst=i;
            isFirst=0;
        end
    else
        if (isFirst==0)
            currentLast=i;
            isFirst=1;
        end
    end
    if (currentLast-currentFirst>last-first)
        first=currentFirst;
        last=currentLast;
    end
end




nShiftVelocities=floor(distSigma/2);

first=first-nShiftVelocities;
last=last-nShiftVelocities;
if (last==-nShiftVelocities)
    last=length(handObjectDistancesVelocity)+nShiftVelocities;
end
end

