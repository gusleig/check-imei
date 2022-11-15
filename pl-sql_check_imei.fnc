create or replace function check_imei(imei_in varchar2) return number is
  v_check boolean;
  v_len number(10);
  v_val_digit number(1);
  v_imei_part varchar2(14);
  v_imei_check varchar2(21);
  type v_array is varray(14) of varchar2(1);
  array v_array := v_array(); -- initialize
  v_total number(10);
  
begin
  v_len := length(imei_in);
  v_val_digit := to_number(SUBSTR(imei_in, -1));
  v_imei_part := substr(imei_in,1 , length(imei_in)-1);
  v_imei_check :='';
  
  if v_len <> 15 THEN
    return 0;
  END IF;
  
  v_len := v_len -1;
  
  for i in 1..v_len
  Loop
    array.extend();
    IF MOD(i, 2) = 0 THEN --even
       array(i)  := substr(v_imei_part * 2, i, 1);
       v_imei_check := v_imei_check || substr(v_imei_part * 2, i, 1);
    ELSE
       array(i)  := substr(v_imei_part, i, 1);
       v_imei_check := v_imei_check || substr(v_imei_part, i, 1);
    END IF;
 
  End loop;
  
  v_len := length(v_imei_check);
  v_total :=0;
  
  for i in 1..v_len
  Loop
    v_total := v_total + to_number(substr(v_imei_check, i, 1));
  
  end loop;
  
  v_check := (ceil(v_total/10)*10 - v_total) = v_val_digit;
  
  if v_check THEN
    return 1;
  else
    return 0;
  END IF;
 
end check_imei;
/
