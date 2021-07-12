select
  sum(anzahlfall)
from
  kranke
where
  bundesland like 'Baden%';
  
  
select
  bundesland,
  sum(anzahltodesfall) as anzahltodesfall,
  sum(anzahlfall) as anzahlfall
from
  kranke
group by
  bundesland;
  
  
select
  bundesland,
  max(meldedatum) as Datum,
  sum(anzahlfall)/kreise.bevölkerung::decimal * 100000 as inzidenz
from
  kranke,
  kreise
where
  meldedatum >= (
    select
      max(meldedatum)
    from
      kranke
  ) - interval '5 days'
  and kreise.name = bundesland
group by
  bundesland,
  kreise.bevölkerung;

 

  
