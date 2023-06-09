USE [master]
GO
/****** Object:  Database [DBSISTEMA_VENTA]    Script Date: 22/05/2023 1:25:46 ******/
CREATE DATABASE [DBSISTEMA_VENTA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBSISTEMA_VENTA', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DBSISTEMA_VENTA.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBSISTEMA_VENTA_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DBSISTEMA_VENTA_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBSISTEMA_VENTA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ARITHABORT OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET RECOVERY FULL 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET  MULTI_USER 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DBSISTEMA_VENTA', N'ON'
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET QUERY_STORE = ON
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DBSISTEMA_VENTA]
GO
/****** Object:  UserDefinedTableType [dbo].[EDetalle_Compra]    Script Date: 22/05/2023 1:25:46 ******/
CREATE TYPE [dbo].[EDetalle_Compra] AS TABLE(
	[IdProducto] [int] NULL,
	[PrecioCompra] [decimal](18, 2) NULL,
	[PrecioVenta] [decimal](18, 2) NULL,
	[Cantidad] [int] NULL,
	[MontoTotal] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[EDetalleVenta]    Script Date: 22/05/2023 1:25:46 ******/
CREATE TYPE [dbo].[EDetalleVenta] AS TABLE(
	[IdProducto] [int] NULL,
	[PrecioCompra] [decimal](18, 2) NULL,
	[PrecioVenta] [decimal](18, 2) NULL,
	[Cantidad] [int] NULL,
	[SubTotal] [decimal](18, 2) NULL
)
GO
/****** Object:  Table [dbo].[CATEGORIA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATEGORIA](
	[IdCategoria] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](100) NULL,
	[Estado] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CLIENTE]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLIENTE](
	[IdCliente] [int] IDENTITY(1,1) NOT NULL,
	[Documento] [varchar](50) NULL,
	[NombreCompleto] [varchar](50) NULL,
	[Correo] [varchar](50) NULL,
	[Telefono] [varchar](50) NULL,
	[Estado] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COMPRA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMPRA](
	[IdCompra] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NULL,
	[IdProveedor] [int] NULL,
	[TipoDocumento] [varchar](50) NULL,
	[NumeroDocumento] [varchar](50) NULL,
	[MontoTotal] [decimal](10, 2) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_COMPRA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_COMPRA](
	[IdDetalleCompra] [int] IDENTITY(1,1) NOT NULL,
	[IdCompra] [int] NULL,
	[IdProducto] [int] NULL,
	[PrecioCompra] [decimal](10, 2) NULL,
	[PrecioVenta] [decimal](10, 2) NULL,
	[Cantidad] [int] NULL,
	[MontoTotal] [decimal](10, 2) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDetalleCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DETALLE_VENTA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DETALLE_VENTA](
	[IdDetalleVenta] [int] IDENTITY(1,1) NOT NULL,
	[IdVenta] [int] NULL,
	[IdProducto] [int] NULL,
	[PrecioCompra] [decimal](10, 2) NULL,
	[PrecioVenta] [decimal](10, 2) NULL,
	[Cantidad] [int] NULL,
	[SubTotal] [decimal](10, 2) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDetalleVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NEGOCIO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NEGOCIO](
	[IdNegocio] [int] NOT NULL,
	[Nombre] [varchar](60) NULL,
	[Ruc] [varchar](60) NULL,
	[Direccion] [varchar](60) NULL,
	[Logo] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdNegocio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERMISO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERMISO](
	[IdPermiso] [int] IDENTITY(1,1) NOT NULL,
	[IdRol] [int] NULL,
	[NombreMenu] [varchar](100) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRODUCTO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCTO](
	[IdProducto] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](50) NULL,
	[Nombre] [varchar](100) NULL,
	[Descripcion] [varchar](100) NULL,
	[IdCategoria] [int] NULL,
	[Stock] [int] NOT NULL,
	[PrecioCompra] [decimal](10, 2) NULL,
	[PrecioVenta] [decimal](10, 2) NULL,
	[Estado] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PROVEEDOR]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROVEEDOR](
	[IdProveedor] [int] IDENTITY(1,1) NOT NULL,
	[Documento] [varchar](50) NULL,
	[RazonSocial] [varchar](50) NULL,
	[Correo] [varchar](50) NULL,
	[Telefono] [varchar](50) NULL,
	[Estado] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROL]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROL](
	[IdRol] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USUARIO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIO](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Documento] [varchar](50) NULL,
	[NombreCompleto] [varchar](50) NULL,
	[Correo] [varchar](50) NULL,
	[Clave] [varchar](50) NULL,
	[IdRol] [int] NULL,
	[Estado] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VENTA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VENTA](
	[IdVenta] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NULL,
	[TipoDocumento] [varchar](50) NULL,
	[NumeroDocumento] [varchar](50) NULL,
	[DocumentoCliente] [varchar](50) NULL,
	[NombreCliente] [varchar](100) NULL,
	[MontoPago] [decimal](10, 2) NULL,
	[MontoCambio] [decimal](10, 2) NULL,
	[MontoTotal] [decimal](10, 2) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdVenta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CATEGORIA] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[CLIENTE] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[COMPRA] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[DETALLE_COMPRA] ADD  DEFAULT ((0)) FOR [PrecioCompra]
GO
ALTER TABLE [dbo].[DETALLE_COMPRA] ADD  DEFAULT ((0)) FOR [PrecioVenta]
GO
ALTER TABLE [dbo].[DETALLE_COMPRA] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[DETALLE_VENTA] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PERMISO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT ((0)) FOR [PrecioCompra]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT ((0)) FOR [PrecioVenta]
GO
ALTER TABLE [dbo].[PRODUCTO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PROVEEDOR] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[ROL] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[USUARIO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[VENTA] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[COMPRA]  WITH CHECK ADD FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[PROVEEDOR] ([IdProveedor])
GO
ALTER TABLE [dbo].[COMPRA]  WITH CHECK ADD FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[USUARIO] ([IdUsuario])
GO
ALTER TABLE [dbo].[DETALLE_COMPRA]  WITH CHECK ADD FOREIGN KEY([IdCompra])
REFERENCES [dbo].[COMPRA] ([IdCompra])
GO
ALTER TABLE [dbo].[DETALLE_COMPRA]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[PRODUCTO] ([IdProducto])
GO
ALTER TABLE [dbo].[DETALLE_VENTA]  WITH CHECK ADD FOREIGN KEY([IdProducto])
REFERENCES [dbo].[PRODUCTO] ([IdProducto])
GO
ALTER TABLE [dbo].[DETALLE_VENTA]  WITH CHECK ADD FOREIGN KEY([IdVenta])
REFERENCES [dbo].[VENTA] ([IdVenta])
GO
ALTER TABLE [dbo].[PERMISO]  WITH CHECK ADD FOREIGN KEY([IdRol])
REFERENCES [dbo].[ROL] ([IdRol])
GO
ALTER TABLE [dbo].[PRODUCTO]  WITH CHECK ADD FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[CATEGORIA] ([IdCategoria])
GO
ALTER TABLE [dbo].[USUARIO]  WITH CHECK ADD FOREIGN KEY([IdRol])
REFERENCES [dbo].[ROL] ([IdRol])
GO
ALTER TABLE [dbo].[VENTA]  WITH CHECK ADD FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[USUARIO] ([IdUsuario])
GO
/****** Object:  StoredProcedure [dbo].[SPEDITARCATEGORIA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPEDITARCATEGORIA](
@IdCategoria int,
@Estado bit,
@Descripcion varchar(50),
@Resultado bit  output,
@Mensaje varchar(500) output
)as
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

GO
/****** Object:  StoredProcedure [dbo].[SPEDITARCLIENTE]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SPEDITARCLIENTE](
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
/****** Object:  StoredProcedure [dbo].[SPEDITARPRODUCTO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SPEDITARPRODUCTO](
@IdProducto int,
@Codigo varchar(20),
@Nombre varchar(30),
@Descripcion varchar(30),
@Stock int,
@PrecioVenta decimal,
@PrecioCompra decimal,
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
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
		PrecioCompra = @PrecioCompra,
		IdCategoria = @IdCategoria,
		Estado = @Estado
		where IdProducto = @IdProducto
	end
	else
		set @Resultado = 0
		set @Mensaje = 'Ya existe  un producto con el mismo codigo'
end

GO
/****** Object:  StoredProcedure [dbo].[SPEDITARPROVEEDOR]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* MODIFICAR UN PROVEEDOR*/
CREATE PROC [dbo].[SPEDITARPROVEEDOR](
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

GO
/****** Object:  StoredProcedure [dbo].[SPEDITARUSUARIO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPEDITARUSUARIO](
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
GO
/****** Object:  StoredProcedure [dbo].[SPELIMINARCATEGORIA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*para eliminar categoria */

create proc [dbo].[SPELIMINARCATEGORIA](
@IdCategoria int,
@Resultado bit  output,
@Mensaje varchar(500) output
)as
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
/****** Object:  StoredProcedure [dbo].[SPELIMINARPRODUCTO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* ELIMINAR UN PRODUCTO*/
CREATE PROC [dbo].[SPELIMINARPRODUCTO](
@IdProducto int,
@Respuesta int output,
@Mensaje varchar(500) output
)as
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

GO
/****** Object:  StoredProcedure [dbo].[SPELIMINARPROVEEDOR]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPELIMINARPROVEEDOR](
@IdProveedor int,
@Resultado bit output,
@Mensaje varchar(500) output
)as
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

GO
/****** Object:  StoredProcedure [dbo].[SPELIMINARUSUARIO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPELIMINARUSUARIO](
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
GO
/****** Object:  StoredProcedure [dbo].[SPREGISTRARCATEGORIA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPREGISTRARCATEGORIA](
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

GO
/****** Object:  StoredProcedure [dbo].[SPREGISTRARCLIENTE]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SPREGISTRARCLIENTE](
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

GO
/****** Object:  StoredProcedure [dbo].[SPREGISTRARCOMPRA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SPREGISTRARCOMPRA](
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
/****** Object:  StoredProcedure [dbo].[SPREGISTRARPRODUCTO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SPREGISTRARPRODUCTO](
@Codigo varchar(20),
@Nombre varchar(30),
@Descripcion varchar(30),
@Stock int,
@PrecioVenta decimal,
@PrecioCompra decimal,
@IdCategoria int,
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin
	set @Resultado = 0
	if not exists (select * from PRODUCTO where Codigo = @Codigo)
	begin
		insert into PRODUCTO(Codigo, Nombre, Descripcion, Stock, PrecioVenta, PrecioCompra, IdCategoria, Estado) values (@Codigo, @Nombre, @Descripcion, @Stock, @PrecioVenta, @PrecioCompra, @IdCategoria, @Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Ya existe  un producto con el mismo codigo'
end

GO
/****** Object:  StoredProcedure [dbo].[SPREGISTRARPROVEEDORES]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SPREGISTRARPROVEEDORES](
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
/****** Object:  StoredProcedure [dbo].[SPREGISTRARUSUARIO]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPREGISTRARUSUARIO](
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
GO
/****** Object:  StoredProcedure [dbo].[SPREGISTRARVENTA]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SPREGISTRARVENTA](
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

			insert into DETALLE_VENTA(IdVenta, IdProducto,PrecioCompra, PrecioVenta, Cantidad, SubTotal)
			select @IdVenta, IdProducto,PrecioCompra, PrecioVenta, Cantidad, SubTotal from @DetalleVenta

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[SPREPORTECOMPRAS]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPREPORTECOMPRAS](
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
GO
/****** Object:  StoredProcedure [dbo].[SPREPORTEVENTAS]    Script Date: 22/05/2023 1:25:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPREPORTEVENTAS](
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
	p.Codigo[CodigoProducto], p.Nombre[NombreProducto], ca.Descripcion[Categoria], dv.PrecioCompra, dv.PrecioVenta, dv.Cantidad, dv.SubTotal
	from VENTA v
	inner join USUARIO u on u.IdUsuario = v.IdUsuario
	inner join DETALLE_VENTA dv on dv.IdVenta = v.IdVenta
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	inner join CATEGORIA ca on ca.IdCategoria = p.IdCategoria
	where convert(date, v.FechaRegistro) between @FechaInicio and @FechaFin
end
GO
USE [master]
GO
ALTER DATABASE [DBSISTEMA_VENTA] SET  READ_WRITE 
GO


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