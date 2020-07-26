
%this function updates the faceDet and faceTracks structure with a new
%bounding box
function [faceDet,faceTracks] = updateFace(faceDet,faceTracks,facebbox,trackID,frameID)

% if faceDet is not empty
    if ~isempty(faceDet)
        if numel(faceDet)<frameID % add new face and frame
            % the faceDet (depending on the frameID) sees its field being
            % updated (they are appended in the function)
            
            % this is when the number of elements in faceDet is smaller
            % than frameID
            faceDet(frameID).trackIDs = trackID;
            faceDet(frameID).bboxes = facebbox;
            faceDet(frameID).landmarks = [];
        else %append face to current frame
            % uses the cat function concatenate new faces detections
            % here it appends something to already exoisting fields instead
            % of creating ones
            faceDet(frameID).trackIDs = cat(2,faceDet(end).trackIDs,trackID);
            faceDet(frameID).bboxes = cat(1,faceDet(end).bboxes,facebbox);
            faceDet(frameID).landmarks = [];
        end
    else
        % the faceDet (depending on the frameID) sees its field being
        % updated (they are appended in the function)    
        % the same is done there as the faceDet is empty
        faceDet(frameID).trackIDs = trackID;
        faceDet(frameID).bboxes = facebbox;
        faceDet(frameID).landmarks = [];
    end

end