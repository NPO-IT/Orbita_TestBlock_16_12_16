unit TLMUnit;

interface

uses
  Classes,DateUtils,LibUnit,SysUtils,Dialogs,OutUnit;


type
  Ttlm = class(TObject)
    //���� ���
    //PtlmFile:file of byte;
    //���������� ��� ������ � ������ ���
    PtlmFile: file;
    //��� ��������� ����� ��� �����
    fileName: string;
    //����� �������� ����� tlm � ������� unixtime
    msTime: cardinal;
    //����� ������������� �����
    blockNumInfile: Cardinal;
    //�����. ���� � �����
    wordNumInBlock: Cardinal;
    //����� � ������� ������� ������
    timeBlock: cardinal;
    //������1
    rez: cardinal;
    //������� �����
    prKPSEV: cardinal;
    //�������� ������� ����
    nowTime: TDateTime;
    //�
    hour: byte;
    //�
    minute: byte;
    //���
    sec: byte;
    //mc
    mSec: word;
    //mcs
    mcSec: byte;
    //������2
    rez1M08_04_02_01:word;
    rez1M16: byte;
    //���� ��������
    prSEV: byte;
    error: byte;
    //������3
    rez2: cardinal;
    //��� ������� � ��������� ������ � ���
    flagWriteTLM: boolean;

    //�������� ������ ��������� � ������� ������ � ���
    tlmHeadByteArray: array of byte;
    iTlmHeadByteArray: integer;

    //�������� ������ ��������� � ������� ������ � ���
    tlmBlockByteArray: array of byte;
    iTlmBlockByteArray: integer;

    //���� ������ ������� �����
    flagFirstWrite: boolean;
    //���� ��� �������� �����
    flagEndWrite: boolean;
    //������� ��� ��������� ���� � 1 ��
    iOneGC: integer;
    //���������� ��������� ���� � ���� ���
    countWriteByteInFile: int64;
    //���. �������� ������ �����. ����.
    precision: integer;
    stream: TFileStream;
    //���������� ������ ���. �� 1 ������
    tlmPlaySpeed: integer;
    //���� ������������� ��� ����������� ���������� �������
    fFlag: boolean;
    //���� ��� ����������� ����� ������ � ��� ��� ������������� ��
    tlmBFlag: boolean;
    //���������� ���� � ����� ���  � ����������� �� ���������������
    sizeBlock: integer;
    //�������� ������ �����
    //blockOrbArr: array  of byte;
    //�������� ������� ����� � ����������� �� ���������������
    arr1: array[0..131103] of byte;
    arr2: array[0..65567] of byte;
    arr3: array[0..32799] of byte;
    arr4: array[0..16415] of byte;
    arr5: array[0..8223] of byte;

    lastTimeBlock:Cardinal;
    testD:Cardinal;

    //������ �������� ��������� �����. ������. ������
    procedure WriteToFile(str: string); overload;
    //������ ������� �������� � ��������� ����� ���
    procedure WriteToFile(nullVal: byte); overload;
    //������ �������� ��������� � ������. ����. ������
    procedure WriteByteToByte(multiByteValue: cardinal); overload;
    procedure WriteByteToByte(multiByteValue: word); overload;
    procedure WriteByteToByte(multiByteValue: byte); overload;
    //����� �� ����� ���������� ��������� � ���� �����
    procedure OutTLMfileSize(numWriteByteInFile: int64; var numValBefore: integer);
    //������ ���������
    procedure WriteTLMhead;
    //������ ����� M16
    procedure WriteTLMBlockM16(msStartFile: cardinal);
    //������ ����� M08_04_02_01
    procedure WriteTLMBlockM08_04_02_01(msStartFile: cardinal);
    //������ ����� ������ � ������� ���. M16
    procedure WriteCircleM16;
    //������ ����� ������ � ������� ���. M08_04_02_01
    procedure WriteCircleM08_04_02_01;
    //���. ���� �������
    constructor CreateTLM;
    //������ ������ � ���
    procedure StartWriteTLM;
    //����� �������� �����
    procedure OutFileName;
    //���������� � ������ � ��� ������
    procedure BeginWork;
    //������ ����������� ���������� ������ ���. �����
    procedure ParseBlock(countBlock: word);
    //���� ������� ������
    procedure CollectOrbGroup;
    //���� ������� �����
    procedure CollectBlockTime;
    function ConvTimeToStr(t: cardinal): string;
  end;

implementation

uses
  OrbitaAll;
//==============================================================================
//������� �� ������ � ������ ���
//==============================================================================

//=============================================================================
//
//=============================================================================
constructor Ttlm.CreateTLM;
begin
  //��������� ����������� ����� � ����� ��� � ���������� �� ���������������
  case infNum of
    //M16
    0:
    begin
      sizeBlock := 131104;
    end;
    //M08
    1:
    begin
      sizeBlock := 65568;
    end;
    //M04
    2:
    begin
      sizeBlock := 32800;
    end;
    //M02
    3:
    begin
      sizeBlock := 16416;
    end;
    //M01
    4:
    begin
      sizeBlock := 8224;
    end;
  end;

  //�� ��������� ����� � ���
  tlmBFlag := true;
  //���������� ������ �� ������
  tlmPlaySpeed := 4;
  //��� ����. ������ � ���� ��� ���
  flagWriteTLM := false;

  msTime:=0;
  msTimeF:=0.0;

  //!!
  lastTimeBlock:=0;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.StartWriteTLM;
