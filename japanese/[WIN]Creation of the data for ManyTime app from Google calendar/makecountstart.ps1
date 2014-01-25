##BEGIN makecountstart.ps1 ##
#�\�[�g���ꂽ�J�n���Ԃ̃t�@�C�����͂�ϊ����āA�J�E���g�l�ƊJ�n���Ԃ̃t�@�C���o�͂���B
#
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#����
$inRecords = Get-Content $inputFilePath -Encoding UTF8
#�O���[�v������
$groupedInRecords = $inRecords | Group-Object
#
#���̓I�u�W�F�N�g�z��v�f���
foreach($inRecord in $groupedInRecords)
{
    $strOutput = ""
    $strOutput += [String]$inRecord.Count + "`t" + $inRecord.Name
    Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
}
##END makecountstart.ps1 ##