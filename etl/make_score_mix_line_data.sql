drop table if exists public.cms_eligibility_mips_by_year;
create table public.cms_eligibility_mips_by_year as
(
  select *,
  case when MIPS < 35 then '0-35'
       when MIPS between 35 and 70 then '35-70'
       when MIPS > 70 then '70+' end as MIPS_bucket
  from
  (
    (
      SELECT '2017' as year,
      0.6*quality + 0.25*advancing_care_info + 0.15*improvement_activities + 0*cost as MIPS FROM public.cms_eligibility_mips
    ) union all (
      SELECT '2018' as year,
      0.5*quality + 0.25*advancing_care_info + 0.15*improvement_activities + 0.1*cost as MIPS FROM public.cms_eligibility_mips
    )  union all (
      SELECT '2019' as year,
      0.3*quality + 0.25*advancing_care_info + 0.15*improvement_activities + 0.3*cost as MIPS FROM public.cms_eligibility_mips
    )
  )
);

grant all on table public.cms_eligibility_mips_by_year to adeora, cson, achen