var
  j: integer;
  strLen:integer;
begin
  //get time in ms
  msTime := DateTimeToUnix(Time) * 1000;
  //create file name
  case infNum of
    //M16
    0:
      begin
        fileName := 'M16_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.tlm';
      end;
    //M08
    1:
      begin
        fileName := 'M08_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.tlm';
      end;
    //M04
    2:
      begin
        fileName := 'M04_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.tlm';
      end;
    //M02
    3:
      begin
        fileName := 'M02_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.tlm';
      end;
    //M01
    4:
      begin
        fileName := 'M01_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.tlm';
      end;
  end;
  strLen:=length(fileName);
  for j := 1 to strLen do
  begin
    if (fileName[j] = ':') then
    begin
      fileName[j] := '.';
    end;
  end;

  //set begin value of count write byte
  countWriteByteInFile := 0;
  //set begin out precision
  precision := 0;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteToFile(str: string);
var
  i: integer;
  simbInByte: byte;
  strLen:Integer;
begin
  strLen:=length(str);
  for i := 1 to strLen do
  begin
    simbInByte := ord(str[i]);
    SetLength(tlmHeadByteArray, iTlmHeadByteArray + 1);
    tlmHeadByteArray[iTlmHeadByteArray] := simbInByte and 255;
    inc(iTlmHeadByteArray);
    //write(PtlmFile,simbInByte);
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteToFile(nullVal: byte);
var
  j: integer;
begin
  //������� �� ���. ���� ���������� ����������
  for j := 1 to SizeOf(nullVal) do
  begin
    SetLength(tlmHeadByteArray, iTlmHeadByteArray + 1);
    tlmHeadByteArray[iTlmHeadByteArray] := nullVal and 255;
    inc(iTlmHeadByteArray);
    //���������� �� ����� �������� ����� �������
    nullVal := nullVal shr 8 {(j*8)};
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
//for cardinal value

procedure Ttlm.WriteByteToByte(multiByteValue: cardinal);
var
  j: integer;
begin
  //������� �� ���. ���� ���������� ����������
  for j := 1 to SizeOf(multiByteValue) do
  begin
    SetLength(tlmBlockByteArray, iTlmBlockByteArray + 1);
    tlmBlockByteArray[iTlmBlockByteArray] := multiByteValue and 255;
    inc(iTlmBlockByteArray);
    //���������� �� ����� �������� ����� �������
    multiByteValue := multiByteValue shr 8 {(j*8)};
  end;
end;

//for word value

procedure Ttlm.WriteByteToByte(multiByteValue: word);
var
  j: integer;
begin
  //������� �� ���. ���� ���������� ����������
  for j := 1 to SizeOf(multiByteValue) do
  begin
    //write(PtlmFile,multiByteValue);
    SetLength(tlmBlockByteArray, iTlmBlockByteArray + 1);
    tlmBlockByteArray[iTlmBlockByteArray] := multiByteValue and 255;
    inc(iTlmBlockByteArray);
    //���������� �� ����� �������� ����� �������
    multiByteValue := multiByteValue shr 8 {(j*8)};
  end;
end;

//for byte value

procedure Ttlm.WriteByteToByte(multiByteValue: byte);
var
  j: integer;
begin
  //������� �� ���. ���� ���������� ����������
  for j := 1 to SizeOf(multiByteValue) do
  begin
    //write(PtlmFile,multiByteValue);
    SetLength(tlmBlockByteArray, iTlmBlockByteArray + 1);
    tlmBlockByteArray[iTlmBlockByteArray] := multiByteValue and 255;
    inc(iTlmBlockByteArray);
    //���������� �� ����� �������� ����� �������
    multiByteValue := multiByteValue shr 8 {(j*8)};
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteCircleM16;
var
  i: integer;
begin
  for i := 1 to masCircleSize do
  begin
    //12 ��������� ����� ������ + ��� 1��+�� �����+����� ����������+
    //+��. ������ ����� . M8 65535 ���� 32768 ���� ������
    if i = 1{0} then
    begin
      //��������� ��� ��� ������ ����� � ������������� ��� ������ �����
      //� 1 �����
     //16 ��� � 1. ������ �����
    { data.masCircle[data.reqArrayOfCircle][i]:=
       data.masCircle[data.reqArrayOfCircle][i] or 32768;}
    end;
    if iOneGC = 4 then
    begin
      //13 ��� � 1. ����� 1 ��
      masCircle[{data.}reqArrayOfCircle][i] :=masCircle[{data.}reqArrayOfCircle][i] or 4096;
      iOneGC := 1;
    end;

    //������ 16 ������� �������� �������� � ��������
    WriteByteToByte(masCircle[{data.}reqArrayOfCircle][i]);
  end;
  inc(iOneGC);
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteCircleM08_04_02_01;
var
  i: integer;
