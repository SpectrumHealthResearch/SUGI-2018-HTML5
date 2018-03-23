filename filedir "c:\Users\&sysuserid\Desktop";

/* BEGIN WITH ODS HTML5 STATMENT */
ods html5 
  /* SPECIFY FILE PATH AND FILE NAME */
  path=filedir
  file="example_toc.html"

  /* SPECIFY DOCUMENT TITLE (IN HEADER) */
  (title="Fish Catch Data by Species")

  /* NO MACHINE-GENERATED TOC */
  options(outline="no")

  /* SPECIFY STYLING FOR TABLE OF CONTENTS */
  headtext="
    <style>
    #toc ul {
      width: 200px; 
      margin: auto;
      border: 1px solid #c1c1c1; 
      padding: 15px 0px 5px 30px;
    }
    </style>";

/* DOCUMENT HEADING */
ods text="<h1>Finland's Lake Laengelmavesi Fish Catch Data By Species</h1>";

/* GET ALL DISTINCT SPECIES AND PUT THEM IN A MACRO VARIABLE */
proc sql noprint;
  select distinct species 
  into :species_list separated by " "
  from sashelp.fish
  order by 1;
quit;

/* DEFINE A MACRO TO POPULATE TABLE OF CONTENTS WITH SPECIES IN DATASET */
%macro create_toc_list(species_list);
  %do i=1 %to %sysfunc(countw(&species_list.));
    item "<a href='#Species&i'>%scan(&species_list.,&i.)</a>";
  %end;
%mend create_toc_list;

/* CREATE A UNIQUE ID FOR THE TABLE OF CONTENTS */
ods anchor="toc";

/* USE ODSTEXT PROCEDURE TO MAKE TABLE OF CONTENTS */
proc odstext;
  p "Table of Contents" / 
  /* DEMONSTRATING INLINE STYLING */
    style={
      htmlstyle="
        text-align: center; 
        font-weight: bold; 
        font-size: 1.2em; 
        color: #112277;
    "};
  list; %create_toc_list(&species_list.);
run;

/* GIVE EACH BY-SECTION IN PRINT PROCEDURE A UNIQUE ID TO LINK TO */
ods anchor="Species1";

/* SORT DATA AND PRINT RESULT */
proc sort data=sashelp.fish out=fish;
  by species;
run;

proc print 
  data=fish 
  label
  style(table)={posthtml="<a href='#toc'>Back to Table of Contents</a>"};
  by species;
run;

/* CLOSE ODS HTML5 DESTINATION */
ods html5 close;
