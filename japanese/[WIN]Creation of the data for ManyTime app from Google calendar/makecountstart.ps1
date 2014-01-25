##BEGIN makecountstart.ps1 ##
#ソートされた開始時間のファイル入力を変換して、カウント値と開始時間のファイル出力する。
#
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Get-Content $inputFilePath -Encoding UTF8
#グループ化する
$groupedInRecords = $inRecords | Group-Object
#
#入力オブジェクト配列要素を列挙
foreach($inRecord in $groupedInRecords)
{
    $strOutput = ""
    $strOutput += [String]$inRecord.Count + "`t" + $inRecord.Name
    Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
}
##END makecountstart.ps1 ##