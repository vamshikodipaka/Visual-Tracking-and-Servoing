
function bboxes = detectFaces(faceDetector,img)
    bboxes = step(faceDetector, img);   
    % calls a step function
    % this in fact a Run System object algorithm function that takes the
    % image as well as the face detector parameters
    % to computes bounding boxes associated point coordinates instead of
    % simple points coordinates (THE  YELLOW FRAME !)
end
