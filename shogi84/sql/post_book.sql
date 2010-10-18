-- 棋譜データを返す関数
-- 入力 文字列 moves_str movesデータをmoves,boardsに登録するSQL文
--      文字列 meta_str  metadataをkifsに登録し、その結果を返すSQL文
-- 出力 record kifs の１レコードぶん
--      (ただし,kifカラムの値は、get_bookの結果を利用して
--       [指し手の集合を文字列に変換した文字列]に置き換えられる。)

create or replace function post_book( moves_str text, meta_str text ) returns kifs as $$
  declare
    workrow	kifs%rowtype;
    result      kifs%ROWTYPE;
  begin
    execute moves_str;
    execute meta_str;
    select * into result from get_book_with_meta(workrow.kid);
    return result;
  end;$$
language 'plpgsql';
