%ga.montoya44@uniandes.edu.co

clc, clear all, close all

fid = fopen('params.txt');
% Read all lines & collect in cell array
txt = textscan(fid,'%s','delimiter','\n'); 
% Convert string to numerical value
Val = str2double(txt{1}); 


%% Inicio Graficar Nodos
% Posiciones de los nodos---------------------------------------------------  
% Nota: el siguiente proceso se va a hacer como se haría en GAMS.
numNODOS=Val(1);
AREA=100;
RC=40;
dij=0;

%coordenadas iniciales de los nodos.
coorX=999*ones(numNODOS,1);
coorY=999*ones(numNODOS,1);

% genero el primer nodo
coorX(1)=unidrnd(AREA);
coorY(1)=unidrnd(AREA);

% grafico el primer nodo
figure
hold on;

plot(coorX(1), coorY(1), 'o', 'LineWidth',1,'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',7);
x=coorX(1);
y=coorY(1);
text(x+1, y+0.5, num2str(1), 'FontSize',8, 'FontWeight', 'bold', 'Color','k');



%% Proceso que asigna coordenadas a cada nodo conforme el nodo este conectado
%% a algún otro nodo.

%Del nodo 2 en adelante...
for i=2:numNODOS
    
    flag1=1;
    while flag1==1
        coorX(i)=unidrnd(AREA);
        coorY(i)=unidrnd(AREA);
        
        %Por cada nodo nuevo i, chequeamos si hay algún nodo que este
        %conectado a él. Si no, nuevamente se le asignan coordenadas hasta
        %que haya un nodo que este conectado.
        for m=1:numNODOS
            
            if (coorX(m)~= 999 && m~=i)
                
                dij=sqrt( ( coorX(i)-coorX(m) )^2+( coorY(i)-coorY(m) )^2);
                
                %Si hay un nodo m que posea una distancia menor o igual a RC respecto a i, entonces i estaría conectado a la red. 
                if dij<=RC
                    flag1=0;
                    break;
                end                                
                
            end
                        
        end
                        
    end
    
    if(i==numNODOS)
        plot(coorX(i), coorY(i), 'o', 'LineWidth',1,'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',7);
        
    else
        plot(coorX(i), coorY(i), 'o', 'LineWidth',1,'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',7);
    end
    
    %plot(coorX(i), coorY(i), 'o', 'LineWidth',1,'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',7);
    x=coorX(i);
    y=coorY(i);
    text(x+1, y+0.5, num2str(i), 'FontSize',8, 'FontWeight', 'bold', 'Color','k');
            
end


k=1;
%% Pintamos enlaces.
for i=1:numNODOS
    for j=1:numNODOS
        
            dij=sqrt( ( coorX(i)-coorX(j) )^2+( coorY(i)-coorY(j) )^2);
            if(dij<=RC) & i~=j
                vert1(k)=i+","+j;
                matrLinks(i,j)=dij;
                matrAd(i+1,j)=1;
                k=k+1;
                line([coorX(i), coorX(j)], [coorY(i), coorY(j)],'LineStyle',':', 'Color','k', 'LineWidth',1);
                
            else
                matrLinks(i,j)=inf;
                matrAd(i+1,j)=0;
            end
        
    end
end

for i=1:numNODOS
    matrAd(1,i)=i;
end
% final
axis([0 AREA 0 AREA]);

%return;

%% Exportamos a un archivo excel.
A=1;

if A==1
    C=[coorX coorY];
    xlswrite('coordenadas.xlsx', matrAd , 'Hoja1');
    T = table(vert1);
    % Write data to text file
    writetable(T, 's02.edges.dat');
end


