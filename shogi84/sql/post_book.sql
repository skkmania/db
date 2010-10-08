-- movesテーブルと、kifテーブルとから棋譜のmoveを抽出して出力するSQL
-- postgersql 8.4以降でないと動かない( with recursiveを使うので）
-- 入力 文字列 kid  kifのid kifsテーブルのカラム
-- 出力 テーブル  a_kif テーブル movesに、手数カラムを加えて、その順に１局分を列挙したもの

create type a_kif_record as (cnt bigint, bid integer, mid integer, m_from smallint, m_to smallint, piece character(1), promote boolean, nxt_bid integer);
create or replace function post_book( arg_kid integer ) returns setof a_kif_record as $$
  declare
    workrow	a_kif_record;
    kif_string	varchar;
    moves_count	bigint;
    myrow	record;
  begin
    -- kifsから、kifテーブルを作成
    -- kifテーブルには、手数とmidが列挙される
    select into moves_count ,kif_string tesu, kif from kifs where kid = arg_kid;
    
    drop table if exists kif cascade;
    CREATE TEMPORARY TABLE kif as
      select * from kif_data_to_table(kif_string, moves_count);

    -- kifテーブルにしたがってmovesから繰り返し該当する手をselectして結果を重ね、それをreturnする
    return query
    with recursive r AS (
          SELECT *
                FROM kif,moves
                  WHERE moves.bid = 1
                    and cnt       = 1 
                    and moves.mid = (select kmid from kif where cnt = 1)
        UNION ALL
          SELECT kif.*, moves.*
                FROM kif,moves,r
                  WHERE moves.bid = r.nxt_bid
                    and kif.cnt   = r.cnt + 1
                    and moves.mid = kif.kmid
    )
    SELECT cnt, bid, mid, m_from, m_to, piece, promote, nxt_bid FROM r ORDER BY cnt;
  end;$$
language 'plpgsql';
