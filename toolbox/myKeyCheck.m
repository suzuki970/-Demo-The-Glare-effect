function myKeyCheck
% OSで共通のキー配置にする
KbName('UnifyKeyNames');

% いずれのキーも押されていない状態にするため１秒ほど待つ
tic;
while toc < 1; end;

% 無効にするキーの初期化
DisableKeysForKbCheck([]);

% 常に押されるキー情報を取得する
[ keyIsDown, secs, keyCode ] = KbCheck;

% 常に押されている（と誤検知されている）キーがあったら、それを無効にする
if keyIsDown 
    fprintf('無効にしたキーがあります\n');
    keys=find(keyCode) % keyCodeの表示
    KbName(keys) % キーの名前を表示
    DisableKeysForKbCheck(keys);
end