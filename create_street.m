function [ pixel ] = create_street( pixel , amount ,side_length)
%��С��������ӵ�·
%   �˴���ʾ��ϸ˵��
step = floor(side_length/(amount)+1);%���������Ĳ���
start_point = floor((size(pixel,1)-side_length)/2);
for i = start_point+step:step:start_point+side_length
    pixel(i,1:side_length+1) = 0;
end


end

