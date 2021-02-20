
function pixel_num = pixel_size(dotpitch, visual_angle , visual_range)

% dotpitch = 0.282; %(mm) SMI
% visual_angle = 0.29 %(?�)
% visual_range = 60 %(cm)

visual_angle = visual_angle * (pi/180);   % Degree to radian
a = visual_range * tan(visual_angle); % output = ?�?�cm
a = a * 10;  % cm to mm
disp([num2str(a),'mm'])
pixel_num = a / dotpitch;
end

% atan(3*0.276/10/60)* (180/pi)