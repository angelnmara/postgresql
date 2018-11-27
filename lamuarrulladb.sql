drop table if exists tbCatObj;

drop table if exists tbCatCampo;

drop table if exists tbCatTpPer;

drop table if exists tbUsuCveApi;

drop table if exists tbUsuPassw;

drop table if exists tbAmortiza;

drop table if exists tbUsuTabla;

drop table if exists tbPantallaRol;

drop table if exists tbPantallas;

drop table if exists tbTipoPantalla;

drop table if exists tbGruposEmpresas;

drop table if exists tbGruposTareas;

drop table if exists tbGrupos;

drop table if exists tbTrabajoTarea;

drop table if exists tbTareas;

drop table if exists tbTrabajos;

drop table if exists tbTareasStatus;

drop table if exists tbUsu;

drop table if exists tbMemberRol;

drop table if exists tbTpGastoMes;

drop table if exists tbPlazoTpGasto;

drop table if exists tbPlazo;

drop table if exists tbTpGasto;

drop table if exists tbGastadoMes;

drop table if exists tbPresupuestoMes;

drop table if exists tbMes;

drop table if exists tbRols;

-- drop table if exists tbTrabajosGruposTareasStat;
-- drop table if exists tbTrabajosGruposTareas;
-- drop table if exists tbStatusTrabajosGruposTareas

drop table if exists tbEmpresas;

create table if not exists tbCatObj(fiIdObj serial primary key,
				fcObj varchar(4),
				fcDescObj varchar(100));

create table if not exists tbCatCampo(fiIdCampo serial primary key,
				fcCampo varchar(5) unique,
				fcDescCampo varchar(100));	

create table if not exists tbCatTpPer(fiIdTpPer serial primary key,
				fcDescTpPer char(50), 
				fnStatTpPer boolean default true);

create table if not exists tbRols(fiIdRol serial primary key,
				fiRolDesc varchar(100),
                                fnRolStat boolean default true);

create table if not exists tbMemberRol(fiIdMemberRol serial primary key,
				fiIdRol int references tbCatRol(fiIdRol),
                                fiIdRolMember int references tbCatRol(fiIdRol),
                                fnStatMemberRol boolean default true,                                
                                unique(fiIdRol, fiIdRolMember));

create table if not exists tbEmpresas(fiIdEmpresa serial primary key,
				fcEmpresaNom varchar(100) not null,
				fcEmpresaStat bool default true not null);                                

create table if not exists tbUsu (fiIdUsu serial primary key,
                    fcUsuNom char(10) unique not null,
                    fiIdEmpresa int references tbEmpresas(fiIdEmpresa),
                    fcUsuCorrElec char(100) unique not null,                    
                    fiIdRolUsu int references tbCatRol(fiIdRol),
                    fnUsuStat boolean default true);

create table if not exists tbUsuCveApi(fiIdUsuCveAPI serial primary key,
				fiIdUsu int references tbusu(fiIdUsu),
                                fcCveAPI varchar(1000) not null unique,
                                fnStatCveAPI boolean default true,
                                fdFecIniCveAPI timestamp default CURRENT_TIMESTAMP,
                                fdFecFinCveAPI timestamp default null);     

create table if not exists tbUsuPassw(fiIdUsuPassw serial primary key,
				fiIdUsu int references tbusu(fiIdUsu),
                                fcUsuPassw varchar(200) not null default 'cXdlcnR5',
                                fnStatUsuPassw boolean default true,
                                fdFecIniUsuPassw timestamp default CURRENT_TIMESTAMP,
                                fdFecFinUsuPassw timestamp null);

create table if not exists tbPlazo(fiIdPlazo serial primary key,				
                                fcNomPlazo varchar(200) not null,
                                fiNoDiasPlazo int,
                                fnStatPlazo boolean default true,
                                fdFecIniPlazo timestamp default CURRENT_TIMESTAMP,
                                fdFecFinPlazo timestamp null);

create table if not exists tbUsuTabla(fiIdUsuTabla serial primary key,
	fiIdUsu int references tbusu(fiidusu));                                

create table if not exists tbAmortiza(fiNumPagoAmortiza serial primary key,
		fiIdUsuTabla int references tbUsuTabla(fiIdUsuTabla),
		flPagoAmortiza decimal(18,2),
		flInteresesPagadosAmortiza decimal(18,2),
		flCapitalPagadoAmortiza decimal(18,2),
		flMontoPrestamoAmortiza decimal(18,2));

create table if not exists tbTpGasto(fiIdTipoGasto serial primary key,
				fcDescTipoGasto varchar(500));

create table if not exists tbPlazoTpGasto(fiIdPlazoTipoGasto serial primary key,
					fiIdPlazo int references tbPlazo(fiIdPlazo),
					fiIdTipoGasto int references tbTpGasto(fiIdTipoGasto),
					fmMontoPlazoTipoGasto money not null);

