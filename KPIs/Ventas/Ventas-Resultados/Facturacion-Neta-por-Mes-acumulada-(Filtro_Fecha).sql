--- Nombre: Facturación Neta por Mes acumulada

--Descripción
-- Venta Neta acumulada por Mes: a cada mes se le suman los meses anteriores.
-- Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
-- Venta neta = Monto Facturado - Devoluciones - Anulaciones.
-- Filtro: rango de fechas.
-- Filtro obligatorio: rango de fechas.
SELECT ild.dateinvoicedmonth AS "Mes", 
sum(ild.linenetamtreal) AS "Facturado", 
sum(sum(ild.linenetamtreal)) OVER (ORDER BY ild.dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Facturado acumulado",

abs(sum(linenetamtvoided)) AS "Anulaciones", 
sum(abs(sum(linenetamtvoided))) OVER (ORDER BY ild.dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Anulaciones acumulado",

sum(ild.linenetamtreturned) AS "Devoluciones",
sum(sum(ild.linenetamtreturned)) OVER (ORDER BY ild.dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Devoluciones acumulado",

sum(ild.netsales) AS "Venta Neta",
sum(sum(ild.netsales)) OVER (ORDER BY ild.dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Venta Neta  acumulado"


FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000001 -- AD_Client_ID -> ZonaPhone 
AND issotrx = 'Y'
AND docstatus in ('CO','VO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
GROUP BY ild.dateinvoicedmonth
ORDER BY ild.dateinvoicedmonth ASC