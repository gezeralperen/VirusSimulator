close all
clear
clc

%Define Environment
X = [0, 1000];
Y = [0, 1000];
spread_distance = 10;
max_step_size = 20;
infection_time = 100;
infection_chance = 0.2;
allow_i = true; %Can Infected people move?
P = 1000; %Initial Population
p = 0.01; %Initial Infection Percentage
sh = 0; %Stay-home rate


%Create Population
shp = round(P*sh);
ip = round(P*p);

People = [X(1)+rand(P,1)*(X(2)-X(1)),...
    Y(1)+rand(P,1)*(Y(2)-Y(1)),...
    [zeros(P-ip,1);ones(ip,1)],...
    zeros(P,1),...
    [zeros(P-shp,1);ones(shp,1)]];
    
%X    Y   IsInfected  DaysAfterInfection IsStayingHome

Infected = ip;
Healthy = P-ip;
Recovered = 0; 


days = 0;
HIR = [Infected, Recovered, Healthy];
while Infected>0
    Inf = [];
    H = [];
    Rec = [];
    
    %Simulate Environment
    
    %Process Infected
    for k = 1:size(People)
        if People(k,3) == 1
            %Get Infected Position Data
            Inf = [Inf;People(k,:)];
            
            if allow_i && People(k,5) == 0
                %Move Infected
                People(k,1) = People(k,1) + 2*(rand()-0.5)*(max_step_size);
                People(k,2) = People(k,2) + 2*(rand()-0.5)*(max_step_size);

                %Check Movement
                if X(1) > People(k,1)
                    People(k,1) = 2*X(1)-People(k,1);
                end
                if X(2) < People(k,1)
                   People(k,1) = 2*X(2)-People(k,1);
                end

                if Y(1) > People(k,2)
                    People(k,2) = 2*Y(1)-People(k,2);
                end
                if Y(2) < People(k,2)
                   People(k,2) = 2*Y(2)-People(k,2);
                end
            end
            
            
            People(k,4) = People(k,4) + 1;
            if People(k,4) > infection_time
                People(k,4) = 0;
                People(k,3) = -1;
                Recovered = Recovered + 1;
                Infected = Infected - 1;
            end
        end
    end
    
    
    %Process Healthy
    for k = 1:size(People)
        if People(k,3) == 0
            %Get Healthy Position Data
            H = [H;People(k,:)];
            
            %Search for Infected Person in Range
            for j = 1:size(Inf)
                d = sqrt((Inf(j,1)-People(k,1))^2+(Inf(j,2)-People(k,2))^2);
                if d < spread_distance && rand()<infection_chance
                    People(k,3) = 1;
                    Infected = Infected + 1;
                    Healthy = Healthy - 1;
                    break
                end
            end
            
            if People(k,5) == 0
                %Move Healthy
                People(k,1) = People(k,1) + 2*(rand()-0.5)*(max_step_size);
                People(k,2) = People(k,2) + 2*(rand()-0.5)*(max_step_size);

                %Check Movement
                if X(1) > People(k,1)
                    People(k,1) = 2*X(1)-People(k,1);
                end
                if X(2) < People(k,1)
                   People(k,1) = 2*X(2)-People(k,1);
                end

                if Y(1) > People(k,2)
                    People(k,2) = 2*Y(1)-People(k,2);
                end
                if Y(2) < People(k,2)
                   People(k,2) = 2*Y(2)-People(k,2);
                end
            end
            
        end
        
    end
    
    
    %Process Recovered
    for k = 1:size(People)
        if People(k,3) == -1
            %Get Recovered Position Data
            Rec = [Rec;People(k,:)];
            
            if People(k,5) == 0
                %Move Recovered
                People(k,1) = People(k,1) + 2*(rand()-0.5)*(max_step_size);
                People(k,2) = People(k,2) + 2*(rand()-0.5)*(max_step_size);

                %Check Movement
                if X(1) > People(k,1)
                    People(k,1) = 2*X(1)-People(k,1);
                end
                if X(2) < People(k,1)
                   People(k,2) = 2*X(2)-People(k,2);
                end

                if Y(1) > People(k,2)
                    People(k,2) = 2*Y(1)-People(k,2);
                end
                if Y(2) < People(k,2)
                   People(k,2) = 2*Y(2)-People(k,2);
                end
            end
            
        end
    end
    days = days + 1;
    
    %Graph Data
    %Graph Positions
    subplot(1,3,1) 
    xlim(X);
    ylim(Y);
    
    if Healthy>0
    scatter(H(:,1),H(:,2), 5, 'filled', 'MarkerFaceColor',[0.3 0.6 0.4]) ;
    hold on ;
    end
    
    if Infected>0
    scatter(Inf(:,1),Inf(:,2), 5, 'filled','MarkerFaceColor',[0.6 0.4 0.4]) ;
    hold on ;
    end
    
    if Recovered>0
    scatter(Rec(:,1),Rec(:,2), 5, 'filled','MarkerFaceColor',[0.5 0.5 0.6]) ;
    end
    pbaspect([1 1 1])
    axis([X, Y]);
    hold off;
    
    %Graph Rates
    HIR = [HIR; Infected, Recovered, Healthy];
    subplot(1,3,[2,3]);
    h = area(HIR,'LineStyle','none');
    
    try
    h(3).FaceColor = [0.3 0.6 0.4];
    end
    
    try
    h(1).FaceColor = [0.6 0.4 0.4];
    end
    
    try
    h(2).FaceColor = [0.5 0.5 0.6];
    end
    
    axis([1, days+1, 0, P]);
    pbaspect([2 1 1])
    pause(0.2);
    hold off;

end

