function [pixel,pixel_speed,move_steps,num_of_cars,jam_cars,main_road_move_steps] = go_forward(pixel,pixel_speed)
%ǰ������
%���򣬸ó��Ը���Ϊprobǰ������ǰ���λ��
[L, W] = size(pixel); %get its dimensions
prob = 0.9;
temp_pixel = pixel;
global total_speed;
num_of_cars=0;
speed_max = 3;%����ٶ�
jam_cars= 0;
move_steps=0;
main_road_move_steps=0;
%if  ~isempty(find(pixel(:,W-1)==-3,1))%����һ��ʱ,�����������С����·ʱռ�õ�pixel(i,j)
    pixel(pixel(:,W-1)==-3,W-1) =0;
    pixel(pixel<=-4&pixel>=-10) = pixel(pixel<=-4&pixel>=-10)+1;
%end
move_steps=0;
%% ����ǰ�����߼�

for i = (L-1):-1:1
    for j =1: W-1
        if temp_pixel(i,j) == 1%����·���ƶ����
            if temp_pixel(i+1, j) ~= 0%�³���
                if temp_pixel(i, j-1)==0&&(temp_pixel(i+1, j)&temp_pixel(i+2, j)) ~= 0%�������Ҳ��������ǰ������ʱ�ҹ���С��
                    pixel(i,j) = -8;%�ڴ�ʱ��ռ�� pixel(i,j)����һʱ���ٽ�pixel(i,j)��Ϊ0���Դ�����ʾ����ڶԵ�·ͨ�е�Ӱ��
                    pixel(i, j-1) = -8;
                end
                pixel_speed(i,j) = 0;
            elseif prob >= rand%��ǰ�ƶ�                
                if i+pixel_speed(i,j)>L%Խ���߽�ʱ                    
                    next = find(temp_pixel(i+1:L,j),1);%�ж���һ�εļ����ƶ��Ƿ����ײ
                if ~isempty(next)&&next~=1%����������N-S����,�ƶ���ǰ��n���ٶȽ�ΪVn-1
                    total_speed=total_speed+(next-1);
                    move_steps=move_steps+(next-1);
                    next = next + i;
                    pixel(next-1,j) = 1;
                    %disp(next)
                    pixel(i,j)=1;%��ռ��С��·����ռ��
                    pixel_speed(i,j)=0;
                    pixel_speed(next-1,j)=1;                    
                elseif isempty(next)
                    pixel(i,j)=0;
                    total_speed=total_speed+pixel_speed(i,j);
                    move_steps = move_steps+pixel_speed(i,j);
                end
                    break;
                end
                temp_pixel(temp_pixel==-2)=3;%�����̵�ת�����������ж�
                next = find(temp_pixel(i+1:(i+pixel_speed(i,j)),j),1);%�ж���һ�εļ����ƶ��Ƿ����ײ
                if ~isempty(next)&&next~=1%��ײ��ǰ��������NaSch����,�ƶ���ǰ��n���ٶȽ�ΪVn-1
                    total_speed=total_speed+(next-1);
                    move_steps = move_steps+(next - 1);
                    next = next + i;                    
                    %disp(next)
                    pixel(i,j)=0;
                    pixel(next-1,j) = 1;
                    pixel_speed(i,j)=0;
                    pixel_speed(next-1,j)=1;                    
                elseif isempty(next)
                    pixel(i,j)=0;
                    pixel(i+pixel_speed(i,j), j) = 1;
                    total_speed=total_speed+pixel_speed(i,j);
                    move_steps = move_steps+pixel_speed(i,j);
                    if (pixel_speed(i,j)+1)>speed_max
                        pixel_speed(i+pixel_speed(i,j), j)=speed_max;
                    else
                        pixel_speed(i+pixel_speed(i,j), j)=pixel_speed(i,j)+1;
                    end                   
                end               
            end
            main_road_move_steps = move_steps;%��·���ƶ�����
        elseif pixel(i,j) == -3%С���ڳ������ƶ�
                if (prob-0.3) >= rand&&pixel(i, j-1)==0&&j~=W-1;%184׼��
                    %total_speed=total_speed+1;
                    move_steps = move_steps+1;                    
                    pixel(i,j) = 0;
                    pixel(i, j-1) = -3;
                end
        end
    end
end
%% ͳ������
for i=1:W
    for j=1:L
        if pixel(j,i)==1||pixel(j,i)==-3
            num_of_cars=num_of_cars+1;
            if pixel(j,i)==1&&pixel_speed(j,i)==0;
                jam_cars = jam_cars+1;
            end
        end
    end
end
if main_road_move_steps==0||sum(temp_pixel(:,W-1)==1)==0
    main_road_move_steps=0;
else
    main_road_move_steps = main_road_move_steps/sum(temp_pixel(:,W-1)==1);
end
if(main_road_move_steps ==0)
    %disp('1')
end
if    move_steps==0||sum(sum(temp_pixel==1))==0%��ֹNaN��Inf
    move_steps = 0;
else
    move_steps = move_steps/sum(sum(temp_pixel==1));
end
end