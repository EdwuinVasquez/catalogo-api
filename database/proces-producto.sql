-- LISTAR PRODUCTOS --
DROP PROCEDURE IF EXISTS `PROCEDURE_LISTAR_PRODUCTOS`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_LISTAR_PRODUCTOS`()
BEGIN
	SELECT 
	*,
	(IFNULL((SELECT COUNT(ITEM.ID_PRODUCTO) FROM ITEM WHERE ITEM.ID_PRODUCTO = PRODUCTO.CODIGO_PRODUCTO), 0)) AS "NUMERO_VENTAS",
	(SELECT CATEGORIA.DISPONIBILIDAD FROM CATEGORIA WHERE CATEGORIA.CODIGO_CATEGORIA = PRODUCTO.ID_CATEGORIA) AS "CATEGORIA_DISPONIBLE"
	FROM PRODUCTO
	INNER JOIN PRODUCTO_INFORMACION ON PRODUCTO.CODIGO_PRODUCTO = PRODUCTO_INFORMACION.ID_PRODUCTO
	INNER JOIN CATEGORIA ON PRODUCTO.ID_CATEGORIA = CATEGORIA.CODIGO_CATEGORIA
	ORDER BY PRODUCTO.ID_CATEGORIA ASC;
END $$
DELIMITER ;

-- REGISTAR PRODUCTO --
DROP PROCEDURE IF EXISTS `PROCEDURE_INGRESAR_PRODUCTO`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_INGRESAR_PRODUCTO`
	(IN VAR_CODIGO_PRODUCTO DOUBLE,IN VAR_NOMBRE_PRODUCTO VARCHAR(700),IN VAR_IMAGEN_PRINCIPAL VARCHAR(1000),IN VAR_IVA DOUBLE,IN VAR_DESCUENTO DOUBLE,IN VAR_PRECIO_BASE DOUBLE,IN VAR_DETALLES VARCHAR(3000),IN VAR_PRODUCTO_DISPONIBLE DOUBLE,IN VAR_ESTADO_PRODUCTO DOUBLE,IN VAR_ID_CATEGORIA DOUBLE)
BEGIN
	DECLARE DEC_VACIO DOUBLE;
	SET DEC_VACIO = (SELECT CODIGO_PRODUCTO FROM PRODUCTO WHERE CODIGO_PRODUCTO = VAR_CODIGO_PRODUCTO);
	SET DEC_VACIO = (SELECT IFNULL(DEC_VACIO, 0));
	IF(DEC_VACIO = 0 ) THEN
		DELETE FROM PRODUCTO_INFORMACION WHERE ID_PRODUCTO = VAR_CODIGO_PRODUCTO;
	  INSERT INTO PRODUCTO (CODIGO_PRODUCTO, NOMBRE_PRODUCTO, IMAGEN_PRINCIPAL, IVA, DESCUENTO, PRECIO_BASE, DETALLES, PRODUCTO_DISPONIBLE, ESTADO_PRODUCTO, ID_CATEGORIA) 
	  VALUES (VAR_CODIGO_PRODUCTO, UPPER(VAR_NOMBRE_PRODUCTO), VAR_IMAGEN_PRINCIPAL, VAR_IVA, VAR_DESCUENTO, VAR_PRECIO_BASE, UPPER(VAR_DETALLES), VAR_PRODUCTO_DISPONIBLE, VAR_ESTADO_PRODUCTO, VAR_ID_CATEGORIA);
	ELSE
		DELETE FROM PRODUCTO_INFORMACION WHERE ID_PRODUCTO = VAR_CODIGO_PRODUCTO;
		UPDATE PRODUCTO
		SET 
			NOMBRE_PRODUCTO = UPPER(VAR_NOMBRE_PRODUCTO), 
			IMAGEN_PRINCIPAL = VAR_IMAGEN_PRINCIPAL, 
			IVA = VAR_IVA, 
			DESCUENTO = VAR_DESCUENTO, 
			PRECIO_BASE = VAR_PRECIO_BASE, 
			DETALLES = UPPER(VAR_DETALLES), 
			PRODUCTO_DISPONIBLE = VAR_PRODUCTO_DISPONIBLE, 
			ESTADO_PRODUCTO = VAR_ESTADO_PRODUCTO, 
			ID_CATEGORIA = ID_CATEGORIA
		WHERE CODIGO_PRODUCTO = VAR_CODIGO_PRODUCTO;
	END IF;
	 	SELECT CODIGO_PRODUCTO FROM PRODUCTO WHERE CODIGO_PRODUCTO = VAR_CODIGO_PRODUCTO;
END $$
DELIMITER ;

