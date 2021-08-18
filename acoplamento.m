function [CL CD] = acoplamento(pesos)
%ACOP Summary of this function goes here
%   Detailed explanation goes here
%% parametros iniciais
grau = 2;% 

vetor_ksi_extradorso = [0,0,0,0.125,0.25,0.375,0.5,0.625,0.75,0.875,1,1,1]; % nKnots = nPC + grau + 1
vetor_ksi_intradorso = [0,0,0,0.125,0.25,0.375,0.5,0.625,0.75,0.875,1,1,1]; %

pesos_extradorso = pesos(1:10); %nPesos = nPC  
pesos_intradorso = pesos(11:20);
%pesos_intradorso = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; 
%OS PESOS SÓ TEM EFEITO NA PRESENÇA DE UM DELTA (usar TODOS em 5 ou 0.5 gera um mesmo resultado por exemplo)

%ABUSAR DE PESOS CAUSA UM PONTO DE INFLEXAO MUITO ACENTUADO! NAO DESEJADO.

%PONTOS DE CONTROLE POSSUEM UMA INFLUENCIA MUITO MAIOR EM NURBS DO QUE EM
%BEZIER

discretizacao = 80; % discretizacao do aerofolio

pontos_controle_extradorso = [
 -.158416E-01, 0.974978E-09;    
 -.158416E-01, 0.170846E-01;    
 0.331683E-01, 0.420242E-01;    
 0.186139E+00, 0.614653E-01;    
 0.389604E+00, 0.600906E-01;    
 0.594554E+00, 0.465408E-01;    
 0.796535E+00, 0.270997E-01;    
 0.897525E+00, 0.139426E-01;   
 0.949505E+00, 0.903323E-02;    
 0.100000E+01, 0.974978E-09    
] % NACA 0012

pontos_controle_intradorso =[
 -.158416E-01, -0.974978E-09;    
 -.158416E-01, -0.170846E-01;    
 0.331683E-01, -0.420242E-01;    
 0.186139E+00, -0.614653E-01;    
 0.389604E+00, -0.600906E-01;    
 0.594554E+00, -0.465408E-01;    
 0.796535E+00, -0.270997E-01;    
 0.897525E+00, -0.139426E-01;   
 0.949505E+00, -0.903323E-02;    
 0.100000E+01, -0.974978E-09    
]  % NACA 0012


% %% bspline 
% curva_spline1 = bspline(grau, pontos_controle_extradorso, vetor_ksi_extradorso, dominio);
% curva_spline2 = bspline(grau, pontos_controle_intradorso, vetor_ksi_intradorso, dominio); 

    %plots das bases nurbs
% figure(2)
% plot(dominio,base_nurbs1);
% figure(5)
% plot(dominio,base_nurbs2);


[nurbs_extradorso nurbs_intradorso] = geometria(grau, vetor_ksi_extradorso, vetor_ksi_intradorso, discretizacao, pontos_controle_extradorso, pontos_controle_intradorso, pesos_extradorso, pesos_intradorso);


% Gerando a matriz com a geometria do aerofolio
nurbs_extradorso=flip(nurbs_extradorso);
aerofolio=[nurbs_extradorso;nurbs_intradorso]%

%% plots 
    %curvas
% figure(3)
figure(1)
plot(nurbs_extradorso(:,1), nurbs_extradorso(:,2));
hold on
plot(nurbs_intradorso(:,1), nurbs_intradorso(:,2));
grid on
    %pontos de controle
plot(pontos_controle_extradorso(:,1),pontos_controle_extradorso(:,2),'-d');
plot(pontos_controle_intradorso(:,1),pontos_controle_intradorso(:,2),'-d');
    %etc
xlabel('x1');
ylabel('x2');
hold off


%% salvando documento .dat
% fid = fopen('perfil_temp.txt','wt');
% 
% for ii = 1:size(aerofolio,1)
%     fprintf(fid,'%6.4f %12.8f\n',aerofolio(ii,:));
% end
% fclose(fid)


%% Chamando o xfoil 
[pol foil flag] = xfoil(aerofolio,5,50000,0.14,'panels n 80','oper/iter 500')

%% Plot dos outputs xfoil
%figure; 
%plot(pol.alpha,pol.CL); xlabel('alpha [\circ]'); ylabel('C_L'); title(pol.name); grid on; 
% figure; subplot(3,1,[1 2]);
% plot(foil(1).xcp(:,end),foil(1).cp(:,end)); xlabel('x');
% ylabel('C_p'); title(sprintf('%s @ %g\\circ',pol.name,foil(1).alpha(end))); 
% set(gca,'ydir','reverse');
% subplot(3,1,3);
% I = (foil(1).x(:,end)<=1); 
% plot(foil(1).x(I,end),foil(1).y(I,end)); xlabel('x');
% ylabel('y'); axis('equal');  

CL=pol.CL
CD=pol.CD

end

