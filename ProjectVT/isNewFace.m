%check if the current bounding box is a new detection
function [newface,matchingFaceID] = isNewFace(faceDet,facebbox,frameID)

% flag like in trackBBox (drawn to false by default)
    newface = false;
    matchingFaceID = [];
    
    % calls true conditions for to get new case (roughly the same as seen
    % in trackBBox)
    if isempty(faceDet)
        newface = true;
    elseif numel(faceDet)<frameID
        newface = true;
    else
        %check overlap of facebbox with bounding boxes present in faceDet
        numBBoxes = size(faceDet(frameID).bboxes,1);
        A1 = prod(facebbox(3:4)); %area of new bounding box
        for i = 1:numBBoxes
            A2 = prod(faceDet(frameID).bboxes(i,3:4)); %area of old bounding box
            %compute intersection area
            U = rectint(facebbox,faceDet(frameID).bboxes(i,:)); % rectangle intersection area
            
            %calculate a similarity score and threshold at 0.9
            similarity = (U/A1 + U/A2)/2;
            if similarity > 0.6 % Here the similarity is drawn at 0.6 instead of 0.7 in trackBBox
                newface = false;
                matchingFaceID = i; % reassociate the detection ID to its corresponding bbox number
                break;
            else
                newface = true; % Here if the similarity is under this threshold, then the face detcted is different form the others
            end
        end
    end
end
