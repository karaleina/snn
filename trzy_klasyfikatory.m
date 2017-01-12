clc;
clear;
close all;

%% Dla użytkowanika
czy_trenowac = 0;
class_no = 2;
neurony_liczba = 1;
margines_nieokreslonosci = 0.1;

%% Wczytywanie danych
dane = importdata('dane_po_selekcji.txt');
dane_uczenie = dane(1:683,:);
dane_test = dane(684:end, :);

dane = dane_uczenie;
% dane_test = dane;
%% Znajdowanie indeksów dla właściwych klas
idx_1 = find(dane(:,3)==1);
idx_2 = find(dane(:,3)==2);
idx_3 = find(dane(:,3)==3);

idx_1_test = find(dane_test(:,3)==1);
idx_2_test = find(dane_test(:,3)==2);
idx_3_test = find(dane_test(:,3)==3);

pkt_test_1 = length(idx_1_test);
pkt_test_2 = length(idx_2_test);
pkt_test_3 = length(idx_3_test);
zbiory = [pkt_test_1; pkt_test_2; pkt_test_3 ];
zbiory_dopelniajace = [pkt_test_2 + pkt_test_3; pkt_test_1 + pkt_test_3; pkt_test_1 + pkt_test_2];


%% Rysowanie danych wejściowych
figure(1)
draw_data(dane, idx_1, idx_2, idx_3);
title('Dane')

%% Trenowanie zapisywanie i wizualizacja sieci

