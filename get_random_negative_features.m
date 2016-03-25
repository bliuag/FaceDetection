% Starter code prepared by James Hays for CS 143, Brown University
% This function should return negative training examples (non-faces) from
% any images in 'non_face_scn_path'. Images should be converted to
% grayscale, because the positive training data is only available in
% grayscale. For best performance, you should sample random negative
% examples at multiple scales.

function features_neg = get_random_negative_features(non_face_scn_path, feature_params, num_samples)
% 'non_face_scn_path' is a string. This directory contains many images
%   which have no faces in them.
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
% 'num_samples' is the number of random negatives to be mined, it's not
%   important for the function to find exactly 'num_samples' non-face
%   features, e.g. you might try to sample some number from each image, but
%   some images might be too small to find enough.

% 'features_neg' is N by D matrix where N is the number of non-faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
num_images = length(image_files);
num_cells= feature_params.template_size / feature_params.hog_cell_size;
num_orientations=9;
D=(num_cells)^2 * 4 * num_orientations;
features_neg=rand(num_samples,D);
avr=int32(num_samples/num_images);
for i=1:num_images
    file=fullfile(non_face_scn_path, image_files(i).name);
    Im=imread(file);
    if(size(Im,3) > 1)
        Im = rgb2gray(Im);
    end
    Im = single(Im)/255;
    [X,Y,~]=size(Im);
    HOG=vl_hog(single(Im),feature_params.hog_cell_size,'variant','dalaltriggs','numOrientations',num_orientations);
    for j=1:avr
        x=int32(rand*(X-feature_params.template_size));
        y=int32(rand*(Y-feature_params.template_size));
        %if(x>X-feature_params.template_size)
        %    x=X-feature_params.template_size;
        %end
        %if(y>Y-feature_params.template_size)
        %    y=Y-feature_params.template_size;
        %end
        hog=HOG((x/feature_params.hog_cell_size+1):(x/feature_params.hog_cell_size+num_cells),...
            (y/feature_params.hog_cell_size+1):(y/feature_params.hog_cell_size+num_cells),:);
        temp1=reshape(hog,[num_cells^2,num_orientations*4]);
        temp2=transpose(temp1);
        features_neg((i-1)*avr+j,:)=reshape(temp2,[D,1]); 
    %for j=1:num_cells
    %    for k=1:num_cells
    %        last=((j-1)*num_cells+k-1)*num_orientations*4;
    %        curr=((j-1)*num_cells+k)*num_orientations*4;
    %        features_neg(i,(last+1):curr)=HOG(j,k,:);
    %    end 
    %end           
    end
end
file=fullfile(non_face_scn_path, image_files(1).name);
Im=imread(file);
[X,Y]=size(Im);
HOG=vl_hog(single(Im),feature_params.hog_cell_size,'variant','dalaltriggs','numOrientations',num_orientations);
for j=1:(num_samples-avr*num_images)
    x=int32(rand*(X-feature_params.template_size+1));
    y=int32(rand*(Y-feature_params.template_size+1));
    if(x>X-feature_params.template_size)
        x=X-feature_params.template_size;
    end
    if(y>Y-feature_params.template_size)
        y=Y-feature_params.template_size;
    end
   hog=HOG(((x-1)/feature_params.hog_cell_size+1):((x-1)/feature_params.hog_cell_size+num_cells),...
            ((y-1)/feature_params.hog_cell_size+1):((y-1)/feature_params.hog_cell_size+num_cells),:);
    temp1=reshape(hog,[num_cells^2,num_orientations*4]);
    temp2=transpose(temp1);
    features_neg(num_images*avr+j,:)=reshape(temp2,[D,1]); 
%for j=1:num_cells
%    for k=1:num_cells
%        last=((j-1)*num_cells+k-1)*num_orientations*4;
%        curr=((j-1)*num_cells+k)*num_orientations*4;
%        features_neg(i,(last+1):curr)=HOG(j,k,:);
%    end 
%end           
end


% placeholder to be deleted
%features_neg = rand(100, (feature_params.template_size / feature_params.hog_cell_size)^2 * 36);