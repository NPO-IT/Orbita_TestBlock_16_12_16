unit LibUnit;


interface
uses
  SysUtils,Gauges,Graphics;


const
  //АЦП
  // частота ввода данных
  ADCRATE: double = 10000.0; //3145.728
  // кол-во активных каналов
  CHANNELSQUANTITY: WORD = $01;
  //размер кольцевого буфера(хранит Орбитовкие биты)
  FIFOSIZE = 2500000;
  //размер массива группы. В каждой ячейке хранится значение слова в 10-ом формате
  SIZEMASGROUP=2048;
  //количество блоков(циклов Орбиты обрабатываемых за один проход)
  NUMBLOCK = 4;
  SIZEBLOCKPREF = 32;
  MAXHEADSIZE = 256;

  //M08,04,02,01
  // размеры маркера 1/2 размера бита
  MARKMINSIZE = 3;
  MARKMAXSIZE = 4;
  //мин колич точек между маркерами
  MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR = 1220;
  //количество точек выводимое за 1 раз на график
  NUMPOINTINTCOUT = 10;

  //колич. значений в массиве БУС
  NUM_BUS_ELEM=96;
  //знач. маркера БУС.
  BUS_MARKER_VAL=65535;

  SAZ_NUM=22;

  //константа для округления калибровки для МКТ3
  ROUND_P_N=32;
type
  //тип двойного буфера (для буфера цикла)
  TDBufCircleArray = array[0..1] of array[1..SIZEMASGROUP*32] of word;

  //тип канала для вывода на график
  channelOutParam = record
    //номер первой точки в массиве группы
    numOutElemG: integer;
    //шаг до след. номера точки в массиве группы
    stepOutG: integer;
    //0-аналоговый адрес. 1-контактный адрес. 2-быстрые параметры
    adressType: {short}integer;
    //номер бита в значении, для получ. значения контактного канала.
    //0-аналоговый канал. 1-8 номера битов.
    bitNumber: {short}integer;
    //номер потока для БУС.
    numBusThread: {short}integer;
    //адрес БУС.
    adrBus: {short}integer;
    //номер адреса в таблице для БУС
    numAdrInTable: {short}integer;
    //номер 1 канала в пакете БУС
    numAdrInBusPocket: {short}integer;
    //номер 2 канала в пакете БУС
    numAdrInBusPocket2: {short}integer;
    //!!! номер текущей точки для вывода на гистограмму
    numOutPoint: {short}integer;
    //флаг для определения перескакивания через группы
    flagGroup:Boolean;
    //флаг для определения перескакивания через циклы
    flagCikl:Boolean;
    //массив номеров групп для выборки
    arrNumGroup:array of {SHORT}integer;
    //массив номеров циклов для выборки
    arrNumCikl:array of {SHORT}integer;
  end;

  TtempCh=record
    num:Integer;
    val:Word;
  end;

  TslowCh=record
    num:Integer;
    val:Word;
  end;

  TcontCh=record
    num:Integer;
    val:Word;
  end;

  //тип записи псевдомассива
  adrElement = record
    litera: char;
    n: {short}integer;
    k: {short}integer;
  end;

