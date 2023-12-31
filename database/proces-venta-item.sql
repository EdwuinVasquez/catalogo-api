-- REGISTAR ITEM --
DROP PROCEDURE IF EXISTS `PROCEDURE_INGRESAR_ITEMVENTA`;

DELIMITER $$
CREATE PROCEDURE `PROCEDURE_INGRESAR_ITEMVENTA`
	(IN VAR_NOMBREITEM VARCHAR(1600), IN VAR_INFORMACIONADICIONAL VARCHAR(3000), IN VAR_DESCUENTO DOUBLE, IN VAR_IVA DOUBLE, IN VAR_CANTIDAD DOUBLE, IN VAR_VALORBASE DOUBLE, IN VAR_VALORIVA DOUBLE, IN VAR_VALORDESCUENTO DOUBLE, IN VAR_VALORTOTAL DOUBLE, IN VAR_IDPRODUCTO DOUBLE, IN VAR_IDVENTA DOUBLE)
BEGIN
	DECLARE VERIFICADOR DOUBLE;
	SET VERIFICADOR = (SELECT COUNT(ITEM.NOMBRE_ITEM) FROM ITEM WHERE ITEM.NOMBRE_ITEM = UPPER(VAR_NOMBREITEM) AND ITEM.ID_VENTA = VAR_IDVENTA); 
	SET VERIFICADOR = (SELECT IFNULL(VERIFICADOR, 0));

	IF(VERIFICADOR != 0) THEN
		INSERT INTO ITEM (NOMBRE_ITEM, INFORMACION_ADICIONAL, DESCUENTO, IVA, CANTIDAD, VALOR_BASE, VALOR_IVA, VALOR_DESCUENTO, VALOR_TOTAL, ID_PRODUCTO, ID_VENTA) 
		VALUES (UPPER(VAR_NOMBREITEM), UPPER(VAR_INFORMACIONADICIONAL), VAR_DESCUENTO, VAR_IVA , VAR_CANTIDAD, VAR_VALORBASE, VAR_VALORIVA, VAR_VALORDESCUENTO, VAR_VALORTOTAL, VAR_IDPRODUCTO, VAR_IDVENTA);
	ELSE 
		DELETE FROM ITEM WHERE ITEM.NOMBRE_ITEM = UPPER(VAR_NOMBREITEM) AND ITEM.ID_VENTA = VAR_IDVENTA;
		INSERT INTO ITEM (NOMBRE_ITEM, INFORMACION_ADICIONAL, DESCUENTO, IVA, CANTIDAD, VALOR_BASE, VALOR_IVA, VALOR_DESCUENTO, VALOR_TOTAL, ID_PRODUCTO, ID_VENTA) 
		VALUES (UPPER(VAR_NOMBREITEM), UPPER(VAR_INFORMACIONADICIONAL), VAR_DESCUENTO, VAR_IVA , VAR_CANTIDAD, VAR_VALORBASE, VAR_VALORIVA, VAR_VALORDESCUENTO, VAR_VALORTOTAL, VAR_IDPRODUCTO, VAR_IDVENTA);
	END IF;
END $$
DELIMITER ;