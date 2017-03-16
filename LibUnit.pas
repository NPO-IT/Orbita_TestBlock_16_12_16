unit LibUnit;


interface
uses
  SysUtils,Gauges,Graphics;


const
  //���
  // ������� ����� ������
  ADCRATE: double = 10000.0; //3145.728
  // ���-�� �������� �������
  CHANNELSQUANTITY: WORD = $01;
  //������ ���������� ������(������ ���������� ����)
  FIFOSIZE = 2500000;
  //������ ������� ������. � ������ ������ �������� �������� ����� � 10-�� �������
  SIZEMASGROUP=2048;
  //���������� ������(������ ������ �������������� �� ���� ������)
  NUMBLOCK = 4;
  SIZEBLOCKPREF = 32;
  MAXHEADSIZE = 256;

  //M08,04,02,01
  // ������� ������� 1/2 ������� ����
  MARKMINSIZE = 3;
  MARKMAXSIZE = 4;
  //��� ����� ����� ����� ���������
  MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR = 1220;
  //���������� ����� ��������� �� 1 ��� �� ������
  NUMPOINTINTCOUT = 10;

  //�����. �������� � ������� ���
  NUM_BUS_ELEM=96;
  //����. ������� ���.
  BUS_MARKER_VAL=65535;

  SAZ_NUM=22;

  //��������� ��� ���������� ���������� ��� ���3
  ROUND_P_N=32;
type
  //��� �������� ������ (��� ������ �����)
  TDBufCircleArray = array[0..1] of array[1..SIZEMASGROUP*32] of word;

  //��� ������ ��� ������ �� ������
  channelOutParam = record
    //����� ������ ����� � ������� ������
    numOutElemG: integer;
    //��� �� ����. ������ ����� � ������� ������
    stepOutG: integer;
    //0-���������� �����. 1-���������� �����. 2-������� ���������
    adressType: {short}integer;
    //����� ���� � ��������, ��� �����. �������� ����������� ������.
    //0-���������� �����. 1-8 ������ �����.
    bitNumber: {short}integer;
    //����� ������ ��� ���.
    numBusThread: {short}integer;
    //����� ���.
    adrBus: {short}integer;
    //����� ������ � ������� ��� ���
    numAdrInTable: {short}integer;
    //����� 1 ������ � ������ ���
    numAdrInBusPocket: {short}integer;
    //����� 2 ������ � ������ ���
    numAdrInBusPocket2: {short}integer;
    //!!! ����� ������� ����� ��� ������ �� �����������
    numOutPoint: {short}integer;
    //���� ��� ����������� �������������� ����� ������
    flagGroup:Boolean;
    //���� ��� ����������� �������������� ����� �����
    flagCikl:Boolean;
    //������ ������� ����� ��� �������
    arrNumGroup:array of {SHORT}integer;
    //������ ������� ������ ��� �������
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

  //��� ������ �������������
  adrElement = record
    litera: char;
    n: {short}integer;
    k: {short}integer;
  end;

