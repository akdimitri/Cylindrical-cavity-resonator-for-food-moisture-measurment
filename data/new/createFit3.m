function [fitresult, gof] = createFit3(mean_values, mean_humidity)
%CREATEFIT3(MEAN_VALUES,MEAN_HUMIDITY)
%  Create a fit.
%
%  Data for 'Humidity - Frequency' fit:
%      X Input : mean_values
%      Y Output: mean_humidity
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 27-May-2020 18:35:09


%% Fit: 'Humidity - Frequency'.
[xData, yData] = prepareCurveData( mean_values, mean_humidity );

% Set up fittype and options.
ft = fittype( 'poly3' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'Humidity - Frequency' );
h = plot( fitresult, xData, yData );
legend( h, 'humididty', 'fit curve Humidity - Frequency', 'Location', 'NorthEast' );
% Label axes
xlabel 'Frequency (Hz)'
ylabel 'Humidity %'
grid on

