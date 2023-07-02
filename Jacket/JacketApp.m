function JacketApp
% clear; clc; close all force;
screenSize = get(groot,'Screensize');
figSize = [screenSize(3:4).*0.5-screenSize(3:4).*0.75.*0.5,...
    screenSize(4)*0.75*3/2 screenSize(4)*0.75];
app = uifigure('name','JacketApp',...
    'Position',figSize,...%     'Resize','off',...
    'Visible','on');

maingrid = uigridlayout(app,[2 2],'RowHeight',{'1x','19x'},'ColumnWidth',{'1x','2x'});

inputslabel = uilabel(maingrid,'Text','Input Parameters','HorizontalAlignment','center','FontWeight','bold');

visuallabel = uilabel(maingrid,'Text','Visualisation','HorizontalAlignment','center','FontWeight','bold');

inputgrid = uigridlayout(maingrid,[18 2],'ColumnWidth',{'2x','1x'},'Padding',[0 0 0 0]);

visualgrid = uigridlayout(maingrid,[1 1]);

inputtext = {'Beam Fidelity','Leg Diameter','Horizontal Brace Diameter','Cross Brace Diameter',...
    'Number of Legs','Number of Legs in X dir','Number of Legs in Y dir','Horizontal Brace Elevation','Twist',...
    'Jacket Type','Brace Configuration','Top Spacing Length','Bottom Spacing Length','Top Elevation','Bottom Elevation','Top Extension', 'Bottom Extension'};

inputvalue = {10,0.5,0.2,0.2,4,4,3,"[5 20 35 50]",0,'symmetric',"[k x -k 0]",...
    4*2^(1/2),16*2^(1/2),50,0,2,0};

for i = 1:length(inputtext)
    inputlabel(i) = uilabel(inputgrid,'Text',inputtext{i},'HorizontalAlignment','center');
    if isnumeric(inputvalue{i}) && length(inputvalue{i})<2
        typ = 'numeric';
    else
        typ = 'text';
    end
    inputfield(i) = uieditfield(inputgrid,typ,'Value',inputvalue{i},'ValueChangedFcn',{@drawvisual});
end

visuals = uiaxes(visualgrid);
hold(visuals, 'on')
drawvisual;
    function drawvisual(event,handle)
        cla(visuals)
        %% input
        fidelity = inputfield(1).Value;
        lwidth = inputfield(2).Value;
        hwidth = inputfield(3).Value;
        cwidth = inputfield(4).Value;
        nlegs = inputfield(5).Value;
        nlegsx = inputfield(6).Value;
        nlegsy = inputfield(7).Value;
        hbracez = str2num(inputfield(8).Value);
        twist = inputfield(9).Value;
        prismtype = 'symmetric'; % {'symmetric', 'rectangular'}
        config = ["k" "x" "-k" ""]; % {'z' 'k' 'x'}
        lt = 4*2^(1/2);
        lb = 16*2^(1/2);
        lt2 = 8*2^(1/2);
        lb2 = 32*2^(1/2);
        zt = 50;
        zb = 0;
        vlt = 2;
        vlb = 0;
        %% calculate points
        switch prismtype
            case 'symmetric'
                faceangle = linspace(0, 2*pi, nlegs+1);
                rb = lb/(2*sin(pi/nlegs));
                xb = double(rb*cos(faceangle));
                yb = double(rb*sin(faceangle));
                zb = zb.*ones(1,size(xb,2));
                
                rt = lt/(2*sin(pi/nlegs));
                xt = double(rt*cos(faceangle));
                yt = double(rt*sin(faceangle));
                zt = zt.*ones(1,size(xt,2));
                
                [xt, yt] = rotateP([xt;yt],twist,[0;0]);
                
                point0 = [xb;yb;zb];
                point1 = [xt;yt;zt];
                vec = (point1 - point0)./(zt(1));
                xm = [point0(1,:) + hbracez'.*vec(1,:)];
                ym = [point0(2,:) + hbracez'.*vec(2,:)];
                zm = [point0(3,:) + hbracez'.*vec(3,:)];
                
                if vlt > 0
                    xm(end,:) = xt;
                    ym(end,:) = yt;
                end
                if vlb > 0
                    xm(1,:) = xb;
                    ym(1,:) = yb;
                end
        
        %% draw plot
        
        for i = 1:nlegs
            legs{i} = PrismP2P(visuals,fidelity,lwidth,[xb(i) yb(i) zb(i)],[xt(i) yt(i) zt(i)]); %Legs
            if vlt > 0
                vlegst{i} = PrismP2P(visuals,fidelity,lwidth,[xt(i) yt(i) zt(i)],[xt(i) yt(i) zt(i)+vlt]); %VT Legs
            end
            if vlb > 0
                vlegsn{i} = PrismP2P(visuals,fidelity,lwidth,[xb(i) yb(i) zb(i)],[xb(i) yb(i) zb(i)-vlb]); %VB Legs
            end
            
            for j = 1:size(hbracez,2) % Horizontal Braces
                hbraces{j,i} = PrismP2P(visuals,fidelity,hwidth,[xm(j,i) ym(j,i) zm(j,i)],[xm(j,i+1) ym(j,i+1) zm(j,i+1)]);
            end
            
            for j = 1:size(hbracez,2)-1 % Cross Braces 1
                switch config(j)
                    case "z"
                        zbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i) ym(j,i) zm(j,i)],[xm(j+1,i+1) ym(j+1,i+1) zm(j+1,i+1)]);
                    case "-z"
                        zbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j+1,i) ym(j+1,i) zm(j+1,i)],[xm(j,i+1) ym(j,i+1) zm(j,i+1)]);
                    case "x"
                        xbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i) ym(j,i) zm(j,i)],[xm(j+1,i+1) ym(j+1,i+1) zm(j+1,i+1)]);
                        xbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j+1,i) ym(j+1,i) zm(j+1,i)],[xm(j,i+1) ym(j,i+1) zm(j,i+1)]);
                    case "k"
                        kbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[(xm(j,i)+xm(j,i+1))/2 (ym(j,i)+ym(j,i+1))/2 zm(j,i)],[xm(j+1,i) ym(j+1,i) zm(j+1,i)]);
                        kbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[(xm(j,i)+xm(j,i+1))/2 (ym(j,i)+ym(j,i+1))/2 zm(j,i)],[xm(j+1,i+1) ym(j+1,i+1) zm(j+1,i+1)]);
                    case "-k"
                        kbraces1{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i) ym(j,i) zm(j,i)],[(xm(j+1,i)+xm(j+1,i+1))/2 (ym(j+1,i)+ym(j+1,i+1))/2 zm(j+1,i)]);
                        kbraces2{j,i} = PrismP2P(visuals,fidelity,cwidth,[xm(j,i+1) ym(j,i+1) zm(j,i+1)],[(xm(j+1,i)+xm(j+1,i+1))/2 (ym(j+1,i)+ym(j+1,i+1))/2 zm(j+1,i)]);
                end
            end
            
        end
        
        axis(visuals,'vis3d')
        axis(visuals,'off')
        camlight(visuals,'right')
        view(visuals,-45,135)
        zlim(visuals, 2.*[-vlb zt(2)+vlt])
        axis(visuals,'equal')
        
    end
end


end