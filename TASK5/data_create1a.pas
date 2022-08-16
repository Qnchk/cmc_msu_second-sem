{Погосян Арсен}
program data_base(input, output, f1);
const str_length=10;
type str=array[1..str_length] of char;
variants='a'..'e';
item =
   record
      name: str;
      //stickers_count:integer;
      stikers: array[1..10] of str;
      stattrack:boolean;
      //quality_count:integer;
      quality: set of variants;
      //price:integer;
      zip: longint 
   end;
ff=file of item;

var f1:ff;



function pack(stickers_count,quality_count,price:longInt): integer;
  stdcall;
  external name '_pack@0';
  {$L oper.obj}

procedure s_clear(var s:str);
   var k:integer;
   begin
      for k:=1 to str_length do
         begin
            s[k]:=chr(0);
         end;

   end;


procedure str_read(var s:str);
   var k:integer;
       bufer:char;
   begin
      s_clear(s);
      k:=0;
      repeat
         k:=k+1;
         read(bufer);
         if not(bufer='.') then
            s[k]:=bufer;
      until (k=str_length) or (bufer='.');
   end;

procedure item_read(var f:ff);
var k,index,item_count:integer;
    stickers_count,quality_count,price:longInt;
    data:item;
    bufer:char;

begin
rewrite(f);
write('Write count of items :');
readln(item_count);
for index:=1 to item_count do
   begin
      data.quality:=[];
      write('write item name with <.> on end: ');
      str_read(data.name);
      write('write count of stickers(1-10): ');
      readln(stickers_count);
      for k:=1 to stickers_count do
         begin
            write('write sticker number  ',k,' with <.> on end: ');
            str_read(data.stikers[k]);
            readln;
         end;
      write('write 1 if stattrack and 0 otherwise: ');
      readln(k);
      data.stattrack:=k=1;
      write('write quality count(1-10): ');
      readln(quality_count);
      if quality_count>0 then
         writeln('a-legendary, b-secret, c-very rare, d-rare, e-common');
      for k:=1 to quality_count do
         begin
            write('Write quality number ',k,' :');
            readln(bufer);
            data.quality:=data.quality+[bufer];
         end;
      write('Enter the value of the item in dollars (0-100): ');
      readln(price);
      data.zip:=pack(stickers_count,quality_count,price);
      write(f,data);
   end;
close(f);
end;

   procedure str_write(s:str);
   var index:integer;
   begin
   for index:=1 to str_length do
      if ord(s[index])<>0 then
         write(s[index]);
   end;



begin
assign(f1,'base_PA.txt');
item_read(f1);
end.
