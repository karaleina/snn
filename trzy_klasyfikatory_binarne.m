%projekt SNN 2016
%3 klasyfikatory binarne dla 3 klas
clear;
clc;

dane = load('dane_po_selekcji.txt');

dane_a = dane(1:1000, :);
dane_b = dane(1001:end, :);

liczba_danych_uczacych = length(dane_a(:, 1))
liczba_danych_testowych = length(dane_b(:, 1))

%% Decyzja o trenowaniu
czy_trenowac = 1;   % 1 - TRENUJ
                    % 0 - NIE TRENUJ

if czy_trenowac==0
    load('siec2_kl1.mat');
    load('siec2_kl2.mat');
    load('siec2_kl3.mat');
end;

dane=dane_a';
dane_b=dane_b';
%--w celu testowania na zbiorze uczącym odkomentować poniższą linię
% dane_b=dane;

wart_klasy=0.8;

klasa1 = wart_klasy*(dane(3,:)==1);
klasa2 = wart_klasy*(dane(3,:)==2);
klasa3 = wart_klasy*(dane(3,:)==3);

% margines_gorny=0.6;
% margines_dolny=0.4;

%wartości min i max zbioru uczącego
% we1_min=min(dane(1,:));
% we1_max=max(dane(1,:));
% we2_min=min(dane(2,:));
% we2_max=max(dane(2,:));
% 
% indx_cl1=find(klasa1>=margines_gorny);
% indx_cl2=find(klasa2>=margines_gorny);
% indx_cl3=find(klasa3>=margines_gorny);

if czy_trenowac==1
    
    
    
    
%utworzenie klasyfikator�w binarnych
%   
%   klasyfikator1=newff([we1_min we1_max; we2_min we2_max], [4 1], {'logsig' 'logsig'}, 'traingd');
%   klasyfikator1.trainParam.goal=0.01;
%   klasyfikator1.trainParam.epochs=100;
%   
% 
%   klasyfikator2=newff([we1_min we1_max; we2_min we2_max], [6 1], {'logsig' 'logsig'}, 'traingd');
%   klasyfikator2.trainParam.goal=0.01;
%   klasyfikator2.trainParam.epochs=100; 
%   
%   
%   klasyfikator3=newff([we1_min we1_max; we2_min we2_max], [6 1], {'logsig' 'logsig'}, 'traingd');
%   klasyfikator3.trainParam.goal=0.01;
%   klasyfikator3.trainParam.epochs=100;
% 
% %inicjalizacja wag wg Nguyena-Widrowa
% klasyfikator1=initnw(klasyfikator1, 1);
% klasyfikator1=initnw(klasyfikator1, 2);
% klasyfikator2=initnw(klasyfikator2, 1);
% klasyfikator2=initnw(klasyfikator2, 2);
% klasyfikator3=initnw(klasyfikator3, 1);
% klasyfikator3=initnw(klasyfikator3, 2);
%   
% %uczenie sieci neuronowej
%   klasyfikator1=train(klasyfikator1, dane(1:2,:), klasa1);
%   klasyfikator2=train(klasyfikator2, dane(1:2,:), klasa2);
%   klasyfikator3=train(klasyfikator3, dane(1:2,:), klasa3);
%   
%   klasyfikator1.trainFcn = 'trainlm';
%   klasyfikator2.trainFcn = 'trainlm';
%   klasyfikator3.trainFcn = 'trainlm';
%   klasyfikator1.trainParam.epochs=200;
%   klasyfikator2.trainParam.epochs=200;
%   klasyfikator3.trainParam.epochs=200;
%   
%   klasyfikator1=train(klasyfikator1, dane(1:2,:), klasa1);
%   klasyfikator2=train(klasyfikator2, dane(1:2,:), klasa2);
%   klasyfikator3=train(klasyfikator3, dane(1:2,:), klasa3);
%  
%   save('siec2_kl1.mat', 'klasyfikator1');
%   save('siec2_kl2.mat', 'klasyfikator2');
%   save('siec2_kl3.mat', 'klasyfikator3');
%   
end;


klasa_n1 = wart_klasy*(dane_b(3,:)==1)+0.1;
klasa_n2 = wart_klasy*(dane_b(3,:)==2)+0.1;
klasa_n3 = wart_klasy*(dane_b(3,:)==3)+0.1;

indx_cl_n1=find(klasa_n1>=margines_gorny);
indx_cl_n2=find(klasa_n2>=margines_gorny);
indx_cl_n3=find(klasa_n3>=margines_gorny);

%wizualizacja zbioru testuj�cego
figure(1);
plot(dane_b(1,indx_cl_n1),dane_b(2,indx_cl_n1),'ro');
hold on;
plot(dane_b(1,indx_cl_n2),dane_b(2,indx_cl_n2),'go');
plot(dane_b(1,indx_cl_n3),dane_b(2,indx_cl_n3),'bo');
hold off;

