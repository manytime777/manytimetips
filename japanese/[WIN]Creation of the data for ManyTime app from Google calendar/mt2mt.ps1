## BEGIN mt2mt.ps1 ##
#�t�@�C���p�X�̍쐬
#���̓t�@�C��
$filepath = Split-Path $MyInvocation.MyCommand.Path
$inputFilePath = Join-Path $filepath $args[0]
#�o�̓t�@�C��
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
    #�J�E���^�l
    $counter = [int]$anArray[0]
    #���[�J�����Ԃ̊J�n���ԕ�����
    $strStartTime = $anArray[1]
    $startTime = [datetime]::ParseExact($strStartTime,"yyyy-MM-dd HH:mm:ss", $null)
    #���[�J�����Ԃ̏I�����ԕ�����
    $strEndTime = $anArray[2]
    $endTime = [datetime]::ParseExact($strEndTime,"yyyy-MM-dd HH:mm:ss", $null)
    #�R�����g
    $comment = $anArray[3]
    #
    $subDay = $endTime - $startTime
    $days = $subDay.Days
    $hours = $subDay.Hours
    $mins = $subDay.Minutes
    $seconds = $subDay.Seconds
    #
    #�I���C�x���g���ǂ������f����
    $checkAllDay = $FALSE
    if (($startTime.Hour -eq 0) -and ($startTime.Minute -eq 0) -and ($startTime.Second -eq 0) -and
        ($days -ge 0) -and ($hours -eq 23) -and ($mins -eq 59) -and ($seconds -eq 0)) {
        $checkAllDay = $TRUE
    }
    else {
        $checkAllDay = $FALSE
    }
    #
    #�������ɂ܂�����I���C�x���g���ǂ������f����
    $checkMultiAllDays = $FALSE
    if (($startTime.Hour -eq 0) -and ($startTime.Minute -eq 0) -and ($startTime.Second -eq 0) -and
        ($days -ge 1) -and ($hours -eq 23) -and ($mins -eq 59) -and ($seconds -eq 0)) {
        $checkMultiAllDays = $TRUE
    }
    else {
        $checkMultiAllDays = $FALSE
    }
    #
    #�J�E���^�l:-1 ->�@�d���Ȃ��A�J�E���^�l����ȊO:0~ -> �d������
    if ($counter -lt 0) {
        #�d������
        if($checkAllday) {
            #�I���C�x���g
            $strStartDate = $startTime.ToString("yyyy-MM-dd HH:mm:ss")
            #�I���C�x���g����23:59:00�ŏo�͂���
            $strEndDate = $endTime.ToString("yyyy-MM-dd HH:mm:ss")
            #�I���C�x���g����00:59:00�ŏo�͂���
            #$strEndDate = $endTime.ToString("yyyy-MM-dd") + " 00:59:00"
            #
            if($checkMultiAlldays) {
                #�������ɂ܂�����I���C�x���g�B���ʂ̏I���C�x���g�Ɠ��l�Ɉ����R�����g�t������B
                #�I�����Ԃ��J�n���̏I�����Ԃɂ���
                <#
                $newStartTime = $startTime
                $newEndTime = $newStartTime.AddHours(23)
                $newEndTime = $newEndTime.AddMinutes(59)
                $strStartDate = $newStartTime.ToString("yyyy-MM-dd HH:mm:ss")
                $strEndDate = $newEndTime.ToString("yyyy-MM-dd HH:mm:ss")
                #>
                #�R�����g�t��
                $endDateString = $endTime.ToString("yyyy-MM-dd HH:mm:ss")
                $comment += "(~" + $endDateString + ")";
            }
            #
            $newLine = $strStartDate + "`t" + $strEndDate + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
        else {
            #�ʏ�C�x���g
            $newLine = $strStartTime + "`t" + $strEndTime + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
    }
    else {
        #�d������
        if ($checkAllday) {
            #�I���C�x���g
            $newStartTime = $startTime.AddHours($hourOffset + $counter)
            $newEndTime = $newStartTime.AddMinutes(59)
            $strNewStartTime = $newStartTime.ToString("yyyy-MM-dd HH:mm:ss")
            $strNewEndTime = $newEndTime.ToString("yyyy-MM-dd HH:mm:ss")
            #
            if($checkMultiAlldays) {
                #�������ɂ܂�����I���C�x���g�B���ʂ̏I���C�x���g�Ɠ��l�Ɉ����R�����g�t������B
                $endDateString = $endTime.ToString("yyyy-MM-dd HH:mm:ss")
                $comment += "(~" + $endDateString + ")";
            }
            #
            $newLine = $strNewStartTime + "`t" + $strNewEndTime + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
        else {
            #�ʏ�C�x���g�i���Ԃ�R���t���N�g���Ă���j
            $comment += "(�R���t���N�g)";
            $newLine = $strStartTime + "`t" + $strEndTime + "`t" + $comment
            Add-Content -Path $outputFilePath -Value $newLine -Encoding UTF8
        }
    }
}
## END mt2mt.ps1 ##