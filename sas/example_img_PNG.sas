filename filedir "c:\Users\&sysuserid\Desktop";

/* OPEN ODS HTML5 */
ods html5
  path=filedir
  file='example_img_PNG.html'
  options(bitmap_mode='img');

/* TURN ON ODS GFX, SET IMG FORMAT TO PNG, AND SPECIFY IMG NAME */
ods graphics on / imagefmt=png imagename='example_fish_plot';

/* PLOT USING STATISTICAL GRAPHICS PROCEDURE */
proc sgplot data=sashelp.fish;
scatter x=height y=weight / group=species;
run;

/* CLOSE ODS DESTINATION */
ods html5 close;
