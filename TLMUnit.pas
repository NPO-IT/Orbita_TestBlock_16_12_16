unit TLMUnit;

interface

uses
  Classes,DateUtils,LibUnit,SysUtils,Dialogs,OutUnit;


type
  Ttlm = class(TObject)
    //файл тлм
    //PtlmFile:file of byte;
    //переменная для работы с файлом тлм
    PtlmFile: file;
    //для генерации имени тлм файла
    fileName: string;
    //время создания файла tlm в формате unixtime
    msTime: cardinal;
    //номер записываемого блока
    blockNumInfile: Cardinal;
    //колич. слов в блоке
    wordNumInBlock: Cardinal;
    //время с момента запуска записи
    timeBlock: cardinal;
    //резерв1
    rez: cardinal;
    //признак КПСЕВ
    prKPSEV: cardinal;
    //получаем текущую дату
    nowTime: TDateTime;
    //ч
    hour: byte;
    //м
    minute: byte;
    //сек
    sec: byte;
    //mc
    mSec: word;
    //mcs
    mcSec: byte;
    //резерв2
    rez1M08_04_02_01:word;
    rez1M16: byte;
    //поле признака
    prSEV: byte;
    error: byte;
    //резерв3
    rez2: cardinal;
    //для запуска и остановки записи в тлм
    flagWriteTLM: boolean;

    //байтовый массив заголовка и счетчик работы с ним
    tlmHeadByteArray: array of byte;
    iTlmHeadByteArray: integer;

    //байтовый массив заголовка и счетчик работы с ним
    tlmBlockByteArray: array of byte;
    iTlmBlockByteArray: integer;

    //флаг записи первого блока
    flagFirstWrite: boolean;
    //флаг для дозаписи блока
    flagEndWrite: boolean;
    //счетчик для установки бита в 1 ГЦ
    iOneGC: integer;
    //количество записаных байт в файл тлм
    countWriteByteInFile: int64;
    //нач. точность вывода запис. байт.
    precision: integer;
    stream: TFileStream;
    //количество блоков обр. за 1 проход
    tlmPlaySpeed: integer;
    //флаг синхронизации для правильного выключения таймера
    fFlag: boolean;
    //флаг для определения вести запись в тлм или останавливать ее
    tlmBFlag: boolean;
    //количество байт в блоке тлм  в зависимости от информативности
    sizeBlock: integer;
    //байтовый массив блока
    //blockOrbArr: array  of byte;
    //байтовые массивы блока в зависимости от информативности
    arr1: array[0..131103] of byte;
    arr2: array[0..65567] of byte;
    arr3: array[0..32799] of byte;
    arr4: array[0..16415] of byte;
    arr5: array[0..8223] of byte;

    lastTimeBlock:Cardinal;
    testD:Cardinal;

    //запись побайтно заголовка файла. формир. буфера
    procedure WriteToFile(str: string); overload;
    //запись нулевых значений в заголовок файла ТЛМ
    procedure WriteToFile(nullVal: byte); overload;
    //запись побайтно префиксов и блоков. форм. буфера
    procedure WriteByteToByte(multiByteValue: cardinal); overload;
    procedure WriteByteToByte(multiByteValue: word); overload;
    procedure WriteByteToByte(multiByteValue: byte); overload;
    //вывод на форму количества записаных в файл Мбайт
    procedure OutTLMfileSize(numWriteByteInFile: int64; var numValBefore: integer);
    //запись заголовка
    procedure WriteTLMhead;
    //запись блока M16
    procedure WriteTLMBlockM16(msStartFile: cardinal);
    //запись блока M08_04_02_01
    procedure WriteTLMBlockM08_04_02_01(msStartFile: cardinal);
    //запись блока данных с прибора инф. M16
    procedure WriteCircleM16;
    //запись блока данных с прибора инф. M08_04_02_01
    procedure WriteCircleM08_04_02_01;
    //нач. иниц объекта
    constructor CreateTLM;
    //запуск записи в ТЛМ
    procedure StartWriteTLM;
    //вывод названия файла
    procedure OutFileName;
    //подготовка к работе с тлм файлом
    procedure BeginWork;
    //разбор переданного количества блоков Орб. файла
    procedure ParseBlock(countBlock: word);
    //сбор массива группы
    procedure CollectOrbGroup;
    //сбор времени блока
    procedure CollectBlockTime;
    function ConvTimeToStr(t: cardinal): string;
  end;

