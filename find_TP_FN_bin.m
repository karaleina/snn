function [ TP, FN ] = find_TP_FN_bin(idx_test, idx_pos_zaklasyfikowane, idx_neg_zaklasyfikowane)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
TP = 0;
FN = 0;
for i = 1:length(idx_pos_zaklasyfikowane)
    znalezione = 0;
    for j = 1:length(idx_test)
        if idx_test(j) == idx_pos_zaklasyfikowane(i)
            znalezione = 1;
            break
        end
    end
    
    if (znalezione)
        TP = TP + 1;
    end
   
end

for i=1:length(idx_test)
    znaleziono_we_wlasciwej_klasie = 0;
    for j=1:length(idx_pos_zaklasyfikowane)
        if (idx_test(i) == idx_pos_zaklasyfikowane(j))
            znaleziono_we_wlasciwej_klasie = 1;
            break;
        end
    end
    
    znaleziono_w_innej_klasie = 0;
    
    for j=1:length(idx_neg_zaklasyfikowane)
        if (idx_test(i) == idx_neg_zaklasyfikowane(j))
            znaleziono_w_innej_klasie = 1;
            break;
        end
    end
    
    if (znaleziono_we_wlasciwej_klasie == 0 && znaleziono_w_innej_klasie == 1)
        FN = FN + 1;
    end

end

