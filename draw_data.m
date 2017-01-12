function [ handle ] = draw_data( dane, idx_1, idx_2, idx_3 )
%DRAW DATA
    plot(dane(idx_1,1),dane(idx_1,2),'ro');
    hold on;
    plot(dane(idx_2,1),dane(idx_2,2),'go');
    hold on;
    plot(dane(idx_3,1),dane(idx_3,2),'bo');
    legend('klasa 1', 'klasa 2', 'klasa 3');
    hold off; 
end

