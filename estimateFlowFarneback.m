function [ dx, dy ] = estimateFlowFarneback(I1, I2) 

[ A1, B1 ] = polyExpand(I1);
[ A2, B2 ] = polyExpand(I2);
disp('Finished polynomial expansion');
[ nr, nc ] = size(I1);

A = (A1 + A2)/2;
dB  = -(B2 - B1)/2;

dx = zeros(nr, nc, 1);
dy = zeros(nr, nc, 1);

AtA = zeros(nr, nc, 2, 2);
AtdB = zeros(nr, nc, 2);

for r = 1:nr
    for c = 1:nc
        Atmp = reshape(A(r, c, : ,:), 2, 2);
        AtA(r, c, : , :) = reshape(Atmp'*Atmp, 1, 1, 2, 2);
        
        dBtmp = reshape(dB(r, c, :), 2, 1);
        AtdB(r, c, :) = reshape(Atmp'*dBtmp, 1, 1, 2);
    end
end

K = 39;
kwidth = (K-1)/2;
w = conv2(normpdf(-19:19, 0, 6), normpdf(-19:19, 0, 6)');
num_pix = nr*nc;
outputted = 0.1;
for r = 1:nr
    for c = 1:nc
        if (r*nc+c > outputted*num_pix) 
            fprintf('Done %d percent', (r*nc+c)/num_pix*100);
            outputted = outputted + 0.1;
        end
        AtAavg = zeros(1, 1, 2, 2);
        AtdBavg = zeros(1, 1, 2);
        
        for dr = -kwidth:kwidth
            for dc = -kwidth:kwidth
                if (r + dr > 1 && r + dr <= nr && c + dc > 1 ...
                    && c + dc <= nc)
                    AtAavg = AtAavg + w(dr+kwidth+1)*AtA(r+dr, c+dc, :, :);
                    AtdBavg = AtdBavg + w(dr+kwidth+1)*AtdB(r+dr, c+dc, :);
                end
            end
        end
        
        AtAavg_tmp = reshape(AtAavg, 2, 2);
        AtdBavg_tmp = reshape(AtdBavg, 2, 1);
        
        d_tmp = AtAavg_tmp\AtdBavg_tmp;
        dx(r, c) = d_tmp(1);
        dy(r, c) = d_tmp(2);
    end
end



end