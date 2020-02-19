unit Unit1;

//���������� ��� ��������� � ������������ ������

interface

//������������ ������
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, StrUtils;

//���������� ��������
Const
  n=4;
  alf=['q','Q','w','W','e','E','S','r','R','t','T','y','Y','U','I','O','P','A','u','D','F','G','H','J','K','L','Z','X','C','V','B','N','M','i','o','p','a','s','d','f','g','h','j','k','l','l','z','x','c','v','b','n','m'];
  alf2=['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�'];
  max=['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�'];
  min=['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�','�'];

  //n-����� ����� � �������� � �������
  //alf- ����� ����������� ��������
  //alf2- ����� �������� ��������
  //max- ������� ����� �������� ��������
  //min- ��������� ����� �������� ��������

//���������� �����
type
  Matrix= array[1..n,1..n] of String;    //������� 4�4

  TEncrypter = class(TForm)
    HelpText2: TLabel;
    TypeOfEncr: TComboBox;
    TextOfKey: TLabel;
    KeyOfEncr: TEdit;
    DoThis: TButton;
    CloseBtn: TButton;
    Decrypt: TButton;
    Errorlb: TLabel;
    ErrorText: TMemo;
    ChipherTextlb: TLabel;
    UseTextFromFile: TCheckBox;
    ResultText: TMemo;
    PlainTextForEncr: TMemo;
    Plaintext: TLabel;
    procedure DoThisClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TypeOfEncrChange(Sender: TObject);
    procedure EncrOrDecrKeyPress(Sender: TObject; var Key: Char);
    procedure TypeOfEncrKeyPress(Sender: TObject; var Key: Char);
    procedure EncrOrDecrChange(Sender: TObject);
    procedure DecryptClick(Sender: TObject);
    procedure UseTextFromFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Procedure FirstLook();
  Procedure ColEncr2(const key: String);


//���������� ����������
var
  Encrypter: TEncrypter;
  mask: Matrix =(('x','o','o','o'),('o','o','o','x'),('o','o','x','o'),('o','x','o','o'));

  //mask- ��������������� �������, ������������ ��� ����������(�������������) ������ ������� ���������������� �������

implementation

{$R *.dfm}

//��������� ���������� ��� �������� �� �����
Procedure FirstLook();
begin
  Encrypter.TypeOfEncr.ItemIndex:=-1;
  Encrypter.KeyOfEncr.Text:='';
  Encrypter.keyOfEncr.Enabled:=False;
  Encrypter.DoThis.Enabled:=false;
  Encrypter.Decrypt.Enabled:=false;
end;

//��������� �������� ������� �� 90 �������� ������
procedure Povorot(var mass1:Matrix);
var
  mass2: Matrix;
  i,j:Integer;

  //mass2- ��������������� �������
  //i,j- �������� �����

begin
  mass2 := mass1;
  for i := 1 to n do
  begin
    for j := 1 to n do
    begin
      mass1[j, n - i + 1] := mass2[i, j];
    end;
  end;
end;

//��������� ��� ���������� � ������������ ������ ���������� �������
Procedure ColEncr3(const key: String);
var
  matr: array[1..500,1..500] of String;      //������� ��� ����������(�������������) ������
  i,j,x,col,row:integer;                     //�������� �����
  File1,File2:Text;                          //��������� �����
  k: real;                                   //���������� ��� ����������� ����� ����� �������
  min:integer;                               //��������� ��� �������������� �������
  lengthstr, sizet: integer;                 //������ ������
  str: string;                               //���������� ��� ���������� �������� ������
  tmpn1,tmpn2:Integer;                       //���������� ��� ���������� �������� ��������� ��������
  tmp1,tmp2: char;                           //���������� ��� ����������� ������� ���� �������� �����
  mass: array[1..500] of integer;            //������, ������������ ������� ���� �������� �����
  mass2: array[1..500] of integer;           //������, ������������ ������� ������ �������� � ��������� ����
  tmp: char;                                 //��������� ����������
  lengthkey: integer;
  mass3: array[1..500] of Char;                               //���������� ��� ����������� ������� �������� ������� ����� � �����
  mass4: array[1..500] of Char;
  Textstr: String;
  mass5: array[1..500] of String;

begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf then
    begin
      lengthkey:=lengthkey+1;
      mass3[j]:=key[i];
      inc(j);
    end;
  end;

  //���� ���� �������� ������ ������� �����, �� ����� ��������� �� ����, ����� ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ���������� ����!');

    assignFile(File2,'Encr-Decr.txt');
    Textstr:='';
    lengthstr:=0;
    for i:=0 to encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j:=1 to length(Str) do
      begin
        if (str[j] in alf) then
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
      Textstr:=Textstr+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr)>=lengthstr do
      begin
        if Textstr[lengthstr] in alf then
        begin
          write(file2,UpCase(Textstr[lengthstr]));
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
  end
  else
  begin
                  //�������������
    assignFile(File2,'Encr-Decr.txt');

    Textstr:='';
    lengthstr:=0;
    for i:=0 to encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j:=1 to length(Str) do
      begin
        if (str[j] in alf) or (str[j]=' ') then
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
      Textstr:=Textstr+str;
    end;


    //���� ��� �������� ������� ����� � �����, �� ����� ��������� �� ����, ����� - ��������� ���������� ���������
    If lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('��������� ���� ����� ��� �������� ������ ������� �� ����������� �����');
      Rewrite(File2);
      CloseFile(File2);
    end
    else
    begin

      sizet:=lengthstr;
      //����������� ������� ���������� �������� � �����
      tmp1:='A';
      tmp2:='a';
      x:=1;
      for i := 1 to 26 do
      begin
        for j := 1 to lengthkey do
        begin
          if (mass3[j]=tmp1) or (mass3[j]=tmp2) then
          begin
            mass2[j]:=x;
            inc(x);
          end;
        end;
        tmp1:=succ(tmp1);
        tmp2:=succ(tmp2);
      end;

      for i := 1 to lengthkey do
      begin
        mass[i]:=i;
      end;

      // ���������� �������� ��� ����������� ������������������ ���������� ������� ��� �����������
      for i := 1 to lengthkey-1 do
      begin
        min:=i;
        for j := i+1 to lengthkey do
        begin
          if mass2[min]>mass2[j] then
          begin
            min:=j;
          end;
        end;
        tmpn1:=mass2[i];
        mass2[i]:=mass2[min];
        mass2[min]:=tmpn1;
        tmpn2:=mass[min];
        mass[min]:=mass[i];
        mass[i]:=tmpn2;
      end;

      //����������� ���-�� ����� � �������
      j:=lengthkey;
      k:=sizet/j;
      if k-trunc(k)<>0 then
      begin
        x:=trunc(k)+1;
      end
      else
      begin
        x:=trunc(k);
      end;

      col:=j;
      row:=x;

      //���������� ������� ��� �����������
      lengthstr:=1;
      for i := 1 to col do
      begin
        for j := 1 to row do
        begin
          if Textstr[lengthstr] in alf then
          begin
            matr[j][mass[i]]:=UpCase(Textstr[lengthstr]);
            lengthstr:=lengthstr+1;
          end
          else
          begin
            if Textstr[lengthstr]=' ' then
            begin
              matr[j][mass[i]]:='';
              lengthstr:=lengthstr+1;
            end
            else
            begin
              repeat
                lengthstr:=lengthstr+1;
              until
                textstr[lengthstr] in alf;
              if lengthstr<=sizet then
              begin
                matr[j][mass[i]]:=UpCase(textstr[lengthstr]);
                lengthstr:=lengthstr+1;
              end;
            end;
          end;
        end;
      end;

      //����� ��������������� ������ � ��������� ����
      Rewrite(File2);
      for i := 1 to row do
      begin
        for j := 1 to col do
        begin
          write(File2,matr[i][j]);
        end;
      end;

      Reset(File2);
      Readln(File2,Str);

      Encrypter.ResultText.Lines.Add(str);
      CloseFile(File2);
    end;
  end;