implementation

uses
  OrbitaAll;
//==============================================================================
//Функции по работе с файлом ТЛМ
//==============================================================================

//=============================================================================
//
//=============================================================================
constructor Ttlm.CreateTLM;
begin
  //установим размерность блока в файле тлм в зависимоти от информативности
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

  //по умолчанию пишем в тлм
  tlmBFlag := true;
  //количество блоков за проход
  tlmPlaySpeed := 4;
  //при иниц. записи в файл тлм нет
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
  //зависит от кол. байт переданной переменной
  for j := 1 to SizeOf(nullVal) do
  begin
    SetLength(tlmHeadByteArray, iTlmHeadByteArray + 1);
    tlmHeadByteArray[iTlmHeadByteArray] := nullVal and 255;
    inc(iTlmHeadByteArray);
    //записываем на место младшего байта старший
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
  //зависит от кол. байт переданной переменной
  for j := 1 to SizeOf(multiByteValue) do
  begin
    SetLength(tlmBlockByteArray, iTlmBlockByteArray + 1);
    tlmBlockByteArray[iTlmBlockByteArray] := multiByteValue and 255;
    inc(iTlmBlockByteArray);
    //записываем на место младшего байта старший
    multiByteValue := multiByteValue shr 8 {(j*8)};
  end;
end;

//for word value

procedure Ttlm.WriteByteToByte(multiByteValue: word);
var
  j: integer;
begin
  //зависит от кол. байт переданной переменной
  for j := 1 to SizeOf(multiByteValue) do
  begin
    //write(PtlmFile,multiByteValue);
    SetLength(tlmBlockByteArray, iTlmBlockByteArray + 1);
    tlmBlockByteArray[iTlmBlockByteArray] := multiByteValue and 255;
    inc(iTlmBlockByteArray);
    //записываем на место младшего байта старший
    multiByteValue := multiByteValue shr 8 {(j*8)};
  end;
end;

//for byte value

procedure Ttlm.WriteByteToByte(multiByteValue: byte);
var
  j: integer;
