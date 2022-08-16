{Погосян Арсен 109 группа}
program base(input,output,f1);
const str_length=10;
      item_count=20;
type str=array[1..str_length] of char;
variants='a'..'e';
item =
   record
      name: str;
      stickers_count:integer;
      stickers: array[1..10] of str;
      stattrack:boolean;
      quality_count:integer;
      quality: set of variants;
      price:integer;
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






{======================================================================}
{*****************Вывод полного 1-го элемента из файла*****************}
{======================================================================}
   procedure item_write(data:item);
   var k:integer;
       m:char;
   begin
   write('====================');
   str_write(data.name);
   write('========================');
         writeln;
         write('количество наклеек на предмете: ',data.stickers_count);
         writeln;
         if data.stickers_count>0 then
            writeln('Наклейки:');
         for k:=1 to data.stickers_count do
            begin
               write('   ');
               str_write(data.stickers[k]);
               writeln;
            end;
         writeln('Stattrack: ',data.stattrack);
         if data.quality_count>0 then
            writeln('Доступные качества:');
         for m:='a' to 'e' do
            if m in data.quality then
               case m of
                  'a': writeln('  Легендарное');
                  'b': writeln('  Засекреченное');
                  'c': writeln('  Запрещенное ');
                  'd': writeln('  Редкое');
                  'e': writeln('  Ширпотреб');
               end;
         writeln('Стоимость предмета:',data.price,'$');

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
   writeln('Введите качество, котрое необходимо найти:');
   writeln('a-легендарное,b-засекреченное,c-запрещенное,d-редкое,e-ширпотреб');
   write('Ввод: ');
   readln(quality);
   for index:=1 to current_count do
      if quality in data[index].quality then
         count:=count+1;
   function_1:=count;
   end;


   {2-я операция из меню}
   function function_2(var data:dd; current_count:integer):integer;
   var index,count,flag,price :integer;
   begin
   count:=0;
   writeln('Выберите режим:');
   writeln('1)Ниже указанной цены');
   writeln('2)Выше указанной цены');
   write('Ввод: ');
   readln(flag);
   write('Введите необходимую цену: ');
   readln(price);
   for index:=1 to current_count do
      case flag of
      1: if data[index].price<=price then count:=count+1;
      2: if data[index].price>=price then count:=count+1;
      end;
   function_2:=count;
   end;

   {3-я операция из меню}
   procedure function_3(var data:dd; current_count:integer);
   var s:str;
       index1,index2,count:integer;
   begin
   count:=0;
   write('Введите название нужной наклейки, окончив ввод точкой: ');
   str_read(s);
   for index1:=1 to current_count do
      for index2:=1 to data[index1].stickers_count do
         if str_compare(s, data[index1].stickers[index2]) then
            begin
               item_write(data[index1]);
               count:=count+1;
            end;
   if count=0 then
      writeln('Предметов с заданной наклейкой не найдено!');
   end;

   {4-я операция из меню}
   procedure function_4(var data:dd; curent_count:integer);
   var flag,index,count:integer;
   begin
   count:=0;
   writeln('Выберите режим работы:');
   writeln('1)Вывести все предметы со stattrack');
   writeln('2)Вывести все предметы без stattreck');
   write('Ввод: ');
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
      writeln('Предметов с заданными параметрами не найдено!');
   end;


   {Меню и обработка нужной игфы}
   procedure data_operate(var data:dd; current_count:integer);
   var flag:integer;
   begin
   repeat
      writeln('Выберите режим работы:');
      writeln('1)Поиск количества пердметов с заданным качеством');
      writeln('2)Поиск количества предметов с ценой вышше/ниже указанной');
      writeln('3)Вывод всех предметов с заданной наклейкой');
      writeln('4)Вывод всех предметов с/без stattrack');
      writeln('0)Выход из программы');
      write('Ввод: ');
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
assign(f1,'base_P.txt');
file_read(f1, data,current_count);
Writeln('=====================================================');
writeln('====================Все данные=======================');
writeln('=====================================================');
data_write(data,current_count);
data_operate(data,current_count);

end.
