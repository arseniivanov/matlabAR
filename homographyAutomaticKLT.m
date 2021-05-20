C = imread('food.jpg'); %image to emplace
vid = VideoReader('bettercorner.MP4');
vid.CurrentTime = 0;
B = vid.readFrame();

I1 = rgb2gray(imread('checkerAbove.png')); %Image to match
I2 = rgb2gray(B); %Frame
points1 = detectMinEigenFeatures(I1);
points2 = detectMinEigenFeatures(I2);
[features1, valid_points1] = extractFeatures(I1, points1);
[features2, oldValidLocs] = extractFeatures(I2, points2);
indexPairs = matchFeatures(features1, features2);
xA = valid_points1(indexPairs(:, 1), :);
xB = oldValidLocs(indexPairs(:, 2), :);
% figure; showMatchedFeatures(I1, I2, xA, xB);
oldValidLocs = oldValidLocs.Location;
xA = xA.Location';
xB = xB.Location';

%RANSAC to find best Homography
bestInliers = 0;
bestH = [];
thresh = 5;
iterations = 150;
sz = size(xA);
for i = 1:iterations
    vals = randi(sz(2),1,4);
    inliers = 0;
    correspondences = 4;
    svdPrep = [];
    %DLT
    for k = 1:correspondences
         a =[xA(:,vals(k));1];
         b =[xB(:,vals(k));1];
         svdPrep = [svdPrep;
                    a' zeros(1,3) -b(1)*a(1) -b(1)*a(2) -b(1);
                    zeros(1,3) a' -b(2)*a(1) -b(2)*a(2) -b(2)];
    end
    [U,S,V] = svd(svdPrep);
    V = V(:, end);
    H = reshape(V ,[3  3])';
    H = H/H(3,3);
    for j = 1:sz(2)
         point = [xA(:,j);1];
         xvec = H*point;
         if (norm(xvec-[xB(:,j);1]) < thresh)  
            inliers = inliers + 1;
         end
    end
    if inliers > bestInliers
       bestH = H;
       bestInliers = inliers;
    end
    inliers = 0;
end

reftransf = affine2d(round(bestH'));
videoPlayer = vision.VideoPlayer;
tracker = vision.PointTracker('MaxBidirectionalError',2); %KLT
initialize(tracker,xB',B);
Rout = imref2d(size(B)); %Create outputview the size of B, NOTE: ENTIRE PICTURE
Idtform = projective2d(eye(3)); %Don't manipulate original image
while vid.hasFrame()
    B = vid.readFrame();
    foodResized = imresize(C,size(I1,[1 2])); %Resize food to scene size?
    [points,validity] = tracker(B);
    newValidLocs = points(validity, :);
    oldValidLocs = oldValidLocs(validity,:);
    sz = size(points,2);
    [trackTransf,oldInlierLoc,newInlierLoc] = estimateGeometricTransform(oldValidLocs, newValidLocs, 'Similarity');
    setPoints(tracker,newInlierLoc);
    trackTransf.T = reftransf.T * trackTransf.T;
    [Btransf] = imwarp(B,Idtform ,'OutputView',Rout);
    AB = Btransf;
    [foodTransf] = imwarp(foodResized, trackTransf,'OutputView',Rout); %Transform food-picture
    AB(Btransf & foodTransf) = foodTransf(Btransf  & foodTransf); %Add images together
    videoPlayer(AB);
end

% B = vid.readFrame();
% imshow(B)
% fig2 = drawpolygon('Color','r');
% xBold = fig2.Position';
% tracker = vision.PointTracker('MaxBidirectionalError',1);
% points = detectMinEigenFeatures(im2gray(B),'ROI',objectRegion);
% initialize(tracker,points.Location,B);
