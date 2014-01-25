##BEGIN mt2json.ps1 ##
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]
#UTF8�G���R�[�f�B���O�w������ēǂݍ���
$inRecords = Import-Csv -Header Start, End, Comment $inputFilePath -Encoding UTF8 -Delimiter `t

#�o�̓I�u�W�F�N�g���i�[����z��i�����l����̔z��j
$outRecords=@() 

#���̓I�u�W�F�N�g�z��v�f���
foreach($inRecord in $inRecords)
{
    #���ݎ��Ԃ̕�������擾
    $currentTime = Get-Date
    $strUTCCurrentTime = $currentTime.toUniversalTime().ToString("yyyyMMddTHHmmssZ")
    #�J�n���ԂƏI�����Ԃ̃��[�J�����Ԃ̌v�Z
    $timeStartTime = [datetime]::ParseExact($inRecord.Start,"yyyy-MM-dd HH:mm:ss",$null)
    $timeEndTime = [datetime]::ParseExact($inRecord.End,"yyyy-MM-dd HH:mm:ss",$null)
    #�I���C�x���g�̔��f�̏���
    $days = ($timeEndTime - $timeStartTime).Days
    $hours = ($timeEndTime - $timeStartTime).Hours
    $mins = ($timeEndTime - $timeStartTime).Minutes
    $seconds = ($timeEndTime - $timeStartTime).Seconds
    $allDayFlag = $FALSE
    #�����ԃf�[�^�̏o��
    if (($timeStartTime.Hour -eq 0) -and ($timeStartTime.Minute -eq 0) -and ($timeStartTime.Second -eq 0) -and
            ($days -ge 0) -and ($hours -eq 23) -and ($mins -eq 59) -and ($seconds -eq 0)) {
        #�I���C�x���g
        $allDayFlag = $TRUE
    }
    else {
        #�ʏ�C�x���g
        $allDayFlag = $FALSE
    }
    #�J�n���ԂƏI�����Ԃ̃��[�J�����Ԃ̌v�Z
    $startDate = [datetime]::ParseExact($inRecord.Start,"yyyy-MM-dd HH:mm:ss",$null)
    $endDate = [datetime]::ParseExact($inRecord.End,"yyyy-MM-dd HH:mm:ss",$null)
    $timeStartTime = $startDate.toLocalTime()
    $timeEndTime = $endDate.toLocalTime()
    #�I���C�x���g�̔��f�̏���
    if ($allDayFlag) {
        #�o�̓I�u�W�F�N�g����
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
        #�I���C�x���g�̃��[�J�����ԕ�����̎擾
        $strAllDayStartDate = $timeStartTime.ToString("yyyyMMdd")
        $strAllDayEndDate = ""
        if ($days -eq 0) {
            #�J�n���ԂƏI�����Ԃ������B���t��1����
            $strAllDayEndDate = $timeStartTime.AddDays(1).ToString("yyyyMMdd")
        }
        else {
            #�J�n���ԂƏI�����Ԃ��Ⴄ�B
            $strAllDayEndDate = $timeEndTime.ToString("yyyyMMdd")
        }
        #�I���C�x���g�̊J�n���ԁA�I�����ԁA�R�����g���o�̓I�u�W�F�N�g�ɐݒ�
        $outRecord.'DTSTART;VALUE=DATE' = $strAllDayStartDate
        $outRecord.'DTEND;VALUE=DATE' = $strAllDayEndDate
        $outRecord.SUMMARY = $inRecord.Comment
    }
    else {
        #�o�̓I�u�W�F�N�g����
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
        #�ʏ�C�x���g��UTC���ԕ�����̎擾
        $strUTCStartDT = $startDate.toUniversalTime().ToString("yyyyMMddTHHmmssZ")
        $strUTCEndDT = $endDate.toUniversalTime().ToString("yyyyMMddTHHmmssZ")
        #�ʏ�C�x���g�̊J�n���ԁA�I�����ԁA�R�����g���o�̓I�u�W�F�N�g�ɐݒ�
        $outRecord.DTSTART= $strUTCStartDT
        $outRecord.DTEND = $strUTCEndDT
        $outRecord.SUMMARY = $inRecord.Comment
    }
    $outRecord.DTSTAMP = $strUTCCurrentTime
    $outRecord.'LAST-MODIFIED' = $strUTCCurrentTime
    $outRecord.CREATED = $strUTCCurrentTime
    #$outRecord.LOCATION = 'http://cm-tips.blog.so-net.ne.jp'
    $outRecord.LOCATION = ""
    #�o�̓I�u�W�F�N�g���o�̓I�u�W�F�N�g�z��ɒǉ�
    $outRecords += $outRecord
}
#�o�̓I�u�W�F�N�g�z���JSON�`���ŏo��
$outRecords | Select-Object * | ConvertTo-Json | Out-File $outputFilePath -Encoding UTF8
##END mt2json.ps1 ##