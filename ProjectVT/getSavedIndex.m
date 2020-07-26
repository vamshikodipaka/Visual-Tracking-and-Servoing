%function to return start index for tracking
function [index,trackers] = getSavedIndex(outFilename)
    if ~exist(outFilename,'file') % this is in the case ther is no already existing output from file 
        % by default, since it is the beginning all values are set to null
        index = 1;
        trackers(1).maxID = 0;
        trackers(1).numActive = 0;
    else
        % index is shifted by 1 due to matlab properties
        % loads the existing video and processes it (counts the number of frames) 
        data = load(outFilename);
        index = data.frameID + 1; 
        % append to trackers the field data.trackers
        trackers = data.trackers;
    end
end

% trackers has the following fields : maxID and numActive
% it takes the tracker field from data if already existing in it
