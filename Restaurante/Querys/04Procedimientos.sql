USE DBRestauranteMarias
GO


--sin terminar
--Modulo Usuarios
CREATE PROCEDURE SP_BuscarUsuario
(
    @usuario NVARCHAR(25)
)
AS
BEGIN
    DECLARE @existe INT
    SELECT @existe = COUNT(Restaurante.Usuarios.usuario) FROM Restaurante.Usuarios WHERE usuario = @usuario;
    RETURN @existe;
END
GO

CREATE PROCEDURE SP_InsertarUsuario
(
    @nombre NVARCHAR(25),
    @apellido NVARCHAR(25),
    @clave NVARCHAR(20),
    @idRol INT
)
AS
BEGIN
    DECLARE @existe int;
    DECLARE @Usuario nVarchar(26);
    SET @existe = 0;
    IF (@nombre = '' OR @apellido = '')
        BEGIN
            RAISERROR(N'Hay campos abligatorios sin llenar', 16, 1, @nombre, @apellido);
            RETURN 0
        END
    ELSE
        BEGIN
            SET @usuario = UPPER(LEFT(@nombre, 1)) + Utilidad.NombrePropios(@apellido)

            SELECT @existe = COUNT(Acceso.Usuarios.usuario) FROM Acceso.Usuarios WHERE usuario = @usuario;
            IF (@existe > 0)
                BEGIN
                    RAISERROR(N'Ya existe un usuario con el nombre  "%s %s"', 16, 1, @nombre, @apellido);
                    RETURN 0
                END     
            ELSE
                BEGIN
                    INSERT INTO Acceso.Usuarios(nombre, apellido, usuario, clave, idRol)
                        VALUES (    Utilidad.NombrePropios(@nombre),
                                    Utilidad.NombrePropios(@apellido), 
                                    @usuario, 
                                    @clave, 
                                    @idRol)
                    RETURN 1
                END
            
        END
END
GO

CREATE PROCEDURE SP_ModificarUsuario
(
    @usuarioAnterior NVARCHAR(26),
    @nombre NVARCHAR(25),
    @apellido NVARCHAR(25),
    @clave NVARCHAR(20),
    @idRol INT
)
AS
BEGIN
    DECLARE @existe int;
    DECLARE @Usuario nVarchar(26);
    SET @existe = 0;
    IF (@nombre = '' OR @apellido = '')
        BEGIN
            RAISERROR(N'Hay campos abligatorios sin llenar', 16, 1, @nombre, @apellido);
            RETURN 0
        END
    ELSE
        BEGIN
            SET @usuario = UPPER(LEFT(@nombre, 1)) + Utilidad.NombrePropios(@apellido)

            SELECT @existe = COUNT(Acceso.Usuarios.usuario) FROM Acceso.Usuarios WHERE usuario = @usuarioAnterior;
            IF (@existe = 0)
                BEGIN
                    RAISERROR(N'No existe un usuario con el nombre  "%s %s"', 16, 1, @nombre, @apellido);
                    RETURN 0
                END     
            ELSE
                BEGIN
                    UPDATE Acceso.Usuarios
                        SET     nombre = Utilidad.NombrePropios(@nombre),
                                apellido = Utilidad.NombrePropios(@apellido), 
                                usuario =   @usuario, 
                                clave = @clave, 
                                idRol = @idRol
                            WHERE usuario = @usuarioAnterior;
                    RETURN 1
                END          
        END
END
GO