begin
  for i := 1 to {length(masCircle[data.reqArrayOfCircle])}masCircleSize {- 1} do
  begin
    //12 ��������� ����� ������ + ��� 1��+�� �����+����� ����������+
    //+��. ������ ����� . M8 65535 ���� 32768 ���� ������
    if i = 1{0} then
    begin
      //��������� ��� ��� ������ ����� � ������������� ��� ������ �����
      //� 1 �����
     //16 ��� � 1. ������ �����
      {masCircle[data.reqArrayOfCircle][i] :=     ///!!!!! �������� �������
        masCircle[data.reqArrayOfCircle][i] or 32768;}
    end;
    if iOneGC = 4 then
    begin
      //12 ��� � 1. ����� 1 ��
      masCircle[{data.}reqArrayOfCircle][i] :=
        masCircle[{data.}reqArrayOfCircle][i] or 4096;
      iOneGC := 1;
    end;

    //������ 16 ������� �������� �������� � ��������
    WriteByteToByte(masCircle[{data.}reqArrayOfCircle][i]);
  end;
  inc(iOneGC);
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteTLMhead;
var
  str: string;
  //count write byte
  byteCount: integer;
  i: integer;
begin
  //������� ���������� ���� ���������
  iTlmHeadByteArray := 0;
  //Head//
  //dev name
  WriteToFile('Complex=');
  WriteToFile('MERATMS-M.SYSTEM=ORBITAIV.');
  //data
  WriteToFile('DATA=');
  DateTimeToString(str, 'yyyy:mm:dd.', Date);
  WriteToFile(str);
  //time
  WriteToFile('TIME=');
  DateTimeToString(str, 'hh:mm:sszzz.', Time);
  WriteToFile(str);
  //
  WriteToFile('OBJ=');
  WriteToFile('TMS-M.');
  //
  WriteToFile('SEANS=');
  WriteToFile('.');
  //
  WriteToFile('RC=');
  WriteToFile('LOC.');
  //
  WriteToFile('MODE=');
  WriteToFile('WORK.');
  //
  WriteToFile('T_INP=');
  WriteToFile('INT.');
  //
  WriteToFile('INF=');
  case infNum of
    //M16
    0:
      begin
        WriteToFile('16' + '.');
      end;
    //M08
    1:
      begin
        WriteToFile('8' + '.');
      end;
    //M04
    2:
      begin
        WriteToFile('4' + '.');
      end;
    //M02
    3:
      begin
        WriteToFile('2' + '.');
      end;
    //M01
    4:
      begin
        WriteToFile('1' + '.');
      end;
  end;

  //
  WriteToFile('INP=');
  WriteToFile('RADIO.');
  //
  WriteToFile('FREQ=');
  WriteToFile('2299400.');
  //
  WriteToFile('PPU=');
  WriteToFile('AUTO.');
  //
  WriteToFile('REF=');
  WriteToFile('.');
  //
  WriteToFile('TO=');
  WriteToFile('0.0S');
  //max head size 256 byte
  byteCount := length(tlmHeadByteArray);
  //write 0 value to end
  for i := byteCount + 1 to MAXHEADSIZE do
  begin
    WriteToFile(0);
  end;

  //��������� ���� �� ������ ����� ����
  AssignFile(PtlmFile, ExtractFileDir(ParamStr(0)) + '/Report/' + fileName);
  //��� ������ 1 �����, ���� ����� ������ ��������� ������
  ReWrite(PtlmFile, 1);
  //������� � ���� ���������� ���. ������ ��������*������ ������ �������� � ������
  BlockWrite(PtlmFile, tlmHeadByteArray[0], length(tlmHeadByteArray) * sizeOf(byte)); //!!!
  //���������� ���������� ���������� � ���� �a��
  countWriteByteInFile := length(tlmHeadByteArray);
  closeFile(PtlmFile);

  //���. ����. ������ �����. ����� . � ������
  blockNumInfile := 1;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.OutFileName;
var
  i: integer;
  str: string;
  bool: boolean;
  strLen:Integer;
begin
  str := '';
  bool := false;
  if form1.OpenDialog1.Execute then
  begin
    strLen:=length(form1.OpenDialog1.FileName);
    for i := 1 to strLen  do
    begin
      if (((form1.OpenDialog1.FileName[i] = 'M') and
        (form1.OpenDialog1.FileName[i + 1] = '1') and
        (form1.OpenDialog1.FileName[i + 2] = '6') and
        (form1.OpenDialog1.FileName[i + 3] = '_')) or
        ((form1.OpenDialog1.FileName[i] = 'M') and
        (form1.OpenDialog1.FileName[i + 1] = '0') and
        (form1.OpenDialog1.FileName[i + 2] = '8') and
        (form1.OpenDialog1.FileName[i + 3] = '_')) or
        ((form1.OpenDialog1.FileName[i] = 'M') and
        (form1.OpenDialog1.FileName[i + 1] = '0') and
        (form1.OpenDialog1.FileName[i + 2] = '4') and
        (form1.OpenDialog1.FileName[i + 3] = '_')) or
        ((form1.OpenDialog1.FileName[i] = 'M') and
        (form1.OpenDialog1.FileName[i + 1] = '0') and
        (form1.OpenDialog1.FileName[i + 2] = '2') and
        (form1.OpenDialog1.FileName[i + 3] = '_')) or
        ((form1.OpenDialog1.FileName[i] = 'M') and
        (form1.OpenDialog1.FileName[i + 1] = '0') and
        (form1.OpenDialog1.FileName[i + 2] = '1') and
        (form1.OpenDialog1.FileName[i + 3] = '_'))) then
      begin
        bool := true;
      end;

      if (bool) then
      begin
        str := str + form1.OpenDialog1.FileName[i];
      end;
    end;
    form1.fileNameLabel.Caption := str;
    //� ������ ���� ���� ������� �������
    //������������ ���� ���
    tlm.BeginWork;
    //��� ���������� ������������ �����  ����� ������
    tlm.fFlag := true;
    //1 �������
    form1.startReadTlmB.Enabled := not form1.startReadTlmB.Enabled;
    form1.propB.Enabled := false;
    form1.TrackBar1.Enabled := true;
    //������ ��������� �������������
    form1.PanelPlayer.Enabled := true;
  end
  else
  begin
    showMessage('�� ������� ������� ����!');
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.OutTLMfileSize(numWriteByteInFile: int64; var numValBefore: integer);
var
  valInMB: double;
