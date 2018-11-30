-- Function: public.fnapi(character varying)

 --DROP FUNCTION public.fnapi(int, character, character, character);

CREATE OR REPLACE FUNCTION public.fnapi(int, character, character, character)
  RETURNS character varying AS
$BODY$
declare 
	metodo alias for $1;
	tabla alias for $2;
	campos alias for $3;
	res alias for $4;
	rest varchar(3000);
	countCampos int;	
	insertT character;
	tbcampostempCount int;
	tbrestempCount int;
	salida varchar(3000);
	prmaryKey varchar(100);
	tieneLlave int;
	lastId int;
	--strArrCampos text[];
	--strArrRes text[];	
begin	
	drop table if exists tbCamposTemp;
	drop table if exists tbResTemp;
	create temp table tbCamposTemp(fcCampo varchar);
	create temp table tbResTemp(fcRes varchar);

	SELECT column_name into prmaryKey
	FROM information_schema.columns
	where table_name = tabla
	and column_default like '%nextval%';

	if metodo = 1 then
			execute '(select array_to_json(array_agg(row_to_json(t))) from (select * from ' || tabla || ') t);' into rest;
			return rest;
		elsif metodo = 2 then
			--strArrCampos = string_to_array(campos, ',');
			--strArrRes = string_to_array(res, ',');
			insert into tbcampostemp
			select a from unnest(string_to_array(campos, ',')) as a;

			insert into tbrestemp
			select a from unnest(string_to_array(res, ',')) as a;

			select count(*) into tieneLlave
			from tbcampostemp
			where fccampo = prmaryKey;			
			
			select count(*) into countCampos
			from (SELECT column_name
			FROM information_schema.columns
			where table_name = tabla
			and is_nullable = 'NO'
			and (column_default = '') is not false) a
			left outer join tbcampostemp b
			on a.column_name = b.fcCampo
			where b.fcCampo is null;

			select count(*) into tbcampostempCount
			from tbcampostemp;

			select count(*) into tbrestempCount
			from tbrestemp;

			if tieneLlave > 0 then
				raise notice 'entra aquí se tiene que insertar llave';
				salida := 'no se puede insertar una llave: ' || prmaryKey;							
			elsif countCampos = 0 then
				if tbcampostempCount = tbrestempCount then
					campos = '(' || campos || ')';
					res = '(' || res || ')';								
					raise notice 'salida';
					execute('insert into ' || tabla || campos || 'values' || res || 'RETURNING ' || prmaryKey) into lastId;
					salida := lastId;	
				else
					salida := 'No se tienen los mismos campos y los mismos res ' || tbcampostempCount || ' ' || tbrestempCount;
				end if;
			else
				salida := 'Faltan campos requeridos para insertar';
			end if;
			return salida;
		else 
			return 'dos';
	end if;	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fnapi(int, character, character, character)
  OWNER TO postgres;


select *
from public.fnapi(2, 'tbusu', 'fcusunom,fiidempresa,fcusucorrelec,fiidrolusu,fnusustat', '''alfredo'',1,''alfredo el choto'',5,true');
select *
from tbusu;
rollback;