ile_pkt_1=length(indx_cl_n1);
ile_pkt_2=length(indx_cl_n2);
ile_pkt_3=length(indx_cl_n3);

wyjscie_test_1=sim(klasyfikator1,[dane_b(1,:); dane_b(2,:)]);
wyjscie_test_2=sim(klasyfikator2,[dane_b(1,:); dane_b(2,:)]);
wyjscie_test_3=sim(klasyfikator3,[dane_b(1,:); dane_b(2,:)]);

%sprawdzanie przynale�no�ci do danej klasy
indx_cl1_net=find((wyjscie_test_1(:)>margines_gorny)&(wyjscie_test_2(:)<margines_dolny)&(wyjscie_test_3(:)<margines_dolny));
indx_cl2_net=find((wyjscie_test_1(:)<margines_dolny)&(wyjscie_test_2(:)>margines_gorny)&(wyjscie_test_3(:)<margines_dolny));
indx_cl3_net=find((wyjscie_test_1(:)<margines_dolny)&(wyjscie_test_2(:)<margines_dolny)&(wyjscie_test_3(:)>margines_gorny));

%transpozycja indeks�w
indx_cl_n1=indx_cl_n1';
indx_cl_n2=indx_cl_n2';
indx_cl_n3=indx_cl_n3';

%sprawdzanie ilo�ci true positive
TP=zeros(3,1);TN=zeros(3,1);T=zeros(3,1);  
FN=zeros(3,1);FP=zeros(3,1);F=zeros(3,1);  
il_punktow=length(dane_b);

a = 1;
for i=1:length(indx_cl1_net)
    znaleziono = 0;
    for j=1:length(indx_cl_n1)
        if (indx_cl1_net(i) == indx_cl_n1(j))
            znaleziono = 1;
            break;
        end
    end
    if (znaleziono)
        TP(a)=TP(a)+1;
    end
end
for i=1:length(indx_cl_n1)
    znaleziono = 0;
    for j=1:length(indx_cl1_net)
        if (indx_cl_n1(i) == indx_cl1_net(j))
            znaleziono=1;
            break;
        end
    end
    if (znaleziono == 0)
        FN(a)=FN(a)+1;
    end
end

a = 2;
for i=1:length(indx_cl2_net)
    znaleziono = 0;
    for j=1:length(indx_cl_n2)
        if (indx_cl2_net(i) == indx_cl_n2(j))
            znaleziono = 1;
            break;
        end
    end
    if (znaleziono)
        TP(a)=TP(a)+1;
    end
end
for i=1:length(indx_cl_n2)
    znaleziono = 0;
    for j=1:length(indx_cl2_net)
        if (indx_cl_n2(i) == indx_cl2_net(j))
            znaleziono=1;
            break;
        end
    end
    if (znaleziono == 0)
        FN(a)=FN(a)+1;
    end
end
   
a = 3;
for i=1:length(indx_cl3_net)
    znaleziono = 0;
    for j=1:length(indx_cl_n3)
        if (indx_cl3_net(i) == indx_cl_n3(j))
            znaleziono = 1;
            break;
        end
    end
    if (znaleziono)
        TP(a)=TP(a)+1;
    end
end
for i=1:length(indx_cl_n3)
    znaleziono = 0;
    for j=1:length(indx_cl3_net)
        if (indx_cl_n3(i) == indx_cl3_net(j))
            znaleziono=1;
            break;
        end
    end
    if (znaleziono == 0)
        FN(a)=FN(a)+1;
    end
end

%punkty niezklasyfikowane
Nklas = zeros(3,1);

a = 1;
for i=1:length(indx_cl_n1)
    szuk = indx_cl_n1(i);
    znaleziono=[];
    znaleziono = find((indx_cl1_net(:)==szuk));
    if (isempty(znaleziono))
        znaleziono = find(indx_cl2_net(:)==szuk);
    end
    if (isempty(znaleziono))
        znaleziono = find(indx_cl3_net(:)==szuk);
    end
    if (isempty(znaleziono))
        Nklas(a)=Nklas(a)+1;
    end
end
a = 2;
for i=1:length(indx_cl_n2)
    szuk = indx_cl_n2(i);
    znaleziono=[];
    znaleziono = find((indx_cl1_net(:)==szuk));
    if (isempty(znaleziono))
        znaleziono = find(indx_cl2_net(:)==szuk);
    end
    if (isempty(znaleziono))
        znaleziono = find(indx_cl3_net(:)==szuk);
    end
    if (isempty(znaleziono))
        Nklas(a)=Nklas(a)+1;
    end
end
a = 3;
for i=1:length(indx_cl_n3)
    szuk = indx_cl_n3(i);
    znaleziono=[];
    znaleziono = find((indx_cl1_net(:)==szuk));
    if (isempty(znaleziono))
        znaleziono = find(indx_cl2_net(:)==szuk);
    end
    if (isempty(znaleziono))
        znaleziono = find(indx_cl3_net(:)==szuk);
    end
    if (isempty(znaleziono))
        Nklas(a)=Nklas(a)+1;
    end
