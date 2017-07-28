-- Get the top 10 specialties in terms of total provider counts
-- and calculate the number of eligible providers for each of these specialties
drop table if exists public.eligibility_by_specialty;
create table public.eligibility_by_specialty as
(
select specialty_description, 
count(*), 
sum(case when individual_low_vol_stus_rsn_cd is null then 1 else 0 end) as eligible from public.cms_eligibility_appended
group by 1
order by 2 desc
limit 10
);

grant all on public.eligibility_by_specialty to adeora, cson, achen, mpowell;