end;

//��������� ��� ���������� � ������������ ������ ���������� �������
Procedure ColEncr2(const key: String);
var
  matr: array[1..500,1..500] of String;      //������� ��� ����������(�������������) ������
  i,j,x,col,row:integer;                     //�������� �����
  File1,File2:Text;                          //��������� �����
  k: real;                                   //���������� ��� ����������� ����� ����� �������
  min:integer;                               //��������� ��� �������������� �������
  lengthstr, sizet: integer;                 //������ ������
  str: string;                               //���������� ��� ���������� �������� ������
  tmpn1,tmpn2:Integer;                       //���������� ��� ���������� �������� ��������� ��������
  tmp1,tmp2: char;                           //���������� ��� ����������� ������� ���� �������� �����
  mass: array[1..500] of integer;            //������, ������������ ������� ���� �������� �����
  mass2: array[1..500] of integer;           //������, ������������ ������� ������ �������� � ��������� ����
  tmp: char;                                 //��������� ����������
  lengthkey: integer;
  mass3: array[1..500] of Char;                               //���������� ��� ����������� ������� �������� ������� ����� � �����
  mass4: array[1..500] of Char;
  Textstr:String;
  mass5: array[1..500] of string;

begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf then
    begin
      lengthkey:=lengthkey+1;
      mass3[j]:=key[i];
      inc(j);
    end;
  end;

  //���� ���� �������� ������ ������� �����, �� ����� ��������� �� ����, ����� ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ���������� ����!');
    AssignFile(File2,'Decr-Encr.txt');

    Textstr:='';
    lengthstr:=0;
    for i:=0 to encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j:=1 to length(Str) do
      begin
        if (str[j] in alf) then
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
      Textstr:=Textstr+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      While length(textstr)>=lengthstr do
      begin
        if Textstr[lengthstr] in alf then
        begin
          write(file2,UpCase(Textstr[lengthstr]));
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
  end
  else
  begin                 //����������
    AssignFile(File2,'Decr-Encr.txt');
    j:=lengthkey;

    //����������� ���������� �������� ������� ������, �������� � �����
    lengthstr:=0;
    textstr:='';
    for i:=0 to Encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=encrypter.PlainTextForEncr.Lines[i];
      for j := 1  to length(str) do
      begin
        if str[j] in alf then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      textstr:=textstr+str;
    end;

    //���� ������ �������� ��� ����� ���������, ����� - ���������� ���������� ���������
    if lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('��������� ���� ����� ��� �������� ������ ������� �� ������������� ����������� �����');
      rewrite(File2);
      closeFile(file2);
    end
    else
    begin
      sizet:=lengthstr;
      j:=lengthkey;

      //����������� ���������� ����� � ������� ����������
      k:=lengthstr/j;
      if k-trunc(k)<>0 then
      begin
        x:=trunc(k)+1;
      end
      else
      begin
        x:=trunc(k);
      end;

      col:=j;
      row:=x;

      lengthstr:=1;

      //���������� ������� ��� ����������
      for i := 1 to row do
      begin
        for j := 1 to col do
        begin
          if (lengthstr>length(Textstr)) then
          begin
            matr[i][j]:=' ';
            lengthstr:=lengthstr+1;
          end
          else
          begin
            if Textstr[lengthstr] in alf then
            begin
              matr[i][j]:=Upcase(Textstr[lengthstr]);
              lengthstr:=lengthstr+1;
            end
            else
            begin
              repeat
                lengthstr:=lengthstr+1;
              until
                (Textstr[lengthstr] in alf) or (Lengthstr>Length(TextStr));

              if Lengthstr<=length(Textstr) then
              begin
                matr[i,j]:=Upcase(Textstr[lengthstr]);
                lengthstr:=lengthstr+1;
              end;
            end;
          end;
        end;
      end;

      //����������� ������� ���� �������� � �����
      tmp1:='A';
      tmp2:='a';
      x:=1;
      for i := 1 to 26 do
      begin
        for j := 1 to lengthkey do
        begin
          if (mass3[j]=tmp1) or (mass3[j]=tmp2) then
          begin
            mass2[j]:=x;
            inc(x);
          end;
        end;
        tmp1:=succ(tmp1);
        tmp2:=succ(tmp2);
      end;

      for i := 1 to lengthkey do
      begin
        mass[i]:=i;
      end;

      //���������� ��������, ��� ����������� ������� ���������� ��� ������ �������������� ������
      for i := 1 to lengthkey-1 do
      begin
        min:=i;
        for j := i+1 to lengthkey do
        begin
          if mass2[min]>mass2[j] then
          begin
            min:=j;
          end;
        end;
        tmpn1:=mass2[i];
        mass2[i]:=mass2[min];
        mass2[min]:=tmpn1;
        tmpn2:=mass[min];
        mass[min]:=mass[i];
        mass[i]:=tmpn2;
      end;

      //������ � ���� �����������
      Rewrite(File2);
      for i := 1 to col do
      begin
        for j := 1 to row do
        begin
          write(File2,matr[j][mass[i]]);
        end;
      end;

      Reset(File2);
      Readln(File2,Str);
      Close(File2);

      Encrypter.ResultText.Lines.Add(str);
    end;
  end;
end;

//��������� ��� ���������� � ������������ ������ ���������� �������
Procedure ColEncr(const key: String);
var
  matr: array[1..500,1..500] of String;      //������� ��� ����������(�������������) ������
  i,j,x,col,row:integer;                     //�������� �����
  File1,File2:Text;                          //��������� �����
  k: real;                                   //���������� ��� ����������� ����� ����� �������
  min:integer;                               //��������� ��� �������������� �������
  lengthstr, sizet: integer;                 //������ ������
  str: string;                               //���������� ��� ���������� �������� ������
  tmpn1,tmpn2:Integer;                       //���������� ��� ���������� �������� ��������� ��������
  tmp1,tmp2: char;                           //���������� ��� ����������� ������� ���� �������� �����
  mass: array[1..500] of integer;            //������, ������������ ������� ���� �������� �����
  mass2: array[1..500] of integer;           //������, ������������ ������� ������ �������� � ��������� ����
  tmp: char;                                 //��������� ����������
  lengthkey: integer;
  mass3: array[1..500] of Char;
  Textstr2:String;                               //���������� ��� ����������� ������� �������� ������� ����� � �����

begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf then
    begin
      lengthkey:=lengthkey+1;
      mass3[j]:=key[i];
      inc(j);
    end;
  end;

  //���� ���� �������� ������ ������� �����, �� ����� ��������� �� ����, ����� ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ���������� ����!');

    AssignFile(File1,'Encr.txt');
    AssignFile(File2,'Decr-Encr.txt');
    Reset(File1);

    TextStr2:='';
    //����������� ���������� �������� ������� ������, �������� � �����
    lengthstr:=0;
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if str[i] in alf then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      TextStr2:=Textstr2+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr2)>=lengthstr do
      begin
        if Textstr2[lengthstr] in alf then
        begin
          write(file2,UpCase(Textstr2[lengthstr]));
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
    Closefile(file1);

  end
  else
  begin
    AssignFile(File1,'Encr.txt');
    AssignFile(File2,'Decr-Encr.txt');
    Reset(File1);
    j:=lengthkey;

    TextStr2:='';
    //����������� ���������� �������� ������� ������, �������� � �����
    lengthstr:=0;
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if str[i] in alf then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      TextStr2:=Textstr2+str;
    end;

    //���� ������ �������� ��� ����� ���������, ����� - ���������� ���������� ���������
    if lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('���� � ������� ���� ��� �������� ������ ������� �� ������������� ����������� �����');
      Rewrite(file2);
      Closefile(file2);
    end
    else
    begin
      sizet:=lengthstr;

      //����������� ���������� ����� � ������� ����������
      k:=lengthstr/j;
      if k-trunc(k)<>0 then
      begin
        x:=trunc(k)+1;
      end
      else
      begin
        x:=trunc(k);
      end;

      col:=j;
      row:=x;
      lengthstr:=1;
      x:=0;
      //���������� ������� ��� ����������
      for i := 1 to row do
      begin
        for j := 1 to col do
        begin
          if x>sizet then
          begin
            matr[i][j]:=' ';
            lengthstr:=lengthstr+1;
            x:=x+1;
          end
          else
          begin
            if TextStr2[lengthstr] in alf then
            begin
              matr[i][j]:=UpCase(Textstr2[lengthstr]);
              lengthstr:=lengthstr+1;
              x:=x+1;
            end
            else
            begin
              repeat
                lengthstr:=lengthstr+1;
              until
                (Textstr2[lengthstr] in alf) or (Lengthstr>Length(TextStr2));

              if Lengthstr<=Length(Textstr2) then
              begin
                matr[i,j]:=UpCase(Textstr2[lengthstr]);
                lengthstr:=lengthstr+1;
                x:=x+1;
              end
              else
              begin
                matr[i][j]:=' ';
                lengthstr:=lengthstr+1;
                x:=x+1;
              end;
            end;
          end;
        end;
      end;

      //����������� ������� ���� �������� � �����
      tmp1:='A';
      tmp2:='a';
      x:=1;
      for i := 1 to 26 do
      begin
        for j := 1 to lengthkey do
        begin
          if (mass3[j]=tmp1) or (mass3[j]=tmp2) then
          begin
            mass2[j]:=x;
            inc(x);
          end;
        end;
        tmp1:=succ(tmp1);
        tmp2:=succ(tmp2);
      end;

      for i := 1 to lengthkey do
      begin
        mass[i]:=i;
      end;

      //���������� ��������, ��� ����������� ������� ���������� ��� ������ �������������� ������
      for i := 1 to lengthkey-1 do
      begin
        min:=i;
        for j := i+1 to lengthkey do
        begin
          if mass2[min]>mass2[j] then
          begin
            min:=j;
          end;
        end;
        tmpn1:=mass2[i];
        mass2[i]:=mass2[min];
        mass2[min]:=tmpn1;
        tmpn2:=mass[min];
        mass[min]:=mass[i];
        mass[i]:=tmpn2;
      end;

      //������ � ���� �����������
      Rewrite(File2);
      for i := 1 to col do
      begin
        for j := 1 to row do
        begin
          write(File2,matr[j][mass[i]]);
        end;
      end;
      Reset(File2);
      Readln(File2,Str);
      Close(File2);

      Encrypter.ResultText.Lines.Add(str);
      Close(File1);
    end;
  end;
end;

//��������� ��� ���������� � ������������ ������ ���������� �������
Procedure ColEncr4(const key: String);
var
  matr: array[1..500,1..500] of String;      //������� ��� ����������(�������������) ������
  i,j,x,col,row:integer;                     //�������� �����
  File1,File2:Text;                          //��������� �����
  k: real;                                   //���������� ��� ����������� ����� ����� �������
  min:integer;                               //��������� ��� �������������� �������
  lengthstr, sizet: integer;                 //������ ������
  str: string;                               //���������� ��� ���������� �������� ������
  tmpn1,tmpn2:Integer;                       //���������� ��� ���������� �������� ��������� ��������
  tmp1,tmp2: char;                           //���������� ��� ����������� ������� ���� �������� �����
  mass: array[1..500] of integer;            //������, ������������ ������� ���� �������� �����
  mass2: array[1..500] of integer;           //������, ������������ ������� ������ �������� � ��������� ����
  tmp: char;                                 //��������� ����������
  lengthkey: integer;
  mass3: array[1..500] of Char;                               //���������� ��� ����������� ������� �������� ������� ����� � �����
  Textstr2: String;

begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf then
    begin
      lengthkey:=lengthkey+1;
      mass3[j]:=key[i];
      inc(j);
    end;
  end;

  //���� ���� �������� ������ ������� �����, �� ����� ��������� �� ����, ����� ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ���������� ����!');

    AssignFile(File1,'Decr-Encr.txt');
    assignFile(File2,'Encr-Decr.txt');

    Textstr2:='';
    //����������� ���������� ��������, ��������� ��� �����������
    Reset(File1);
    lengthstr:=0;
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if (str[i] in alf) then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr2:=textstr2+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr2)>=lengthstr do
      begin
        if Textstr2[lengthstr] in alf then
        begin
          write(file2,UpCase(Textstr2[lengthstr]));
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
    Closefile(file1);
  end
  else
  begin
    AssignFile(File1,'Decr-Encr.txt');
    assignFile(File2,'Encr-Decr.txt');

    Textstr2:='';
    //����������� ���������� ��������, ��������� ��� �����������
    Reset(File1);
    lengthstr:=0;
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if (str[i] in alf) or (str[i]=' ') then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr2:=textstr2+str;
    end;

    //���� ��� �������� ������� ����� � �����, �� ����� ��������� �� ����, ����� - ��������� ���������� ���������
    If lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('���� � ������� ���� ��� �������� ������ ������� �� ������������� ����������� �����');
      Rewrite(file2);
      CloseFile(File2);
    end
    else
    begin

      //����������� ������� ���������� �������� � �����
      tmp1:='A';
      tmp2:='a';
      x:=1;
      for i := 1 to 26 do
      begin
        for j := 1 to lengthkey do
        begin
          if (mass3[j]=tmp1) or (mass3[j]=tmp2) then
          begin
            mass2[j]:=x;
            inc(x);
          end;
        end;
        tmp1:=succ(tmp1);
        tmp2:=succ(tmp2);
      end;

      for i := 1 to lengthkey do
      begin
        mass[i]:=i;
      end;

      // ���������� �������� ��� ����������� ������������������ ���������� ������� ��� �����������
      for i := 1 to lengthkey-1 do
      begin
        min:=i;
        for j := i+1 to lengthkey do
        begin
          if mass2[min]>mass2[j] then
          begin
            min:=j;
          end;
        end;
        tmpn1:=mass2[i];
        mass2[i]:=mass2[min];
        mass2[min]:=tmpn1;
        tmpn2:=mass[min];
        mass[min]:=mass[i];
        mass[i]:=tmpn2;
      end;

      //����������� ���-�� ����� � �������
      j:=lengthkey;
      k:=lengthstr/j;
      if k-trunc(k)<>0 then
      begin
        x:=trunc(k)+1;
      end
      else
      begin
        x:=trunc(k);
      end;

      col:=j;
      row:=x;

      //���������� ������� ��� �����������
      x:=0;
      lengthstr:=1;
      for i := 1 to col do
      begin
        for j := 1 to row do
        begin
          if Textstr2[lengthstr] in alf then
          begin
            matr[j][mass[i]]:=UpCase(Textstr2[lengthstr]);
            lengthstr:=lengthstr+1;
            x:=x+1;
          end
          else
          begin
            if Textstr2[lengthstr]=' ' then
            begin
              matr[j][mass[i]]:='';
              lengthstr:=lengthstr+1;
              x:=x+1;
            end
            else
            begin
              repeat
                lengthstr:=lengthstr+1;
              until
                (Textstr2[lengthstr] in alf) or (lengthstr>length(textstr2));

              If lengthstr<=length(textstr2) then
              begin
                matr[j][mass[i]]:=UpCase(textstr2[lengthstr]);
                lengthstr:=lengthstr+1;
                x:=x+1;
              end;
            end;
          end;
        end;
      end;

      //����� ��������������� ������ � ��������� ����
      Rewrite(File2);
      for i := 1 to row do
      begin
        for j := 1 to col do
        begin
          write(File2,matr[i][j]);
        end;
      end;

      Reset(File2);
      Readln(File2,Str);

      Encrypter.ResultText.Lines.Add(str);
      CloseFile(File2);
    end;
    CloseFile(File1);
  end;
