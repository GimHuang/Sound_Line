%=====================================================
%声线图绘制
%Sovling Problems:
%发射换能器为全指向性，发射换能器分别位于水下5米/50米/200米/500米、1000米处；
%假设目标区域水深为2000米平坦海底；
%绘制发射换能器的声线分步图；
%接收换能器距离发射换能器距离为10000米，分别位于水下5米/50米/200米/500米/1000米处，判断接收换能器的所在位置属于什么区域？
%Editor:JinHuang
%V1.00
%LastEdit:10/13/sun
% 寻找边界条件可以选择角度变换作为临界，alpha=0说明出现反转点，深度作为第二临界点
%=====================================================


data=dlmread("OutPutC.txt",'\t',1,0);
c=zeros(1,length(data));   %预分配内存  c深度上点的声速
z=zeros(1,length(data));   %预分配内存  z深度
h=zeros(1,length(data)-1); %预分配内存  h层厚度
a=zeros(1,length(data)-1); %预分配内存  a层中相对声速
c=data(:,2);
z=data(:,1);
for i=2:1:length(data)
    h(i-1)=z(i)-z(i-1);
    a(i-1)=(c(i)-c(i-1))/(c(i-1)*h(i-1));
end
alpha=ones(1,2000);
alpha(:)=NaN;

alpha=alpha';
position=[0 1000]; %发射换能器位置，可修改为50,200,500,1000
angle=-10;         %修改换能器声波发射角，取值范围：-90~+90
alpha(1)=angle/360*2*pi;  %初始化入射角度



PointNumber=1;  %点位数
FloorNumber=1;  %层数
if alpha(1)>0
    symbol=1;
else
    symbol=-1;
end

X=0;
for i=2:1:length(z)     %Judge the FloorNumber throuth the Z axis
    if position(1,2)<=z(i)&&position(1,2)>z(i-1)
        break
    else
        FloorNumber=FloorNumber+1;
    end
end
%FloorNumber

while PointNumber<2000
     if position(PointNumber,2)==4||position(PointNumber,2)==1530   %Judege the case of SeaSurface or Seafloor
        alpha(PointNumber)=-alpha(PointNumber);
        symbol=-symbol;
     end 
     if abs(alpha(PointNumber))<=0.01&&alpha(PointNumber)>=0    %识别反转点
        alpha(PointNumber)=-alpha(PointNumber);
        symbol=-symbol;
     end
    
    if alpha(PointNumber)>0    %Judge circulation approach
        Step=-1; %plus Step means the height being shallow
    else
        Step=1; %plus Step means being deeper
    end
    
    
    
    PointNumber=PointNumber+1;
    FloorNumber=FloorNumber+Step;%使此处水深变化
    
    alpha(PointNumber)=acos(c(FloorNumber)*cos(alpha(PointNumber-1))/c(FloorNumber-Step))*symbol;   %初步判断应为负号的问题
    %alpha(PointNumber)/2/pi*360
    X=X+(z(FloorNumber)-z(FloorNumber-symbol))/tan((alpha(PointNumber)+alpha(PointNumber-1))/2);
    position(PointNumber,1)=X;
    position(PointNumber,2)= z(FloorNumber);
% if PointNumber>=194
%         FloorNumber
%         alpha(PointNumber)/2/pi*360
% end
end

c = linspace(1,10,length(position));
scatter(position(:,1),position(:,2),1,[rand rand rand])%若更换为彩虹线则将[rand rand rand]变为c
set(gca,'YDir','reverse')
title("声线绘制")
xlabel("传输距离\\m")
ylabel("深度\\m")
grid on
hold on
line([1,position(end,1)],[1530,1530])
text(0,1530,' \leftarrow 海底');
%hold off

% 
% function [y]=Cv(Z)
% %   计算层中声速，因为采用恒定声速梯度的情况，所以某一层内的声速应大致相同
% %   z为深度，返回值为某一层中的声速
% 
% data=dlmread("OutPutC.txt",'\t',1,0);
% for i=1:1:length(data)
%     c(i)=data(i,2);
%     z(i)=data(i,1);
% end
% for i=2:1:length(data)
%     h(i-1)=z(i)-z(i-1);
%     a(i-1)=(c(i)-c(i-1))/(c(i-1)*h(i-1));
% end
% 
% for i=2:1:length(data)
%     if(Z>data(i,1)&&Z>data(i-1,1))
%         y=c(i-1)*(1+a(i)*(Z-z(i-1)));
%     end
% end
% end
