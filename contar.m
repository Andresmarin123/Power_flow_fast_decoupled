function [t1,t2,t3]=contar(b)
    PQ=3;t3=0;
    PV=2;t2=0;
    SLACK=1;t1=0;
    n=length(b(:,3));
    
    for i=1:n
       if (b(i,3)==PQ)
           t3=t3+1;
       end
       if (b(i,3)==PV)
           t2=t2+1;
              end
       if (b(i,3)==SLACK)
           t1=t1+1;
       end
    end
end