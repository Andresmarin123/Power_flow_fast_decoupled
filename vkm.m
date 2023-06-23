function [km1,km2]=vkm(aux,buses,Ybus)
%km1 nodos PQ + PV, km2 nodos PQ
    n=length(Ybus);
    m=length(buses);
    for i=1:n
        if buses(i,3)==1
           x=buses(i,1);
        end
       if buses(i,3)==3
            km2(i,:)=buses(i,1);
       end
    end
    for j=1:m
       if aux(j,1)~=x
            if aux(j,2)~=x
                km1(j,:)=aux(j,:);
            end
       end
    end
    
    filas_no_cero1 = any(km1, 2);
    km1 = km1(filas_no_cero1, :);
    num1=unique(km1(:));
    km1=sort(num1);
    
    filas_no_cero2 = any(km2, 2);
    km2 = km2(filas_no_cero2, :);
    num1=unique(km2(:));
    km2=sort(num1);
    

    
end