%=====================================================
%����ͼ����
%Sovling Problems:
%���任����Ϊȫָ���ԣ����任�����ֱ�λ��ˮ��5��/50��/200��/500�ס�1000�״���
%����Ŀ������ˮ��Ϊ2000��ƽ̹���ף�
%���Ʒ��任���������߷ֲ�ͼ��
%���ջ��������뷢�任��������Ϊ10000�ף��ֱ�λ��ˮ��5��/50��/200��/500��/1000�״����жϽ��ջ�����������λ������ʲô����
%Editor:JinHuang
%V1.00
%LastEdit:10/13/sun
% Ѱ�ұ߽���������ѡ��Ƕȱ任��Ϊ�ٽ磬alpha=0˵�����ַ�ת�㣬�����Ϊ�ڶ��ٽ��
%=====================================================


data=dlmread("OutPutC.txt",'\t',1,0);
c=zeros(1,length(data));   %Ԥ�����ڴ�  c����ϵ������
z=zeros(1,length(data));   %Ԥ�����ڴ�  z���
h=zeros(1,length(data)-1); %Ԥ�����ڴ�  h����
a=zeros(1,length(data)-1); %Ԥ�����ڴ�  a�����������
c=data(:,2);
z=data(:,1);
for i=2:1:length(data)
    h(i-1)=z(i)-z(i-1);
    a(i-1)=(c(i)-c(i-1))/(c(i-1)*h(i-1));
end
alpha=ones(1,2000);
alpha(:)=NaN;

alpha=alpha';
position=[0 1000]; %���任����λ�ã����޸�Ϊ50,200,500,1000
angle=-10;         %�޸Ļ�������������ǣ�ȡֵ��Χ��-90~+90
alpha(1)=angle/360*2*pi;  %��ʼ������Ƕ�



PointNumber=1;  %��λ��
FloorNumber=1;  %����
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
     if abs(alpha(PointNumber))<=0.01&&alpha(PointNumber)>=0    %ʶ��ת��
        alpha(PointNumber)=-alpha(PointNumber);
        symbol=-symbol;
     end
    
    if alpha(PointNumber)>0    %Judge circulation approach
        Step=-1; %plus Step means the height being shallow
    else
        Step=1; %plus Step means being deeper
    end
    
    
    
    PointNumber=PointNumber+1;
    FloorNumber=FloorNumber+Step;%ʹ�˴�ˮ��仯
    
    alpha(PointNumber)=acos(c(FloorNumber)*cos(alpha(PointNumber-1))/c(FloorNumber-Step))*symbol;   %�����ж�ӦΪ���ŵ�����
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
scatter(position(:,1),position(:,2),1,[rand rand rand])%������Ϊ�ʺ�����[rand rand rand]��Ϊc
set(gca,'YDir','reverse')
title("���߻���")
xlabel("�������\\m")
ylabel("���\\m")
grid on
hold on
line([1,position(end,1)],[1530,1530])
text(0,1530,' \leftarrow ����');
%hold off

% 
% function [y]=Cv(Z)
% %   ����������٣���Ϊ���ú㶨�����ݶȵ����������ĳһ���ڵ�����Ӧ������ͬ
% %   zΪ��ȣ�����ֵΪĳһ���е�����
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
