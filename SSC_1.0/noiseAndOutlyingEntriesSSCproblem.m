%   Author:         I.Bogun (ibogun2010@my.fit.edu)
%   Date  :         03/07/2013

% 1. Calculate parameters for the convex problem
% 2. Solve convex problem using CVX
% 3. Feed solution (regression coefficients) to the spectral clustering
% 4. Plot confusion matrix


%% 1. Calculate parameters for the convex problem
Y=dataMatrix;

[n,N]=size(Y);

fun=@(x) norm(x(:),1);

res=arrayfun(fun,Y);

mue=zeros(N,1);
muz=zeros(N,1);

mu_z=0;
mu_e=0;

for i=1:N
    for j=1:N
        if (i==j)
            continue;
        end
        var=norm(Y(:,j),1);
        
        if (mu_e<var)
            mu_e=var;
        end
        
        var2=abs(Y(:,i)'*Y(:,i));
        if (mu_z<var2)
            mu_z=var2;
        end
    end
    mue(i,1)=mu_e;
    muz(i,1)=mu_z;
end
mu_e=min(mue);
mu_z=min(muz);


%% 2. Solve convex problem using CVX
cvx_begin
variables  C(N,N)  Z(n,N)  ;

minimize    (norm(C,1)+(2/(mu_z))*pow_pos(norm(Z,'fro'),2));

subject to
(Y*C+Z)==Y;

for i=1:N
    C(i,i)==0;
end

cvx_end

%% 3. Feed solution (regression coefficients) to the spectral clustering
% Code adopted from SSC.m by  Ehsan Elhamifar


D = 54; %Dimension of ambient space
n = 6; %Number of subspaces
X = dataMatrix;
s = groundTruth; %Generating the ground-truth for evaluating clustering results
r=0;
K =0; %Number of top coefficients to build the similarity graph, enter K=0 for using the whole coefficients

Xp = DataProjection(X,r,'NormalProj');


CMat = C;
[CMatC,sc,OutlierIndx,Fail] = OutlierDetection(CMat,s);
if (Fail == 0)
    CKSym = BuildAdjacency(CMatC,K);
    [Grps , SingVals, LapKernel] = SpectralClustering(CKSym,n);
    [Missrate,confusionMatrix, prediction]= Misclassification(Grps,sc);
    display(confusionMatrix);
    display(Missrate);
end
%% 4. Plot confusion matrix
visualizeConfusionMatrix( confusionMatrix )