-- REGISTAR PRODUCTO INFORMACION ADICIONAL --
DROP PROCEDURE IF EXISTS `PROCEDURE_INGRESAR_PRODUCTOINFO`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_INGRESAR_PRODUCTOINFO`
	(IN VAR_CODIGO_PRODUCTO DOUBLE,IN VAR_NOMBRE_ESTILO VARCHAR(700),IN VAR_TIPO_CONTENIDO DOUBLE, IN VAR_CONTENIDO VARCHAR(1000),IN VAR_IMAGEN_EXTRA VARCHAR(1000),IN VAR_DISPONIBLE DOUBLE)
BEGIN
	INSERT INTO PRODUCTO_INFORMACION (NOMBRE_ESTILO, TIPO_CONTENIDO, CONTENIDO, IMAGEN_EXTRA, INFORMACION_ADICIONAL, DISPONIBLE, STOCK, ID_PRODUCTO) 
	VALUES (UPPER(VAR_NOMBRE_ESTILO), VAR_TIPO_CONTENIDO, VAR_CONTENIDO, VAR_IMAGEN_EXTRA, "", 1, 0, VAR_CODIGO_PRODUCTO);
END $$
DELIMITER ;

-- ELIMINAR PRODUCTO --
DROP PROCEDURE IF EXISTS `PROCEDURE_ELIMINAR_PRODUCTO`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_ELIMINAR_PRODUCTO`(IN VAR_CODIGO_PRODUCTO DOUBLE)
BEGIN
	DECLARE DEC_VACIO, DEC_NUMEROCOMPRAS DOUBLE;
	SET DEC_VACIO = (SELECT IFNULL(VAR_CODIGO_PRODUCTO, 0));
	SET DEC_NUMEROCOMPRAS = (SELECT COUNT(ID_PRODUCTO) FROM ITEM WHERE ID_PRODUCTO = VAR_CODIGO_PRODUCTO);

	IF((DEC_NUMEROCOMPRAS = 0 AND DEC_VACIO != 0)) THEN
		DELETE FROM PRODUCTO_INFORMACION WHERE ID_PRODUCTO = VAR_CODIGO_PRODUCTO;
		DELETE FROM PRODUCTO WHERE CODIGO_PRODUCTO = VAR_CODIGO_PRODUCTO;
		SELECT "PRODUCTO ELIMINADO" AS "RESULTADO";
	ELSE 
		SELECT "ERROR EL PRODUCTO NO SE PUEDE BORRAR YA QUE PODRIA AFECTAR GRAVEMENTE LOS DATOS ALMACENADO"  AS "RESULTADO";
	END IF;
END $$
DELIMITER ;

-- SIN STOCK O CON STOCK PRODUCTOS --
DROP PROCEDURE IF EXISTS `PROCEDURE_MODIFICAR_ESTADOPRODUCTO_PRODUCTO`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_MODIFICAR_ESTADOPRODUCTO_PRODUCTO`(IN VAR_CODIGO_PRODUCTO DOUBLE, IN VAR_ESTADO DOUBLE)
BEGIN
	DECLARE DEC_VACIO DOUBLE;
	SET DEC_VACIO = (SELECT IFNULL(VAR_CODIGO_PRODUCTO, 0));
	IF(DEC_VACIO != 0 AND (VAR_ESTADO = 6 OR VAR_ESTADO = 7)) THEN
		UPDATE PRODUCTO
		SET ESTADO_PRODUCTO = VAR_ESTADO
		WHERE CODIGO_PRODUCTO = VAR_CODIGO_PRODUCTO;
		SELECT CONCAT("PRODUCTO ", VAR_CODIGO_PRODUCTO, " MODIFICADO") AS "RESULTADO";
	ELSE
		SELECT CONCAT("PRODUCTO ", VAR_CODIGO_PRODUCTO, " NO SE PUDO MODIFICAR") AS "RESULTADO";
	END IF;
END $$
DELIMITER ;

-- ACTIVO O DESACTIVO PRODUCTOS --
DROP PROCEDURE IF EXISTS `PROCEDURE_MODIFICAR_DISPONIBILIDADPRODUCTO_PRODUCTO`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_MODIFICAR_DISPONIBILIDADPRODUCTO_PRODUCTO`(IN VAR_CODIGO_PRODUCTO DOUBLE, IN VAR_ESTADO DOUBLE)
BEGIN
	DECLARE DEC_VACIO DOUBLE;
	SET DEC_VACIO = (SELECT IFNULL(VAR_CODIGO_PRODUCTO, 0));
	IF(DEC_VACIO != 0 AND (VAR_ESTADO = 0 OR VAR_ESTADO = 1)) THEN
		UPDATE PRODUCTO
		SET ESTADO_PRODUCTO = VAR_ESTADO
		WHERE CODIGO_PRODUCTO = VAR_CODIGO_PRODUCTO;
		SELECT CONCAT("PRODUCTO ", VAR_CODIGO_PRODUCTO, " MODIFICADO") AS "RESULTADO";
	ELSE
		SELECT CONCAT("PRODUCTO ", VAR_CODIGO_PRODUCTO, " NO SE PUDO MODIFICAR") AS "RESULTADO";
	END IF;
END $$
DELIMITER ;