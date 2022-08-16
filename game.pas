program Arsen;
uses crt,sysutils;
const width=120;
      heigh=30;
      start_pos_x=60;{pos of player}
      flat=heigh-3;{ground pos y}
      time=50;
      enemies_count=4;
type coords=array[1..2] of integer;
     enemies_coords=array[1..enemies_count] of coords;
var pos_x,pos_y:integer;
    key:char;
procedure ground;
begin
  window(1,heigh-2,width,heigh);
  textbackground(Brown);
  clrscr;
  textcolor(black);
  writeln(' "space" - jump, "tab" - fast down, "esc" - back to menu')
end;

procedure player(pos_x,pos_y:integer);
begin
  window(pos_x-4,pos_y-4,pos_x-1,pos_y);
  textbackground(white);
  clrscr;
  window(pos_x-4,pos_y-5,pos_x-1,pos_y-5);
  textbackground(red);
  clrscr;
  window(pos_x,pos_y-1,pos_x,pos_y);
  clrscr;
  window(pos_x-5,pos_y-1,pos_x-5,pos_y);
  clrscr;
  window(pos_x-3,pos_y-3,pos_x-2,pos_y-3);
  clrscr;
  window(pos_x-3,pos_y-1,pos_x-2,pos_y-1);
  clrscr;
end;

procedure enemy(pos_x,pos_y:integer);
begin
  window(pos_x+1,pos_y-1,pos_x+5,pos_y-1);
  textbackground(green);
  clrscr;
  window(pos_x,pos_y-1,pos_x,pos_y-1);
  textbackground(blue);
  clrscr;
end;

{reading saved data from database file}
function max_score_read:integer;
var data:text;
    max_score:string;
begin
  assign(data,'max.txt');
  reset(data);
  if not(eof(data)) then
    begin
      readln(data, max_score);
      max_score_read:=StrToInt(max_score)
    end
  else
    max_score_read:=0;
  close(data);
end;

{writing new highscore to database file}
procedure max_score_save(max_score:integer);
var data:text;
begin
  assign(data,'max.txt');
  rewrite(data);
  writeln(data,max_score);
  close(data);
end;

{printing score and maxscore on screen}
procedure score_write(score:integer; var max_score:integer);
begin
  window(width-10,heigh-2,width,heigh-2);
  textbackground(brown);
  textcolor(black);
  clrscr;
  writeln('score: ',score);
  if max_score<score then
    begin
      max_score:=score;
      max_score_save(max_score);
    end;
  window(width-10,heigh-1,width,heigh-1);
  textbackground(brown);
  textcolor(black);
  writeln('max:',max_score);
end;



{generating all enemiea froom pool}
procedure output_enemies(var enemies:enemies_coords; var score:integer; pos_x,pos_y:integer;var death:boolean);
var i:integer;
begin
  for i:=1 to enemies_count do
    if enemies[i][1]<>0 then
      begin
        if (((enemies[i][1]>=pos_x-4) and (enemies[i][1]<=pos_x)) or ((enemies[i][1]+5>=pos_x-4) and (enemies[i][1]+5<=pos_x))) and (pos_y>=flat-1) then
          death:=true;
        enemy(enemies[i][1],enemies[i][2]);
        enemies[i][1]:=enemies[i][1]-1; 
      end
    else
      begin
        enemies[i][1]:=random(random(round(width/2)))+width;
        score:=score+1;
        enemy(enemies[i][1],enemies[i][2]);
      end;
end;

{updating frame and all objects on it}
procedure update_frame(pos_x,pos_y:integer;var score,max_score:integer;var enemies:enemies_coords;var death:boolean); 
begin
  window(1,1,width,heigh-3);
  textbackground(Black);
  clrscr;
  player(pos_x,pos_y);
  output_enemies(enemies,score,pos_x,pos_y,death);
  player(pos_x,pos_y);
  score_write(score,max_score);
  delay(time);
end;

{main hero jump}
procedure jump(var is_ground:boolean;pos_x,pos_y:integer; var score,max_score:integer; var enemies:enemies_coords; var death:boolean);
var force,i,key:integer;
begin
  force:=30;{jump force(max high of jump)}
  i:=0;
  while not(is_ground) and (i<force) do
    begin
      i:=i+1;
      if KeyPressed then
        if ord(readkey)=9 then
        begin
          pos_y:=flat-1;
          is_ground:=true;
        end; 
      if i<=force/2 then
        pos_y:=pos_y-i mod 2
      else
        pos_y:=pos_y+i mod 2; 
      update_frame(pos_x,pos_y,score,max_score,enemies,death);
    end;
  is_ground:=true;
end;


procedure game; 
var key,pos_x,pos_y,i,score,max_score:integer;
    enemies:enemies_coords;
    is_ground,death:boolean;
