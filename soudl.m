%% -----------------------------------------------------------------
%                           Editor Information
%--------------------------------------------------------------------------
% Ver: 2.1
% Inf: SoundLine Pic app
% Editior: Kim Huang form SDUST
% Mail: kim.huang.j@qq.com
% 
% Latest:
% Add the deep ocean sound channel
% Suit deep ocean sound channel 's soundline
%--------------------------------------------------------------------------

%% -----------------------------------------------------------------
%                               START
%--------------------------------------------------------------------------
clear;
clc;
%--------------------------------------------------------------------------

%% -----------------------------------------------------------------
%                           Control Information
%--------------------------------------------------------------------------
angle = -6:0.6:6;
for k=1:length(angle)%�޸Ļ�������������ǣ�ȡֵ��Χ��-90~+90
alpha(1) = angle(k)/360*2*pi;      %��ʼ������Ƕ�
SonaDeep = 1500;                %�������λ��
TotlePoint = 6000;              %�ܹ����Ƶ����
SeaFloor = 3000;                %�������
filename = 'OutPutCtest.txt';   %�����ļ���
%--------------------------------------------------------------------------

%% read the file
data=dlmread(filename,'\t',1,0);
c=zeros(length(data),1);   %Ԥ�����ڴ�  c����ϵ������
z=zeros(length(data),1);   %Ԥ�����ڴ�  z���
a=zeros(length(data)-1,1); %Ԥ�����ڴ�  a������������ݶ�

c = data(:,2);
z = data(:,1);

% subplot(1,2,1);
% plot(c,z);    %��������ͼ

%% ��ʼ�����������

position = zeros(60000,2);
alpha = ones(60000,1);
floornumber = 1;
n = 1;
X = 0;
position(1,:)=[X SonaDeep];
angle(k) = angle(k)*pi/180;
alpha(1,1) = angle(k);

%% Judge the FloorNumber with the sona Deepth;
for j = 1:length(z)
    if position(1,2) == z(j)
        floornumber = j;
        break;
    elseif position(1,1) < z(j)
        continue;
    elseif position(1,1) > z(j)
        break;
    end
end
X = 0;
%% Caculate Circle 
%while n < TotlePoint
while X<=100000
    
    %�ж��Ƿ�ﵽ������ߺ���
    if position(n,2) == z(1) || position(n,2) == z(end)
        alpha(n) = -alpha(n);
    end
    %�ж��н�����
    if alpha(n)>0    %�Ƕȴ����㣬���ϴ�������ȼ�С
        step = 1;
        symbol = 1;
    elseif alpha(n)<0 %�Ƕ�С���㣬���´������������
        step = -1;
        symbol = -1;
    elseif alpha(n)==0%�Ƕȵ����㣬ͬ�㴫��
        step = 0;
        symbol = 1;
    end
    
    %�жϴﵽ��ת��
    alphaNext = acos(c(floornumber - step) * cos(alpha(n)) / c(floornumber)) * symbol;
     if ~isreal(alphaNext)    %ʶ��ת�㣨��Ϊ���������ȡ����ȣ����ڽӽ���ʱ����ָ�����
        alpha(n)=-alpha(n);
     end
     
     %�ٴ��ж��н�����
    if alpha(n)>0    %�Ƕȴ����㣬���ϴ�������ȼ�С
        step = 1;
        symbol = 1;
    elseif alpha(n)<0 %�Ƕ�С���㣬���´������������
        step = -1;
        symbol = -1;
    elseif alpha(n)==0%�Ƕȵ����㣬ͬ�㴫��
        step = 0;
        symbol = 1;
    end
    
    %����
    alpha(n+1) = acos(c(floornumber - step) * cos(alpha(n)) / c(floornumber)) * symbol;
     X = X + (z(floornumber + step) - z(floornumber)) / tan((alpha(n + 1) + alpha(n)) / 2);
     position(n,1) = X;
     position(n,2) = z(floornumber + 1);
    %��һ��
    n = n+1;
    floornumber = floornumber - step;
end

%% Draw the SoundLine Pic
%subplot(1,2,2);
scatter(position(:,1),position(:,2),1,[rand rand rand])
hold on;
while(k==length(angle))
axis([0,inf,300,2700]);
set(gca,'YDir','reverse');
title("��ʼ�����Ϊ-6�㵽6������߻���")
xlabel("�������\\m")
ylabel("���\\m")
line([1,position(end,1)],[SeaFloor,SeaFloor])
text(0,SeaFloor,' \leftarrow ����');
text(0,0,' \leftarrow ����');
grid on;
break;
end
end