create table if not exists tbMes(fiIdMes serial primary key,
				fcMes varchar(20));

create table if not exists tbTpGastoMes(fiIdTipoGastoMes serial primary key,
					fiIdMes int references tbMes(fiIdMes),
					fiIdPlazoTipoGasto int references tbPlazoTpGasto(fiIdPlazoTipoGasto));				

create table if not exists tbPresupuestoMes(fiIdPresupuestoMes serial primary key,
					fiIdMes int references tbMes(fiIdMes),
					fmPresupuestoMes money);

create table if not exists tbGastadoMes(fiGastadoMes serial primary key,
					fiIdMes int references tbMes(fiIdMes),
					fmGastadoMes money);

create table if not exists tbTipoPantalla(fiIdTipoPantalla serial primary key,
					fcTipoPantallaDesc varchar(200),
					fnTipoPantallaStat bool default true not null,
					fiTipoPantallaUsuUltCamb int references tbUsu(fiIdUsu));

create table if not exists tbPantallas(fiIdPantalla serial primary key,
				fiIdTipoPantalla int references tbTipoPantalla(fiIdTipoPantalla),
				fcPantallaNom varchar(100) not null,
				fcPantallaDesc varchar(1000),
				fcPantallaURL varchar(500),
				fnPantallaStat bool default true not null,
				fiPantallaUsuUltCamb int references tbUsu(fiIdUsu));	

create table if not exists tbPantallaRol(fiIdPantallaRol serial primary key,
					fiIdPantalla int references tbPantallas(fiIdPantalla),
					fiIdRol int references tbRols(fiIdRol),
					fnPantallaRol bool default true,
					fiPantallaRolUsuUltCamb int references tbUsu(fiIdUsu));

create table if not exists tbGrupos(fiIdGrupo serial primary key,
				fcGrupoNom varchar(200) not null,
				fcGrupoDesc varchar(1000),
				fnGrupoStat bool default true not null,
				fiGrupoUsuUltCamb int references tbUsu(fiIdUsu));

create table if not exists tbTareas(fiIdTarea serial primary key,
				fcTareaNom varchar(100) not null,
				fcTareaDesc varchar(1000),
				fcTareaStat bool default true not null,
				fiTareaUsuUltCamb int references tbUsu(fiIdUsu));

create table if not exists tbGruposEmpresas(fiIdGrupoEmpresa serial primary key,
					fiIdGrupo int references tbGrupos(fiIdGrupo),
					fiIdEmpresa int references tbEmpresas(fiIdEmpresa),
					fnGrupoEmpresaStat bool default true not null,
					fiGruposEmpresasUsuUltCamb int references tbUsu(fiIdUsu) not null);

create table if not exists tbGruposTareas(fiIdGrupoTarea serial primary key,
					fiIdGrupo int references tbGrupos(fiIdGrupo),
					fiIdTarea int references tbTareas(fiIdTarea),
					fiGrupoTareaStat bool default true not null,
					fiGrupoTareaUsuUltCamb int references tbUsu(fiIdUsu) not null);		

create table if not exists tbTrabajos(fiIdTrabajo serial primary key,
				fcTrabajoNom varchar(100) not null,
				fcTrabajoDesc varchar(1000) not null,
				fcTrabajoDireccion varchar(1000) not null,
				fcTrabajoLote varchar(1000) not null,
				fcTrabajoCP varchar(10) not null,
				fcTrabajoReferencia varchar(5000) not null,
				flTrabajoLat decimal(28,10) not null,
				flTrabajoLong decimal(28,10) not null,
				fdTrabajoFecUltAct date default CURRENT_TIMESTAMP,
				fnTrabajoStat bool default true not null,
				fiTrabajoUsuUltCamb int references tbUsu(fiIdUsu) not null);

create table tbTareasStatus(fiIdTareaStatus serial primary key,
			fcTareasEstatusNom varchar(100),
			fnTareaEstatusStat bool default true,
			fiTareaStatusUsuUltCamb int references tbUsu(fiIdUsu) not null);

create table tbTrabajoTarea(fiIdTrabajoTarea serial primary key,
			fiIdTrabajo int references tbTrabajos(fiIdTrabajo),
			fiIdTarea int references tbTareas(fiIdTarea),
			fiIdTareasStatus int references tbTareasStatus(fiIdTareaStatus),
			fiTrabajoTareaUsuUltCamb int references tbUsu(fiIdUsu) not null);							

-- create table if not exists tbTrabajosGruposTareas(fiIdTrabajosGruposTareas serial primary key,
-- 						fiIdTrabajo int references tbTrabajos(fiIdTrabajo),
-- 						fiIdGrupoTarea int references tbGruposTareas(fiIdGrupoTarea),
-- 						fdTrabajosGruposTareasFecUltAct date default CURRENT_TIMESTAMP,
-- 						fnTrabajosGruposTareasStat bool default true);

