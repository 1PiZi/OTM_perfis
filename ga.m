%% ************************************************************************
%**************************************************************************
%**********    Real Coded Steady-State GA -- Minimizacao     **************
%**************************************************************************
%**************************************************************************

clc;clear;close all;

rng('shuffle') 

% adiciona pasta das subrotinas
addpath('subrotinas','geometria','GA'); %adicionar xfoil e pasta geometria 

%funcao objetivo
EfficiencyFunction=@(x) ObjectFunc(x);     % Cost Function
            %input    %exec
          %retorna CostFunction
% tt=[0.6431,0.0268];
% teste2  = EfficiencyFunction(tt)
% teste3 = EfficiencyFunction(eficiencia)

%arquivos
saida = fopen('arquivo.dat','wt');

%variaveis de projeto
nvar = 20;                %numero de variaveis de projeto
x_bound(1,1) = 1;   x_bound(1,2) = 2;   %xmin e xmax de cada variavel
x_bound(2,1) = 1;   x_bound(2,2) = 2;
x_bound(3,1) = 1;   x_bound(3,2) = 2;
x_bound(4,1) = 1;   x_bound(4,2) = 2;
x_bound(5,1) = 1;   x_bound(5,2) = 2;
x_bound(6,1) = 1;   x_bound(6,2) = 2;
x_bound(7,1) = 1;   x_bound(7,2) = 2;
x_bound(8,1) = 1;   x_bound(8,2) = 2;
x_bound(9,1) = 1;   x_bound(9,2) = 2;
x_bound(10,1) =1;   x_bound(10,2) = 2;

x_bound(11,1) = 1;   x_bound(11,2) = 2;   %xmin e xmax de cada variavel
x_bound(12,1) = 1;   x_bound(12,2) = 2;
x_bound(13,1) = 1;   x_bound(13,2) = 2;
x_bound(14,1) = 1;   x_bound(14,2) = 2;
x_bound(15,1) = 1;   x_bound(15,2) = 2;
x_bound(16,1) = 1;   x_bound(16,2) = 2;
x_bound(17,1) = 1;   x_bound(17,2) = 2;
x_bound(18,1) = 1;   x_bound(18,2) = 2;
x_bound(19,1) = 1;   x_bound(19,2) = 2;
x_bound(20,1) = 1;   x_bound(20,2) = 2;

% GA Parameters
MaxIt=5;     % Maximum Number of Iterations
nPop=5;       % Population Size
pc=1;                 % Crossover probabilidade
nc=2;  % Number of Offsprings (also Parnets) - numero multiplo de 2
pm=0.1;                 % probalidade de ocorrer mutação   
nm=1;      % Number of Mutants 
run_max = 1; %numero de rodadas independentes

%tipo de operador selecao:
 % Tournament: parametroS.TournamentSize (tamanho do torneio)
 % Linear_Ranking
Op_selection = 'Tournament';
parametroS.TournamentSize = 2;

%tipo de operador crossover:
 % BLX: parametroC.alpha = [0,1]
 % SBX: parametroC.inc = [1,20]
Op_crossover = 'SBX';
parametroC.alpha = 0.3;
parametroC.inc = 2;

%tipo de mutacao:
 % Gaussian
 % Poly: parametroM.inm = [1,20]
Op_mutation = 'Poly';
parametroM.inm = 2;

%tipo de penalizacao
  % Static: parametroP.R
  % Dynamic: 
  % APM
  % Deb
Op_penalty = 'Static';
parametroP.R = 0*10^0;

%estrategia de substituicao(replacement)
R_metodo = 'scheme1';