begin
  //зависит от кол. байт переданной переменной
  for j := 1 to SizeOf(multiByteValue) do
  begin
    //write(PtlmFile,multiByteValue);
    SetLength(tlmBlockByteArray, iTlmBlockByteArray + 1);
    tlmBlockByteArray[iTlmBlockByteArray] := multiByteValue and 255;
    inc(iTlmBlockByteArray);
    //записываем на место младшего байта старший
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
    //12 разрядное слово Орбиты + бит 1ГЦ+пр КПСЕВ+внутр телеметрия+
    //+пр. начала цикла . M8 65535 байт 32768 слов Орбиты
    if i = 1{0} then
    begin
      //проверяем что это начало цикла и устанавливаем бит начала цикла
      //в 1 слове
     //16 бит в 1. начало цикла
    { data.masCircle[data.reqArrayOfCircle][i]:=
       data.masCircle[data.reqArrayOfCircle][i] or 32768;}
    end;
    if iOneGC = 4 then
    begin
      //13 бит в 1. метка 1 Гц
      masCircle[{data.}reqArrayOfCircle][i] :=masCircle[{data.}reqArrayOfCircle][i] or 4096;
      iOneGC := 1;
    end;

    //запись 16 битного значения побайтно с младшего
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
    //12 разрядное слово Орбиты + бит 1ГЦ+пр КПСЕВ+внутр телеметрия+
    //+пр. начала цикла . M8 65535 байт 32768 слов Орбиты
    if i = 1{0} then
    begin
      //проверяем что это начало цикла и устанавливаем бит начала цикла
      //в 1 слове
     //16 бит в 1. начало цикла
      {masCircle[data.reqArrayOfCircle][i] :=     ///!!!!! добавлен коммент
        masCircle[data.reqArrayOfCircle][i] or 32768;}
    end;
    if iOneGC = 4 then
    begin
      //12 бит в 1. метка 1 Гц
      masCircle[{data.}reqArrayOfCircle][i] :=
        masCircle[{data.}reqArrayOfCircle][i] or 4096;
      iOneGC := 1;
    end;

    //запись 16 битного значения побайтно с младшего
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
  //счетчик записанных байт заголовка
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

  //открывыем файл на запись блока байт
  AssignFile(PtlmFile, ExtractFileDir(ParamStr(0)) + '/Report/' + fileName);
  //под запись 1 байта, если будет больше запишется больше
  ReWrite(PtlmFile, 1);
  //запишем в файл содержимое дин. буфера элементы*размер одного элемента в байтах
  BlockWrite(PtlmFile, tlmHeadByteArray[0], length(tlmHeadByteArray) * sizeOf(byte)); //!!!
  //записываем количество записанных в файл бaйт
  countWriteByteInFile := length(tlmHeadByteArray);
  closeFile(PtlmFile);

  //нач. иниц. номера запис. блока . с одного
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
    //в случае если файл открыли успешно
    //масштабируем трек бар
    tlm.BeginWork;
    //для завершения проигрывания файла  любой момент
    tlm.fFlag := true;
    //1 нажатие
    form1.startReadTlmB.Enabled := not form1.startReadTlmB.Enabled;
    form1.propB.Enabled := false;
    form1.TrackBar1.Enabled := true;
    //делаем доступным проигрыватель
    form1.PanelPlayer.Enabled := true;
  end
  else
  begin
    showMessage('Не удалось открыть файл!');
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
  //Выведем размер файла в MByte. 1 знак до запятой и 2 после.
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
  //счетчик записанных байт блока
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

  //после того как начали первый блок записали начали считать время блоков
  flagStartWriteTime:=True;

  {2 раза по 4 байта(8b)}
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
  //если была нажата кнопка окончания записи, то дописываем цикл до конца
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
  //записываем количество запис. байт
  countWriteByteInFile := countWriteByteInFile + length(tlmBlockByteArray);
  //выводим размер записанного файла в байтах
  OutTLMfileSize(countWriteByteInFile, precision);

  tlmBlockByteArray := nil;
  //form1.Memo1.Lines.Add(intToStr(iTlmBlockByteArray));
  iTlmBlockByteArray := 0;

  //для проверки
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
  //счетчик записанных байт блока
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
  //после того как начали первый блок записали начали считать время блоков
  flagStartWriteTime:=True;
  
  //2 раза по 4 байта(8b)
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
  //если была нажата кнопка окончания записи, то дописываем цикл до конца
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

  //записываем количество запис. байт
  countWriteByteInFile := countWriteByteInFile + length(tlmBlockByteArray);
  //выводим размер записанного файла в байтах
  OutTLMfileSize(countWriteByteInFile, precision);

  tlmBlockByteArray := nil;
  //form1.Memo1.Lines.Add(intToStr(iTlmBlockByteArray));
  iTlmBlockByteArray := 0;

  //для проверки
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
  //открытие файла на чтение
  stream := TFileStream.Create(form1.OpenDialog1.FileName, fmOpenRead);
  //1 блок М16 131104 байта
  form1.TrackBar1.Max := round((stream.Size - MAXHEADSIZE) / SIZEBLOCK);
  //сдвинемся в файле на размер заголовка
  stream.Seek(MAXHEADSIZE, soFromCurrent);
  //смещаемся от начала блока на размер префикса
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
      //часы
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
      //мин.
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
    //сек
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
  //счетчик перебора блоков(циклов)
  i, jG: integer;
  iMasGroupPars: integer;
  time: cardinal;
  iT: integer;
  str: string;
  arrLength:Integer;
