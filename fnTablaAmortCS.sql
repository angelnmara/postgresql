-- Function: public.fntablaamortcs(numeric, numeric, integer)

-- DROP FUNCTION public.fntablaamortcs(numeric, numeric, integer);

CREATE OR REPLACE FUNCTION public.fntablaamortcs(
    numeric,
    numeric,
    integer)
  RETURNS character varying AS
$BODY$
declare montoTotal alias for $1;
	tasaAnual alias for $2;
	plazo alias for $3;
	tasaMensual decimal;
	montoPago decimal;
	saldoInsoluto decimal;
	intereses decimal;
	pagoCapital decimal;
	ta TablaAmort%ROWTYPE;	
	count int := 1;
	jsonSalida varchar;
begin	
	tasaAnual = (tasaAnual/100);
	tasaMensual = (tasaAnual/12);
	montoPago = (tasaMensual / (1 - ((1+tasaMensual)^(-1*plazo)))) * montoTotal;

	CREATE TEMP TABLE IF NOT EXISTS tbAmortizacion AS
        select 0 count,0 montoPago,0 intereses,0 pagoCapital,montoTotal saldoInsoluto;

	--select 0,0,0,0,montoTotal into ta;

	while plazo>=count loop
		if count = 1 then		
			saldoInsoluto =	montoTotal;
		end if;
		intereses = tasaMensual * saldoInsoluto;
		pagoCapital = montoPago - intereses;
		saldoInsoluto = saldoInsoluto - pagoCapital;

		insert into tbAmortizacion --(count,montoPago,intereses,pagoCapital,saldoInsoluto) 
		values (count,montoPago,intereses,pagoCapital,saldoInsoluto);
		--select count,montoPago,intereses,pagoCapital,saldoInsoluto into ta;
		count:=count+1;

		raise notice 'Value: %', montoPago || ' ' || intereses;
		
	end loop;
	
	select array_to_json(array_agg(row_to_json(t))) into jsonSalida from (select * from tbAmortizacion) t;
	--select ta;

	drop table if exists tbAmortizacion;
	
	return jsonSalida;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fntablaamortcs(numeric, numeric, integer)
  OWNER TO postgres;

select * from fntablaamortcs(20000, 10, 24);