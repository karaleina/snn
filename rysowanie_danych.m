clc;
clear;

data = load('K_34_2.txt');

wektor_y = data(:,5);

idx_1 = find(wektor_y==1);
idx_2 = find(wektor_y==2);
idx_3 = find(wektor_y== 3);


var_count = 4;                   % liczba wymiarów
class_count = 3;                 % liczba klas 
sample_count = size(data,1);     % liczba probek

%% Normalizacja i centrowanie do (0, 1)
data_centr = zeros(sample_count, var_count);
data_norm = zeros(sample_count, var_count);

 avg = zeros(var_count,1);                    % wektor w którym obliczane będą średnie kolumn (wymiarów)

for i=1:1:var_count              
   avg(i) = mean(data(:,i));
   data_centr(:,i) = data(:,i)-avg(i);
end



for i = 1:1:var_count        
    data_norm(:,i) = (data_centr(:,i)-min(data_centr(:,i)))/(max(data_centr(:,i))-min(data_centr(:,i)));
end

dane = data_norm;

%% Podawanie wymiarów do wizualizacji
wymiar_1 = 4;
wymiar_2 = 2;

%% Wizualizacja  
x = dane(idx_1, wymiar_1);
y = dane(idx_1, wymiar_2);
z = data(idx_1, 5);

plot3(x, y, z, 'ro'); hold on;

x = dane(idx_2, wymiar_1);
y = dane(idx_2, wymiar_2);
z = data(idx_2, 5);

plot3(x, y, z, 'go'); hold on; 

x = dane(idx_3, wymiar_1);
y = dane(idx_3, wymiar_2);
z = data(idx_3, 5);

plot3(x, y, z, 'bo'); 
grid on;
xlabel(['wymiar ' num2str(wymiar_1)])
ylabel(['wymiar ' num2str(wymiar_2)])
zlabel('klasa')
hold off;