begin
  //form1.Memo1.Lines.Add(intToStr(countBlock));
  i := 1;
  //разбираем и выводим блок за блоком. для каждой информативности свой статический массив
  while i <= countBlock do
  begin
    try
      //счетчик для сбора времени
      iT := 11;
      case infNum of
        //M16
        0:
        begin
          //читаем из файла блок с префиксом, потом префикс откинем
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
          //сдвигаемся от начала блока на размер префикса
          jG := SIZEBLOCKPREF; {+1} //!!!!!

          arrLength:=length(arr1);
          //разбиваем цикл на группы и выводим погруппно на график
          while jG <=arrLength  - 1 do
          begin
            //собираем массив группы
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize do
            begin
              //собираем 11 разрядное значение для вывода
              masGroup[iMasGroupPars] := ((arr1[jG + 1] shl 8) +
              arr1[jG]) and 2047;
              //содержит 12 разрядное значение для сбора быстрых каналов
              masGroupAll[iMasGroupPars] := ((arr1[jG + 1] shl 8) +
              arr1[jG]) and 4095;
              jG := jG + 2;
            end;
            //собрали группу
            //запупустили вывод на диаграммы

            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //если активна вкладка температурных параметров
              //то на гистограмму выводим все точки
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;

            //определяем тип активной вкладки
    {case form1.PageControl1.ActivePageIndex  of
      0:
      begin
        //аналоговые и контактные
        if ((not vSlowFlag)and(not vContFlag)) then
        begin
          //вывод по таймеру
          form1.TimerOutToDia.Enabled := true;
        end;

        if ((not vSlowFlag)and(vContFlag)) then
        begin
          //вывод по таймеру медленных
          form1.TimerOutToDia.Enabled := true;
          //вывод всех точек контактных
          outToDiaCGeneral;
        end;

        if ((vSlowFlag)and(not vContFlag)) then
        begin
          outToDiaSGeneral;
          //вывод по таймеру контактных
          form1.tmrCont.Enabled := true;
        end;

        if ((vSlowFlag)and(vContFlag)) then
        begin
          //вывод медленных все точки
          outToDiaSGeneral;
          //вывод контактных все точки
          outToDiaCGeneral;
        end;
      end;
      1:
      begin
        //быстрые
        //вывод по таймеру
        form1.TimerOutToDia.Enabled := true;
      end;
      2:
      begin
         //температурные
        //если активна вкладка температурных параметров
        //то на гистограмму выводим все точки
        data.outToDiaTGeneral;
        //БУС {невидима и не используется}
      {end;
      3:
      begin
        //БУС {невидима и не используется
      end;
      4:
      begin
        //температурные
        //если активна вкладка температурных параметров
        //то на гистограмму выводим все точки
        data.outToDiaTGeneral;
      end;
    end; }

            //вывод на графики. Общая процедура.
            {data.}OutToGistGeneral;

            //переключение счетчика на след группу
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
          //читаем из файла блок без учета префикса
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
          //сдвигаемся от начала блока на размер префикса
          jG := SIZEBLOCKPREF; {+1} //!!!!!

          arrLength:=length(arr2);
          //разбиваем цикл на группы и выводим погрупно на график
          while jG <= arrLength - 1 do
          begin
            //собираем массив группы
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize do
            begin
              //собираем 11 разрядное значение для вывода
              masGroup[iMasGroupPars] := ((arr2[jG + 1] shl 8) +
              arr2[jG]) and 2047;
              //содержит 12 разрядное значение для сбора быстрых каналов
              masGroupAll[iMasGroupPars] := ((arr2[jG + 1] shl 8) +
              arr2[jG]) and 4095;
              jG := jG + 2;
            end;
            //собрали запупустили вывод на диаграммы
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //если активна вкладка температурных параметров
              //то на гистограмму выводим все точки
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //вывод на графики. Общая процедура.
            {data.}OutToGistGeneral;

            //переключение счетчика на след группу
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
          //читаем из файла блок без учета префикса
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
          //сдвигаемся от начала блока на размер префикса
          jG := SIZEBLOCKPREF; {+1} //!!!!!
          arrLength:=length(arr3);
          //разбиваем цикл на группы и выводим погрупно на график
          while jG <= arrLength - 1 do
          begin
            //собираем массив группы
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize  do
            begin
              //собираем 11 разрядное значение для вывода
              masGroup[iMasGroupPars] := ((arr3[jG + 1] shl 8) +
              arr3[jG]) and 2047;
              //содержит 12 разрядное значение для сбора быстрых каналов
              masGroupAll[iMasGroupPars] := ((arr3[jG + 1] shl 8) +
              arr3[jG]) and 4095;
              jG := jG + 2;
            end;
            //собрали запупустили вывод на диаграммы
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //если активна вкладка температурных параметров
              //то на гистограмму выводим все точки
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //вывод на графики. Общая процедура.
            {data.}OutToGistGeneral;

            //переключение счетчика на след группу
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
          //читаем из файла блок без учета префикса
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
          //сдвигаемся от начала блока на размер префикса
          jG := SIZEBLOCKPREF; {+1} //!!!!!
          arrLength:=length(arr4);
          //разбиваем цикл на группы и выводим погрупно на график
          while jG <=arrLength  - 1 do
          begin
            //собираем массив группы
            //CollectOrbGroup;
            for iMasGroupPars := {0}1 to masGroupSize do
            begin
              //собираем 11 разрядное значение для вывода
              masGroup[iMasGroupPars] := ((arr4[jG + 1] shl 8) +
              arr4[jG]) and 2047;
              //содержит 12 разрядное значение для сбора быстрых каналов
              masGroupAll[iMasGroupPars] := ((arr4[jG + 1] shl 8) +
              arr4[jG]) and 4095;
              jG := jG + 2;
            end;
            //собрали запупустили вывод на диаграммы
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //если активна вкладка температурных параметров
              //то на гистограмму выводим все точки
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //вывод на графики. Общая процедура.
            {data.}OutToGistGeneral;

            //переключение счетчика на след группу
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
          //читаем из файла блок без учета префикса
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
          //сдвигаемся от начала блока на размер префикса
          jG := SIZEBLOCKPREF; {+1} //!!!!!
          arrLength:=length(arr5);
          //разбиваем цикл на группы и выводим погрупно на график
          while jG <=arrLength - 1 do
          begin
            //собираем массив группы
            //CollectOrbGroup;
            for iMasGroupPars := 1{0} to masGroupSize do
            begin
              //собираем 11 разрядное значение для вывода
              masGroup[iMasGroupPars] := ((arr5[jG + 1] shl 8) +
              arr5[jG]) and 2047;
              //содержит 12 разрядное значение для сбора быстрых каналов
              masGroupAll[iMasGroupPars] := ((arr5[jG + 1] shl 8) +
              arr5[jG]) and 4095;
              jG := jG + 2;
            end;
            //собрали запупустили вывод на диаграммы
            if (form1.PageControl1.ActivePageIndex = 2) then
            begin
              //если активна вкладка температурных параметров
              //то на гистограмму выводим все точки
              {data.}outToDiaTGeneral;
            end
            else
            begin
              form1.TimerOutToDia.Enabled := true;
            end;
            //вывод на графики. Общая процедура.
            {data.}OutToGistGeneral;

            //переключение счетчика на след группу
            inc({data.}groupNum);//!!!
            if {data.}groupNum=33 then
            begin
              {data.}groupNum:=1;
            end;
          end;
        end;
      end;
      //переключаем счетчик на след. цикл
      Inc({data.}ciklNum); //!!!
      if {data.}ciklNum=5 then
      begin
        {data.}ciklNum:=1;
      end;


      form1.TrackBar1.Position := form1.TrackBar1.Position +form1.TrackBar1.PageSize;
    finally
      //проверяем каждый раз дошли ли до конца файла.
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
 