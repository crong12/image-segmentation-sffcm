%% Image segmentation function using superpixel-based fast fuzzy c-means clustering

% The code for this function (and the other necessary functions to run this
% one) was adapted heavily from Tao Lei and Xiaohong Jia, written in 2018, 
% for their paper "Superpixel-Based Fast Fuzzy C-Means Clustering for
% Color Image Segmentation", published in 2019. While most of the code is 
% theirs, some modification was made to ensure compatibility of the code 
% for this coursework. 

%% 
function [seg] = segment_image(I, cluster, se)
% input: RGB image with values from [0,1]
% output: grayscale image with values from [0,255]

% generate superpixels
L1 = fcm_algo.w_MMGR_WT(I,se);
L2 = imdilate(L1,strel('square',2));
[~,~,Num,centerLab] = fcm_algo.Label_image(I,L2);

% fast FCM
Label = fcm_algo.w_super_fcm(L2,centerLab,Num,cluster);
Lseg = fcm_algo.Label_image(I,Label);

% convert to grayscale and scale image to [0,255]
segg = rgb2gray(Lseg);
seg = segg*255;        % necessary to mitigate rounding function in the compare_segmentations function

%% 
% References: 
% Tao Lei, Xiaohong Jia, Yanning Zhang, Shigang Liu, Hongying Meng and Asoke K. Nandi, 
% Superpixel-Based Fast Fuzzy C-Means Clustering for Color Image
% Segmentation, IEEE Transactions on Fuzzy Systems, vol. 27, no. 9, pp. 1753-1766, Sept. 2019.
% Accessed from: "http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8265186."