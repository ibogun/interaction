clc; clear; close all;

load('interpolatedFullDataInStruct');
load('groundTruth');

n=length(data);

tNewMax=100;
tNewMin=3;

dataMatrix=zeros(n,2*(tNewMax-tNewMin+1));
dataMatrix1=zeros(n,2*(tNewMax-tNewMin+1));



isLocalizationEstimated=1;


for i=1:n
    l=data(i).trajectoryLeftHand;
    r=data(i).trajectoryRightHand;
    o=data(i).trajectoryObject;
    h=data(i).trajectoryHead;
    
    % normalization;
    [trajectorySize,~]=size(l);
    
    for j=1:trajectorySize
        l(j,:)=l(j,:)-h(j,:);
        r(j,:)=r(j,:)-h(j,:);
        o(j,:)=o(j,:)-h(j,:);
    end
    
    if (isLocalizationEstimated==1)
        % estimated interaction start/stop
       [tStart,tEnd]=localizeInteraction(data(i));
    else
        % 'ground truth' interaction start/stop
        tStart=data(i).tInteractionStart;
        tEnd=data(i).tInteractionStop;
    end
    
    

    distance=zeros(trajectorySize,1);
    
    hand=findMostCorrelated(l,r,o);
    hand=smooth(hand,11);
    for j=1:trajectorySize
       distance(j)=norm(hand(j,:));
    end
    
    maxDistance=max(distance);
    hand=hand/distance(1);
       
    hand=resample1(hand,tNewMin,tNewMax,tStart,tEnd);
    
    % NORMALIZATION VIA absolute value
    hand(:,2)=abs(hand(:,2));
    
    invHand=hand;
    
    invHand(:,2)=-hand(:,2);
    
    hand=hand(:)';
    dataMatrix(i,:)=hand;
    invHand=invHand(:)';
    dataMatrix1(i,:)=invHand;
        
end
%dataMatrix=[dataMatrix; dataMatrix1];

dataMatrix=dataMatrix';
%mySSC;
%noiseAndOutlyingEntriesSSCproblem;