-- create table if not exists tbStatusTrabajosGruposTareas(fiIdStatusTrabajosGruposTareas serial primary key,
-- 							fcStatusTrabajosGruposTareasDesc varchar(50))

-- create table if not exists tbTrabajosGruposTareasStat(fiIdTrabajosGruposTareasStat serial primary key,
-- 						fiIdTrabajosGruposTareas int references tbTrabajosGruposTareas(fiIdTrabajosGruposTareas),
-- 						fiIdStatusTrabajosGruposTareas int references tbStatusTrabajosGruposTareas(fiIdStatusTrabajosGruposTareas),
-- 						fdTrabajosGruposTareasStatFecUltAct date default CURRENT_TIMESTAMP,
-- 						fnTrabajosGruposTareasStat bool default true);

insert into tbEmpresas(fcEmpresaNom)values('Neurosys');

insert into tbUsu(fcUsuNom, fcUsuCorrElec, fiIdRolUsu, fiIdEmpresa) values ('DAVER', 'angelnmara@hotmail.com', 1, 1);

insert into tbTareasStatus(fcTareasEstatusNom, fitareastatususuultcamb)values('Nuevo', 1);
insert into tbTareasStatus(fcTareasEstatusNom, fitareastatususuultcamb)values('Asignado', 1);
insert into tbTareasStatus(fcTareasEstatusNom, fitareastatususuultcamb)values('En proceso', 1);
insert into tbTareasStatus(fcTareasEstatusNom, fitareastatususuultcamb)values('Terminado', 1);
insert into tbTareasStatus(fcTareasEstatusNom, fitareastatususuultcamb)values('Cancelado', 1);

insert into tbTrabajos(
		fcTrabajoNom,
		fcTrabajoDesc, 
		fcTrabajoDireccion, 
		fcTrabajoLote, 
		fcTrabajoCP,
		fcTrabajoReferencia, 
		flTrabajoLat, 
		flTrabajoLong,
		fitrabajousuultcamb)
		values('Primer trabajos',
		'descripcion del primer trabajo',
		'Sierra dorada 29',
		'lt 39',
		'55790',
		'Porton sin pintar',
		106.52658,
		-21.36979,
		1);

-- insert into tbTrabajosGruposTareas(fiIdTrabajo, fiIdGrupoTarea)values(1,1);
-- insert into tbTrabajosGruposTareas(fiIdTrabajo, fiIdGrupoTarea)values(1,2);

insert into tbTareas(fcTareaNom)values('Pintar puerta');
insert into tbTareas(fcTareaNom)values('Pintura externa');
insert into tbTareas(fcTareaNom)values('Pintura interna');
insert into tbTareas(fcTareaNom)values('Limpieza ventanas');
insert into tbTareas(fcTareaNom)values('Limpieza carpeta');

insert into tbGrupos(fcGrupoNom)values('Pintores');
insert into tbGrupos(fcGrupoNom)values('Limpieza');

insert into tbGruposTareas(fiIdGrupo, fiIdTarea, figrupotareausuultcamb)values(1,1, 1);
insert into tbGruposTareas(fiIdGrupo, fiIdTarea, figrupotareausuultcamb)values(1,2, 1);

insert into tbGruposEmpresas(fiIdGrupo, fiIdEmpresa, fiGruposEmpresasUsuUltCamb)values(1,1,1);
insert into tbGruposEmpresas(fiIdGrupo, fiIdEmpresa, fiGruposEmpresasUsuUltCamb)values(1,1,1);

insert into tbTipoPantalla(fcTipoPantallaDesc)values('WEB');
insert into tbTipoPantalla(fcTipoPantallaDesc)values('Mobil');

insert into tbPantallas(fiIdTipoPantalla, fcPantallaNom, fcPantallaURL)values(1, 'Login', '\Login');

insert into tbRols(fiRolDesc)values('Admin');

insert into tbPantallaRol(fiIdPantalla, fiIdRol)values(1,1);

insert into tbMes(fcMes)values('Enero');
insert into tbMes(fcMes)values('Febrero');
insert into tbMes(fcMes)values('Marzo');
insert into tbMes(fcMes)values('Abril');
insert into tbMes(fcMes)values('Mayo');
insert into tbMes(fcMes)values('Junio');
insert into tbMes(fcMes)values('Julio');
insert into tbMes(fcMes)values('Agosto');
insert into tbMes(fcMes)values('Septiembre');
insert into tbMes(fcMes)values('Octubre');
insert into tbMes(fcMes)values('Noviembre');
insert into tbMes(fcMes)values('Diciembre');

