function [isGood, facebbox, tracker] = trackBBox(tracker,img,facebbox)
    isGood = false; % this flag is set at false by default
    tracker.oldpoints = tracker.points; % assign to old trackers the current ones prior to update
    
    [points, isFound] = step(tracker.tracker, img); % calls a step function
    % this in fact a Run System object algorithm function that takes
    % trackers and image 
    
    % creates the field points if points to track are found
    tracker.points = points(isFound, :);
    % kinda same with old points
    oldInliers = tracker.oldpoints(isFound, :);
            
    if size(tracker.points, 1) >= 3 % need at least 4 points
        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            oldInliers, tracker.points, 'similarity', 'MaxDistance', 5); % uses inbuilt function for that

        % Position bounding box at centre of points
        centre = mean(tracker.points); % compute center
        tempFacebbox = [centre(1)-facebbox(3)/2,centre(2)-facebbox(4)/2,facebbox(3),facebbox(4)]; % temporary box coordinates
        tempFacebbox = round(tempFacebbox); % rounding it to int pixel values

        %check if tempFacebbox very different, if so track is not good
        A1 = prod(facebbox(3:4)); %area of new bounding box
        A2 = prod(tempFacebbox(3:4)); %area of old bounding box
        % it comperes the product of the faceboxes
        %compute intersection area
        U = rectint(facebbox,tempFacebbox);
            
        %calculate a similarity score and threshold at 0.7
        % computes the similarity scoring to check for flag
        similarity = (U/A1 + U/A2)/2;
        if similarity > 0.7
            isGood = true;
        else
            isGood = false;
        end
        
        % the new facebbox eats the temporary generated one
        facebbox = tempFacebbox;
        % the oldpoints eats the visible current ones
        tracker.oldPoints = visiblePoints;
        % uses the in-built setPoints to defines points to plot
        setPoints(tracker.tracker, tracker.oldPoints);
    end
end
