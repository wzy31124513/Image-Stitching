function [matches] = match(sift1, sift2)
%match - This function matches two buntches of SIFT features by seeking the nearest neighbor of each feature.
%Consulted material:
%[1] - http://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf
%in [1] it is recommended also to take into account the second nearest neighbour and ignore it if the distance is more than 0.8 between these two neighbours
% INPUT: 
% SIFT feature of the first image: sift1[128*n]
% SIFT feature of the second image: sift2[128*m]
% n may or may not equal to m
% OUTPUT:
% matches: M * 2 matrix, each row represents a match [index of p1, index of p2]


%
% Syntax: matches = match(sift1, sift2)
%
% 
n=size(sift1,2);
m=size(sift2,2);
matches=[];
  for i=1:n
      D1=repmat(sift1(:,i),1,m);
      distance=sqrt(sum((D1-sift2).^2));
      distance_sort=sort(distance);
      if distance_sort(1)<=0.8*distance_sort(2)
          j=find(distance==distance_sort(1),1);
          matches=[matches;[i j]];
      end
  end
  
  
end