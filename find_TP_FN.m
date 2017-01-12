function [ TP, FN ] = find_TP_FN(idx_test, idx_zaklasyfikowane, idx_inna_klasa, idx_inna_klasa2)
%FIND_TP_FP Obliczanie TP czyli liczby obiektów z klasy pozytywnej
%rozpoznanych jako obiekty pozytywne 
%oraz FN czyli obiektów z klasy pozytywnej rozpoznanych jako negatywne

TP = 0;
FN = 0;

for i=1:length(idx_zaklasyfikowane)
    znaleziono_we_wlasciwej_klasie = 0;
    for j=1:length(idx_test)
        if (idx_zaklasyfikowane(i) == idx_test(j))
            znaleziono_we_wlasciwej_klasie = 1;
            break;
        end
    end
    if znaleziono_we_wlasciwej_klasie
        TP = TP + 1;
    end
end

for i=1:length(idx_test)
    znaleziono_we_wlasciwej_klasie = 0;
    for j=1:length(idx_zaklasyfikowane)
        if (idx_test(i) == idx_zaklasyfikowane(j))
            znaleziono_we_wlasciwej_klasie = 1;
            break;
        end
    end
    
    znaleziono_w_innej_klasie = 0;
    
    for j=1:length(idx_inna_klasa)
        if (idx_test(i) == idx_inna_klasa(j))
            znaleziono_w_innej_klasie = 1;
            break;
        end
    end
    for j=1:length(idx_inna_klasa2)
        if (idx_test(i) == idx_inna_klasa2(j))
            znaleziono_w_innej_klasie = 1;
            break;
        end
    end
    if (znaleziono_we_wlasciwej_klasie == 0 && znaleziono_w_innej_klasie == 1)
        FN = FN + 1;
    end
end


end