insert into tbPlazo(fcNomPlazo, fiNoDiasPlazo)values('Semanal', 7);
insert into tbPlazo(fcNomPlazo, fiNoDiasPlazo)values('Quincenal', 15);
insert into tbPlazo(fcNomPlazo, fiNoDiasPlazo)values('Mensual', 30);
insert into tbPlazo(fcNomPlazo, fiNoDiasPlazo)values('Anual', 360);
insert into tbPlazo(fcNomPlazo, fiNoDiasPlazo)values('Bimestral', 60);								

insert into tbTpGasto(fcDescTipoGasto) values ('Despensa');
insert into tbTpGasto(fcDescTipoGasto) values ('Colegiaturas');
insert into tbTpGasto(fcDescTipoGasto) values ('Gasto');
insert into tbTpGasto(fcDescTipoGasto) values ('Diversión');
insert into tbTpGasto(fcDescTipoGasto) values ('Cable, Télefono e Internet');						
insert into tbTpGasto(fcDescTipoGasto) values ('Cable');
insert into tbTpGasto(fcDescTipoGasto) values ('Teléfono');
insert into tbTpGasto(fcDescTipoGasto) values ('Internet');
insert into tbTpGasto(fcDescTipoGasto) values ('Gas');
insert into tbTpGasto(fcDescTipoGasto) values ('Luz');
insert into tbTpGasto(fcDescTipoGasto) values ('Agua');

insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(3,1, 1400); 
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(2,2, 2600);
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(1,3, 1400);
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(2,4, 800);
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(3,5, 850);
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(3,9, 200);
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(5,10, 300);
insert into tbPlazoTpGasto(fiIdPlazo, fiIdTipoGasto, fmMontoPlazoTipoGasto) values(4,11, 800);

insert into tbCatObj(fcObj, fcDescObj) values ('tb', 'tabla');
insert into tbCatObj(fcObj, fcDescObj) values ('sp', 'store procedure');        
insert into tbCatObj(fcObj, fcDescObj) values ('fn', 'funcion');
insert into tbCatObj(fcObj, fcDescObj) values ('tr', 'trigger');
insert into tbCatObj(fcObj, fcDescObj) values ('vw', 'vista');

insert into tbCatCampo(fcCampo, fcDescCampo) values('fi', 'formato entero');
insert into tbCatCampo(fcCampo, fcDescCampo) values('fc', 'formato caracter');                                    
insert into tbCatCampo(fcCampo, fcDescCampo) values('fn', 'formato boolean');
insert into tbCatCampo(fcCampo, fcDescCampo) values('fd', 'formato fecha');
insert into tbCatCampo(fcCampo, fcDescCampo) values('fm', 'formato money');
insert into tbCatCampo(fcCampo, fcDescCampo) values('fl', 'formato decimal');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Desc', 'Descripcion campo');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Id', 'Campo Identificador');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Stat', 'Status del campo');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Tp', 'Tipo');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Ap', 'Apellido');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Per', 'Persona');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Cat', 'Catalogo');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Dt', 'Datos');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Cve', 'Clave');
insert into tbCatCampo(fcCampo, fcDescCampo) values('API', 'Aplicacion');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Fec', 'fecha');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Ini', 'Inicial');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Passw', 'Contraseña / Password');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Abr', 'Abrebiado');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Lat', 'Latitud');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Long', 'Longitud');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Tam', 'Tamaño');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Dir', 'Direccion');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Corr', 'Correo');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Elec', 'Electronico');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Obj', 'Objeto');
insert into tbCatCampo(fcCampo, fcDescCampo) values('No', 'Numero');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Nom', 'Nombre');
insert into tbCatCampo(fcCampo, fcDescCampo) values('Cte', 'Cliente');

insert into tbCatTpPer(fcDescTpPer) values ('Fisica');
insert into tbCatTpPer(fcDescTpPer) values ('Moral');
insert into tbCatTpPer(fcDescTpPer) values ('Fisica con actividad empresarial');

insert into tbCatRol(fiDescRol) values ('Admin');
insert into tbCatRol(fiDescRol) values ('Gerente');
insert into tbCatRol(fiDescRol) values ('Ejecutivo');
insert into tbCatRol(fiDescRol) values ('Vendedor');
insert into tbCatRol(fiDescRol) values ('Usuario');

insert into tbMemberRol(fiIdRol, fiIdRolMember) values (1,2);
insert into tbMemberRol(fiIdRol, fiIdRolMember) values (1,3);

insert into tbUsuCveApi(fiIdUsu, fcCveAPI) values(1,'1234');

insert into tbUsuPassw(fiIdUsu) values (1);



select *
from tbUsuPassw;

select *
from tbPlazo;

select *
from tbUsuTabla;

select *
from tbAmortiza;