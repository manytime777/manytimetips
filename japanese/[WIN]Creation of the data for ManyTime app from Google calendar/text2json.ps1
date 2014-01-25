## BEGIN text2json.ps1 ##
#外周部のics表記をjson表記に変換する。
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$filepath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$filepath2 = Join-Path $filepath2 $args[1]
#UTF8エンコーディング指定をして読み込み
$ICS = Get-Content -Encoding UTF8 $filepath

#"BEGIN:VEVENT"項
$tempfile4 = [System.IO.Path]::GetTempFileName()
$tempfile4 = $ICS -replace '"BEGIN": "VEVENT",', "{"
#"BEGIN:VCALENDAR"項
$tempfile5 = [System.IO.Path]::GetTempFileName()
$tempfile5 = $tempfile4 -replace '"BEGIN": "VCALENDAR",', "["
#"END:VEVENT"項
$tempfile6 = [System.IO.Path]::GetTempFileName()
$tempfile6 = $tempfile5 -replace '"END": "VEVENT"', "}"
#"END:VCALENDAR"項
$tempfile7 = [System.IO.Path]::GetTempFileName()
$tempfile7 = $tempfile6 -replace '"END": "VCALENDAR",', "]"
#"TRANSP": "TRANSPARENT"項
$tempfile8 = [System.IO.Path]::GetTempFileName()
$tempfile8 = $tempfile7 -replace '"TRANSP": "TRANSPARENT",', '"TRANSP": "TRANSPARENT"'

#CATEGORIES項の末尾#event",
$tempfile9 = [System.IO.Path]::GetTempFileName()
$tempfile9 = $tempfile8 -replace '#event",', '#event"'

#"http": "表現
$tempfile10 = [System.IO.Path]::GetTempFileName()
$tempfile10 = $tempfile9 -replace 'http": "', 'http\\:'

#\,を,に変換する。
$tempfile11 = [System.IO.Path]::GetTempFileName()
$tempfile11 = $tempfile10 -replace '\\,', ','

#2行目から7行目を削除
$tempfile12 = [System.IO.Path]::GetTempFileName()
$tempfile12 = $tempfile11 | Foreach {$n=1}{if (($n -lt 2) -or ($n -gt 8)) {$_}; $n++}
#行数カウント
$dataRecordNum = $tempfile12 | Measure-Object
$num = $dataRecordNum.Count - 1
$OUTPUT = $tempfile12 | Foreach {$n=1}{if ($n++ -lt $num) {$_}}
#ファイル出力
Add-Content -path $filepath2 -value $OUTPUT -Encoding UTF8
Add-Content -path $filepath2 -value "}`n]" -Encoding UTF8
## END text2json.ps1 ##