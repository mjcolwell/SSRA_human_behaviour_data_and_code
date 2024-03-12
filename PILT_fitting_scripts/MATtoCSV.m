% Specify the folder containing .mat files
matFolder = 'C:\Users\micha\Desktop\ModelledData\';

% Specify the output folder for CSV files
csvFolder = 'C:\Users\micha\Desktop\ModelledData_CSV\';

% Create the output folder if it doesn't exist
if ~exist(csvFolder, 'dir')
    mkdir(csvFolder);
end

% Get a list of all .mat files in the specified folder
matFiles = dir(fullfile(matFolder, '*.mat'));

% Iterate through each .mat file
for fileIdx = 1:length(matFiles)
    % Load the data from the .mat file
    matFilePath = fullfile(matFolder, matFiles(fileIdx).name);
    load(matFilePath, 'fitstruct'); % Assuming fitstruct is the variable you want to convert

    % Check if 'fitstruct' contains the variable 'mod_choice_prob'
    if isfield(fitstruct, 'mod_choice_prob')
        % Extract the variable and create a table
        modChoiceProbTable = table(fitstruct.mod_choice_prob);

        % Generate the filename for the CSV file
        [~, baseFileName, ~] = fileparts(matFiles(fileIdx).name);
        csvFileName = [baseFileName, '_mod_choice_prob2.csv'];

        % Save the table as a CSV file in the output folder
        csvFilePath = fullfile(csvFolder, csvFileName);
        writetable(modChoiceProbTable, csvFilePath);
    else
        disp(['Mat file "', matFiles(fileIdx).name, '" does not contain the required variable mod_choice_prob.']);
    end
end