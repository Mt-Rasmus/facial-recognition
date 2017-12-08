function [ bestID ] = tnm034( image )
    % Check if face in im exists in database

    % Load pre-calculated eigenfaces and corresponding matrices
    load databaseTEST;

    output = colorCorrection(image);    % Color correct
    face = detectFace(output);          % Detect face

    % Return if face could not get detected
    if isempty(face)
        id = -1;
        return
    end

    % Project detected face to eigenfaces space 
    [cols, rows] = size(face);
    dimensions = cols*rows;

    face = reshape(face, [dimensions, 1]);
    face = im2double(face);
    face = face-meanImage;
    
    face2 = reshape(face, [cols, rows]);
    figure
    imshow(face2, [])
    title('Candidate face with subtracted mean face')
    
    [w, h] = size(weights);
    numOfFacesInDB = w;

    % Calculate face weights vector
    for i = 1:numOfFacesInDB
        w =  face' * eigenVecLarge(:,i);
        faceWeights(i) = w;
    end    
        
    % Find the shortest distance weight vector
    %distance = abs(sum(faceWeights-weights, 2));
    for j = 1:numOfFacesInDB
        s = norm(faceWeights' - weights(:,j));
        distance(j) = s;
    end
    
    % Sorted weight vector (decreasing)
    [weights1, index1] = sort(distance)
    %dist = distance
    %bestID = find(distance == min(distance))
    %bestWeight = min(distance)
    %bestID = index(1);
    %bestWeight = weights(1);
    
 
end

