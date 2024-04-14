clear;
clc;
close all;
%~~~~~~~~~~~~~~~~~~~~~~~布置节点，画节点分布图~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd 'Deploy Nodes'
square_random(1000, 300, 60); %布置节点
Distribution_Of_WSN; %画节点分布图
cd ..;
% ~~~~~~~~~~~~ 给定通信半径，选择通信模型，计算邻居关系，画邻居关系图~~~~~~~~~~
cd 'Topology Of WSN';
comm_r = 300; %给定通信半径
%~~~~~~~~~~~~~~~~~~选择通信模型~~~~~~~~~~~~~~~~~
model='Regular Model';
%~~~~~~~~~~~~~~~~~~计算邻居关系~~~~~~~~~~~~~~~~~
anchor_comm_r = 1;
%anchor_comm_r参数只在APIT中更改，其他的算法统一设置为1。
%它表示锚节点通信半径是未知节点通信半斤的倍数。
calculate_neighbor(comm_r, anchor_comm_r, model);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Topology_Of_WSN; %画邻居关系图
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~选择定位算法~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%cd Centroid;Centroid(20,0.9);%Centroid_second(20,0.9);
%cd RSSI;RSSI;%RSSI_second;
%~~~~~~~~~~~~~~~~~~~~~~~~
%cd 'DV-hop';DV_hop;
%cd Amorphous;Amorphous;
%cd APIT;APIT(0.1*comm_r);
dist_available = true;
cd 'MDS-MAP'; MDS_MAP(dist_available);
cd ..
%~~~~~~~~~~~~~~~~~~~~~~~~~~~计算定位误差，画定位误差图~~~~~~~~~~~~~~~~~~~~~~~
cd 'Localization Error'
calculate_localization_error;
cd ..;