var
  //счетчики для подсчета адресов аналоговых и контактных каналов
  analogAdrCount: integer;
  contactAdrCount: integer;
  tempAdrCount:Integer;
  //номер информативности Орбиты
  infNum: integer;
  //хранит целиковый цикл
  masCircle: TDBufCircleArray;
  //количество Орбитовских слов в массиве цикла от информативности
  masCircleSize:cardinal;
  // порог(среднее значение сигнала которое будет проверяться разбора сигнала)
  porog: integer;
  //переменная числа выводов в файл
  outStep: integer;
  //массив для хранения битов орбиты
  fifoMas: array[1..FIFOSIZE] of integer;
  //счетчик буфера для разбора массива
  fifoBufCount: integer;
  //счетчик для записи в массив fifo
  fifoLevelWrite: integer;
  //счетчик чтения из fifo
  fifoLevelRead: integer;
  // вспомог. переменная для flSinxC
  flBeg: boolean;
  //счетчик номера слова Орбиты
  wordNum: integer;
  //счетчик фраз
  fraseNum: integer;
  //счетчик номера группы
  groupNum:integer;
  //счетчик номера цикла
  ciklNum:Integer;
  //для заполнения массива цикла с начала 1 слово
  //первой фразы первой группы
  flSinxC: boolean;
  //флаг для индикации что маркер кадра был найден
  flKadr:Boolean;
  //разр. записи в массив группы
  startWriteMasGroup: boolean;
  //аккум. 12 разр. слова Орбиты
  codStr: word;

  //вывод.аналоговые и контактные каналы
  graphFlagSlowP: boolean;
  //вывод.температурные параметры
  graphFlagTempP: boolean;
  //вывод. быстрые каналы
  graphFlagFastP: boolean;
  //вывод. БУС каналы
  graphFlagBusP: boolean;
  //счетчик для подсчета маркеров фраз от 1 до 128
  countForMF:Integer;
  //счетчик ошибок поиска маркера фразы за 100 раз
  countErrorMF:Integer;
  //переменная размерности буфера данных с АЦП.
  buffDivide: integer;
  //счетчик групп
  groupWordCount: integer;
  //счетчик четных фраз от маркера группы до маркера группы
  countEvenFraseMGToMG:integer;
  //счетчик для подсчета маркеров групп от 1 до 100
  countForMG:Integer;
  //счетчик ошибок поиска маркера группы за 100 раз
  countErrorMG:Integer;
  //для двойной буферизации
  reqArrayOfCircle: {short}Shortint;
  //для заполнения  masCircle
  imasCircle: integer;
  vSlowFlag:Boolean;
  vContFlag:Boolean;

  //номер канала на гистограмме значения
  //которого будут выводится на график медл.
  chanelIndexSlow: integer;
  //номер канала на гистограмме значения
  //которого будут выводится на график медл.
  chanelIndexTemp: integer;
  //номер канала на гистограмме значения которого
  //будут выводится на график быст.
  chanelIndexFast: integer;
  //номер канала на гистограмме значения которого
  //будут выводится на график БУС
  chanelIndexBus:integer;
  //счетчик для вывода на график быстрых параметров
  countPastOut: integer;
  tempArr:array of TtempCh;
  tempArr2:array of TtempCh;
  tempArr3:array of TtempCh;

  slowArr:array of TslowCh;
  contArr:array of TcontCh;

  iTempArr:integer;
  iSlowArr:Integer;
  iContArr:Integer;

  vSlowFlagGr:Boolean;
  vSlowFlagCikl:Boolean;
  vContFlagGr:Boolean;
  vContFlagCikl:Boolean;

  //массив значений слов БУС.
  busArray:array of word;
  //массив из которого выводим быстрые значения
  masFastVal: array{[1..100000]} of double;

  //номер выводимой точки на гистограмму
  numP: integer;
  numPfast: integer;

  //флаг для осущ. перезапуска сбора кадра Орбиты
  flagACPWork:Boolean;
  flagStartWriteTime:Boolean=false;
  //время создания файла tlm в формате unixtime
  msTime:cardinal;
  msTimeF:Double;
  //время в мс на 1 буфер АЦП
  msOnACPBuf:Double;

  adrTestNum:Integer=0;

  modZU:integer=0;//!!
  startZUtime:Integer=0;//!!
  //нач состояние каналов прибора
  testZU_Arr_pr_BegState:array[1..100] of Integer;//!!


  flagSinxTemp:Boolean=False;
  iColibr:integer=0;

  testSAZ:Boolean=false;
  startWSaz:Boolean;
  iTestSazArr:Integer=1;
  testSazArr:array[1..SAZ_NUM] of word;
  testSazArrConst:array[1..SAZ_NUM] of word=
  (1361,681,119,18,196,9,32,136,19,64,76,29,96,16,39,128,212,48,160,152,58,192);



  BufferADP:array[1..100] of Byte;


  iMaxScale4Arr:Integer;
  iMinScale4Arr:Integer;
  iMaxScale3Arr:Integer;
  iMinScale3Arr:Integer;
  iMaxScale2Arr:Integer;
  iMinScale2Arr:Integer;
  iMaxScale1Arr:Integer;
  iMinScale1Arr:Integer;

  maxScale4Arr:array[1..ROUND_P_N] of Integer;
  minScale4Arr:array[1..ROUND_P_N] of Integer;
  maxScale3Arr:array[1..ROUND_P_N] of Integer;
  minScale3Arr:array[1..ROUND_P_N] of Integer;
  maxScale2Arr:array[1..ROUND_P_N] of Integer;
  minScale2Arr:array[1..ROUND_P_N] of Integer;
  maxScale1Arr:array[1..ROUND_P_N] of Integer;
  minScale1Arr:array[1..ROUND_P_N] of Integer;

  isTestCloseFl:Boolean;

  fileName:string;

  periodTestMKT3_Const:array[1..32] of Double=
  (0.0,6.25,9.37,18.75,25.0,37.5,50.0,75.0,100.0,18.75,37.5,0.0,6.25,6.25{9.37},
   18.75,25.0,37.5,50.0,75.0,100.0,18.75,37.5,18.75,37.5,18.75,37.5,18.75,
   37.5,18.75,37.5,18.75,37.5);
  periodTestMKB2_ZU_Const:array[1..32] of Double=
  (0.0,30.01,60.03,90.04,8.5,34.31,74.2,100.0,
   0.0,60.03,8.5,74.2,0.0,60.03,8.5,74.2,0.0,60.03,8.5,74.2,
   0.0,60.03,8.5,74.2,0.0,60.03,8.5,74.2,0.0,60.03,8.5,74.2);

  periodTestMKT3:array[1..32] of Double;
  periodTestMKB2_ZU:array[1..32] of Double;

  stPrTest:Boolean;

  tFlagPr:Boolean=True;

  procedure OutMF(errMF:Integer);
  procedure OutMG(errMG:Integer);
  //функции для проверки соответствует текущая группа или цикл нужной
  function isInGroup(grNum:integer;addrNum:integer):Boolean;
  function isInCikl(ciklNum:integer;addrNum:integer):Boolean;