TPs=[];
if czy_trenowac==1
    for iteracja=1:1:50
        len = length(dane);
        train_set = zeros(len, 1);
        for i=1:1:len
            if(dane(i,3)==class_no)
                train_set(i,1) = 1;
            else
                train_set(i,1) = 0;
            end
        end

        net = train_net(dane(:,1:2),train_set(:,1),[neurony_liczba 1]);
        input_weight = [net.IW{1}];
        input_bias = [net.b{1}];
        nazwa = (['wyniki/trzy_klasyfikatory/net' num2str(class_no) num2str(iteracja) '.mat']);
        save(nazwa, 'net');
        % Wizualizacja
        figure(2)
        draw_data_bin(class_no, dane, idx_1, idx_2, idx_3);
        for i=1:size(input_weight)
           plotpc((input_weight(i,:)), (input_bias(i)))
        end

        %% Test pojedynczego klasyfikatora
        nazwa = (['wyniki/trzy_klasyfikatory/net' num2str(class_no) num2str(iteracja) '.mat']);
        load(nazwa);
        wyjscie_bin = sim(net, dane_test(:,1:2)');

        idx_pos_zaklasyfikowane_bin = find(wyjscie_bin>=(0.5 + margines_nieokreslonosci));
        idx_neg_zaklasyfikowane_bin = find(wyjscie_bin<=(0.5 - margines_nieokreslonosci));

        test_set = zeros(len, 1);
        for i=1:1:len
            if(dane_test(i,3)==class_no)
                test_set(i,1) = 1;
            else
                test_set(i,1) = 0;
            end
        end
        idx_pos_test_set = find(test_set==1);

        TP_bin = 0;
        for i=1:length(idx_pos_zaklasyfikowane_bin)
            znaleziono = 0;
            for j=1:length(idx_pos_test_set)
                if (idx_pos_zaklasyfikowane_bin(i)==idx_pos_test_set(j))
                    znaleziono = 1;
                    break;
                end
            end
            if znaleziono
                TP_bin = TP_bin + 1;
            end
        end

        sensivity = TP_bin/length(idx_pos_test_set);
        WY(iteracja, :) = 100*[sensivity];
        figure(3)
        title('wynik dzialania sieci binarnej');
        draw_data_bin2(class_no, dane_test, idx_pos_zaklasyfikowane_bin, idx_neg_zaklasyfikowane_bin);
    end
else
    
    %% Testowanie trzech jednoczesnie
    for i=1:1:3
        nazwa = [ 'wyniki/trzy_klasyfikatory/najlepsze/net' num2str(i) '_best.mat' ];
        load(nazwa);
        wyjscie(i, :) = sim(net, dane_test(:,1:2)');
    end
    
    wyjscie1 = wyjscie(1,:);
    wyjscie2 = wyjscie(2,:);
    wyjscie3 = wyjscie(3,:);
    
    idx_1_pos_zaklasyfikowane = find(wyjscie1>(0.5+margines_nieokreslonosci) & wyjscie2<(0.5-margines_nieokreslonosci) & wyjscie3<(0.5-margines_nieokreslonosci));
    idx_2_pos_zaklasyfikowane = find(wyjscie1<(0.5-margines_nieokreslonosci) & wyjscie2>(0.5+margines_nieokreslonosci) & wyjscie3<(0.5-margines_nieokreslonosci));
    idx_3_pos_zaklasyfikowane = find(wyjscie1<(0.5-margines_nieokreslonosci) & wyjscie2<(0.5-margines_nieokreslonosci) & wyjscie3>(0.5+margines_nieokreslonosci));
    
    TP = zeros(3,1);
    FN = zeros(3,1);
    
    [TP(1,1), FN(1,1)] = find_TP_FN(idx_1_test, idx_1_pos_zaklasyfikowane, idx_2_pos_zaklasyfikowane, idx_3_pos_zaklasyfikowane);
    [TP(2,1), FN(2,1)] = find_TP_FN(idx_2_test, idx_2_pos_zaklasyfikowane, idx_1_pos_zaklasyfikowane, idx_3_pos_zaklasyfikowane);
    [TP(3,1), FN(3,1)] = find_TP_FN(idx_3_test, idx_3_pos_zaklasyfikowane, idx_1_pos_zaklasyfikowane, idx_3_pos_zaklasyfikowane);
    
    Nklas = zeros(3,1);
    Nklas(1) = find_Nklas(idx_1_test, idx_1_pos_zaklasyfikowane, idx_2_pos_zaklasyfikowane, idx_3_pos_zaklasyfikowane);
    Nklas(2) = find_Nklas(idx_2_test, idx_2_pos_zaklasyfikowane, idx_1_pos_zaklasyfikowane, idx_3_pos_zaklasyfikowane);
    Nklas(3) = find_Nklas(idx_3_test, idx_3_pos_zaklasyfikowane, idx_1_pos_zaklasyfikowane, idx_3_pos_zaklasyfikowane);
    
    FP(1,1) = length(idx_1_pos_zaklasyfikowane) - TP(1,1);
    FP(2,1) = length(idx_2_pos_zaklasyfikowane) - TP(2,1);
    FP(3,1) = length(idx_3_pos_zaklasyfikowane) - TP(3,1);
    
    TN(1,1) = length(idx_1_test) - FN(1,1) - Nklas(1,1);
    TN(2,1) = length(idx_2_test) - FN(2,1) - Nklas(2,1);
    TN(3,1) = length(idx_3_test) - FN(3,1) - Nklas(3,1);
      
    fp_rate = FP./zbiory_dopelniajace
    precision = TP./(TP + FP)
    accuracy = (TP + TN)./(length(dane_test))
    specifity = TN./zbiory_dopelniajace
    sensivity = TP./zbiory

    WY = sum(TP)/sum(zbiory)
   
    stosunek_niesklasyfikowanych(1, 1) = Nklas(1,1)/length(idx_1_test);
    stosunek_niesklasyfikowanych(2, 1) = Nklas(2,1)/length(idx_2_test);
    stosunek_niesklasyfikowanych(3, 1) = Nklas(3,1)/length(idx_3_test);
    
    % Wyjecie wag z sieci
    wagi_n_ukrytych_1 = net.IW{1,1};
    bias_n_ukrytych_1 = net.b{1};
    wagi_n_wyjsciowych_1 = net.LW{2,1};
    bias_n_wyjsciowych_1 = net.b{2};
    

end