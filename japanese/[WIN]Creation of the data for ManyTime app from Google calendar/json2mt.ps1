## BEGIN json2mt.ps1 ##
#Json�t�@�C�����͂�ϊ����āA�����ԃf�[�^���t�@�C���o�͂���B
#
#�t�@�C���p�X�̍쐬
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
$filepath2 = Split-Path $MyInvocation.MyCommand.Path
$outputFilePath = Join-Path $filepath2 $args[1]

#����
$inRecords = Get-Content $inputFilePath -Encoding UTF8 -Raw | ConvertFrom-Json

#�o�̓I�u�W�F�N�g���i�[����z��i�����l����̔z��j
$outRecords=@() 

#���̓I�u�W�F�N�g�z��v�f���
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
        #�o�̓I�u�W�F�N�g����
        $properties = @{'Start'= "";
                        'End'= "";
                        'Comment'= ""}
        $outRecord = New-Object PSObject -Prop $properties
        #
        #�J�n���ԂƏI�����Ԃ̃��[�J�����Ԃ̌v�Z
        $timeStartTime = $startDate.toLocalTime()
        $timeEndTime = $endDate.toLocalTime()
        #�I���C�x���g�̔��f�̏���
        if ($allDayFlag) {
            $strStartDate = $timeStartTime.ToString("yyyy-MM-dd")
            $strAllDayStartDate = $strStartDate + " 00:00:00"
            #
            $newTimeEndTime = $timeEndTime.AddDays(-1)
            $strEndDate = $newTimeEndTime.ToString("yyyy-MM-dd")
            #$strEndDate = $timeEndTime.ToString("yyyy-MM-dd")
            #
            $strAllDayEndDate = $strEndDate + " 23:59:00"
            #�I���C�x���g�̏ꍇ
            $outRecord.Start = $strAllDayStartDate
            $outRecord.End = $strAllDayEndDate
            #�R�����Ή�
            $comment = $inRecord.SUMMARY.replace("\:",":")
            $outRecord.Comment = $comment
        }
        else {
            #�ʏ�C�x���g�̃��[�J�����ԕ�����̎擾
            $strStartDT = $timeStartTime.ToString("yyyy-MM-dd HH:mm:ss")
            $strEndDT = $timeEndTime.ToString("yyyy-MM-dd HH:mm:ss")
            #�o�̓I�u�W�F�N�g�̃v���p�e�B�ɓ��̓I�u�W�F�N�g�̃v���p�e�B�l����
            $outRecord.Start = $strStartDT
            $outRecord.End = $strEndDT
            #�R�����Ή�
            $comment = $inRecord.SUMMARY.replace("\:",":")
            $outRecord.Comment = $comment
        }
        #�o�̓I�u�W�F�N�g���o�̓I�u�W�F�N�g�z��ɒǉ�
        $outRecords += $outRecord
    }
}

#�o�̓I�u�W�F�N�g�z���CSV�`���ŏo��
$outRecords | Select-Object Start, End, Comment | ConvertTo-Csv -Delimiter "`t" | % {$_.Replace('"','')} | Select -Skip 2 | Out-File $outputFilePath -Encoding UTF8
## END json2mt.ps1 ##