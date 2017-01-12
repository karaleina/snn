function [net]= train_net(train_set,labels,hidden_neurons_count)
    %Opis: funkcja tworząca i ucząca sieć neuronową
    %Parametry:
    %   train_set: zbiór uczący - kolejne punkty w kolejnych wierszach
    %   labels:    etykiety punktów - {-1,1}
    %   hidden_neurons_count: liczba neuronów w warstwie ukrytej
    %Wartość zwracana:
    %   net - obiekt reprezentujący sieć neuronową
    
    %inicjalizacja obiektu reprezentującego sieć neuronową
    %funkcja aktywacji: neuronów z warstwy ukrytej - tangens hiperboliczny,
    %                   neuronu wyjściowego - liniowa
    %funkcja ucząca: gradient descent backpropagation - propagacja wsteczna
    %                   błędu    
    net=newff(train_set',labels',hidden_neurons_count,...
              {'logsig', 'logsig'},'traingd');
          
    %rand('state',sum(100*clock));          %inicjalizacja generatora liczb
                                            %pseudolosowych
    net = initnw(net,1);
    net = initnw(net,2);
    
	% net = init(net);                      %inicjalizacja wag sieci
    
    net.trainParam.goal = 0.01;             %warunek stopu - poziom błędu
    net.trainParam.epochs = 100;            %maksymalna liczba epok
    net.divideFcn = '';
    net.trainParam.showWindow = false;      %nie pokazywać okna z wykresami
                                            %w trakcie uczenia
    net=train(net,train_set',labels');      %uczenie sieci
    
    %zmiana funkcji uczącej na: Levenberg-Marquardt backpropagation
    net.trainFcn = 'trainlm';
    net.trainParam.goal = 0.01;             %warunek stopu - poziom błędu
    net.trainParam.epochs = 200;            %maksymalna liczba epok
    net.divideFcn = '';
    net.trainParam.showWindow = false;      %nie pokazywać okna z wykresami
                                            %w trakcie uczenia
    net=train(net,train_set',labels');      %uczenie sieci
    