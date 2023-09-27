function A = convert_matrix(A, type)

    switch type
        case 1
            % Iterate through each row and find the largest index of 1
            for row = 1:size(A, 1)
                indices = find(A(row, :) == 1); % Find indices of 1 in the current row
                if ~isempty(indices)
                    A(row, 1:max(indices)) = 1;
                end
            end

        case 2
            % vertical_2
            for row = 1:size(A, 1)
                indices = find(A(row, :) == 1); % Find indices of 1 in the current row
                if ~isempty(indices)
                    A(row, min(indices):end) = 1;
                end
            end

        case 3
            % horizontal_1
            for col = 1:size(A, 2)
                indices = find(A(:,col) == 1); % Find indices of 1 in the current row
                if ~isempty(indices)
                    A(min(indices):end, col) = 1;
                end
            end


        otherwise
            % horizontal_2
            for col = 1:size(A, 2)
                indices = find(A(:,col) == 1); % Find indices of 1 in the current row
                if ~isempty(indices)
                    A(1:max(indices), col) = 1;
                end
            end

    end
end
