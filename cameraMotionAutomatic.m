%A - Image to insert into video
A = imread('food.jpg');
sz = size(A);
xA = [ 0 sz(2) sz(2) 0; sz(1) sz(1) 0 0];

vid = VideoReader('blackbook.MP4');
vid.CurrentTime = 0;
videoPlayer = vision.VideoPlayer;
B = vid.readFrame(); %Initialize xBold(First frame)
T = imcomplement(imbinarize(rgb2gray(B),0.4));
T = bwareafilt(T,1);
xBold = pgonCorners(T,4);
xBold = flip(xBold,2)';
Rout = imref2d(size(B)); %Create outputview the size of B, NOTE: ENTIRE PICTURE
Idtform = projective2d(eye(3)); %Don't manipulate original image
while vid.hasFrame()
    B = vid.readFrame();
    T = imcomplement(imbinarize(rgb2gray(B),0.4));
    T = bwareafilt(T,1);
    xB = pgonCorners(T,4);
    if (size(xB,1) < 4)
       continue;
    end
    xB = flip(xB,2)';
    xDetectedFirst = xB;
    
    %---Don't allow huge jumps by using distance to previous point.---
    for i = 1:4
       if (sum(abs(xB(:,i)-xBold(:,i))) > 50)
          xB(:,i) = xBold(:,i);
       end
    end
    xB = (xB+xBold)/2; %Reduce flutter of image from corner-jumps
    xBold = xB;
    
    %SVD to get homography from 4 points correspondences
    svdPrep = [];
    for k = 1:4
     a =[xA(:,k);1];
     b =[xB(:,k);1];
     svdPrep = [svdPrep;
                a' zeros(1,3) -b(1)*a(1) -b(1)*a(2) -b(1);
                zeros(1,3) a' -b(2)*a(1) -b(2)*a(2) -b(2)];
    end
    [U,S,V] = svd(svdPrep);
    V = V(:, end);
    H = reshape(V ,[3  3])';
    H = H/H(3,3);
    
    Htform = projective2d(H'); %Create transform
    [Btransf] = imwarp(B,Idtform ,'OutputView',Rout);
    AB = Btransf;
    [foodTransf] = imwarp(A, Htform,'OutputView',Rout); %Transform food-picture
    AB(Btransf & foodTransf) = foodTransf(Btransf  & foodTransf); %Add images together
    videoPlayer(AB);
end