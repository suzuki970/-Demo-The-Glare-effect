warning('off')
rng('shuffle');

% OpenGL
AssertOpenGL;

%%participant's info
prompt = 'Demo? 1:demo -- > ';
demoMode = input(prompt);
if demoMode~=1
    demoMode = false;
else
    demoMode = true;
end

prompt = 'Mode? 1:gradation, 2:rotation, 3:motion -- >';
cfg.participantsInfo.mode = input(prompt);
while 1
    if isempty(cfg.participantsInfo.mode)
        prompt = 'Name is null. try again -- > ';
        cfg.participantsInfo.mode = input(prompt);
    elseif cfg.participantsInfo.mode < 1 || cfg.participantsInfo.mode > 3
        prompt = 'Mode should be from 1 to 3 -- > ';
        cfg.participantsInfo.mode = input(prompt);
    else
        break;
    end
end

% prompt = 'No.?';
% cfg.participantsInfo.no = input(prompt);
% while 1
%     if isempty(cfg.participantsInfo.no)
%         prompt = 'No. is null. try again -- > ';
%         cfg.participantsInfo.no = input(prompt,'s');
%     else
%         break;
%     end
% end
today_date = datestr(now, 30);

% hide a cursor point
HideCursor;
ListenChar(2);
myKeyCheck;

if demoMode
    useEyelink = false;     % eyelink
else
    useEyelink = true;     % eyelink
end

% set KeyInfo
cfg.KEYNAME = [];
cfg.KEYNAME.escapeKey = KbName('q');
cfg.KEYNAME.returnKey = KbName('a');
cfg.KEYNAME.NumKey4 = KbName('4');
cfg.KEYNAME.NumKey6 = KbName('6');

% set screen number
screens=Screen('Screens');
screenNumber=max(screens);
% screenNumber=1;

% making main screen and off screen window
[win, rect] = Screen('OpenWindow',screenNumber, cfg.BGCOLOR);
% , [50, 50, 1000, 600]
[centerX, centerY] = RectCenter(rect);
cfg.rect = [centerX centerY];

%% eyelink on/off: 1 or 2
if useEyelink
    eyelinkSetup();
    edfFile = [cfg.participantsInfo.name '.edf']; % open file to record data to
    status = Eyelink('Openfile', edfFile);
    if status ~= 0
        Screen('CloseAll');
        Screen('ClearAll');
        ListenChar(0);
        sca;
        return
    end
    EyelinkCalibration();
    Initialization();
end