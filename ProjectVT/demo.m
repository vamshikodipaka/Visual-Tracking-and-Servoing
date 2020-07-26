clc
clear all
close all

%load example video
vidinp = 'demo.avi';
vidobj = VideoReader(vidinp);

%set tracking output file
trackFile = './demo_data/demo_tracks.mat';

%set some options, like max and min detection windows
model.maxsize = [250 250]; %max size of detected face
model.minsize = [70 70]; %min size of detected face
model.facedetect.imscale =1; %run at full resolution 
model.facedetect.sensitivity = 10; %lower numbers detect more faces


%track the video and visualise while tracking. Set visualise = false to
%turn off visualisation while tracking.
visualise = true;
% Set visualize flage as true
[faceDet,faceTracks] = trackFaces(vidinp,model,trackFile,visualise);


%visualise precomputed tracks
visualiseFaceTracking(vidinp,trackFile,1);



