function [nurbs_extradorso nurbs_intradorso] = geometria(grau, vetor_ksi_extradorso, vetor_ksi_intradorso, discretizacao, pontos_controle_extradorso, pontos_controle_intradorso, pesos_extradorso, pesos_intradorso);
%passar dominio

dominio =linspace(min(vetor_ksi_extradorso),max(vetor_ksi_extradorso),discretizacao);

%% funcao base
bspline_base = base_bspline(grau,vetor_ksi_extradorso, dominio,pontos_controle_extradorso);
bspline_base2 = base_bspline(grau,vetor_ksi_intradorso, dominio,pontos_controle_intradorso);

%% base NURBS
base_nurbs1 = base_nurbs(pesos_extradorso,bspline_base);
base_nurbs2 = base_nurbs(pesos_intradorso,bspline_base2);

%% NURBS
nurbs_extradorso = nurbs(pesos_extradorso,bspline_base,pontos_controle_extradorso);
nurbs_intradorso = nurbs(pesos_intradorso,bspline_base,pontos_controle_intradorso);

end

