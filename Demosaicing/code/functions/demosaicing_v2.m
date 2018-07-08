function output = demosaicing_v2(input,type)
% Code modified from CFA Interpolation Detection by Leszek Swirski (Nov 30,
% 2009), accessed on 07/05/2017
% The paper can be found here: 
% https://www.cl.cam.ac.uk/teaching/0910/R08/work/essay-ls426-cfadetection.pdf
% Types:
%   'neighbor' - nearest neighbor interpolation
%   'bilinear' - bilinear interpolation            
%   'smooth_hue' - smooth hue transition interpolation
%   'median' - median-filtered bilinear interpolation
%   'gradient' - gradient-based interpolation
% Input MUST be in double for code to run successfully


% Load image
S = input;
% Create CFA filter for each of the three colours in GBRG format
Rcfa = repmat([0 0;1 0],size(S,1)/2,size(S,2)/2);
Gcfa = repmat([1 0;0 1],size(S,1)/2,size(S,2)/2);
Bcfa = repmat([0 1;0 0],size(S,1)/2,size(S,2)/2);
% Split data into 'hat' variables
Rh = S.*double(Rcfa);
Gh = S.*double(Gcfa);
Bh = S.*double(Bcfa);

switch type
    case 'neighbor' % nearest neighbor interpolation
        R = Rh(floor([0:end-1]/2)*2+2,floor([0:end-1]/2)*2+1);
        G = zeros(size(Gh));
        G(floor([0:end-1]/2)*2+1,:) = Gh(floor([0:end-1]/2)*2+1,floor([0:end-1]/2)*2+1);
        G(floor([0:end-1]/2)*2+2,:) = Gh(floor([0:end-1]/2)*2+2,floor([0:end-1]/2)*2+2);
        B = Bh(floor([0:end-1]/2)*2+1,floor([0:end-1]/2)*2+2);
    case 'bilinear' % bilinear interpolation
        R = conv2(Rh,[1 2 1;2 4 2;1 2 1]/4,'same');
        G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same');
        B = conv2(Bh,[1 2 1;2 4 2;1 2 1]/4,'same');
    case 'smooth_hue' % smooth hue transition interpolation
        G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same') ;
        R = G.*conv2(Rh./G,[1 2 1;2 4 2;1 2 1]/4,'same') ;
        B = G.*conv2(Bh./G,[1 2 1;2 4 2;1 2 1]/4,'same') ;
    case 'median' % median-filtered bilinear interpolation
        R = conv2(Rh,[1 2 1;2 4 2;1 2 1]/4,'same') ;
        G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same') ;
        B = conv2(Bh,[1 2 1;2 4 2;1 2 1]/4,'same') ;
        Mrg = R-G;
        Mrb = R-B;
        Mgb = G-B;
        R = S+Mrg.*Gcfa+Mrb.*Bcfa ;
        G = S-Mrg.*Rcfa+Mgb.*Bcfa ;
        B = S-Mrb.*Rcfa-Mgb.*Gcfa ;
    case 'gradient' % gradient-based interpolation
        H = abs((S(:,[1 1 1:end-2])+S(:,[3:end end end]))/2-S);
        V = abs((S([1 1 1:end-2],:)+S([3:end end end],:))/2-S);
        G = Gh+(Rcfa+Bcfa).*((H<V).*((Gh(:,[1 1:end-1])+Gh(:,[2:end end]))/2)+(H>V).*((Gh([1 1:end-1],:)+Gh([2:end end],:))/2)+(H==V).*((Gh(:,[1 1:end-1])+Gh(:,[2:end end])+Gh([1 1:end-1],:)+Gh([2:end end],:))/4)) ;
        R = G+conv2(Rh-Rcfa.*G,[1 2 1;2 4 2;1 2 1]/4,'same');
        B = G+conv2(Bh-Bcfa.*G,[1 2 1;2 4 2;1 2 1]/4,'same');
end
%%
output(:,:,1) = R;output(:,:,2) = G; output(:,:,3) = B;
end
