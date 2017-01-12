clc;
clear;

dane_load = importdata('dane_po_selekcji.txt');
dane_uczace = dane_load(1:683,:);
dane_test = dane_load(684:end, :);

dane = dane_uczace;

%% Znajdowanie indeksów dla właściwych klas
idx_1 = find(dane(:,3) == 1); 
idx_2 = find(dane(:,3) == 2); 
idx_3 = find(dane(:,3) == 3);

idx_1_test = find(dane_test(:,3) == 1); 
idx_2_test = find(dane_test(:,3) == 2); 
idx_3_test = find(dane_test(:,3) == 3);

pkt_test_1 = length(idx_1_test);
pkt_test_2 = length(idx_2_test);
pkt_test_3 = length(idx_3_test);
zbiory = [pkt_test_1; pkt_test_2; pkt_test_3 ];
zbiory_dopelniajace = [pkt_test_2 + pkt_test_3; pkt_test_1 + pkt_test_3; pkt_test_1 + pkt_test_2];

load('wyniki/jeden_klasyfikator/najlepsze/siec24.mat');

%% Rysowanie danych uczących i testujących 
figure(1)
draw_data(dane, idx_1, idx_2, idx_3);
title('Dane uczące');

figure(2)
draw_data(dane_test, idx_1_test, idx_2_test, idx_3_test);
title('Dane testujące');




    %% Rysowanie - jeden klasyfikator dla 3 klas

    input_weight = [net.IW{1}];
    input_bias = [net.b{1}];

    figure(3)
    draw_data(dane, idx_1, idx_2, idx_3);
    title('Jeden klasyfikator');

    for i=1:size(input_weight)
       plotpc((input_weight(i,:)), (input_bias(i)));
    end
    %axis([-1 2 -2 1])
    
     % Uruchomienie sieci
    wyjscie = sim(net, dane_test(:,1:2)');

    margines_nieokreslonosci = 0.1;

    % Indeksy wyjścia sieci ZAKLASYFIKOWANE do poszczegolnych klas
    
    idx_1_zaklasyfikowane = find(wyjscie(1,:)>=(0.5 + margines_nieokreslonosci) & wyjscie(2,:)<=(0.5 - margines_nieokreslonosci) & wyjscie(3,:)<=(0.5 - margines_nieokreslonosci));
    idx_2_zaklasyfikowane = find(wyjscie(2,:)>=(0.5 + margines_nieokreslonosci) & wyjscie(1,:)<=(0.5 - margines_nieokreslonosci) & wyjscie(3,:)<=(0.5 - margines_nieokreslonosci));
    idx_3_zaklasyfikowane = find(wyjscie(3,:)>=(0.5 + margines_nieokreslonosci) & wyjscie(1,:)<=(0.5 - margines_nieokreslonosci) & wyjscie(2,:)<=(0.5 - margines_nieokreslonosci));

    
    figure(4)
    draw_data(dane_test, idx_1_zaklasyfikowane, idx_2_zaklasyfikowane, idx_3_zaklasyfikowane);
    title('Funkcja realizowana przez siec neuronowa');
    
    for i=1:size(input_weight)
       plotpc((input_weight(i,:)), (input_bias(i)));
    end
    
    %axis([-1 2 -2 1])
    pkt_test_1 = length(idx_1_test);
    pkt_test_2 = length(idx_2_test);
    pkt_test_3 = length(idx_3_test);
    zbiory = [pkt_test_1; pkt_test_2; pkt_test_3 ];

    % Porównywanie otrzymanych indeksów

    %KLASA 1
    % Zliczanie dobrze zaklasyfikowanych elementow 
    TP = zeros(3, 1);
    TN = zeros(3, 1);
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
    
    FP(1,1) = length(idx_1_zaklasyfikowane) - TP(1,1);
    FP(2,1) = length(idx_2_zaklasyfikowane) - TP(2,1);
    FP(3,1) = length(idx_3_zaklasyfikowane) - TP(3,1);
    
    TN(1,1) = length(idx_1_test) - FN(1,1) - Nklas(1,1);
    TN(2,1) = length(idx_2_test) - FN(2,1) - Nklas(2,1);
    TN(3,1) = length(idx_3_test) - FN(3,1) - Nklas(3,1);
    
    wagi_n_ukrytych = net.IW{1,1};
    bias_n_ukrytych = net.b{1};
    wagi_n_wyjsciowych = net.LW{2,1};
    bias_n_wyjsciowych = net.b{2};
    
    fp_rate = FP./zbiory_dopelniajace
    precision = TP./(TP + FP)
    accuracy = (TP + TN)./(length(dane_test))
    specifity = TN./zbiory_dopelniajace
    sensivity = TP./zbiory
    
    WY = sum(TP)/sum(zbiory)