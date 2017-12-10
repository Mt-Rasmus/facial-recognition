function [ id, message ] = tnm034( image, threshold )
    % Check if face in im exists in database
    % bestID > 0  =>  face exists in database. ID corresponding to the
    %                 image recognized is returned
    % bestID = 0  =>  face does not exists in database
    % bestID = -1 =>  face could not get detected

    % Load pre-calculated eigenfaces and corresponding matrices
    load databaseFINAL;
    threshold = 4.0;

    output = colorCorrection(image);    % Color correct
    face = detectFace(output);          % Detect face

    % Return if face could not get detected
    if isempty(face)
        id = -1;
        message = 'The face could not get detected!';
        return
    end

    % Project detected face to eigenfaces space 
    [cols, rows] = size(face);
    dimensions = cols*rows;

    face = reshape(face, [dimensions, 1]);
    face = im2double(face);
    face = face-meanImage;
    
    %face2 = reshape(face, [cols, rows]);
    %figure
    %imshow(face2, [])
    %title('Candidate face with subtracted mean face')
    
    [w1, h] = size(weights);
    numOfFacesInDB = w1;

    % Calculate face weights vector
    for i = 1:numOfFacesInDB
        w = eigenVecLarge(:,i)' * face;
        faceWeights(i) = w;
    end    
        
    % Find the shortest distance weight vector
    %distance = abs(sum(faceWeights-weights, 2));
    for j = 1:numOfFacesInDB
        s = norm(faceWeights' - weights(:,j));
        distance(j) = s;
    end
    
    % Sorted weight vector (decreasing)
    [weights1, index1] = sort(distance);

    % Extract best id and weight 
    bestID = index1(1);
    bestWeight = weights1(1);   
        
    % Check if best weight found is less than the threshold
    if bestWeight <= threshold
        id = bestID;
        message = 'Face exists in the database!';
        return
    else
        id = 0;
        message = 'Face does not exist in the database!';
        return
    end
 
end