begin
  valInMB := numWriteByteInFile / 1024 / 1024;
  if (trunc(valInMB) mod 10) = 0 then
  begin
    inc(numValBefore);
  end;
  //form1.tlmWriteB.Caption := '';
  //������� ������ ����� � MByte. 1 ���� �� ������� � 2 �����.
  if cOut=7 then
  begin
    form1.tlmWriteB.Caption := '';
  end;
  if cOut=10 then
  begin
    //csk.Enter;
    form1.tlmWriteB.Caption := floatToStrF(valInMB, ffFixed, numValBefore, 2) + ' Mb';
    cOut:=0;
    //csk.Leave;
  end;
  inc(cOut);

  //sleep(5);
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteTLMBlockM16(msStartFile: cardinal);
begin
  //block
  wordNumInBlock := {length(masCircle[data.reqArrayOfCircle])}masCircleSize;
  rez := 0;
  mcSec := 0;
  prSEV := 0;
  error := 0;
  rez1M16 := 0;
  rez2 := 0;
  prKPSEV := high(prKPSEV);
  //������� ���������� ���� �����
  iTlmBlockByteArray := 0;
  //pref
  //block num (4b)
  WriteByteToByte(blockNumInfile);
  //word in block (4b)
  WriteByteToByte(wordNumInBlock);
  //time in mc (4b)
  //timeBlock := (DateTimeToUnix(Time) * 1000) - msStartFile;
  //time in mc (4b)
  if blockNumInfile<>1 then
  begin
    lastTimeBlock:=timeBlock;
  end; 

  //timeBlock := (timeInt64{ * 1000}) - msStartFile;
  msTime:=Trunc(msTimeF);
  timeBlock:=msTime;

  WriteByteToByte(timeBlock);

  //����� ���� ��� ������ ������ ���� �������� ������ ������� ����� ������
  flagStartWriteTime:=True;

  {2 ���� �� 4 �����(8b)}
  //4b
  //rez
  WriteByteToByte(rez);
  //rez
  //WriteByteToByte(rez);
  //kpSev  4b
  WriteByteToByte(prKPSEV);
  //calend
  nowTime := Now;
  //h  (1b)
  hour := HourOf(nowTime);
  WriteByteToByte(hour);
  //m  (1b)
  minute := MinuteOf(nowTime);
  WriteByteToByte(minute);
  //s  (1b)
  sec := SecondOf(nowTime);
  WriteByteToByte(sec);
  //ms (2b)
  mSec := MilliSecondOf(nowTime);
  WriteByteToByte(mSec);
  //mcs
  //mSec:=MilliSecondOf(nowTime);
  //WriteByteToByte(mcSec);
  {rez1 (2b)}
  //1b
  WriteByteToByte(rez1M16);
  //pr SEV. 1b
  WriteByteToByte(prSEV);
  //error (1b)
  WriteByteToByte(error);
  //rez2  (4b)
  WriteByteToByte(rez2);
  //write circle in tlm
  WriteCircleM16;

  //IntToStr(GetFileSizeInMByte(ExtractFileDir(ParamStr(0))+'/Report/'+fileName));

  if (flagFirstWrite) then
  begin
    AssignFile(PtlmFile, ExtractFileDir(ParamStr(0)) + '/Report/' + fileName);
    reset(PtlmFile, 1);
    seek(PtlmFile, length(tlmHeadByteArray));
    flagFirstWrite := false;
  end;
  //���� ���� ������ ������ ��������� ������, �� ���������� ���� �� �����
  if (flagEndWrite) then
  begin
    //wait(100);
    //flagEndWrite:=false;
  end
  else
  begin
    //form1.Memo1.Lines.Add(intToStr(length(tlmBlockByteArray)));
    BlockWrite(PtlmFile, tlmBlockByteArray[0],
      length(tlmBlockByteArray) * sizeof(byte)); //!!!
  end;
  //���������� ���������� �����. ����
  countWriteByteInFile := countWriteByteInFile + length(tlmBlockByteArray);
  //������� ������ ����������� ����� � ������
  OutTLMfileSize(countWriteByteInFile, precision);

  tlmBlockByteArray := nil;
  //form1.Memo1.Lines.Add(intToStr(iTlmBlockByteArray));
  iTlmBlockByteArray := 0;

  //��� ��������
  {if blockNumInfile=4 then
  begin
    closeFile(tlm.PtlmFile);
    inc(blockNumInfile);
  end; }

  inc(blockNumInfile);
  if blockNumInfile >= High(blockNumInfile) then
  begin
    blockNumInfile := 1;
  end;
  //form1.Memo1.Lines.Add(intToStr(blockNumInfile));

