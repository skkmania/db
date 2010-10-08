--
--  users テーブルにテストデータを挿入
--
create or replace function create_users_testdata()
  returns void as $$
  declare
    i  integer;
    uid varchar;
  begin
    for i in 1..9999 loop
      uid := trim(to_char(i,'00000'));
      insert into users values (i, 'aa' || uid, 'aa' || uid );
      insert into users values (10000+i, 'bb' || uid, 'bb' || uid );
    end loop;
  end;$$
language 'plpgsql';
