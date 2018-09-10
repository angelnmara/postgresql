drop table if exists tbCatObj;

drop table if exists tbCatCampo;

drop table if exists tbCatTpPer;

drop table if exists tbUsuCveApi;

drop table if exists tbUsuPassw;

drop table if exists tbUsu;

drop table if exists tbMemberRol;

drop table if exists tbCatRol;




create table if not exists tbCatObj(fiIdObj serial primary key,
				fcObj varchar(4),
				fcDescObj varchar(100));

create table if not exists tbCatCampo(fiIdCampo serial primary key,
				fcCampo varchar(5) unique,
				fcDescCampo varchar(100));	

create table if not exists tbCatTpPer(fiIdTpPer serial primary key,
				fcDescTpPer char(50), 
				fnStatTpPer boolean default true);

create table if not exists tbCatRol(fiIdRol serial primary key,
				fiDescRol varchar(100),
                                fnStatRol boolean default true);

create table if not exists tbMemberRol(fiIdMemberRol serial primary key,
				fiIdRol int references tbCatRol(fiIdRol),
                                fiIdRolMember int references tbCatRol(fiIdRol),
                                fnStatMemberRol boolean default true,                                
                                unique(fiIdRol, fiIdRolMember));

create table if not exists tbUsu (fiIdUsu serial primary key,
                    fcUsu char(10) unique not null,
                    fcCorrElecUsu char(100) unique not null,                    
                    fiIdRolUsu int references tbCatRol(fiIdRol),
                    fnStatUsu boolean default true);                                

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

insert into tbCatObj(fcObj, fcDescObj) values ('tb', 'tabla');
insert into tbCatObj(fcObj, fcDescObj) values ('sp', 'store procedure');        
insert into tbCatObj(fcObj, fcDescObj) values ('fn', 'funcion');
insert into tbCatObj(fcObj, fcDescObj) values ('tr', 'trigger');
insert into tbCatObj(fcObj, fcDescObj) values ('vw', 'vista');

insert into tbCatCampo(fcCampo, fcDescCampo) values('fi', 'formato entero');
insert into tbCatCampo(fcCampo, fcDescCampo) values('fc', 'formato caracter');                                    
insert into tbCatCampo(fcCampo, fcDescCampo) values('fn', 'formato boolean');
insert into tbCatCampo(fcCampo, fcDescCampo) values('fd', 'formato fecha');
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

insert into tbUsu(fcUsu, fcCorrElecUsu, fiIdRolUsu) values ('DAVER', 'angelnmara@hotmail.com', 1);

insert into tbUsuCveApi(fiIdUsu, fcCveAPI) values(1,'1234');

insert into tbUsuPassw(fiIdUsu) values (1);


select *
from tbUsuPassw;