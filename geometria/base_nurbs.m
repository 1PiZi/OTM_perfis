function base_nurbs = base_nurbs(pesos,bspline_base)
    for i = 1:size(bspline_base,1) %eixo Y
        for j = 1:size(bspline_base,2) %eixo X
            %% primeira parte
            dividendo(i,j)=bspline_base(i,j)*pesos(j);
            
            %% segunda parte 
            divisor(i,j)=sum(bspline_base(i,:).*pesos);
            
            %% executando divisao 
            base_nurbs(i,j) = dividendo(i,j)/divisor(i,j);
        end
    end
end
