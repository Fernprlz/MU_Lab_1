%Compute and visualize the motion vectors of a sequence
% Syntax: me_block_based(video_name,finit,fend,step,save_output)
%   Inputs:
%     video_name : name of the video
%     finit: initial frame index
%     fend: final frame index
%     step: temporal gap between frames for estimation  
%     save_output: if 1, the outputs frames are saved in the dir outputs
%   Example:
%       me_block_based('coastguard',1,300,1,0)

function me_block_based(video_pattern,finit,fend,step,save_output)

%Parameters

%%%%%%%%%%%%%%Block-based%%%%%%%%%%%%%%
%  patchCC    - Block around each pixel to compute the distance between blocks
%  searchCC   - Size of the search area
%  sigmaCC    - Standard deviation of a Gaussian prefiltering of the images
%  lambda     - Regularization of the cost function to force small vectors: 
%                C = mesure + lambda * ||u||, where the measure is SSD, SAD
%                or 1-NCC.
%  measure      - Measure: Used error measure => 1: SSD, 2: SAD, 3: NCC
%                (1-NCC so it is a distance)
patchCC=15;
searchCC=3;
sigmaCC=1.0;
lambda=1;
medida=1;

%%%%%%%%%%%%%% PROGRAM CODE %%%%%%%%%%%%%%%%%%%%
close all;
scale=1; 
addpath('./toolbox/images');
addpath('./toolbox/matlab');
addpath('./toolbox/filters');
addpath('./toolbox/external');
addpath('./toolbox/ransac');
addpath('./toolbox/evaluation');

videoDir=sprintf('./outputs/%s/',video_pattern);
mkdir(videoDir);
cont=0;

for i=finit:step:fend-1
    cont=cont+1;
    fprintf('.');
    if(rem(i,25)==0)
        fprintf('\n');
    end
    path1=sprintf('./videos/%s/%s%03d.jpg',video_pattern,video_pattern,i);
    path2=sprintf('./videos/%s/%s%03d.jpg',video_pattern,video_pattern,i+step);
    im1=imread(path1);
    [H W c]=size(im1);
    im2=imread(path2);
    im1=imresize(im1,scale);
    im2=imresize(im2,scale);
    gim1=double(rgb2gray(im1));
    gim2=double(rgb2gray(im2));
    
    [Vx,Vy] = optFlowBB( gim1, gim2, patchCC, searchCC, sigmaCC, lambda, 0, medida );
    Vx=sign(Vx).*min(abs(Vx),5);
    Vy=sign(Vy).*min(abs(Vy),5);
    Vx(abs(Vx)<0.1)=0;
    Vy(abs(Vy)<0.1)=0;

    %%%%%%%%%%%%%%%%%%%%% VISUALIZATION %%%%%%%%%%%%%%%%%%%%%
    bs=16;
    bx=W/bs;
    by=H/bs;
    sVx=imresize(Vx,[by bx]);
    sVy=imresize(Vy,[by bx]);
    
    f = figure(1);
    imshow(im2,'Border', 'tight');
    hold('on');
    quiver(bs/2:bs:W,bs/2:bs:H,sVx, sVy,1,'b-');
    hold off;
    if(save_output)
        output=sprintf('outputs/%s/%s%03d.jpg',video_pattern,video_pattern,cont);
        [H,W,D] = size(im2);
        im=zbuffer_cdata(f);
        imwrite(im,output);
    end
end

function cdata = zbuffer_cdata(hfig)
% Get CDATA from hardcopy using zbuffer

% Need to have PaperPositionMode be auto
orig_mode = get(hfig, 'PaperPositionMode');
set(hfig, 'PaperPositionMode', 'auto');

cdata = print(hfig, '-RGBImage');

% Restore figure to original state
set(hfig, 'PaperPositionMode', orig_mode); % end