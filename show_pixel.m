function h = show_pixel(pixel, B, h)
%��ͼ����ʾԪ���ռ�
[L, W] = size(pixel); %��ȡ�������ȣ�������
temp = pixel;
temp(temp==1) = 0;%һ��ʼ�Ȱѳ����еĳ����

PLAZA(:,:,1) = pixel;
PLAZA(:,:,2) = pixel;
PLAZA(:,:,3) = pixel;

PLAZA(PLAZA==0)=1;
if pixel(end,end-1) == -2;
    PLAZA(end,end-1,1) =1;
    PLAZA(end,end-1,2) =0;
    PLAZA(end,end-1,3) =0;
end
for j=1:W
    for i=1:L
        if pixel(i,j) <= -3&&pixel(i,j) >= -10
            PLAZA(i,j,1) =0;
            PLAZA(i,j,2) =1;
            PLAZA(i,j,3) =0;
        elseif pixel(i,j) == 1
            PLAZA(i,j,1) =0.1289;
            PLAZA(i,j,2) =0.3867;
            PLAZA(i,j,3) =1;
        elseif pixel(i,j) <-100
            PLAZA(i,j,1) =0.45;
            PLAZA(i,j,2) =0.45;
            PLAZA(i,j,3) =0.45;
        end
    end
end
% for i = (L+1)/2
%     for j = ceil(W/2)-ceil(B/2)+2:ceil(W/2)+floor(B/2)
%         if pixel(i,j) == 0;
%             PLAZA(i,j,1) =0;
%             PLAZA(i,j,2) =1;
%             PLAZA(i,j,3) =0;
%         else
%             PLAZA(i,j,1) =1;
%             PLAZA(i,j,2) =0;
%             PLAZA(i,j,3) =0;
%         end
%     end
% end

if ishandle(h)
    set(h,'CData',PLAZA)
else
    figure('position',[20,100,1200,600])
    h = imagesc(PLAZA);    
    hold on
    plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k')%������
    plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k')%������
    axis image
    set(gca,'xtick',[]);%ȥ������x��ı�ǩ
    set(gca,'ytick',[]);%ȥ�����y��ı�ǩ
end