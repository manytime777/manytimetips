##BEGIN mt2json.ps1 ##
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]
#UTF8エンコーディング指定をして読み込み
$inRecords = Import-Csv -Header Start, End, Comment $inputFilePath -Encoding UTF8 -Delimiter `t

#出力オブジェクトを格納する配列（初期値＝空の配列）
$outRecords=@() 

#入力オブジェクト配列要素を列挙
foreach($inRecord in $inRecords)
{
    #現在時間の文字列を取得
    $currentTime = Get-Date
    $strUTCCurrentTime = $currentTime.toUniversalTime().ToString("yyyyMMddTHHmmssZ")
    #開始時間と終了時間のローカル時間の計算
    $timeStartTime = [datetime]::ParseExact($inRecord.Start,"yyyy-MM-dd HH:mm:ss",$null)
    $timeEndTime = [datetime]::ParseExact($inRecord.End,"yyyy-MM-dd HH:mm:ss",$null)
    #終日イベントの判断の準備
    $days = ($timeEndTime - $timeStartTime).Days
    $hours = ($timeEndTime - $timeStartTime).Hours
    $mins = ($timeEndTime - $timeStartTime).Minutes
    $seconds = ($timeEndTime - $timeStartTime).Seconds
    $allDayFlag = $FALSE
    #多時間データの出力
    if (($timeStartTime.Hour -eq 0) -and ($timeStartTime.Minute -eq 0) -and ($timeStartTime.Second -eq 0) -and
            ($days -ge 0) -and ($hours -eq 23) -and ($mins -eq 59) -and ($seconds -eq 0)) {
        #終日イベント
        $allDayFlag = $TRUE
    }
    else {
        #通常イベント
        $allDayFlag = $FALSE
    }
    #開始時間と終了時間のローカル時間の計算
    $startDate = [datetime]::ParseExact($inRecord.Start,"yyyy-MM-dd HH:mm:ss",$null)
    $endDate = [datetime]::ParseExact($inRecord.End,"yyyy-MM-dd HH:mm:ss",$null)
    $timeStartTime = $startDate.toLocalTime()
    $timeEndTime = $endDate.toLocalTime()
    #終日イベントの判断の準備
    if ($allDayFlag) {
        #出力オブジェクト生成
        $properties = @{
                        'BEGIN'='VEVENT';
                        'DTSTART;VALUE=DATE'= "";
                        'DTEND;VALUE=DATE'= "";
                        'DTSTAMP'="";
                        'ORGANIZER'="";
                        #'UID'='manytime@777.so-net.ne.jp';
                        'UID'="";
                        'CREATED'="";
                        'DESCRIPTION'="";
                        'LAST-MODIFIED'="";
                        'LOCATION'="";
                        'SEQUENCE'='0';
                        'STATUS'='CONFIRMED';
                        'SUMMARY'= "";
                        'TRANSP'='TRANSPARENT';
                        'END'='VEVENT'
                        }
        $outRecord = New-Object PSObject -Prop $properties
        #終日イベントのローカル時間文字列の取得
        $strAllDayStartDate = $timeStartTime.ToString("yyyyMMdd")
        $strAllDayEndDate = ""
        if ($days -eq 0) {
            #開始時間と終了時間が同じ。日付の1日後
            $strAllDayEndDate = $timeStartTime.AddDays(1).ToString("yyyyMMdd")
        }
        else {
            #開始時間と終了時間が違う。
            $strAllDayEndDate = $timeEndTime.ToString("yyyyMMdd")
        }
        #終日イベントの開始時間、終了時間、コメントを出力オブジェクトに設定
        $outRecord.'DTSTART;VALUE=DATE' = $strAllDayStartDate
        $outRecord.'DTEND;VALUE=DATE' = $strAllDayEndDate
        $outRecord.SUMMARY = $inRecord.Comment
    }
    else {
        #出力オブジェクト生成
        $properties = @{
                        'BEGIN'='VEVENT';
                        'DTSTART'= "";
                        'DTEND'= "";
                        'DTSTAMP'="";
                        'ORGANIZER'="";
                        #'UID'='manytime@777.so-net.ne.jp';
                        'UID'="";
                        'CREATED'="";
                        'DESCRIPTION'="";
                        'LAST-MODIFIED'="";
                        'LOCATION'="";
                        'SEQUENCE'='0';
                        'STATUS'='CONFIRMED';
                        'SUMMARY'= "";
                        'TRANSP'='TRANSPARENT';
                        'END'='VEVENT'
                        }
        $outRecord = New-Object PSObject -Prop $properties
        #通常イベントのUTC時間文字列の取得
        $strUTCStartDT = $startDate.toUniversalTime().ToString("yyyyMMddTHHmmssZ")
        $strUTCEndDT = $endDate.toUniversalTime().ToString("yyyyMMddTHHmmssZ")
        #通常イベントの開始時間、終了時間、コメントを出力オブジェクトに設定
        $outRecord.DTSTART= $strUTCStartDT
        $outRecord.DTEND = $strUTCEndDT
        $outRecord.SUMMARY = $inRecord.Comment
    }
    $outRecord.DTSTAMP = $strUTCCurrentTime
    $outRecord.'LAST-MODIFIED' = $strUTCCurrentTime
    $outRecord.CREATED = $strUTCCurrentTime
    #$outRecord.LOCATION = 'http://cm-tips.blog.so-net.ne.jp'
    $outRecord.LOCATION = ""
    #出力オブジェクトを出力オブジェクト配列に追加
    $outRecords += $outRecord
}
#出力オブジェクト配列をJSON形式で出力
$outRecords | Select-Object * | ConvertTo-Json | Out-File $outputFilePath -Encoding UTF8
##END mt2json.ps1 ##