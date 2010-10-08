--
-- 文字列から末尾の0の連続を削除して返す 
--
create or replace function rtrim_zeros(
    str varchar)
  returns varchar as $$
  declare
    ret_str varchar;
    matubi  char;
  begin
    ret_str := str;
    matubi := substr(ret_str, char_length(ret_str), 1);
    while matubi = '0' loop
      ret_str := rtrim(ret_str,'0');
      matubi := substr(ret_str, char_length(ret_str), 1);
    end loop;
    return ret_str;
  end;$$
language 'plpgsql';
