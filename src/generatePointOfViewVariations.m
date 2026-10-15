function pM = generatePointOfViewVariations(p0,phixR,phiyR,phizR)
 %Global
 pM = {};
 pLocal = p0;
 counter =1;
 for i=1:length(phixR)
     pLocal.phi1_x= p0.phi1_x + phixR(i);
     for  j=1:length(phiyR)
            pLocal.phi1_y= p0.phi1_y + phiyR(j);
            for  k=1:length(phizR)               
                pLocal.phi1_z=p0.phi1_z + phizR(k);
                pM{counter} = pLocal;
                counter = counter+1;
            end          
     end
 end
