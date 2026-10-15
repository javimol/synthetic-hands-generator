function ret = generateVideosAndAnnotations(folderName)
%folderName = 'syn_AllPostures_200pov_1perPose_Noisy_phix_0_0.3927_phiy_-0.3927_0.3927_phiz_-0.3927_0.3927'; 
%folderName = 'syn_AllPostures_200pov_1perPose_Noisy_phix_0_0.7854_phiy_-0.7854_0.7854_phiz_-0.7854_0.7854';
if nargin < 1
    folderName = 'syn_AllPostures_I2e';
end
frames = dir([folderName '/*.png']);
OUTPUT = ['VIDEOS_' folderName];
mkdir(OUTPUT);
   
lastGestureId = -1;
lastUserId = -1;
N = -1;
Nlast = -1;
%Ordeno los frames por gestos
ann =   [];
for iframes=1:length(frames)
    filename1 = [frames(iframes).name];
    A = sscanf(filename1, '%d_%d_%d_*');
    userLocal=A(1);
    annLocal=A(2);
    iteLocal=A(3);
    ann=[ann;annLocal];
end
[B,OrderIndexes] = sort(ann)
counterForIterationField = 1;
for iframesAux=1:length(OrderIndexes)+1
     if iframesAux==length(frames)+1
         close(aviobj);
         break;
      end
     iframes = OrderIndexes(iframesAux);
     
    display([num2str(iframes) ' of ' num2str(length(frames))]);
     filename1 = [frames(iframes).name];
    filename = [folderName '/' filename1];
    A = sscanf(filename1, '%d_%d_%d_*');
    userLocal=A(1);
    annLocal=A(2);
    iteLocal=A(3);
    if ((annLocal~=lastGestureId)||(userLocal~=lastUserId))
        if ((lastGestureId~=-1)&&(lastUserId~=-1))
            close(aviobj);
            if  N~=Nlast
                warning('Wrong number of frames.');
            end
        end
        Nlast =  N;
        N =0;
        lastGestureId = annLocal;
        lastUserId = userLocal;
        OUTPUT_AUX = [OUTPUT '/' num2str(userLocal)];
        mkdir(OUTPUT_AUX);
        fnVideo = [OUTPUT_AUX '/depth_' num2str(annLocal) '_' num2str(0) '.avi'];
        aviobj = VideoWriter(fnVideo); aviobj.FrameRate = 5; open(aviobj);
    end
    frame1 = imread(filename);
    frame = imresize(frame1,[240 320]);
    writeVideo(aviobj,frame);
    N = N+1;

end




