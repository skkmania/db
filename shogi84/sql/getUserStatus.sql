--
--  getUserStatus
--    与えられたuserNameのステータスを返す
--      case 1: // 登録済みでログイン済み
--      case 2: // 登録済みで未ログイン
--      case 3: // 未登録
--
create or replace function getUserStatus(userName varchar(15))
  returns integer as $$
     declare
       retval   integer;
       dummy    integer;
     begin
       raise notice 'getUserStatus : arg_userName is %', userName;
       select into dummy userid from users where uname = userName;
       if dummy is null then
         retval := 3;
       else
	 select into dummy userid from user_logins where uname = userName;
	 if dummy is null then
	   retval := 2;
	 else
	   retval :=1;
	 end if;
       end if;
       return retval;
     end;$$
language 'plpgsql';
