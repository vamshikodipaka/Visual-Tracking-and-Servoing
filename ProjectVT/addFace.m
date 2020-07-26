
%this function adds a new face and initialises a new tracker
function [faceDet,faceTracks,trackers] = addFace(faceDet,faceTracks,trackers,facebbox,img,frameID)
    numActiveTrackers = trackers(1).numActive; % get the number of active trackers from numActive field
    
    %get features
    points = getFeaturePoints(img,facebbox); % calls custom function to get features
    
    if ~isempty(points)
        %setup new tracker
        trackerID = numActiveTrackers+1; % reuse tracker detections  
        trackers(1).maxID = trackers(1).maxID + 1; %maxID stores the total number of trackers so far
        trackers(1).numActive = trackers(1).numActive + 1; % Adds a new tracker 
        trackers(trackerID).trackID = trackers(1).maxID; % upgrades the tracking array
        trackers(trackerID).tracker = vision.PointTracker('MaxBidirectionalError', 2); % vision
        % toolbox function used here to track points
        % This is the KLT core of the project !
        % THIS IS THE MOST IMPORTANT PART OF THE PROJECT
        % FOR TRACKERS Structure, THE FIELD .tracker CORRESPONDS TO OUR
        % KLT

        %get features to track
        trackers(trackerID).points = points; % feeds the features to track, then goes to the 
        % initialization of the tracker

        %initialise the tracker
        initialize(trackers(trackerID).tracker,trackers(trackerID).points,img);
        % Here it is a dependent function which is called once the
        % parameters are specified (or data thrown inside)

        %update the faceDet and faceTracks structure
        [faceDet,faceTracks] = updateFace(faceDet,faceTracks,facebbox,trackers(trackerID).trackID,frameID);
        % calls again the update face stuff (similar structure one again)
    end
end
