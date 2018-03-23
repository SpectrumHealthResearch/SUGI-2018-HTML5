filename filedir "c:\Users\&sysuserid\Desktop";

/******************************************************************

THIS SHOWS HOW TO CREATE A <STYLE> TAG IN YOUR DOCUMENT HEADER

THE CSS WITHIN THE STYLE TAG WILL MAKE THE TEXT OF TABLE DATA RED

*******************************************************************/
ods html5 
  path=filedir 
  file="example_embedded_css.html"
  style=styles.minimal
  headtext='<style>td {color: red;}</style>'; /* <-- Embedded CSS */

proc print data=sashelp.fish
  style(table)={prehtml="<p style='text-align: center;'>Fish</p>"} /* <-- Inline CSS */
  style(data)={htmlstyle="font-weight: bold;"};
run;

ods html5 close;
