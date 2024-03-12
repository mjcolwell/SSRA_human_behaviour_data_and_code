function [value1, value2] = extractValuesFromFileName(fileName)
    % Define the regular expression pattern to capture values
    pattern = 'p(\d+)(v\d+)?_visit_(-?\d+)_reward_log\.dat';
    
    % Use regexp to extract values
    matches = regexp(fileName, pattern, 'tokens');
    
    % Check if the regex pattern matched
    if ~isempty(matches)
        % Extract the captured values and convert to the desired format
        value1 = ['p', matches{1}{1}];
        
        % Check if value2 is present (if not, set it to 'v1')
        if numel(matches{1}) >= 3 && ~isempty(matches{1}{2})
            value2 = matches{1}{2};
        else
            value2 = 'v1';
        end
    else
        % If the regex pattern didn't match, set values to empty
        value1 = '';
        value2 = '';
    end
end