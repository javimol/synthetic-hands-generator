function ret = printVoxels(voxels,mask,cmap)
hold on
ret = 0;
V=voxels;
if isempty(mask)
    mask = ones(size(voxels));    
end
if isempty(cmap)
    %cmap = [0 0 0]/255;    
    cmap = zeros(256,3);    
end
for z=1:size(V,3)
    [ii,jj]=find(V(:,:,z)==1);
    for cont=1:length(ii)
        i=ii(cont);
        j=jj(cont);
        if V(i,j,z)==1
            colorIndex=mask (i,j);
            if colorIndex>0
            colorLocal = cmap(colorIndex,:);
            else
                 colorLocal = [0 0 0];
            end
           % plot3(i,j,z,'.k');            
            plot3(i,j,z,'.','Color',colorLocal);            
        end
    end    
end
hold off
xlabel('x');
ylabel('y');
zlabel('z');