end;

//��������� ���������� ������� ���������������� �������
Procedure TurnGrid(const key: String);
var
  a: Matrix;                                     //������� 4�4
  str: String;                                   //���������� ��� ���������� �������� ������
  i,j,k,num,x, lengthstr, num2: integer;         //�������� �����
  File1,file2: Text;                             //��������� �����
  mass: array[1..10000] of String;               //������ ��� �������� �������� �����������
  mass2: array[1..10000] of String;              //������ ��� �������� �������� ��������������� ������
  size: Integer;                                 //������ ������
  Bykva: Char;                                   //���������� ��� ���������� ������� ����������� ��������
  ost, dop: Integer;
  Textstr2: String;                             //���������� ��� �������� ������� �� �������������� ������� � �����, ����������� ��� ���������� �����

begin
  AssignFile(File1,'Encr2.txt');
  AssignFile(File2,'Decr-Encr2.txt');

  //����������� ���������� ������ ��������, ��������  � �����
  Reset(File1);
  lengthstr:=0;
  textstr2:='';
  while not Eof(File1) do
  begin
    readln(File1,str);
    for i := 1  to length(str) do
    begin
      if str[i] in alf then
      begin
        lengthstr:=Lengthstr+1;
      end;
    end;
    TextStr2:=Textstr2+str;
  end;

  //���� ������ �������� ���, �� ������� ���������, ����� - ���������� ���������� ���������
  if lengthstr=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� � ������� ���� ��� �������� ������ ������� �� ������������� ����������� �����');
    rewrite(file2);
    closefile(file2);
  end
  else
  begin
    size:= lengthstr;

    //���������� ������� ��������� ������
    x:=0;
    lengthstr:=1;
    for i := 1 to size do
    begin
      if textstr2[lengthstr] in alf then
      begin
        mass[i]:=UpCase(textstr2[lengthstr]);
        lengthstr:=lengthstr+1;
        x:=x+1;
      end
      else
      begin
        repeat
          lengthstr:=lengthstr+1;
        until
          Textstr2[lengthstr] in alf;
        mass[i]:=UpCase(Textstr2[lengthstr]);
        lengthstr:=lengthstr+1;
        x:=x+1;
      end;
    end;

    Rewrite(File2);

    //����������� ��������������� ����������
    ost:=size mod 16;
    if ost<>0 then
    begin
      dop:=16-ost;
    end
    else
    begin
      dop:=0;
    end;

    //���������� ������� ���������������� �������
    num:=1;
    Bykva:='A';
    while num<size+dop do
    begin
      k:=0;
      while k<>4 do
      begin
        for i := 1 to n do
        begin
          for j := 1 to n do
          begin
            if mask[i,j]='x' then
            begin
              if num<=size then
              begin
                a[i,j]:=mass[num];
                num:=num+1;
              end
              else
              begin
                a[i,j]:=Bykva;
                Bykva:=Succ(Bykva);
                num:=num+1;
              end;
            end;
          end;
        end;
        Povorot(mask);
        k:=k+1;
      end;

      //����� ����������� � ����
      for i := 1 to n do
      begin
        for j := 1 to n do
        begin
          write(File2,a[i][j]);
        end;
      end;
    end;

    Reset(File2);
    Readln(File2,Str);

    Encrypter.ResultText.Lines.Add(str);

    CloseFile(file2);
    CloseFile(file1);
  end;
end;

//��������� ���������� ������� ���������������� �������
Procedure TurnGrid4(const key: String);
var
  a: Matrix;                                     //������� 4�4
  str: String;                                   //���������� ��� ���������� �������� ������
  i,j,k,num,x, lengthstr, num2: integer;         //�������� �����
  File1,file2: Text;                             //��������� �����
  mass: array[1..10000] of String;               //������ ��� �������� �������� �����������
  mass2: array[1..10000] of String;              //������ ��� �������� �������� ��������������� ������
  size: Integer;                                 //������ ������
  Bykva: Char;                                   //���������� ��� ���������� ������� ����������� ��������
  ost, dop: Integer;
  textstr2: String;                             //���������� ��� �������� ������� �� �������������� ������� � �����, ����������� ��� ���������� �����

begin
  AssignFile(File1,'Decr-Encr2.txt');
  AssignFile(File2,'Encr-Decr2.txt');
  Reset(File1);

  //����������� ���-�� ���������� ��������, �������������� � ���������
  textstr2:='';
  lengthstr:=0;
  while not Eof(File1) do
  begin
    readln(File1,str);
    for i := 1  to length(str) do
    begin
      if str[i] in alf then
      begin
        lengthstr:=Lengthstr+1;
      end;
    end;
    Textstr2:=textstr2+str;
  end;

  //���� �������� ��� ��������� ���, ������� ��������� �� ����, ����� - ���������� ���������� ���������
  if lengthstr=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� � ������� ���� ��� �������� ������ ������� �� ������������� ����������� �����');
    rewrite(file2);
    closeFile(file2);
  end
  else
  begin
    size:= lengthstr;

    //���������� ������� ��������� �����������
    lengthstr:=1;
    for i := 1 to size do
    begin
      if Textstr2[lengthstr] in alf then
      begin
        mass[i]:=UpCase(Textstr2[lengthstr]);
        lengthstr:=lengthstr+1;
      end
      else
      begin
        repeat
          lengthstr:=lengthstr+1;
        until
          Textstr2[lengthstr] in alf;
        mass[i]:=UpCase(Textstr2[lengthstr]);
        lengthstr:=lengthstr+1;
      end;
    end;

    //����������� ������
    num:=1;
    num2:=1;
    while num<size do
    begin
      for i:=1 to n do
      begin
        for j:=1 to n do
        begin
          a[i,j]:=mass[num];
          num:=num+1;
        end;
      end;

      k:=0;
      while k<>4 do
      begin
        for i:=1 to n do
        begin
          for j:=1 to n do
          begin
            if mask[i,j]='x' then
            begin
              mass2[num2]:=a[i,j];
              inc(num2);
            end;
          end;
        end;
        Povorot(mask);
        inc(k);
      end;
    end;

    //����� ����������� ������ � ����
    Rewrite(File2);
    for i:=1 to num2 do
    begin
      Write(File2,mass2[i]);
    end;

    Reset(File2);
    Readln(File2,Str);

    Encrypter.ResultText.Lines.Add(str);
    CloseFile(File2);
    CloseFile(file1);
  end;
end;

