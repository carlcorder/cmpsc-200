% This function calculates numeric derivatives given sample data y in ROW
% vector form. We assume a uniformly sampled space in x with diff(x) = dx
%
% INPUT: dependent sample data y
% INPUT: sample space width dx
% INPUT: differencing: forward (f), backward (b), central (c) [char] +
%        accuracy order: 2-pt scheme (2), 4-pt scheme (4), 6-pt scheme (6)
% NOTE: this parameter must be specified in combination e.g. f2,c6, etc..
%
% OUTPUT: numeric derivative of y (dy) as a ROW vector

function dy = ndiff(y,dx,schema)

% extract the type of differencing and order of accuracy from the schema
type = schema(1); order = schema(2); n = str2num(order);

valid = {'f2';'f4';'f6';
         'b2';'b4';'b6';
         'c2';'c4';'c6'};
            
% checka schema for valid input
if isempty(find(strcmp(schema,valid)))
    display('error, please check input args');
    return;
end

% difference types
forward  = 'f';
backward = 'b';
central  = 'c';

% forward/backward finite difference table for orders 2,4 & 6
Cf2 = [-3/2 2 -1/2];                        Cb2 = -Cf2;
Cf4 = [-25/12 4 -3 4/3 -1/4];               Cb4 = -Cf4;
Cf6 = [-49/20 6 -15/2 20/3 -15/4 6/5 -1/6]; Cb6 = -Cf6;

% central finite difference table for orders 2,4 & 6
Cc2 = [-1/2 0 1/2];
Cc4 = [1/12 -2/3 0 2/3 -1/12];
Cc6 = [-1/60 3/20 -3/4 0 3/4 -3/20 1/60];

% coefficient structure to hold the data
C = struct('f2',Cf2,'f4',Cf4,'f6',Cf6,...
           'b2',Cb2,'b4',Cb4,'b6',Cb6,...
           'c2',Cc2,'c4',Cc4,'c6',Cc6);

% pre allocate space for dy
dy = zeros(1,length(y));

% forward difference
if strcmp(type,forward)
    c = C.(schema);
    head = conv(y,fliplr(c),'valid');
    % the last order of data points need to be calculated using a backward
    % difference
    tail = conv(y(end - (2*n-1):end),-c,'valid');
    dy = [head tail]./dx;
end

% backward difference
if strcmp(type,backward)
    c = C.(schema);
    tail = conv(y,c,'valid');
    % the first order of data points need to be calculated using a forward
    % difference
    head = conv(y(1:2*n),-fliplr(c),'valid');
    dy = [head tail]./dx;
end

% central difference
if strcmp(type,central)
    c = C.(schema);
    cf = C.(strcat(forward,order));
    cb = C.(strcat(backward,order));
     % the first order/2 of data points need to be calculated using a forward
    % difference
    head = conv(y(1:3/2*n),fliplr(cf),'valid');
    % the middle points can be calculated using a central difference
    body = conv(y,fliplr(c),'valid');
    % the last order/2 of data points need to be calculated using a backward
    % difference
    tail = conv(y(end - (3/2*n-1):end),cb,'valid');
    dy = [head body tail]./dx;
end
   

