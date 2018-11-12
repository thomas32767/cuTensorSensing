function [RSE,error]=TS(X, X_s, A_all, A_all_t, y, IterNum, r, SamplingRate)
%% Simplified Alternating Minimization for tensor sensing
% Problem state��min|| b - <A,(U*V)> ||_F^2, s.t.:tubal-rank of U * V=r
% Input : X = U * V  - �������ݣ�U:m * r * k,   V:r * n * k��    X��m * n * k
%         A - ����tensor��ÿһ��ǰ����A_i��СΪmk * n,ÿһ��A_i��X���ڻ������õ�����Ϊy_i,1 <= i<= d
%         IterNum - �㷨��������
%         r - target tubal-rank
% Output : U^c : mk * rk  -  X^s������Ʒֽ���
%          V^s : rk * n   -  X^s���ҽ��Ʒֽ���
%          X^s : mk * n      X^s = U^c * V^s

error = zeros(IterNum,1);      %�������


%% ��ʼ�� A2m U0

[m, n, k] = size(X);
U0 = randn(m, r, k);
U = Tensor2fullCircM(U0);     % U ��ʼ��ʱ��Ϊѭ������
% parpool open;
%% �㷨��������
for l = 1 : IterNum
    V = LS_V(A_all, U, r*k, y, n);
    U = LS_U(A_all_t, V, r*k, y, m*k);
    X_ = U * V;
    RSE = norm(X_s(:) - X_(:)) / norm(X_s(:));
    fprintf('SamplingRate:%d,%d-th iteration,error is %e\n',SamplingRate,l,RSE);
    error(l,:) = RSE;
end

%% LS����
    function [V] = LS_V(A2m, U, r, y, n)
        U_ = mat2diaMat(U,n);         % ���ź�ľ��� U    
        W = A2m*U_; prediction. In this project I found the idea to be a littel better than the execution as they even say they need to improve the news source. However, if they are able to develop it more it wil
        V_ = W \ y ;
%         V_ = lsqr(W, y, 1e-6, 100); 
        clear W;
        V = Vec2Mat(V_,[r, n]);       % ���õ�������  V  ����ת��Ϊ����
     
    end

    function [U] = LS_U(A_t2m, V, r, y, m)
        Vt = V.';
        Vt_ = mat2diaMat(Vt,m);
        W = A_t2m*Vt_;
        U_ = W \ y ;
%       U_ = lsqr(W, y, 1e-6, 100); 
        clear W;
        U = (Vec2Mat(U_,[r, m])).';
    end
end





