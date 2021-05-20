function [outputArg1] = resection(model,projections)
%RESECTION Get camera matrix from at least 6 points and their projections
%   
    means1 = mean(projections(1:2 ,:) ,2);
    stds1 = std(projections(1:2 ,:) ,0 ,2);

    N1 = [1/stds1(1) 0 -means1(1)*1/stds1(1); 
          0 1/stds1(2) -means1(2)*1/stds1(2);
          0 0 1];

    sz =  size(projections);
    xA = [projections; ones(1,sz(2))];
    xA = N1*xA;

    svdPrep = [];
    samples = sz(2);
    for i = 1:samples
    svdPrep = [svdPrep; model(:,i)' zeros(1,8) zeros(1,(i-1)) -xA(1,i) zeros(1,samples-i);
              zeros(1,4) model(:,i)' zeros(1,4) zeros(1,(i-1)) -xA(2,i) zeros(1,samples-i);
                          zeros(1,8) model(:,i)' zeros(1,(i-1)) -1 zeros(1,samples-i)];
    end
    [U,S,V] = svd(svdPrep);
    V = V(:, end);
    P1 = reshape(V(1:12) ,[4  3])';
    if (det(P1(:,1:3))< 0)
        P1 = -P1;
    end

    P1 = N1\P1;

    outputArg1 = P1;
end

