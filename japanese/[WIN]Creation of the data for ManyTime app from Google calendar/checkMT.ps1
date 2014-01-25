## BEGIN checkMT.ps1 ##
# 多時間データのファイルを読み込んで、各行の開始時間と終了時間の間隔と
# 前行の終了時間と開始時間の間隔をチェックする。
#
#ファイルパスの作成
#入力ファイル
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
#
$inRecords = Get-Content $inputFilePath -Encoding UTF8
#
$count = 1
$previousEndTime = $null
#
foreach($inRecord in $inRecords)
{
    $anArray = $inRecord.split("`t")
    #ローカル時間の開始時間文字列
    $strStartTime = $anArray[0]
    #開始時間文字列のチェック
    $dateCheck = $strStartTime -as [DateTime]
    if (!$dateCheck) {
        [String]$count + "行目の開始時間が不正です。"
        exit 1
    }
    $startTime = [datetime]::ParseExact($strStartTime,"yyyy-MM-dd HH:mm:ss", $null)
    #ローカル時間の終了時間文字列
    $strEndTime = $anArray[1]
    #終了時間文字列のチェック
    $dateCheck = $strEndTime -as [DateTime]
    if (!$dateCheck) {
        [String]$count + "行目の終了時間が不正です。"
        exit 1
    }
    $endTime = [datetime]::ParseExact($strEndTime,"yyyy-MM-dd HH:mm:ss", $null)
    #コメント
    $comment = $anArray[2]
    #
    $subDay = $endTime - $startTime
    $days = $subDay.Days
    $hours = $subDay.Hours
    $mins = $subDay.Minutes
    $seconds = $subDay.Seconds
    #
    #終了時間が開始時間より前かどうか判断する
    if (($days -ge 0) -and ($hours -le 23) -and ($mins -le 59) -and ($seconds -eq 0) -and 
        ($hours -ge 0) -and ($mins -gt 0)) {
        #開始時間が終了時間より前
    }
    else {
        $strCount = [String]$count
        #終了時間が開始時間より後
        if (($days -eq 0) -and ($hours -eq 0) -and ($mins -eq 0 ) -and ($seconds -eq 0)) {
            $strCount + "行目の開始時間が終了時間と同じです。"
        }
        else {
            if (($days -lt 0) -or ($hours -lt 0) -or ($mins -lt 0) -or ($seconds -lt 0)) {
                $strCount + "行目の開始時間が終了時間より後です。"
            }
        }
    }
    #
    #前行の終了時間が開始時間より前かどうか判断する
    if ($previousEndTime -ne $null) {
        $subDay = $startTime - $previousEndTime
        $days = $subDay.Days
        $hours = $subDay.Hours
        $mins = $subDay.Minutes
        $seconds = $subDay.Seconds
        if (($days -ge 0) -and ($hours -le 23) -and ($mins -le 59) -and ($seconds -eq 0) -and 
            ($hours -ge 0) -and ($mins -gt 0)) {
            #開始時間が前行の終了時間が開始時間より後
        }
        else {
            $strCount = [String]$count
            #前行の終了時間が開始時間より後
            if (($days -eq 0) -and ($hours -eq 0) -and ($mins -eq 0 ) -and ($seconds -eq 0)) {
                $strCount + "行目の開始時間が前行の終了時間と同じです。"
            }
            else {
                if (($days -lt 0) -or ($hours -lt 0) -or ($mins -lt 0) -or ($seconds -lt 0)) {
                    $strCount + "行目の開始時間が前行の終了時間より前です。"
                }
            }
        }
    }
    #
    $previousEndTime = $endTime
    #
    $count++
}
## END checkMT.ps1 ##