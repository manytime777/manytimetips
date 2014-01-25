##BEGIN ics2text.ps1 ##
#�{�̂�ics�\�L��json�\�L�ɕϊ�����B
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#����
$inRecords = Get-Content $inputFilePath -Encoding UTF8

#$count = 0
#���̓I�u�W�F�N�g�z��v�f���
foreach($inRecord in $inRecords)
{
    $anArray = $inRecord.Split(":")
    if ($anArray.Length -gt 2) {
        $output2 = $anArray[1]
        for ($i = 2; $i -lt $anArray.Length; $i++) {
            $output2 = $output2 + '\\:' + $anArray[$i] 
        }
        $newLine = '"' + $anArray[0] + '": "' + $output2  + '",'
        $newLine | Out-File $outputFilePath -Encoding UTF8 -Append
    }
    else {
        $newLine = '"' + $anArray[0] + '": "' + $anArray[1]  + '",'
        $newLine | Out-File $outputFilePath -Encoding UTF8 -Append
    }
}
##END ics2text.ps1 ##