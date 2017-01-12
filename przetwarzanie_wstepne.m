clc;
clear;

% wczytanie zestawu danych
data=importdata('K_34_2.txt');
var_count = 4;                   % liczba wymiarów
class_count = 3;                 % liczba klas 
sample_count = size(data,1);     % liczba probek

% normalizacja i centrowanie do (0, 1)
data_centr = zeros(sample_count, var_count);
data_norm = zeros(sample_count, var_count);

 avg = zeros(var_count,1);                    % wektor w którym obliczane będą średnie kolumn (wymiarów)

for i=1:1:var_count              
   avg(i) = mean(data(:,i))
   data_centr(:,i) = data(:,i)-avg(i);
end

wektor_y = data(:,5);

for i = 1:1:var_count        
    data_norm(:,i) = (data_centr(:,i)-min(data_centr(:,i)))/(max(data_centr(:,i))-min(data_centr(:,i)));
end

%% Wyselekcjonowane zmienne wejściowe - 2 i 4
data_kol_a = data_norm(:,2);
data_kol_b = data_norm(:,4);
data_uzyteczne = [data_kol_a data_kol_b];
data_full = [data_uzyteczne wektor_y];

%% Zapis przetworzonego zestawu danych
save('dane_po_selekcji.txt', 'data_full', '-ascii');