
%function to convert faceDet structure to a faceTracks structure
function faceTracks = dets2tracks(faceDet)
    faceTracks(1).bboxes = [];
    faceTracks(1).frameIDs = [];
    % convert all faceDet fields to faceTracks one 
    % by assigning and concatenates variables.
    for frameID = 1:numel(faceDet)
        if ~isempty(faceDet(frameID).trackIDs)
            for t = 1:numel(faceDet(frameID).trackIDs)
                trackID = faceDet(frameID).trackIDs(t);
                if trackID > numel(faceTracks)
                    faceTracks(trackID).bboxes = faceDet(frameID).bboxes(t,:);
                    faceTracks(trackID).frameIDs = frameID;
                else
                    faceTracks(trackID).bboxes = cat(1,faceTracks(trackID).bboxes,faceDet(frameID).bboxes(t,:));
                    faceTracks(trackID).frameIDs = cat(2,faceTracks(trackID).frameIDs,frameID);
                end
            end
        end
    end
end
