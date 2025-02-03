%% MMGR-WT achieves superpixel segmentation using adaptive and multiscale morphological gradient reconstruction
function [L_seg,i,diff] = w_MMGR_WT(f,se_start) 
% L_seg is label image with line;
% i is the maximal iterations;
% diff is the difference between the previous result and current gradient
max_itr = 50;
min_impro = 0.0001;
%% step 1: gaussian filtering
sigma = 1.0;
gausFilter = fspecial('gaussian',[5 5],sigma);
g = imfilter(f,gausFilter,'replicate');
%% step 2: compute gradient image
gg = fcm_algo.colorspace('Lab<-RGB',g); 
a1 = fcm_algo.sgrad_edge(fcm_algo.normalized(gg(:,:,1))).^2;
b1 = fcm_algo.sgrad_edge(abs(fcm_algo.normalized(gg(:,:,2)))).^2;
c1 = fcm_algo.sgrad_edge(fcm_algo.normalized(gg(:,:,3))).^2;
ngrad_f1 = sqrt(a1+b1+c1); 
%% step 3: MMGR
f_g = zeros(size(f,1),size(f,2));
diff = zeros(max_itr,1);
for i = 1:max_itr
    gx = fcm_algo.w_recons_CO(ngrad_f1,strel('disk',i+se_start-1)); 
    f_g2 = max(f_g,double(gx));
    f_g1 = f_g;
    f_g = f_g2;
    diff(i) = mean2(abs(f_g1 - f_g2));
	if i > 1
		if diff(i) < min_impro
            break
        end
    end  
end
%% step 4: watershed
L_seg = watershed(f_g);
