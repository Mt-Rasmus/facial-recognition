function [ ] = createDatabase( images_folder )

files = dir(fullfile(images_folder, '*.jpg'));
files = {files.name}';
numFacesNotDetected = 0;

% Loop image directory and detect each face, store in faces_db matrix
for i=1:numel(files)
    fname = fullfile(images_folder, files{i});
    disp(['Loading ', num2str(fname), '..'])
    img = imread(fname);
    output = colorCorrection(img); % Color correct
    result = detectFace(output);   % Detect face
    if( isempty(result) )
        numFacesNotDetected = numFacesNotDetected - 1;
        continue
    else
        faces_db(:,:,i+numFacesNotDetected) = result;
    end
end

numberofimages = numel(files);
[aa,bb,numDetectedFaces] = size(faces_db);
disp(['Loaded ', num2str(numDetectedFaces), ' of ', num2str(numberofimages), ' faces successfully.'])

[X,Y] = size(faces_db(:,:,1));
n = X*Y;

% Reshape images to vectors
faces_db = reshape(faces_db, [n, numDetectedFaces]);

% Run PCA algorithm
x = im2double(faces_db);
meanImage = mean(x,2);                 % Find average face vector
A = bsxfun(@minus, x, meanImage);      % Subtract the mean for each vector in faces_db
C = transpose(A) * A;                  % Covariance matrix (MxM) 
[eigVec, eigVal] = eig(C);             % Eigenvectors and eigenvalues in smaller dimension
eigenVecLarge = A * eigVec;            % Eigenvectors in bigger dimension (n x n)

% Reshaping the n-dim eigenvectors into matrices (eigenfaces)
eigenfaces = [];
for k = 1:numDetectedFaces
    c = eigenVecLarge(:,k);
    eigenfaces{k} = reshape(c,X,Y);
    eigenfaces{k} = eigenfaces{k}./norm(eigenfaces{k});    
end

% Normalize eigenvectors
eigenVecLarge = eigenVecLarge./norm(eigenVecLarge);

% Extract eigenvalues and sort in descending order
x = diag(eigVal);
[xc,xci] = sort(x,'descend'); 
[xciR, xciC] = size(xci);

% Display eigenfaces
for e = 1:xciR
    figure
    imshow(eigenfaces{e}, [])
end

% Calculate weights vector for each eigenface
weights = zeros(numDetectedFaces, numDetectedFaces);
for a = 1:numDetectedFaces
    for j=1:numDetectedFaces
        w =  eigenVecLarge(:,j)' * A(:,a);
        weights(j,a) = w;
    end
end

% Saving weight matrix, eigenvectors and mean image to database
save('databaseFINAL.mat', 'eigenVecLarge', 'weights', 'meanImage');

end

