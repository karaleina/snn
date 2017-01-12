clc;
clear;

margines_nieokreslonosci = 0.1;

dane_load = importdata('dane_po_selekcji.txt');
dane_uczace = dane_load(1:683,:);
dane_test = dane_load(684:end, :);

% wektor "dane", to wektor, dla ktorego uczymy
dane = dane_uczace;
%dane_test = dane_uczace;

%% Znajdowanie indeksów dla właściwych klas
idx_1 = find(dane(:,3) == 1); 
idx_2 = find(dane(:,3) == 2); 
idx_3 = find(dane(:,3) == 3);

idx_1_test = find(dane_test(:,3) == 1); 
idx_2_test = find(dane_test(:,3) == 2); 
idx_3_test = find(dane_test(:,3) == 3);

train_set = zeros(length(dane), 3);
for class_no=1:1:3 
    for i = 1:1:length(dane)
        if(dane(i,3)==class_no)
            train_set(i,class_no) = 1;
        else
            train_set(i,class_no) = 0;
        end
    end
end

%% Porownanie licznosci zbiorow danych
liczba_danych_uczacych = [length(idx_1); length(idx_2); length(idx_3)];
liczba_danych_test = [length(idx_1_test); length(idx_2_test); length(idx_3_test)];

%% Rysowanie danych uczących i testujących 
figure(1)
draw_data(dane, idx_1, idx_2, idx_3);
title('Dane uczące');

figure(2)
draw_data(dane_test, idx_1_test, idx_2_test, idx_3_test);
title('Dane testujące');


    %% Uczenie - jeden klasyfikator dla 3 klas

