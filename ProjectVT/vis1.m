function h_img = vis1(img,faceDet,frameID,h_img)
    if isempty(h_img) %create figure and image pane
        %figure
        h_img = imagesc(img); axis image;
    end
    
    if numel(faceDet)>=frameID
        for b = 1:size(faceDet(frameID).bboxes,1)
            img = insertObjectAnnotation(img,'rectangle',faceDet(frameID).bboxes(b,:),sprintf('track: %d',faceDet(frameID).trackIDs(b)));
        end
    end
    set(h_img,'cdata',img);
    drawnow
end