%% Yxy‚©‚çRGB‚É•ÏŠ·
function rgb = Yxy2sRGB(Yxy)

xyz = [(Yxy(2)/Yxy(3)*Yxy(1));Yxy(1);(Yxy(1)/Yxy(3)*(1-Yxy(2)-Yxy(3)))];

M = [3.240970 -1.537383 -0.498611;
    -0.969244 1.875968 0.041555;
    0.055630 -0.203977 1.056972];
 
rgb = M * xyz;
 
% for i = 1 : 3
%     if rgb(i) <= 0.0031308
%         rgb(1) = rgb(1) * 12.92;
%     else if rgb(i) > 0.0031308
%             rgb(1) = 1.055*rgb(1)^(1/2.4) - 0.055;
%         end
%     end
% end
    
end