sensivity_all = [];    
for step = 1:1:2 
    
    save_file = ['wyniki/jeden_klasyfikator/siec' num2str(step) '.mat' ];
    
    
    liczba_neuronow_ukrytych = [8, 3];
    net = train_net(dane(:,1:2), train_set(:,1:3), liczba_neuronow_ukrytych);

    input_weight = [net.IW{1}];
    input_bias = [net.b{1}];

    figure(3)
    draw_data(dane, idx_1, idx_2, idx_3);
    title(['Jeden klasyfikator' num2str(step)]);

    for i=1:size(input_weight)
       plotpc((input_weight(i,:)), (input_bias(i)));
    end
 

    save(save_file, 'net');
    %% Testowanie

    % Uruchomienie sieci
    wyjscie = sim(net, dane_test(:,1:2)');



    % Indeksy wyjścia sieci ZAKLASYFIKOWANE do poszczegolnych klas
    
    idx_1_zaklasyfikowane = find(wyjscie(1,:)>=(0.5 + margines_nieokreslonosci) & wyjscie(2,:)<=(0.5 - margines_nieokreslonosci) & wyjscie(3,:)<=(0.5 - margines_nieokreslonosci));
    idx_2_zaklasyfikowane = find(wyjscie(2,:)>=(0.5 + margines_nieokreslonosci) & wyjscie(1,:)<=(0.5 - margines_nieokreslonosci) & wyjscie(3,:)<=(0.5 - margines_nieokreslonosci));
    idx_3_zaklasyfikowane = find(wyjscie(3,:)>=(0.5 + margines_nieokreslonosci) & wyjscie(1,:)<=(0.5 - margines_nieokreslonosci) & wyjscie(2,:)<=(0.5 - margines_nieokreslonosci));

    pkt_test_1 = length(idx_1_test);
    pkt_test_2 = length(idx_2_test);
    pkt_test_3 = length(idx_3_test);
    zbiory = [pkt_test_1; pkt_test_2; pkt_test_3 ];

    % Porównywanie otrzymanych indeksów

    %KLASA 1
    % Zliczanie dobrze zaklasyfikowanych elementow 
    TP = zeros(3, 1);
    FP = zeros(3, 1);
    FN = zeros(3, 1);
    FP = zeros(3, 1);

    % Obliczanie TP - obiektów z klasy pozytywnej rozpoznanych pozytywnie oraz
    % FN - obiektów z klasy pozytywnej rozpoznanych jako z klasy negatywnej
    
    [TP(1,1), FN(1,1)] = find_TP_FN(idx_1_test, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane, idx_3_zaklasyfikowane);
    [TP(2,1), FN(2,1)] = find_TP_FN(idx_2_test, idx_2_zaklasyfikowane, idx_1_zaklasyfikowane, idx_3_zaklasyfikowane);
    [TP(3,1), FN(3,1)] = find_TP_FN(idx_3_test, idx_3_zaklasyfikowane, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane);

    % Znajdowanie punktów niezaklasyfikowanych do danych klas
    
    Nklas = zeros(3,1);
    Nklas(1,1) = find_Nklas( idx_1_test, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane, idx_3_zaklasyfikowane);
    Nklas(2,1) = find_Nklas( idx_2_test, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane, idx_3_zaklasyfikowane);
    Nklas(3,1) = find_Nklas( idx_3_test, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane, idx_3_zaklasyfikowane);

    % Sumy kontrolne
    wektor_sum_kontrolnych = TP + FN + Nklas
    zbiory
    
    czulosc = TP./zbiory
    
    WY(step, :) = [sum(TP)/length(dane_test), sum(FN)/length(dane_test), sum(Nklas)/length(dane_test) ];
    sum(WY(:,:))
    
    
%     zbiory_dopelniajace = [pkt_test_2 + pkt_test_3; pkt_test_1 + pkt_test_3; pkt_test_1 + pkt_test_2]
% 
%     % FP i TN
% 
%     FP(1,1) = length(idx_1_zaklasyfikowane) - TP(1,1);
%     FP(2,1) = length(idx_2_zaklasyfikowane) - TP(2,1);
%     FP(3,1) = length(idx_3_zaklasyfikowane) - TP(3,1);
% 
%     TN(1,1) = TP(2,1) + TP(3,1);
%     TN(2,1) = TP(1,1) + TP(3,1);
%     TN(3,1) = TP(1,1) + TP(2,1);
% 
%     
%     % Ocena jakosci
%     stosunek_niesklasyfikowanych(1, 1) = Nklas(1,1)/length(idx_1_test);
%     stosunek_niesklasyfikowanych(2, 1) = Nklas(2,1)/length(idx_2_test);
%     stosunek_niesklasyfikowanych(3, 1) = Nklas(3,1)/length(idx_3_test);
%     stosunek_niesklasyfikowanych
% 
%     sensivity = TP./zbiory;
%     fp_rate = FP./zbiory_dopelniajace;
%     precision = TP./(TP + FP);
%     accuracy = (TP + TN)./(zbiory + zbiory_dopelniajace);
%     specifity = (TN)/(FP + TN);
%     
%     AA_zaklasyfikowane_poprawnie = sum(TP + TN)/length(dane_test);
%     AA_zaklasyfikowane_blednie = sum(FP + FN)/length(dane_test);
%     AA_nie_zaklasyfikowane = sum(Nklas)/length(dane_test);
%     
%     AA_wynik(step,:) = 100*[AA_zaklasyfikowane_poprawnie, AA_zaklasyfikowane_blednie, AA_nie_zaklasyfikowane];
% %     
% %     AAAsensivity_all(step, :) = sensivity';
% %     AAATP_all(step,:) = TP';
% %     
% %     AAAfp_rate_all(step,:) = fp_rate';
% %     AAAFP_all(step,:) = FP';
% %     
% %     AAANklas_all(step, :) = Nklas';
% %     AAANklas_all_percent(step,:) = (Nklas./(zbiory + zbiory_dopelniajace))';
% %     
% 
%     % Wyjecie wag z sieci
    wagi_n_ukrytych = net.IW{1,1};
    bias_n_ukrytych = net.b{1};
    wagi_n_wyjsciowych = net.LW{2,1};
    bias_n_wyjsciowych = net.b{2};
end