CREATE PROCEDURE SP_EliminarUsuario
(
    @usuario NVARCHAR(26)
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;
            SELECT @existe = COUNT(Acceso.Usuarios.usuario) FROM Acceso.Usuarios WHERE usuario = @usuario;
            IF (@existe = 0)
                BEGIN
                    RAISERROR(N'No existe un usuario con el nombre "', 16, 1);
                    RETURN 0
                END     
            ELSE
                BEGIN
                    DELETE FROM Acceso.Usuarios WHERE usuario = @usuario;
                    RETURN 1
                END
END
GO
----------------------------------------------------------
--Modulo Proveedor

CREATE PROCEDURE SP_AgregarProveedor
(
	@nombre NVARCHAR(100),
	@telefono NVARCHAR(9),
	@direccion NVARCHAR(300)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.Proveedores.idProveedor) FROM Restaurante.Proveedores WHERE nombre = @nombre;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Ya existe un proveedor con el nombre  "%s"', 16, 1, @nombre);
			RETURN 0			
		END
	ELSE
		BEGIN
			INSERT INTO Restaurante.Proveedores(nombre, telefono, direccion)
				VALUES(@nombre, @telefono, @direccion)
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_ModificarProveedor
(
	@idProveedor INT,
	@nombre NVARCHAR(100),
	@telefono NVARCHAR(9),
	@direccion NVARCHAR(300)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(Restaurante.Proveedores.idProveedor) FROM Restaurante.Proveedores WHERE idProveedor = @idProveedor;

	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe el proveedor con el id %d"', 16, 1, @idProveedor);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE Restaurante.Proveedores
				SET 	nombre = @nombre,
						telefono = @telefono,
						direccion = @direccion
					WHERE idProveedor = @idProveedor;
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_EliminarProveedor
(
	@idProveedor INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
		SELECT @existe = COUNT(Restaurante.Proveedores.idProveedor) FROM Restaurante.Proveedores WHERE idProveedor = @idProveedor;
		IF (@existe = 0)
			BEGIN
				RAISERROR(N'No existe el proveedor con el id %d"', 16, 1, @idProveedor);
				RETURN 0
			END 	
		ELSE
			BEGIN
				DELETE FROM Restaurante.Proveedores	WHERE idProveedor = @idProveedor;
				RETURN 1
			END
END
GO
----------------------------------------------------------------------------------------
--Modulo Mesero
CREATE PROCEDURE SP_AgregarMesero
(
	@identidad NVARCHAR(15),
	@nombre NVARCHAR(25),
	@apellido NVARCHAR(25)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(Restaurante.Meseros.identidad) FROM Restaurante.Meseros WHERE identidad = @identidad;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Ya existe Un mesero con la identidad %s"', 16, 1, @identidad);
			RETURN 0		
		END
	ELSE
		BEGIN
			INSERT INTO Restaurante.Meseros(identidad, nombre, apellido)
				VALUES(	@identidad, @nombre, @apellido)
			RETURN 1
		END
END
GO

Create PROCEDURE SP_ModificarMesero
(	
	@id INT,
	@identidad NVARCHAR(15),
	@nombre NVARCHAR(25),
	@apellido NVARCHAR(25)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.Meseros.identidad) FROM Restaurante.Meseros WHERE identidad=@identidad;
	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe el mesero con la identidad %s"', 16, 1, @identidad);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE Restaurante.Meseros
				SET 	
						nombre = @nombre,
						apellido = @apellido
					WHERE identidad = @identidad;
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_EliminarMesero
(
	@id INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
			SELECT @existe = COUNT(Restaurante.Meseros.id) FROM Restaurante.Meseros WHERE id=@id;
		IF (@existe = 0)
			BEGIN
				RAISERROR(N'No existe el mesero con el id %d"', 16, 1, @id);
				RETURN 0
			END 	
		ELSE
			BEGIN
				DELETE FROM Restaurante.Meseros	WHERE id=@id;
				RETURN 1
			END
END
GO
-----------------------------------------------------------------------------------
--Modulo Insumos
USE DBRestauranteMarias
GO
ALTER PROCEDURE SP_AgregarInsumo
(
    @nombre NVARCHAR(100),
    @costo DECIMAL(4,2),
	@cantidad INT,
	@cantidadMinima INT,
    @idTipoUnidad INT,
    @descripcion NVARCHAR(200),
    @idProveedor INT
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;

    SELECT @existe = COUNT(Restaurante.Insumos.idInsumo) FROM Restaurante.Insumos WHERE nombre = @nombre;
    IF (@existe > 0)
        BEGIN
            RAISERROR(N'Ya existe un Insumo con el nombre %s"', 16, 1,@nombre);
            RETURN 0
            
        END
    ELSE
        BEGIN
            INSERT INTO Restaurante.Insumos(nombre, costo, cantidad,cantidadMinima,idTipoUnidad, descripcion, idProveedor)
                VALUES(@nombre, @costo, @cantidad,@cantidadMinima,@idTipoUnidad, @descripcion, @idProveedor)
            RETURN 1
        END
END
GO

ALTER PROCEDURE SP_ModificarInsumo
(
    @idInsumo INT,
    @nombre NVARCHAR(100),
    @costo DECIMAL(4,2),
	@cantidad INT,
	@cantidadMinima INT,
    @idTipoUnidad INT,
    @descripcion NVARCHAR(200),
    @idProveedor INT
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;

    SELECT @existe = COUNT(Restaurante.Insumos.IdInsumo) FROM Restaurante.Insumos WHERE IdInsumo = @idInsumo;

    IF (@existe = 0)
        BEGIN
            RAISERROR(N'No existe el insumo con el id %d"', 16, 1, @idInsumo);
            RETURN 0
        END     
    ELSE
        BEGIN
            UPDATE Restaurante.Insumos
                SET     nombre = @nombre,
                        costo = @costo,
						cantidad=@cantidad,
						cantidadMinima=@cantidadMinima ,
                        idTipoUnidad = @idTipoUnidad,
                        descripcion = @descripcion,
                        idProveedor = @idProveedor
                    WHERE idInsumo = @idInsumo;
            RETURN 1
        END
END
GO

CREATE PROCEDURE SP_EliminarInsumo
(
    @idInsumo INT
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;
        SELECT @existe = COUNT(Restaurante.Insumos.IdInsumo) FROM Restaurante.Insumos WHERE IdInsumo = @idInsumo;
        IF (@existe = 0)
            BEGIN
                RAISERROR(N'No existe el insumo con el id %d"', 16, 1, @idInsumo);
                RETURN 0
            END     
        ELSE
            BEGIN
                DELETE FROM Restaurante.Insumos WHERE idInsumo = @idInsumo;
                RETURN 1
            END
END
GO
--------------------------------------------------------------------------------------------
--Modulo Tipo de Unidad
CREATE PROCEDURE SP_InsertarTipoUnidad
(
    @descripcion NVARCHAR(100)
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;

    SELECT @existe = COUNT(Restaurante.TipoUnidad.idTipoUnidad) FROM Restaurante.TipoUnidad WHERE descripcion=@descripcion;
    IF (@existe > 0)
        BEGIN
            RAISERROR(N'Ya existe un Tipo de Unidad con el nombre "%s"', 16, 1,@descripcion);
            RETURN 0          
        END
    ELSE
        BEGIN
            INSERT INTO Restaurante.TipoUnidad(descripcion)
                VALUES(@descripcion)
            RETURN 1
        END
END
GO

CREATE PROCEDURE SP_ModificarTipoUnidad
(
    @idTipoUnidad INT,
    @descripcion NVARCHAR(100)
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;
    SELECT @existe = COUNT(Restaurante.TipoUnidad.idTipoUnidad) FROM Restaurante.TipoUnidad WHERE idTipoUnidad=@idTipoUnidad;
    IF (@existe = 0)
        BEGIN
            RAISERROR(N'No existe ning�n Tipo de Unidad con el id "%d"', 16, 1, @idTipoUnidad);
            RETURN 0
        END     
    ELSE
        BEGIN
            UPDATE Restaurante.TipoUnidad
                SET     descripcion = @descripcion
                    WHERE idTipoUnidad = @idTipoUnidad;
            RETURN 1
        END
END
GO

CREATE PROCEDURE SP_EliminarTipoUnidad
(
    @idTipoUnidad INT
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;
    SELECT @existe = COUNT(Restaurante.TipoUnidad.idTipoUnidad) FROM Restaurante.TipoUnidad WHERE idTipoUnidad=@idTipoUnidad;
    IF (@existe = 0)
        BEGIN
            RAISERROR(N'No existe ning�n Tipo de Unidad con el id "%d"', 16, 1, @idTipoUnidad);
            RETURN 0
        END     
    ELSE
        BEGIN
            DELETE FROM Restaurante.TipoUnidad  WHERE idTipoUnidad = @idTipoUnidad;
            RETURN 1
        END
END
GO
---------------------------------------------------------------------------------
--Modulo mesas

CREATE PROCEDURE SP_AgregarMesa
(
@estado NVARCHAR(21)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.Mesas.estado) FROM Restaurante.Mesas WHERE estado=@estado;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Ya existe una area con el nombre "%s"', 16, 1,@estado);
			RETURN 0
		END
	ELSE
		BEGIN
			INSERT INTO Restaurante.Mesas(estado)
				VALUES(@estado)
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_ModificarMesa
(
@id INT,
@estado NVARCHAR(21)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.Mesas.id) FROM Restaurante.Mesas WHERE id=@id;
	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe ninguna Mesa con el id "%d"', 16, 1, @id);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE Restaurante.Mesas
				SET estado = @estado
					WHERE id = @id;
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_EliminarMesa
(
@id INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
		SELECT @existe = COUNT(Restaurante.Mesas.id) FROM Restaurante.Mesas WHERE id=@id;
		IF (@existe = 0)
			BEGIN
				RAISERROR(N'No existe ninguna Mesa con el id "%d"', 16, 1);
				RETURN 0
			END 	
		ELSE
			BEGIN
				DELETE FROM Restaurante.Mesas WHERE id=@id;
				RETURN 1
			END
END
GO
----------------------------------------------------------------------------------
--Modulo Pedidos de Comida
/*
CREATE PROCEDURE SP_AgregarPedido
(
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(<esquema.tabla.campo>) FROM <Esquema.tabla> WHERE <condicion>;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Aqui va el mensaje de error"', 16, 1);
			RETURN 0
			
		END
	ELSE
		BEGIN
			INSERT INTO Acceso.TipoAcceso(<campo1>, <campo2>,.... ,<campoN>)
				VALUES(	<variable1>, <variable2>,...,<Variable3>)
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_ModificarPedido
(
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(<esquema.tabla.campo>) FROM <Esquema.tabla> WHERE <condicion>;

	IF (@existe = 0)
		BEGIN
			RAISERROR(N'Aqui va el mensaje de error"', 16, 1);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE <esquema.tabla>
				SET 	<campos=variables>
					WHERE <condicion>;
			RETURN 1
		END
	
	END
END
GO

CREATE PROCEDURE SP_EliminarPedido
(
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
		SELECT @existe = COUNT(<esquema.tabla.campo>) FROM <Esquema.tabla> WHERE <condicion>;
		IF (@existe = 0)
			BEGIN
				RAISERROR(N'aqui va el mensaje de error "', 16, 1);
				RETURN 0
			END 	
		ELSE
			BEGIN
				DELETE FROM <Esquema.tabla>	WHERE <condicion>;
				RETURN 1
			END
END
GO
--------------------------------------------------------------------------------------
--Modulo Factura
CREATE PROCEDURE SP_AgregarFactura
(
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(<esquema.tabla.campo>) FROM <Esquema.tabla> WHERE <condicion>;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Aqui va el mensaje de error"', 16, 1);
			RETURN 0
			
		END
	ELSE
		BEGIN
			INSERT INTO Acceso.TipoAcceso(<campo1>, <campo2>,.... ,<campoN>)
				VALUES(	<variable1>, <variable2>,...,<Variable3>)
			RETURN 1
		END
END
GO*/
-------------------------------------------------------------------------------------------------------------------
--Modulo Inventario 
CREATE PROCEDURE SP_AgregarInventario
(
	@descripcion NVARCHAR(100),
	@costo DECIMAL(4,2),
	@precioVenta DECIMAL(4,2),
	@cantidad DECIMAL(4,2),
	@idTipoProducto INT,
	@idProveedor INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.Inventario.idInventario) FROM Restaurante.Inventario WHERE descripcion = @descripcion;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Ya existe un Insumo con el nombre %s"', 16, 1,@descripcion);
			RETURN 0
		END
	ELSE
		BEGIN
			INSERT INTO Restaurante.Inventario(descripcion, costo, precioVenta, cantidad, idTipoProducto, idProveedor)
				VALUES(@descripcion, @costo, @precioVenta, @cantidad, @idTipoProducto, @idProveedor)
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_ModificarInventario
(
	@idInventario INT,
	@descripcion NVARCHAR(100),
	@costo DECIMAL(4,2),
	@precioVenta DECIMAL(4,2),
	@cantidad DECIMAL(4,2),
	@idTipoProducto INT,
	@idProveedor INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(Restaurante.Inventario.idInventario) FROM Restaurante.Inventario WHERE idInventario = @idInventario;

	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe el Producto con el id %d"', 16, 1, @idInventario);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE Restaurante.Inventario
				SET 	descripcion = @descripcion,
						costo = @costo,
						precioVenta = @precioVenta,
						cantidad = @cantidad,
						idTipoProducto = @idTipoProducto,
						idProveedor = @idProveedor
					WHERE idInventario = @idInventario;
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_EliminarInventario
(
	@idInventario INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
		SELECT @existe = COUNT(Restaurante.Inventario.idInventario) FROM Restaurante.Inventario WHERE idInventario = @idInventario;
		IF (@existe = 0)
			BEGIN
				RAISERROR(N'No existe el Producto con el id %d"', 16, 1, @idInventario);
				RETURN 0
			END 	
		ELSE
			BEGIN
				DELETE FROM Restaurante.Inventario WHERE idInventario = @idInventario;
				RETURN 1
			END
END
GO
--------------------------------------------------------------------------------------------------------
-- Modulo insumo Producto


CREATE PROCEDURE SP_AgregarInsumosProductos
(
	@idInsumo INT,
	@idInventario INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(Restaurante.InsumosProductos.idInsumoProducto) FROM Restaurante.InsumosProductos WHERE idInsumo = @idInsumo AND idInventario = @idInventario;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Ya existe ese Insumo', 16, 1);
			RETURN 0
			
		END
	ELSE
		BEGIN
			INSERT INTO Restaurante.InsumosProductos(idInsumo, idInventario)
				VALUES(@idInsumo, @idInventario)
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_ModificarInsumosProductos
(
	@idInsumoProducto INT,
	@idInsumo INT,
	@idInventario INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(Restaurante.InsumosProductos.idInsumoProducto) FROM Restaurante.InsumosProductos WHERE idInsumoProducto = @idInsumoProducto;

	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe el insumo en el producto con el id %d"', 16, 1, @idInsumoProducto);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE Restaurante.InsumosProductos
				SET 	idInsumo = @idInsumo,
						idInventario = @idInventario
					WHERE idInsumoProducto = @idInsumoProducto;
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_EliminarInsumosProductos
(
	@idInsumoProducto INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
		SELECT @existe = COUNT(Restaurante.InsumosProductos.idInsumoProducto) FROM Restaurante.InsumosProductos WHERE idInsumoProducto = @idInsumoProducto;
		IF (@existe = 0)
			BEGIN
				RAISERROR(N'No existe el insumo con el id %d"', 16, 1, @idInsumoProducto);
				RETURN 0
			END 	
		ELSE
			BEGIN
				DELETE FROM Restaurante.InsumosProductos WHERE idInsumoProducto = @idInsumoProducto;
				RETURN 1
			END
END
GO
-------------------------------------------------
--Modulo Categoria de Producto
CREATE PROCEDURE SP_AgregarCategoriaProducto
(
	@descripcion NVARCHAR(100)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;

	SELECT @existe = COUNT(Restaurante.CategoriaProducto.idCategoria) FROM Restaurante.CategoriaProducto WHERE descripcion=@descripcion;
	IF (@existe > 0)
		BEGIN
			RAISERROR(N'Ya existe un Tipo de Unidad con el nombre "%s"', 16, 1,@descripcion);
			RETURN 0
			
		END
	ELSE
		BEGIN
			INSERT INTO Restaurante.CategoriaProducto(descripcion)
				VALUES(@descripcion)
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_ModificarCategoriaProducto
(
	@idCategoriaProducto INT,
	@descripcion NVARCHAR(100)
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.CategoriaProducto.idCategoria) FROM Restaurante.CategoriaProducto WHERE idCategoria=@idCategoriaProducto;
	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe ning�n Tipo de Unidad con el id "%d"', 16, 1, @idCategoriaProducto);
			RETURN 0
		END 	
	ELSE
		BEGIN
			UPDATE Restaurante.CategoriaProducto
				SET 	descripcion = @descripcion
					WHERE idCategoria = @idCategoriaProducto;
			RETURN 1
		END
END
GO

CREATE PROCEDURE SP_EliminarCategoriaProducto
(
	@idCategoriaProducto INT
)
AS
BEGIN
	DECLARE @existe int;
	SET @existe = 0;
	SELECT @existe = COUNT(Restaurante.CategoriaProducto.idCategoria) FROM Restaurante.CategoriaProducto WHERE idCategoria=@idCategoriaProducto;
	IF (@existe = 0)
		BEGIN
			RAISERROR(N'No existe ning�n Tipo de Unidad con el id "%d"', 16, 1, @idCategoriaProducto);
			RETURN 0
		END 	
	ELSE
		BEGIN
			DELETE FROM Restaurante.CategoriaProducto	WHERE idCategoria = @idCategoriaProducto;
			RETURN 1
		END
END
GO
---------------------------------------------------------
--Modulo Tipo de Producto
CREATE PROCEDURE SP_InsertarTipoProducto
(
    @nombre NVARCHAR(100)
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;

    SELECT @existe = COUNT(Restaurante.TipoProducto.idTipoProducto) FROM Restaurante.TipoProducto WHERE nombre=@nombre;
    IF (@existe > 0)
        BEGIN
            RAISERROR(N'Ya existe un Tipo de Unidad con el nombre "%s"', 16, 1,@nombre);
            RETURN 0          
        END
    ELSE
        BEGIN
            INSERT INTO Restaurante.TipoProducto(nombre)
                VALUES(@nombre)
            RETURN 1
        END
END
GO

CREATE PROCEDURE SP_ModificarTipoProducto
(
    @idTipoProducto INT,
    @nombre NVARCHAR(100)
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;
    SELECT @existe = COUNT(Restaurante.TipoProducto.idTipoProducto) FROM Restaurante.TipoProducto WHERE idTipoProducto=@idTipoProducto;
    IF (@existe = 0)
        BEGIN
            RAISERROR(N'No existe ning�n Tipo de Unidad con el id "%d"', 16, 1, @idTipoProducto);
            RETURN 0
        END     
    ELSE
        BEGIN
            UPDATE Restaurante.TipoProducto
                SET     nombre = @nombre
                    WHERE idTipoProducto = @idTipoProducto;
            RETURN 1
        END
END
GO

CREATE PROCEDURE SP_EliminarTipoProducto
(
    @idTipoProducto INT
)
AS
BEGIN
    DECLARE @existe int;
    SET @existe = 0;
    SELECT @existe = COUNT(Restaurante.TipoProducto.idTipoProducto) FROM Restaurante.TipoProducto WHERE idTipoProducto=@idTipoProducto;
    IF (@existe = 0)
        BEGIN
            RAISERROR(N'No existe ning�n Tipo de Producto con el id "%d"', 16, 1, @idTipoProducto);
            RETURN 0
        END     
    ELSE
        BEGIN
            DELETE FROM Restaurante.TipoProducto  WHERE idTipoProducto = @idTipoProducto;
            RETURN 1
        END
END
GO
/*
----------------------------------------------------------------------------------------------------------------
--SP para actualizar el stock dela Tabla Inventario.Articulos 
CREATE PROCEDURE Inventario.SPActualizarArticulos(
	@CodigoArticulo VARCHAR(15),
	@Stock INT
  )
AS
BEGIN
	DECLARE @Codigo INT
	DECLARE @CodigoProducto VARCHAR(15) = @CodigoArticulo

	EXEC @Codigo = Inventario.SPEstadoDelArticulo @CodigoProducto
	IF @Codigo = 1
		PRINT 'Debe ingresar el codigo del Articulo'
	ELSE
		IF @Codigo = 2
			PRINT 'El Codigo del producto ingresado no es v�lido'
		ELSE
			IF @Codigo = 3
				PRINT 'No hay existencia de este producto'
			ELSE
				IF @Codigo = 0
					PRINT 'Producto encontrado'

	DECLARE @Stock1 INT 
	SELECT @Stock1 = Stock FROM Inventario.Articulos
			WHERE Codigo = @CodigoProducto

UPDATE Inventario.Articulos
SET Stock = @Stock1 + @Stock
FROM Inventario.Articulos
WHERE Codigo = @CodigoProducto

END
--Probando con valores Incorrectos
EXEC Inventario.SPActualizarArticulos '3 154141 194108';
--Probando Valores Correctos
EXEC Inventario.SPActualizarArticulos '3 154141 194108',4;
GO
------------------------------------------------------------------------------------------------
	-- Creaci�n de un Stored Procedure que se encarga de ingresar
	-- valores a la tabla Factura 
CREATE PROCEDURE SP_sFacturas(
	@IdCliente CHAR(15)=NULL ,
	@IdVendedor INT = NULL
)
AS
BEGIN
	IF (@IdVendedor IS NULL) OR (@IdCliente IS NULL) 
		BEGIN
			RAISERROR('El Codigo de Vendedor, Cliente son requeridos.', 16, 1)
			RETURN 0
		END
	ELSE
		BEGIN
		--Declaramos las Variables las cuales nos serviran al momento de la inserci�n
		DECLARE @Vendedor INT  = @IdVendedor
		DECLARE @Cliente CHAR (15) = @IdCliente
		DECLARE @ImporteISV DECIMAL(10,2) = 0
		DECLARE @Impuesto DECIMAL(10,2) = 0
		DECLARE @Total DECIMAL(10,2) = 0
		INSERT INTO Facturacion.Factura(IdVendedor,IdCliente, ImporteISV,Impuesto,Total )
				VALUES(@Vendedor,@Cliente,@ImporteISV,@Impuesto,@Total)
			RETURN 1
		END
END
GO



---------------------------------------------------------------------------------------
    -- Creaci�n de un Stored Procedure que se encarga de ingresar
	-- valores a la tabla Detalle Factura 
CREATE PROCEDURE Facturacion.SPDetalleFacturas(
	@CodigoArticulo VARCHAR (15) = NULL, 
	@CantidadArticulo INT = NULL
)
AS
BEGIN
	IF (@CodigoArticulo IS NULL) OR (@CantidadArticulo IS NULL)
		BEGIN
			RAISERROR('El Codigo de Producto e igual que la Cantidad son requeridos.', 16, 1)
			RETURN 0
		END
	ELSE
--Declaramos las variables a utilizar
	DECLARE @NumeroFactura INT
	DECLARE @Codigo INT
	DECLARE @CodigoArticulo1 VARCHAR(15) = @CodigoArticulo
	DECLARE @PrecioUnitario DECIMAL (10,2)
	DECLARE @SubTotal DECIMAL (10,2)

-- Verificar Codigo de Producto
	EXEC @Codigo = Inventario.SPEstadoDelArticulo @CodigoArticulo1
	IF @Codigo = 1
		PRINT 'Debe ingresar el codigo del Articulo'
	ELSE
		IF @Codigo = 2
			PRINT 'El Codigo del producto ingresado no es v�lido'
		ELSE
			IF @Codigo = 3
				PRINT 'No hay existencia de este producto'
			ELSE
				IF @Codigo = 0
					PRINT 'Producto encontrado'
--BUSCANDO VALORES
		SET @NumeroFactura = (SELECT MAX(Numero) FROM Facturacion.Factura)
		SELECT @PrecioUnitario = PrecioVenta FROM Inventario.Articulos
		WHERE Codigo = @CodigoArticulo
		SET @SubTotal = @PrecioUnitario * @CantidadArticulo
		DECLARE @Impuesto DECIMAL(10,2)
		DECLARE @Importe DECIMAL(10,2)
--Ejecutamos los Stored Procedure de calculo de impuesto e importe
		EXEC Facturacion.SPCalculoImporte @CodigoArticulo,@SubTotal,@Importe OUTPUT
		EXEC Facturacion.SPExcentoImpuesto @CodigoArticulo,@Importe,@Impuesto OUTPUT
--Insertamos los datos en la tabla Detalle Factura
		INSERT INTO Facturacion.DetalleFactura(NumeroFactura,CodigoArticulo,CantidadArticulo,PrecioUnitario,Subtotal) 
			VALUES (@NumeroFactura,@CodigoArticulo1,@CantidadArticulo,@PrecioUnitario,@SubTotal)
		
				IF ((SELECT Stock FROM Inventario.Articulos 
					WHERE Codigo = @CodigoArticulo1)<=(SELECT CantidadMinima FROM Inventario.Articulos
					WHERE Codigo = @CodigoArticulo1))
				BEGIN
					PRINT 'Se ha alcanzado el inventario minimo para el producto '+ @CodigoArticulo1 +'. Considere contactar a su proveedor.'
				END
--Actualizamos nuestro encabezado en la Tabla Factura para los campos
--IMPUESTO,IMPORTEISV,TOTAL		
		UPDATE Facturacion.Factura
		SET ImporteISV=@Importe,Impuesto = @Impuesto, Total = @SubTotal
		FROM Facturacion.Factura
		INNER JOIN Facturacion.DetalleFactura
		ON @NumeroFactura=Numero
		WHERE Numero= @NumeroFactura
END
GO
*/