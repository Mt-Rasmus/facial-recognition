%{
%    TNM034 - Facial Recognition
%    HT2017 - Linkoping University
%
%    Developed by: Jesper Lund, Rasmus Stahl, Tobias Matts, Anton Sterner
%
%    Process to recognize candidate face:
%        1. Load image and color correct using Gray World Assumption
%        2. Transform to YCbCr Color space
%        3. Detect face; create face mask, eye map and mouth map
%        4. Align and normalize face
%        5. Project candidate face to subspace spanned by database
%        eigenfaces
%        6. Calculate minimum euclidean distance to each eigenface
%        7. Check if mimimum distance is close enough to be able to say
%        that the candidate face exists in the database
%}

%% Create database with eigenfaces

clc;
clear;
images_folder = 'images/DB1';
createDatabase(images_folder);

%% Read candidate face image and check if face exists in database

clc;
clear;
tic
image_name = 'images/DB1/db1_05.jpg'; 
message = '';
im = imread(image_name);
[ id ] = tnm034(im);
toc

if id > 0
    message = 'Face exists in database!';
end
if id == 0
    message = 'Face does not exist in database!';
end
if id == -1
    message = 'Face could not get detected!';
end
 
% Display result
disp(['id = ', num2str(id)])
disp(message)
