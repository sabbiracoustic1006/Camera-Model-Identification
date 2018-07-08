function feature = demosaicingfeature(fullname)

%Reading image and sampling according to b.pattern________________________
I = imread(fullname);
S = BayerFilter(I,[2 3;1 2]);

%demosaicing and error calculation________________________________________
Id = demosaicing_v2(S,'neighbor');
E = double(I) - Id;

%quantization and truncation______________________________________________
T = 3; q = 2;
R = (round(E / q));      
R(R > T) = T;
R(R < -T) = -T;

%cooccurrence feature extraction__________________________________________
feature = finalcooccurrence(R);

%repeating the same procedure for bilinear algo___________________________
Id = demosaicing_v2(S,'bilinear');
E = double(I) - Id;

R = (round(E / q));      
R(R > T) = T;
R(R < -T) = -T;

%feature extraction for bilinear algo and features concatenation__________
feature = [feature finalcooccurrence(R)];

end

 
        