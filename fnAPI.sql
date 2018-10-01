create or replace function fnAPI(varchar(50)) RETURNS varchar as $$
declare 
	tabla alias for $1;
	res varchar;
begin	
	execute '(select array_to_json(array_agg(row_to_json(t))) from (select * from ' || tabla || ') t);' into res;
	return res;
end;
$$ LANGUAGE plpgsql;

select fnAPI('tbPlazo');