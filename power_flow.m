function [Y,Bi,Bii,P_given,Q_given,delta_P,delta_Q,X1,X2,P_calculated,Q_calculated]=power_flow(itemax,tol,buses,linea)
    Ybus=ybus(linea);
    Y=abs(Ybus);
    [nY, ~] = size(Y);
    Y(~logical(eye(nY)))=-abs(Y(~logical(eye(nY))));
    G=real(Ybus);
    B=imag(Ybus);
    ang=atan(B./G);
    [t1,t2,t3]=contar(buses);
    aux=double([linea(:,2) linea(:,3)]);
    [km1,km2]=vkm(aux,buses,Ybus);
    Bi=zeros(t2+t3);
    Bii=zeros(t3);
    n=length(km1);
    m=length(km2);
    V0=buses(:,2);
    V0(:,2)=[0];
    %En los siguientes ciclos for se calculan las submatrices B' y B''
    for q=1:n
        k1=km1(q);
        for p=1:n
            m1=km1(p);
            Bi(q,p)=-B(k1,m1);
        end
    end
    for q=1:m
        k2=km2(q);
        for p=1:m
            m2=km2(p);
            Bii(q,p)=-B(k2,m2);
        end
    end
    
    %Calculo de las potencias dadas del problema
    for q=1:n
        k1=km1(q);
        P_given(q,:)=(buses(k1,4)-buses(k1,6))/100; %division entre 100 para que sea p.u.
    end
    for p=1:m
        k2=km2(p);
        Q_given(p,:)=(buses(k2,5)-buses(k2,7))/100;
    end
    %Potencias calculadas
    for i=1:n
        P_calculated(i,1)=0;
        for q=1:nY
            k1=km1(i);
            P_calculated(i,1)=P_calculated(i,1)+V0(k1,1)*V0(q,1)*(G(k1,q)*cos(V0(k1,2)-V0(q,2))+B(k1,q)*sin(V0(k1,2)-V0(q,2)));
            %P_calculated(i,1)=P_calculated(i,1)+V0(k1,1)*V0(i,1)*Y(i,k1)*cos(ang(i,k1)-V0(k1,2)-V0(i,2));
        end
    end
    for i=1:m
        Q_calculated(i,1)=0;
        for p=1:nY
            k2=km2(i);
            auxQ=V0(k2,1)*V0(p,1)*(G(k2,p)*sin(V0(k2,2)-V0(p,2))-B(k2,p)*cos(V0(k2,2)-V0(p,2)))
            Q_calculated(i,1)=Q_calculated(i,1)+V0(k2,1)*V0(p,1)*(G(k2,p)*sin(V0(k2,2)-V0(p,2))-B(k2,p)*cos(V0(k2,2)-V0(p,2)))
            %Q_calculated(p,1)=Q_calculated(i,1)-V0(k2,1)*V0(i,1)*Y(i,k2)*sin(ang(i,k2)-V0(k2,2)-V0(i,2));
        end
    end
    delta_P=P_given-P_calculated;
    delta_Q=Q_given-Q_calculated;
    
    A1=Bi;
    A2=Bii;
    b1=delta_P;
    b2=delta_Q;
    X1=factorizacion_matriz(A1,b1);
    X2=factorizacion_matriz(A2,b2);
end