## BEGIN mt2mt.ps1 ##
#ファイルパスの作成
#入力ファイル
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
#出力ファイル
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]
#
$inRecords = Get-Content $inputFilePath -Encoding UTF8
#
$hourOffset = 0
#
foreach($inRecord in $inRecords)
{
    $anArray = $inRecord.split("`t")
    #カウンタ値
    $counter = [int]$anArray[0]
    #ローカル時間の開始時間文字列
    $strStartTime = $anArray[1]
    $startTime = [datetime]::ParseExact($strStartTime,"yyyy-MM-dd HH:mm:ss", $null)
    #ローカル時間の終了時間文字列
    $strEndTime = $anArray[2]
    $endTime = [datetime]::ParseExact($strEndTime,"yyyy-MM-dd HH:mm:ss", $null)
    #コメント
    $comment = $anArray[3]
    #
    $subDay = $endTime - $startTime
    $days = $subDay.Days
    $hours = $subDay.Hours
    $mins = $subDay.Minutes
    $seconds = $subDay.Seconds
    #
    #終日イベントかどうか判断する
    $checkAllDay = $FALSE
    if (($startTime.Hour -eq 0) -and ($startTime.Minute -eq 0) -and ($startTime.Second -eq 0) -and
        ($days -ge 0) -and ($hours -eq 23) -and ($mins -eq 59) -and ($seconds -eq 0)) {
        $checkAllDay = $TRUE
    }
    else {
        $checkAllDay = $FALSE
    }
    #
    #複数日にまたがる終日イベントかどうか判断する
    $checkMultiAllDays = $FALSE
    if (($startTime.Hour -eq 0) -and ($startTime.Minute -eq 0) -and ($startTime.Second -eq 0) -and
        ($days -ge 1) -and ($hours -eq 23) -and ($mins -eq 59) -and ($seconds -eq 0)) {
        $checkMultiAllDays = $TRUE
    }
    else {
        $checkMultiAllDays = $FALSE
    }
    #
    #カウンタ値:-1 ->　重複なし、カウンタ値それ以外:0~ -> 重複あり
    if ($counter -lt 0) {
        #重複無し
        if($checkAllday) {
            #終日イベント
            $strStartDate = $startTime.ToString("yyyy-MM-dd HH:mm:ss")
            #終日イベント幅を23:59:00で出力する
            $strEndDate = $endTime.ToString("yyyy-MM-dd HH:mm:ss")
            #終日イベント幅を00:59:00で出力する
            #$strEndDate = $endTime.ToString("yyyy-MM-dd") + " 00:59:00"
            #
            if($checkMultiAlldays) {
                #複数日にまたがる終日イベント。普通の終日イベントと同様に扱いコメント付加する。
                #終了時間を開始日の終了時間にする
                <#
                $newStartTime = $startTime
                $newEndTime = $newStartTime.AddHours(23)
                $newEndTime = $newEndTime.AddMinutes(59)
                $strStartDate = $newStartTime.ToString("yyyy-MM-dd HH:mm:ss")
                $strEndDate = $newEndTime.ToString("yyyy-MM-dd HH:mm:ss")
                #>
                #コメント付加
                $endDateString = $endTime.ToString("yyyy-MM-dd HH:mm:ss")
                $comment += "(~" + $endDateString + ")";
            }
            #
            $newLine = $strStartDate + "`t" + $strEndDate + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
        else {
            #通常イベント
            $newLine = $strStartTime + "`t" + $strEndTime + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
    }
    else {
        #重複あり
        if ($checkAllday) {
            #終日イベント
            $newStartTime = $startTime.AddHours($hourOffset + $counter)
            $newEndTime = $newStartTime.AddMinutes(59)
            $strNewStartTime = $newStartTime.ToString("yyyy-MM-dd HH:mm:ss")
            $strNewEndTime = $newEndTime.ToString("yyyy-MM-dd HH:mm:ss")
            #
            if($checkMultiAlldays) {
                #複数日にまたがる終日イベント。普通の終日イベントと同様に扱いコメント付加する。
                $endDateString = $endTime.ToString("yyyy-MM-dd HH:mm:ss")
                $comment += "(~" + $endDateString + ")";
            }
            #
            $newLine = $strNewStartTime + "`t" + $strNewEndTime + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
        else {
            #通常イベント（たぶんコンフリクトしている）
            $comment += "(コンフリクト)";
            $newLine = $strStartTime + "`t" + $strEndTime + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
    }
}
## END mt2mt.ps1 ##