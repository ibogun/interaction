kernelNames={'linear','polynomial','gaussian','laplacian',...
    'rationalQuadratic','inverseMultiQuadratic','cauchy','generalized_T-student'};


%Run this script after work!

for kk=3:6
    
    fid = fopen(strcat('results_k=',num2str(kk)),'.txt','w');
    
    
    numberOfLambdas=12;
    shift=6;
    % shift=0;
    lambdas=ones(numberOfLambdas,1);
    
    for i=1:numberOfLambdas
        lambdas(i)=lambdas(i)*(10^(i-shift));
    end
    
    params={1,...
        [1,2,3,4,5,6,7,8,9,10],...
        [0.0001,0.001,0.01,0.1,1,10,100,1000,10000,100000],...
        [0.0001,0.001,0.01,0.1,1,10,100,1000,10000,100000],...
        [0.0001,0.001,0.01,0.1,1,10,100,1000,10000,100000],...
        [0.0001,0.001,0.01,0.1,1,10,100,1000,10000,100000],...
        [0.0001,0.001,0.01,0.1,1,10,100,1000,10000,100000],...
        [1,2,3,4,5,6,7,8,9,10]};
    
    for i=1:length(kernelNames)
        
        par=params{i};
        
        for j=1:numberOfLambdas
            for k=1:length(par);
                try
                    [~,~,miss]=SSC(dataMatrix,groundTruth,6,kk,lambdas(j),getKernel(kernelNames{i},par(k)));
                    fprintf(fid,'kernel=%5s, lambda=%5g, parameter=%5g, missclasification=%5g \n',kernelNames{i},lambdas(j),par(k),min(miss(:)));
                catch err
                    fprintf(fid,'kernel=%5s, lambda=%5g, parameter=%5g, missclasification=%5g  ERROR\n',kernelNames{i},lambdas(j),par(k),min(miss(:)));
                end
            end
        end
        
    end
    
    fclose(fid);
    
end