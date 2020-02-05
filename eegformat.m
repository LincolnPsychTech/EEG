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
head = rectangle(ax, 'Position', [i2n/-2 i2n/-2 i2n i2n], 'Curvature', [1 1], 'FaceColor', 'w');

%% Draw saggital guides
d9  = tricircle(ax, res, [-i2n*0.5 0], [0 i2n/2], [0 -i2n/2], i2n/2);
[d9.XData(d9.XData > 0), d9.YData(d9.XData > 0)] = deal(NaN);
d7  = tricircle(ax, res, [-i2n*0.4 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d5  = tricircle(ax, res, [-i2n*0.3 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d3  = tricircle(ax, res, [-i2n*0.2 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d1  = tricircle(ax, res, [-i2n*0.1 0], [0 i2n/2], [0 -i2n/2], i2n/2);
dz  = line(ax, zeros(size(-i2n/2:i2n/res:i2n/2)), -i2n/2:i2n/res:i2n/2, 'Color', 'k');
d2  = tricircle(ax, res, [i2n*0.1 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d4  = tricircle(ax, res, [i2n*0.2 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d6  = tricircle(ax, res, [i2n*0.3 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d8  = tricircle(ax, res, [i2n*0.4 0], [0 i2n/2], [0 -i2n/2], i2n/2);
d10 = tricircle(ax, res, [i2n*0.5 0], [0 i2n/2], [0 -i2n/2], i2n/2);
[d10.XData(d10.XData < 0), d10.YData(d10.XData < 0)] = deal(NaN);
ver = [d9 d7 d5 d3 d1 dz d2 d4 d6 d8 d10];
verNm = {'9' '7' '5' '3' '1' 'z' '2' '4' '6' '8' '10'};

%% Draw coronal lines
Fp = tricircle(ax, res, [0 i2n*0.4], [i2n/2 i2n*0.5], [-i2n/2 i2n*0.5], i2n/2);
AF = tricircle(ax, res, [0 i2n*0.3], [i2n/2 i2n*0.4], [-i2n/2 i2n*0.4], i2n/2);
F  = tricircle(ax, res, [0 i2n*0.2], [i2n/2 i2n*0.3], [-i2n/2 i2n*0.3], i2n/2);
FC = tricircle(ax, res, [0 i2n*0.1], [i2n/2 i2n*0.2], [-i2n/2 i2n*0.2], i2n/2);
C  = line(ax, -i2n/2:i2n/res:i2n/2, zeros(size(-i2n/2:i2n/res:i2n/2)), 'Color', [0 0 0]);
CP = tricircle(ax, res, [0 -i2n*0.1], [i2n/2 -i2n*0.2], [-i2n/2 -i2n*0.2], i2n/2);
P  = tricircle(ax, res, [0 -i2n*0.2], [i2n/2 -i2n*0.3], [-i2n/2 -i2n*0.3], i2n/2);
PO = tricircle(ax, res, [0 -i2n*0.3], [i2n/2 -i2n*0.4], [-i2n/2 -i2n*0.4], i2n/2);
O  = tricircle(ax, res, [0 -i2n*0.4], [i2n/2 -i2n*0.5], [-i2n/2 -i2n*0.5], i2n/2);
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

    function [obj] = tricircle(ax, res, pt1, pt2, pt3, lim)
        if nargin < 3
            error('Three input points are required.');
        elseif ~isequal(numel(pt1),numel(pt2),numel(pt3),2)
            error('The three input points should all have two elements.')
        end
        pt1 = double(pt1);
        pt2 = double(pt2);
        pt3 = double(pt3);
        epsilon = 0.000000001;
        delta_a = pt2 - pt1;
        delta_b = pt3 - pt2;
        ax_is_0 = abs(delta_a(1)) <= epsilon;
        bx_is_0 = abs(delta_b(1)) <= epsilon;
        % check whether both lines are vertical - collinear
        if ax_is_0 && bx_is_0
            c = [0 0];
            r = -1;
            warning([mfilename ':CollinearPoints'],'Points are on a straight line (collinear).');
            return
        end
        % make sure delta gradients are not vertical
        % swap points to change deltas
        if ax_is_0
            tmp = pt2;
            pt2 = pt3;
            pt3 = tmp;
            delta_a = pt2 - pt1;
        end
        if bx_is_0
            tmp = pt1;
            pt1 = pt2;
            pt2 = tmp;
            delta_b = pt3 - pt2;
        end
        grad_a = delta_a(2) / delta_a(1);
        grad_b = delta_b(2) / delta_b(1);
        % check whether the given points are collinear
        if abs(grad_a-grad_b) <= epsilon
            c = [0 0];
            r = -1;
            warning([mfilename ':CollinearPoints'],'Points are on a straight line (collinear).');
            return
        end
        % swap grads and points if grad_a is 0
        if abs(grad_a) <= epsilon
            tmp = grad_a;
            grad_a = grad_b;
            grad_b = tmp;
            tmp = pt1;
            pt1 = pt3;
            pt3 = tmp;
        end
        % calculate centre - where the lines perpendicular to the centre of
        % segments a and b intersect.
        c(1) = ( grad_a*grad_b*(pt1(2)-pt3(2)) + grad_b*(pt1(1)+pt2(1)) - grad_a*(pt2(1)+pt3(1)) ) / (2*(grad_b-grad_a));
        c(2) = ((pt1(1)+pt2(1))/2 - c(1)) / grad_a + (pt1(2)+pt2(2))/2;
        % calculate radius
        r = norm(c - pt1);
        
        x = c(1)+r*cos(0:2*pi/res:2*pi); % Store x coords
        y = c(2)+r*sin(0:2*pi/res:2*pi); % Store y coord
        i = x.^2 + y.^2 <= lim^2; % Cut off points outside the head
        
        
        obj = line(ax, x(i), y(i), 'Color', 'k'); % Draw line
    end


end