end

%false positive, true negative etc.
FP(1)=ile_pkt_1-TP(1)-Nklas(1);
FP(2)=ile_pkt_2-TP(2)-Nklas(2);
FP(3)=ile_pkt_3-TP(3)-Nklas(3);

TN(1)=(ile_pkt_2 + ile_pkt_3) - FP(1);
TN(2)=(ile_pkt_1 + ile_pkt_3) - FP(2);
TN(3)=(ile_pkt_1 + ile_pkt_2) - FP(3);

FP_total = FP(1)+FP(2)+FP(3);
TP_total = TP(1)+TP(2)+TP(3);
FN_total = FN(1)+FN(2)+FN(3);
TN_total = TN(1)+TN(2)+TN(3);

%odczyt wag klasyfikator�w
wagi_n_ukrytych_1=[klasyfikator1.IW{1}]
wagi_n_ukrytych_2=[klasyfikator2.IW{1}]
wagi_n_ukrytych_3=[klasyfikator3.IW{1}]

bias_n_ukrytych_1=[klasyfikator1.b{1}]
bias_n_ukrytych_2=[klasyfikator2.b{1}]
bias_n_ukrytych_3=[klasyfikator3.b{1}]

wagi_n_wyjsciowych_1=klasyfikator1.LW{2,1}
wagi_n_wyjsciowych_2=klasyfikator2.LW{2,1}
wagi_n_wyjsciowych_3=klasyfikator3.LW{2,1}

bias_n_wyjsciowych_1=klasyfikator1.b{2}
bias_n_wyjsciowych_2=klasyfikator2.b{2}
bias_n_wyjsciowych_3=klasyfikator3.b{2}

%czu�o��, specyficzno�� itp. - ocena szczeg�owa
sensitivity=TP_total / (TP_total + FN_total) * 100
fp_rate=FP_total / (FP_total + TN_total) * 100
precision=TP_total / (TP_total + FP_total) * 100
accuracy=(TP_total + TN_total) / (TP_total + FN_total + FP_total + TN_total) * 100
specificity=TN_total / (FP_total + TN_total) * 100

TP_proc=zeros(3,1);
FP_proc=zeros(3,1);

Nklas_suma = 0;
for i=1:3
    Nklas_suma = Nklas_suma + Nklas(i);
end
Nklas_proc=zeros(3,1);

T=TP;
F=FP;
for i=1:3
    TP_proc(i) = T(i) / (T(i) + F(i) + Nklas(i))*100;
    FP_proc(i) = F(i) / (T(i) + F(i) + Nklas(i))*100;
    Nklas_proc(i) = Nklas(i) / (T(i) + F(i) + Nklas(i))*100;
end

TP
TP_proc
FP
FP_proc
TP_calosc = TP_total
TP_calosc_proc=(TP_total) / il_punktow * 100
FP_calosc = FP_total
FP_calosc_proc=(FP_total) / il_punktow * 100
Nklas
Nklas_proc
Nklas_suma
Nklas_suma_proc = Nklas_suma / il_punktow * 100
il_punktow


%wizualizacja linii rozdzielaj�cych klasy

wagi_n_ukrytych=[klasyfikator1.IW{1}; klasyfikator2.IW{1};  klasyfikator3.IW{1};];
bias_n_ukrytych=[klasyfikator1.b{1}; klasyfikator2.b{1}; klasyfikator3.b{1};];

%warto�ci min i max zbioru testowego
we1_min=min(dane_b(1,:));
we1_max=max(dane_b(1,:));
we2_min=min(dane_b(2,:));
we2_max=max(dane_b(2,:));

il_neuronow_ukrytych=klasyfikator1.layers{1}.size+klasyfikator2.layers{1}.size+klasyfikator3.layers{1}.size
figure(1);
hold on;
for n=1:il_neuronow_ukrytych;
  if abs(wagi_n_ukrytych(n,1))<abs(wagi_n_ukrytych(n,2));
    plot([we1_min we1_max],[-wagi_n_ukrytych(n,1)/wagi_n_ukrytych(n,2)*we1_min-bias_n_ukrytych(n)/wagi_n_ukrytych(n,2) -wagi_n_ukrytych(n,1)/wagi_n_ukrytych(n,2)*we1_max-bias_n_ukrytych(n)/wagi_n_ukrytych(n,2)],'k');
  else
    plot([-wagi_n_ukrytych(n,2)/wagi_n_ukrytych(n,1)*we2_min-bias_n_ukrytych(n)/wagi_n_ukrytych(n,1) -wagi_n_ukrytych(n,2)/wagi_n_ukrytych(n,1)*we2_max-bias_n_ukrytych(n)/wagi_n_ukrytych(n,1)],[we2_min we2_max],'k');
  end;
end;
hold off;
axis([we1_min we1_max we2_min we2_max]);

