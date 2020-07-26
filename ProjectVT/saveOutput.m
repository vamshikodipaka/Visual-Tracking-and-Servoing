
%function to save the tracks
function saveOutput(outFilename,faceDet,faceTracks,trackers,maxFrames,frameID,stepSize)
    if frameID == maxFrames || mod(frameID,stepSize)==0
        save(outFilename,'faceDet','faceTracks','frameID','trackers');
        % Save the track structure
    end
end
