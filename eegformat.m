function fig = eegformat(met)
% met = 'byframe' or 'bynode'

i2n = 0.8;
[fig, ax] = drawhead(i2n);

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

    function [fig, ax] = drawhead(i2n)
        %% Initialise window
        fig = figure('InnerPosition', [100 100 900 900]);
        ax = axes(...
            'Position', [0 0 1 1], ...
            'XLim', [-0.5 0.5], ...
            'YLim', [-0.5 0.5], ...
            'Color', [0.5 0.5 0.5] ...
            );
        hold on
        res = max(fig.Position(3:4));
        head = rectangle(ax, 'Position', [i2n/-2 i2n/-2 i2n i2n], 'Curvature', [1 1], 'FaceColor', 'w');
        headlim = tricircle(ax, res, [-i2n/2, 0; 0, i2n/2; 0, -i2n/2], []);
        
        
        %% Draw saggital guides
        
        d9  = tricircle(ax, res, [-i2n*0.5, 0; 0, i2n/2; 0, -i2n/2], headlim);
        [d9.XData(d9.XData > 0), d9.YData(d9.XData > 0)] = deal(NaN);
        d7  = tricircle(ax, res, [-i2n*0.4, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d5  = tricircle(ax, res, [-i2n*0.3, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d3  = tricircle(ax, res, [-i2n*0.2, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d1  = tricircle(ax, res, [-i2n*0.1, 0; 0, i2n/2; 0, -i2n/2], headlim);
        dz  = line(ax, zeros(size(-i2n/2:i2n/res:i2n/2)), -i2n/2:i2n/res:i2n/2, 'Color', 'k');
        d2  = tricircle(ax, res, [ i2n*0.1, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d4  = tricircle(ax, res, [ i2n*0.2, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d6  = tricircle(ax, res, [ i2n*0.3, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d8  = tricircle(ax, res, [ i2n*0.4, 0; 0, i2n/2; 0, -i2n/2], headlim);
        d10 = tricircle(ax, res, [ i2n*0.5, 0; 0, i2n/2; 0, -i2n/2], headlim);
        [d10.XData(d10.XData < 0), d10.YData(d10.XData < 0)] = deal(NaN);
        ver = [d9 d7 d5 d3 d1 dz d2 d4 d6 d8 d10];
        verNm = {'9' '7' '5' '3' '1' 'z' '2' '4' '6' '8' '10'};
        
        %% Draw coronal lines
        Fp = tricircle(ax, res, [0,  i2n*0.4; i2n/2,  i2n*0.5; -i2n/2,  i2n*0.5], headlim);
        AF = tricircle(ax, res, [0,  i2n*0.3; i2n/2,  i2n*0.4; -i2n/2,  i2n*0.4], headlim);
        F  = tricircle(ax, res, [0,  i2n*0.2; i2n/2,  i2n*0.3; -i2n/2,  i2n*0.3], headlim);
        FC = tricircle(ax, res, [0,  i2n*0.1; i2n/2,  i2n*0.2; -i2n/2,  i2n*0.2], headlim);
        C  = line(ax, -i2n/2:i2n/res:i2n/2, zeros(size(-i2n/2:i2n/res:i2n/2)), 'Color', [0 0 0]);
        CP = tricircle(ax, res, [0, -i2n*0.1; i2n/2, -i2n*0.2; -i2n/2, -i2n*0.2], headlim);
        P  = tricircle(ax, res, [0, -i2n*0.2; i2n/2, -i2n*0.3; -i2n/2, -i2n*0.3], headlim);
        PO = tricircle(ax, res, [0, -i2n*0.3; i2n/2, -i2n*0.4; -i2n/2, -i2n*0.4], headlim);
        O  = tricircle(ax, res, [0, -i2n*0.4; i2n/2, -i2n*0.5; -i2n/2, -i2n*0.5], headlim);
        hor = [Fp AF F FC C CP P PO O];
        horNm = {'Fp' 'AF' 'F' 'FC' 'C' 'CP' 'P' 'PO' 'O'};
        
        %% Draw electrode points
        for h = hor
            for v = ver
                [rows, dists] = dsearchn( [v.XData' v.YData'], [h.XData' h.YData'] ); % Calculate distances between points of each circle
                i = rows(dists == min(dists)); % Get index of closest point
                hNm = horNm{hor == h};
                vNm = verNm{ver == v};
                if strcmp(hNm, 'C') && any( strcmp(vNm, {'7', '9', '8', '10'}) )
                    hNm = 'T';
                end
                if strcmp(hNm, 'FC') && any( strcmp(vNm, {'7', '9', '8', '10'}) )
                    hNm = 'FT';
                end
                if strcmp(hNm, 'CP') && any( strcmp(vNm, {'7', '9', '8', '10'}) )
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
            delta = diff([p; p(1,:)]);
            pmid = p + 0.5.*delta;
            adj = diff(pmid, 1, 2);
            grad = delta(:,1) ./ delta(:,2);
            
            %% Remove lines with zero or infinite gradients
            i = isfinite(grad) & grad ~= 0;
            if sum(i) ~= 2
                error("Too many horizontal or vertical lines")
            else
                g = grad(i);
                pm = pmid(i,:);
            end
            
            %%
            %xx*g(1) - pm(1,1)*g(1) - pm(1,2) == xx*g(2) - pm(2,1)*g(2) - pm(2,2)
            %xx*g(1) - xx*g(2) == pm(1,1)*g(1) + pm(1,2) - pm(2,1)*g(2) - pm(2,2)
            c(1) = (pm(1,1)*g(1) - pm(2,1)*g(2) + pm(1,2) - pm(2,2)) / (g(1) - g(2));
            c(2) = c(1)*g(1) - pm(1,1)*g(1) - pm(1,2);
            if grad(~i) ~= 0 % If ignored midsaggital was vertical
                c(2) = -c(2);
            end
            
            %% Radius
            r = norm(c - p(1,:)); % Calcualte radius as the x and y difference between the center and the first point
            
            %% Coords
            x = c(1)+r*cos(0:2*pi/res:2*pi); % Store x coords
            y = c(2)+r*sin(0:2*pi/res:2*pi); % Store y coord
            
            %% Remove points outside the head
            if isempty(lim)
                i = true(length(x),1);
            else
                i = inpolygon(x, y, lim.XData, lim.YData);
            end
            %% Draw line
            obj = line(ax, x(i), y(i), 'Color', 'k'); % Draw line
        end
        
    end

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
end
