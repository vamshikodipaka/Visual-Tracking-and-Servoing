function [face_Det,face_Tracks] = trackFaces( videoname,fitModel,outFile,visualise )
%TRACKFACES tracks all faces in a video
% 
    % initializes the face trakers array
    face_Tracks = [];
    % same for face detectors (centroids ?)
    face_Det = [];
    h_img = []; %for visualisation only (image handle)

    %load video object
    vidobj = VideoReader(videoname);
    
    %setup face detector -- Viola-Jones
    fDetector = vision.CascadeObjectDetector(); % -- Cannot be changed (vision toolb algo)
    fDetector.MaxSize = round(fitModel.maxsize*fitModel.facedetect.imscale);% field containing max possible size
    fDetector.MinSize = round(fitModel.minsize*fitModel.facedetect.imscale);%same with minimal size
    fDetector.MergeThreshold = fitModel.facedetect.sensitivity; % this line attach the sensitivity factor for 
    % further detections.
    
    %setup trackers
    trackers(1).maxID = 0; % this is a dynamic structure with two fields
    trackers(1).numActive = 0; %same but second field
    
    %get starting frame index based on current saved output and also
    %tracker info
    [startIndex,trackers] = getSavedIndex(outFile); % calls the function getsavedindex 
    % to start indexing tracks and/or prepare them fo be injectrd into the
    % tracking algorithm. Also creates default track values when no outFile
    
    %load the saved tracks
    % this piece is relying on the previous function
    if exist(outFile,'file');
        load(outFile);
    end
    
    %loop over frames and track (startindex being the departure)
    for i = startIndex:vidobj.NumberOfFrames
        % If remainder of the division of i and 1000 is null
        % then print the number of active trackers 
        if mod(i,1000)==0
            fprintf('frame %d of %d, number of active trackers: %d\n',i,vidobj.NumberOfFrames,trackers(1).numActive);
        end
        
        % eats one image
        image = read(vidobj,i);
        
        %track all previous faces to this frame
        [face_Det,face_Tracks,trackers] = track(face_Det,face_Tracks,trackers,image,i);
        % Once the trackers are updated 
        % the programs move face detection with bounding boxes
        
        %detect all faces
        facebboxes = detectFaces(fDetector,image);
        
        % when done, it mpoves to new faces detection
        % !!!!!!! THIS FUNCTION IS IN THE SAME FOLDER !!!!!!
        %start new tracks if we detect new faces
        [face_Det,face_Tracks,trackers] = addNewFaces(face_Det, face_Tracks,trackers,facebboxes,image,i);
        
        %save output every 1000 frames
        saveOutput(outFile,face_Det,face_Tracks,trackers,vidobj.NumberOfFrames,i,1000); 
        
        %visualise
        if visualise
            h_img = vis(image,face_Det,trackers,i,h_img); %Observation of the stuff
        end
    end
    
    %produce tracking structure from faceDet
    if isempty(face_Tracks)
        face_Tracks = dets2tracks(face_Det); % to comment
        frameID = vidobj.NumberOfFrames;
        %save(outFile,'faceDet','frameID','faceTracks'); % This line as
        %been commented as it was giving en error in the final script after
        %2 iterations
    end
end

%track all faces to the next frame (destroys trackers when neccessary)
function [face_Det,face_Tracks,trackers] = track(face_Det,face_Tracks,trackers,img,frameID)
    if trackers(1).maxID == 0 || trackers(1).numActive == 0 
        return
    else
        %for each tracker track bbox to new image
        for i = 1:numel(face_Det(frameID-1).trackIDs)
            trackerID = find(face_Det(frameID-1).trackIDs(i)==cat(1,trackers(:).trackID));  %find tracker associated with this face
            if isempty(trackerID); continue; end %if tracker destroyed then skip
            [isGood,facebbox,tracker] = trackBBox(trackers(trackerID),img,face_Det(frameID-1).bboxes(i,:)); %track the face forward in time
            
            %update faceDet and faceTracks with new data
            if isGood
                [face_Det,face_Tracks] = updateFace(face_Det,face_Tracks,facebbox,trackers(trackerID).trackID,frameID);
                %update the tracker
                trackers(trackerID).points = tracker.oldPoints;
                trackers(trackerID).tracker = tracker.tracker;
            else
                if numel(face_Det)<frameID
                    face_Det(frameID).bboxes = [];
                end
                %we need to remove this tracker and let the system
                %initialise a new one when it gets a good face detection
                trackers(1).numActive = max(0,trackers(1).numActive - 1);
                release(trackers(trackerID).tracker);
                
                if trackerID == 1
                    if numel(trackers)==1
                        trackers(trackerID).points = [];
                        trackers(trackerID).tracker = [];
                    else
                        maxID = trackers(1).maxID;
                        numActive = trackers(1).numActive;
                        trackers(trackerID) = [];
                        trackers(trackerID).maxID = maxID;
                        trackers(trackerID).numActive = numActive;
                    end
                else
                    trackers(trackerID) = [];
                end
            end
        end
    end
