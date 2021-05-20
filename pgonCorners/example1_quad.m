%Find the 4 vertices of a quadrilateral

load example1_quad

corners = pgonCorners(BW,4);

imshow(BW)

hold on
plot( corners(:,2),corners(:,1),'yo','MarkerFaceColor','r',...
                                'MarkerSize',12,'LineWidth',2);
hold off