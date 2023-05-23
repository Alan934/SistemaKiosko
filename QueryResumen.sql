

USE DBSISTEMAVENTA

GO


create table ROL(
IdRol int primary key identity,
Descripcion varchar(50),
FechaRegistro datetime default getdate()
)

go

create table PERMISO(
IdPermiso int primary key identity,
IdRol int references ROL(IdRol),
NombreMenu varchar(100),
FechaRegistro datetime default getdate()
)

go

create table PROVEEDOR(
IdProveedor int primary key identity,
Documento varchar(50),
RazonSocial varchar(50),
Correo varchar(50),
Telefono varchar(50),
Estado bit,
FechaRegistro datetime default getdate()
)

go

create table CLIENTE(
IdCliente int primary key identity,
Documento varchar(50),
NombreCompleto varchar(50),
Correo varchar(50),
Telefono varchar(50),
Estado bit,
FechaRegistro datetime default getdate()
)

go

create table USUARIO(
IdUsuario int primary key identity,
Documento varchar(50),
NombreCompleto varchar(50),
Correo varchar(50),
Clave varchar(50),
IdRol int references ROL(IdRol),
Estado bit,
FechaRegistro datetime default getdate()
)

go

create table CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar(100),
Estado bit,
FechaRegistro datetime default getdate()
)

go

create table PRODUCTO(
IdProducto int primary key identity,
Codigo varchar(50),
Nombre varchar(50),
Descripcion varchar(50),
IdCategoria int references CATEGORIA(IdCategoria),
Stock int not null default 0,
PrecioCompra decimal(10,2) default 0,
PrecioVenta decimal(10,2) default 0,
Estado bit,
FechaRegistro datetime default getdate()
)

go

create table COMPRA(
IdCompra int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
IdProveedor int references PROVEEDOR(IdProveedor),
TipoDocumento varchar(50),
NumeroDocumento varchar(50),
MontoTotal decimal(10,2),
FechaRegistro datetime default getdate()
)


go


create table DETALLE_COMPRA(
IdDetalleCompra int primary key identity,
IdCompra int references COMPRA(IdCompra),
IdProducto int references PRODUCTO(IdProducto),
PrecioCompra decimal(10,2) default 0,
PrecioVenta decimal(10,2) default 0,
Cantidad int,
MontoTotal decimal(10,2),
FechaRegistro datetime default getdate()
)

go

create table VENTA(
IdVenta int primary key identity,
IdUsuario int references USUARIO(IdUsuario),
TipoDocumento varchar(50),
NumeroDocumento varchar(50),
DocumentoCliente varchar(50),
NombreCliente varchar(100),
MontoPago decimal(10,2),
MontoCambio decimal(10,2),
MontoTotal decimal(10,2),
FechaRegistro datetime default getdate()
)


go


create table DETALLE_VENTA(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
PrecioVenta decimal(10,2),
Cantidad int,
SubTotal decimal(10,2),
FechaRegistro datetime default getdate()
)

go

create table NEGOCIO(
IdNegocio int primary key,
Nombre varchar(60),
Ruc varchar(60),
Direccion varchar(60),
Logo varbinary(max) NULL
)

go


/*************************** CREACION DE PROCEDIMIENTOS ALMACENADOS ***************************/
/*--------------------------------------------------------------------------------------------*/

go


create PROC SPREGISTRARUSUARIO(
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar (100),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar(500) output
)
as
begin 
	set @IdUsuarioResultado = 0
	set @Mensaje = ''
	
	if not exists(select * from USUARIO where Documento = @Documento)
	begin
		insert into USUARIO(Documento, NombreCompleto, Correo, Clave, IdRol, Estado) values 
		(@Documento, @NombreCompleto, @Correo, @Clave, @IdRol, @Estado)
		
		set @IdUsuarioResultado = SCOPE_IDENTITY()

	end
	else
		set @Mensaje = 'No se puede repetir el Documento, para mas de un Usuario'

end

go

