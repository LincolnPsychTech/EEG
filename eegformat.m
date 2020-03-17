function fig = eegformat(met)
% met = 'byframe' or 'bynode'

%% Initialise window
fig = figure('InnerPosition', [100 100 900 900]);
ax = axes(...
    'Position', [0 0 1 1], ...
    'XLim', [-0.5 0.5], ...
    'YLim', [-0.5 0.5], ...
    'Color', [0.5 0.5 0.5] ...
    );
hold on
i2n = 0.8;
res = max(fig.Position(3:4));
lim = i2n/2;
head = rectangle(ax, 'Position', [i2n/-2 i2n/-2 i2n i2n], 'Curvature', [1 1], 'FaceColor', 'w');

%% Draw saggital guides
d9  = tricircle(ax, res, [-i2n*0.5, 0; 0, i2n/2; 0, -i2n/2], lim);
[d9.XData(d9.XData > 0), d9.YData(d9.XData > 0)] = deal(NaN);
d7  = tricircle(ax, res, [-i2n*0.4, 0; 0, i2n/2; 0, -i2n/2], lim);
d5  = tricircle(ax, res, [-i2n*0.3, 0; 0, i2n/2; 0, -i2n/2], lim);
d3  = tricircle(ax, res, [-i2n*0.2, 0; 0, i2n/2; 0, -i2n/2], lim);
d1  = tricircle(ax, res, [-i2n*0.1, 0; 0, i2n/2; 0, -i2n/2], lim);
dz  = line(ax, zeros(size(-i2n/2:i2n/res:i2n/2)), -i2n/2:i2n/res:i2n/2, 'Color', 'k');
d2  = tricircle(ax, res, [ i2n*0.1, 0; 0, i2n/2; 0, -i2n/2], lim);
d4  = tricircle(ax, res, [ i2n*0.2, 0; 0, i2n/2; 0, -i2n/2], lim);
d6  = tricircle(ax, res, [ i2n*0.3, 0; 0, i2n/2; 0, -i2n/2], lim);
d8  = tricircle(ax, res, [ i2n*0.4, 0; 0, i2n/2; 0, -i2n/2], lim);
d10 = tricircle(ax, res, [ i2n*0.5, 0; 0, i2n/2; 0, -i2n/2], lim);
[d10.XData(d10.XData < 0), d10.YData(d10.XData < 0)] = deal(NaN);
ver = [d9 d7 d5 d3 d1 dz d2 d4 d6 d8 d10];
verNm = {'9' '7' '5' '3' '1' 'z' '2' '4' '6' '8' '10'};

%% Draw coronal lines
Fp = tricircle(ax, res, [0,  i2n*0.4; i2n/2,  i2n*0.5; -i2n/2,  i2n*0.5], lim);
AF = tricircle(ax, res, [0,  i2n*0.3; i2n/2,  i2n*0.4; -i2n/2,  i2n*0.4], lim);
F  = tricircle(ax, res, [0,  i2n*0.2; i2n/2,  i2n*0.3; -i2n/2,  i2n*0.3], lim);
FC = tricircle(ax, res, [0,  i2n*0.1; i2n/2,  i2n*0.2; -i2n/2,  i2n*0.2], lim);
C  = line(ax, -i2n/2:i2n/res:i2n/2, zeros(size(-i2n/2:i2n/res:i2n/2)), 'Color', [0 0 0]);
CP = tricircle(ax, res, [0, -i2n*0.1; i2n/2, -i2n*0.2; -i2n/2, -i2n*0.2], lim);
P  = tricircle(ax, res, [0, -i2n*0.2; i2n/2, -i2n*0.3; -i2n/2, -i2n*0.3], lim);
PO = tricircle(ax, res, [0, -i2n*0.3; i2n/2, -i2n*0.4; -i2n/2, -i2n*0.4], lim);
O  = tricircle(ax, res, [0, -i2n*0.4; i2n/2, -i2n*0.5; -i2n/2, -i2n*0.5], lim);
hor = [Fp AF F FC C CP P PO O];
horNm = {'Fp' 'AF' 'F' 'FC' 'C' 'CP' 'P' 'PO' 'O'};

%% Draw electrode points
for h = hor
    for v = ver
        [rows, dists] = dsearchn( [v.XData' v.YData'], [h.XData' h.YData'] ); % Calculate distances between points of each circle
        i = rows(dists == min(dists)); % Get index of closest point
        hNm = horNm{hor == h};
        vNm = verNm{ver == v};
        if strcmp(hNm, 'C') && any( strcmp(vNm, ['7', '9', '8', '10']) )
            hNm = 'T';
        end
        if strcmp(hNm, 'FC') && any( strcmp(vNm, ['7', '9', '8', '10']) )
            hNm = 'FT';
        end
        if strcmp(hNm, 'CP') && any( strcmp(vNm, ['7', '9', '8', '10']) )
            hNm = 'TP';
        end
        fig.UserData.Nodes.([hNm vNm]) = text(ax, v.XData(i), v.YData(i), [hNm vNm]);
    end
end
fig.UserData.Nodes.A.d1 = text(ax, mean([-i2n/2, -0.5]), 0, 'A1');
fig.UserData.Nodes.A.d2 = text(ax, mean([ i2n/2,  0.5]), 0, 'A2');

set(findobj(ax, 'Type', 'text'), ...
    'BackgroundColor', 'k', ...
    'Color', 'w', ...
    'UserData', struct('RawData', [], 'ProcessedData', []) ...
    );