end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.WriteTLMBlockM08_04_02_01(msStartFile: cardinal);
begin
  //block
  wordNumInBlock := {length(masCircle[data.reqArrayOfCircle])}masCircleSize;
  rez := 0;
  mcSec := 0;
  prSEV := 0;
  error := 0;
  rez1M08_04_02_01 := 0;
  rez2 := 0;
  //������� ���������� ���� �����
  iTlmBlockByteArray := 0;
  //pref
  //block num (4b)
  WriteByteToByte(blockNumInfile);
  //word in block (4b)
  WriteByteToByte(wordNumInBlock);
  //time in mc (4b)
  //timeBlock := (DateTimeToUnix(Time) * 1000) - msStartFile;

  if blockNumInfile<>1 then
  begin
    lastTimeBlock:=timeBlock;
  end;


  //timeBlock := (timeInt64{ * 1000}) - msStartFile;
  msTime:=Trunc(msTimeF);
  timeBlock:=msTime;

  WriteByteToByte(timeBlock);
  //����� ���� ��� ������ ������ ���� �������� ������ ������� ����� ������
  flagStartWriteTime:=True;
  
  //2 ���� �� 4 �����(8b)
  //rez
  WriteByteToByte(rez);
  //rez
  WriteByteToByte(rez);
  //calend
  nowTime := Now;
  //h  (1b)
  hour := HourOf(nowTime);
  WriteByteToByte(hour);
  //m  (1b)
  minute := MinuteOf(nowTime);
  WriteByteToByte(minute);
  //s  (1b)
  sec := SecondOf(nowTime);
  WriteByteToByte(sec);
  //ms (2b)
  mSec := MilliSecondOf(nowTime);
  WriteByteToByte(mSec);
  //mcs
  //mSec:=MilliSecondOf(nowTime);
  //WriteByteToByte(mcSec);
  //rez1 (2b)
  WriteByteToByte(rez1M08_04_02_01);
  //pr SEV
  //WriteByteToByte(prSEV);
  //error (1b)
  WriteByteToByte(error);
  //rez2  (4b)
  WriteByteToByte(rez2);
  //write circle in tlm
  WriteCircleM08_04_02_01;

  if (flagFirstWrite) then
  begin
    AssignFile(PtlmFile, ExtractFileDir(ParamStr(0)) + '/Report/' + fileName);
    reset(PtlmFile, 1);
    seek(PtlmFile, length(tlmHeadByteArray));
    flagFirstWrite := false;
  end;
  //���� ���� ������ ������ ��������� ������, �� ���������� ���� �� �����
  if (flagEndWrite) then
  begin
    //wait(100);
    //flagEndWrite:=false;
  end
  else
  begin
    //form1.Memo1.Lines.Add(intToStr(length(tlmBlockByteArray)));
    BlockWrite(PtlmFile, tlmBlockByteArray[0],
      length(tlmBlockByteArray) * sizeof(byte)); //!!!
  end;

  //���������� ���������� �����. ����
  countWriteByteInFile := countWriteByteInFile + length(tlmBlockByteArray);
  //������� ������ ����������� ����� � ������
  OutTLMfileSize(countWriteByteInFile, precision);

  tlmBlockByteArray := nil;
  //form1.Memo1.Lines.Add(intToStr(iTlmBlockByteArray));
  iTlmBlockByteArray := 0;

  //��� ��������
  {if blockNumInfile=4 then
    begin
      closeFile(tlm.PtlmFile);
      inc(blockNumInfile);
    end; }

  inc(blockNumInfile);
  if blockNumInfile >= High(blockNumInfile) then
    blockNumInfile := 1;
  //form1.Memo1.Lines.Add(intToStr(blockNumInfile));

end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.BeginWork;
begin
  //�������� ����� �� ������
  stream := TFileStream.Create(form1.OpenDialog1.FileName, fmOpenRead);
  //1 ���� �16 131104 �����
  form1.TrackBar1.Max := round((stream.Size - MAXHEADSIZE) / SIZEBLOCK);
  //��������� � ����� �� ������ ���������
  stream.Seek(MAXHEADSIZE, soFromCurrent);
  //��������� �� ������ ����� �� ������ ��������
  //stream.Seek(SIZEBLOCKPREF,soFromCurrent);
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.CollectOrbGroup;
begin
  //showMessage('!! '+intToStr(iMasGroup)+' '+intToStr(iBlock));
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

procedure Ttlm.CollectBlockTime;
{var
  time: cardinal;
  iT: integer;
  str: string;}
