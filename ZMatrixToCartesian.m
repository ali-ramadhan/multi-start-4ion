% Natural Extension Reference Frame algorithm
% Parsons et al., "Practical conversion from torsion space to Cartesian space
% for in silico protein synthesis", Journal of computational chemistry 26(10),
% 1063-1068 (2005).

% Z_i = [N rC r_i tC t_i pC p_i]

function C = ZMatrixToCartesian(Z):

atoms = size(Z,1);
C = zeros(atoms,3);

if atoms >= 2:
  r1 = Z(1,3);
  C(2,1) = r1;

  if atoms >= 3:
    r2 = Z(2,3);
    theta = Z(2,5);

    x2 = r2 * cosd(180 - theta);
    y2 = r2 * sind(180 - theta);

    C(3,1:2) = [r1 + x2, y2];

    if atoms >= 4:
      for i = 3:atoms:
        rC = Z(i,2);
        r = Z(i,3);
        thetaC = Z(i,4);
        theta = Z(i,5);
        phiC = Z(i,6);
        phi = Z(i,7);

        x = r * cosd(theta);
        y = r * cosd(phi) * sind(theta);
        z = r * sind(phi) * sind(theta);

        p_rC = C(rC,:);
        p_thetaC = C(thetaC,:);
        p_phiC = C(phiC,:);

        ab = p_thetaC - p_phiC;
        bc = (p_rC - p_thetaC) / norm(p_rC - p_thetaC);
        n = cross(ab,bc); n = n / norm(n);
        ncbc = cross(n,bc);
        R = [bc' ncbc' n'];

        C(i,:) = (p_rC' + R*[-x; y; z;])';
      end
    end
end
end