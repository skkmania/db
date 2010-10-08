
--
-- sequenceを再開する
--  sessionが変わるたびに実行する必要がある
--
drop function restart_sequence();
create or replace function restart_sequence()
  returns integer as $$
     declare
       tmp_int   integer;
     begin
	select max(bid) into tmp_int from boards where turn = true;
	select setval('black_bid', tmp_int);
	select max(bid) into tmp_int from boards where turn = false;
	select setval('white_bid', tmp_int);
        return tmp_int;
     end;$$
language 'plpgsql';
