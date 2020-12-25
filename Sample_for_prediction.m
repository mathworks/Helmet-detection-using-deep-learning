%% Detect objects in a video
%% initialize
clear; close all; clc; rng('default');
load gTruth
%% load trained yolo v2 detector
load('trainedYOLOv2Detector');

%% Define video file reader and player
videoFReader = vision.VideoFileReader(gTruth.DataSource.Source);
videoPlayer = vision.DeployableVideoPlayer;

numFrames = 10;
cntFrames = 1;
% Setup the color map
cmaps(1,:)=[0 255 255]; 
cmaps(2,:)=[255 0 0];
labelpre =categorical("Helmet");
while ~isDone(videoFReader)
    I = videoFReader();
    % detect objects in a frame
    [bboxes, scores, labels] = detect(detector, I);
    [~,ind] = ismember(labels,gTruth.LabelDefinitions.Name);
    % show the result
    if isempty(labels)  
        detectedImg = I;
    elseif ~(labelpre == labels(1))
        detectedImg = I;
        labelpre = labels(1); 
    else
        detectedImg = insertObjectAnnotation(I, 'Rectangle', bboxes(1,:), cellstr(labels(1)),...
            'Color',im2single(cmaps(ind(1),:)),'FontSize',20,'TextBoxOpacity',1);
        labelpre = labels(1); 
    end
    videoPlayer(detectedImg);
    cntFrames = cntFrames + 1;
end
%% 
% _Copyright 2019 The MathWorks, Inc._