clear all;
% Set up VLfeat Toolbox here.

run('./vlfeat-0.9.21/toolbox/vl_setup');

% Read in the images that you want to stitch together.
% Better to transform RGB images into gray scale images. vl_sift requires 'single' type.
disp('reading img');

image1=imread('./image/2_1.jpeg');
image2=imread('./image/2_2.jpeg');
image3=imread('./image/2_3.jpeg');
% Obtaininig SIFT Correspondences by VLfeat tool box.
% Btw, what's the meaning of the outputs?
% keep track of feature points coordinates.
disp('Obtaininig SIFT Correspondences');
image11=single(rgb2gray(image1));
image22=single(rgb2gray(image2));
image33=single(rgb2gray(image3));




[f1,d1]=vl_sift(image11);
[f2,d2]=vl_sift(image22);
[f3,d3]=vl_sift(image33);

% figure(1);
% 
% imshow(rgb2gray(image1));
% hold on;
% h1 = vl_plotsiftdescriptor(d1,f1()) ;
% 
% figure(2);
% imshow(rgb2gray(image2));
% hold on;
% h2 = vl_plotsiftdescriptor(d2,f2) ;


%[f,d],f(1,2)->disk_center, f(3)->scale,f(4)_>orientation



% Here you should matching the SIFT feature between adjacent images by L2 distance. 
% Please fill the function match.m
disp('matching keypoints');

matches1=match(d1,d2);
matches2=match(d2,d3);
% matches=vl_ubcmatch(d1, d2)' ;

% subplot(1,2,1)
% imshow(rgb2gray(image1));
% hold on;
% h1 = vl_plotframe(f1(:,matches(:,1)')) ;
% set(h1,'color','y','linewidth',3) ;
% % h1 = vl_plotsiftdescriptor(d1(:,matches(:,1)'),f1(:,matches(:,1)')) ;
% 
% subplot(1,2,2)
% imshow(rgb2gray(image2));
% hold on;
% h2 = vl_plotframe(f2(:,matches(:,2)')) ;
% set(h2,'color','y','linewidth',3) ;

% h1 = vl_plotsiftdescriptor(d2(:,matches(:,2)'),f2(:,matches(:,2)')) ;

% Estimating Homography using RANSAC
% Please fill the function RANSACFit.m
disp('RANSACing');

H1 = RANSACFit(f1(1:2,:)', f2(1:2,:)', matches1, 2000, 3, 0.05*size(image1,1),ceil(0.3 * size(matches1, 1)));
H2 = RANSACFit(f2(1:2,:)', f3(1:2,:)', matches2, 2000, 3, 0.05*size(image2,1),ceil(0.3 * size(matches2, 1)));



%% Creating the panorama
% use cell() to store correspondent images and transformations
disp('Generating panorama pictures...');
Pano = MultipleStitch( {image1,image2,image3}, {H1,H2}, 'pano.jpg' );

% In plotMatches.m you can visualize the matching results after you feed proper data stream. Feel free to create your own visualization.
