%track all faces to the next frame (destroys trackers when neccessary)
function [faceDet,faceTracks,trackers] = track(faceDet,faceTracks,trackers,img,frameID)
    
    % Jumps the function if the tracks are empty
    if trackers(1).maxID == 0 || trackers(1).numActive == 0 
        return
    else
        
         
        % for each tracker track bbox to new image
        for i = 1:numel(faceDet(frameID-1).trackIDs) % number of element array
            trackerID = find(faceDet(frameID-1).trackIDs(i)==cat(1,trackers(:).trackID));  %find tracker associated with this face
            if isempty(trackerID); continue; end %if tracker destroyed then skip
            [isGood,facebbox,tracker] = trackBBox(trackers(trackerID),img,faceDet(frameID-1).bboxes(i,:)); %track the face forward in time
            % lets go to throw a look at trackBBox
            
            %update faceDet and faceTracks with new data
            if isGood % if ok flag is emitted
                % then update faces using a custom function
                [faceDet,faceTracks] = updateFace(faceDet,faceTracks,facebbox,trackers(trackerID).trackID,frameID);
                % have commented in it too
                %update the tracker
                trackers(trackerID).points = tracker.oldPoints; % the previously created elements in trackBBox 
                trackers(trackerID).tracker = tracker.tracker; % are thrown there 
            else
                if numel(faceDet)<frameID % numb of elem in faceDet array less than frame ID
                    faceDet(frameID).bboxes = []; % otherwise the bboxes field is empty
                end
                %we need to remove this tracker and let the system
                %initialise a new one when it gets a good face detection
                % since the flag is not valid (mean too much differences)
                trackers(1).numActive = max(0,trackers(1).numActive - 1);
                release(trackers(trackerID).tracker); % releases the fields
                

                if trackerID == 1
                    if numel(trackers)==1
                        % Empties tracker at index = 1, then the rest will follows
                        % after (for two fields)
                        trackers(trackerID).points = [];
                        trackers(trackerID).tracker = [];
                    else
                        % the fields are renewed in the case ID ~= 1
                        % and replaced by thoses at ID == 1
                        maxID = trackers(1).maxID;
                        numActive = trackers(1).numActive;
                        trackers(trackerID) = [];
                        trackers(trackerID).maxID = maxID;
                        trackers(trackerID).numActive = numActive;
                    end
                else % clean all directly to renew
                    trackers(trackerID) = [];
                end
            end
        end
    end
end
