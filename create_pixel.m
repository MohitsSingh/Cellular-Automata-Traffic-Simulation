function pixel = create_pixel(B, L,side_length)
%���ɶ�ά���飬��ʾԪ���ռ��״̬����
global pixellength;%��·����
pixel = zeros(pixellength,B+2);%����pixel����
pixel(1:pixellength,[B,B+2]) = -1000;%�����ϰ��г̸�·
pixel(floor((pixellength-side_length)/2):pixellength-floor((pixellength-side_length)/2),1:B-1)=-1000;%����С����Χ
for i = 1:pixellength
    if 0.7>rand();
        pixel(i,B+1)=1;
    end
end
%%
