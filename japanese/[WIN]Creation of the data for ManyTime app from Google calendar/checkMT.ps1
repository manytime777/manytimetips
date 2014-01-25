## BEGIN checkMT.ps1 ##
# �����ԃf�[�^�̃t�@�C����ǂݍ���ŁA�e�s�̊J�n���ԂƏI�����Ԃ̊Ԋu��
# �O�s�̏I�����ԂƊJ�n���Ԃ̊Ԋu���`�F�b�N����B
#
#�t�@�C���p�X�̍쐬
#���̓t�@�C��
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
    #���[�J�����Ԃ̊J�n���ԕ�����
    $strStartTime = $anArray[0]
    #�J�n���ԕ�����̃`�F�b�N
    $dateCheck = $strStartTime -as [DateTime]
    if (!$dateCheck) {
        [String]$count + "�s�ڂ̊J�n���Ԃ��s���ł��B"
        exit 1
    }
    $startTime = [datetime]::ParseExact($strStartTime,"yyyy-MM-dd HH:mm:ss", $null)
    #���[�J�����Ԃ̏I�����ԕ�����
    $strEndTime = $anArray[1]
    #�I�����ԕ�����̃`�F�b�N
    $dateCheck = $strEndTime -as [DateTime]
    if (!$dateCheck) {
        [String]$count + "�s�ڂ̏I�����Ԃ��s���ł��B"
        exit 1
    }
    $endTime = [datetime]::ParseExact($strEndTime,"yyyy-MM-dd HH:mm:ss", $null)
    #�R�����g
    $comment = $anArray[2]
    #
    $subDay = $endTime - $startTime
    $days = $subDay.Days
    $hours = $subDay.Hours
    $mins = $subDay.Minutes
    $seconds = $subDay.Seconds
    #
    #�I�����Ԃ��J�n���Ԃ��O���ǂ������f����
    if (($days -ge 0) -and ($hours -le 23) -and ($mins -le 59) -and ($seconds -eq 0) -and 
        ($hours -ge 0) -and ($mins -gt 0)) {
        #�J�n���Ԃ��I�����Ԃ��O
    }
    else {
        $strCount = [String]$count
        #�I�����Ԃ��J�n���Ԃ���
        if (($days -eq 0) -and ($hours -eq 0) -and ($mins -eq 0 ) -and ($seconds -eq 0)) {
            $strCount + "�s�ڂ̊J�n���Ԃ��I�����ԂƓ����ł��B"
        }
        else {
            if (($days -lt 0) -or ($hours -lt 0) -or ($mins -lt 0) -or ($seconds -lt 0)) {
                $strCount + "�s�ڂ̊J�n���Ԃ��I�����Ԃ���ł��B"
            }
        }
    }
    #
    #�O�s�̏I�����Ԃ��J�n���Ԃ��O���ǂ������f����
    if ($previousEndTime -ne $null) {
        $subDay = $startTime - $previousEndTime
        $days = $subDay.Days
        $hours = $subDay.Hours
        $mins = $subDay.Minutes
        $seconds = $subDay.Seconds
        if (($days -ge 0) -and ($hours -le 23) -and ($mins -le 59) -and ($seconds -eq 0) -and 
            ($hours -ge 0) -and ($mins -gt 0)) {
            #�J�n���Ԃ��O�s�̏I�����Ԃ��J�n���Ԃ���
        }
        else {
            $strCount = [String]$count
            #�O�s�̏I�����Ԃ��J�n���Ԃ���
            if (($days -eq 0) -and ($hours -eq 0) -and ($mins -eq 0 ) -and ($seconds -eq 0)) {
                $strCount + "�s�ڂ̊J�n���Ԃ��O�s�̏I�����ԂƓ����ł��B"
            }
            else {
                if (($days -lt 0) -or ($hours -lt 0) -or ($mins -lt 0) -or ($seconds -lt 0)) {
                    $strCount + "�s�ڂ̊J�n���Ԃ��O�s�̏I�����Ԃ��O�ł��B"
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