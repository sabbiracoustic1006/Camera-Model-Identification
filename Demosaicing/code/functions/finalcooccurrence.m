function result = finalcooccurrence(R1)

%getting the range of truncated matrix from range [-3,3] to [1,7]_________
GL = [-3 4];  NL = 7;
slope = NL / (GL(2) - GL(1));
intercept = 1 - (slope*(GL(1)));
si = floor(imlincomb(slope,R1,intercept,'double'));
B = zeros(NL,NL,NL);

%computing intrachannel cooccurrence______________________________________
si1 = si(1:end-1,1:end-1,1); si2 = si(1:end-1,2:end,1); si3 = si(2:end,2:end,1);
subs = [si1(:) si2(:) si3(:)];
A = accumarray(subs, 1);

if numel(A)~=NL^3
    B(1:size(A,1),1:size(A,2),1:size(A,3)) = A;
else
    B = A;
end

B1 = zeros(NL,NL,NL);

%computing interchannel cooccurrence______________________________________
si1 = si(1:end-1,1:end-1,1); si2 = si(1:end-1,2:end,1); si3 = si(1:end-1,2:end,2);
subs = [si1(:) si2(:) si3(:)];
A1 = accumarray(subs, 1); C1 = A1;

si1 = si(2:end,2:end,1); si2 = si(1:end-1,2:end,1); 
subs = [si1(:) si2(:) si3(:)];
A2 = accumarray(subs, 1);
C1(1:size(A2,1),1:size(A2,2),1:size(A2,3)) = A2;
A1 = A1 + C1;

if numel(A)~=NL^3
    B1(1:size(A1,1),1:size(A1,2),1:size(A1,3)) = A1;
else
    B1 = A1;
end


%merging all the cooccurrences____________________________________________
result = [B(:)' B1(:)'];
       
end
 
 