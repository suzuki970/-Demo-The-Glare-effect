clear all;
close all;

Screen('Preference', 'SkipSyncTests', 1);

%% --------------------paradigm settings------------------
cfg = [];
cfg.TIME_ISI = 2;      % ISI[sec]
cfg.TIME_STIMULUS = 0.5; % stimulus presentation[sec]
cfg.TIME_FIXATION = 1; % fixation time[sec]

cfg.DOT_PITCH =  0.199; % SMI monitor(22 inch, 1680 x 1050 pixels size)
cfg.DOT_PITCH = 0.271;  % Flexscan S2133 (21.3 inch, 1600 x 1200 pixels size)

cfg.FREQUENCY = 2;   % frequency[Hz]
cfg.FRAME_RATE = 60;

cfg.BGCOLOR = 255*ones(1,3);

StimFrames=round(cfg.TIME_STIMULUS * cfg.FRAME_RATE);
%% ----------------------------------------------------

parmSetting();

%% make colors
ballNum = 8;
load('colors_xy.mat')
colors_xy = colors_xy([1 2 6 7 15 17 19],:);

cfg.FREQUENCY_frame = cfg.FRAME_RATE/(cfg.FREQUENCY*2);
outerR = 1000;
innerR = round( (pi*outerR) / ballNum);
frameNum = 0:(pi/2)/(round(cfg.FREQUENCY_frame)-1):pi/2;

rangeOfLum0 =  round(linspace(1,innerR/2,size(frameNum,2)));
rangeOfLum1 =  round(linspace(innerR,innerR/2,size(frameNum,2)));

for i = 1 : 7
    colors_xy(i,3) = 255;
    for j = 1:2
        space_xyYVal{1,i}(j,:) = linspace(colors_xy(i,j),colors_xy(1,j),innerR);
    end
    space_xyYVal{1,i}(3,:) = linspace(1,colors_xy(i,3),innerR);
end

makeGlareStim = makeGlareStim;
for i = 1:size(rangeOfLum0,2)
    [glareColors innerR] = makeGlareStim.makeGlare(space_xyYVal,ballNum,colors_xy,cfg.FRAME_RATE,cfg.FREQUENCY,rangeOfLum0(i),rangeOfLum1(i));
    glareColors(:,[2 3 4 5 6 7])=[];
    allGlareColors(:,i)=glareColors;
end
%
% for i = 1:size(rangeOfLum0,2)
%     [glareColors2 innerR] = makeGlare_gradation2(ballNum,cfg.FRAME_RATE,cfg.FREQUENCY,rangeOfLum0(i),rangeOfLum1(i));
%     allGlareColors(:,i)=glareColors2;
% end

% set empty screen
empty=Screen('OpenOffscreenWindow',screenNumber,cfg.BGCOLOR, [],[],32);

arrayNumFame = [1:(size(allGlareColors,1)*2-1) (size(allGlareColors,1)*2-2):-1:2];
arrayNumFame = repmat(arrayNumFame,1,round(cfg.TIME_STIMULUS));
arrayNumFame = [arrayNumFame 1];

%% stimulus parameter setting
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% make glare stimuli
tmpColArray = [1:size(allGlareColors,1) (size(allGlareColors,1)-1):-1:1];
for i = 1 : size(allGlareColors,2)
    for lumRoop = 1 : size(allGlareColors,1) * 2 -1
        cercleData = makeGlareStim.makeGlare2(innerR, i, 2, allGlareColors(tmpColArray(lumRoop),:),cfg.BGCOLOR);
        
        if lumRoop > size(allGlareColors,1)
            for j = 1:3
                cercleData(:,:,j) = flipud(cercleData(:,:,j));
            end
        end
        cercleTexture(i,lumRoop) = Screen('MakeTexture',win,cercleData);
    end
end

outerR = round( pixel_size( cfg.DOT_PITCH, 6.05 , 70) );
innerR = round( (pi*outerR) / ballNum)-1;
outerR_Center = outerR-5;
outerR = outerR+2;

