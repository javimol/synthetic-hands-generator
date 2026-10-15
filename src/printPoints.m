function ret = printPoints(rS,format)
%PRINTPOINTS Plot the hand skeleton returned by calculatePoints.
%   printPoints(rS, format) draws the joints with the marker given in
%   format (e.g. '*'), the fill points, the bones and a small axis gizmo.
showFill = true;
ret = 0;
hold on;
levels = {rS.wrist, rS.r1, rS.r2, rS.r3, rS.r4, rS.r5};
for k = 1:numel(levels)
    plot3(levels{k}(1,:),levels{k}(2,:),levels{k}(3,:),format,'MarkerSize',12);
end
if showFill
    plot3(rS.fill(1,:),rS.fill(2,:),rS.fill(3,:),'k.','MarkerSize',12);
    % Lines across the palm at levels 1 and 2
    plot3(rS.r1(1,:),rS.r1(2,:),rS.r1(3,:),'-.g');
    plot3(rS.r2(1,:),rS.r2(2,:),rS.r2(3,:),'-.g');
    plot3([rS.r2(1,1) rS.r2(1,3)],[rS.r2(2,1) rS.r2(2,3)],[rS.r2(3,1) rS.r2(3,3)],'-.g');
    plot3(rS.fill1(1,:),rS.fill1(2,:),rS.fill1(3,:),'og','MarkerSize',12);
    plot3(rS.fill2(1,:),rS.fill2(2,:),rS.fill2(3,:),'og','MarkerSize',12);
    for i=1:size(rS.fill1,2)
        plot3([rS.fill1(1,i) rS.fill2(1,i)],[rS.fill1(2,i) rS.fill2(2,i)],[rS.fill1(3,i) rS.fill2(3,i)],':g');
    end
end
% Joint labels: T1, I1, ... and T2, I2, ...
fingers = 'TIMRL';
for i=1:size(rS.r1,2)
    text(rS.r1(1,i),rS.r1(2,i),rS.r1(3,i),[fingers(i) '1'],'FontSize',18);
    text(rS.r2(1,i),rS.r2(2,i),rS.r2(3,i),[fingers(i) '2'],'FontSize',18);
end
if ~showFill
    for i=1:size(rS.r3,2)
        text(rS.r3(1,i),rS.r3(2,i),rS.r3(3,i),[fingers(i) '3'],'FontSize',18);
    end
    for i=2:size(rS.r4,2)
        text(rS.r4(1,i),rS.r4(2,i),rS.r4(3,i),[fingers(i) '4'],'FontSize',18);
    end
end

% Axes
plot3([-30 -25],[15 15],[0,0],'-k');
plot3(-25,15,0,'>k','MarkerSize',12);
plot3([-30 -30],[15 20],[0,0],'-k');
plot3(-30,20,0,'^k','MarkerSize',12);
plot3(-30,15,0,'ok','MarkerSize',12);
text(-25,15,0,'x','FontSize',18);
text(-30,20,0,'y','FontSize',18);
text(-30,15,0,'z','FontSize',18);

% Bones: thumb (no level 5), then the other fingers
bones = [rS.wrist rS.r1(:,1) rS.r2(:,1) rS.r3(:,1) rS.r4(:,1)];
plot3(bones(1,:),bones(2,:),bones(3,:),'k-');
for f=2:5
    bones = [rS.wrist rS.r1(:,f) rS.r2(:,f) rS.r3(:,f) rS.r4(:,f) rS.r5(:,f-1)];
    plot3(bones(1,:),bones(2,:),bones(3,:),'k-');
end
hold off;
