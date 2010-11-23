--
-- getParentBidsFull.sql 
--    入力値:bid, level
--    返り値:bidのテーブル
--      bidから始め、level の深さまで、
--      そのbidをnxt_bidに持つbids,それぞれをnxt_bidに持つbids,,,
--      と遡って得られるbidの値を集める
--      そうして集まった全てのbidのdistinctを返す
--
create or replace function getParentBidsFull( arg_bid integer, arg_level integer) returns setof integer as $$
  begin
    return query
    with recursive r(bid, nxt_bid, depth) AS (
          SELECT bid, nxt_bid, 0
            FROM moves
           WHERE moves.nxt_bid = arg_bid
        UNION ALL
          SELECT moves.bid, moves.nxt_bid, r.depth + 1
            FROM moves,r
           WHERE moves.nxt_bid = r.bid
             AND r.depth < (arg_level - 1)
    )
    SELECT DISTINCT r.bid
      FROM r
     ORDER BY r.bid;
  end;$$
language 'plpgsql';
