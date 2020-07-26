
%function to visualise the output
function h_img = vis(img,faceDet,trackers,frameID,h_img)
    if isempty(h_img) %create figure and image pane
        figure
        h_img = imagesc(img); axis image;
    end
    
    % Bunch of visual parameters to include
    if numel(faceDet)>=frameID
        for b = 1:size(faceDet(frameID).bboxes,1)
            img = insertObjectAnnotation(img,'rectangle',faceDet(frameID).bboxes(b,:),sprintf('track: %d',faceDet(frameID).trackIDs(b)));
        end
        for b = 1:size(faceDet(frameID).bboxes,1)
            trackerID = find(cat(1,trackers(:).trackID)==faceDet(frameID).trackIDs(b));
            if ~isempty(trackerID)
                plotPoints = cat(2,trackers(trackerID).points(:,1:2),2*ones(size(trackers(trackerID).points,1),1));
                img = insertObjectAnnotation(img,'circle',plotPoints,' ','TextBoxOpacity',0,'Color','white');
            end
        end

    end
    set(h_img,'cdata',img);
    drawnow  
end
