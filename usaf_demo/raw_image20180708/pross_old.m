clc
clear
pix = 260;
lowSeq=zeros(pix,pix,64);

x_pos = 619;
y_pos = 420;
for n=1:64
    A=imread(['raw_data//image',num2str(n),'.png']);
    p=im2double(A);
    %p=p(286:286+pix-1,494:494+pix-1);
    p=p(y_pos:y_pos+pix-1,x_pos:x_pos+pix-1);
    %p(953,1109) = 0;
    lowSeq(:,:,n)=p;
    imwrite(p,['pross\\',num2str(n),'.tif'])
    n
end
lowSeq = lowSeq-min(lowSeq(:));
lowSeq = lowSeq/max(lowSeq(:));
AA = mean(lowSeq,3);
%newpix=pix*4;
objectRecover = imresize(AA,[1024,1024]);
imwrite(mat2gray(objectRecover),'incohren_1024.png');

% lowSeq = lowSeq-min(lowSeq(:));
% lowSeq = lowSeq/max(lowSeq(:));
AA = lowSeq(:,:,1);
%newpix=pix*4;
objectRecover = imresize(AA,[1024,1024]);

imwrite(mat2gray(objectRecover),'ORG.png');

save(['lowSeqData',num2str(pix),'.mat'],'lowSeq')