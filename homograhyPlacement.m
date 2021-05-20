%A - Image to insert into other image
A = imread('food.jpg');
sz = size(A);
xA = [0 0 sz(2) sz(2);0 sz(1) sz(1) 0];

%B - Mark image to insert to. Point order: upper left -> lower left -> lower right -> upper right -> Press Enter
B = imread('imchecker.jpg');
imshow(B)
fig2 = drawpolygon('Color','r');
xB = fig2.Position';
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
Rout = imref2d(size(B)); %Create outputview the size of B, NOTE: ENTIRE PICTURE
Idtform = projective2d(eye(3)); %Don't manipulate original image
[Btransf] = imwarp(B,Idtform ,'OutputView',Rout);
AB = Btransf;
[foodTransf] = imwarp(A, Htform,'OutputView',Rout); %Transform food-picture
AB(Btransf & foodTransf) = foodTransf(Btransf  & foodTransf); %Add images together
imagesc(Rout.XWorldLimits ,Rout.YWorldLimits ,AB); %Render image

sz = size(B);
f = 1109; %f = (sz(2)/2)/tan(60/2), 60 = FOV of camera.
K = [f    0 sz(1)/2; 
     0    f sz(2)/2;
     0    0    1];

[R1,T1,N1,R2,T2,N2,R3,T3,N3,R4,T4,N4] = decompHomography(H',K);

sol1 = [R1' T1 N1];
sol2 = [R2' T2 N2];
sol3 = [R3' T3 N3];
sol4 = [R4' T4 N4];