--
--  moves テーブルに、このような制約をつけるべきか
--  意味は、異なる局面から同じ指し手で同じ局面へ移動するような指し手があるのはおかしい、ということ。
--  この結果が存在するならそのようなおかしなデータが存在することになる。
SELECT *
  FROM moves m1, moves m2
 WHERE (m1.m_from,m1.m_to,m1.piece,m1.promote,m1.nxt_bid) = (m2.m_from,m2.m_to,m2.piece,m2.promote,m2.nxt_bid)
   AND m1.bid != m2.bid;

-- 同じ意味で
SELECT min(bid),max(bid),nxt_bid
  FROM moves
 GROUP BY m_from,m_to,piece,promote,nxt_bid 
HAVING count(*) > 1;
--でもよいが、たぶんコストはこちらのほうが大きい。
--そう、問題はコスト。指し手を登録する度にこのチェックはいかがなものか、とも思えるが、このようなひどいデータの予防には相応の代償と考えるか。
--実際、こんなデータが現在、存在している。
--しかし、これをいれるなら、データ登録時のエラーチェックとその後処理も追加しなければならぬ。
