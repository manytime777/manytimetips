##BEGIN ics2json.ps1 ##
#�{�̂�ics�\�L��json�\�L�ɕϊ�����B
.\ics2text.ps1 $args[0] output-1.txt

#�O������ics�\�L��json�\�L�ɕϊ�����B
.\text2json.ps1 output-1.txt output-1.json

#"TRANSP": "OPAQUE",�̃J���}���㑱�s�������ō폜����B
.\json2json.ps1 output-1.json $args[1]

##END ics2json.ps1 ##