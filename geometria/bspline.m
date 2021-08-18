function curva_bspline = bspline( grau,pontos_controle,vetor_ksi,dominio)
   curva_bspline = bspline_funcao_base(grau,vetor_ksi,dominio)*pontos_controle
end