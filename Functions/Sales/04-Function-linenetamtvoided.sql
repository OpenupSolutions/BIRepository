-- voided amt (invoice voided) for a given invoiceline
-- when column C_Invoiceline.i_Isimported does not exist, delete line

-- Function: linenetamtvoided(numeric)

-- DROP FUNCTION linenetamtvoided(numeric);

CREATE OR REPLACE FUNCTION linenetamtvoided(p_invoicereversalline_id numeric)
  RETURNS numeric AS
$BODY$



DECLARE

	v_reversallinenetamt	numeric;

	v_reversallinenetamtreal numeric;

BEGIN

	v_reversallinenetamt    = 0;

	v_reversallinenetamtreal= 0;

	

	IF (p_invoicereversalline_id = 0) THEN

		RETURN v_reversallinenetamtreal;

	END IF;

	

	SELECT	COALESCE (linenetamt, 0)

        INTO	v_reversallinenetamt

   	FROM	C_Invoiceline

	WHERE C_Invoiceline_ID=p_invoicereversalline_id

  -- Head documentation: C_Invoiceline.i_Isimported does not exist, delete line
	-- AND (i_Isimported = 'N' OR (i_Isimported='Y' and importtype = 'RE'))
	;

	

	IF (v_reversallinenetamt = 0) THEN

		RETURN v_reversallinenetamtreal;

	END IF;



	v_reversallinenetamtreal = linenetamtrealinvoiceline(p_invoicereversalline_id);

	RETURN  coalesce(v_reversallinenetamtreal, 0);

END;



$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION linenetamtvoided(numeric)
  OWNER TO adempiere;
