filename filedir "c:\Users\&sysuserid\Desktop";

/* CREATE FORMATS AND DATA */
proc format;
value length_ranges
  low - 15 = '0-15'
  15 <- 30 = '16-30'
  30 <- 45 = '31-45'
  45 <- 60 = '46-60'
  60 <- high = '60+'
;
run;

data ranges;
input range $ @@;
cards;
0-15 16-30 31-45 46-60 60+
;
run;

proc sql;

create table fish_lengths as
  select
    a.species, a.range, coalesce(b.n_fish,0) as n_fish
  from (
  select
    species.species, ranges.range
    from (select distinct species from sashelp.fish) as species, ranges
  ) as a  
  left join (
    select 
      species, 
      put(length1, length_ranges.) as range, 
      count(*) as n_fish
    from sashelp.fish
    group by 1, calculated range
  ) as b
  on a.species = b.species and a.range = b.range
  order by 1,2
  ;

quit;

/* SET THE SIZE OF THE SVG GRAPH */
options svgheight='400px' svgwidth='600px';  

/* SET THE DEVICE= OPTION TO SVG */
goptions reset=all device=svg;

/* SET THE SYSTEM OPTIONS TO CONTROL THE SVG ANIMATION */
options printerpath=svg animate=start animduration=3 
  svgfadein=1 animloop=1 animoverlay nodate nonumber;

/* OPEN ODS HTML5 DESTINATION */
ods html5 
  path=filedir
  file="example_animated_plot.html"
  options(svg_mode="inline"); 

/* USE PROC GCHART TO CREATE THE FINAL ANIMATED GRAPH */
title "Finland's Lake Laengelmavesi Fish Catch Data by Species";
proc gchart data=fish_lengths;
  by Species;
  vbar range / sumvar=n_fish sum raxis=axis1 maxis=axis2 patternid=midpoint width=15;
  axis1 order=(0 to 40 by 5) label=('Frequency'); 
  axis2 label=('Length Range'); 
run; quit;
options animate=stop;
ods html5 close;
