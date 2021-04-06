function save_figure(fhandle, filename, lineWidth, dimensions, fontSize)
%dimensions: figure dimensions in centimeters [widthcm, hightcm]
%set fontsize to NaN or -1 to keep the current fontsize settings.
obj = findall(fhandle,'type','Text'); set(obj,'FontSize',fontSize)
obj = findall(fhandle,'type','axes'); set(obj,'FontSize',fontSize)
haxes = get(fhandle,'CurrentAxes'); set(haxes,'FontSize',fontSize)
obj = findall(fhandle,'type','Line'); set(obj,'LineWidth',lineWidth)
set(fhandle,'PaperPositionMode','manual');
set(fhandle,'PaperUnits','centimeters');
set(fhandle,'PaperPosition',[1 1 dimensions(1) dimensions(2)]);
try
    print(fhandle,'-depsc',[filename '.eps'])
catch
    warning('Could not save EPS file')
end
saveas(fhandle,filename,'fig')
saveas(fhandle,filename,'png')