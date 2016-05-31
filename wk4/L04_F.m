%% Working with ANSUR (anthroprometric/body length measurements) datasets
% in the male military population (1775 people)

% warning could not start Excel server for import, basic mode will be used
% start at 2 to skip the header
% height
stature = xlsread('ansur_men.xlsx','A2:A1775');
% forearm length
forearm = xlsread('ansur_men.xlsx','B2:B1775');
% foot length
foot = xlsread('ansur_men.xlsx','C2:C1775');
% ear length
ear = xlsread('ansur_men.xlsx','D2:D1775');
% head circumfrence
head = xlsread('ansur_men.xlsx','E2:E1775');

ft = fittype('poly1');
[F1, gof1] = fit(stature, forearm, ft);
[F2, gof2] = fit(stature, foot, ft);
[F3, gof3] = fit(stature, ear, ft);
[F4, gof4] = fit(stature, head, ft);

st = linspace(min(stature), max(stature), 1e3);

% can we predict stature given the four other measurements?
% stature vs other features

subplot(2,2,1);
plot(stature, forearm, 'k.'); grid on; hold on;
xlabel('Stature [mm]'); ylabel('Forearm Length [mm]');
plot(st, F1(st),'g--');

subplot(2,2,2);
plot(stature, foot, 'k.'); grid on; hold on;
xlabel('Stature [mm]'); ylabel('Foot Length [mm]');
plot(st, F2(st),'g--');

subplot(2,2,3);
plot(stature, ear, 'k.'); grid on; hold on;
xlabel('Stature [mm]'); ylabel('Ear Length [mm]');
plot(st, F3(st),'g--');

subplot(2,2,4);
plot(stature, head, 'k.'); grid on; hold on;
xlabel('Stature [mm]'); ylabel('Head Circumfrence [mm]');
plot(st, F4(st),'g--');

% so stature is a good indicator of forearm and foot length but not ear
% length and head circumfrence. We can use this to estimate our shoe size

h = (5*12 + 6)*25.4; % height in mm
shoe = F2(h)/25.4; % shoe size