%rodadas independentes
bestEfficiency_run = zeros(run_max,1);
BestPosition_run = zeros(run_max,nvar);
for run = 1:run_max   
 % Initialization
 empty_individual.Position=[];
 empty_individual.Efficiency=[];
 pop=repmat(empty_individual,nPop,1);
 CV=zeros(1,nPop);
 for i=1:nPop
     % Initialize Position
     for j=1:nvar
         pop(i).Position(j) = random_real(x_bound(j,1),x_bound(j,2)); %gera as pos
     end
     %% Evaluation
     %% chamar acoplamento
     [CL CD] = acoplamento(pop(i).Position)
     eficiencia=[CL CD] %agrupando CL e CD obtidos da iteração no XFOIL
     pop(i).Efficiency = EfficiencyFunction(eficiencia) %jogando CL e CD na funcao objetivo 
     % Violacao das restricoes
     [CV(i)] = Constraints_Violation(pop(i).Position,parametroP,Op_penalty);
 end
 % Penalizacao
 [aux] = Penalty([pop.Efficiency],CV,parametroP,Op_penalty);
 aux=num2cell(aux);
 [pop(:).Efficiency]=deal(aux{:});
 % Sort Population
 [~, SortOrder]=sort([pop.Efficiency],'descend');
 pop=pop(SortOrder); %ordenando a populacao em ordem de custo
 CV=CV(SortOrder);
 % Array to Hold Best Cost Values
 BestEfficiency=zeros(MaxIt,1);
 empty.Position=[];
 BestPosition=repmat(empty,MaxIt,1);
 % Main Loop - geracoes
 for it=1:MaxIt    
     popc=repmat(empty_individual,nc,1); %nc = numeros de pais
     CVc=zeros(1,nc);
     for k=1:nc/2       
        % Select Parents Indices         
        i1 = Selection(pop,parametroS,Op_selection);
        i2 = Selection(pop,parametroS,Op_selection);
        while (i1==i2)
            i2 = Selection(pop,parametroS,Op_selection);
        end   
        % Crossover
        if pc>=rand            
            [popc(2*k-1).Position,popc(2*k).Position] = Crossover(pop(i1).Position,pop(i2).Position,x_bound,parametroC,Op_crossover);    
            % Evaluate Offsprings
            %% chamar acoplamento
            
            [CL CD] = acoplamento(popc(2*k-1).Position)
            eficiencia=[CL CD]
            popc(2*k-1).Efficiency = EfficiencyFunction(eficiencia); %% CALCULANDO EFICIENCIA COM BASE EM POSICOES NAO CL CD!!
            
            [CL CD] = acoplamento(popc(2*k).Position)
            eficiencia=[CL CD]
            popc(2*k).Efficiency = EfficiencyFunction(eficiencia);
            % Violacao das restricoes
            [CVc(2*k-1)] = Constraints_Violation(popc(2*k-1).Position,parametroP,Op_penalty);
            [CVc(2*k)] = Constraints_Violation(popc(2*k).Position,parametroP,Op_penalty);           
        else
            popc(2*k-1) = pop(i1);
            popc(2*k) = pop(i2);
        end        
     end   
     % Mutation
     for k=1:nm         
        if pm >= rand
            popc(k).Position = Mutation(popc(k).Position,x_bound,parametroM,Op_mutation);
            % Evaluate Cost Mutant
            [CL CD] = acoplamento(popc(k).Position)
            eficiencia=[CL CD]
            popc(k).Efficiency = EfficiencyFunction(eficiencia);
            % Violacao das restricoes            
            [CVc(k)] = Constraints_Violation(popc(k).Position,parametroP,Op_penalty);             
        end
     end 
     % Penalizacao
     [aux] = Penalty([popc.Efficiency],CVc,parametroP,Op_penalty);
     aux=num2cell(aux);
     [popc(:).Efficiency]=deal(aux{:});
     
     % Estrategia de substituicao 
     [pop,CV] = Replacement(pop,CV,popc,CVc,nPop,R_metodo,i1,i2);
     
     % Store Best Cost Ever Found
     BestEfficiency(it)=pop(1).Efficiency;
     BestPosition(it).Position=pop(1).Position;    
     
     % Show Iteration Information
     fprintf('Iteration %d : Best Cost = %e : BestPosition =',it,BestEfficiency(it));
     fprintf(saida,'run = %d, Iteration= %d , Best Cost = %16.14e , BestPosition =', run,it,BestEfficiency(it));  
     for j=1:nvar
         fprintf(' %e ',BestPosition(it).Position(j));
         fprintf(saida,' %e ',BestPosition(it).Position(j));
     end
     fprintf('\n');
     fprintf(saida,'\n');  
 end
 
 % Results
 bestEfficiency_run(run) = BestEfficiency(MaxIt);
 BestPosition_run(run,:) = BestPosition(MaxIt).Position;
 figure(2);
 plot(BestEfficiency,'LineWidth',2);
 xlabel('Iteration');
 ylabel('Cl/Cd');
 grid on;
 hold on;
end
fclose(saida);

% analise estatistica
estatistica(bestEfficiency_run);

