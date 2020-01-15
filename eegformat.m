function data = eegformat()

fig = figure('InnerPosition', [200 200 500 500]);
ax = axes(...
    'Position', [0 0 1 1], ...
    'XLim', [-0.5 0.5], ...
    'YLim', [-0.5 0.5], ...
    'Color', [0 0 0] ...
    );
hold on
i2n = 0.8;
res = fig.Position(3:4);
head = rectangle(ax, 'Position', [i2n/-2 i2n/-2 i2n i2n], 'Curvature', [1 1], 'FaceColor', 'w');

d9  = tricircle(ax, res, [-i2n*0.5 0], [0 i2n/2], [0 -i2n/2]);
d7  = tricircle(ax, res, [-i2n*0.4 0], [0 i2n/2], [0 -i2n/2]);
d5  = tricircle(ax, res, [-i2n*0.3 0], [0 i2n/2], [0 -i2n/2]);
d3  = tricircle(ax, res, [-i2n*0.2 0], [0 i2n/2], [0 -i2n/2]);
d1  = tricircle(ax, res, [-i2n*0.1 0], [0 i2n/2], [0 -i2n/2]);
dz  = line(ax, zeros(size(-i2n/2:i2n/res(2):i2n/2)), -i2n/2:i2n/res(2):i2n/2, 'Color', 'k');
d2  = tricircle(ax, res, [i2n*0.1 0], [0 i2n/2], [0 -i2n/2]);
d4  = tricircle(ax, res, [i2n*0.2 0], [0 i2n/2], [0 -i2n/2]);
d6  = tricircle(ax, res, [i2n*0.3 0], [0 i2n/2], [0 -i2n/2]);
d8  = tricircle(ax, res, [i2n*0.4 0], [0 i2n/2], [0 -i2n/2]);
d10 = tricircle(ax, res, [i2n*0.5 0], [0 i2n/2], [0 -i2n/2]);
ver = [d9 d7 d5 d3 d1 dz d2 d4 d6 d8 d10];
verNm = ["d9" "d7" "d5" "d3" "d1" "dz" "d2" "d4" "d6" "d8" "d10"];

Fp = tricircle(ax, res, [0 i2n*0.4], [i2n/2 i2n*0.5], [-i2n/2 i2n*0.5]);
AF = tricircle(ax, res, [0 i2n*0.3], [i2n/2 i2n*0.4], [-i2n/2 i2n*0.4]);
F  = tricircle(ax, res, [0 i2n*0.2], [i2n/2 i2n*0.3], [-i2n/2 i2n*0.3]);
FC = tricircle(ax, res, [0 i2n*0.1], [i2n/2 i2n*0.2], [-i2n/2 i2n*0.2]);
C  = line(ax, -i2n/2:i2n/res(2):i2n/2, zeros(size(-i2n/2:i2n/res(2):i2n/2)), 'Color', [0 0 0]);
CP = tricircle(ax, res, [0 -i2n*0.1], [i2n/2 -i2n*0.2], [-i2n/2 -i2n*0.2]);
P  = tricircle(ax, res, [0 -i2n*0.2], [i2n/2 -i2n*0.3], [-i2n/2 -i2n*0.3]);
PO = tricircle(ax, res, [0 -i2n*0.3], [i2n/2 -i2n*0.4], [-i2n/2 -i2n*0.4]);
O  = tricircle(ax, res, [0 -i2n*0.4], [i2n/2 -i2n*0.5], [-i2n/2 -i2n*0.5]);
hor = [Fp AF F FC C CP P PO O];
horNm = ["Fp" "AF" "F" "FC" "C" "CP" "P" "PO" "O"];

nodes = [];
for h = hor
    for v = ver
        i = ismembertol(h.XData', v.XData', 2*pi/res(1), 'ByRows', true) & ismembertol(h.YData', v.YData', 2*pi/res(2), 'ByRows', true);
        [h.XData(i)',h.YData(i)', v.XData(i)',v.YData(i)']
        [~, i] = min(abs(coords(:,1)) + abs(coords(:,2)));
        hNm = horNm(h == hor);
        vNm = verNm(v == ver);
        nodes.(hNm).(vNm) = scatter(coords(i,1), coords(i,2));
    end
end
