filename filedir "c:\Users\&sysuserid\Desktop";

/* FIRST WE SHOW HOW TO EMBED MULTIMEDIA USING ODS TEXT STATEMENT */
ods html5 
  path=filedir 
  file="example_multimedia_ODS_TEXT.html" 
  headtext="<style>.usertext {text-align: center;}</style>";

ods text="
<video width='854' height='480' controls>
  <source 
    src='https://upload.wikimedia.org/wikipedia/commons/transcoded/9/98/Waves_on_the_Thames.webm/Waves_on_the_Thames.webm.480p.webm' 
    type='video/webm'>
</video>";

ods html5 close;

/* NEXT WE SHOW HOW TO EMBED AUDIO AND VIDEO USING RWI */
ods html5 
  path=filedir 
  file="example_multimedia_RWI.html" 
  headtext="<style>.usertext {text-align: center;}</style>";

/* MACRO VARIABLES TO KEEP URLS A LITTLE MORE MANAGEABLE AND AGILE */
%let base_url = https://upload.wikimedia.org/wikipedia/commons/;
%let video_file_name = Waves_on_the_Thames.webm;
%let audio_file_name = 1-George_Frideric_Handel_-_Water_Music_Suite_in_F_major_%28Overture%29_HWV348.ogg;

/* THE REPORT WRITING INTERFACE LIVES INSIDE THE DATA STEP */
data _null_;
dcl odsout obj();

obj.format_text(data: "Waves on the Thames", style_elem: "SystemTitle");
obj.format_text(data: "Enjoy this water-themed video that shows off HTML5."); 
obj.video(
  file: "&base_url.transcoded/9/98/&video_file_name./&video_file_name..480p.webm",
  type: "webm",
  width: "854", 
  height: "480",
  preload: "auto",
  autoplay: "yes",
  poster: "&base_url.thumb/9/98/&video_file_name./800px--&video_file_name..jpg",
  loop: "on"
);


obj.format_text(data: "Handel's Water Music Suite in F major (Overture)", style_elem: "SystemTitle"); 
obj.format_text(data: "And here is some more water-themed media that shows off HTML5's features!");
obj.audio( 
  file: "&base_url.6/6e/&audio_file_name.",
  type: "ogg",        
  preload: "auto",
  autoplay: "off",
  loop: "no"
);
obj.delete();
run;

/* ATTRIBUTION */
ods text="<span id='attribution'>
  Video courtesy of 
  <a href='https://commons.wikimedia.org/wiki/User:Secretlondon'>
    secretlondon
  </a> 
  [<a href='https://creativecommons.org/licenses/by-sa/4.0/deed.en'>
    CC BY-SA 4.0
  </a>], 
  <a href='https://commons.wikimedia.org/wiki/File:&video_file_name.'>
    via Wikimedia Commons
  </a>
  <br>
  Music by George Frideric Handel 
  [<a href='https://creativecommons.org/licenses/by-sa/3.0'>
    CC BY-SA 3.0
  </a>], 
  <a href='https://commons.wikimedia.org/wiki/File%3A&audio_file_name.'>
    via Wikimedia Commons
  </a>
</span>";
ods html5 close;
