clc;clear; close all;

load('interpolatedFullData');

data=struct('trajectoryLeftHand',[],'trajectoryRightHand',[],...
    'trajectoryTorso',[],'trajectoryHead',[],'trajectoryObject',[],...
    'tGrasp',[],'tInteractionStart',[],'tInteractionStop',[],'tPutBack',[]);


n=length(processedData);

data=repmat(data,n,1);

for i=1:n
    data(i).trajectoryLeftHand=processedData(i).trajectoryLefthand.singlePointArray;
    data(i).trajectoryRightHand=processedData(i).trajectoryRighthand.singlePointArray;
    data(i).trajectoryTorso=processedData(i).trajectoryTorso.singlePointArray;
    data(i).trajectoryHead=processedData(i).trajectoryHead.singlePointArray;
    data(i).trajectoryObject=processedData(i).trajectoryObject.singlePointArray;
    data(i).tGrasp=processedData(i).tGrasp;
    data(i).tInteractionStart=processedData(i).tInteractionStart;
    data(i).tInteractionStop=processedData(i).tInteractionStop;
    data(i).tPutBack=processedData(i).tPutBack;
end


savefile='interpolatedFullDataInStruct';
save(savefile,'data');