var
  //�������� ��� �������� ������� ���������� � ���������� �������
  analogAdrCount: integer;
  contactAdrCount: integer;
  tempAdrCount:Integer;
  //����� ��������������� ������
  infNum: integer;
  //������ ��������� ����
  masCircle: TDBufCircleArray;
  //���������� ����������� ���� � ������� ����� �� ���������������
  masCircleSize:cardinal;
  // �����(������� �������� ������� ������� ����� ����������� ������� �������)
  porog: integer;
  //���������� ����� ������� � ����
  outStep: integer;
  //������ ��� �������� ����� ������
  fifoMas: array[1..FIFOSIZE] of integer;
  //������� ������ ��� ������� �������
  fifoBufCount: integer;
  //������� ��� ������ � ������ fifo
  fifoLevelWrite: integer;
  //������� ������ �� fifo
  fifoLevelRead: integer;
  // �������. ���������� ��� flSinxC
  flBeg: boolean;
  //������� ������ ����� ������
  wordNum: integer;
  //������� ����
  fraseNum: integer;
  //������� ������ ������
  groupNum:integer;
  //������� ������ �����
  ciklNum:Integer;
  //��� ���������� ������� ����� � ������ 1 �����
  //������ ����� ������ ������
  flSinxC: boolean;
  //���� ��� ��������� ��� ������ ����� ��� ������
  flKadr:Boolean;
  //����. ������ � ������ ������
  startWriteMasGroup: boolean;
  //�����. 12 ����. ����� ������
  codStr: word;

  //�����.���������� � ���������� ������
  graphFlagSlowP: boolean;
  //�����.������������� ���������
  graphFlagTempP: boolean;
  //�����. ������� ������
  graphFlagFastP: boolean;
  //�����. ��� ������
  graphFlagBusP: boolean;
  //������� ��� �������� �������� ���� �� 1 �� 128
  countForMF:Integer;
  //������� ������ ������ ������� ����� �� 100 ���
  countErrorMF:Integer;
  //���������� ����������� ������ ������ � ���.
  buffDivide: integer;
  //������� �����
  groupWordCount: integer;
  //������� ������ ���� �� ������� ������ �� ������� ������
  countEvenFraseMGToMG:integer;
  //������� ��� �������� �������� ����� �� 1 �� 100
  countForMG:Integer;
  //������� ������ ������ ������� ������ �� 100 ���
  countErrorMG:Integer;
  //��� ������� �����������
  reqArrayOfCircle: {short}Shortint;
  //��� ����������  masCircle
  imasCircle: integer;
  vSlowFlag:Boolean;
  vContFlag:Boolean;

  //����� ������ �� ����������� ��������
  //�������� ����� ��������� �� ������ ����.
  chanelIndexSlow: integer;
  //����� ������ �� ����������� ��������
  //�������� ����� ��������� �� ������ ����.
  chanelIndexTemp: integer;
  //����� ������ �� ����������� �������� ��������
  //����� ��������� �� ������ ����.
  chanelIndexFast: integer;
  //����� ������ �� ����������� �������� ��������
  //����� ��������� �� ������ ���
  chanelIndexBus:integer;
  //������� ��� ������ �� ������ ������� ����������
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

  //������ �������� ���� ���.
  busArray:array of word;
  //������ �� �������� ������� ������� ��������
  masFastVal: array{[1..100000]} of double;

  //����� ��������� ����� �� �����������
  numP: integer;
  numPfast: integer;

  //���� ��� ����. ����������� ����� ����� ������
  flagACPWork:Boolean;
  flagStartWriteTime:Boolean=false;
  //����� �������� ����� tlm � ������� unixtime
  msTime:cardinal;
  msTimeF:Double;
  //����� � �� �� 1 ����� ���
  msOnACPBuf:Double;

  adrTestNum:Integer=0;

  modZU:integer=0;//!!
  startZUtime:Integer=0;//!!
  //��� ��������� ������� �������
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
  //������� ��� �������� ������������� ������� ������ ��� ���� ������
  function isInGroup(grNum:integer;addrNum:integer):Boolean;
  function isInCikl(ciklNum:integer;addrNum:integer):Boolean;
implementation
uses
  OrbitaAll;

//==============================================================================
//���� �� ���������� ����� ������ � ������� ����� �� ������� ������ ����������� �������
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
//���� �� ���������� ����� ����� � ������� ����� �� ������� ������ ����������� �������
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
//����� �� ��������� ����� ����� �� ��
//==============================================================================
procedure OutMF(errMF:Integer);
var
  procentErr:Integer;
begin
  if errMF=0 then
  begin
    //����� ��� ��� clWhite
    form1.gProgress1.BackColor:=clWhite;
  end
  else
  begin
    //���� ���� ��� clRed
    form1.gProgress1.BackColor:=clRed;
  end;

  procentErr:=Trunc(errMF/1.27);
  Form1.gProgress1.Progress:=procentErr;
end;
//==============================================================================

//==============================================================================
//����� �� ��������� ����� ����� �� ��
//==============================================================================
procedure OutMG(errMG:Integer);
var
  procentErr:Integer;
begin
  if errMG=0 then
  begin
    //����� ��� ��� clWhite
    form1.gProgress2.BackColor:=clWhite;
  end
  else
  begin
    //���� ���� ��� clRed
    form1.gProgress2.BackColor:=clRed;
  end;
  procentErr:=Trunc(errMG/0.32);
  Form1.gProgress2.Progress:=procentErr;
end;
//==============================================================================



end.
