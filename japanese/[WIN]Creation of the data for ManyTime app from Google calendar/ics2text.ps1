##BEGIN ics2text.ps1 ##
#本体のics表記をjson表記に変換する。
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Get-Content $inputFilePath -Encoding UTF8

#$count = 0
#入力オブジェクト配列要素を列挙
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