%% Draw buttons
done = text(ax, i2n/2, -i2n/2, "Done", 'BackgroundColor', 'b', 'Color', 'w', 'ButtonDownFcn', @saveclose);

switch met
    case 'byframe'
        %% Read in data file
        [file path] = uigetfile('*.edf');
        fig.UserData.Model = edfread([path file]);
        set(findobj(ax, 'Type', 'text'), ...
            'ButtonDownFcn', @byframe ...
            );
        time = text(ax, i2n/2, i2n/2, "Time", 'BackgroundColor', 'b', 'Color', 'w', 'ButtonDownFcn', @framespec);
    case 'bynode'
        set(findobj(ax, 'Type', 'text'), ...
            'ButtonDownFcn', @bynode ...
            );
        
        app.UserData.RawData = uiimport;
        cols = fieldnames(app.UserData.RawData);
        dcol = listdlg(...
             'SelectionMode', 'single', ...
             'ListSize', [250 300], ...
             'PromptString', "Which variable contains data?", ...
             'ListString', cols ...
             );
         app.UserData.RawData = app.UserData.RawData.(cols{dcol});
end



%% Functions

    function byframe(app, event)
        
        
    end
    function bynode(app, ~)
        
        
        
        app.UserData.RawData = uiimport;
        app.UserData.ProcessedData = repmat(struct('Time', NaN, 'Sample', NaN), 2, 1);
%         cols = fieldnames(raw);
%         tcol = listdlg(...
%             'SelectionMode', 'single', ...
%             'ListSize', [250 300], ...
%             'PromptString', "Which column of data file is timestamps?", ...
%             'ListString', cols ...
%             );
%         dcol = listdlg(...
%             'SelectionMode', 'single', ...
%             'ListSize', [250 300], ...
%             'PromptString', "Which column of data file is raw electrode data?", ...
%             'ListString', cols ...
%             );
%         if length(raw.(cols{tcol})) ~= length(raw.(cols{dcol}))
%             error("Data and timestamp columns must be the same length");
%         end
%         fcols = cols(1:end ~= tcol & 1:end ~= dcol);
%         if length(cols) > 2
%             ocol = listdlg(...
%                 'SelectionMode', 'multiple', ...
%                 'ListSize', [250 300], ...
%                 'PromptString', "What other columns would you like to include?", ...
%                 'ListString', fcols ...
%                 );
%             for col = ocol
%                 if length(raw.(fcols{col})) ~= length(raw.(cols{tcol})) || length(raw.(fcols{col})) ~= length(raw.(cols{dcol}))
%                     error("Additional columns must match data and time columns in length");
%                 end
%             end
%         else
%             ocol = [];
%         end
%         
%         app.UserData = table(raw.(cols{tcol}), raw.(cols{dcol}), 'VariableNames', ["Time" "EEG"]);
%         for col = ocol
%             app.UserData.(fcols{col}) = raw.(fcols{col});
%         end
        openvar(['fig.UserData.Nodes.' app.String '.UserData.RawData'])
        openvar(['fig.UserData.Nodes.' app.String '.UserData.ProcessedData'])
        app.BackgroundColor = [0 0.5 0.2];
    end

    function saveclose(app, ~)
        nodes = app.Parent.Parent.UserData;
        app.UserData = [];
        for sag = fieldnames(nodes)'
            cor = nodes.(sag{:});
            for c = fieldnames(cor)'
                if ~isempty(cor.(c{:}).UserData)
                    app.Parent.Parent.UserData.(sag{:}).(c{:}) = cor.(c{:}).UserData;
                end
            end
        end
        close(app.Parent.Parent)
    end

    function [obj] = tricircle(ax, res, p, lim)       
        % Differences & Gradients
        delta = diff(p, 1, 1);
        grad = delta(:,2) ./ delta(:,1);
        if any(all( abs(delta) < 1/res, 1 )) % If points are all a straight line...
            error('Cannot draw circle from straight line.'); % Throw an error
        end
        
        % X Center
        if all(~isinf(grad))
            c(1) = prod(grad).*diff( p([1 3],2) ) + grad(1).*(p(2,1)+p(3,1)) - grad(2).*sum(p([2 1],1))./2*diff(grad([2 1]));
        elseif isinf(grad(1))
            c(1) =  grad(2) .* sum( [diff(p([1 3],2)), sum(p([3 2],1))] ) / 2;
        elseif isinf(grad(2))
            c(1) = diff( [sum(p([2 1],1)), grad(1).*diff(p([1 3],2))] ) /2;
        else
            error()
        end
        
        % Y Center
        if grad(1) ~= 0
            c(2) = -1./grad(1).*( c(1)-sum(p([2 1],1))/2 ) + sum(p([2 1],2))/2;
        else
            c(2) = -1./grad(2).*(c(1)-sum(p([3 2],1))/2) + sum(p([2 3],2))/2;
        end
        
        % Radius
        r = norm(c - p(1,:));
        
        % Coords
        x = c(1)+r*cos(0:2*pi/res:2*pi); % Store x coords
        y = c(2)+r*sin(0:2*pi/res:2*pi); % Store y coord
        
        % Remove points outside the head
        i = x.^2 + y.^2 <= lim^2; % Cut off points outside the head
        
        % Draw line
        obj = line(ax, x(i), y(i), 'Color', 'k'); % Draw line
    end


end
