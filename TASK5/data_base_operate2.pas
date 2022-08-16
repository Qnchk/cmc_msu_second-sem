{������ ��ᥭ 109 ��㯯�}
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
{**********************����� � ��ப���******************************}
{======================================================================}

   {�஢�ઠ �� ࠢ���⢮ ��ப}
   function str_compare(s1:str;s2:str):boolean;
   var index:integer;
   begin
   str_compare:=true;
   for index:=1 to str_length do
      if s1[index]<>s2[index] then
         str_compare:=false;
   end;


   {����⪠ ��ப�}
   procedure s_clear(var s:str);
   var k:integer;
   begin
      for k:=1 to str_length do
         begin
            s[k]:=chr(0);
         end;
   end;

   {���뢠��� ��ப�}
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

   {�뢮� ��ப�}
   procedure str_write(var s:str);
   var index:integer;
   begin
   for index:=1 to str_length do
      if ord(s[index])<>0 then
         write(s[index]);
   end;

{======================================================================}
{*********************�⥭�� �室���� 䠩��****************************}
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
{*****************�뢮� ������� 1-�� ����� �� 䠩��*****************}
{======================================================================}
   procedure item_write(data:item);
   var k:integer;
       m:char;
   begin
   write('====================');
   str_write(data.name);
   write('========================');
         writeln;
         write('������⢮ ������� �� �।���: ',data.stickers_count);
         writeln;
         if data.stickers_count>0 then
            writeln('��������:');
         for k:=1 to data.stickers_count do
            begin
               write('   ');
               str_write(data.stickers[k]);
               writeln;
            end;
         writeln('Stattrack: ',data.stattrack);
         if data.quality_count>0 then
            writeln('����㯭� ����⢠:');
         for m:='a' to 'e' do
            if m in data.quality then
               case m of
                  'a': writeln('  �������୮�');
                  'b': writeln('  ��ᥪ�祭���');
                  'c': writeln('  ����饭��� ');
                  'd': writeln('  ������');
                  'e': writeln('  ��௮�ॡ');
               end;
         writeln('�⮨����� �।���:',data.price,'$');

   end;

{======================================================================}
{***********************�뢮� ��� ������******************************}
{======================================================================}

   procedure data_write(var data:dd; current_count:integer);
   var index:integer;
   begin
   for index:=1 to current_count do
      item_write(data[index]);
   end;



{======================================================================}
{*************************�㭪樮��� ����******************************}
{======================================================================}

   {1-� ������ �� ����}
   function function_1(var data:dd;current_count:integer):integer;
   var index,count:integer;
       quality:char;
   begin
   count:=0;
   writeln('������ ����⢮, ���஥ ����室��� ����:');
   writeln('a-�������୮�,b-��ᥪ�祭���,c-����饭���,d-।���,e-�௮�ॡ');
   write('����: ');
   readln(quality);
   for index:=1 to current_count do
      if quality in data[index].quality then
         count:=count+1;
   function_1:=count;
   end;


   {2-� ������ �� ����}
   function function_2(var data:dd; current_count:integer):integer;
   var index,count,flag,price :integer;
   begin
   count:=0;
   writeln('�롥�� ०��:');
   writeln('1)���� 㪠������ 業�');
   writeln('2)��� 㪠������ 業�');
   write('����: ');
   readln(flag);
   write('������ ����室���� 業�: ');
   readln(price);
   for index:=1 to current_count do
      case flag of
      1: if data[index].price<=price then count:=count+1;
      2: if data[index].price>=price then count:=count+1;
      end;
   function_2:=count;
   end;

   {3-� ������ �� ����}
   procedure function_3(var data:dd; current_count:integer);
   var s:str;
       index1,index2,count:integer;
   begin
   count:=0;
   write('������ �������� �㦭�� ��������, ����稢 ���� �窮�: ');
   str_read(s);
   for index1:=1 to current_count do
      for index2:=1 to data[index1].stickers_count do
         if str_compare(s, data[index1].stickers[index2]) then
            begin
               item_write(data[index1]);
               count:=count+1;
            end;
   if count=0 then
      writeln('�।��⮢ � �������� ��������� �� �������!');
   end;

   {4-� ������ �� ����}
   procedure function_4(var data:dd; curent_count:integer);
   var flag,index,count:integer;
   begin
   count:=0;
   writeln('�롥�� ०�� ࠡ���:');
   writeln('1)�뢥�� �� �।���� � stattrack');
   writeln('2)�뢥�� �� �।���� ��� stattreck');
   write('����: ');
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
      writeln('�।��⮢ � ������묨 ��ࠬ��ࠬ� �� �������!');
   end;


   {���� � ��ࠡ�⪠ �㦭�� ����}
   procedure data_operate(var data:dd; current_count:integer);
   var flag:integer;
   begin
   repeat
      writeln('�롥�� ०�� ࠡ���:');
      writeln('1)���� ������⢠ ��ब�⮢ � ������� ����⢮�');
      writeln('2)���� ������⢠ �।��⮢ � 業�� ����/���� 㪠������');
      writeln('3)�뢮� ��� �।��⮢ � �������� ���������');
      writeln('4)�뢮� ��� �।��⮢ �/��� stattrack');
      writeln('0)��室 �� �ணࠬ��');
      write('����: ');
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
writeln('====================�� �����=======================');
writeln('=====================================================');
data_write(data,current_count);
data_operate(data,current_count);

end.
