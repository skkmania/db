--
-- getChildBidsFull.sql 
--    入力値:bid, level
--    返り値:bidのテーブル
--      bidから始め、level の深さまで、
--      そのbidのnxt_bids,それぞれのnxt_bids,,,
--      と辿って得られるbidの値を集める
--      そうして集まった全てのbidのdistinctを返す
--
create or replace function getChildBidsFull( arg_bid integer, arg_level integer) returns setof integer as $$
  begin
    return query
    with recursive r(bid, nxt_bid, depth) AS (
          SELECT bid, nxt_bid, 0
            FROM moves
           WHERE moves.bid = arg_bid
        UNION ALL
          SELECT moves.bid, moves.nxt_bid, r.depth + 1
            FROM moves,r
           WHERE moves.bid = r.nxt_bid
             AND r.depth < (arg_level - 1)
    )
    SELECT DISTINCT r.nxt_bid
      FROM r
     ORDER BY r.nxt_bid;
  end;$$
language 'plpgsql';
