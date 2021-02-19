-- Three tables:
-- c = Contacts = Cambridge buildings
-- p = Points = Consumption meters
-- d = DataProfile = Individual values from the meter (e.g. each 30min)


-- Display building details

select -- 4) final wrapper query to use for ordering stuff, quick filters etc.
  *
from
  (
    select -- 3) the values from p have also been reduced to statistics, only Buildings remain as rows
      Contacts_Id,
      Code,
      Name,
      count(Points_Id) Meters, -- how many meters does the building have
      sum(Days) Data_Days,
      max(case when Type = 'Electricity' then 1 else 0 end) E, -- is there an electricity meter
      max(case when Type = 'Gas' then 1 else 0 end) G,
      max(case when Type = 'Water' then 1 else 0 end) W,
      max(case when Type not in ('Electricity','Gas','Water') then 1 else 0 end) O,
      cast(min(Oldest) as date) Oldest,
      cast(max(Newest) as date) Newest
    from
      (
        SELECT -- 2) Choose only the columns I want - only columns in GROUP BY and aggregating functions permitted
          COUNT(d.Date) Days,
          MAX(d.Date) Newest,
          MIN(d.Date) Oldest, -- The values from d have all been reduced to a few statistics
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
        FROM -- 1) Join the three tables together on the id numbers
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
