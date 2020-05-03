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
for k=1:length(angle)%修改换能器声波发射角，取值范围：-90~+90
alpha(1) = angle(k)/360*2*pi;      %初始化入射角度
SonaDeep = 1500;                %声呐深度位置
TotlePoint = 6000;              %总共绘制点个数
SeaFloor = 3000;                %海底深度
filename = 'OutPutCtest.txt';   %数据文件名
%--------------------------------------------------------------------------

%% read the file
data=dlmread(filename,'\t',1,0);
c=zeros(length(data),1);   %预分配内存  c深度上点的声速
z=zeros(length(data),1);   %预分配内存  z深度
a=zeros(length(data)-1,1); %预分配内存  a层中相对声速梯度

c = data(:,2);
z = data(:,1);

% subplot(1,2,1);
% plot(c,z);    %绘制声速图

%% 初始化、计算参数

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
    
    %判断是否达到海面或者海底
    if position(n,2) == z(1) || position(n,2) == z(end)
        alpha(n) = -alpha(n);
    end
    %判断行进方向
    if alpha(n)>0    %角度大于零，向上传播，深度减小
        step = 1;
        symbol = 1;
    elseif alpha(n)<0 %角度小于零，向下传播，深度增加
        step = -1;
        symbol = -1;
    elseif alpha(n)==0%角度等于零，同层传播
        step = 0;
        symbol = 1;
    end
    
    %判断达到反转点
    alphaNext = acos(c(floornumber - step) * cos(alpha(n)) / c(floornumber)) * symbol;
     if ~isreal(alphaNext)    %识别反转点（因为掠射角难以取到零度，其在接近零时会出现复数）
        alpha(n)=-alpha(n);
     end
     
     %再次判断行进方向
    if alpha(n)>0    %角度大于零，向上传播，深度减小
        step = 1;
        symbol = 1;
    elseif alpha(n)<0 %角度小于零，向下传播，深度增加
        step = -1;
        symbol = -1;
    elseif alpha(n)==0%角度等于零，同层传播
        step = 0;
        symbol = 1;
    end
    
    %计算
    alpha(n+1) = acos(c(floornumber - step) * cos(alpha(n)) / c(floornumber)) * symbol;
     X = X + (z(floornumber + step) - z(floornumber)) / tan((alpha(n + 1) + alpha(n)) / 2);
     position(n,1) = X;
     position(n,2) = z(floornumber + 1);
    %下一点
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
title("初始掠射角为-6°到6°的声线绘制")
xlabel("传输距离\\m")
ylabel("深度\\m")
line([1,position(end,1)],[SeaFloor,SeaFloor])
text(0,SeaFloor,' \leftarrow 海底');
text(0,0,' \leftarrow 海面');
grid on;
break;
end
end
