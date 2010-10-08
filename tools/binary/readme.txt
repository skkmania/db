shogi84bに登録するためのツール

2010.5.19 開始

大きくいうと２つのツールがある

ひとつは、24の棋譜ファイルを読んでshogi84bに登録するもの
24kifbtools.rb  --  こちらがライブラリ
regist24kif.rb  --  これは実行ファイル

もうひとつは、2chデータベースのファイルを読んでshogi84bに登録するもの
kifubtools.rb -- これはライブラリ（これは上のスクリプトからも呼ばれる)
bdb_regist.rb -- これは実行ファイル

そのどちらからも使われるのが
db_connect.rb

そして、これはテスト用
kifu2query.rb
