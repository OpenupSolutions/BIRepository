-- Nombre: Facturación, Costo y Margen de ganancia (monto) por Mes

-- Descripción:
-- Venta bruta, costos y margen de ganancia (monto) por Mes.
--Venta bruta=Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
--Margen de ganancia  = Monto Facturado - Costos
--El margen de ganancia no incluye devoluciones ni anulaciones.
--Si hay una cantidad considerable de devoluciones y anulaciones, éste dato no concuerda con la realidad.
--Filtro:  rango de fechas y Cantidad de meses por desplegar.
--Filtro obligatorio:  rango de fechas y Cantidad de meses por desplegar.
SELECT ild.dateinvoicedmonth as "Mes", sum(ild.linenetamtreal) as "Facturado", sum(ild.transactioncost) as "Costo", sum(marge_abs) as "Margen (monto)"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000001 
AND issotrx = 'Y'
AND docstatus in ('CO') 
AND docbasetype = 'ARI' 
AND producttype = 'I' 
GROUP BY ild.dateinvoicedmonth
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeMeses}}