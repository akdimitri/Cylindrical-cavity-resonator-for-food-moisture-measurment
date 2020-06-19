function [fitresult, gof] = createFit2(x, DT_mean)
%CREATEFIT2(X,DT_MEAN)
%  Create a fit.
%
%  Data for 'fit curve DF' fit:
%      X Input : x
%      Y Output: DT_mean
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 27-May-2020 18:22:25


%% Fit: 'fit curve DF'.
[xData, yData] = prepareCurveData( x, DT_mean );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'fit curve DF' );
h = plot( fitresult, xData, yData );
legend( h, 'Delat T mean', 'fit curve DT', 'Location', 'East' );
% Label axes
xlabel 'Time in oven (m)'
ylabel 'Delta T'
grid on

