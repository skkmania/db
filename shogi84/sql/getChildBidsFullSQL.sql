--
-- getChildBidsFullSQL.sql 
--    入力値:bid, level
--    返り値:bidのテーブル
--      bidから始め、level の深さまで、
--      そのbidのnxt_bids,それぞれのnxt_bids,,,
--      と辿って得られるbidの値を集める
--      そうして集まった全てのbidのdistinctを返す
--
create or replace function getChildBidsFullSQL(integer, integer) returns setof integer as $$
  WITH RECURSIVE r(bid, nxt_bid, depth) AS (
          SELECT bid, nxt_bid, 0
            FROM moves
           WHERE moves.bid = $1
        UNION ALL
          SELECT moves.bid, moves.nxt_bid, r.depth + 1
            FROM moves,r
           WHERE moves.bid = r.nxt_bid
             AND r.depth < ($2 - 1)
    )
    SELECT DISTINCT r.nxt_bid AS bid
      FROM r; $$
language SQL;
