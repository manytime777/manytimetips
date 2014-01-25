##BEGIN sortbystart.ps1 ##
#�����ԃf�[�^�̃t�@�C�����͂�ϊ����āA�\�[�g���ꂽ�J�n���Ԃ̃t�@�C���o�͂���B
#
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#����
$inRecords = Import-Csv -Header Start, End, Comment $inputFilePath -Encoding UTF8 -Delimiter `t
#Start�Ń\�[�g����
$sortedInRecords = $inRecords | sort Start
#
#���̓I�u�W�F�N�g�z��v�f���
foreach($inRecord in $sortedInRecords)
{
    $strOutput = ""
    $strOutput += $inRecord.Start
    Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
}
##END sortbystart.ps1 ##