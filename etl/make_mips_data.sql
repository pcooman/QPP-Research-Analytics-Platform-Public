SET SEED TO 0.25;

CREATE TABLE public.cms_mips_scores
DISTKEY(npi)
SORTKEY(npi) AS (
  SELECT
    npi
    ,prvdr_org_name
    ,CAST(RANDOM() * 70 AS INT) AS quality
    ,CAST(RANDOM() * 100 AS INT) AS cost
    ,CAST(RANDOM() * 40 AS INT) AS improvement_activities
    ,CAST(RANDOM() * 155 AS INT) AS advancing_care_info
  FROM public.cms_eligibility
  WHERE individual_low_vol_stus_rsn_cd IS NULL
  );

GRANT ALL ON public.cms_mips_scores TO pcooman, adeora, cson, mpowell;
