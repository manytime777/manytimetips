##BEGIN extract.ps1 ##
#ics�̃v���p�e�B�Ŏn�܂�s�݂̂𒊏o����B�܂��ADESCRIPTION�s�̒l�͍폜����B
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#����
$inRecords = Get-Content $inputFilePath -Encoding UTF8

#�o�̓I�u�W�F�N�g���i�[����z��i�����l����̔z��j
$outRecords=@()

#���̓I�u�W�F�N�g�z��v�f���
$descriptionString = "DESCRIPTION:"
foreach($inRecord in $inRecords)
{
    if ($inRecord -match "^[A-Z].+") {
        if ($inRecord -match "^DESCRIPTION:") {
            $outRecords += $descriptionString
        }
        else {
            $outRecords += $inRecord
        }
    }
}
#�o�͔z����o��
$outRecords | Out-File $outputFilePath -Encoding UTF8
##END extract.ps1 ##