end



function [faceDet,faceTracks,trackers] = addNewFaces(faceDet, faceTracks,trackers,facebboxes,img,frameID)
    %for each box see if it is a new face
    if ~isempty(facebboxes)
        % get the number of detections in the case when facebboxes is
        % not empty (there is at least one face bounding box there)
        numDets = size(facebboxes,1);
        for i = 1:numDets
            % if the faceDetection is there (at least one) then use the
            % following code
            if ~isempty(faceDet)
                [isNew,matchingFaceID] = isNewFace(faceDet,facebboxes(i,:),frameID); % the function is very similar
                % to <<<< trackBBox >>>>>
                if isNew
                    [faceDet,faceTracks,trackers] = addFace(faceDet,faceTracks,trackers,facebboxes(i,:),img,frameID);
                    % commented
                else
                    %update tracker with points in detected face
                    if ~isempty(matchingFaceID)
                        trackerID = find(cat(1,trackers(:).trackID)==faceDet(frameID).trackIDs(matchingFaceID));
                        % Tracker_ID = the IDs are reassigned once again
                        % there
                        % if no tracks then
                        if ~isempty(trackerID)
                            %re-initialise the tracker
                            trackers(trackerID).points = cat(1,trackers(trackerID).points,getFeaturePoints(img,facebboxes(i,:)));

                            %randomly sample at most 30 points
                            % this sampling is done in an already defined
                            % bounding box. these are the new points to track
                            Ridx = randperm(size(trackers(trackerID).points,1));
                            trackers(trackerID).points = trackers(trackerID).points(Ridx(1:min(numel(Ridx),30)),:);
                            setPoints(trackers(trackerID).tracker, trackers(trackerID).points);
                        end
                    end
                end
            else
                % if detection is not not empty, then faces are added to
                % existing ones
                [faceDet,faceTracks,trackers] = addFace(faceDet,faceTracks,trackers,facebboxes(i,:),img,frameID);
            end
        end
    end
end

%this function adds a new face and initialises a new tracker
function [faceDet,faceTracks,trackers] = addFace(faceDet,faceTracks,trackers,facebbox,img,frameID)
    numActiveTrackers = trackers(1).numActive;
    
    %get features
    points = getFeaturePoints(img,facebbox);
    
    if ~isempty(points)
        %setup new tracker
        trackerID = numActiveTrackers+1;
        trackers(1).maxID = trackers(1).maxID + 1; %maxID stores the total number of trackers so far
        trackers(1).numActive = trackers(1).numActive + 1;
        trackers(trackerID).trackID = trackers(1).maxID;
        trackers(trackerID).tracker = vision.PointTracker('MaxBidirectionalError', 2);

        %get features to track
        trackers(trackerID).points = points;

        %initialise the tracker
        initialize(trackers(trackerID).tracker,trackers(trackerID).points,img);

        %update the faceDet and faceTracks structure
        [faceDet,faceTracks] = updateFace(faceDet,faceTracks,facebbox,trackers(trackerID).trackID,frameID);
    end
end


%function to convert a bounding box to points (unused)
function points = bbox2point(bbox)
    points = zeros(4,2);
    points(1,:) = bbox(1:2);
    points(2,:) = points(1,:) + [0 bbox(3)];
    points(3,:) = points(2,:) + [bbox(4) 0];
    points(4,:) = points(1,:) + [bbox(4) 0];
end

%function to convert points to a bounding box (unused)
function bbox = point2bbox(points)
    bbox = zeros(1,4);
    bbox(1) = min(points(:,1));
    bbox(2) = min(points(:,2));
    bbox(3) = max(points(:,1))-bbox(1);
    bbox(4) = max(points(:,2))-bbox(2);
end
