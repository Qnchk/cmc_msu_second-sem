{Pogosyan Arsen 109 2022}
program arsen;
Uses sysutils;
const n=3;
type input_data=text;
     output_data=text;
     integer_data=array[1..n] of longint;
     num_data=array[1..2] of string;


function add(num1_str,num2_str:string; var z_flag, s_flag,c_flag,o_flag:integer):string;
var i,buffer,over:integer;  
    result:string;
begin
result:='';
over:=0;
for i:=length(num1_str) downto 1 do
   begin
      buffer:=StrToInt(num1_str[i])+StrToInt(num2_str[i]);
      result:=IntToStr((buffer+over) mod 2) + result;
      over:= (over+buffer) div 2;   
   end;
c_flag:=over;
if StrToInt(result)=0 then
   z_flag:=1
else
   z_flag:=0;
s_flag:=StrToInt(result[1]);
if (num1_str[1]=num2_str[1]) and (num1_str[1]<>result[1]) then
   o_flag:=1
else
   o_flag:=0;
add:=result;
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
function sub(num1_str,num2_str:string; var z_flag, s_flag,c_flag, o_flag:integer):string;
var i,over:integer;
   result:string;
begin
result:='';
over:=0;
for i:=length(num1_str) downto 1 do
      if StrToInt(num1_str[i])-StrToInt(num2_str[i])-over>=0 then
         begin
            result:= IntToStr(StrToInt(num1_str[i])-StrToInt(num2_str[i])-over)+ result;
            over:=0
         end
      else
         begin
            result:=IntToStr(StrToInt(num1_str[i])-StrToInt(num2_str[i])-over+2)+ result;
            over:=1;
         end;
         
         
if StrToInt(result)=0 then 
   z_flag:=1
else
   z_flag:=0;
s_flag:=StrToInt(result[1]);
c_flag:=over;
if (num2_str[1]=result[1]) and (num1_str[1]<>num2_str[1]) then
   o_flag:=1
else
   o_flag:=0;
sub:=result;
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure znak_correct(var data:longint; max_value,min_value:longint);
begin
if data>-min_value-1 then
   while data>(min_value-1) do
      data:=data-max_value-1;
if data<min_value then
   while data<min_value do
      data:=data+max_value+1;
end;


procedure bezznak_correct(var data:longint; max_value:longint);
begin
if data>max_value then
   while data>max_value do
      data:=data-max_value-1;
if data<0 then
   while data<0 do
      data:=data+max_value+1;
 
end;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
function to_bin(bytes:integer;number:longint):string;
var result:string;
    i:integer;
begin
result:='';
while number>0 do
   begin
      result:= IntToStr(number mod 2) +result;
      number:=number div 2;
   end;
for i:=1 to bytes-length(result) do
   result:='0'+result;
to_bin:=result;

end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure read_one_line(var main_data:integer_data; line:string);
var buffer:string;
    index,i:integer;
begin
index:=0;
buffer:='';
for i:=1 to length(line) do
   begin
      if line[i]<>' ' then
         buffer:=buffer+line[i]
      else
         begin
            index:=index+1;
            main_data[index]:=StrToInt(buffer);
            buffer:='';
         end;
   end;
index:=index+1;
main_data[index]:=StrToInt(buffer);
end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
* num_str - bin string
* num[1] - signed
* num[2] - unsigned}
function data_operate(main_data:integer_data; var num1,num2:integer_data; var num1_str,num2_str:string; var max_value,min_value:longint):boolean;
begin
max_value:=round(exp(ln(2)*main_data[1])-1);
min_value:=-round(exp(ln(2)*(main_data[1]-1)));
if (main_data[2]>=min_value) and (main_data[2]<=max_value) and (main_data[3]>=min_value) and (main_data[3]<=max_value) and (main_data[1]>=2) and (main_data[1]<=16) then
   begin   
{======================================================================}
      if main_data[2]<0 then
         begin
            num1[2]:=main_data[2];
            num1[1]:=main_data[2]+max_value+1;
            num1_str:=to_bin(main_data[1],num1[1])
         end
      else
         begin
            if main_data[2]<=-(min_value+1) then
               num1[2]:=main_data[2]
            else
               num1[2]:=main_data[2]-max_value-1;
            num1[1]:=main_data[2];
            num1_str:=to_bin(main_data[1],num1[1]);
         end; 
{======================================================================}      
      if main_data[3]<0 then
         begin
            num2[2]:=main_data[3];
            num2[1]:=main_data[3]+max_value+1;
            num2_str:=to_bin(main_data[1],num2[1]);
         end
      else
         begin
            if main_data[3]<=-(min_value+1) then
               num2[2]:=main_data[3]
            else
               num2[2]:=main_data[3]-max_value-1;
            num2[1]:=main_data[3];
            num2_str:=to_bin(main_data[1],num2[1]);
         end;  
{======================================================================}  
      data_operate:=True 
   end
else
   data_operate:=false;

end;
{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


function beautiful_signed(num:longint):string;
begin
if num<0 then 
   beautiful_signed:=' -'+IntToStr(abs(num))
else
   beautiful_signed:='  '+IntToStr(num); 
end;



procedure one_iteration(main_data:integer_data;var result_data:output_data; line:string);
var num1,num2:integer_data;
    num1_str,num2_str,result1,result2:string;
    o_flag,s_flag,z_flag,c_flag:integer;
    max_value,min_value,buffer_znak_1,buffer_znak_2,buffer_bezznak_1,buffer_bezznak_2:longint;
    flag:boolean;
begin
flag:=data_operate(main_data,num1,num2,num1_str,num2_str,max_value,min_value);

if flag then
   begin
      buffer_bezznak_1:=num1[1]+num2[1];
      buffer_znak_1:=num1[2]+num2[2];
      buffer_bezznak_2:=num1[1]-num2[1];
      buffer_znak_2:=num1[2]-num2[2];
      
      
      {operate overflow  example: 256->1  or 128->-128}
      bezznak_correct(buffer_bezznak_1,max_value);
      znak_correct(buffer_znak_1,max_value,min_value);
      bezznak_correct(buffer_bezznak_2,max_value);
      znak_correct(buffer_znak_2,max_value,min_value);
      {=====================================}
      
      
      result1:='+ '+num1_str+'  '+num2_str+'  '+add(num1_str,num2_str,z_flag,s_flag,c_flag,o_flag)+'  '+IntToStr(buffer_bezznak_1)+beautiful_signed(buffer_znak_1)+'  '+IntToStr(z_flag)+IntToStr(s_flag)+IntToStr(c_flag)+IntToStr(o_flag);
      result2:='- '+num1_str+'  '+num2_str+'  '+sub(num1_str,num2_str,z_flag,s_flag,c_flag,o_flag)+'  '+IntToStr(buffer_bezznak_2)+beautiful_signed(buffer_znak_2)+'  '+IntToStr(z_flag)+IntToStr(s_flag)+IntToStr(c_flag)+IntToStr(o_flag);
      writeln(result_data,line);
      writeln(result_data,result1);
      writeln(result_data,result2);
      writeln(result_data,' ')
   end
else
   begin
      writeln('ERROR IN INPUT DATA!!!');
      writeln(line);
      writeln;
   end;
end;



procedure main;
var main_data:integer_data;
    data: input_data;
    result_data:output_data;
    line:string;
begin
assign(data, 'data.txt');
assign(result_data, 'result.txt');
reset(data);
rewrite(result_data);
while not(eof(data)) do
begin
   readln(data,line);
   read_one_line(main_data,line);
   one_iteration(main_data,result_data,line);
end;
close(data);
close(result_data);

end;


begin
main;
end.
