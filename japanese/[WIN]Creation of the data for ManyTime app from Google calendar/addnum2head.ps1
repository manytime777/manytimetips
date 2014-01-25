##BEGIN addnum2head.ps1 ##
#�J�E���^�l�ƊJ�n���Ԃ̃t�@�C�����͂���A�J�n���Ԃŕʓ��̓t�@�C�����������āA
#�Y�������s�̐擪�ɔԍ���t�����t�@�C�����o�͂���B
#
#�t�@�C���p�X�̍쐬
#���̓t�@�C��
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
#�ʓ��̓t�@�C��
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$anotherInputFilePath = Join-Path $filepath2 $args[1]
#�o�̓t�@�C��
$filepath3 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath3 $args[2]
#
#����
#�J�E���^�l�ƊJ�n���Ԃ̃t�@�C������
$COUNTS = Get-Content $inputFilePath -Encoding UTF8
#�ʓ��̓t�@�C��
$MT = Get-Content $anotherInputFilePath -Encoding UTF8
#���̓I�u�W�F�N�g�z��v�f���
foreach($countstart in $COUNTS)
{
    $anArray = $countstart.split("`t")
    #�d���s�̌�
    $counter = [int]$anArray[0]
�@�@#�J�n���Ԃ��p�^�[���Ƃ��Ďg��
    $pattern = $anArray[1]
    #�ʓ��̓t�@�C������p�^�[���ɍ��v����s��T��
    $Lines = $MT | Select-String -pattern $pattern
    if ($counter -eq 1) {
        #�d�����Ȃ�
�@�@�@�@$Line = $Lines[0]
        #�d�����Ȃ��ꍇ���������߃J�E���g�l��-1�ɂ���
        $newLine = "-1`t" + $Line
        Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
    }
    else {
        #�d��������ꍇ�J�E���g�l��0�ȏ�ŕt����B
        $index = 0
        foreach($Line in $Lines) {
            $newLine = [String]$index + "`t" + $Line
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
            $index += 1
        }
    }
}
##END addnum2head.ps1 ##