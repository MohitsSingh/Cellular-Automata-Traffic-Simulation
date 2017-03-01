%% ȫ����ѧ����ѧ��ģ����B��������ļ�.
%ÿ�����ӵ�״̬�����֣�
%��1����ʾ����ǰ������,-3��ʾ����С���ĳ�����0��ʾ��λ��-888��ʾ���ɽ�������

%% ��ʼ�����пռ�
clear all;
%clc;
warning off;
dbstop if error
W = 0;
%% ģ����Ҫ��������
red_light_time = 60;%���ʱ��
green_light_time = 40;%�̵�ʱ��
fresh_frequency = 0.1;%ˢ������
num_of_street = 4;%С����·������,Ҳ���ǽ���ڵ�����
global pixellength;%����ȫ�ֱ�����������
pixellength = 30;%�����ĳ���
side_length = 25;%С���߳�
%% ����ͳ�����ݵı���
global speed_index
speed_index=0;
loop_times = 10;%ѭ��`����;
time_step_length = loop_times*(red_light_time+green_light_time)/2;
avr_move_steps = ones(1,time_step_length);
store_num_of_cars = ones(1,time_step_length);
store_num_of_jam_cars = ones(1,time_step_length);
avr_mainroad_move_steps = ones(1,time_step_length);
%% �������иĽ����N-Sģ������ı���.
B = side_length+1;
L = 1;     
pixel = create_pixel(B,L,side_length);%����Ԫ���ռ��״̬����
pixel = create_street(pixel , num_of_street+1 ,side_length);%����С����·
pixel_speed = zeros(size(pixel));%С�����ٶȾ���,��Ӧ����λ�õ�С�����ٶ�
temp_handle = show_pixel(pixel,B,NaN);%��ʾԪ������
 %% ѭ��ˢ��ÿһʱ����ͼ��,ͳ������.
for i = 1:loop_times
    waiting_time = 0;
    output = 0;
    entry = 0;
    traffic_capacity = 0;
    if mod(i,2)~=0
        pixel(end,end-1) = 0;%��Ʊ��̵�
        for xx=1:green_light_time            
            [pixel,pixel_speed,move_step,num_of_cars,num_of_jam_cars,avr_mainroad_move_step] = go_forward(pixel,pixel_speed); %ǰ������
            [pixel,pixel_speed] = new_cars(pixel,1,pixel_speed); %�����ɵĳ����ӵ�Ԫ���ռ������
            entry = entry + 1;
            %waiting_time = waiting_time + compute_wait(pixel); %����������ܵ�ʱ��
            %==============
            temp_handle = show_pixel(pixel,B,temp_handle);%ˢ��ͼ��
            %drawnow
            %==============
            pixel = clear_boundary(pixel);%��Ҫ�뿪ϵͳ�ĳ�������Ҫ��������ϵͳ���Ƴ�
            %k = k+1;
            pause(fresh_frequency);
            speed_index=speed_index+1;
            avr_move_steps(speed_index)=move_step;
            store_num_of_cars(speed_index) = num_of_cars;
            store_num_of_jam_cars(speed_index)=num_of_jam_cars;
            avr_mainroad_move_steps(speed_index)=avr_mainroad_move_step;
        end
    else
        pixel = red_light_on(pixel);%�̵Ʊ���
        for xx=1:red_light_time
            
            [pixel,pixel_speed,move_step,num_of_cars,num_of_jam_cars,avr_mainroad_move_step] = go_forward(pixel,pixel_speed); %ǰ������
            
            [pixel,pixel_speed] = new_cars(pixel,1,pixel_speed); %�����ɵĳ����ӵ�Ԫ���ռ������
            temp_handle = show_pixel(pixel,B,temp_handle);%����ͼ��
            drawnow
            pause(fresh_frequency);
            pixel = clear_boundary(pixel);
            speed_index=speed_index+1;
            avr_move_steps(speed_index)=move_step;
            store_num_of_cars(speed_index) = num_of_cars;
            store_num_of_jam_cars(speed_index)=num_of_jam_cars;
            avr_mainroad_move_steps(speed_index)=avr_mainroad_move_step;
        end
    end               
end

%% ��ͼ��ͳ��
hold off;
time_series = linspace(1,time_step_length,time_step_length);
show_pixel(pixel,B,temp_handle);
figure(2);
% title('ƽ������');
% xlabel('ʱ��')
% ylabel('ÿ������ƽ���ƶ�����')
para = robustfit(time_series,avr_move_steps);
xdata = [ones(size(time_series,2),1) time_series'];
regress_avr_move_steps=xdata*para; 
%fitresult=createFit(avr_move_steps);
temp_handle=plot(avr_move_steps);
legend( temp_handle, 'ÿ������ƽ���ƶ�����' );
hold on;
%plot(fitresult);
title('ƽ������');
xlabel('ʱ��')
ylabel('ÿ������ƽ���ƶ�����')
hold off
figure(3);
% title('λ�ڵ�ͼ�ڵĳ�������');
% xlabel('ʱ��')
% ylabel('��������')
temp_handle=plot(store_num_of_cars);
legend( temp_handle, 'λ�ڵ�ͼ�ڵĳ�������' );
title('λ�ڵ�ͼ�ڵĳ�������');
xlabel('ʱ��')
ylabel('��������')
figure(4);
temp_handle=plot(store_num_of_jam_cars);
legend( temp_handle, '�������ĳ���' );
title('�������ĳ�������');
xlabel('ʱ��')
ylabel('��������')
fprintf('С���߳���%i\n',side_length);
fprintf('��·���ȣ�%i\n',pixellength);
fprintf('С����·����%i\n',num_of_street);
fprintf('һ�����̵������ڵ�һ������ƽ������Ϊ��%f ��ÿʱ��\n',mean(avr_move_steps(end-(red_light_time+green_light_time):end)));
fprintf('һ�����̵������ڵ�һ���������ϵĳ���ƽ������Ϊ��%f ��ÿʱ��\n',mean(avr_mainroad_move_steps(end-(red_light_time+green_light_time):end)));
fprintf('�ȶ���λ�ڵ�ͼ�ڵĳ�������Ϊ��%f \n',floor(mean(store_num_of_cars(end-30:end))));
fprintf('�ȶ���λ�ڵ�ͼ�ڱ������ĳ���Ϊ��%f \n',floor(mean(store_num_of_jam_cars(end-30:end))));
fprintf('�ȶ�������������Ϊ��%f \n',mean(store_num_of_jam_cars(end-30:end))/pixellength);