ax1 = subplot(2,5,[1,2,3]);
semilogx(CentralDensity,CentralEntropy,'-',...
    'color',linecolor,'linewidth',linewidth,...
    'marker',linemarker); hold on
xticks([1.0e10,1.0e11,1.0e12,1.0e13,1.0e14]);
xticklabels({'','',''})
ylim([0.4, 2.5]);
ylabel('Entropy');
set(gca,'XGrid','on','XminorGrid','on');
ax1.TickLength = [0.02 0.035];
xlim([1.0e10,2.0e14]);
ylim([0.4, 1.5]);

%%
ax2 = subplot(2,5,[4,5]);
plot(Times.*1.e3,CentralEntropy,'-',...
    'color',linecolor,'linewidth',linewidth,...
    'marker',linemarker);hold on
xticks([0:100:500]);xlim([0, tmax]);
if(Times(end)*1.e3 < 100) xlim([0,Times(end)*1.e3]);end
xticklabels({'','',''})
set(gca,'Box','on');set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','off','YAxisLocation','right');
ax2.TickLength = [0.02 0.035];
ylim([0.7, 1.5]);

%%
ax3 = subplot(2,5,[6,7,8]);
semilogx(CentralDensity,CentralElectronFraction,'-',...
    'color',linecolor,'linewidth',linewidth,...
    'marker',linemarker,...
    'Display','Y$_e$'); hold on;
semilogx(CentralDensity,CentralLeptonFraction,'--',...
    'color',linecolor,'linewidth',linewidth,...
    'marker',linemarker,...
    'Display','Y$_L$');
xticks([1.0e10,1.0e11,1.0e12,1.0e13,1.0e14]);
xlabel('$\rho_{c}$ [g/cm$^{3}$]');
ylabel('Y$_e$, Y$_L$');
ylim([0.15,0.45]);
yticks([0.1:0.05:0.4]);
xlim([1.0e10,3.0e14]);
ax3.TickLength = [0.02 0.035];
legend('Location','southwest','Interpreter','LaTeX');

%%
ax4 = subplot(2,5,[9,10]);
plot(Times.*1.e3,CentralElectronFraction,'-',...
    'color',linecolor,'linewidth',linewidth,...
    'Display','Y$_e$'); hold on;
plot(Times.*1.e3,CentralLeptonFraction,'--',...
    'color',linecolor,'linewidth',linewidth,...
    'Display','Y$_L$');
xlabel('t$_{pb}$ [ms]');
set(gca,'XGrid','on','XMinorGrid','on');set(gca,'YMinorGrid','off');
set(gca,'Box','on','YAxisLocation','right')
ax4.TickLength = [0.02 0.035];
xticks([0:50:500]);
xlim([0,tmax]);
if(Times(end)*1.e3 < 100)
    xlim([0,Times(end)*1.e3]); 
    xticks([0,Times(end)*1.e3]);
end
yticks([0.1:0.05:0.4]);

%%
linkaxes([ax1, ax2], 'y');
linkaxes([ax3, ax4], 'y');
linkaxes([ax1, ax3], 'x');
linkaxes([ax2, ax4], 'x');