a = (2*pi)/ballNum;
t = 0 : a : (2*pi-a);
x = outerR .* cos(t);
y = outerR .* sin(t);

len_mov = round(linspace(0,100,(size(allGlareColors,1) * 2 -1)));

for i = 1:(size(allGlareColors,1) * 2 -1)
    x_mov(i,:) = len_mov(i) .* cos(t);
    y_mov(i,:) = len_mov(i) .* sin(t);
end
angle = 0 : (360/ballNum) : 360 + (360/ballNum);
angle = angle + 90;

angle_rot = round(linspace(0,360,(size(allGlareColors,1) * 2 -1)));

for i_color = 1 : size(allGlareColors,2)
    for lumRoop = 1 : size(allGlareColors,1) * 2 -1
        [window_color(i_color,lumRoop),screenRect] = Screen('OpenOffscreenWindow',screenNumber, cfg.BGCOLOR,[],[],32);
        
        Screen('CopyWindow', empty, win);
        
        %% noraml color glare
        Screen('FillOval',win, allGlareColors{1,1}(:,end),[centerX-outerR_Center centerY-outerR_Center centerX+outerR_Center centerY+outerR_Center]);
        
        %% draw the surrounding glare ball
        for j = 1 : ballNum
            if cfg.participantsInfo.mode == 1
                Screen('DrawTexture', win, cercleTexture(i_color,lumRoop),[],[x(j)+centerX-(innerR), y(j)+centerY-(innerR), x(j)+centerX+(innerR), y(j)+centerY+(innerR)],angle(j));
            elseif cfg.participantsInfo.mode == 2
                Screen('DrawTexture', win, cercleTexture(2,1),[],[x(j)+centerX-(innerR), y(j)+centerY-(innerR), x(j)+centerX+(innerR), y(j)+centerY+(innerR)],angle(j)+angle_rot(lumRoop));
            else
                Screen('DrawTexture', win, cercleTexture(1,1),[],[x(j)+centerX-(innerR)+x_mov(lumRoop,j), y(j)+centerY-(innerR)+y_mov(lumRoop,j), x(j)+centerX+(innerR)+x_mov(lumRoop,j), y(j)+centerY+(innerR)+y_mov(lumRoop,j)],angle(j));
            end
        end
        Screen('CopyWindow',win, window_color(i_color,lumRoop));
    end
end

for i_color = 1 : size(allGlareColors,2)
    lumRoop = size(allGlareColors,1) * 2 -1;
    [window_color2(i_color,lumRoop),screenRect] = Screen('OpenOffscreenWindow',screenNumber, cfg.BGCOLOR,[],[],32);
    
    Screen('CopyWindow', empty, win);
    
    %% noraml color glare
    Screen('FillOval',win, allGlareColors{1,1}(:,end),[centerX-outerR_Center centerY-outerR_Center centerX+outerR_Center centerY+outerR_Center]);
    
    %% draw the surrounding glare ball
    for j = 1 : ballNum
        if cfg.participantsInfo.mode == 1
            Screen('DrawTexture', win, cercleTexture(i_color,lumRoop),[],[x(j)+centerX-(innerR), y(j)+centerY-(innerR), x(j)+centerX+(innerR), y(j)+centerY+(innerR)],angle(j));
        elseif cfg.participantsInfo.mode == 2
            Screen('DrawTexture', win, cercleTexture(2,1),[],[x(j)+centerX-(innerR), y(j)+centerY-(innerR), x(j)+centerX+(innerR), y(j)+centerY+(innerR)],angle(j)+angle_rot(lumRoop));
        else
            Screen('DrawTexture', win, cercleTexture(1,1),[],[x(j)+centerX-(innerR)+x_mov(lumRoop,j), y(j)+centerY-(innerR)+y_mov(lumRoop,j), x(j)+centerX+(innerR)+x_mov(lumRoop,j), y(j)+centerY+(innerR)+y_mov(lumRoop,j)],angle(j));
        end
        Screen('CopyWindow',win, window_color2(i_color,lumRoop));
    end
end
Flickering();

sca;
ListenChar(0);
