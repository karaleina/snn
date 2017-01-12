function [ Nklas ] = find_Nklas_bin(idx, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%find_Nklas
Nklas = 0;

    for i=1:length(idx)
        
        szuk = idx(i);
        znaleziono = find((idx_1_zaklasyfikowane(:)==szuk));
        
        if (isempty(znaleziono))
            znaleziono = find(idx_2_zaklasyfikowane(:)==szuk);
        end
        
        if (isempty(znaleziono))
            Nklas = Nklas+1;
        end
    end

end

