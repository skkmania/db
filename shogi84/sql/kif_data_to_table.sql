--
-- kif_data文字列をkifテーブルにする
--  入力 : 文字列 kif_data つまりmid(数字）を並べた文字列 ただし、midが２桁ならdではじまる
--         数値   moves_count  この棋譜の手数
--  入力例 : 00102d100201
--           これは、0, 0, 1, 0, 2, 10, 0, 2, 0, 1 を意味する
--  出力 : なし
--         ただし、kifテーブルの内容を書き換える
--  処理例 : 上記入力文字列に対して、kifテーブルは
--         cnt   |   kmid
--        -------+---------
--          1    |    0
--          2    |    0
--          3    |    1
--          4    |    0
--          5    |    2
--          6    |   10
--          7    |    0
--          8    |    2
--          9    |    0
--         10    |    1
--         11    |    0
--         12    |    0
--         13    |    0
--           ........
--           ........ 
--        127    |    0
--        128    |    0
--   このように、kif_dataが終わった後は、手数までmidには0を埋める
--     （kif_insert.sqlを参照のこと）
--
create type kif_record as (cnt bigint, kmid numeric);
create or replace function kif_data_to_table(
    kif_str varchar,
    moves_count bigint)
  returns setof kif_record as $$
  declare
    data_cnt bigint;
    ret_str varchar;
    first  char;
  begin
    -- kif_strに含まれるmoveの個数を求めやすくするため一度tempテーブルをつくる
  drop table if exists temp cascade;
  CREATE TEMPORARY TABLE temp as
    select row_number() OVER () as cnt,
           case when length(s.i[1]) = 3 then to_number(substring(s.i[1],2,2), '99')                
                else                         to_number(s.i[1], '9') end as kmid
    from regexp_matches(kif_str, E'\\d|d\\d\\d', 'g') as s(i);
    -- これでmoveの個数がわかる
  select into data_cnt count(*) from temp;
  return query select cnt, kmid from temp;
    -- moveの個数を超えたら,moves_countまでmidに0を埋める
    -- 上の結果と型を合わせるために0はnumericにキャストしている
  return query select t.i as cnt, 0::numeric as kmid
    from generate_series(data_cnt + 1, moves_count) as t(i);
  end;$$
language 'plpgsql';
