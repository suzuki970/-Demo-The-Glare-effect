function myKeyCheck
% OS�ŋ��ʂ̃L�[�z�u�ɂ���
KbName('UnifyKeyNames');

% ������̃L�[��������Ă��Ȃ���Ԃɂ��邽�߂P�b�قǑ҂�
tic;
while toc < 1; end;

% �����ɂ���L�[�̏�����
DisableKeysForKbCheck([]);

% ��ɉ������L�[�����擾����
[ keyIsDown, secs, keyCode ] = KbCheck;

% ��ɉ�����Ă���i�ƌ댟�m����Ă���j�L�[����������A����𖳌��ɂ���
if keyIsDown 
    fprintf('�����ɂ����L�[������܂�\n');
    keys=find(keyCode) % keyCode�̕\��
    KbName(keys) % �L�[�̖��O��\��
    DisableKeysForKbCheck(keys);
end