//��������� ���������� ������� ���������������� �������
Procedure TurnGrid3(const key: String);
var
  a: Matrix;                                     //������� 4�4
  str: String;                                   //���������� ��� ���������� �������� ������
  i,j,k,num,x, lengthstr, num2: integer;         //�������� �����
  File1,file2: Text;                             //��������� �����
  mass: array[1..10000] of String;               //������ ��� �������� �������� �����������
  mass2: array[1..10000] of String;              //������ ��� �������� �������� ��������������� ������
  size: Integer;                                 //������ ������
  Bykva: Char;                                   //���������� ��� ���������� ������� ����������� ��������
  ost, dop: Integer;                             //���������� ��� �������� ������� �� �������������� ������� � �����, ����������� ��� ���������� �����
  textstr: String;

begin
  AssignFile(File2,'Encr-Decr2.txt');

  Textstr:='';
  lengthstr:=0;
  //����������� ���-�� ���������� ��������, �������������� � ���������
  For i:= 0 to Encrypter.PlainTextForEncr.Lines.Count do
  begin
    str:=Encrypter.PlainTextForEncr.Lines[i];
    for j := 1  to length(str) do
    begin
      if str[j] in alf then
      begin
        lengthstr:=Lengthstr+1;
      end;
    end;
    Textstr:=textstr+str;
  end;


  //���� �������� ��� ��������� ���, ������� ��������� �� ����, ����� - ���������� ���������� ���������
  if lengthstr=0 then
  begin
    Encrypter.ErrorText.Lines.Add('��������� ���� ����� ��� �������� ������ ������� �� ������������� ����������� �����');
    rewrite(file2);
    closefile(file2);
  end
  else
  begin
    size:= lengthstr;

    j:=1;
    lengthstr:=0;
    //���������� ������� ��������� �����������
    for i := 1 to length(TextStr) do
    begin
      if Textstr[lengthstr] in alf then
      begin
        mass[j]:=UpCase(Textstr[lengthstr]);
        lengthstr:=lengthstr+1;
        j:=j+1;
      end
      else
      begin
        repeat
          lengthstr:=lengthstr+1;
        until
          Textstr[lengthstr] in alf;
        mass[j]:=UpCase(Textstr[lengthstr]);
        lengthstr:=lengthstr+1;
        j:=j+1;
      end;
    end;

    //����������� ������
    num:=1;
    num2:=1;
    while num<size do
    begin
      for i:=1 to n do
      begin
        for j:=1 to n do
        begin
          a[i,j]:=mass[num];
          num:=num+1;
        end;
      end;

      k:=0;
      while k<>4 do
      begin
        for i:=1 to n do
        begin
          for j:=1 to n do
          begin
            if mask[i,j]='x' then
            begin
              mass2[num2]:=a[i,j];
              inc(num2);
            end;
          end;
        end;
        Povorot(mask);
        inc(k);
      end;
    end;

    //����� ����������� ������ � ����
    Rewrite(File2);
    for i:=1 to num2 do
    begin
      Write(File2,mass2[i]);
    end;

    Reset(File2);
    Readln(File2,Str);

    Encrypter.ResultText.Lines.Add(str);
    CloseFile(File2);
  end;
end;

//��������� ���������� ������� ���������������� �������
Procedure TurnGrid2(const key: String);
var
  a: Matrix;                                     //������� 4�4
  str: String;                                   //���������� ��� ���������� �������� ������
  i,j,k,num,x, lengthstr, num2: integer;         //�������� �����
  File1,file2: Text;                             //��������� �����
  mass: array[1..10000] of String;               //������ ��� �������� �������� �����������
  mass2: array[1..10000] of String;              //������ ��� �������� �������� ��������������� ������
  size: Integer;                                 //������ ������
  Bykva: Char;                                   //���������� ��� ���������� ������� ����������� ��������
  ost, dop: Integer;
  Textstr: String;                            //���������� ��� �������� ������� �� �������������� ������� � �����, ����������� ��� ���������� �����

begin
  AssignFile(File2,'Decr-Encr2.txt');

  //����������� ���������� ������ ��������, ��������  � �����

  Textstr:='';
  lengthstr:=0;
  for i:= 0 to Encrypter.PlainTextForEncr.Lines.Count do
  begin
    str:=Encrypter.PlainTextForEncr.Lines[i];
    for j := 1  to length(str) do
    begin
      if str[j] in alf then
      begin
        lengthstr:=Lengthstr+1;
      end;
    end;
    Textstr:=textstr+str;
  end;


  //���� ������ �������� ���, �� ������� ���������, ����� - ���������� ���������� ���������
  if lengthstr=0 then
  begin
    Encrypter.ErrorText.Lines.Add('��������� ���� ����� ��� �������� ������ ������� �� ������������� ����������� �����');
    Rewrite(file2);
    Closefile(file2);
  end
  else
  begin
    size:= lengthstr;

    Lengthstr:= 1;
    j:=1;
    //���������� ������� ��������� ������
    for i := 1 to length(Textstr) do
    begin
      if Textstr[lengthstr] in alf then
      begin
        mass[j]:=UpCase(textstr[lengthstr]);
        lengthstr:=lengthstr+1;
        j:=j+1;
      end
      else
      begin
        repeat
          lengthstr:=lengthstr+1;
        until
          textstr[lengthstr] in alf;
        mass[j]:=UpCase(textstr[lengthstr]);
        lengthstr:=lengthstr+1;
        j:=j+1;
      end;
    end;

    Rewrite(File2);
    //����������� ��������������� ����������
    ost:=size mod 16;
    if ost<>0 then
    begin
      dop:=16-ost;
    end
    else
    begin
      dop:=0;
    end;

    //���������� ������� ���������������� �������
    num:=1;
    Bykva:='A';
    while num<size+dop do
    begin
      k:=0;
      while k<>4 do
      begin
        for i := 1 to n do
        begin
          for j := 1 to n do
          begin
            if mask[i,j]='x' then
            begin
              if num<=size then
              begin
                a[i,j]:=mass[num];
                num:=num+1;
              end
              else
              begin
                a[i,j]:=Bykva;
                Bykva:=Succ(Bykva);
                num:=num+1;
              end;
            end;
          end;
        end;
        Povorot(mask);
        k:=k+1;
      end;

      //����� ����������� � ����
      for i := 1 to n do
      begin
        for j := 1 to n do
        begin
          write(File2,a[i][j]);
        end;
      end;
    end;

    Reset(File2);
    Readln(File2,Str);

    Encrypter.ResultText.Lines.Add(str);
    CloseFile(file2);
  end;
end;


//��������� ���������� ������� ����� ��������
Procedure VigChiper(const key: String);
var
  str: String;                         //����������, ��� ���������� �������� ������
  i,j,k,lengthstr: integer;            //���������� �����
  File1,File2: Text;                   //��������� �����
  mass: array[1..3,1..10000] of Char;  //������� ��� �������� �������� ��������� ������, �������� �����, � ����� �������� �����������
  mass2: array[1..33] of Char;         //������, ���������� ������� ��������� ������� ����
  mass3: array[1..33] of Char;
  mass4: array[1..10000] of Char;      //������ ���������� ������� ������� ������� ����
  size,Lengthkey: Integer;             //������ ������
  x: char;                             //���������� ��� �����
  tmp, tmp1, tmp2: integer;
  textstr2: String;           //������� ��������, ������������ � ������� ��� ���������� � ������������                    //���������� ��� ��������� ������� �������� ������� ����� � �����
begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf2 then
    begin
      lengthkey:=lengthkey+1;
      mass4[j]:=key[i];
      inc(j);
    end;
  end;

  //���������� ������� ���������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass2[i]:='�';
      end
      else
      begin
        mass2[i]:=x;
        x:=succ(x);
      end;
    end;

    //���������� ������ �������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass3[i]:='�';
      end
      else
      begin
        mass3[i]:=x;
        x:=succ(x);
      end;
    end;

  //���� ������� ������� ����� ���� � �����, ������� ��������� �� ����, ����� - ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ������� ����!');
    AssignFile(File1,'Encr3.txt');
    AssignFile(File2,'Decr-Encr3.txt');

    //����������� ���������� �������� �������������� � ����������
    Reset(File1);
    lengthstr:=0;
    Textstr2:='';
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if str[i] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr2:=textstr2+str;
    end;

    rewrite(file2);
   if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr2)>=lengthstr do
      begin
        if Textstr2[lengthstr] in alf2 then
        begin
          if Textstr2[lengthstr] in max then
          begin
            for i:=1 to 33 do
            begin
              if mass3[i]=Textstr2[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end
          else
          begin
            for i:=1 to 33 do
            begin
              if mass2[i]=Textstr2[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end;
          write(file2,mass3[j]);
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
    Closefile(file1);
  end
  else
  begin

    AssignFile(File1,'Encr3.txt');
    AssignFile(File2,'Decr-Encr3.txt');

    //����������� ���������� �������� �������������� � ����������
    Reset(File1);
    lengthstr:=0;
    Textstr2:='';
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if str[i] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr2:=textstr2+str;
    end;

    //���� ��������, ��������� ��� ���������� ���, �� ������� ��������� �� ����, ����� - ���������� ���������� ���������
    if lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('���� � ������� ���� ��� �������� ������ ������� �� ������������� �������� �����');
      Rewrite(file2);
      Closefile(file2);
    end
    else
    begin
      size:= lengthstr;

      //���������� ������� ��������� ��������� ������
      lengthstr:=1;
      for i := 1 to size do
      begin
        if Textstr2[lengthstr] in alf2 then
        begin
          mass[1,i]:=UpCase(Textstr2[lengthstr]);
          lengthstr:=lengthstr+1;
        end
        else
        begin
          repeat
            lengthstr:=lengthstr+1;
          until
            Textstr2[lengthstr] in alf2;
          mass[1,i]:=UpCase(Textstr2[lengthstr]);
          lengthstr:=lengthstr+1;
        end;
      end;

      //���������� ������� ��������� ������������������� �����
      j:=1;
      for i := 1 to size do
      begin
        if lengthkey>=i then
        begin
          mass[2][i]:=mass4[i];
        end
        else
        begin
          mass[2][i]:=mass[1][j];
          j:=j+1;
        end;
      end;

      //���������� ������
      for i:=1 to size do
      begin
        if mass[1][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end;

        if mass[2][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end;

        tmp:=(tmp1+tmp2-1) mod 33;

        if tmp=0 then
        begin
          tmp:=33;
        end;

        if mass[1][i] in max then
        begin
          mass[3][i]:=mass3[tmp];
        end
        else
        begin
          mass[3][i]:=mass3[tmp];
        end;
      end;

      //����� �������� ����������� � ����
      Rewrite(File2);
      for i:= 1 to size do
      begin
        write(File2,UpCase(mass[3][i]));
      end;

      Reset(File2);
      Readln(File2,Str);

      Encrypter.ResultText.Lines.Add(str);
      CloseFile(File2);
      CloseFile(file1);
    end;
  end;
end;

//��������� ���������� ������� ����� ��������
Procedure VigChiper2(const key: String);
var
  str: String;                         //����������, ��� ���������� �������� ������
  i,j,k,lengthstr: integer;            //���������� �����
  File1,File2: Text;                   //��������� �����
  mass: array[1..3,1..10000] of Char;  //������� ��� �������� �������� ��������� ������, �������� �����, � ����� �������� �����������
  mass2: array[1..33] of Char;         //������, ���������� ������� ��������� ������� ����
  mass3: array[1..33] of Char;
  mass4: array[1..10000] of Char;      //������ ���������� ������� ������� ������� ����
  size,Lengthkey: Integer;             //������ ������
  x: char;                             //���������� ��� �����
  tmp, tmp1, tmp2: integer;            //������� ��������, ������������ � ������� ��� ���������� � ������������                    //���������� ��� ��������� ������� �������� ������� ����� � �����
  Textstr:String;

begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf2 then
    begin
      lengthkey:=lengthkey+1;
      mass4[j]:=key[i];
      inc(j);
    end;
  end;

  //���������� ������� ���������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass2[i]:='�';
      end
      else
      begin
        mass2[i]:=x;
        x:=succ(x);
      end;
    end;

    //���������� ������ �������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass3[i]:='�';
      end
      else
      begin
        mass3[i]:=x;
        x:=succ(x);
      end;
    end;

  //���� ������� ������� ����� ���� � �����, ������� ��������� �� ����, ����� - ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ������� ����!');

    AssignFile(File2,'Decr-Encr3.txt');
    lengthstr:=0;
    Textstr:='';
    //����������� ���������� �������� �������������� � ����������
    For i:=0 to Encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j := 1  to length(str) do
      begin
        if str[j] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr:=textstr+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr)>=lengthstr do
      begin
        if Textstr[lengthstr] in alf2 then
        begin
          if Textstr[lengthstr] in max then
          begin
            for i:=1 to 33 do
            begin
              if mass3[i]=Textstr[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end
          else
          begin
            for i:=1 to 33 do
            begin
              if mass2[i]=Textstr[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end;
          write(file2,mass3[j]);
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
  end
  else
  begin

    AssignFile(File2,'Decr-Encr3.txt');
    lengthstr:=0;
    Textstr:='';
    //����������� ���������� �������� �������������� � ����������

    For i:=0 to Encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j := 1  to length(str) do
      begin
        if str[j] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr:=textstr+str;
    end;

    //���� ��������, ��������� ��� ���������� ���, �� ������� ��������� �� ����, ����� - ���������� ���������� ���������
    if lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('��������� ���� ����� ��� �������� ������ ������� �� ������������� �������� �����');
      Rewrite(file2);
      Closefile(file2);
    end
    else
    begin
      size:= lengthstr;

      //���������� ������� ��������� ��������� ������
      lengthstr:=1;
      j:=1;
      for i := 1 to Length(TextStr) do
      begin
        if Textstr[lengthstr] in alf2 then
        begin
          mass[1,j]:=UpCase(Textstr[lengthstr]);
          j:=j+1;
          lengthstr:=lengthstr+1;
        end
        else
        begin
          repeat
            lengthstr:=lengthstr+1;
          until
            Textstr[lengthstr] in alf2;
          mass[1,j]:=UpCase(Textstr[lengthstr]);
          j:=j+1;
          lengthstr:=lengthstr+1;
        end;
      end;

      //���������� ������� ��������� ������������������� �����
      j:=1;
      for i := 1 to size do
      begin
        if lengthkey>=i then
        begin
          mass[2][i]:=mass4[i];
        end
        else
        begin
          mass[2][i]:=mass[1][j];
          j:=j+1;
        end;
      end;

      //���������� ������
      for i:=1 to size do
      begin
        if mass[1][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end;

        if mass[2][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end;

        tmp:=(tmp1+tmp2-1) mod 33;

        if tmp=0 then
        begin
          tmp:=33;
        end;

        if mass[1][i] in max then
        begin
          mass[3][i]:=mass3[tmp];
        end
        else
        begin
          mass[3][i]:=mass3[tmp];
        end;
      end;

      //����� �������� ����������� � ����
      Rewrite(File2);
      for i:= 1 to size do
      begin
        write(File2,UpCase(mass[3][i]));
      end;

      Reset(File2);
      Readln(File2,Str);

      Encrypter.ResultText.Lines.Add(str);
      CloseFile(File2);
    end;
  end;
end;

//��������� ���������� ������� ����� ��������
Procedure VigChiper3(const key: String);
var
  str: String;                         //����������, ��� ���������� �������� ������
  i,j,k,lengthstr: integer;            //���������� �����
  File1,File2: Text;                   //��������� �����
  mass: array[1..3,1..10000] of Char;  //������� ��� �������� �������� ��������� ������, �������� �����, � ����� �������� �����������
  mass2: array[1..33] of Char;         //������, ���������� ������� ��������� ������� ����
  mass3: array[1..33] of Char;
  mass4: array[1..10000] of Char;      //������ ���������� ������� ������� ������� ����
  size,Lengthkey: Integer;             //������ ������
  x: char;                             //���������� ��� �����
  tmp, tmp1, tmp2: integer;            //������� ��������, ������������ � ������� ��� ���������� � ������������                    //���������� ��� ��������� ������� �������� ������� ����� � �����
  Textstr:String;

begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf2 then
    begin
      lengthkey:=lengthkey+1;
      mass4[j]:=key[i];
      inc(j);
    end;
  end;

  //���������� ������� ���������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass2[i]:='�';
      end
      else
      begin
        mass2[i]:=x;
        x:=succ(x);
      end;
    end;

    //���������� ������ �������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass3[i]:='�';
      end
      else
      begin
        mass3[i]:=x;
        x:=succ(x);
      end;
    end;

  //���� ������� ������� ����� ���� � �����, ������� ��������� �� ����, ����� - ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ������� ����!');
    AssignFile(File2,'Encr-Decr3.txt');

    //??????????? ?????????? ????????, ????????? ??? ??????????

    Textstr:='';
    lengthstr:=0;
    For i:=0 to Encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j := 1  to length(str) do
      begin
        if str[j] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr:=Textstr+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr)>=lengthstr do
      begin
        if Textstr[lengthstr] in alf2 then
        begin
          if Textstr[lengthstr] in max then
          begin
            for i:=1 to 33 do
            begin
              if mass3[i]=Textstr[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end
          else
          begin
            for i:=1 to 33 do
            begin
              if mass2[i]=Textstr[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end;
          write(file2,mass3[j]);
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);

  end
  else
  begin

    AssignFile(File2,'Encr-Decr3.txt');

    //??????????? ?????????? ????????, ????????? ??? ??????????

    Textstr:='';
    lengthstr:=0;
    For i:=0 to Encrypter.PlainTextForEncr.Lines.Count do
    begin
      str:=Encrypter.PlainTextForEncr.Lines[i];
      for j := 1  to length(str) do
      begin
        if str[j] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr:=Textstr+str;
    end;

    //???? ???????? ?????????? ??? ?????????? ???, ?? ??????? ????????? ?? ????, ????? ?????????? ?????????? ?????????
    if lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('��������� ���� ����� ��� �������� ������ ������� �� ������������� �������� �����');
      Rewrite(File2);
      Closefile(file2);
    end
    else
    begin
      size:= lengthstr;

      //?????????? ??????? ????????? ??????????????? ??????
      j:=1;
      lengthstr:=1;
      for i := 1 to length(TextStr) do
      begin
        if Textstr[lengthstr] in alf2 then
        begin
          mass[1,j]:=UpCase(Textstr[lengthstr]);
          lengthstr:=lengthstr+1;
          j:=j+1;
        end
        else
        begin
          repeat
            lengthstr:=lengthstr+1;
          until
            Textstr[lengthstr] in alf2;
          mass[1,j]:=UpCase(Textstr[lengthstr]);
          j:=j+1;
          lengthstr:=lengthstr+1;
        end;
      end;

      //?????????? ??????? ????????? ?????
      for i := 1 to lengthkey do
      begin
        mass[2,i]:=mass4[i];
      end;

      //??????????? ?????? ? ????????? ??????????? ??????? ????????? ??????????????????? ????? ? ????????? ??????????????? ??????
      k:=lengthkey+1;
      for i:=1 to size do
      begin
        if mass[1][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end;

        if mass[2][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end;


        tmp:=(tmp1-tmp2+34)mod 33;

        if tmp=0 then
        begin
          tmp:=33;
        end;

        if mass[1][i] in max then
        begin
          mass[3][i]:=mass3[tmp];
          mass[2,k]:=mass3[tmp];
          k:=k+1;
        end
        else
        begin
          mass[3][i]:=mass3[tmp];
          mass[2,k]:=mass3[tmp];
          k:=k+1;
        end;
      end;

      //????? ??????????????? ?????? ? ????
      Rewrite(File2);
      for i:= 1 to size do
      begin
        write(File2,UpCase(mass[3][i]));
      end;

      Reset(File2);
      Readln(File2,Str);

      Encrypter.ResultText.Lines.Add(str);
      CloseFile(File2);
    end;
  end;
end;

//��������� ���������� ������� ����� ��������
Procedure VigChiper4(const key: String);
var
  str: String;                         //����������, ��� ���������� �������� ������
  i,j,k,lengthstr: integer;            //���������� �����
  File1,File2: Text;                   //��������� �����
  mass: array[1..3,1..10000] of Char;  //������� ��� �������� �������� ��������� ������, �������� �����, � ����� �������� �����������
  mass2: array[1..33] of Char;         //������, ���������� ������� ��������� ������� ����
  mass3: array[1..33] of Char;
  mass4: array[1..10000] of Char;      //������ ���������� ������� ������� ������� ����
  size,Lengthkey: Integer;             //������ ������
  x: char;                             //���������� ��� �����
  tmp, tmp1, tmp2: integer;
  Textstr2: String;            //������� ��������, ������������ � ������� ��� ���������� � ������������                    //���������� ��� ��������� ������� �������� ������� ����� � �����
begin

  j:=1;
  //����������� ��������� � ���� �������� ������� �����
  lengthkey:=0;
  For i:=1 to length(key) do
  begin
    if  key[i] in alf2 then
    begin
      lengthkey:=lengthkey+1;
      mass4[j]:=key[i];
      inc(j);
    end;
  end;

  //���������� ������� ���������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass2[i]:='�';
      end
      else
      begin
        mass2[i]:=x;
        x:=succ(x);
      end;
    end;

    //���������� ������ �������� ��������� �������� ��������
    x:='�';
    for i:= 1 to 33 do
    begin
      if i=7 then
      begin
        mass3[i]:='�';
      end
      else
      begin
        mass3[i]:=x;
        x:=succ(x);
      end;
    end;

  //���� ������� ������� ����� ���� � �����, ������� ��������� �� ����, ����� - ���������� ���������� ���������
  if lengthkey=0 then
  begin
    Encrypter.ErrorText.Lines.Add('���� �������� ������ ������� �� �������� � ������� ����!');

    AssignFile(File1,'Decr-Encr3.txt');
    AssignFile(File2,'Encr-Decr3.txt');

    //����������� ���������� ��������, ��������� ��� ����������
    Reset(File1);
    Textstr2:='';
    lengthstr:=0;
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if str[i] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr2:=Textstr2+str;
    end;

    rewrite(file2);
    if lengthstr>0 then
    begin
      lengthstr:=1;
      while length(textstr2)>=lengthstr do
      begin
        if Textstr2[lengthstr] in alf2 then
        begin
          if Textstr2[lengthstr] in max then
          begin
            for i:=1 to 33 do
            begin
              if mass3[i]=Textstr2[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end
          else
          begin
            for i:=1 to 33 do
            begin
              if mass2[i]=Textstr2[lengthstr] then
              begin
                j:=i;
              end;
            end;
          end;
          write(file2,mass3[j]);
          lengthstr:=lengthstr+1;
        end
        else
        begin
          lengthstr:=lengthstr+1;
        end;
      end;
    end
    else
    begin
      rewrite(file2);
    end;

    reset(file2);
    readln(file2,str);

    Encrypter.ResultText.Lines.Add(str);

    closefile(file2);
    Closefile(file1);

  end
  else
  begin

    AssignFile(File1,'Decr-Encr3.txt');
    AssignFile(File2,'Encr-Decr3.txt');

    //����������� ���������� ��������, ��������� ��� ����������
    Reset(File1);
    Textstr2:='';
    lengthstr:=0;
    while not Eof(File1) do
    begin
      readln(File1,str);
      for i := 1  to length(str) do
      begin
        if str[i] in alf2 then
        begin
          lengthstr:=Lengthstr+1;
        end;
      end;
      Textstr2:=Textstr2+str;
    end;

    //���� �������� ���������� ��� ���������� ���, �� ������� ��������� �� ����, ����� ���������� ���������� ���������
    if lengthstr=0 then
    begin
      Encrypter.ErrorText.Lines.Add('���� � ������� ���� ��� �������� ������ ������� �� ������������� �������� �����');
      Rewrite(file2);
      Closefile(File2)
    end
    else
    begin
      size:= lengthstr;

      //���������� ������� ��������� ��������������� ������
      lengthstr:=1;
      for i := 1 to size do
      begin
        if Textstr2[lengthstr] in alf2 then
        begin
          mass[1,i]:=UpCase(Textstr2[lengthstr]);
          lengthstr:=lengthstr+1;
        end
        else
        begin
          repeat
            lengthstr:=lengthstr+1;
          until
            Textstr2[lengthstr] in alf2;
          mass[1,i]:=UpCase(Textstr2[lengthstr]);
          lengthstr:=lengthstr+1;
        end;
      end;

      //���������� ������� ��������� �����
      for i := 1 to lengthkey do
      begin
        mass[2,i]:=mass4[i];
      end;

      //����������� ������ � ��������� ����������� ������� ��������� ������������������� ����� � ��������� ��������������� ������
      k:=lengthkey+1;
      for i:=1 to size do
      begin
        if mass[1][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[1][i] then
            begin
              tmp1:=j;
            end;
          end;
        end;

        if mass[2][i] in max then
        begin
          for j:=1 to 33 do
          begin
            if mass3[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end
        else
        begin
          for j:=1 to 33 do
          begin
            if mass2[j]=mass[2][i] then
            begin
              tmp2:=j;
            end;
          end;
        end;


        tmp:=(tmp1-tmp2+34)mod 33;

        if tmp=0 then
        begin
          tmp:=33;
        end;

        if mass[1][i] in max then
        begin
          mass[3][i]:=mass3[tmp];
          mass[2,k]:=mass3[tmp];
          k:=k+1;
        end
        else
        begin
          mass[3][i]:=mass3[tmp];
          mass[2,k]:=mass3[tmp];
          k:=k+1;
        end;
      end;

      //����� ��������������� ������ � ����
      Rewrite(File2);
      for i:= 1 to size do
      begin
        write(File2,UpCase(mass[3][i]));
      end;

      Reset(File2);
      Readln(File2,Str);

      Encrypter.ResultText.Lines.Add(str);
      CloseFile(File2);
      CloseFile(file1);
    end;
  end;
end;

//��������� ������� �� ������ "���������"
procedure TEncrypter.DoThisClick(Sender: TObject);
var
  numEncrDecr: Byte;
  TextForEncr: String;               //������� ��������� �������� � ComboBox-��
  KeyEncr: String;                //�������� ����
begin
  Encrypter.ResultText.Lines.Clear;
  Encrypter.ErrorText.Lines.Clear;
  KeyEncr:= Encrypter.KeyOfEncr.Text;
  numEncrDecr:=Encrypter.TypeOfEncr.ItemIndex;
  if UseTextFromFile.Checked=True then
  begin
    case numEncrDecr of
      0:ColEncr(keyEncr);
      1:TurnGrid(KeyEncr);
      2:VigChiper(KeyEncr);
    end;
  end
  else
  begin
    case numEncrDecr of
      0:ColEncr2(keyEncr);
      1:TurnGrid2(keyEncr);
      2:VigChiper2(keyEncr);
    end;
  end;
end;

//��������� ������� �� ������ "�������"
procedure TEncrypter.CloseBtnClick(Sender: TObject);
begin
  Encrypter.Close();
end;

//��������� ��� ����������� ��������� ���������� �����
procedure TEncrypter.FormCreate(Sender: TObject);
begin
  Encrypter.KeyOfEncr.Enabled:=False;
end;

//��������� ��������� �������� ComboBox-�
procedure TEncrypter.TypeOfEncrChange(Sender: TObject);
begin
  if (Encrypter.TypeOfEncr.ItemIndex=1) then
  begin
    Encrypter.DoThis.Enabled:=True;
    Encrypter.Decrypt.Enabled:=True;
    Encrypter.KeyOfEncr.Enabled:=False;
    Encrypter.KeyOfEncr.Text:='';
  end
  else
  begin
    Encrypter.KeyOfEncr.Enabled:=True;
    Encrypter.KeyOfEncr.Text:='';
  end;
end;

//������ ����� � ���� comboBox
procedure TEncrypter.EncrOrDecrKeyPress(Sender: TObject; var Key: Char);
begin
  key:=#0;
end;

//������ ����� � ���� comboBox
procedure TEncrypter.TypeOfEncrKeyPress(Sender: TObject; var Key: Char);
begin
  key:=#0;
end;

//��������� ��������� �������� ���� ComboBox-�
procedure TEncrypter.EncrOrDecrChange(Sender: TObject);
begin
  If (Encrypter.TypeOfEncr.ItemIndex=1) then
  begin
    Encrypter.DoThis.Enabled:=true;
    Encrypter.Decrypt.Enabled:=true;
  end;
  if (Encrypter.TypeOfEncr.ItemIndex=0) or(Encrypter.TypeOfEncr.ItemIndex=2) then
  begin
    Encrypter.KeyOfEncr.Enabled:=true;
  end;
end;




procedure TEncrypter.DecryptClick(Sender: TObject);
var
  numEncrDecr: Byte;               //������� ��������� �������� � ComboBox-��
  KeyEncr,TextForEncr: String;                //�������� ����
begin
  Encrypter.ResultText.Lines.Clear;
  Encrypter.ErrorText.Lines.Clear;
  KeyEncr:= Encrypter.KeyOfEncr.Text;
  numEncrDecr:=Encrypter.TypeOfEncr.ItemIndex;
  if UseTextFromFile.Checked=True then
  begin
    case numEncrDecr of
      0:ColEncr4(keyEncr);
      1:TurnGrid4(KeyEncr);
      2:VigChiper4(KeyEncr);
    end;
  end
  else
  begin
    case numEncrDecr of
      0:ColEncr3(keyEncr);
      1:TurnGrid3(keyEncr);
      2:VigChiper3(keyEncr);
    end;
  end;
end;

procedure TEncrypter.UseTextFromFileClick(Sender: TObject);
begin
  if Encrypter.UseTextFromFile.Checked=True then
  begin
    Encrypter.UseTextFromFile.Checked:=False;
  end
  else
  begin
    Encrypter.UseTextFromFile.Checked:=True;
  end;
end;

end.