begin
  {iT := 11;
  time := blockOrbArr[iT];
  dec(iT);
  while iT >= 8 do
  begin
    time := (time shl 8) + blockOrbArr[iT];
    dec(iT);
  end;
  DateTimeToString(str, 'hh:mm:ss', UnixToDateTime(time));
  form1.orbTimeLabel.Caption := str;}
end;
//==============================================================================

function Ttlm.ConvTimeToStr(t: cardinal): string;
var
  h: integer;
  m: integer;
  s: integer;
  str: string;
begin
  s := round(t / 1000);
  if s > 59 then
  begin
    if s > 3600 then
    begin
      //����
      h := trunc(s / 3600);
      m := trunc(s / 60);
      s := s mod 3600;
      if s > 9 then
      begin
        if m > 9 then
        begin
          if h > 9 then
          begin
            str := intToStr(h) + ':' + intToStr(m) + ':' + intToStr(s);
          end
          else
          begin
            str := '0' + intToStr(h) + ':' + intToStr(m) + ':' + intToStr(s);
          end;
        end
        else
        begin
          if h > 9 then
          begin
            str := intToStr(h) + ':' + '0' + intToStr(m) + ':' + intToStr(s);
          end
          else
          begin
            str := '0' + intToStr(h) + ':' + '0' + intToStr(m) + ':' + intToStr(s);
          end;
        end;
      end
      else
      begin
        if m > 9 then
        begin
          if h > 9 then
          begin
            str := intToStr(h) + ':' + intToStr(m) + ':' + '0' + intToStr(s);
          end
          else
          begin
            str := '0' + intToStr(h) + ':' + intToStr(m) + ':' + '0' + intToStr(s);
          end;
        end
        else
        begin
          if h > 9 then
          begin
            str := intToStr(h) + ':' + '0' + intToStr(m) + ':' + '0' + intToStr(s);
          end
          else
          begin
            str := '0' + intToStr(h) + ':' + '0' + intToStr(m) + ':' + '0' + intToStr(s);
          end;
        end;
      end;
    end
    else
    begin
      //���.
      h := 0;
      m := trunc(s / 60);
      s := s mod 60;
      if s > 9 then
      begin
        if m > 9 then
        begin
          str := '0' + intToStr(h) + ':' + intToStr(m) + ':' + intToStr(s);
        end
        else
        begin
          str := '0' + intToStr(h) + ':' + '0' + intToStr(m) + ':' + intToStr(s);
        end;
      end
      else
      begin
        if m > 9 then
        begin
          str := '0' + intToStr(h) + ':' + intToStr(m) + ':' + '0' + intToStr(s);
        end
        else
        begin
          str := '0' + intToStr(h) + ':' + '0' + intToStr(m) + ':' + '0' + intToStr(s);
        end;
      end;
    end;
  end
  else
  begin
    //���
    s := round(t / 1000);
    m := 0;
    h := 0;
    if s > 9 then
    begin
      str := '0' + intToStr(h) + ':' + '0' + intToStr(m) + ':' + intToStr(s);
    end
    else
    begin
      str := '0' + intToStr(h) + ':' + '0' + intToStr(m) + ':' + '0' + intToStr(s);
    end;
  end;
  result := str;
end;

//==============================================================================
//
//==============================================================================

procedure Ttlm.ParseBlock(countBlock: word);
var
  //������� �������� ������(������)
  i, jG: integer;
  iMasGroupPars: integer;
  time: cardinal;
  iT: integer;
  str: string;
  arrLength:Integer;
