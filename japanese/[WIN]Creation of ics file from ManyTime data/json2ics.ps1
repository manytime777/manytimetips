##BEGIN json2ics.ps1 ##
#
#Jsonファイル入力を変換して、icsファイル出力する。
#
#ファイルパスの作成
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#入力
$inRecords = Get-Content $inputFilePath -Encoding UTF8 -Raw | ConvertFrom-Json

#
$strOutput = ""
$strOutput += "BEGIN:VCALENDAR`n"
$strOutput += "CALSCALE:GREGORIAN`n"
$strOutput += "METHOD:PUBLISH`n"
$strOutput += "PRODID:-//ManyTime//`n"
$strOutput += "VERSION:2.0`n"
$strOutput += "X-WR-CALNAME:`n"
$strOutput += "X-WR-CALDESC:`n"
$strOutput += "X-WR-TIMEZONE:Asia/Tokyo"
Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
#
#入力オブジェクト配列要素を列挙
foreach($inRecord in $inRecords)
{
    $strOutput = ""
    $strOutput += "BEGIN:VEVENT`n"
    if ($inRecord.DTSTART -eq $NULL) {
        $strOutput += "DTSTART;VALUE=DATE:" + $inRecord.'DTSTART;VALUE=DATE' + "`n"
        $strOutput += "DTEND;VALUE=DATE:" + $inRecord.'DTEND;VALUE=DATE' + "`n"
    } 
    else {
        $strOutput += "DTSTART:" + $inRecord.DTSTART + "`n"
        $strOutput += "DTEND:" + $inRecord.DTEND + "`n"
    }
    $strOutput += "DTSTAMP:" + $inRecord.DTSTAMP + "`n"
    $strOutput += "ORGANIZER:" + $inRecord.ORGANIZER + "`n"
    $strOutput += "UID:" + $inRecord.UID + "`n"
    $strOutput += "CREATED:" + $inRecord.CREATED + "`n"
    $strOutput += "DESCRIPTION:" + $inRecord.DESCRIPTION + "`n"
    $strOutput += "LAST-MODIFIED:" + $inRecord.'LAST-MODIFIED' + "`n"
    $strOutput += "LOCATION:" + $inRecord.LOCATION + "`n"
    $strOutput += "SEQUENCE:" + $inRecord.SEQUENCE + "`n"
    $strOutput += "STATUS:" + $inRecord.STATUS + "`n"
    $strOutput += "SUMMARY:" + $inRecord.SUMMARY + "`n"
    $strOutput += "TRANSP:" + $inRecord.TRANSP + "`n"
    $strOutput += "END:VEVENT"
    Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
}
$strOutput = "END:VCALENDAR"
Add-Content -Path $outputFilePath -Value $strOutput -Encoding UTF8
##END json2ics.ps1 ##