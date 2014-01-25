## BEGIN json2mt.ps1 ##
#Jsonファイル入力を変換して、多時間データをファイル出力する。
#
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Get-Content $inputFilePath -Encoding UTF8 -Raw | ConvertFrom-Json

#出力オブジェクトを格納する配列（初期値＝空の配列）
$outRecords=@() 

#入力オブジェクト配列要素を列挙
foreach($inRecord in $inRecords)
{
    #
    $strUTCStartDT = ""
    $strUTCEndDT = ""
    $startDate = $null
    $endDate = $null
    $allDayFlag = $FALSE
    if ($inRecord.DTSTART -eq $null) {
        #DTSTART;VALUE=DATE
        $startDate = [datetime]::ParseExact($inRecord."DTSTART;VALUE=DATE","yyyyMMdd",$null)
        $strUTCStartDT = $startDate.toUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
        $endDate = [datetime]::ParseExact($inRecord."DTEND;VALUE=DATE","yyyyMMdd",$null)
        $strUTCEndDT = $endDate.toUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
        $allDayFlag = $TRUE
    }
    else {
        #DTSTART
        $startDate = [datetime]::ParseExact($inRecord.DTSTART,"yyyyMMddTHHmmssZ",$null)
        $strUTCStartDT = $startDate.toUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
        $endDate = [datetime]::ParseExact($inRecord.DTEND,"yyyyMMddTHHmmssZ",$null)
        $strUTCEndDT = $endDate.toUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
    }
    #
    if ($strUTCStartDT -eq "1970-01-01 00:00:00") {
        continue
    } 
    else {
        #出力オブジェクト生成
        $properties = @{'Start'= "";
                        'End'= "";
                        'Comment'= ""}
        $outRecord = New-Object PSObject -Prop $properties
        #
        #開始時間と終了時間のローカル時間の計算
        $timeStartTime = $startDate.toLocalTime()
        $timeEndTime = $endDate.toLocalTime()
        #終日イベントの判断の準備
        if ($allDayFlag) {
            $strStartDate = $timeStartTime.ToString("yyyy-MM-dd")
            $strAllDayStartDate = $strStartDate + " 00:00:00"
            #
            $newTimeEndTime = $timeEndTime.AddDays(-1)
            $strEndDate = $newTimeEndTime.ToString("yyyy-MM-dd")
            #$strEndDate = $timeEndTime.ToString("yyyy-MM-dd")
            #
            $strAllDayEndDate = $strEndDate + " 23:59:00"
            #終日イベントの場合
            $outRecord.Start = $strAllDayStartDate
            $outRecord.End = $strAllDayEndDate
            #コロン対応
            $comment = $inRecord.SUMMARY.replace("\:",":")
            $outRecord.Comment = $comment
        }
        else {
            #通常イベントのローカル時間文字列の取得
            $strStartDT = $timeStartTime.ToString("yyyy-MM-dd HH:mm:ss")
            $strEndDT = $timeEndTime.ToString("yyyy-MM-dd HH:mm:ss")
            #出力オブジェクトのプロパティに入力オブジェクトのプロパティ値を代入
            $outRecord.Start = $strStartDT
            $outRecord.End = $strEndDT
            #コロン対応
            $comment = $inRecord.SUMMARY.replace("\:",":")
            $outRecord.Comment = $comment
        }
        #出力オブジェクトを出力オブジェクト配列に追加
        $outRecords += $outRecord
    }
}

#出力オブジェクト配列をCSV形式で出力
$outRecords | Select-Object Start, End, Comment | ConvertTo-Csv -Delimiter "`t" | % {$_.Replace('"','')} | Select -Skip 2 | Out-File $outputFilePath -Encoding UTF8
## END json2mt.ps1 ##