function pixel = clear_boundary(pixel)
%��Ҫ�뿪ϵͳ�ĳ�������Ҫ��������ϵͳ���Ƴ�������Ԫ���ռ������һ�д���0 ����Ϊ0
[L,W] = size(pixel);
if pixel(L,end-1)==1
    pixel(L,end-1)=0;
end
pixel(pixel(:,1)==-3)=0;
