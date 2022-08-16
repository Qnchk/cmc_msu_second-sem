{Погосян Арсен 109 группа}
program base(input,output,f1);
const str_length=10;
      item_count=20;
type str=array[1..str_length] of char;
variants='a'..'e';
item =
   record
      name: str;
      stickers: array[1..10] of str;
      stattrack:boolean;
      quality: set of variants;
      zip:longint;
   end;
ff=file of item;
dd=array[1..item_count] of item;

var data:dd;
   f1:ff;
   current_count:integer;

{======================================================================}
{**********************Работа со строками******************************}
{======================================================================}

   {Проверка на равенство строк}
   function str_compare(s1:str;s2:str):boolean;
   var index:integer;
   begin
   str_compare:=true;
   for index:=1 to str_length do
      if s1[index]<>s2[index] then
         str_compare:=false;
   end;


   {отчистка строки}
   procedure s_clear(var s:str);
   var k:integer;
   begin
      for k:=1 to str_length do
         begin
            s[k]:=chr(0);
         end;
   end;

   {считывание строки}
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

   {вывод строки}
   procedure str_write(var s:str);
   var index:integer;
   begin
   for index:=1 to str_length do
      if ord(s[index])<>0 then
         write(s[index]);
   end;

{======================================================================}
{*********************Чтение входного файла****************************}
{======================================================================}
   procedure file_read(var f:ff; var data:dd; var current_count:integer);
   var bufer:item;
       index:integer;
   begin
      current_count:=0;
      index:=0;
      reset(f);
      while not(eof(f)) do
         begin
            read(f,bufer);
            index:=index+1;
            current_count:=current_count+1;
            data[index]:=bufer;
         end;
   end;


procedure unpack(zip: longint; var stickers_count,quality_count,price:longint);
  stdcall;
  external name '_unpack@0';
  {$L oper.obj}

{======================================================================}
{*****************Вывод полного 1-го элемента из файла*****************}
{======================================================================}
   procedure item_write(data:item);
   var k:integer;
       m:char;
       stickers_count,quality_count,price:longint;
   begin
   unpack(data.zip,stickers_count,quality_count,price);
   write('====================');
   str_write(data.name);
   write('========================');
         writeln;
         write('Count of stickers: ',stickers_count);
         writeln;
         if stickers_count>0 then
            writeln('Sticker:');
         for k:=1 to stickers_count do
            begin
               write('   ');
               str_write(data.stickers[k]);
               writeln;
            end;
         writeln('Stattrack: ',data.stattrack);
         if quality_count>0 then
            writeln('Avaible quality:');
         for m:='a' to 'e' do
            if m in data.quality then
               case m of
                  'a': writeln('  Legendary');
                  'b': writeln('  Secret');
                  'c': writeln('  Super rare ');
                  'd': writeln('  rare');
                  'e': writeln('  common');
               end;
         writeln('item price:',price,'$');
         writeln('==============================================');
         writeln;

   end;

{======================================================================}
{***********************Вывод всех данных******************************}
{======================================================================}

   procedure data_write(var data:dd; current_count:integer);
   var index:integer;
   begin
   for index:=1 to current_count do
      item_write(data[index]);
   end;



{======================================================================}
{*************************Функционал меню******************************}
{======================================================================}

   {1-я операция из меню}
   function function_1(var data:dd;current_count:integer):integer;
   var index,count:integer;
       quality:char;
   begin

   count:=0;
   writeln('Write quality to find:');
   writeln('a-legendary,b-secret,c-super rare,d-rare,e-common');
   write('input: ');
   readln(quality);
   for index:=1 to current_count do
      if quality in data[index].quality then
         count:=count+1;
   function_1:=count;
   end;


   {2-я операция из меню}
   function function_2(var data:dd; current_count:integer):integer;
   var index,count,flag,local_price :integer;
       stickers_count,quality_count,price:longint;
   begin
   count:=0;
   writeln('select mode:');
   writeln('1)under value');
   writeln('2)upper value');
   write('input: ');
   readln(flag);
   write('write value: ');
   readln(local_price);
   for index:=1 to current_count do
      begin
         unpack(data[index].zip,stickers_count,quality_count,price);
         case flag of
         1: if price<=local_price then count:=count+1;
         2: if price>=local_price then count:=count+1;
         end;
      end;
   function_2:=count;
   end;

   {3-я операция из меню}
   procedure function_3(var data:dd; current_count:integer);
   var s:str;
       index1,index2,count:integer;
       stickers_count,quality_count,price:longint;
   begin
   count:=0;
   write('write sticker name with <.> on end: ');
   str_read(s);
   for index1:=1 to current_count do
      begin
         unpack(data[index1].zip,stickers_count,quality_count,price);
         for index2:=1 to stickers_count do
            if str_compare(s, data[index1].stickers[index2]) then
               begin
                  item_write(data[index1]);
                  count:=count+1;
               end;
      end;
   if count=0 then
      writeln('No items with this sticker!');
   end;

   {4-я операция из меню}
   procedure function_4(var data:dd; curent_count:integer);
   var flag,index,count:integer;
   begin
   count:=0;
   writeln('Select mode:');
   writeln('1)all items with stattrack');
   writeln('2)all items without stattreck');
   write('unput: ');
   readln(flag);
   for index:=1 to current_count do
      case flag of
         1: if data[index].stattrack then
               begin
                  item_write(data[index]);
                  count:=count+1;
               end;
         2: if not(data[index].stattrack) then
               begin
                  item_write(data[index]);
                  count:=count+1;
               end;
      end;
   if count = 0 then
      writeln('No items with selected params!');
   end;


   {Меню и обработка нужной игфы}
   procedure data_operate(var data:dd; current_count:integer);
   var flag:integer;
   begin
   repeat
      writeln('Select mode:');
      writeln('1)Search count of items with selected quality');
      writeln('2)Search count of items with price abow/below selected');
      writeln('3)Write all items with selected sticker');
      writeln('4)Write all items with/without stattrack');
      writeln('0)Exit');
      write('Input: ');
      readln(flag);
      case flag of
         1: writeln(function_1(data,current_count));
         2: writeln(function_2(data,current_count));
         3: function_3(data,current_count);
         4: function_4(data,current_count);
      end;
   until flag=0;
   end;

begin
assign(f1,'base_PA.txt');
file_read(f1, data,current_count);
Writeln('=====================================================');
writeln('====================all items=======================');
writeln('=====================================================');
data_write(data,current_count);
data_operate(data,current_count);

end.
