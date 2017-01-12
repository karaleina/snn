function [ handle ] = draw_data_bin2(class_index, points, idx_pos, idx_neg)
%DRAW DATA

 % Wizualizacja binarna klasy pozytywnej i negatywnej
   
    plot(points(idx_pos,1),points(idx_pos,2),'go');
    hold on;
    plot(points(idx_neg,1),points(idx_neg,2),'ko');
    hold off; 
    
    title(['Klasyfikator binarny dla klasy ' num2str(class_index) '.']);

