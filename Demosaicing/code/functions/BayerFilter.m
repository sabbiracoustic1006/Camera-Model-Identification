function A = BayerFilter(I, d)

[m,n,~]=size(I);
    
A=zeros(m,n);
    
A(1:2:end,1:2:end)=I(1:2:end,1:2:end,d(1));
A(2:2:end,1:2:end)=I(2:2:end,1:2:end,d(2));
A(1:2:end,2:2:end)=I(1:2:end,2:2:end,d(3));
A(2:2:end,2:2:end)=I(2:2:end,2:2:end,d(4));

end