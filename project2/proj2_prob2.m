%% Generating the Mandelbrot Set
% set of all values C in the complex plane such that z(n+1) = z(n)^2 + C is
% bounded -> does not go to complex infinity as n -> inf.
% Let z0 = 0 and create the set for -2 < Re(C) < 1 and -1 < Im(C) < 1
%                                                                *                                
% 
%                                             **                                   
%                                          ****** *                                
%                                          ********                                
%                                           *****                                  
%                                     *************** *                            
%                                ***********************  ***                      
%                            *   ****************************                      
%                            ********************************                      
%                            *********************************  *                  
%                           ************************************                   
%            ** ******     ************************************                    
%           *************  ************************************                    
%          *************** ***********************************                     
%      ******************************************************                      
%    ******************************************************                        
%      ******************************************************                      
%          *************** ***********************************                     
%           *************  ************************************                    
%            ** ******     ************************************                    
%                           ************************************                   
%                            *********************************  *                  
%                            ********************************                      
%                            *   ****************************                      
%                                ***********************  ***                      
%                                     *************** *                            
%                                           *****                                  
%                                          ********                                
%                                          ****** *                                
%                                             **                                   
% 
%                                                 *
% inspired by:
% http://blogs.mathworks.com/loren/2011/07/18/a-mandelbrot-set-on-the-gpu/

% parameters
maxIterations = 400;
gridSize = 1e3;
xlim = [-2,1]; ylim = [-1,1];

% setup
x = linspace(xlim(1),xlim(2),gridSize);
y = linspace(ylim(1),ylim(2),gridSize);
% class gpuArray
% x = gpuArray.linspace(xlim(1),xlim(2),gridSize);
% y = gpuArray.linspace(ylim(1),ylim(2),gridSize);

[X,Y] = meshgrid(x,y);
z0 = complex(X,Y);
count = ones(size(z0));
% count = ones(size(z0),'gpuArray');

% calculate
z = z0;
for n = 0:maxIterations
    z = z.*z + z0;
    % if the sequence ever becomes larger than 2, it will escape to
    % infinity
    inside = abs(z) <= 2;
    count = count + inside;
end
count = log(count);
% count = gather(count); % fetch data back from the gpu

% show
figure('name','Mandelbrot Set');
imagesc(x,y,count);
xlabel('$\Re(z)$','interpreter','latex','FontSize',12);
ylabel('$\Im(z)$','interpreter','latex','FontSize',12);
title('$z_{n + 1} = z_{n}^2 + C$','interpreter','latex','FontSize',15);
axis image;
colormap([parula();flipud(parula());0 0 0]);

    