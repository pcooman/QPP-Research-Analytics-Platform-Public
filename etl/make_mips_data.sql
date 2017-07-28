--Set seed for RANDOM()
SET SEED TO 0.25;

--Create raw scores for MIPS performance categories
DROP TABLE IF EXISTS public.cms_mips_scores;

CREATE TABLE public.cms_mips_scores
DISTKEY(id)
SORTKEY(id) AS (
  SELECT
    id
    ,CAST(RANDOM() * 30 + 60 AS INT) AS quality
    ,CAST(RANDOM() * 40 AS INT) AS cost
    ,CAST(RANDOM() * 40 AS INT) AS improvement_activities
    ,CAST(RANDOM() * 155 AS INT) AS advancing_care_info
  FROM public.cms_eligibility_id
  WHERE individual_low_vol_stus_rsn_cd IS NULL
  );

--Append MIPS scores back to provider eligibility data
DROP TABLE IF EXISTS public.cms_eligibility_mips;

CREATE TABLE public.cms_eligibility_mips
DISTKEY(npi)
SORTKEY(npi) AS (
  SELECT
  *
  FROM public.cms_eligibility_id
  LEFT JOIN public.cms_mips_scores
  USING (id)
  WHERE individual_low_vol_stus_rsn_cd IS NULL
);

--Grant access
GRANT ALL ON public.cms_mips_scores TO pcooman, adeora, cson, mpowell;
GRANT ALL ON public.cms_eligibility_mips TO pcooman, adeora, cson, mpowell;
