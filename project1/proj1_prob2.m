%% 2. Maximizing company profits under work constraints
% This is a multi constrained knapsack problem that would ideally be solved
% using combinatorial optimization or some other dynamic programming algorithm.

% Also look at 1) Cross-entropy method 2) Simulated Annealing 3)
% Botev-Kroese method

% Given four products a,b,c & d and that we can make only an integer number
% of each products using three machines: lathe, grinder and a mill, what
% combination of production will maximize profit?

% example if we produce 2(c) + 13(d) -> profit = $7,220. Can we do better?

% machining hours     profit / prod     qty
  lath  = 40;         pa = 380;         a = 0;
  grind = 40;         pb = 340;         b = 0;
  mill  = 40;         pc = 360;         c = 0;
                      pd = 500;         d = 0;
                      
% profit density vector     qty vector          total profit function
profpp = [pa pb pc pd];     qty = [a b c d];    profit = @(x) sum(profpp .* x);

% time requirements for each product on each machine

% product a     product b    product c     product d
  al = 1;       bl = 2;      cl = 0.5;     dl = 3;
  ag = 0.5;     bg = 1.5;    cg = 4;       dg = 1;
  am = 3;       bm = 1;      cm = 5;       dm = 2;

% create a machine information matrix
machine_info = [al bl cl dl lath; ...
                ag bg cg dg grind; ...
                am bm cm dm mill];
            
% this function takes the qty vector and returns a boolean letting us know
% if we have failed to meet any constraints
failed_constraint = @(x) ...
    (sum(machine_info(:,1:end - 1) * x' > machine_info(:,end)));
            
% build a vector of the maximum number of each product we could produce.
% these will be used as limits in our for-loop
max_prod = [];
for k = 1:length(machine_info) - 1
    max_prod = [max_prod floor(min(machine_info(:,end)./machine_info(:,k)))];
end

% initialize maximum profit and optimal production quantities
max_profit = [0];
max_qty = [0 0 0 0];

% loop through every reasonable combination and check our constraints. if
% they are satisfied and the profit is larger, update the max_profit value.
% [13 20 8 13] -> (13 + 1)*(20 + 1)*(8 + 1)*(13 + 1) = 37,044 possible
% combinations that we need to check for
for a = 0:max_prod(1)
    for b = 0:max_prod(2)
        for c = 0:max_prod(3)
            for d = 0:max_prod(4)
                % quantity vector
                qty = [a b c d];
                % if even one constraint is violated, skip to checking
                % other combinations
                if(failed_constraint(qty))
                    continue;
                elseif(profit(qty) > max_profit(end))
                    max_profit = [max_profit; profit(qty)];
                    max_qty = [max_qty; qty];
                end
            end
        end
    end
end
% % maximum profit $8,480 obtained by producing 8(a) + 16(b) + 0(c) + 0(d)
[max_profit max_qty]
% ------------------------alternative solution-----------------------------
% aa = 0:max_prod(1);
% bb = 0:max_prod(2);
% cc = 0:max_prod(3);
% dd = 0:max_prod(4);
% 
% % create a multi dimensional meshgrid of all the possible qty coordinates
% % this way we don't have to use a nested for-loop
% [A B C D] = ndgrid(aa,bb,cc,dd);
% qty_space = [A(:) B(:) C(:) D(:)];
% 
% for i = 1:length(qty_space)
%     qty = qty_space(i,:);
%     if(failed_constraint(qty))
%         continue;
%     elseif(profit(qty) > max_profit(end))
%         max_profit = [max_profit; profit(qty)];
%         max_qty = [max_qty; qty];
%     end
% end
