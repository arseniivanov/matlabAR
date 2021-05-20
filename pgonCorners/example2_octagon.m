%Find the 8 vertices of an irregular octagon

load example2_octagon

corners = pgonCorners(BW,8);

imshow(BW)

hold on
plot( corners(:,2),corners(:,1),'yo','MarkerFaceColor','r',...
                                'MarkerSize',12,'LineWidth',2);
hold off