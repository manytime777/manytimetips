##BEGIN ics2json.ps1 ##
#本体のics表記をjson表記に変換する。
.\ics2text.ps1 $args[0] output-1.txt

#外周部のics表記をjson表記に変換する。
.\text2json.ps1 output-1.txt output-1.json

#"TRANSP": "OPAQUE",のカンマを後続行しだいで削除する。
.\json2json.ps1 output-1.json $args[1]

##END ics2json.ps1 ##