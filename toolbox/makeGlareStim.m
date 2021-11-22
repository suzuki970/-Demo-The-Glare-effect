
function funs = makeGlareStim
funs.makeGlareGradation=@makeGlareGradation;
funs.makeGlareGradation_Sparse=@makeGlareGradation_Sparse;
funs.makeGlare2=@makeGlare2;
funs.makeGlareBall = @makeGlareBall;
funs.makeGlareBall_Sparse = @makeGlareBall_Sparse;
funs.makeGlareGradation_Sparse_adjust = @makeGlareGradation_Sparse_adjust;
end

function [glareColors,innerR] = makeGlareGradation(space_xyYVal, ballNum,frameRate,freq1,minL,maxL)

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

function [glareColors,innerR] = makeGlareGradation_Sparse(ballNum,frameRate,freq1,minL,maxL)

outerR = 1000;
innerR = round( (pi*outerR) / ballNum);
innerR = 1000;

freq1_frame=frameRate/(freq1*2);
for iFrame = 1:freq1_frame
    tmp = round(linspace(minL,maxL,innerR/(iFrame*4)));
    tmp = repmat(tmp',1,round(innerR/size(tmp,2)));
    tmp = reshape(tmp',1,size(tmp,1)*size(tmp,2));
    if size(tmp,2) > innerR
        glareColors{iFrame,1} = repmat(tmp(1:innerR),3,1);
    else
        glareColors{iFrame,1} = repmat([tmp ones(1,innerR-size(tmp,2))*maxL],3,1);
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

function [ cercleData ] = makeGlareBall( cfg)

innerR = cfg.innerR;
bgcolor = cfg.bgcolor;
upsilon = cfg.upsilon;

% make alpha value
cercleData = ones(innerR,innerR,4);
cercleData(:,:,4) = 255;

% make circle
for i = 1:innerR
    for j = 1:innerR
        r1 = sqrt((innerR/2 - i)^2 + (innerR/2 - j)^2);
        if r1 > innerR/2
            cercleData(i,j,1:3) = 1;
        end
        if r1 > innerR/2
            cercleData(i,j,4)   = 0;
        end
    end
end

if cfg.method == 1
    if bgcolor(1) == bgcolor(2)
        t = ones(1,innerR)*bgcolor(1);
    else
        t = repmat(bgcolor(1):(bgcolor(2)-bgcolor(1))/(innerR-1):bgcolor(2),3,1);
    end
    t = repmat(t,3,1);
else
    t = linspace(-6,6,innerR);
    t = 1./(1+exp(-upsilon*t));
    
    %     t = linspace(0.001,0.999,innerR);
    %     t = log(t./(1-t));
    %     t = t + t(end);
    %     t = t/max(t);
    if bgcolor(1) == bgcolor(2)
        t = ones(1,innerR)*bgcolor(1);
    else
        t = t*(bgcolor(2) - bgcolor(1)) + bgcolor(1);
    end
    t = repmat(t,3,1);
end

for i = 1:innerR
    temp = find(cercleData(i,:,1) == 1);
    if ~isempty(temp)
        for rgbRoop = 1:3
            cercleData(i,temp,rgbRoop) = t(rgbRoop,i);
        end
    end
end

cercleData = cat(1, ones(1,innerR,4)*bgcolor(2), cercleData);
cercleData = cat(2, ones(innerR+1,1,4)*bgcolor(2), cercleData);

cercleData = cercleData(2:innerR,2:innerR,:);

end


function [ cercleData ] = makeGlareBall_Sparse(cfg)

innerR = cfg.innerR;
bgcolor = cfg.bgcolor;
upsilon = cfg.upsilon;


% make alpha value
cercleData = ones(innerR,innerR,4);
cercleData(:,:,4) = 255;

% make circle
for i = 1:innerR
    for j = 1:innerR
        r1 = sqrt((innerR/2 - i)^2 + (innerR/2 - j)^2);
        if r1 > innerR/2
            cercleData(i,j,1:3) = 1;
        end
        if r1 > innerR/2
            cercleData(i,j,4) = 0;
        end
    end
end


t = round(linspace(bgcolor(1),bgcolor(2),innerR/200));
t = repmat(t',1,round(innerR/size(t,2)));
t = reshape(t',1,size(t,1)*size(t,2));

for i = 1:innerR
    temp = find(cercleData(i,:,1) == 1);
    if ~isempty(temp)
        for rgbRoop = 1:3
            cercleData(i,temp,rgbRoop) = t(1,i);
        end
    end
end

cercleData = cercleData(2:innerR,2:innerR,:);

end

function [glareColors,innerR] = makeGlareGradation_Sparse_adjust(step,minL,maxL)

innerR = 1000;

numSplt = fliplr(round(linspace(3,maxL-minL,step)));

for iFrame = 1:step    
%     tmp = round(linspace(minL,maxL,numSplt(iFrame)));
    tmp = round(linspace(minL,maxL,(step*2)/iFrame));
    tmp = repmat(tmp',1,fix(innerR/size(tmp,2)));
    tmp = reshape(tmp',1,size(tmp,1)*size(tmp,2));
    
    x = round(linspace(1,innerR,size(tmp,2)));
    tmp = round(spline(x,tmp,1:innerR));
    
    glareColors{iFrame,1} = repmat(tmp,3,1);
    
end

end
