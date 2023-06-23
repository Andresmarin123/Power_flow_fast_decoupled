function X=factorizacion_matriz(A,b)
    tam=length(A);
    TI=eye(tam);
    Ts=cell(tam,1);
    T=TI;
    for j=1:tam
        for i=1:tam
            if i==j
                T(i,j)=1/A(j,j);
            else
                T(i,j)=-A(i,j)/A(j,j);
            end
            Ts{j}=T;
        end
        A=cell2mat(Ts(j))*A;
        T=TI;
    end
    for n=1:tam
        X=cell2mat(Ts(n))*b;
        b=X;
    end
%Creado por José Andrés Castro Marín 22 de Junio del 2023 a las 2:00 p.m.
end