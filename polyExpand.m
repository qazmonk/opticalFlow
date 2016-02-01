function [ A B ] = polyExpand(I) 
K = 11;
kwidth = (K-1)/2;
I_padded = padarray(I, [kwidth kwidth]);
[nr, nc] = size(I);
A = zeros(nr, nc, 2, 2);
B = zeros(nr, nc, 2);
S = zeros(K*K, 6);
for r = -kwidth:kwidth
    for c = -kwidth:kwidth
        idx = (r+kwidth)+K*(c+kwidth)+1;
        S(idx, 1) = c*c;
        S(idx, 2) = r*r;
        S(idx, 3) = 2*r*c;
        S(idx, 4) = c;
        S(idx, 5) = r;
        S(idx, 6) = 1;
    end
end
[cols, rows] = meshgrid(1:K, 1:K);
idxs = sub2ind(size(I_padded), rows(:), cols(:));
for r = 1:nr
    for c = 1:nc
        ind = sub2ind(size(I_padded), r, c);
        obs = I_padded(idxs + ind-1);
        p = S\double(obs);
        A(r, c, 1, 1) = p(1);
        A(r, c, 2, 2) = p(2);
        A(r, c, 1, 2) = p(3);
        A(r, c, 2, 1) = p(3);
        B(r, c, 1) = p(4);
        B(r, c, 2) = p(5);
    end
end

end