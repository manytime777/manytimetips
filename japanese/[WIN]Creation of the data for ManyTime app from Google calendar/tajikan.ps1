##BEGIN tajikan.ps1 ##
#output-2.txt($args[0]) ���J�n���ԂŃ\�[�g����B
.\sortbystart $args[0] output-3.txt

#output-3.txt �̏d������s�����J�E���g���āAcount.txt ���쐬����B
.\makecountstart.ps1 output-3.txt count.txt

#count.txt �� output-2.txt($args[0]) ���}�[�W����Boutput-7.txt($args[1])���o�́B
.\addnum2head.ps1 count.txt $args[0] $args[1]
##END tajikan.ps1 ##