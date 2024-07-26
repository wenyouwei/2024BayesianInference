close all; clear all; clc;
addpath('data');

% %% load 2Ps data
% Img=double(imread('given_new_1.png'));
% Img=Img-min(Img(:));Img=Img/max(Img(:));
% 
% Clean = double(rgb2gray(imread('shape_clean.jpg')));
% Clean=Clean-min(Clean(:));Clean=Clean/max(Clean(:));
% k = 2;
% 
% th_Clean = ThdKmeans(Clean,k);
% Clean(Clean>=th_Clean) = 1;
% Clean(Clean< th_Clean) = 0;
% 
% 
% %% obtain the smoothed image and the parameters
% [x,beta,lambda,mu] = SaT_Bayesian_Seg(Img);
% 
% %% show the result and SA value
% th = ThdKmeans(x,k);
% seg = SegResultShow(Img,x,th,k);
% [SA_value,new_seg] = new_SA(Clean,x,k,th);
% disp(SA_value);



%% load 4Ps data
load shape_multi_clean
Img=Img-min(Img(:));Img=Img/max(Img(:));
Clean = Img;
Img = double(rgb2gray(imread('given_new_2.png')));
Img=Img-min(Img(:));Img=Img/max(Img(:));
k=4;

%% obtain the smoothed image and the parameters
[x,beta,lambda,mu] = SaT_Bayesian_Seg(Img);

%% show the result and SA value
th = ThdKmeans(x,k);
seg = SegResultShow(Img,x,th,k);
SA_value = new_SA(Clean,x,k,th);
disp(SA_value);
