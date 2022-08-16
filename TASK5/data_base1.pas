{Погосян Арсен}
program data_base(input, output, f1);
const str_length=10;
type str=array[1..str_length] of char;
variants='a'..'e';
item =
   record
      name: str;
      stickers_count:integer;
      stikers: array[1..10] of str;
      stattrack:boolean;
      quality_count:integer;
      quality: set of variants;
      price:integer;
   end;
ff=file of item;

var f1:ff;

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
    data:item;
    bufer:char;

begin
rewrite(f);
write('Введите к оличество предметов в инвентаре :');
readln(item_count);
for index:=1 to item_count do
   begin
      data.quality:=[];
      write('Введите название предмета, окончив строку точкой: ');
      str_read(data.name);
      write('Введите количество наклеек на предмете: ');
      readln(data.stickers_count);
      for k:=1 to data.stickers_count do
         begin
            write('Введите наклейку номер ',k,' окончив строку точкой: ');
            str_read(data.stikers[k]);
            readln;
         end;
      write('Введите 1 если stattrack и 0 если нет: ');
      readln(k);
      data.stattrack:=k=1;
      write('Введите количество качеств которые хотите ввести: ');
      readln(data.quality_count);
      if data.quality_count>0 then
         writeln('a-легендарное, b-запрещенное, c-засекреченное, d-редкое, e-ширпотреб');
      for k:=1 to data.quality_count do
         begin
            write('Введите качество номер ',k,' :');
            readln(bufer);
            data.quality:=data.quality+[bufer];
         end;
      write('Введите стоимость предмета в долларах: ');
      readln(data.price);
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

procedure file_write(var f:ff);
var data:item;
    k:integer;
    m:char;
begin
reset(f);
while not(eof(f)) do
   begin
      read(f,data);
      write('====================');
      str_write(data.name);
      writeln('====================');
      write('Количество наклеек на предмете: ',data.stickers_count);
      writeln;
      if data.stickers_count>0 then
         writeln('Наклейки:');
      for k:=1 to data.stickers_count do
         begin
            write('   ');
            str_write(data.stikers[k]);
            writeln;
         end;
      writeln('Stattrack: ',data.stattrack);
      if data.quality_count>0 then
         writeln('Доступные качества :')
      else
         writeln('Качеств нет');
      for m:='a' to 'e' do
         if m in data.quality then
            case m of
               'a': writeln('   Легендарное');
               'b': writeln('   Запрещенное ');
               'c': writeln('   Засекреченное');
               'd': writeln('   Редкое');
               'e': writeln('   Ширпотреб');
            end;
      writeln('Стоимость: ',data.price,'$');
         end;
end;

begin
assign(f1,'base_P.txt');
item_read(f1);
file_write(f1);


end.
