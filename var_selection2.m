clc;
clear;

%% Import danych i okreśnienie wymiarowości
data = importdata('K_34_2.txt');
var_count = 4;                   % liczba wymiarów
class_count = 3;                 % liczba klas 
sample_count = size(data,1);     % liczba probek

%% Deklaracje zmiennych
data_norm = zeros(sample_count,var_count);  % macierz zer o wymiarach macierzy x
labels = -1*ones(sample_count,class_count); % macierz odpowiadających etykiet
avg = zeros(var_count,1);                   % wektor o długości odpowiadającej liczbie kolumn

% cos2 = zeros(var_count);                  % cos^2 jest miara korelacji
var_ranking = zeros(class_count,var_count); 
original_var_no = 1:1:var_count;            % wektor odpowiadający kolejnym wymiarom

%% "Normalizacja" tj. odjęcie średniej  od wszystkich wartości w ramach danej kolumny
for i = 1:1:var_count
   avg(i) = mean(data(:,i));
   data_norm(:,i) = data(:,i)-avg(i);
end

data_norm_start = data_norm;


% % % normalizacja i centrowanie do (0, 1)
% data_norm = zeros(sample_count, var_count);
% 
% for i = 1:1:var_count        
%     data_norm(:,i) = (data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
% end    
% 
% data_centr = zeros(sample_count,var_count);  % macierz zer o wymiarach macierzy x
% avg = zeros(var_count,1);                    % wektor w którym obliczane będą średnie kolumn (wymiarów)
% 
% for i=1:1:var_count              
%    avg(i) = mean(data_norm(:,i));
%    data_centr(:,i) = data_norm(:,i)-avg(i);
% end
% 
% % wektor_y = data(:,5);
% 
% data_norm = data_centr;


%% Pętla po wyszystkich próbkach nadająca etykiety kolumnom odpowiadającym klasom próbek
for i = 1:1:sample_count
   labels(i,data(i,var_count + 1)) = 1;
end
 
%% Pętla po wszystkich klasach


licznik = 1;
for class_no = 1:1:class_count      
    data_ort = data_norm;
    
    % Pętla po wymiarach (kolumnach)
    for sel_feature_no = 1:1:var_count
        
        cos2 = zeros(var_count,1);
        
        % Pętla obliczająca korelację danej klasy (class_no w pętli
        % zewnętrznej) z kolejnymi wymiarami (var_no) - dzięki tej "dodatkowej" pętli
        % unikniemy podwójnego obliczania korelacji
        for var_no = sel_feature_no:1:var_count
           
            exp1 = 0;
            exp2 = 0;
            exp3 = 0; 
         
           for i = 1:1:sample_count    
               exp1 = exp1 + data_ort(i, var_no) * labels(i,class_no);
               exp2 = exp2 + data_ort(i, var_no)^2;
               exp3 = exp3 + labels(class_no)^2;
           end 
           
           % Obliczona korelacja dla bieżącego wymiaru z danymi
           cos2(var_no) = exp1^2 / (exp2 * exp3)
           MATRIX_cos(licznik, :) = cos2(var_no)';
           licznik = licznik + 1;
        end 
        
        % Na tym etapie dysponujemy korelacją danej klasy dla każdego
        % wymiaru w wektorze cos2
        
        % Znajdujemy max korelacji i odpowiadający jej wymiar var_idx
        [max_r, var_idx]=max(cos2);
        
        % Dopisujemy dane do rankingu - wiersz odpowiada danej klasie, a
        % kolumna kolejnym wektorom x
        var_ranking(class_no,sel_feature_no) = original_var_no(var_idx)
        temp = data_ort(:,sel_feature_no);
        data_ort(:,sel_feature_no) = data_ort(:,var_idx);
        data_ort(:,var_idx) = temp;
        
        temp = original_var_no(sel_feature_no);
        original_var_no(sel_feature_no) = original_var_no(var_idx);
        original_var_no(var_idx) = temp;
        
        for i = sel_feature_no+1 : 1 : var_count
            V = data_ort(:,sel_feature_no);
            U = data_ort(:,i);
            UprojV = ((U'*V)/(V'*V))*V;
            UortV = U - UprojV;
            data_ort(:,i) = UortV;
        end
        
    end
    figure(3140 + class_no);
    idx_pos = find(data(:,5) == class_no);
    idx_neg = find(data(:,5) ~= class_no);
    plot(data(idx_pos,var_ranking(class_no,1)),data(idx_pos,var_ranking(class_no,2)),'ro');
    hold on;
    plot(data(idx_neg,var_ranking(class_no,1)),data(idx_neg,var_ranking(class_no,2)),'k.');
    
end
