function funs = makeGlareStim
  funs.makeGlare=@makeGlare;
  funs.makeGlareStim2=@makeGlareStim2;
  funs.makeGlare2=@makeGlare2;
end

function [glareColors,innerR] = makeGlare(space_xyYVal, ballNum,colors_xy,frameRate,freq1,minL,maxL)

outerR = 1000;
innerR = round( (pi*outerR) / ballNum);

freq1_frame=frameRate/(freq1*2);

frameNum = 0:(pi/2)/(round(freq1_frame)-1):pi/2;

% rangeOfLum0 =  round(linspace(1,1,size(frameNum,2)));
% rangeOfLum1 =  round(linspace(innerR,innerR/2,size(frameNum,2)));

rangeOfLum0 =  round(linspace(minL,innerR/2,size(frameNum,2)));
rangeOfLum1 =  round(linspace(maxL,innerR/2,size(frameNum,2)));


for i = 1 : 7
    for lumRoop = 1:size(rangeOfLum0,2)
        for j = 1:3
            space_RGBVal{lumRoop,i}(j,:) = linspace(space_xyYVal{1,i}(j,rangeOfLum0(lumRoop)),space_xyYVal{1,i}(j,rangeOfLum1(lumRoop)),innerR);
        end
    end
end

for i = 1 : 7
    for lumRoop = 1:size(rangeOfLum0,2)
        for j =1:innerR
            t = [space_RGBVal{lumRoop,i}(3,j) space_RGBVal{lumRoop,i}(1,j) space_RGBVal{lumRoop,i}(2,j)];
            glareColors{lumRoop,i}(:,j) =Yxy2sRGB(t);
        end
    end
end
end

function [glareColors,innerR] = makeGlareStim2(ballNum,frameRate,freq1,minL,maxL)

outerR = 1000;
innerR = round( (pi*outerR) / ballNum);

freq1_frame=frameRate/(freq1*2);
for iFrame = 1:freq1_frame
    tmp = round(linspace(0,255,innerR/(iFrame*4)));
    tmp = repmat(tmp',1,round(innerR/size(tmp,2)));
    tmp = reshape(tmp',1,size(tmp,1)*size(tmp,2));
    if size(tmp,2) > innerR
        glareColors{iFrame,1} = repmat(tmp(1:innerR),3,1);
    else
        glareColors{iFrame,1} = repmat([tmp ones(1,innerR-size(tmp,2))*255],3,1);
    end
end

end

function [ cercleData ] = makeGlare2( innerR, conNum, colorFrag, glareColors,bgcolor)

% make alpha value
cercleData = ones(innerR,innerR,4);
cercleData(:,:,4) = 255;

% make circle
for i = 1:innerR
    for j = 1:innerR
        r1 = sqrt((innerR/2 - i)^2 + (innerR/2 - j)^2);
        if r1 > innerR/2
            cercleData(i,j,1:3) = bgcolor(1);
        end
        if r1 > innerR/2
            cercleData(i,j,4)   = 0;
        end
    end
end

t = cell2mat(glareColors(1,conNum));

for i = 1:innerR
    temp = find(cercleData(i,:,1) == 1);
    if ~isempty(temp)
        for rgbRoop = 1:3
            cercleData(i,temp,rgbRoop) = t(rgbRoop,i);
        end
    end
end

cercleData = cat(1, ones(1,innerR,4)*bgcolor(1), cercleData);
cercleData = cat(2, ones(innerR+1,1,4)*bgcolor(1), cercleData);

% for i = 2:innerR
%     for j = 2:innerR
%         for k = 1:3
%             if cercleData(i,j,k) == bgcolor(1)
%                 tmp = 0;
%                 for l = -1:1:1
%                     for m = -1:1:1
%                         tmp = tmp + cercleData(i+l,j+m,k);
%                     end
%                 end
%                 cercleData(i,j,k) = tmp/9;
%             end
%         end
%     end
% end

cercleData = cercleData(2:innerR,2:innerR,:);

end

