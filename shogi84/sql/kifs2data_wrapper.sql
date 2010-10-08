--
-- kifs2dataを回して指定したidのデータをkifu_dataテーブルへ登録する 
--
create or replace function kifs2data_wrapper(from_id integer, to_id integer)
  returns void as $$
  begin
    for i in from_id..to_id loop
      perform kifs2data(i);
    end loop;
  end;$$
language 'plpgsql';