begin
  enemies[1][1]:=random(random(100))+width;
  enemies[1][2]:=heigh-3;
  for i:=2 to enemies_count do
     begin 
      enemies[i][1]:=enemies[i-1][1]+random(20)+10;
      enemies[i][2]:=heigh-3;
     end;
ground;
death:=false;
score:=0;
max_score:=max_score_read;
is_ground:=true;
pos_x:=start_pos_x;
pos_y:=flat;
update_frame(pos_x,pos_y,score,max_score,enemies,death);
  repeat
    if KeyPressed then
      begin
        key:=ord(readkey);
        if (key = 32) and is_ground then
          begin
            is_ground:=false;
            jump(is_ground,pos_x,pos_y,score,max_score,enemies,death);
          end
        else if key=27 then
          death:=true
        else 
          update_frame(pos_x,pos_y,score,max_score,enemies,death)
      end
    else
       update_frame(pos_x,pos_y,score,max_score,enemies,death);
  until death;
end;

{logo of usfo on main menu}
procedure picture(pos_x,pos_y:integer);
begin
window(1,1,width,heigh);
textbackground(blue);
clrscr;
textbackground(red);
window(pos_x+15,pos_y+9,pos_x+16,pos_y+9);
clrscr;
window(pos_x+17,pos_y+8,pos_x+18,pos_y+8);
clrscr;
window(pos_x+19,pos_y+7,pos_x+32,pos_y+7);
clrscr;
window(pos_x+33,pos_y+8,pos_x+34,pos_y+8);
clrscr;
window(pos_x+35,pos_y+9,pos_x+36,pos_y+9);
clrscr;
textbackground(LightGray);
window(pos_x+10,pos_y+10,pos_x+40,pos_y+11);
clrscr;
window(pos_x+15,pos_y+12,pos_x+35,pos_y+12);
clrscr;
window(pos_x+19,pos_y+13,pos_x+31,pos_y+13);
clrscr;
end;

{text SPACE on main menu}
procedure text(pos_x,pos_y:integer);
begin
textbackground(black);
{letter "S"}
window(pos_x+10,pos_y,pos_x+15,pos_y);
clrscr;
window(pos_x+10,pos_y,pos_x+10,pos_y+2);
clrscr;
window(pos_x+10,pos_y+2,pos_x+15,pos_y+2);
clrscr;
window(pos_x+15,pos_y+2,pos_x+15,pos_y+4);
clrscr;
window(pos_x+10,pos_y+4,pos_x+15,pos_y+4);
clrscr;
{letter "P"}
window(pos_x+17,pos_y,pos_x+17,pos_y+4);
clrscr;
window(pos_x+17,pos_y,pos_x+22,pos_y);
clrscr;
window(pos_x+17,pos_y+2,pos_x+22,pos_y+2);
clrscr;window(pos_x+22,pos_y,pos_x+22,pos_y+2);
clrscr;
{Letter "A"}
window(pos_x+24,pos_y,pos_x+24,pos_y+4);
clrscr;
window(pos_x+24,pos_y,pos_x+29,pos_y);
clrscr;
window(pos_x+29,pos_y,pos_x+29,pos_y+4);
clrscr;
window(pos_x+24,pos_y+2,pos_x+29,pos_y+2);
clrscr;
{letter "C"}
window(pos_x+31,pos_y,pos_x+31,pos_y+4);
clrscr;
window(pos_x+31,pos_y,pos_x+36,pos_y);
clrscr;
window(pos_x+31,pos_y+4,pos_x+36,pos_y+4);
clrscr;
{letter "A"}
window(pos_x+38,pos_y,pos_x+38,pos_y+4);
clrscr;
window(pos_x+38,pos_y,pos_x+43,pos_y);
clrscr;
window(pos_x+38,pos_y+2,pos_x+43,pos_y+2);
clrscr;
window(pos_x+38,pos_y+4,pos_x+43,pos_y+4);
clrscr;
end;

{main menu}
procedure menu;
var key:integer;
begin
picture(round(width/4),round(heigh/10));
text(round(width/4),round(2*heigh/3));
textcolor(white);
window(round(width/3),heigh-4,round(width/2+10),heigh-2);
clrscr;
writeln('press enter to play');
writeln('press esc to exit');
{my tag (created by Arsen Pogosan) }
window(width-30,heigh-1,width,heigh-1);
clrscr;
writeln('Created By Arsen Pogosyan');
key:=ord(readkey);
case key of
27: begin 
      window(round(width/3),heigh-4,round(width/2+10),heigh-2);
      clrscr;
      writeln('Thank you for game!');
    end;
13: game;
end;
if key<>27 then
  menu;
end;


begin 
  menu;
end.
