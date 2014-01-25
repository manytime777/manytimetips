## BEGIN text2json.ps1 ##
#�O������ics�\�L��json�\�L�ɕϊ�����B
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$filepath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$filepath2 = Join-Path $filepath2 $args[1]
#UTF8�G���R�[�f�B���O�w������ēǂݍ���
$ICS = Get-Content -Encoding UTF8 $filepath

#"BEGIN:VEVENT"��
$tempfile4 = [System.IO.Path]::GetTempFileName()
$tempfile4 = $ICS -replace '"BEGIN": "VEVENT",', "{"
#"BEGIN:VCALENDAR"��
$tempfile5 = [System.IO.Path]::GetTempFileName()
$tempfile5 = $tempfile4 -replace '"BEGIN": "VCALENDAR",', "["
#"END:VEVENT"��
$tempfile6 = [System.IO.Path]::GetTempFileName()
$tempfile6 = $tempfile5 -replace '"END": "VEVENT"', "}"
#"END:VCALENDAR"��
$tempfile7 = [System.IO.Path]::GetTempFileName()
$tempfile7 = $tempfile6 -replace '"END": "VCALENDAR",', "]"
#"TRANSP": "TRANSPARENT"��
$tempfile8 = [System.IO.Path]::GetTempFileName()
$tempfile8 = $tempfile7 -replace '"TRANSP": "TRANSPARENT",', '"TRANSP": "TRANSPARENT"'

#CATEGORIES���̖���#event",
$tempfile9 = [System.IO.Path]::GetTempFileName()
$tempfile9 = $tempfile8 -replace '#event",', '#event"'

#"http": "�\��
$tempfile10 = [System.IO.Path]::GetTempFileName()
$tempfile10 = $tempfile9 -replace 'http": "', 'http\\:'

#\,��,�ɕϊ�����B
$tempfile11 = [System.IO.Path]::GetTempFileName()
$tempfile11 = $tempfile10 -replace '\\,', ','

#2�s�ڂ���7�s�ڂ��폜
$tempfile12 = [System.IO.Path]::GetTempFileName()
$tempfile12 = $tempfile11 | Foreach {$n=1}{if (($n -lt 2) -or ($n -gt 8)) {$_}; $n++}
#�s���J�E���g
$dataRecordNum = $tempfile12 | Measure-Object
$num = $dataRecordNum.Count - 1
$OUTPUT = $tempfile12 | Foreach {$n=1}{if ($n++ -lt $num) {$_}}
#�t�@�C���o��
Add-Content -path $filepath2 -value $OUTPUT -Encoding UTF8
Add-Content -path $filepath2 -value "}`n]" -Encoding UTF8
## END text2json.ps1 ##