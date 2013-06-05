clc;clear;close all;

load('fullRawDataSet');



for i=1:10
    [f,l]=localizeInteraction(data(i),15);
    display('calculated');
    display([f l]);
    display('real');
    display([data(i).tInteractionStart, data(i).tInteractionStop]);
end













