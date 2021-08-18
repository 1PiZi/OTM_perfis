function curva_nurbs = nurbs(pesos,bspline_base,pontos_controle)
   curva_nurbs = base_nurbs(pesos,bspline_base)*pontos_controle
end