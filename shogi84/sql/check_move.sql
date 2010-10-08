
--
-- check_move.sql
--  movesレコードの値の正当性を判定する関数
--  movesテーブルの列制約のために用いる
--
create or replace function check_move()
  returns boolean as $$
     declare
       result   boolean;
     begin
	select max(bid) into tmp_int from boards where turn = true;
	select setval('black_bid', tmp_int);
	select max(bid) into tmp_int from boards where turn = false;
	select setval('white_bid', tmp_int);
        return tmp_int;
     end;$$
language 'plpgsql';
