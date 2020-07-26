
%function to return feature points given bounding box and image
function locations = getFeaturePoints(img,bbox)
%     points = detectMinEigenFeatures(rgb2gray(img), 'ROI', bbox);
    points = detectBRISKFeatures(rgb2gray(img), 'ROI', bbox,'MinContrast',0.001);
    locations = points.Location;
    if ~isempty(locations)

        %get cluster close to centre of points
        centre = mean(locations);
        dist = sqrt(sum(bsxfun(@minus,locations,centre).^2,2));
        i = 1;
        idrem = ones(1,size(locations,1));
        while sum(idrem)>=size(locations,1)
            idrem = dist>15*i;
            i = i + 0.5;
        end
        locations(idrem,:) = [];
    end
end
