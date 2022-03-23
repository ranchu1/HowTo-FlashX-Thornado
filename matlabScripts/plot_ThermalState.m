%% KEY SETTING
%%% Parameters
UnitSolarMass = 5.02785e-34;
K2MeV = 8.6173e-11;

[ Time, X1_cm, X2, X3, ~, ~, Density_gcm3, Temperature_K, Y,...
    SpecificTotalEnergy, Pressure, velx, entropy, shock, ~] ...
    = ReadFluidFields_flashCHK(basenm,id,...
    directory );

enclosedMass = ComputeEnclosedMass( X1_cm, Density_gcm3 );
enclosedMass = enclosedMass * UnitSolarMass;
Temperature_MeV = Temperature_K .* K2MeV;

if( xaxisflag == 'x')
    subplot(2,3,2);
    semilogx(X1_cm.*1.0e-5,log10(Density_gcm3),linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',[num2str(Time*1.0e3,'$t_{sm}$ = %.1f ms'),'']); hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Radius [km]';''},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'log10(Mass Density [g/cm$^{3}$])'},'Interpreter','LaTeX','Fontsize',18);
    lgd = legend('location','southwest','box','off','Interpreter','LaTeX','Fontsize',15);
    lgd.NumColumns = 1;
    xlim([xmin xmax]);
    ylim([5, 15]); yticks([5:2:15]);
    
    subplot(2,3,5);
    semilogx(X1_cm.*1.0e-5,Y,linetype_t,'color',linecolor,'linewidth',linewidth); hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Radius [km]';''},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Electron Fraction'},'Interpreter','LaTeX','Fontsize',18);
    ylim([0.05 0.6]);
    xlim([xmin xmax]);
    
    subplot(2,3,1)
    lightspeed = 3.0e10;
    semilogx(X1_cm.*1.0e-5,velx./lightspeed,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Radius [km]';''},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Velocity [v/c]'},'Interpreter','LaTeX','Fontsize',18);
    ylim([-0.3 0.15]); if( max(velx./lightspeed) < 0.1) ylim auto; end
    xlim([xmin xmax]);
    
    subplot(2,3,6)
    loglog(X1_cm.*1.0e-5,SpecificTotalEnergy,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    legend('location','south');
    xlabel({'Radius [km]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Specific Total Energy [erg/g]'},'Interpreter','LaTeX','Fontsize',18);
    xlim([xmin xmax]);
    
    subplot(2,3,4)
    semilogx(X1_cm.*1.0e-5,Temperature_MeV,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Radius [km]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Temperature [MeV]'},'Interpreter','LaTeX','Fontsize',18);
    xlim([xmin xmax]);
    
    subplot(2,3,3)
    semilogx(X1_cm.*1.0e-5,entropy,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Radius [km]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Entropy [$k_b$]'},'Interpreter','LaTeX','Fontsize',18);
    xlim([xmin xmax]);
    %     ylim([0, 5]);
    
elseif( xaxisflag == 'm')
    subplot(2,3,2);
    plot(enclosedMass,log10(Density_gcm3),linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',[num2str(Time*1.0e3,'$t_{sm}$ = %.1f ms'),'']); hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Enclosed Mass [M$_{\odot}$]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'log10(Mass Density [g/cm$^{3}$])'},'Interpreter','LaTeX','Fontsize',18);
    lgd = legend('location','southwest','box','off','Interpreter','LaTeX','Fontsize',15);
    lgd.NumColumns = 1;
    xlim([0, mmax]);
    ylim([5, 15]); yticks([5:2:15]);
    
    subplot(2,3,5);
    plot(enclosedMass,Y,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']); hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Enclosed Mass [M$_{\odot}$]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Electron Fraction'},'Interpreter','LaTeX','Fontsize',18);
    ylim([0.05 0.6]);
    xlim([0, mmax]);
    
    subplot(2,3,1)
    lightspeed = 3.0e10;
    plot(enclosedMass,velx./lightspeed,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Enclosed Mass [M$_{\odot}$]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Velocity [v/c]'},'Interpreter','LaTeX','Fontsize',18);
    ylim([-0.3 0.15]); if( max(velx./lightspeed) < 0.1) ylim auto; end
    xlim([0, mmax]);
    
    subplot(2,3,6)
    semilogy(enclosedMass,Pressure,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',...
        ['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    legend('location','south');
    xlabel({'Enclosed Mass [M$_{\odot}$]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Pressure'},'Interpreter','LaTeX','Fontsize',18);
    xlim([0, mmax]);
    
    subplot(2,3,4)
    plot(enclosedMass,Temperature_MeV,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Enclosed Mass [M$_{\odot}$]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Temperature [MeV]'},'Interpreter','LaTeX','Fontsize',18);
    xlim([0, mmax]);
    
    subplot(2,3,3)
    plot(enclosedMass,entropy,linetype_t,'color',linecolor,'linewidth',linewidth,...
        'DisplayName',['$\rho_c$ =', num2str(((Density_gcm3(1)+Density_gcm3(2))*0.5),'%1.1e'),'']);hold on;
    set(gca,'FontSize',15);set(gca,'LineWidth',1.2);
    xlabel({'Enclosed Mass [M$_{\odot}$]'},'Interpreter','LaTeX','Fontsize',18);
    ylabel({'Entropy [$k_b$]'},'Interpreter','LaTeX','Fontsize',18);
    xlim([0, mmax]);
    ylim([0, 5]);
    ylim auto
    
    for ifig = 1:6
        subplot(2,3,ifig)
        xticks([0:0.2:mmax]);
    end
end
