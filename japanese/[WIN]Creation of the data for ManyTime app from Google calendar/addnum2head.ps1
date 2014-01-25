##BEGIN addnum2head.ps1 ##
#カウンタ値と開始時間のファイル入力から、開始時間で別入力ファイルを検索して、
#該当した行の先頭に番号を付けたファイルを出力する。
#
#ファイルパスの作成
#入力ファイル
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
#別入力ファイル
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$anotherInputFilePath = Join-Path $filepath2 $args[1]
#出力ファイル
$filepath3 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath3 $args[2]
#
#入力
#カウンタ値と開始時間のファイル入力
$COUNTS = Get-Content $inputFilePath -Encoding UTF8
#別入力ファイル
$MT = Get-Content $anotherInputFilePath -Encoding UTF8
#入力オブジェクト配列要素を列挙
foreach($countstart in $COUNTS)
{
    $anArray = $countstart.split("`t")
    #重複行の個数
    $counter = [int]$anArray[0]
　　#開始時間をパターンとして使う
    $pattern = $anArray[1]
    #別入力ファイルからパターンに合致する行を探す
    $Lines = $MT | Select-String -pattern $pattern
    if ($counter -eq 1) {
        #重複がない
　　　　$Line = $Lines[0]
        #重複がない場合を示すためカウント値を-1にする
        $newLine = "-1`t" + $Line
        Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
    }
    else {
        #重複がある場合カウント値を0以上で付ける。
        $index = 0
        foreach($Line in $Lines) {
            $newLine = [String]$index + "`t" + $Line
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
            $index += 1
        }
    }
}
##END addnum2head.ps1 ##