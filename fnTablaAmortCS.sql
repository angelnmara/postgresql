-- Function: public.fntablaamortcs(numeric, numeric, integer)

-- DROP FUNCTION public.fntablaamortcs(numeric, numeric, integer);

CREATE OR REPLACE FUNCTION public.fntablaamortcs(
    numeric,
    numeric,
    integer, 
    integer)
  RETURNS character varying AS
$BODY$
declare montoTotal alias for $1;
	tasa alias for $2;
	plazo alias for $3;
	tipoTasa alias for $4;	
	tasaMensual decimal;
	montoPago decimal;
	saldoInsoluto decimal;
	intereses decimal;
	pagoCapital decimal;
	ta TablaAmort%ROWTYPE;	
	count int := 1;
	jsonSalida varchar;
	secuencia int;
begin	
	tasa = (tasa/100);
	tasaMensual :=
	case tipoTasa 
		when 4 then  (tasa/12)
		when 3 then tasa
		when 2 then (tasa * (((360/7)/12)/2))
		when 1 then (tasa * ((360/7)/12))
		else tasa
	end;
	
	montoPago = (tasaMensual / (1 - ((1+tasaMensual)^(-1*plazo)))) * montoTotal;

	insert into tbUsuTabla(fiIdUsu)values(1);
	SELECT into secuencia currval(pg_get_serial_sequence('tbUsuTabla','fiidusutabla'));
	
	while plazo>=count loop
		if count = 1 then		
			saldoInsoluto =	montoTotal;
		end if;
		intereses = tasaMensual * saldoInsoluto;
		pagoCapital = montoPago - intereses;
		saldoInsoluto = saldoInsoluto - pagoCapital;	

		insert into tbAmortiza
		values (count,secuencia,montoPago,intereses,pagoCapital,saldoInsoluto);
		
		count:=count+1;

		raise notice 'Value: %', montoPago || ' ' || intereses;
		
	end loop;
	
	select array_to_json(array_agg(row_to_json(t))) into jsonSalida from (select * from tbAmortiza) t;	
	
	return concat('{tbAmortiza: ', jsonSalida, '}');

	--- by d@ve_®
	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fntablaamortcs(numeric, numeric, integer)
  OWNER TO postgres;

select * from public.fntablaamortcs(1200, 2,50,1);
