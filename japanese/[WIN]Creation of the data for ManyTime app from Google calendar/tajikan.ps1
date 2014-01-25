##BEGIN tajikan.ps1 ##
#output-2.txt($args[0]) を開始時間でソートする。
.\sortbystart $args[0] output-3.txt

#output-3.txt の重複する行数をカウントして、count.txt を作成する。
.\makecountstart.ps1 output-3.txt count.txt

#count.txt と output-2.txt($args[0]) をマージする。output-7.txt($args[1])が出力。
.\addnum2head.ps1 count.txt $args[0] $args[1]
##END tajikan.ps1 ##