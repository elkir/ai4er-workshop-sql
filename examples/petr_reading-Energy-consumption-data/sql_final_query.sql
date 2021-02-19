-- Display building details
select
  *
from
  (
    select
      Contacts_Id,
      Code,
      Name,
      count(Points_Id) Meters,
      sum(Days) Data_Days,
      max(case when Type = 'Electricity' then 1 else 0 end) E,
      max(case when Type = 'Gas' then 1 else 0 end) G,
      max(case when Type = 'Water' then 1 else 0 end) W,
      max(case when Type not in ('Electricity','Gas','Water') then 1 else 0 end) O,
      cast(min(Oldest) as date) Oldest,
      cast(max(Newest) as date) Newest
    from
      (
        SELECT
          COUNT(d.Date) Days,
          MAX(d.Date) Newest,
          MIN(d.Date) Oldest,
          c.Id Contacts_Id,
          p.Id Points_Id,
          c.Code,
          c.Name,
          c.PostCode,
          c.Last_Update,
          p.Type,
          p.Units,
          p.Location,
          p.Code2,
          p.Closed_Date
        FROM
          dbo.Points p
          RIGHT JOIN (
            select
              *
            from
              dbo.Contacts c
          ) c on c.Id = p.Contacts_Id
          LEFT JOIN dbo.DataProfile d on p.Id = d.Point_Id
        GROUP BY
          c.Code,
          c.Name,
          c.PostCode,
          c.Last_Update,
          p.Type,
          p.Units,
          p.Location,
          p.Code2,
          p.Closed_Date,
          c.Id,
          p.Id
      ) q2
    group by
      Contacts_Id,
      Code,
      Name
  ) q1
-- where No_DayDataPoints > 0
order by
  No_Meters desc,
  No_DayDataPoints desc,
  Oldest desc
