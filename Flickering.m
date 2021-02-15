

for i_condition = [1:size(allGlareColors,2) size(allGlareColors,2)-1 :-1:1]
    for i = 1 : size(arrayNumFame,2)
        
        if i == size(window_color,2)
            Screen('CopyWindow', window_color2(i_condition, arrayNumFame(i)),win);
            Screen('Flip', win);
        else
            Screen('CopyWindow', window_color(i_condition, arrayNumFame(i)),win);
            Screen('Flip', win);
            
        end
        %         imageArray=Screen('GetImage',win,[],[],0);
        %         imwrite(imageArray,['test_' num2str((i_condition-1) * size(arrayNumFame,2)+i) '.png']);
        clear keyCode;
        [keyIsDown,secs,keyCode]=KbCheck;
        % interrupt by ESC
        if (keyCode(cfg.KEYNAME.escapeKey))
            Screen('CloseAll');
            Screen('ClearAll');
            ListenChar(0);
            sca;
            return
        end
        
    end
end