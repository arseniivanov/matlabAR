%A more advanced example which finds the "corners" of the vertebrae
%of a spinal column. The vertebrae are not convex, but pgonCorners()
%still works pretty well.

load example3_spine


[m,n]=size(BW);

A=false(m,n);

R=regionprops(BW,'PixelIdxList');
Nv=numel(R); %number of vertebrae

corners=cell(1,Nv);

imshow(BW)


for i=1:Nv
    
   B=A;
   B(R(i).PixelIdxList)=1;
   
   corners{i} = pgonCorners(B,4,40);
   
   hold on
   
   plot( corners{i}(:,2),corners{i}(:,1),'yo','MarkerFaceColor','r','MarkerSize',5);
   
   hold off

end

heights=cellfun(@(c) mean(c(:,1)),corners);

[heights,idx]=sort(heights);
corners=corners(idx);