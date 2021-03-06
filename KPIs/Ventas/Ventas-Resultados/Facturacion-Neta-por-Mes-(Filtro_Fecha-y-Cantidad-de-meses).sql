-- Nombre: Facturación Neta por Mes

-- Descripción:
-- Venta Neta por Mes.
-- Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
-- Venta neta = Monto Facturado - Devoluciones - Anulaciones.
-- Filtro:  rango de fechas y Cantidad de meses por deplegar.
-- Filtro obligatorio:  rango de fechas y Cantidad de meses por deplegar.
SELECT ild.dateinvoicedmonth as "Mes", sum(ild.linenetamtreal) as "Facturado", abs(sum(linenetamtvoided)) as "Anulaciones", sum(ild.linenetamtreturned) as "Devoluciones", sum(ild.netsales) as "Venta Neta"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','VO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
GROUP BY ild.dateinvoicedmonth
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeMeses}}