implementation
uses
  OrbitaAll;

//==============================================================================
//Есть ли переданный номер группы в массиве групп из которых должна произодится выборка
//==============================================================================
function isInGroup(grNum:integer;addrNum:integer):Boolean;
var
  i:Integer;
  maxArrElem:Integer;
  flagS:Boolean;
begin
  flagS:=false;
  i:=0;
  maxArrElem:=Length(masElemParam[addrNum].arrNumGroup);
  while i<maxArrElem do
  begin
    if masElemParam[addrNum].arrNumGroup[i]=grNum then
    begin
      flagS:=true;
      Break;
    end;
    Inc(i);
  end;
  result:=flagS;
end;
//==============================================================================

//==============================================================================
//Есть ли переданный номер цикла в массиве цикла из которых должна произодится выборка
//==============================================================================
function isInCikl(ciklNum:integer;addrNum:integer):Boolean;
var
  i:Integer;
  maxArrElem:Integer;
  flagS:Boolean;
begin
  flagS:=false;
  i:=0;
  maxArrElem:=Length(masElemParam[addrNum].arrNumCikl);
  while i<maxArrElem do
  begin
    if masElemParam[addrNum].arrNumCikl[i]=ciklNum then
    begin
      flagS:=true;
      Break;
    end;
    Inc(i);
  end;
  result:=flagS;
end;
//==============================================================================

//==============================================================================
//Вывод на диаграмму число сбоев по МФ
//==============================================================================
procedure OutMF(errMF:Integer);
var
  procentErr:Integer;
begin
  if errMF=0 then
  begin
    //сбоев нет фон clWhite
    form1.gProgress1.BackColor:=clWhite;
  end
  else
  begin
    //сбои есть фон clRed
    form1.gProgress1.BackColor:=clRed;
  end;

  procentErr:=Trunc(errMF/1.27);
  Form1.gProgress1.Progress:=procentErr;
end;
//==============================================================================

//==============================================================================
//Вывод на диаграмму число сбоев по МГ
//==============================================================================
procedure OutMG(errMG:Integer);
var
  procentErr:Integer;
begin
  if errMG=0 then
  begin
    //сбоев нет фон clWhite
    form1.gProgress2.BackColor:=clWhite;
  end
  else
  begin
    //сбои есть фон clRed
    form1.gProgress2.BackColor:=clRed;
  end;
  procentErr:=Trunc(errMG/0.32);
  Form1.gProgress2.Progress:=procentErr;
end;
//==============================================================================



end.
