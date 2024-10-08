USE [proyectorestaurante]
GO
/****** Object:  Table [dbo].[reserva]    Script Date: 1/24/2024 4:28:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reserva](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[restaurante_id] [int] NULL,
	[usuario_id] [int] NULL,
	[nombre] [varchar](50) NULL,
	[cantidad_personas] [int] NULL,
	[fecha_reserva] [datetime] NULL,
	[subtotal] [float] NULL,
 CONSTRAINT [PK_reserva] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[restaurante]    Script Date: 1/24/2024 4:28:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[restaurante](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[direccion] [varchar](50) NULL,
	[telefono] [varchar](50) NULL,
	[precio_persona] [float] NULL,
 CONSTRAINT [PK_restaurante] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[reserva] ON 

INSERT [dbo].[reserva] ([id], [restaurante_id], [usuario_id], [nombre], [cantidad_personas], [fecha_reserva], [subtotal]) VALUES (1, 1, 1, N'julia', 2, CAST(N'2024-02-01T00:00:00.000' AS DateTime), 24)
INSERT [dbo].[reserva] ([id], [restaurante_id], [usuario_id], [nombre], [cantidad_personas], [fecha_reserva], [subtotal]) VALUES (2, 1, 1, N'juand', 2, CAST(N'2024-01-23T00:00:00.000' AS DateTime), 24)
SET IDENTITY_INSERT [dbo].[reserva] OFF
GO
SET IDENTITY_INSERT [dbo].[restaurante] ON 

INSERT [dbo].[restaurante] ([id], [nombre], [direccion], [telefono], [precio_persona]) VALUES (1, N'bufalo', N'maracaibo y 11av', N'09563325', 12)
INSERT [dbo].[restaurante] ([id], [nombre], [direccion], [telefono], [precio_persona]) VALUES (2, N'La parrillada del ñato', N'Av. Francisco de Orellana', N'0956625417', 15)
INSERT [dbo].[restaurante] ([id], [nombre], [direccion], [telefono], [precio_persona]) VALUES (3, N'El cafe de Tere', N'Av. Hno Miguel Solar', N'0931825426', 7)
INSERT [dbo].[restaurante] ([id], [nombre], [direccion], [telefono], [precio_persona]) VALUES (4, N'El Corral', N'Mall del Sol', N'0945268936', 9)
SET IDENTITY_INSERT [dbo].[restaurante] OFF
GO
ALTER TABLE [dbo].[reserva]  WITH CHECK ADD  CONSTRAINT [FK_reserva_reserva] FOREIGN KEY([restaurante_id])
REFERENCES [dbo].[restaurante] ([id])
GO
ALTER TABLE [dbo].[reserva] CHECK CONSTRAINT [FK_reserva_reserva]
GO
ALTER TABLE [dbo].[reserva]  WITH CHECK ADD  CONSTRAINT [FK_reserva_usuario] FOREIGN KEY([usuario_id])
REFERENCES [dbo].[usuario] ([id])
GO
ALTER TABLE [dbo].[reserva] CHECK CONSTRAINT [FK_reserva_usuario]
GO
/****** Object:  StoredProcedure [dbo].[GetReserva]    Script Date: 1/24/2024 4:28:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetReserva]
	-- Add the parameters for the stored procedure here
	@iTransaccion as VARCHAR(50),
	@iXML	as XML = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @respuesta	AS VARCHAR(10);
	DECLARE @leyenda AS VARCHAR(50);
	DECLARE @id_reserva AS int;
	DECLARE @precio_venta AS float;



	BEGIN TRY 
		IF (@iTransaccion = 'CONSULTA_TODOS_RESERVA')
			BEGIN

				SELECT re.id as id_reserva, us.nombre as nombre_usuario, us.email, re.nombre as nombre_cliente,
						re.cantidad_personas,rest.nombre as nombre_restaurante,rest.direccion as direccion_restaurante, 
						re.fecha_reserva, rest.precio_persona, re.subtotal
				FROM reserva re
				LEFT OUTER JOIN usuario us ON re.usuario_id =us.id
				LEFT OUTER JOIN restaurante rest ON re.restaurante_id = rest.id

				SET @respuesta ='ok';
				SET @leyenda = 'consulta exitosa'
		END

		IF (@iTransaccion = 'CONSULTA_RESERVA_ID')
			BEGIN
				SET @id_reserva = (select @iXML.value('(/Reserva/Id)[1]','INT'))

				SELECT re.*
				FROM reserva re
				LEFT OUTER JOIN usuario us ON re.usuario_id =us.id
				LEFT OUTER JOIN restaurante rest ON re.restaurante_id = rest.id
				where re.id = @id_reserva

				SET @respuesta ='ok';
				SET @leyenda = 'consulta exitosa';
		END

		IF (@iTransaccion = 'CONSULTA_GENERAL_RESERVA')
			BEGIN

				SELECT * FROM reserva 
				

				SET @respuesta ='ok';
				SET @leyenda = 'consulta exitosa'
		END
	END TRY
	BEGIN CATCH
		SET @respuesta = 'Error';
		SET @leyenda = 'Error al ejecutar el comando en la BD: '+ ERROR_MESSAGE();
	END CATCH

	SELECT @respuesta AS respuesta, @leyenda AS leyenda
END
GO
/****** Object:  StoredProcedure [dbo].[GetRestaurante]    Script Date: 1/24/2024 4:28:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetRestaurante]

	@iTransaccion as VARCHAR(50),
	@iXML	as XML = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @respuesta	AS VARCHAR(10);
	DECLARE @leyenda AS VARCHAR(50);
	DECLARE @id_restaurante AS int;
	DECLARE @precio_venta AS float;

	BEGIN TRY 
		IF (@iTransaccion = 'CONSULTA_TODOS_RESTAURANTES')
			BEGIN

				SELECT * FROM restaurante

				SET @respuesta ='ok';
				SET @leyenda = 'consulta exitosa'
		END

		IF (@iTransaccion = 'CONSULTA_MESAS_DISPONIBLES_RESTAURANTE_ID')
			BEGIN
				SET @id_restaurante = (select @iXML.value('(/Restaurante/Id)[1]','INT'))

				SELECT re.nombre, mr.mesas_disponibles FROM mesas_restaurante mr, restaurante re
				WHERE re.id = @id_restaurante;

				SET @respuesta ='ok';
				SET @leyenda = 'consulta exitosa';
		END
	END TRY
	BEGIN CATCH
		SET @respuesta = 'Error';
		SET @leyenda = 'Error al ejecutar el comando en la BD: '+ ERROR_MESSAGE();
	END CATCH

	SELECT @respuesta AS respuesta, @leyenda AS leyenda
END
GO
/****** Object:  StoredProcedure [dbo].[SetReserva]    Script Date: 1/24/2024 4:28:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetReserva]
	-- Add the parameters for the stored procedure here
	@iTransaccion as VARCHAR(50),
	@iXML as XML = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @id_reserva AS INT
	DECLARE @id_restaurante AS INT;
	DECLARE @id_usuario AS INT;
	DECLARE @nombre AS VARCHAR(50);
	DECLARE @cantidad_personas AS INT;
	DECLARE @fecha_reserva AS DATE;
	DECLARE @subtotal AS FLOAT;
	DECLARE @precio_restaurante AS FLOAT;
	DECLARE @respuesta AS VARCHAR(10);
	DECLARE @leyenda AS VARCHAR(100);
	
	BEGIN TRY
	BEGIN TRANSACTION TRX_DATOS
	IF (@iTransaccion = 'INSERTAR_RESERVA')
				BEGIN
						SET @id_restaurante = (select @iXML.value('(/Reserva/Restaurante/Id)[1]','INT'))
						SET @id_usuario = (select @iXML.value('(/Reserva/Usuario/Id)[1]','INT'))
						SET @nombre = (select @iXML.value('(/Reserva/Nombre)[1]','VARCHAR(50)'))
						SET @cantidad_personas = (select @iXML.value('(/Reserva/Cantidad_Personas)[1]','INT'))
						SET @fecha_reserva = (select @iXML.value('(/Reserva/Fecha)[1]','DATE'))
						SET @precio_restaurante = (select precio_persona  from restaurante where id = @id_restaurante)
						SET @subtotal = @cantidad_personas * @precio_restaurante

						--if( select mesas_disponibles from mesas_restaurante where restaurante_id = @id_restaurante) != 0
						--BEGIN

						----select * from mesas_restaurante where restaurante_id = 1
						
						--update mesas_restaurante set  mesas_disponibles = (mesas_disponibles -1) where restaurante_id = @id_restaurante;


						INSERT INTO reserva(restaurante_id, usuario_id ,nombre,cantidad_personas,fecha_reserva,subtotal)
									values(@id_restaurante,@id_usuario, @nombre, @cantidad_personas, @fecha_reserva,@subtotal);

						SET @Respuesta = 'Ok'
						SET @Leyenda = 'Se ha insertado de manera correcta la reserva al Sistema'
						--END
					--ELSE 
					--BEGIN
					--		SET @Respuesta = 'ERROR'
					--		SET @Leyenda = 'No existen mesas disponibles'
					--END
					
				END

				IF (@iTransaccion = 'ACTUALIZAR_RESERVA_ID')
				BEGIN
						SET @id_reserva = (select @iXML.value('(/Reserva/Id)[1]','INT'))
						SET @id_restaurante = (select @iXML.value('(/Reserva/Restaurante/Id)[1]','INT'))
						SET @id_usuario = (select @iXML.value('(/Reserva/Usuario/Id)[1]','INT'))
						SET @nombre = (select @iXML.value('(/Reserva/Nombre)[1]','VARCHAR(50)'))
						SET @cantidad_personas = (select @iXML.value('(/Reserva/Cantidad_Personas)[1]','INT'))
						SET @fecha_reserva = (select @iXML.value('(/Reserva/Fecha)[1]','DATE'))
						SET @precio_restaurante = (select precio_persona  from restaurante where id = @id_restaurante)
						SET @subtotal = @cantidad_personas * @precio_restaurante

					
					UPDATE reserva
					SET restaurante_id = @id_restaurante,
						usuario_id = @id_usuario,
						nombre = @nombre,
						cantidad_personas = @cantidad_personas,
						fecha_reserva = @fecha_reserva,
						subtotal = @subtotal
									
					WHERE id = @id_reserva


						SET @Respuesta = 'Ok'
						SET @Leyenda = 'Se Actualizo de manera correcta la reserva al Sistema'
					
				END

				IF (@iTransaccion = 'ELIMINAR_RESERVA_ID')
				BEGIN
						SET @id_reserva = (select @iXML.value('(/Reserva/Id)[1]','INT'))
						

					
					delete reserva where id = @id_reserva


						SET @Respuesta = 'Ok'
						SET @Leyenda = 'Se ha Eliminado de manera correcta la reserva al Sistema'
						
					
					
				END

	IF @@TRANCOUNT > 0
				BEGIN  
					COMMIT TRANSACTION TRX_DATOS;
				END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN 
				COMMIT TRANSACTION TRX_DATOS;
			END

		SET @Respuesta = 'ERROR'
		SET @Leyenda = 'Incovenientes para realizar la transaccion: ' + @iTransaccion + '_ Error: '+ ERROR_MESSAGE()

	END CATCH

	SELECT @Respuesta AS Respuesta, @Leyenda AS Leyenda

END
GO
