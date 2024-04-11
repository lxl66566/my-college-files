clear;
clc;
close all;
%~~~~~~~~~~~~~~~~~~~~~~~���ýڵ㣬���ڵ�ֲ�ͼ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd 'Deploy Nodes'
square_random(1000, 300, 60); %���ýڵ�
Distribution_Of_WSN; %���ڵ�ֲ�ͼ
cd ..;
% ~~~~~~~~~~~~ ����ͨ�Ű뾶��ѡ��ͨ��ģ�ͣ������ھӹ�ϵ�����ھӹ�ϵͼ~~~~~~~~~~
cd 'Topology Of WSN';
comm_r = 300; %����ͨ�Ű뾶
%~~~~~~~~~~~~~~~~~~ѡ��ͨ��ģ��~~~~~~~~~~~~~~~~~
model='Regular Model';
%~~~~~~~~~~~~~~~~~~�����ھӹ�ϵ~~~~~~~~~~~~~~~~~
anchor_comm_r = 1;
%anchor_comm_r����ֻ��APIT�и��ģ��������㷨ͳһ����Ϊ1��
%����ʾê�ڵ�ͨ�Ű뾶��δ֪�ڵ�ͨ�Ű��ı�����
calculate_neighbor(comm_r, anchor_comm_r, model);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Topology_Of_WSN; %���ھӹ�ϵͼ
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ѡ��λ�㷨~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd Centroid; Centroid(20, 0.9); %Centroid_second(20,0.9);
cd ..;
cd RSSI; RSSI; %RSSI_second;
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~
cd 'DV-hop'; DV_hop;
cd Amorphous; Amorphous;
cd APIT; APIT(0.1 * comm_r);
dist_available = true;
cd 'MDS-MAP'; MDS_MAP(dist_available);
cd ..
%~~~~~~~~~~~~~~~~~~~~~~~~~~~���㶨λ������λ���ͼ~~~~~~~~~~~~~~~~~~~~~~~
cd 'Localization Error'
calculate_localization_error;
cd ..;
