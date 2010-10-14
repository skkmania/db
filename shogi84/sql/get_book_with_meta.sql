-- 棋譜データを返す関数
-- 入力 数値 kid  kifのid kifsテーブルのカラム
-- 出力 record kifs の１レコードぶん
--      ただし,kifカラムの値は、get_bookの返値である指し手の集合を文字列に変換したものに置き換えられる

create or replace function get_book_with_meta( arg_kid integer ) returns kifs as $$
  declare
    kif_string	text;
    result      kifs%ROWTYPE;
  begin
    drop table if exists tmp_kif cascade;
    CREATE TEMPORARY TABLE tmp_kif as
      SELECT * from kifs where kid = arg_kid;
    select into kif_string sum(conv_kif_record_to_str(bid,mid,m_from,m_to,piece,promote,nxt_bid)) from get_book(arg_kid);
    UPDATE tmp_kif set kif = kif_string;
    select * into result from tmp_kif where kid = arg_kid;
    return result;
  end;$$
language 'plpgsql';
