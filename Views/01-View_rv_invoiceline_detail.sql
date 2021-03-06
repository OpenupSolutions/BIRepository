﻿-- Materialized view for sales
-- displays invoice lines
-- includes costs, redundant names

-- Materialized View: rv_invoiceline_detail

-- DROP MATERIALIZED VIEW rv_invoiceline_detail;

CREATE MATERIALIZED VIEW rv_invoiceline_detail AS
 SELECT i.ad_client_id,
    i.ad_org_id,
    i.dateinvoiced,
    to_char(i.dateinvoiced::date::timestamp with time zone, 'dd/mm/yyyy'::text) AS dateinvoicedformatted,
    trunc(i.dateinvoiced::timestamp with time zone, 'YEAR'::character varying) AS dateinvoicedyear,
    date_part('YEAR'::text, i.dateinvoiced) AS dateinvoicedonlyyear,
    to_char(i.dateinvoiced::date::timestamp with time zone, 'MM'::text) AS monthinvoicedformatted,
    trunc(i.dateinvoiced::timestamp with time zone, 'MONTH'::character varying) AS dateinvoicedmonth,
    date_part('MONTH'::text, i.dateinvoiced) AS dateinvoicedonlymonth,
    i.issotrx,
    i.documentno,
    i.docstatus,
    usr.name AS salesrepname,
    usr.value AS salesrepvalue,
    p.name AS productname,
    p.value AS productvalue,
    pc.name AS pcatname,
    pc.value AS pcatvalue,
    vnd.value AS vendorvalue,
    vnd.name AS vendorname,
    il.qtyinvoiced,
    COALESCE(uomtrl.name, uom.name) AS uomname,
    il.priceactual,
    il.linetotalamt,
    COALESCE(taxtrl.name, tax.name) AS tax,
    linenetamtrealinvoiceline(il.c_invoiceline_id) AS linenetamtreal,
    linenetamtreturned(il.c_invoiceline_id) AS linenetamtreturned,
    abs(linenetamtvoided(il.reversalline_id)) AS linenetamtvoided,
    0 AS linenetamtreinvoiced,
    linenetamtrealinvoiceline(il.c_invoiceline_id) + linenetamtvoided(il.reversalline_id) - linenetamtreturned(il.c_invoiceline_id) AS netsales,
    i.c_invoice_id,
    p.m_product_id,
    vnd.c_bpartner_id,
    usr.ad_user_id,
    COALESCE(dtt.name, dt.name) AS doctypename,
    i.c_doctype_id,
    dt.docbasetype,
    il.c_invoiceline_id,
        CASE
            WHEN charat(dt.docbasetype::character varying, 3)::text = 'C'::text THEN '-1'::integer
            ELSE 1
        END AS multiplier,
    bp.c_bpartner_id AS customer_id,
    round(il.linenetamt, 2) AS linenetamt,
    per.c_period_id,
    i.salesrep_id,
    p.m_product_category_id,
    i.c_bpartner_location_id,
    gettransactioncost(il.c_invoiceline_id) AS transactioncost,
    gettransactionmarge(il.c_invoiceline_id) AS transactionmarge,
    bp.name AS customername,
    bp.value AS customervalue,
    ppo.pricelastpo,
    ppo.pricelastinv,
    ppo.vendorproductno,
    ppo.pricepo AS ppo_pricepo,
    ppo.order_min,
    gettransactionpurchaseprice(il.c_invoiceline_id) AS pricepo,
    gettransactionmarge_abs(il.c_invoiceline_id) AS marge_abs,
    p.M_Product_Group_ID,
    p.producttype,
    i.C_Currency_ID,
    sc.S_Contract_ID,
    camp.C_Campaign_ID,
    camp.name campaign_name,
    pg.name product_group_name,
	sc.name contract_name,
	i.User1_ID,
	usr1.name usr1_name,
	usr1.value usr1_value,
	i.User3_ID,
	usr3.name usr3_name,
	usr3.value usr3_value,
	i.User4_ID,
	usr4.name usr4_name,
	usr4.value usr4_value
   FROM c_invoice i
     JOIN c_invoiceline il ON i.c_invoice_id = il.c_invoice_id
     JOIN ad_client cl ON i.ad_client_id = cl.ad_client_id
     JOIN c_uom uom ON il.c_uom_id = uom.c_uom_id
     LEFT JOIN c_uom_trl uomtrl ON uom.c_uom_id = uomtrl.c_uom_id AND cl.ad_language::text = uomtrl.ad_language::text
     JOIN c_tax tax ON il.c_tax_id = tax.c_tax_id
     LEFT JOIN c_tax_trl taxtrl ON tax.c_tax_id = taxtrl.c_tax_id AND cl.ad_language::text = taxtrl.ad_language::text
     JOIN m_product p ON il.m_product_id = p.m_product_id
     LEFT JOIN M_Product_Group pg ON p.M_Product_Group_ID=pg.M_Product_Group_ID
     JOIN m_product_category pc ON p.m_product_category_id = pc.m_product_category_id
     LEFT JOIN m_product_po ppo ON p.m_product_id = ppo.m_product_id AND ppo.iscurrentvendor = 'Y'::bpchar
     LEFT JOIN c_bpartner vnd ON ppo.c_bpartner_id = vnd.c_bpartner_id
     JOIN ad_user usr ON i.salesrep_id = usr.ad_user_id
     JOIN c_doctype dt ON i.c_doctype_id = dt.c_doctype_id
     LEFT JOIN c_doctype_trl dtt ON dt.c_doctype_id = dtt.c_doctype_id AND cl.ad_language::text = dtt.ad_language::text
     LEFT JOIN c_period per ON i.dateinvoiced >= per.startdate AND i.dateinvoiced <= per.enddate AND per.ad_client_id = i.ad_client_id
     JOIN c_bpartner bp ON i.c_bpartner_id = bp.c_bpartner_id
     LEFT JOIN S_Contract sc ON i.S_Contract_ID=sc.S_Contract_ID
     LEFT JOIN C_Campaign camp ON i.C_Campaign_ID=camp.C_Campaign_ID
	 LEFT JOIN C_ElementValue usr1 ON i.User1_ID=usr1.C_ElementValue_ID
	 LEFT JOIN C_ElementValue usr3 ON i.User3_ID=usr3.C_ElementValue_ID
	 LEFT JOIN C_ElementValue usr4 ON i.User4_ID=usr4.C_ElementValue_ID
WITH DATA;

ALTER TABLE rv_invoiceline_detail
  OWNER TO adempiere;
