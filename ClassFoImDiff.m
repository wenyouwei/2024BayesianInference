%% First order gradient of the image
%% Example
% clear; clc;close all
% n = 256; m = 256;
% a = rand(n,m,3);
% Rx   = ClassBlurMatrix([1;-1;0], size(a));
% Ry   = ClassBlurMatrix([1 -1 0], size(a));
% 
% tmp1 = Rx * a; tmp2 = Ry * a;
% R = ClassFoImDiff('cir');
% z = R * a;
% tmp3 = z(:,:,:,1); tmp4 = z(:,:,:,2);
% e1 = tmp1 - tmp3; norm(e1(:))
% e2 = tmp2 - tmp4; norm(e2(:))
%% kernel of R'R: [0 -1 0;-1 4 -1;0 -1 0];
% 
% Copyright March. 5, 2020, Dr.WEN You-Wei 
% email: wenyouwei@gmail.com

%% Class
classdef ClassFoImDiff  %first order gradient of the image    
    properties
        scalar        = 1
        transpos      = 0
        boundarycond  = 'cir'
        tgv        = 0
    end
    
    methods
        function ob = ClassFoImDiff(flag)
            if nargin < 1, flag = 'symmetric';   end
            ob.boundarycond = flag;
            ob.transpos     = 0;
            ob.scalar       = 1;
        end
        
        function ob = ctranspose(A) %% written by wenyouwei@gmail.com
            ob       = A;
            ob.transpos = ~A.transpos;
        end
        
        function z = mtimes(a,b)
            if ~isa(a, 'ClassFoImDiff')
                z = b;
                if numel(a) ~= 1
                    error('Wrong, the paramter must be a scalar');
                else
                    z.scalar = a * b.scalar;
                end
                return;
            end
            boundary = a.boundarycond;
            if a.transpos  == 0
                tmp  = zeros(size(b,1)+1,size(b,2)+1,size(b,3));
                tmp(1:end-1,1:end-1,:) = b;
                switch boundary
                    case {'cir','circular'}
                        tmp(end,:,:) = tmp(1,:,:);
                        tmp(:,end,:) = tmp(:,1,:);
                    case {'refl','symmetric'}
                        tmp(end,:,:) = tmp(end-1,:,:);
                        tmp(:,end,:) = tmp(:,end-1,:);
                end
                zy = tmp(2:end,:,:)-tmp(1:end-1,:,:); %kernel [0;-1;1];
                zx = tmp(:,2:end,:)-tmp(:,1:end-1,:); %kernel [0 -1 1]
                %Rx   = ClassBlurMatrix([1;-1;0], [n,m]);
                %Ry   = ClassBlurMatrix([1 -1 0], [n,m]);
                z(:,:,:,1) = zy(:,1:end-1,:);
                z(:,:,:,2) = zx(1:end-1,:,:);
            else
                p1 = b(:,:,:,1); p2 = b(:,:,:,2);
                switch lower(boundary)
                    case {'cir','circular'}
                        v = p2 - circshift(p2,[0 1]); %x-direction
                        u = p1 - circshift(p1,1);     %y-direction
                    case {'refl','symmetric'}
                        zx = p2(:,2:end-1,:) - p2(:,1:end-2,:);
                        v = [p2(:,1,:) zx -p2(:,end,:)];
                        zy = p1(2:end-1, :,:) - p1(1:end-2,:,:);
                        u = [p1(1,:,:); zy;  -p1(end,:,:)];
                end
                z = -v - u;
            end
            if a.scalar ~= 1,    z = a.scalar * z;   end
        end
    end
end