function [ ] = createDatabase( images_folder )

files = dir(fullfile(images_folder, '*.jpg'));
files = {files.name}';
numDetectedFaces = 0;

for i=1:numel(files)
    fname = fullfile(images_folder, files{i});
    img = imread(fname);
    output = colorCorrection(img); % Color correct
    result = detectFace(output);   % Detect face
    if( isempty(result) )
        continue
    end
    numDetectedFaces = numDetectedFaces + 1;
    faces_db(:,:,i) = result;
end

numberofimages = numel(files);
disp(['Loaded ', num2str(numDetectedFaces), ' of ', num2str(numberofimages), ' faces successfully.'])

[X,Y] = size(faces_db(:,:,1));
n = X*Y;
% Reshape images to vectors
faces_db = reshape(faces_db, [n, numberofimages]);

% Run PCA algorithm
x = im2double(faces_db);
meanImage = mean(x');                   % Find average face vector
A = bsxfun(@minus, x', mean(x'))';      % Subtract the mean for each vector in faces_db
C = transpose(A) * A;                   % Covariance matrix (MxM) 
[eigVec, eigVal] = eig(C);              % Eigenvectors and eigenvalues in smaller dimension
eigenVecLarge = A * eigVec;             % Eigenvectors in bigger dimension (n x n)

% Reshaping the n-dim eigenvectors into matrices (eigenfaces)
eigenfaces = [];
for k = 1:numberofimages
    c = eigenVecLarge(:,k);
    eigenfaces{k} = reshape(c,X,Y);
    eigenfaces{k} = eigenfaces{k}./norm(eigenfaces{k});
end

x = diag(eigVal);
[xc,xci] = sort(x,'descend'); % get largest eigenvalue
[xciR, xciC] = size(xci);

for e = 1:xciR
    figure
    imshow(eigenfaces{e}, [])
end

% Calculate weights
weights = zeros(numberofimages, numberofimages);
for a = 1:numberofimages
    img = faces_db(:,a)';
    img = double(img)-meanImage;
    for j=1:numberofimages
        w =  img*eigenVecLarge(:,j);
        weights(a,j) = w;
    end
end

% Saving weight matrix, eigenvectors and mean image to database
save('database.mat', 'eigenVecLarge', 'weights', 'meanImage');

end

