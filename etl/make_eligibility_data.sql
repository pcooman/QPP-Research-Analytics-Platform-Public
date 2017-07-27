--Set seed for RANDOM()
SET SEED TO 0.25;

--Create a table with fake charges per provider data
CREATE TABLE public.cms_charges_per_provider
DISTKEY (npi)
SORTKEY (npi) AS (
  SELECT
    npi
    ,CASE WHEN (individual_low_vol_stus_rsn_cd='BOTH' OR individual_low_vol_stus_rsn_cd='CHRG')
      THEN CAST(RANDOM() * 20000 + 5000 AS INT)
      ELSE CAST(RANDOM() * 50000 + 35000 AS INT)
      END AS total_charges
  FROM public.cms_eligibility);

--Create a table with fake beneficiaries per provider data
CREATE TABLE public.cms_beneficiaries_per_provider
DISTKEY (npi)
SORTKEY (npi) AS (
  SELECT
    npi
    ,CASE WHEN (individual_low_vol_stus_rsn_cd='BOTH' OR individual_low_vol_stus_rsn_cd='BENE')
      THEN CAST(RANDOM() * 90 + 5 AS INT)
      ELSE CAST(RANDOM() * 350 + 125 AS INT)
      END AS total_beneficiaries
  FROM public.cms_eligibility);

--Join fake data back to provider eligibility table
CREATE TABLE public.cms_eligibility_appended
DISTKEY(npi)
SORTKEY(npi) AS (
  SELECT *
  FROM public.cms_eligibility
  LEFT JOIN public.cms_charges_per_provider
    USING (npi)
  LEFT JOIN public.cms_beneficiaries_per_provider
    USING (npi)
  );