create PROC SPEDITARUSUARIO(
@IdUsuario int,
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar (100),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin 
	set @Respuesta = 0
	set @Mensaje = ''
	
	if not exists(select * from USUARIO where Documento = @Documento and IdUsuario != @IdUsuario)
	begin
		update USUARIO set
		Documento = @Documento,
		NombreCompleto =@NombreCompleto, 
		Correo = @Correo, 
		Clave = @Clave, 
		IdRol = @IdRol, 
		Estado = @Estado
		where IdUsuario = @IdUsuario

		set @Respuesta = 1

	end
	else
		set @Mensaje = 'No se puede repetir el Documento, para mas de un Usuario'

end
go

create PROC SPELIMINARUSUARIO(
@IdUsuario int,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin 
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1
	
	if exists (select * from COMPRA c
	inner join USUARIO u on u.IdUsuario = c.IdUsuario
	where u.IdUsuario = @IdUsuario)
	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar, porque el usuario se encuentra relacionado a una COMPRA\n'
	end

	if exists (select * from VENTA V
	inner join USUARIO u on u.IdUsuario = v.IdUsuario
	where u.IdUsuario = @IdUsuario)
	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar, porque el usuario se encuentra relacionado a una VENTA\n'
	end

	if(@pasoreglas = 1)
	begin
		delete from USUARIO where IdUsuario = @IdUsuario
		set @Respuesta = 1
	end
end

go

/* ---------- PROCEDIMIENTOS PARA CATEGORIA -----------------*/


create PROC SPREGISTRARCATEGORIA(
@Descripcion varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 0
	if not exists (select * from CATEGORIA where Descripcion = @Descripcion)
	begin 
		insert into CATEGORIA(Descripcion, Estado) values (@Descripcion, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'No se puede repetir la Descripcion de una Categoria'
end


go

Create procedure SPEDITARCATEGORIA(
@IdCategoria int,
@Estado bit,
@Descripcion varchar(50),
@Resultado bit  output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists (select * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
		update CATEGORIA set
		Descripcion = @Descripcion,
		Estado = @Estado
		where IdCategoria = @IdCategoria
	else
	begin
		set @Mensaje = 'No se puede repetir la Descripcion de una Categoria'
		set @Resultado = 0
	end
end

go

create procedure SPELIMINARCATEGORIA(
@IdCategoria int,
@Resultado bit  output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists (select * from CATEGORIA c inner join PRODUCTO p on p.IdCategoria = c.IdCategoria	where c.IdCategoria = @IdCategoria)
		begin
			delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
		end
	else
	begin
		set @Mensaje = 'La categoria se encuentra relacionada a un producto'
		set @Resultado = 0
	end
end

GO

/* ---------- PROCEDIMIENTOS PARA PRODUCTO -----------------*/

create PROC SPREGISTRARPRODUCTO(
@Codigo varchar(20),
@Nombre varchar(30),
@Descripcion varchar(30),
@Stock int,
@PrecioVenta decimal,
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 0
	if not exists (select * from PRODUCTO where Codigo = @Codigo)
	begin
		insert into PRODUCTO(Codigo, Nombre, Descripcion, Stock, PrecioVenta, IdCategoria, Estado) values (@Codigo, @Nombre, @Descripcion, @Stock, @PrecioVenta, @IdCategoria, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Ya existe  un producto con el mismo codigo'
end

GO

create procedure SPEDITARPRODUCTO(
@IdProducto int,
@Codigo varchar(20),
@Nombre varchar(30),
@Descripcion varchar(30),
@Stock int,
@PrecioVenta decimal,
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists (select * from PRODUCTO where Codigo = @Codigo and IdProducto != @IdProducto)
	begin
		update PRODUCTO set
		Codigo = @Codigo,
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		Stock = @Stock,
		PrecioVenta = @PrecioVenta,
		IdCategoria = @IdCategoria,
		Estado = @Estado
		where IdProducto = @IdProducto
	end
	else
		set @Resultado = 0
		set @Mensaje = 'Ya existe  un producto con el mismo codigo'
end

go


create PROC SPELIMINARPRODUCTO(
@IdProducto int,
@Respuesta int output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	if exists (select * from DETALLE_COMPRA dc inner join PRODUCTO p on p.IdProducto = dc.IdProducto where p.IdProducto = @IdProducto)
	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar, porque se encuentra relacionado a una Compra\n'
	end

	if exists (select * from DETALLE_VENTA dv inner join PRODUCTO p on p.IdProducto = dv.IdProducto where p.IdProducto = @IdProducto)
	begin
		set @pasoreglas = 0
		set @Respuesta = 0
		set @Mensaje = @Mensaje + 'No se puede eliminar, porque se encuentra relacionado a una Venta\n'
	end

	if(@pasoreglas = 1)
		begin
			delete from PRODUCTO where IdProducto = @IdProducto
			set @Respuesta = 1
		end
end
go

/* ---------- PROCEDIMIENTOS PARA CLIENTE -----------------*/

create PROC SPREGISTRARCLIENTE(
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 0
	declare @IdPersona int
	if not exists (select * from CLIENTE where Documento = @Documento)
	begin
		insert into CLIENTE(Documento, NombreCompleto, Correo, Telefono, Estado) values (@Documento, @NombreCompleto, @Correo, @Telefono, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Numero Documento Ya existe'
end

go

create PROC SPEDITARCLIENTE(
@IdCliente int,
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 1
	declare @IdPersona int
	if not exists (select * from CLIENTE where Documento = @Documento and IdCliente != @IdCliente)
	begin
		update CLIENTE set
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdCliente = @IdCliente
	end
	else
		begin
			set @Resultado = 0
			set @Mensaje = 'Numero Documento Ya existe'
		end
end

GO

/* ---------- PROCEDIMIENTOS PARA PROVEEDOR -----------------*/

create PROC SPREGISTRARPROVEEDORES(
@Documento varchar(50),
@RazonSocial varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 0
	declare @IdPersona int
	if not exists (select * from PROVEEDOR where Documento = @Documento)
	begin
		insert into PROVEEDOR(Documento, RazonSocial, Correo, Telefono, Estado) values (@Documento, @RazonSocial, @Correo, @Telefono, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Numero Documento Ya existe'
end

GO

create PROC SPEDITARPROVEEDOR(
@IdProveedor int,
@Documento varchar(50),
@RazonSocial varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 1
	declare @IdPersona int
	if not exists (select * from PROVEEDOR where Documento = @Documento and IdProveedor != @IdProveedor)
	begin
		update PROVEEDOR set
		Documento = @Documento,
		@RazonSocial = @RazonSocial,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where @IdProveedor = @IdProveedor
	end
	else
		begin
			set @Resultado = 0
			set @Mensaje = 'Numero Documento Ya existe'
		end
end

go

create procedure SPELIMINARPROVEEDOR(
@IdProveedor int,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	set @Resultado = 1
	if not exists (
	select * from PROVEEDOR p 
	inner join COMPRA c on p.IdProveedor = c.IdProveedor 
	where p.IdProveedor = @IdProveedor
	)
	begin
		delete top(1) from PROVEEDOR where IdProveedor = @IdProveedor
	end
	ELSE
	BEGIN
		SET @Resultado = 0
		SET @Mensaje = 'El proveedor se encuentra relacionado a una compra'
	END
end

go

/* PROCESOS PARA REGISTRAR UNA COMPRA */

CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE(
	[IdProducto] int null,
	[PrecioCompra] decimal(18,2) null,
	[PrecioVenta] decimal(18,2) null,
	[Cantidad] int null,
	[MontoTotal] decimal(18,2) null
)

GO


CREATE PROCEDURE SPREGISTRARCOMPRA(
@IdUsuario int,
@IdProveedor int,
@TipoDocumento varchar(500),
@NumeroDocumento varchar(500),
@MontoTotal decimal(18,2),
@DetalleCompra [EDetalle_Compra] readonly,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	begin try
		declare @IdCompra int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro
			insert into COMPRA(IdUsuario, IdProveedor, TipoDocumento, NumeroDocumento, MontoTotal)
			values(@IdUsuario, @IdProveedor, @TipoDocumento, @NumeroDocumento, @MontoTotal)

			set @IdCompra = SCOPE_IDENTITY()

			insert into DETALLE_COMPRA(IdCompra, IdProducto, PrecioCompra, PrecioVenta, Cantidad, MontoTotal)
			select @IdCompra, IdProducto, PrecioCompra, PrecioVenta, Cantidad, MontoTotal from @DetalleCompra

			update p set p.Stock = p.Stock + dc.Cantidad,
			p.PrecioCompra = dc.PrecioCompra,
			p.PrecioVenta = dc.PrecioVenta
			from PRODUCTO p
			inner join @DetalleCompra dc on dc.IdProducto = p.IdProducto


		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end


GO

/* PROCESOS PARA REGISTRAR UNA VENTA */

drop type [dbo].[EDetalleVenta]

create type [dbo].[EDetalleVenta] as table (
[IdProducto] int null,
[PrecioCompra] decimal(18,2) null,
[PrecioVenta] decimal(18,2) null,
[Cantidad] int null,
[SubTotal] decimal(18,2) null
)

go


create procedure SPREGISTRARVENTA(
@IdUsuario int,
@TipoDocumento varchar(500),
@NumeroDocumento varchar(500),
@DocumentoCliente varchar(500),
@NombreCliente varchar(500),
@MontoPago decimal(18,2),
@MontoCambio decimal(18,2),
@MontoTotal decimal(18,2),
@DetalleVenta [EDetalleVenta] readonly,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	begin try
		declare @IdVenta int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin transaction registro
			insert into VENTA(IdUsuario, TipoDocumento, NumeroDocumento, DocumentoCliente, NombreCliente, MontoPago, MontoCambio, MontoTotal)
			values(@IdUsuario, @TipoDocumento, @NumeroDocumento, @DocumentoCliente, @NombreCliente, @MontoPago, @MontoCambio, @MontoTotal)

			set @IdVenta = SCOPE_IDENTITY()

			insert into DETALLE_VENTA(IdVenta, IdProducto, PrecioVenta, Cantidad, SubTotal)
			select @IdVenta, IdProducto, PrecioVenta, Cantidad, SubTotal from @DetalleVenta

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end

go
/*************************************************/

create PROC SPREPORTECOMPRAS(
@FechaInicio varchar(10),
@FechaFin varchar(10),
@IdProveedor int
 )
  as
begin
	set dateformat dmy;
	select 
	CONVERT(char(10),c.FechaRegistro,103)[FechaRegistro], c.TipoDocumento, c.NumeroDocumento, c.MontoTotal,
	u.NombreCompleto[UsuarioRegistro],
	pr.Documento[DocumentoProveedor], pr.RazonSocial,
	p.Codigo[CodigoProducto], p.Nombre[NombreProducto], ca.Descripcion[Categoria], dc.PrecioCompra, dc.PrecioVenta, dc.Cantidad, dc.MontoTotal[SubTotal]
	from COMPRA c
	inner join USUARIO u on u.IdUsuario = c.IdUsuario
	inner join PROVEEDOR pr on pr.IdProveedor = c.IdProveedor
	inner join DETALLE_COMPRA dc on dc.IdCompra = c.IdCompra
	inner join PRODUCTO p on p.IdProducto = dc.IdProducto
	inner join CATEGORIA ca on ca.IdCategoria = p.IdCategoria
	where convert(date, c.FechaRegistro) between @FechaInicio and @FechaFin
	and pr.IdProveedor = iif(@IdProveedor=0,pr.IdProveedor,@IdProveedor)
end

 go

 CREATE PROC SPREPORTEVENTAS(
@FechaInicio varchar(10),
@FechaFin varchar(10)
 )
 as
begin
	set dateformat dmy;
	select 
	CONVERT(char(10),v.FechaRegistro,103)[FechaRegistro], v.TipoDocumento, v.NumeroDocumento, v.MontoTotal,
	u.NombreCompleto[UsuarioRegistro],
	v.DocumentoCliente, v.NombreCliente,
	p.Codigo[CodigoProducto], p.Nombre[NombreProducto], ca.Descripcion[Categoria], dv.PrecioVenta, dv.PrecioVenta, dv.Cantidad, dv.SubTotal
	from VENTA v
	inner join USUARIO u on u.IdUsuario = v.IdUsuario
	inner join DETALLE_VENTA dv on dv.IdVenta = v.IdVenta
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	inner join CATEGORIA ca on ca.IdCategoria = p.IdCategoria
	where convert(date, v.FechaRegistro) between @FechaInicio and @FechaFin
end




/****************** INSERTAMOS REGISTROS A LAS TABLAS ******************/
/*---------------------------------------------------------------------*/

GO

 insert into rol (Descripcion)
 values('ADMINISTRADOR')

 GO

  insert into rol (Descripcion)
 values('EMPLEADO')

 GO

 insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
 values 
 ('43749627','ADMIN','@GMAIL.COM','3421',1,1)

 GO


 insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
 values 
 ('20','EMPLEADO','@GMAIL.COM','123',2,1)

 GO

insert into PERMISO (IdRol, NombreMenu) 
values (1, 'menuUsuarios'), (1, 'menuMantenedor'), 
(1, 'menuVentas'), (1, 'menuCompras'), 
(1, 'menuClientes'), (1, 'menuProveedores'), 
(1, 'menuReportes'), (1, 'menuAcercade')

  GO

  insert into PERMISO(IdRol,NombreMenu) values
  (2,'menuVentas'),
  (2,'menuCompras'),
  (2,'menuClientes'),
  (2,'menuProveedores'),
  (2,'menuAcercade')

  GO

  insert into NEGOCIO(IdNegocio,Nombre,Ruc,Direccion,Logo) values
  (1,'Kiosko Cepeda','202020','Ruta 34, Codigo 23',null)