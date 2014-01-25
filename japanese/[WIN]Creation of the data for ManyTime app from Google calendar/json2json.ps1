##BEGIN json2json.ps1 ##
#"TRANSP": "OPAQUE",�̃J���}���㑱�s�������ō폜����B
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
$saveString1 = ""
$saveString2 = ""
foreach($inRecord in $inRecords)
{
    if ($inRecord -match ".+OPAQUE.+") {
        $saveString1 = $inRecord
        $saveString2 = $inRecord -replace(",$", "")
    }
    else {
        if ($inRecord -match "^}") {
            if ($saveString2 -ne "") {
                $outRecords += $saveString2
                $saveString2 = ""
                $saveString1 = ""
            }
        } 
        elseif ($inRecord -match ".+CATEGORIES.+") {
            if ($saveString1 -ne "") {
                $outRecords += $saveString1
                $saveString1 = ""
                $saveString2 = ""
            }
        }
        else {
        }
        $outRecords += $inRecord
    }
}
#�o�͔z����o��
$outRecords | Out-File $outputFilePath -Encoding UTF8
##END json2json.ps1 ##