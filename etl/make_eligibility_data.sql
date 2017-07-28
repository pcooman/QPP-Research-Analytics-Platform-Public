--Set seed for RANDOM()
SET SEED TO 0.25;

--Create an unique id for joining tables (since there are NPI duplicates)
DROP TABLE IF EXISTS public.cms_eligibility_id;

CREATE TABLE public.cms_eligibility_id
DISTKEY(id)
SORTKEY(id) AS (
  SELECT *
  ,ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY npi) AS id
  FROM public.cms_eligibility
);

--Create a table with fake charges per provider data
DROP TABLE IF EXISTS public.cms_charges_per_provider;

CREATE TABLE public.cms_charges_per_provider
DISTKEY (id)
SORTKEY (id) AS (
  SELECT
    id
    ,CASE WHEN (individual_low_vol_stus_rsn_cd='BOTH' OR individual_low_vol_stus_rsn_cd='CHRG')
      THEN CAST(RANDOM() * 25000 + 4999 AS INT)
      ELSE CAST(RANDOM() * 50000 + 30000 AS INT)
      END AS total_charges
  FROM public.cms_eligibility_id
);

--Create a table with fake beneficiaries per provider data
DROP TABLE IF EXISTS public.cms_beneficiaries_per_provider;

CREATE TABLE public.cms_beneficiaries_per_provider
DISTKEY (id)
SORTKEY (id) AS (
  SELECT
    id
    ,CASE WHEN (individual_low_vol_stus_rsn_cd='BOTH' OR individual_low_vol_stus_rsn_cd='BENE')
      THEN CAST(RANDOM() * 95 + 4 AS INT)
      ELSE CAST(RANDOM() * 400 + 100 AS INT)
      END AS total_beneficiaries
  FROM public.cms_eligibility_id
);

--Join fake data back to provider eligibility table
DROP TABLE IF EXISTS public.cms_eligibility_appended;

CREATE TABLE public.cms_eligibility_appended
DISTKEY(npi)
SORTKEY(npi) AS (
  SELECT *
  FROM public.cms_eligibility_id
  LEFT JOIN public.cms_charges_per_provider
    USING (id)
  LEFT JOIN public.cms_beneficiaries_per_provider
    USING (id)
  );

--Grant access to users
GRANT ALL ON public.cms_eligibility_id TO pcooman, adeora, cson, mpowell;
GRANT ALL ON public.cms_charges_per_provider TO pcooman, adeora, cson, mpowell;
GRANT ALL ON public.cms_beneficiaries_per_provider TO pcooman, adeora, cson, mpowell;
GRANT ALL ON public.cms_eligibility_appended TO pcooman, adeora, cson, mpowell;
