function [pixel,pixel_speed] = new_cars(pixel, entry,pixel_speed)
%���³����뵽Ԫ���ռ�����У����ҿ��Կ��Ƽ��³����ܶȡ�

if entry > 0&&1>rand()%1>rand()Ϊ�������ý����·�ĳ������ܶ�
       pixel(1,end-1) = 1;
       pixel_speed(1,end-1) = 4;

end
%%