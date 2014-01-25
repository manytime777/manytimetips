##BEGIN extract.ps1 ##
#icsのプロパティで始まる行のみを抽出する。また、DESCRIPTION行の値は削除する。
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Get-Content $inputFilePath -Encoding UTF8

#出力オブジェクトを格納する配列（初期値＝空の配列）
$outRecords=@()

#入力オブジェクト配列要素を列挙
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
#出力配列を出力
$outRecords | Out-File $outputFilePath -Encoding UTF8
##END extract.ps1 ##