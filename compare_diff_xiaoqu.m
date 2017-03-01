%% ȫ����ѧ����ѧ��ģ�����ʱȽϲ�ͬС���ȽϵĴ���.
%ÿ�����ӵ�״̬�����֣�
%��1����ʾ����ǰ������,-3��ʾ����С���ĳ�����0��ʾ��λ��-888��ʾ���ɽ�������

%% ��ʼ�����пռ�
clear all;
clc;
warning off;
dbstop if error
W = 0;
%% ��Ҫ����
diff_xiaoqu_size=[25 50 70];%��Ӧ���׳����������СС��,����С��,���С��
max_seperation_distance=25;%��Ӧ����¥���Ŀ��,�������Կ�.
one_step_distance = 6;%һ���Ӧ6m
red_light_time = 60;%���ʱ��
green_light_time = 40;%�̵�ʱ��
global pixellength;%����ȫ�ֱ�����������

%% ����ͳ�����ݵı���
global speed_index
speed_index=0;
loop_times = 10;%ѭ������;
time_step_length = loop_times*(red_light_time+green_light_time)/2;
avr_move_steps = zeros(1,time_step_length);
store_num_of_cars = zeros(1,time_step_length);
store_num_of_jam_cars = zeros(1,time_step_length);
avr_mainroad_move_steps = zeros(1,time_step_length);
%% �������иĽ����N-Sģ������ı���.
for side_length=diff_xiaoqu_size
    pixellength = floor(side_length*1.6);
    data_index = 0;
    avr_mainroad_move_steps_arry=[];
    jam_percentage_arry=[];
    for num_of_street = [0:side_length*one_step_distance/max_seperation_distance]%��0��С����·��ʼ
        data_index = data_index+1;
        B = side_length+1;
        L = 1;     
        pixel = create_pixel(B,L,side_length);%����Ԫ���ռ��״̬����
        pixel = create_street( pixel , num_of_street+1 ,side_length);%����С����·
        pixel_speed = zeros(size(pixel));%С�����ٶȾ���,��Ӧ����λ�õ�С�����ٶ�
        %temp_handle = show_pixel(pixel,B,NaN);%��ʾԪ������
        speed_index=0;
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
                    %temp_handle = show_pixel(pixel,B,temp_handle);%ˢ��ͼ��
                    %drawnow
                    %==============
                    pixel = clear_boundary(pixel);%��Ҫ�뿪ϵͳ�ĳ�������Ҫ��������ϵͳ���Ƴ�
                    %k = k+1;
                    %pause(fresh_frequency);
                    speed_index=speed_index+1;
                    %disp(speed_index)
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
                    %temp_handle = show_pixel(pixel,B,temp_handle);%����ͼ��
                    %drawnow
                    %pause(fresh_frequency);
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
        fprintf('С���߳���%i\n',side_length);
        fprintf('��·���ȣ�%i\n',pixellength);
        fprintf('С����·����%i\n',num_of_street);
        fprintf('һ�����̵������ڵ�һ������ƽ������Ϊ��%f ��ÿʱ��\n',mean(avr_move_steps(end-(red_light_time+green_light_time):end)));
        fprintf('һ�����̵������ڵ�һ���������ϵĳ���ƽ������Ϊ��%f ��ÿʱ��\n',mean(avr_mainroad_move_steps(end-(red_light_time+green_light_time):end)));
        fprintf('�ȶ���λ�ڵ�ͼ�ڵĳ�������Ϊ��%f \n',floor(mean(store_num_of_cars(end-30:end))));
        fprintf('�ȶ���λ�ڵ�ͼ�ڱ������ĳ���Ϊ��%f \n',floor(mean(store_num_of_jam_cars(end-30:end))));
        fprintf('�ȶ���·��ӵ�¶�Ϊ��%f \n',mean(store_num_of_jam_cars(end-30:end))/pixellength);
        avr_mainroad_move_steps_arry(data_index)=mean(avr_mainroad_move_steps(end-(red_light_time+green_light_time):end));
        jam_percentage_arry(data_index)=mean(store_num_of_jam_cars(end-30:end))/pixellength;
    end
    %figure(side_length);
    subplot(2,1,1)
    hold on
    xdata = [0:length(avr_mainroad_move_steps_arry)-1];
    plot(xdata,avr_mainroad_move_steps_arry.*(3600*6/1000))%����Ϊǧ��
    %bar(xdata,avr_mainroad_move_steps_arry.*(3600*6/1000))%����Ϊǧ��
    %avr_mainroad_move_steps_arry.*(3600*6/1000)
    %title(['ͼ1:С���߳�Ϊ',num2str(side_length),'������ƽ������ km / h'])
    xlabel('����С�����������')
    ylabel('����')
    subplot(2,1,2)
    hold on
    plot(xdata,jam_percentage_arry)
    %bar(xdata,jam_percentage_arry)
    %title(['ͼ2:С���߳�Ϊ',num2str(side_length),'��·��ӵ�¶�'])
    xlabel('����С�����������')
    ylabel('������')
    %jam_percentage_arry
end