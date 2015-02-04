function show_results(im,on,off,rgcs,fltrs)
%
%

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

edges   = ceil(size(fltrs(1).ON.cntr,1)/2);
im   = im(edges+1:end-edges,edges+1:end-edges);   % crop edges by 1/2 filter width
show_image([1:8],[],im)

for r = 1:length(rgcs.cell_type)
    
    show_image(r+8,[rgcs.cell_type{r} ' ON'],on(r).im)
    show_image(r+12,[rgcs.cell_type{r} ' OFF'],off(r).im)
    
end

% plot sums of ON and OFF responses
figure; hold on;

y = [cell2mat({on.sum}) ; cell2mat({off.sum})]';
b = bar(y);
b(1).FaceColor = [ 206 200 104 ]/255;
b(2).FaceColor = [ 51 127 186 ]/255;

set(gca,'XTick',[1:4],'XTickLabel',rgcs.cell_type);
ylabel('Response Sum'); xlabel('RGC type');
bl = legend(b,'ON','OFF');
set(bl,'Location','NorthWest');
box on;



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

