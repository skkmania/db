--
-- restart db
--  作りかけてはやりなおすときのためのバッチ処理
--  中途半端に登録したデータを削除する
delete from moves;
delete from boards;
delete from kifread;
delete from kifs;
delete from kifu_data;
delete from new_moves;
delete from new_boards;

insert into boards values(1,true,'','lxpxxxPxLnbpxxxPRNsxpxxxPxSgxpxxxPxGkxpxxxPxKgxpxxxPxGsxpxxxPxSnrpxxxPBNlxpxxxPxL','');

-- setvalだと次にnextvalを呼んだとき次の値から始まる。
-- blackは1についてはすでに上の行で手動入力してあるからこれでよい。
select setval('black_bid',1);
-- whiteはsetvalだと2が抜けて4から始まるので綺麗ではない。
-- select setval('white_bid',2);
-- したがって次のようにする。これならば2から始まる。
alter sequence white_bid restart with 2;
-- kifs テーブルのkidはserial型なので1から始めるように設定しないと、前回の続きから始まってしまう。
alter sequence kifs_kid_seq restart with 1;
