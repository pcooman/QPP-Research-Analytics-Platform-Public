--Set seed for RANDOM()
SET SEED TO 0.25;

--Create a table with fake charges per provider data
CREATE TABLE public.cms_charges_per_provider
DISTKEY (npi)
SORTKEY (npi) AS (
  SELECT
    npi
    ,prvdr_org_name
    ,CASE WHEN (individual_low_vol_stus_rsn_cd='BOTH' OR individual_low_vol_stus_rsn_cd='CHRG')
      THEN CAST(RANDOM() * 25000 + 4999 AS INT)
      ELSE CAST(RANDOM() * 50000 + 30000 AS INT)
      END AS total_charges
  FROM public.cms_eligibility);

--Create a table with fake beneficiaries per provider data
CREATE TABLE public.cms_beneficiaries_per_provider
DISTKEY (npi)
SORTKEY (npi) AS (
  SELECT
    npi
    ,prvdr_org_name
    ,CASE WHEN (individual_low_vol_stus_rsn_cd='BOTH' OR individual_low_vol_stus_rsn_cd='BENE')
      THEN CAST(RANDOM() * 95 + 4 AS INT)
      ELSE CAST(RANDOM() * 400 + 100 AS INT)
      END AS total_beneficiaries
  FROM public.cms_eligibility);

--Join fake data back to provider eligibility table
CREATE TABLE public.cms_eligibility_appended
DISTKEY(npi)
SORTKEY(npi) AS (
  SELECT *
  FROM public.cms_eligibility as a
  LEFT JOIN public.cms_charges_per_provider as b
  ON a.npi = b.npi and
  a.prvdr_org_name = b.prvdr_org_name 
  LEFT JOIN public.cms_beneficiaries_per_provider as c
  ON a.npi = c.npi and 
  a.prvdr_org_name = c.prvdr_org_name
  WHERE b.npi is not null and
  b.prvdr_org_name is not null and
  c.npi is not null and
  c.prvdr_org_name is not null
);

--Grant access to users
GRANT ALL ON public.cms_eligibility_appended TO pcooman, adeora, cson, mpowell;
GRANT ALL ON public.cms_charges_per_provider TO pcooman, adeora, cson, mpowell;
GRANT ALL ON public.cms_beneficiaries_per_provider TO pcooman, adeora, cson, mpowell;
