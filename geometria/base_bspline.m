function funcao_base = bspline_funcao_base(grau,vetor_ksi,dominio,pontos_controle)
ordem = grau + 1;
ntotal_knots = size(vetor_ksi,2); %numero total de knots, ou seja, comprimento do vetor ksi
npontos = ntotal_knots-ordem %size(pontos_controle,1)(numero de pontos de controle)
funcao_base = zeros(size(dominio,2), npontos);

for i = 1:size(dominio,2)
  t = dominio(i);
  if t == vetor_ksi(ntotal_knots)    %se t representa o ultimo knot
    j = find(vetor_ksi~=t,1,'last'); %pegar knot imediatamente menor
    transicao = vetor_ksi(j);        %usar ele para efetuar a transicao
    else
    transicao = t;
  end
  % calculo da funcao base de primeira ordem
  temp = zeros(1,ntotal_knots-1);
  for j = 1:ntotal_knots-1
    temp(j) = double(transicao >= vetor_ksi(j) && transicao < vetor_ksi(j+1));
  end

  for p = 2:ordem
    % calculo da funcao base da ordem 2 em diante
    for j = 1:ntotal_knots-p
        %% Separando o calculo de N em duas partes para facilitar 
        parte_1 = 0;
        parte_2 = 0;
            %% Primeira parte
            if temp(j) ~= 0
                parte_1 = ((t-vetor_ksi(j))*temp(j))/(vetor_ksi(j+p-1)-vetor_ksi(j));
            end
            %% Segunda parte
            if temp(j+1) ~= 0
            parte_2 = ((vetor_ksi(j+p)-t)*temp(j+1))/(vetor_ksi(j+p)-vetor_ksi(j+1));
            end
        %% Somando as duas partes
        temp(j) = parte_1+parte_2;
    end
  end
      funcao_base(i,:) = temp(1:npontos);
end

end
