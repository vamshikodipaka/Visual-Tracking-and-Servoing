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