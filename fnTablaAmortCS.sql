

create or replace function fnTablaAmortCS(decimal, decimal, int)
returns varchar as $$
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

	select 0,0,0,0,montoTotal into ta;

	while plazo>=count loop
		if count = 1 then		
			saldoInsoluto =	montoTotal;
		end if;
		intereses = tasaMensual * saldoInsoluto;
		pagoCapital = montoPago - intereses;
		saldoInsoluto = saldoInsoluto - pagoCapital;
		select count,montoPago,intereses,pagoCapital,saldoInsoluto into ta;
		count:=count+1;

		raise notice 'Value: %', montoPago || ' ' || intereses;
		
	end loop;
	
	--select array_to_json(array_agg(row_to_json(t))) into jsonSalida from (select * from ta) t;
	--select ta;
	
	return ta;
end;
$$ language plpgsql;

select fnTablaAmortCS(20000, 5, 12);