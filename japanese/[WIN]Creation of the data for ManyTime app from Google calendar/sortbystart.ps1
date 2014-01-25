##BEGIN sortbystart.ps1 ##
#多時間データのファイル入力を変換して、ソートされた開始時間のファイル出力する。
#
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Import-Csv -Header Start, End, Comment $inputFilePath -Encoding UTF8 -Delimiter `t
#Startでソートする
$sortedInRecords = $inRecords | sort Start
#
#入力オブジェクト配列要素を列挙
foreach($inRecord in $sortedInRecords)
{
    $strOutput = ""
    $strOutput += $inRecord.Start
    Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
}
##END sortbystart.ps1 ##