begin
  //form1.Memo1.Lines.Add(intToStr(countBlock));
  i := 1;
  //��������� � ������� ���� �� ������. ��� ������ ��������������� ���� ����������� ������
  while i <= countBlock do
  begin
    try
      //������� ��� ����� �������
      iT := 11;
      case infNum of
        //M16
        0:
        begin
          //������ �� ����� ���� � ���������, ����� ������� �������
          stream.Read(arr1, sizeof(arr1));
          //CollectBlockTime;

          time := arr1[iT];
          dec(iT);
          while iT >= 8 do
          begin
            time := (time shl 8) + arr1[iT];
            dec(iT);
          end;
          //DateTimeToString(str,'hh:mm:ss',
            //StrToDateTime(intToStr(round(time/1000))));
          str := ConvTimeToStr(time);
          form1.orbTimeLabel.Caption := str; {intToStr(h)+':'+
            intToStr(m)+':'+intToStr(s)}
          //intToStr(round(time/1000));
          //���������� �� ������ ����� �� ������ ��������
          jG := SIZEBLOCKPREF; {+1} //!!!!!

          arrLength:=length(arr1);
          //��������� ���� �� ������ � ������� ��������� �� ������
          while jG <=arrLength  - 1 do
          begin
            //�������� ������ ������
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize do
            begin
              //�������� 11 ��������� �������� ��� ������
              masGroup[iMasGroupPars] := ((arr1[jG + 1] shl 8) +
              arr1[jG]) and 2047;
              //�������� 12 ��������� �������� ��� ����� ������� �������
              masGroupAll[iMasGroupPars] := ((arr1[jG + 1] shl 8) +
              arr1[jG]) and 4095;
              jG := jG + 2;
            end;
            //������� ������
            //����������� ����� �� ���������

            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //���� ������� ������� ������������� ����������
              //�� �� ����������� ������� ��� �����
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;

            //���������� ��� �������� �������
    {case form1.PageControl1.ActivePageIndex  of
      0:
      begin
        //���������� � ����������
        if ((not vSlowFlag)and(not vContFlag)) then
        begin
          //����� �� �������
          form1.TimerOutToDia.Enabled := true;
        end;

        if ((not vSlowFlag)and(vContFlag)) then
        begin
          //����� �� ������� ���������
          form1.TimerOutToDia.Enabled := true;
          //����� ���� ����� ����������
          outToDiaCGeneral;
        end;

        if ((vSlowFlag)and(not vContFlag)) then
        begin
          outToDiaSGeneral;
          //����� �� ������� ����������
          form1.tmrCont.Enabled := true;
        end;

        if ((vSlowFlag)and(vContFlag)) then
        begin
          //����� ��������� ��� �����
          outToDiaSGeneral;
          //����� ���������� ��� �����
          outToDiaCGeneral;
        end;
      end;
      1:
      begin
        //�������
        //����� �� �������
        form1.TimerOutToDia.Enabled := true;
      end;
      2:
      begin
         //�������������
        //���� ������� ������� ������������� ����������
        //�� �� ����������� ������� ��� �����
        data.outToDiaTGeneral;
        //��� {�������� � �� ������������}
      {end;
      3:
      begin
        //��� {�������� � �� ������������
      end;
      4:
      begin
        //�������������
        //���� ������� ������� ������������� ����������
        //�� �� ����������� ������� ��� �����
        data.outToDiaTGeneral;
      end;
    end; }

            //����� �� �������. ����� ���������.
            {data.}OutToGistGeneral;

            //������������ �������� �� ���� ������
            inc({data.}groupNum);//!!!
            if {data.}groupNum=33 then
            begin
              {data.}groupNum:=1;
            end;
          end;
        end;
        //M08
        1:
        begin
          //������ �� ����� ���� ��� ����� ��������
          stream.Read(arr2, sizeof(arr2));
          //CollectBlockTime;
          time := arr2[iT];
          dec(iT);
          while iT >= 8 do
          begin
            time := (time shl 8) + arr2[iT];
            dec(iT);
          end;
          //DateTimeToString(str,'hh:mm:ss',
            //StrToDateTime(intToStr(round(time/1000))));
          str := ConvTimeToStr(time);
          form1.orbTimeLabel.Caption := str; {intToStr(h)+':'+
            intToStr(m)+':'+intToStr(s)}
          //intToStr(round(time/1000));
          //���������� �� ������ ����� �� ������ ��������
          jG := SIZEBLOCKPREF; {+1} //!!!!!

          arrLength:=length(arr2);
          //��������� ���� �� ������ � ������� �������� �� ������
          while jG <= arrLength - 1 do
          begin
            //�������� ������ ������
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize do
            begin
              //�������� 11 ��������� �������� ��� ������
              masGroup[iMasGroupPars] := ((arr2[jG + 1] shl 8) +
              arr2[jG]) and 2047;
              //�������� 12 ��������� �������� ��� ����� ������� �������
              masGroupAll[iMasGroupPars] := ((arr2[jG + 1] shl 8) +
              arr2[jG]) and 4095;
              jG := jG + 2;
            end;
            //������� ����������� ����� �� ���������
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //���� ������� ������� ������������� ����������
              //�� �� ����������� ������� ��� �����
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //����� �� �������. ����� ���������.
            {data.}OutToGistGeneral;

            //������������ �������� �� ���� ������
            inc({data.}groupNum);//!!!
            if {data.}groupNum=33 then
            begin
              {data.}groupNum:=1;
            end;
          end;
         end;
        //M04
        2:
        begin
          //������ �� ����� ���� ��� ����� ��������
          stream.Read(arr3, sizeof(arr3));
          //CollectBlockTime;
          time := arr3[iT];
          dec(iT);
          while iT >= 8 do
          begin
            time := (time shl 8) + arr3[iT];
            dec(iT);
          end;
          //DateTimeToString(str,'hh:mm:ss',
            //StrToDateTime(intToStr(round(time/1000))));
          str := ConvTimeToStr(time);
          form1.orbTimeLabel.Caption := str; {intToStr(h)+':'+
            intToStr(m)+':'+intToStr(s)}
          //intToStr(round(time/1000));
          //���������� �� ������ ����� �� ������ ��������
          jG := SIZEBLOCKPREF; {+1} //!!!!!
          arrLength:=length(arr3);
          //��������� ���� �� ������ � ������� �������� �� ������
          while jG <= arrLength - 1 do
          begin
            //�������� ������ ������
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize  do
            begin
              //�������� 11 ��������� �������� ��� ������
              masGroup[iMasGroupPars] := ((arr3[jG + 1] shl 8) +
              arr3[jG]) and 2047;
              //�������� 12 ��������� �������� ��� ����� ������� �������
              masGroupAll[iMasGroupPars] := ((arr3[jG + 1] shl 8) +
              arr3[jG]) and 4095;
              jG := jG + 2;
            end;
            //������� ����������� ����� �� ���������
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //���� ������� ������� ������������� ����������
              //�� �� ����������� ������� ��� �����
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //����� �� �������. ����� ���������.
            {data.}OutToGistGeneral;

            //������������ �������� �� ���� ������
            inc({data.}groupNum);//!!!
            if {data.}groupNum=33 then
            begin
              {data.}groupNum:=1;
            end;
          end;
        end;
        //M02
        3:
        begin
          //������ �� ����� ���� ��� ����� ��������
          stream.Read(arr4, sizeof(arr4));
          //CollectBlockTime;
          time := arr4[iT];
          dec(iT);
          while iT >= 8 do
          begin
            time := (time shl 8) + arr4[iT];
            dec(iT);
          end;
          //DateTimeToString(str,'hh:mm:ss',
            //StrToDateTime(intToStr(round(time/1000))));
          str := ConvTimeToStr(time);
          form1.orbTimeLabel.Caption := str; {intToStr(h)+':'+
            intToStr(m)+':'+intToStr(s)}
          //intToStr(round(time/1000));
          //���������� �� ������ ����� �� ������ ��������
          jG := SIZEBLOCKPREF; {+1} //!!!!!
          arrLength:=length(arr4);
          //��������� ���� �� ������ � ������� �������� �� ������
          while jG <=arrLength  - 1 do
          begin
            //�������� ������ ������
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize do
            begin
              //�������� 11 ��������� �������� ��� ������
              masGroup[iMasGroupPars] := ((arr4[jG + 1] shl 8) +
              arr4[jG]) and 2047;
              //�������� 12 ��������� �������� ��� ����� ������� �������
              masGroupAll[iMasGroupPars] := ((arr4[jG + 1] shl 8) +
              arr4[jG]) and 4095;
              jG := jG + 2;
            end;
            //������� ����������� ����� �� ���������
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //���� ������� ������� ������������� ����������
              //�� �� ����������� ������� ��� �����
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //����� �� �������. ����� ���������.
            {data.}OutToGistGeneral;

            //������������ �������� �� ���� ������
            inc({data.}groupNum);//!!!
            if {data.}groupNum=33 then
            begin
              {data.}groupNum:=1;
            end;
          end;
        end;
        //M01
        4:
        begin
          //������ �� ����� ���� ��� ����� ��������
          stream.Read(arr5, sizeof(arr5));
          //CollectBlockTime;
          time := arr5[iT];
          dec(iT);
          while iT >= 8 do
          begin
            time := (time shl 8) + arr5[iT];
            dec(iT);
          end;
          //DateTimeToString(str,'hh:mm:ss',
            //StrToDateTime(intToStr(round(time/1000))));
          str := ConvTimeToStr(time);
          form1.orbTimeLabel.Caption := str; {intToStr(h)+':'+
            intToStr(m)+':'+intToStr(s)}
          //intToStr(round(time/1000));
          //���������� �� ������ ����� �� ������ ��������
          jG := SIZEBLOCKPREF; {+1} //!!!!!
          arrLength:=length(arr5);
          //��������� ���� �� ������ � ������� �������� �� ������
          while jG <=arrLength - 1 do
          begin
            //�������� ������ ������
            //CollectOrbGroup;
            for iMasGroupPars := 1{0} to masGroupSize do
            begin
              //�������� 11 ��������� �������� ��� ������
              masGroup[iMasGroupPars] := ((arr5[jG + 1] shl 8) +
              arr5[jG]) and 2047;
              //�������� 12 ��������� �������� ��� ����� ������� �������
              masGroupAll[iMasGroupPars] := ((arr5[jG + 1] shl 8) +
              arr5[jG]) and 4095;
              jG := jG + 2;
            end;
            //������� ����������� ����� �� ���������
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //���� ������� ������� ������������� ����������
              //�� �� ����������� ������� ��� �����
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //����� �� �������. ����� ���������.
            {data.}OutToGistGeneral;

            //������������ �������� �� ���� ������
            inc({data.}groupNum);//!!!
            if {data.}groupNum=33 then
            begin
              {data.}groupNum:=1;
            end;
          end;
        end;
      end;
      //����������� ������� �� ����. ����
      Inc({data.}ciklNum); //!!!
      if {data.}ciklNum=5 then
      begin
        {data.}ciklNum:=1;
      end;


      form1.TrackBar1.Position := form1.TrackBar1.Position +form1.TrackBar1.PageSize;
    finally
      //��������� ������ ��� ����� �� �� ����� �����.
      if stream.Position >= stream.Size then
      begin
        form1.TimerPlayTlm.Enabled := false;

        if (form1.PageControl1.ActivePageIndex <> 2) then
        begin
          form1.TimerOutToDia.Enabled := false;
        end;
        i := countBlock + 1;
        form1.diaSlowAnl.Series[0].Clear;
        form1.diaSlowCont.Series[0].Clear;
        form1.fastDia.Series[0].Clear;
        form1.fastGist.Series[0].Clear;
        form1.gistSlowAnl.Series[0].Clear;
        //form1.fileNameLabel.Caption:='';
      end;
    end;
    inc(i);
    //!!
    {sleep(250);
    Application.ProcessMessages;}
  end;
end;
//==============================================================================

end.
 