function [ handle ] = draw_data_bin(class_index, points, idx_a, idx_b, idx_c)
%DRAW DATA

 % Wizualizacja binarna klasy pozytywnej i negatywnej
    % Oraz dzialania sieci
    idx_pos = 0;
    idx_neg = 0;
    
    if class_index == 1
        idx_pos = idx_a;
        idx_neg = sort([idx_b; idx_c]);
        
    elseif class_index == 2
        idx_pos = idx_b;
        idx_neg = sort([idx_a; idx_c]);
    else 
        idx_pos = idx_c;
        idx_neg = sort([idx_a; idx_b]);
    end
   
    plot(points(idx_pos,1),points(idx_pos,2),'go');
    hold on;
    plot(points(idx_neg,1),points(idx_neg,2),'ko');
    hold off; 
    
    title(['Klasyfikator binarny dla klasy ' num2str(class_index) '.']);

    
   
end

