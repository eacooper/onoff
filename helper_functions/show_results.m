function show_results(im,on,off,rgcs,fltrs)
%
% Visualize results of RGC modeling
%
% INPUT:
%
%       im:     image matrix of linear intensity values
%       on:     structure containing ON pathway RGC responses
%       off:    structure contraining OFF pathway RGC responses
%       rgcs:   structure containng RGC model info
%       fltrs:  structure containing different filters for each RGC type
%
% Emily Cooper, 2015


% plot RGC receptive fields
figure; hold on;
for r = 1:length(rgcs.cell_type)
    
    plot_rgc_rf(r,[rgcs.cell_type{r} ' ON'],fltrs(r).ON.cntr,fltrs(r).ON.sur)
    plot_rgc_rf(r+4,[rgcs.cell_type{r} ' OFF'],fltrs(r).OFF.cntr,fltrs(r).OFF.sur)
    
end


% plot RGC contrast response functions
figure; hold on;
h(1) = plot(100*on(1).crf.cont,on(1).crf.resp,'color',[ 206 200 104 ]/255);
h(2) = plot(100*off(1).crf.cont,off(1).crf.resp,'color',[ 51 127 186 ]/255);
legend(h,'ON','OFF');
xlabel('Weber Contrast');
ylabel('RGC Response');
axis square; box on;


% show ON/OFF images
figure; hold on;
edges   = ceil(size(fltrs(1).ON.cntr,1)/2);          % crop original image to have same dims as RGC output
im      = im(edges+1:end-edges,edges+1:end-edges);   % crop edges by 1/2 filter width
show_image([1:8],[],im)

for r = 1:length(rgcs.cell_type)
    
    show_image(r+8,[rgcs.cell_type{r} ' ON'],on(r).im)
    show_image(r+12,[rgcs.cell_type{r} ' OFF'],off(r).im)
    
end


% plot sums of ON and OFF responses
figure; hold on;
y       = [cell2mat({on.sum}) ; cell2mat({off.sum})]';                          % concat sum of on and off activity for each pathway
y(5,1)  = (9*sum(cell2mat({on(1:2).sum})) + sum(cell2mat({on(3:4).sum})))/20;   % weighted average bars with 9x more P pathway ...
y(5,2)  = (9*sum(cell2mat({off(1:2).sum})) + sum(cell2mat({off(3:4).sum})))/20; % fovea and perihpery treated equally

b = bar(y);
set(b(1), 'FaceColor', [ 206 200 104 ]/255);
set(b(2), 'FaceColor', [ 51 127 186 ]/255);

set(gca,'XTick',[1:5],'XTickLabel',[rgcs.cell_type 'Weighted Ave'] );
ylabel('Response Sum'); xlabel('RGC type');
bl = legend(b,'ON','OFF');
set(bl,'Location','NorthWest');
box on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_rgc_rf(plt,ttl,cntr,sur)

subplot(2,4,plt); hold on;
title(ttl);
surf(cntr - sur,'EdgeColor','none');
colormap(jet);
axis square tight off
view([-6 1]);

function show_image(plt,ttl,im)

subplot(4,4,plt); hold on;
title(ttl);
imagesc(im);
colormap(gray);
axis image off;


