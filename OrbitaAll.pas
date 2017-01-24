unit OrbitaAll;

interface

uses
  SysUtils,Windows, Messages,Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, StdCtrls, Series, TeEngine, TeeProcs, Chart, ExtCtrls,
  Lusbapi,  Math, Buttons, ComCtrls, xpman, DateUtils,
  MPlayer,iniFiles,StrUtils,syncobjs,ExitForm, Gauges,TLMUnit,LibUnit,ACPUnit,UnitM16,
  OutUnit,UnitMoth,TestUnit_N1_1, IdUDPBase, IdUDPServer,IdSocketHandle;
//Lusbapi-библиотека для работы с АЦП Е20-10
//Visa_h-библиотека для работы с генератором и вольтметром
const
  ISD_VALUE = 2100;
type
 TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    OrbitaAddresMemo: TMemo;
    TimerOutToDia: TTimer;
    Memo1: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    diaSlowAnl: TChart;
    Series1: TBarSeries;
    diaSlowCont: TChart;
    Series3: TBarSeries;
    gistSlowAnl: TChart;
    upGistSlowSize: TButton;
    downGistSlowSize: TButton;
    Series2: TLineSeries;
    fastDia: TChart;
    Series4: TBarSeries;
    fastGist: TChart;
    Series11: TFastLineSeries;
    upGistFastSize: TButton;
    downGistFastSize: TButton;
    tlmWriteB: TButton;
    Label2: TLabel;
    Panel2: TPanel;
    TrackBar1: TTrackBar;
    LabelHeadF: TLabel;
    fileNameLabel: TLabel;
    OpenDialog1: TOpenDialog;
    PanelPlayer: TPanel;
    play: TSpeedButton;
    pause: TSpeedButton;
    stop: TSpeedButton;
    TimerPlayTlm: TTimer;
    startReadACP: TButton;
    startReadTlmB: TButton;
    tlmPSpeed: TTrackBar;
    Label2x: TLabel;
    Labelx: TLabel;
    Labelx2: TLabel;
    timeHeadLabel: TLabel;
    orbTimeLabel: TLabel;
    OpenDialog2: TOpenDialog;
    propB: TButton;
    saveAdrB: TButton;
    TabSheet3: TTabSheet;
    busDia: TChart;
    busGist: TChart;
    Series5: TBarSeries;
    Series6: TLineSeries;
    TimerOutToDiaBus: TTimer;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    tmrForTestOrbSignal: TTimer;
    gProgress1: TGauge;
    gProgress2: TGauge;
    procentFalseMF1: TLabel;
    procentFalseMG: TLabel;
    ts3: TTabSheet;
    tempDia: TChart;
    Series7: TBarSeries;
    tempGist: TChart;
    lnsrsSeries8: TLineSeries;
    upGistTempSize: TButton;
    downGistTempSize: TButton;
    rb1: TRadioButton;
    rb2: TRadioButton;
    lbl1: TLabel;
    Button1: TButton;
    tmrCont: TTimer;
    btnAutoTest: TButton;
    lblTestResult: TLabel;
    mmoTestResult: TMemo;
    idhttp1: TIdHTTP;
    idpsrvr1: TIdUDPServer;
    btn1: TButton;
    tmr1_1_10_2: TTimer;
    tmrAllTest: TTimer;
    tmrRCo: TTimer;
    tmrTestSRN2: TTimer;
    idhttp2: TIdHTTP;
    achx: TTabSheet;
    achxG: TChart;
    lnsrsSeries9: TLineSeries;
    lnsrsSeries10: TLineSeries;
    lnsrsSeries11: TLineSeries;
    tmrMKB_Dpart: TTimer;
    tmrF: TTimer;
    tmrTestBVK: TTimer;
    btn2: TButton;
    lbl2: TLabel;
    btn3: TButton;
    btn4: TButton;
    tmr1: TTimer;
    tmrBVK2: TTimer;
    btnPoweroff: TButton;
    btnPowerOn: TButton;
    procedure startReadACPClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure upGistSlowSizeClick(Sender: TObject);
    procedure downGistSlowSizeClick(Sender: TObject);
    procedure Series1Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TimerOutToDiaTimer(Sender: TObject);
    procedure upGistFastSizeClick(Sender: TObject);
    procedure downGistFastSizeClick(Sender: TObject);
    procedure tlmWriteBClick(Sender: TObject);
    procedure startReadTlmBClick(Sender: TObject);
    procedure Series4Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TimerPlayTlmTimer(Sender: TObject);
    procedure playClick(Sender: TObject);
    procedure pauseClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure stopClick(Sender: TObject);
    procedure tlmPSpeedChange(Sender: TObject);
    procedure propBClick(Sender: TObject);
    procedure saveAdrBClick(Sender: TObject);
    procedure Series5Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TimerOutToDiaBusTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tmrForTestOrbSignalTimer(Sender: TObject);
    procedure Series7Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure upGistTempSizeClick(Sender: TObject);
    procedure downGistTempSizeClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure tmrContTimer(Sender: TObject);
    procedure btnAutoTestClick(Sender: TObject);
    procedure idpsrvr1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure tmr1_1_10_2Timer(Sender: TObject);
    procedure tmrAllTestTimer(Sender: TObject);
    procedure tmrRCoTimer(Sender: TObject);
    procedure tmrTestSRN2Timer(Sender: TObject);
    procedure tmrMKB_DpartTimer(Sender: TObject);
    procedure tmrFTimer(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure tmrTestBVKTimer(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure tmrBVK2Timer(Sender: TObject);
    procedure btnPoweroffClick(Sender: TObject);
    procedure btnPowerOnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



  Tdata = class(TObject)
    //флаг для вычисления порога 1 раз
    //modC: boolean;
    //счетчик для заполнения аналоговых параметров БУС
    masAnlBusChCount: integer;
    //массив для хранения значения слов Орбиты.11 младших битов
    {masGroup:array[1..SIZEMASGROUP] of word;}

    //массив для хранения значения слов Орбиты.12 битов
    {masGroupAll:array[1..SIZEMASGROUP] of word;}
    //bool:boolean;
    //----------------------------------- M08,04,02,01
    //счетчик фраз
    //fraseCount: integer;
    //счетчик групп
    //groupCount: integer;

    //7 разрядное значение с 0 до 127 номера группы
    bufNumGroup:byte;
    //счетчик заполненных слов БУС
    iBusArray:integer;
    //флаг для поиска маркера для зап. массива БУС
    flagWtoBusArray:boolean;
    procedure OutMG(errMG:Integer);
    //вспомогательная процедура для вывода данных маркетра фразы
    procedure TestSMFOutDate(numPointDown:Integer;numCurPoint:integer;numPointUp:integer);
    //подготовка программы к приему или чтению данных
    procedure ReInitialisation;
    //сохранение отчета
    //procedure SaveReport;
    //для работы с системным файлом(признак проверки туда пишем(system))
    procedure WriteSystemInfo(value: string);
    //подсчет среднего значения в массиве группы
    function AvrValue(firstOutPoint: integer; nextPointStep: integer;
      masGroupS: integer): integer;

    constructor CreateData;

    //m08,04,02,01
    //
    //передаем начало предидущего маркера (номер точки),



    function TestMarker(begNumPoint: integer; const pointCounter: integer): boolean;



    function BuildBusValue(highVal:word;lowerVal:word):word;
    function CollectBusArray(var iBusArray:integer):boolean;
  end;

  


var
  Form1: TForm1;
   
  //===================================
  //Переменные для работы с АЦП
  //===================================

  //=============================
  //Параметры приборов.
  //=============================
  //RS485
  //переменная для хранения ip-адреса адаптера RS485 (ini-файл)
  HostAdapterRS485: string;
  //переменная для хранения номера порта для адаптера
  PortAdapterRS485: integer;
  //ИСД1
  //переменная для хранения ip-адреса первого ИСД (ini-файл)
  HostISD1: string;
  //ИСД2
  //переменная для хранения ip-адреса второго ИСД (ini-файл)
  HostISD2: string;
  //Генератор
  //переменная для хранения идентификатора генератора
  RigolDg1022: string;
  //Вольтметр_1
  m_defaultRM_usbtmc_1, m_instr_usbtmc_1: array[0..3] of LongWord;
  viAttr_1: Longword = $3FFF001A;

  //Вольтметр_2
  m_defaultRM_usbtmc_2, m_instr_usbtmc_2: array[0..3] of LongWord;
  viAttr_2: Longword = $3FFF001A;

  viAttr: Longword = $3FFF001A;
  Timeout: integer = 1000; //7000
  //==============================

  //==============================
  //Работа с файлами
  //==============================
  //файловая переменная для работы с системным файлом
  systemFile: Text;
  //файловая переменная для формирования отчета проверки в файл
  reportFile: Text;
  //файл данных с АЦП
  LogFile: text;
  //==============================

  //класс для работы с сигналом Орбита
  //data: Tdata;

  dataM16:TDataM16;
  dataMoth:TDataMoth;

  //класс для работы с TLM
  tlm: Ttlm;
  //класс для работы с АЦП
  acp: Tacp;

  //опис. массив для параметров адресов
  masElemParam: array of channelOutParam;

  arrAddrOk:array of string;

  //счетчик хранит максим. число адреосв Орбиты
  iCountMax: integer;
  //кол. аналоговых каналов
  acumAnalog: integer;
  //колич. температурных каналов
  acumTemp:Integer;
  //счетчик выведенных темп. параметров
  outTempAdr:Integer;
  //кол. контактных
  acumContact: integer;
  //кол. быстрых
  acumFast: integer;
  //кол. БУС каналов
  acumBus:integer;
  //количество Орбитовских слов в массиве группы от информативности
  masGroupSize: integer;

  masGroup: array[1..SIZEMASGROUP] of word;
  masGroupAll: array[1..SIZEMASGROUP] of word;


  //строка с информативностью Орбиты
  infStr: string;



  //счетчик для подсчета циклов чтения
  countC: integer;

  //переменная для ini файла для запоминания пути последнего файла настроек
  propIniFile:TiniFile;
  propStrPath:string;


  flagEnd:boolean;

  //файл для 32-разр. слов
  //swtFile:text;

  cOut:integer;
  csk:TCriticalSection;

  boolFlg:boolean;

  testOutFalg:boolean;

  //textTestFile:Text;
  //флаг что сигнал Орбиты нашли
  orbOk:Boolean;
  orbOkCounter:integer;

  flagTrue:boolean;

  //максимальное и минимальное значение данных с АЦП
  maxValue, minValue: integer;


implementation


//uses Unit1;

{$R *.dfm}

//==============================================================================
//Процедуры отвечающие за вывод в файл
//==============================================================================
//формирование файла логов

{procedure SaveBitToLog(str: string);
begin
  Writeln(LogFile,str);
  exit
end;}
//==============================================================================

//==============================================================================
//
//==============================================================================
function AditTestAdrCorrect: boolean;
var
  i: integer;
  str: string;
  bool: boolean;
begin
  bool := true;
  //проверка на корректность адресов
  for i := 0 to form1.OrbitaAddresMemo.Lines.Count - 1 do
  begin
    str := '';
    str := form1.OrbitaAddresMemo.Lines.Strings[i][1] +
    form1.OrbitaAddresMemo.Lines.Strings[i][2] +
    form1.OrbitaAddresMemo.Lines.Strings[i][3];
    if str = infStr then
    begin
    end
    else
    begin
      if  str<>'---' then
      begin
        bool := false;
        ShowMessage('Загруженные адреса не соотв. выбранной информативности');
        break;
      end;
    end;
  end;
  result := bool;
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
function GenTestAdrCorrect:boolean;
var
  i: integer;
  //строка с информ.
  str: string;
  masEcount: integer;
  rez:boolean;
begin
  rez:=false;
  //проверка на корректность всех адресов
  for i := 0 to form1.OrbitaAddresMemo.Lines.Count - 1 do
  begin
    str := '';
    str := form1.OrbitaAddresMemo.Lines.Strings[i][1] +
      form1.OrbitaAddresMemo.Lines.Strings[i][2]+form1.OrbitaAddresMemo.Lines.Strings[i][3];
    //проверим а не логический ли это разделитель
    if str = '---' then
    begin
      //перейдем на следующую итерацию цикла
      Continue;
    end;

    if ((str = 'M16')or(str = 'M08')or(str = 'M04')or(str = 'M02')or(str = 'M01')) then
    begin
      //выставим размерность массива группы от выбранной информативности
      case strToInt(str[2] + str[3]) of
        //M16
        16:
        begin
          infNum := 0;
          infStr := 'M16';
        end;
        //M08
        8:
        begin
          infNum := 1;
          infStr := 'M08';
        end;
        //M04
        4:
        begin
          infNum := 2;
          infStr := 'M04';
        end;
        //M02
        2:
        begin
          infNum := 3;
          infStr := 'M02';
        end;
        //M01
        1:
        begin
          infNum := 4;
          infStr := 'M01';
         end;
      end;
    end
    else
    begin
      //ShowMessage('Проверьте правильность адресов');
      //form1.OrbitaAddresMemo.Clear;
      rez:=false;
      break;
    end;

    if i = form1.OrbitaAddresMemo.Lines.Count - 1 then
    begin
      if {data.}AditTestAdrCorrect then
      begin
        form1.startReadACP.Enabled := true;
        form1.startReadTlmB.Enabled := true;
        //выставим размерность массива группы от выбранной информативности
        //также выставим коэф. для поиска маркера фразы для М08,04,02,01
        case infNum of
          //M16
          0:
          begin
            masGroupSize := 2048;
          end;
          //M08
          1:
          begin
            masGroupSize := 1024;
            markKoef:=6.357828776;
            widthPartOfMF:=3;
            minSizeBetweenMrFrToMrFr:=1220;
          end;
          //M04
          2:
          begin
            masGroupSize := 512;
            markKoef:=12.715657552;
            widthPartOfMF:=6;
            minSizeBetweenMrFrToMrFr:=1220;//!!!
          end;
          //M02
          3:
          begin
            masGroupSize := 256;
            markKoef:=25.431315104;
            widthPartOfMF:=12;
            minSizeBetweenMrFrToMrFr:=1220;//!!!
          end;
          //M01
          4:
          begin
            masGroupSize := 128;
            markKoef:=50.862630020;
            widthPartOfMF:=25;
            minSizeBetweenMrFrToMrFr:=1220;//!!!
          end;
        end;

        //количество элементов в массиве цикла от информативности
        masCircleSize:=masGroupSize*32;


        //нач. иниц. кольц. массива битов Орбиты
        for masEcount := 1 to FIFOSIZE do
        begin
          fifoMas[masEcount] := 9;
        end;

        //выделили память под массив группы 11 бит. на графики
        //SetLength(masGroup, masGroupSize);
        //выделили память под массив группы 12 бит. для сбора быстрых
        //SetLength(masGroupAll, masGroupSize);
        for masEcount := 1 to masGroupSize do
        begin
          masGroup[masEcount] := 9;
          masGroupAll[masEcount] := 9;
        end;


        //нач. релизация флага перекл. двойного буфера массива цикла
        //0 буфер
        {data.}reqArrayOfCircle := 0;
        //SetLength(masCircle[data.reqArrayOfCircle], masGroupSize * 32);
        //form1.Memo1.Lines.Add(intToStr(length(masCircle[reqArrayOfCircle])));
        //иниц. массива цикла
        for masEcount := 1 to masGroupSize * 32 do
        begin
          masCircle[{data.}reqArrayOfCircle][masEcount] := 9;
        end;

        rez:=true;
      end;
    end;
  end;
  result:=rez;
end;
//==============================================================================

//==============================================================================
//Процедура для подсчета сколько каких адресов в конфиге есть
//==============================================================================

procedure CountAddres;
var
  //счетчик перебора всех переданных адресов
  adrCount: integer;
  masElemParamLen:integer;
begin
  adrCount := 0;
  masElemParamLen:=length(masElemParam);
  while adrCount <=masElemParamLen  - 1 do
  begin
    case masElemParam[adrCount].adressType of
      0,8:
      begin
        //аналоговые  T01,T01-01(9 разр.)
        inc(acumAnalog);
      end;
      1:
      begin
        //контактные
        inc(acumContact);
      end;
      2, 3, 4, 5:
      begin
        //быстрые
        inc(acumFast);
      end;
      6:
      begin
        //БУС
        inc(acumBus);
      end;
      7:
      begin
        //температурные
        inc(acumTemp);
      end;
    end;
    inc(adrCount);
  end;


   //Выделяем память под массив температурных параметров, так как они выводятся отдельно
  SetLength(slowArr,acumAnalog);
  //Выделяем память под массив температурных параметров, так как они выводятся отдельно
  SetLength(tempArr,acumTemp);
  SetLength(tempArr2,acumTemp);
end;
//==============================================================================

//==============================================================================
//Заполнение массива номеров групп
//==============================================================================
procedure FillGroupArr(iArrElemPar:Integer;var fNum:Integer;var stepNum:Integer);
const
  MAXGROUPNUM=32;
var
  i:Integer;
  iG:Integer;
  fElemGr:Integer;
  sElemGr:Integer;
  fNumGr:Integer;
  sNumGr:Integer;
begin
  masElemParam[iArrElemPar].flagGroup:=True;
  i:=0;
  fElemGr:=fNum;
  //узнаем номер первой группы
  fNumGr:=Trunc(fElemGr/masGroupSize)+1;
  //если первый элемент находится не в первой группе,
  //то посчитаем номер группы и начнем отталкиваться от ее начала
  if fElemGr>masGroupSize then
  begin
    fNum:=fElemGr-((fNumGr-1)*masGroupSize);
  end;

  sElemGr:=stepNum;
  //смещение до след группы
  sNumGr:=Trunc(sElemGr/masGroupSize);
  iG:=fNumGr;
  SetLength(masElemParam[iArrElemPar].arrNumGroup,i+1);
  masElemParam[iArrElemPar].arrNumGroup[i]:=iG;
  Inc(i);
  iG:=iG+sNumGr;
  //заполняем номера из расчета что максимальный номер цикла 4
  while iG<=MAXGROUPNUM do
  begin
    SetLength(masElemParam[iArrElemPar].arrNumGroup,i+1);
    masElemParam[iArrElemPar].arrNumGroup[i]:=iG;
    iG:=iG+sNumGr;
    Inc(i);
  end;
end;
//==============================================================================

//==============================================================================
//Процедура для коррекции медленных адресов для подгонки по самому медленному адресу
//==============================================================================
procedure slowAdrCorrection;
var
  i:Integer;
  j:Integer;
  masElemParamLen:integer;

  arrNumbersCikl:array[1..200] of integer;
  iCikl:Integer;
  //flagCikl:Boolean;
  iMinCiklNumber:Integer;
  minCiklNumber:Integer;
  arrCikl:array of Integer;
  maxAdrStepCikl:Integer;

  arrNumbersGr:array[1..200] of integer;
  iGr:Integer;
  //flagGr:Boolean;
  iMinGrNumber:Integer;
  minGrNumber:Integer;
  arrGr:array of Integer;
  maxAdrStepGr:Integer;
begin
  masElemParamLen:=length(masElemParam);
  iGr:=1;
  iCikl:=1;

  if ((vSlowFlagGr)and(vSlowFlagCikl)) then
  begin
    // выборка по всем адресам медленных должна происходить из конкретных циклов
    // конкретных групп
    //переписываем в спец массив все номера адресов с выборкой из конкретных групп
    //и циклов
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        if masElemParam[i].flagCikl then
        begin
          arrNumbersCikl[iCikl]:=i;
          inc(iCikl);
        end;

        if masElemParam[i].flagGroup then
        begin
          arrNumbersGr[iGr]:=i;
          inc(iGr);
        end;
      end;
    end;

    //цикл
    //ищем два параметра минимальное колличество циклов в адресах
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //и попутно максимальное смещение в адресах
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;

    iMinCiklNumber:=arrNumbersCikl[1];

    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;




    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //группа
    //ищем два параметра минимальное колличество групп в адресах
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //и попутно максимальное смещение в адресах
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];
    
    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

    {if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //нашли минимальное количество циклов для каждого адреса медленных
    //прогоняем цикл по всем медленным и приводим их все к самому медленному
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        //выборку их конкр. циклов производим
        masElemParam[i].flagCikl:=true;
        //выборку их конкр. групп не производим
        masElemParam[i].flagGroup:=true;
        //максимальный шаг смещения для всех адресов медленных максимальный
        if  maxAdrStepCikl>maxAdrStepGr then
        begin
          masElemParam[i].stepOutG:=maxAdrStepCikl;
        end
        else
        begin
          masElemParam[i].stepOutG:=maxAdrStepGr;
        end;


        //цикл
        //проверяем есть ли в массиве номеров циклов элементы
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //записываем во временный массив минимальное колич точек(групп) для кадого адреса
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumCikl:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:= masElemParam[iMinCiklNumber].arrNumCikl[j];
          end;
        end;

        //группа
        //проверяем есть ли в массиве номеров групп элементы
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //есть элементы. оставляем их минимальное количество
          //записываем во временный массив минимальное колич точек(групп) для каждого адреса
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumGroup:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:= masElemParam[iMinGrNumber].arrNumGroup[j];
          end;
        end;

      end;
    end;

  end
  else if ((not vSlowFlagGr)and(vSlowFlagCikl)) then
  begin
    //выборка происходит из конкретных циклов, всех групп
    //переписываем в спец массив все номера адресов с выборкой из конкретных групп
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        if masElemParam[i].flagCikl then
        begin
          arrNumbersCikl[iCikl]:=i;
          inc(iCikl);
        end;
      end;
    end;

    //ищем два параметра минимальное колличество групп в адресах
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //и попутно максимальное смещение в адресах
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;
    iMinCiklNumber:=arrNumbersCikl[1];
    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;

    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //нашли минимальное количество циклов для каждого адреса медленных
    //прогоняем цикл по всем медленным и приводим их все к самому медленному
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        //выборку их конкр. циклов производим
        masElemParam[i].flagCikl:=true;
        //выборку их конкр. групп не производим
        masElemParam[i].flagGroup:=false;
        //максимальный шаг смещения для всех адресов медленных максимальный
        masElemParam[i].stepOutG:=maxAdrStepCikl;


        //проверяем есть ли в массиве номеров циклов элементы
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //записываем во временный массив минимальное колич точек(групп) для кадого адреса
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumCikl:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:= masElemParam[iMinCiklNumber].arrNumCikl[j];
          end;
        end;
      end;
    end;
  end
  else
  begin
    //выборка происходит из конкретных групп всех циклов
    //переписываем в спец массив все номера адресов с выборкой из конкретных групп
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        if masElemParam[i].flagGroup then
        begin
          arrNumbersGr[iGr]:=i;
          inc(iGr);
        end;
      end;
    end;

    //ищем два параметра минимальное колличество групп в адресах
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //и попутно максимальное смещение в адресах
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];

    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

   { if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //нашли минимальное количество групп для каждого адреса медленных
    //прогоняем цикл по всем медленным и приводим их все к самому медленному
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        //выборку их конкр. циклов не производим
        masElemParam[i].flagCikl:=false;
        //выборку их конкр. групп производим
        masElemParam[i].flagGroup:=true;
        //максимальный шаг смещения для всех адресов медленных максимальный
        masElemParam[i].stepOutG:=maxAdrStepGr;

        //проверяем есть ли в массиве номеров групп элементы
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //есть элементы. оставляем их минимальное количество
          //записываем во временный массив минимальное колич точек(групп) для каждого адреса
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumGroup:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:= masElemParam[iMinGrNumber].arrNumGroup[j];
          end;
        end;
      end;
    end;
  end;
end;
//==============================================================================


//==============================================================================
//Процедура для коррекции контактных адресов для подгонки по самому медленному адресу
//==============================================================================
procedure contAdrCorrection;
var
  i:Integer;
  j:Integer;
  masElemParamLen:integer;

  arrNumbersCikl:array[1..200] of integer;
  iCikl:Integer;
  //flagCikl:Boolean;
  iMinCiklNumber:Integer;
  minCiklNumber:Integer;
  arrCikl:array of Integer;
  maxAdrStepCikl:Integer;

  arrNumbersGr:array[1..200] of integer;
  iGr:Integer;
  //flagGr:Boolean;
  iMinGrNumber:Integer;
  minGrNumber:Integer;
  arrGr:array of Integer;
  maxAdrStepGr:Integer;
begin
  masElemParamLen:=length(masElemParam);
  iGr:=1;
  iCikl:=1;

  if ((vSlowFlagGr)and(vSlowFlagCikl)) then
  begin
    // выборка по всем адресам медленных должна происходить из конкретных циклов
    // конкретных групп
    //переписываем в спец массив все номера адресов с выборкой из конкретных групп
    //и циклов
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        if masElemParam[i].flagCikl then
        begin
          arrNumbersCikl[iCikl]:=i;
          inc(iCikl);
        end;

        if masElemParam[i].flagGroup then
        begin
          arrNumbersGr[iGr]:=i;
          inc(iGr);
        end;
      end;
    end;

    //цикл
    //ищем два параметра минимальное колличество циклов в адресах
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //и попутно максимальное смещение в адресах
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;

    iMinCiklNumber:=arrNumbersCikl[1];

    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;

    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //группа
    //ищем два параметра минимальное колличество групп в адресах
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //и попутно максимальное смещение в адресах
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];

    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

    {if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //нашли минимальное количество циклов для каждого адреса медленных
    //прогоняем цикл по всем медленным и приводим их все к самому медленному
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        //выборку их конкр. циклов производим
        masElemParam[i].flagCikl:=true;
        //выборку их конкр. групп не производим
        masElemParam[i].flagGroup:=true;
        //максимальный шаг смещения для всех адресов медленных максимальный
        if  maxAdrStepCikl>maxAdrStepGr then
        begin
          masElemParam[i].stepOutG:=maxAdrStepCikl;
        end
        else
        begin
          masElemParam[i].stepOutG:=maxAdrStepGr;
        end;


        //цикл
        //проверяем есть ли в массиве номеров циклов элементы
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //записываем во временный массив минимальное колич точек(групп) для кадого адреса
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumCikl:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:= masElemParam[iMinCiklNumber].arrNumCikl[j];
          end;
        end;

        //группа
        //проверяем есть ли в массиве номеров групп элементы
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //есть элементы. оставляем их минимальное количество
          //записываем во временный массив минимальное колич точек(групп) для каждого адреса
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumGroup:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:= masElemParam[iMinGrNumber].arrNumGroup[j];
          end;
        end;

      end;
    end;

  end
  else if ((not vSlowFlagGr)and(vSlowFlagCikl)) then
  begin
    //выборка происходит из конкретных циклов, всех групп
    //переписываем в спец массив все номера адресов с выборкой из конкретных групп
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        if masElemParam[i].flagCikl then
        begin
          arrNumbersCikl[iCikl]:=i;
          inc(iCikl);
        end;
      end;
    end;

    //ищем два параметра минимальное колличество групп в адресах
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //и попутно максимальное смещение в адресах
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;

    iMinCiklNumber:=arrNumbersCikl[1];

    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;

    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //нашли минимальное количество циклов для каждого адреса медленных
    //прогоняем цикл по всем медленным и приводим их все к самому медленному
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        //выборку их конкр. циклов производим
        masElemParam[i].flagCikl:=true;
        //выборку их конкр. групп не производим
        masElemParam[i].flagGroup:=false;
        //максимальный шаг смещения для всех адресов медленных максимальный
        masElemParam[i].stepOutG:=maxAdrStepCikl;


        //проверяем есть ли в массиве номеров циклов элементы
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //записываем во временный массив минимальное колич точек(групп) для кадого адреса
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumCikl:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:= masElemParam[iMinCiklNumber].arrNumCikl[j];
          end;
        end;
      end;
    end;
  end
  else
  begin
    //выборка происходит из конкретных групп всех циклов
    //переписываем в спец массив все номера адресов с выборкой из конкретных групп
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        if masElemParam[i].flagGroup then
        begin
          arrNumbersGr[iGr]:=i;
          inc(iGr);
        end;
      end;
    end;

    //ищем два параметра минимальное колличество групп в адресах
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //и попутно максимальное смещение в адресах
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];

    //пробежим по всем адресам и найдем минимальное количество групп
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //опеределяем значения макмимального смещения при выборке точек из массив группы
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

    {if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //нашли минимальное количество групп для каждого адреса медленных
    //прогоняем цикл по всем медленным и приводим их все к самому медленному
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        //выборку их конкр. циклов не производим
        masElemParam[i].flagCikl:=false;
        //выборку их конкр. групп производим
        masElemParam[i].flagGroup:=true;
        //максимальный шаг смещения для всех адресов медленных максимальный
        masElemParam[i].stepOutG:=maxAdrStepGr;

        //проверяем есть ли в массиве номеров групп элементы
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //есть элементы. оставляем их минимальное количество
          //записываем во временный массив минимальное колич точек(групп) для каждого адреса
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //обнуляем массив для его перезаписи с нуля
          masElemParam[i].arrNumGroup:=nil;
          //перезаписываем номера групп для выборки из учета сколько минимально их должно быть
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //нет элементов.
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:= masElemParam[iMinGrNumber].arrNumGroup[j];
          end;
        end;
      end;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function FillContFlagCikl:Boolean;
var
  i:Integer;
  bool:Boolean;
  masElemParamLen:integer;
begin
  bool:=false;
  masElemParamLen:=length(masElemParam);
  for i:=0 to masElemParamLen-1 do
  begin
    if masElemParam[i].adressType=1 then
    begin
      if (masElemParam[i].flagCikl) then
      begin
        bool:=true;
        break;
      end;
    end;
  end;
  result:=bool;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function FillContFlagGr:Boolean;
var
  i:Integer;
  bool:Boolean;
  masElemParamLen:integer;
begin
  bool:=false;
  masElemParamLen:=length(masElemParam);
  for i:=0 to masElemParamLen-1 do
  begin
    if masElemParam[i].adressType=1 then
    begin
      if (masElemParam[i].flagGroup) then
      begin
        bool:=true;
        break;
      end;
    end;
  end;
  result:=bool;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function FillSlowFlagCikl:Boolean;
var
  i:Integer;
  bool:Boolean;
  masElemParamLen:integer;
begin
  bool:=false;
  masElemParamLen:=length(masElemParam);

  for i:=0 to masElemParamLen-1 do
  begin
    if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
    begin
      if (masElemParam[i].flagCikl) then
      begin
        bool:=true;
        break;
      end;
    end;
  end;
  result:=bool;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function FillSlowFlagGr:Boolean;
var
  i:Integer;
  bool:Boolean;
  masElemParamLen:integer;
begin
  bool:=false;
  masElemParamLen:=length(masElemParam);

  for i:=0 to masElemParamLen-1 do
  begin
    if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8))then
    begin
      if (masElemParam[i].flagGroup) then
      begin
        bool:=true;
        break;
      end;
    end;
  end;


  result:=bool;
end;
//==============================================================================

//==============================================================================
//Заполнение массива номеров циклов
//==============================================================================
procedure FillCiklArr(iArrElemPar:Integer;var fNum:Integer;var stepNum:Integer);
const
  MAXCIKLNUM=4;
var
  fNumCikl:Integer;
  sNumCikl:Integer;
  fElemC:Integer;
  sElemC:Integer;
  i:Integer;
  iC:Integer;
  fElemGr:Integer;
  sElemGr:Integer;
begin
  masElemParam[iArrElemPar].flagCikl:=True;
  i:=0;
  fElemC:=fNum;
  //узнаем номер первого цикла
  fNumCikl:=Trunc(fElemC/(masGroupSize*32))+1;
  //если первый элемент находится не в первом цикле,
  //то посчитаем номер цикла и начнем отталкиваться от его начала
  if fElemC>masGroupSize*32 then
  begin
    fNum:=fElemC-((fNumCikl-1)*masGroupSize*32);
  end;


  sElemC:=stepNum;
  //смещение до след цикла
  sNumCikl:=Trunc(sElemC/(masGroupSize*32));
  iC:=fNumCikl;
  SetLength(masElemParam[iArrElemPar].arrNumCikl,i+1);
  masElemParam[iArrElemPar].arrNumCikl[i]:=iC;
  Inc(i);
  iC:=iC+sNumCikl;
  //заполняем номера из расчета что максимальный номер цикла 4
  while iC<=MAXCIKLNUM do
  begin
    SetLength(masElemParam[iArrElemPar].arrNumCikl,i+1);
    masElemParam[iArrElemPar].arrNumCikl[i]:=iC;
    iC:=iC+sNumCikl;
    Inc(i);
  end;

  fElemGr:=fElemC-((fNumCikl-1)*masGroupSize*32);
  //sElemGr:=sElemC-((sNumCikl-1)*masGroupSize*32);

  //проверяем надо ли заполнять массив группы
  if sElemGr>masGroupSize then
  begin
    //заполнение массива группы после заполнения массива цикла
    FillGroupArr(iArrElemPar,fElemGr,sElemGr);
  end;

end;
//==============================================================================


//==============================================================================
//Разбор адресов ОрбитыM16
//==============================================================================
function AdressAnalyser(adressString: string; var imasElemParam: integer):Boolean;
var
  //Объявление для графиков
  iGraph: integer;
  flagM: boolean;
  //переменная для хранения ASCII-кода символа
  codAsciiGraph: integer;
  stepKoef: integer;
  //Множители для вычисления координат
  Ma, Mb, Mc, Md, Me, Mx: integer; //Ma=N1-1;Mb=N2-1;Mc=N3-1; и т.д
  //фазы для вычисления адреса
  //Fa=8, если K=0; Fa=4, если K=1; Fa=2, если K=2; аналогично для других
  Fa, Fb, Fc, Fd, Fe, Fx: integer;
  //начально смещ. в массиве, зависит от П1 или П2
  pBeginOffset: integer;
  flagBegin: boolean;
  stepOutGins: integer;
  offset: integer;

  //информативность адреса в виде целого числа
  infStrInt: integer;

  adrLength:Integer;

  //флаг для проверки успешности разбора адреса
  isOkAdr:Boolean;
begin
  isOkAdr:=True;
  stepOutGins := 1;
  offset := 0;
  pBeginOffset := 0;
  Fa := 0;
  Fb := 0;
  Fc := 0;
  Fd := 0;
  Fe := 0;
  Fx := 0;
  flagM := false;
  iGraph := 1;
  flagBegin := false;
  adrLength:=length(adressString);
  while iGraph <= adrLength do
  begin
    //первый символ должен быть обязательно М
    if adressString[iGraph] = 'M' then
    begin
      //М есть.
      flagM := true;
    end;

    if (flagM) then
    begin
      //M16
      if (adressString[iGraph + 1] = '1') and (adressString[iGraph + 2] = '6') then
      begin
        if ((adressString[iGraph + 3] = 'П') or (adressString[iGraph + 3] = 'п')) then
        begin
          if (adressString[iGraph + 4] = '1') then
          begin
            //задаем нач. смещение для выборки из массива
            pBeginOffset := 1;
          end;
          if (adressString[iGraph + 4] = '2') then
          begin
            //задаем нач. смещение для выборки из массива
            pBeginOffset := 2;
          end;
          flagBegin := true;
          iGraph := iGraph + 5;
          break;
        end
        else
        begin
          showMessage('Ошибка! Проверте разбираемые адреса,'
            + 'выбранная информативность им не соответствует!');
          //Application.Terminate;
          halt;
        end;
      end
      //остальные
      else
      begin
        //нач смещение
        pBeginOffset := 1;
        flagBegin := true;
        iGraph := iGraph + 3;
        break;
      end;
    end;
  end;

  if (flagBegin) then
  begin
    //обязательную часть проверили
    while {(adressString[iGraph]<>' ')} iGraph <= adrLength do
    begin
      codAsciiGraph := ord(adressString[iGraph]);
      // заполняем коэффициенты чтоб в конце посчитать номер и шаг.
      case codAsciiGraph of
        //Поиск А(а)
        65, 97:
        begin
          Ma := strToInt(adressString[iGraph + 1]);
          case infNum of
            0:
            begin
              //M16
              if ((Ma<1)or(Ma>8)) then
              begin
                //ошибка разбора адреса. неверный адрес
                isOkAdr:=False;
                Break;
              end;
            end;
            1:
            begin
              //M08
              if ((Ma<1)or(Ma>8)) then
              begin
                //ошибка разбора адреса. неверный адрес
                isOkAdr:=False;
                Break;
              end;
            end;
            2:
            begin
              //M04
              if ((Ma<1)or(Ma>4)) then
              begin
                //ошибка разбора адреса. неверный адрес
                isOkAdr:=False;
                Break;
              end;
            end;
            3:
            begin
              //M02
              if ((Ma<1)or(Ma>2)) then
              begin
                //ошибка разбора адреса. неверный адрес
                isOkAdr:=False;
                Break;
              end;
            end;
            4:
            begin
              //M01
              if (Ma<>1) then
              begin
                //ошибка разбора адреса. неверный адрес
                isOkAdr:=False;
                Break;
              end;
            end;
          end;

          Ma :=Ma-1;
          //Ma := strToInt(adressString[iGraph + 1]) - 1;

          stepKoef := strToInt(adressString[iGraph + 2]);
          case stepKoef of
            0:
            begin
              case infNum of
                0:
                begin
                  //M16
                  Fa := 8;
                end;
                1:
                begin
                  //M08
                  Fa := 8;
                end;
                2:
                begin
                  //M04
                  Fa := 4;
                end;
                3:
                begin
                  //M02
                  Fa := 2;
                end;
                4:
                begin
                  //M01
                  Fa := 1;
                end;
              end;
            end;
            1:
            begin
              case infNum of
                0:
                begin
                  //M16
                  Fa := 4;
                end;
                1:
                begin
                  //M08
                  Fa := 4;
                end;
                2:
                begin
                  //M04
                  Fa := 2;
                end;
                3:
                begin
                  //M02
                  Fa := 1;
                end;
                4:
                begin
                  //M01
                  //Fa := 0;
                  //если Fa < 1 то такого адреса быть не может
                  isOkAdr:=False;
                  Break;
                end;
              end;
            end;
            2:
            begin
              case infNum of
                0:
                begin
                  //M16
                  Fa := 2;
                end;
                1:
                begin
                  //M08
                  Fa := 2;
                end;
                2:
                begin
                  //M04
                  Fa := 1;
                end;
                3:
                begin
                  //M02
                  //Fa := 0;
                  //если Fa < 1 то такого адреса быть не может
                  //!! ошибка
                  isOkAdr:=False;
                  Break;
                end;
                4:
                begin
                  //M01
                  //Fa := 0;
                  //если Fa < 1 то такого адреса быть не может
                  //!! ошибка
                  isOkAdr:=False;
                  Break;
                end;
              end;
            end;
          end;
          stepOutGins := Fa;
          offset := offset + Ma;
        end;
        //Поиск B(b)
        66, 98:
        begin
          Mb := strToInt(adressString[iGraph + 1]);
          if ((Mb<1)or(Mb>8)) then
          begin
            //ошибка разбора адреса. неверный адрес
            isOkAdr:=False;
            Break;
          end;

          Mb :=Mb-1;
          stepKoef := strToInt(adressString[iGraph + 2]);
          case stepKoef of
            0:
            begin
              Fb := 8;
            end;
            1:
            begin
              Fb := 4;
            end;
            2:
            begin
              Fb := 2;
            end;
          end;
          offset := offset + Mb * stepOutGins;
          stepOutGins := stepOutGins * Fb;
        end;
        //Поиск C(c)
        67, 99:
        begin
          Mc := strToInt(adressString[iGraph + 1]);
          if ((Mc<1)or(Mc>8)) then
          begin
            //ошибка разбора адреса. неверный адрес
            isOkAdr:=False;
            Break;
          end;

          Mc :=Mc-1;

          stepKoef := strToInt(adressString[iGraph + 2]);
          case stepKoef of
            0:
            begin
              Fc := 8;
            end;
            1:
            begin
              Fc := 4;
            end;
            2:
            begin
              Fc := 2;
            end;
          end;
          offset := offset + Mc * stepOutGins;
          stepOutGins := stepOutGins * Fc;
        end;
        //Поиск D(d)
        68, 100:
        begin
          Md := strToInt(adressString[iGraph + 1]);
          if ((Md<1)or(Md>8)) then
          begin
            //ошибка разбора адреса. неверный адрес
            isOkAdr:=False;
            Break;
          end;

          Md :=Md-1;
          stepKoef := strToInt(adressString[iGraph + 2]);
          case stepKoef of
            0:
            begin
              Fd := 8;
            end;
            1:
            begin
              Fd := 4;
            end;
            2:
            begin
              Fd := 2;
            end;
          end;
          offset := offset + Md * stepOutGins;
          stepOutGins := stepOutGins * Fd;
        end;
        //Поиск E(e)
        69, 101:
        begin
          Me := strToInt(adressString[iGraph + 1]);
          if ((Me<1)or(Me>8)) then
          begin
            //ошибка разбора адреса. неверный адрес
            isOkAdr:=False;
            Break;
          end;

          Me :=Me-1;


          stepKoef := strToInt(adressString[iGraph + 2]);
          case stepKoef of
            0:
            begin
              Fe := 8;
            end;
            1:
            begin
              Fe := 4;
            end;
            2:
            begin
              Fe := 2;
            end;
          end;
          offset := offset + Me * stepOutGins;
          stepOutGins := stepOutGins * Fe;
        end;
        //Поиск X(x)
        88, 120:
        begin
          Mx := strToInt(adressString[iGraph + 1]);
          if ((Mx<1)or(Mx>8)) then
          begin
            //ошибка разбора адреса. неверный адрес
            isOkAdr:=False;
            Break;
          end;
          Mx:=Mx-1;

          stepKoef := strToInt(adressString[iGraph + 2]);
          case stepKoef of
            0:
            begin
              Fx := 8;
            end;
            1:
            begin
              Fx := 4;
            end;
            2:
            begin
              Fx := 2;
            end;
          end;
          offset := offset + Mx * stepOutGins;
          stepOutGins := stepOutGins * Fx;
        end;
        //Поиск T(t)
        84, 116:
        begin
          if ((adressString[iGraph + 1] = '0')and(adressString[iGraph + 2] = '1')and
                       (adressString[iGraph + 3] = '-')and(adressString[iGraph + 4] = '0')and
                       (adressString[iGraph + 5] = '1')
                  ) then

          begin

            //T01-01. Медленный аналоговый только 9 разрядов
            masElemParam[imasElemParam].adressType := 8;

          end
          else if ((adressString[iGraph + 1] = '0')and(adressString[iGraph + 2] = '5')) then
          begin
            //T05. Контактный 1.
            masElemParam[imasElemParam].adressType := 1;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '1')) then
          begin
            //T21 Быстрый 1.
            masElemParam[imasElemParam].adressType := 3;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '2')) then
          begin
            //T22. Быстрый 2.
            masElemParam[imasElemParam].adressType := 2;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '3')) then
          begin
            //T23. Быстрый 3.
            masElemParam[imasElemParam].adressType := 4;
          end else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '4')) then
          begin
            //T24 Быстрый 4.
            //свой тип для ГРЦ Макеева
            masElemParam[imasElemParam].adressType := 5;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '5')) then
          begin
            //T25. БУС. Для проверки
            masElemParam[imasElemParam].adressType := 6;
          end
          else if ((adressString[iGraph + 1] = '1')and(adressString[iGraph + 2] = '1')) then
          begin
            //T11. Температурный
            masElemParam[imasElemParam].adressType := 7;
          end
          else if ((adressString[iGraph + 1] = '0')and(adressString[iGraph + 2] = '1')) then
          begin
             //T01. Аналоговый 0.
            masElemParam[imasElemParam].adressType := 0;
            //указываем номер бита.
            //Используется только для контактных.
            masElemParam[imasElemParam].bitNumber := 0;

          end
          else
          begin
            //если ни один из типов не совпал
            isOkAdr:=False;
            Break;
          end;
        end;
        //Поиск P(p)
        80, 112:
        begin
          //вытаскиваем и записываем одну цифру.
          //и указываем булевской переменной что адрес контактный
          //указываем номер бита. Используется только
          //для контактных. Присваивание для системы.
          masElemParam[imasElemParam].bitNumber :=
            strToInt(adressString[iGraph + 1] + adressString[iGraph + 2]);
          if ((masElemParam[imasElemParam].bitNumber<1)or
              (masElemParam[imasElemParam].bitNumber>10)) then
          begin
            isOkAdr:=False;
          end;
          break;
        end;
      end;
      iGraph := iGraph + 3;
    end;

    if (isOkAdr) then
    begin
      infStrInt := StrToInt(adressString[2] + adressString[3]);
      //N1={Ma+Mb*Fa+Mc*Fa*Fb+Md*Fa*Fb*Fc+Me*Fa*Fb*Fc*Fd+Mx*Fa*Fb*Fc*Fd*Fe}
      //выбираем правильный первый элемент в зависимости от инф разб. адреса
      //M16
      if infStrInt = 16 then
      begin
        {if  ((pBeginOffset + 2 * offset)>(masGroupSize*32)) then
        begin
          //в цикле
          fElemC:=pBeginOffset + 2 * offset;
          //узнаем номер первого цикла
          iCikl:=Trunc(fElemC/(masGroupSize*32));
          //проверим в какой группе
          if (fElemC-(iCikl*(masGroupSize*32)))>masGroupSize then
          begin
            fElemGr:=fElemC-(iCikl*(masGroupSize*32));
            iGr:=Trunc(fElemGr/masGroupSize);
            //узнаем номер элемента в первой группе
            masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
          end
          else
          begin
            //узнаем номер элемента в первой группе
            masElemParam[imasElemParam].numOutElemG:=fElemC-(iCikl*(masGroupSize*32));
          end;
        end
        else if  ((pBeginOffset + 2 * offset)>masGroupSize) then
        begin
          //в группе
          fElemGr:=pBeginOffset + 2 * offset;
          //узнаем номер первой группы
          iGr:=Trunc(fElem/masGroupSize);
          //узнаем номер элемента в первой группе
          masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
        end
        else
        begin
          //в каждой группе каждого цикла
          masElemParam[imasElemParam].numOutElemG := pBeginOffset + 2 * offset;
        end; }
        masElemParam[imasElemParam].numOutElemG := pBeginOffset + 2 * offset;
      end
      //остальные
      else
      begin
        {if  ((pBeginOffset + offset)>(masGroupSize*32)) then
        begin
          //в цикле
          fElemC:=pBeginOffset + offset;
          //узнаем номер первого цикла
          iCikl:=Trunc(fElemC/(masGroupSize*32));
          //проверим в какой группе
          if (fElemC-(iCikl*(masGroupSize*32)))>masGroupSize then
          begin
            fElemGr:=fElemC-(iCikl*(masGroupSize*32));
            iGr:=Trunc(fElemGr/masGroupSize);
            //узнаем номер элемента в первой группе
            masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
          end
          else
          begin
            //узнаем номер элемента в первой группе
            masElemParam[imasElemParam].numOutElemG:=fElemC-(iCikl*(masGroupSize*32));
          end;
        end
        else if  ((pBeginOffset + offset)>masGroupSize) then
        begin
          //в группе
          fElemGr:=pBeginOffset + offset;
          //узнаем номер первой группы
          iGr:=Trunc(fElem/masGroupSize);
          //узнаем номер элемента в первой группе
          masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
        end
        else
        begin
          //в каждой группе каждого цикла
          masElemParam[imasElemParam].numOutElemG := pBeginOffset + offset;
        end;}
        masElemParam[imasElemParam].numOutElemG := pBeginOffset + offset;
      end;

      //выставляем шаг для выборки след. точки в завис. от информативности адреса
      case infStrInt of
        16:
        begin
          masElemParam[imasElemParam].stepOutG := 2 * stepOutGins; //T=Fa*Fb*Fc*Fd*Fe*Fx
        end;
        8:
        begin
          masElemParam[imasElemParam].stepOutG := stepOutGins;
        end;
        4:
        begin
          masElemParam[imasElemParam].stepOutG := stepOutGins;
          //masElemParam[imasElemParam].stepOutG := round(stepOutGins / 2);
        end;
        2:
        begin
          masElemParam[imasElemParam].stepOutG := stepOutGins;
          //masElemParam[imasElemParam].stepOutG := round(stepOutGins / 4);
        end;
        1:
        begin
          masElemParam[imasElemParam].stepOutG := stepOutGins;
          //masElemParam[imasElemParam].stepOutG := round(stepOutGins / 8);
        end;
      end;

      if  (masElemParam[imasElemParam].stepOutG>(masGroupSize*32)) then
      begin
        //смещение больше одного цикла
        //заполняем массив циклов с номерами циклов из которых надо брать слова
        FillCiklArr(imasElemParam,masElemParam[imasElemParam].numOutElemG,
          masElemParam[imasElemParam].stepOutG );
      end
      else if (masElemParam[imasElemParam].stepOutG>masGroupSize) then
      begin
        FillGroupArr(imasElemParam,masElemParam[imasElemParam].numOutElemG,
          masElemParam[imasElemParam].stepOutG );
      end;

      //установим по умолчанию значение текущей
      //выводимой точки в 1 для всех адресов
      masElemParam[imasElemParam].numOutPoint := 1;
      //masElemParam[imasElemParam].numOutElemG:=
        //masElemParam[imasElemParam].numOutElemG+numPoint*
          //masElemParam[imasElemParam].stepOutG; //N=N1+nT
    end;
  end
  else
  begin
    isOkAdr:=False;
  end;
  //вернули состояние разбора адреса
  Result:=isOkAdr;
end;
//==============================================================================



//==============================================================================
//Заполнения массива параметров анализируемых адресов ОрбитыМ16
//==============================================================================
function FillAdressParam:boolean;
var
  //переменная счетчик для разбора только нужных адресов
  adrCount: integer;
  //макс кол. адресов
  iAdr: integer;
  maxAdrNum:Integer;
  //флаг успешности разбора адресов
  isOk:Boolean;
begin
  isOk:=True;
  //Обнуление динамического массива
  masElemParam := nil;
  iAdr := 0;
  maxAdrNum:=form1.OrbitaAddresMemo.Lines.Count - 1;
  for adrCount := 0 to maxAdrNum  do
  begin
    //при пробеге по адресам проверяем адрес это или логический разделитель
    if  form1.OrbitaAddresMemo.Lines.Strings[adrCount]<>'---' then
    begin
      //адрес
      //выделим память на элемент массива параметров
      setlength(masElemParam, iAdr  + 1);
      //если адрес разобран успешно то вернет true
      isOk:=AdressAnalyser(form1.OrbitaAddresMemo.Lines.Strings[adrCount], iAdr);
      if (not isOk) then
      begin
        //очередной адрес разобран с ошибкой
        //дальше адреса не разбираем
        Break;
      end;
      inc(iAdr);
    end;
  end;

  //если проблем при разборе адресов не было то начинаем работу
  if (isOk) then
  begin
    //запомнием максимальное количество адресов
    iCountMax := iAdr;
    //подсчитаем сколько каких адресов есть в работе
    CountAddres;
    //masElemParam:=nil;

    //проверим есть ли среди медленных параметров очень медленные выборка не из всех групп
    //T01 и T01-01
    vSlowFlagGr:=FillSlowFlagGr;
    //проверим есть ли среди медленных параметров очень медленные выборка не из всех циклов
    vSlowFlagCikl:=FillSlowFlagCikl;
    //определяем для медленных параметров коррекцию
    //для отображения всех адресов с ориентацией на самый медленный
    if ((vSlowFlagCikl)or(vSlowFlagGr)) then
    begin
      slowAdrCorrection;
    end;

    //проверим есть ли среди контактных параметров очень медленные выборка не из всех групп
    vContFlagGr:=FillContFlagGr;
    //проверим есть ли среди контактных параметров очень медленные выборка не из всех циклов
    vContFlagCikl:=FillContFlagCikl;

    if ((vContFlagCikl)or(vContFlagGr)) then
    begin
      contAdrCorrection;
    end;

    vSlowFlag:=(vSlowFlagGr){and}or(vSlowFlagCikl);
    vContFlag:=(vContFlagGr){and}or(vContFlagCikl);

    //masElemParam:=nil;
  end;

  Result:=isOk;

end;
//==============================================================================

//==============================================================================
//Функция задержки
//==============================================================================

procedure Wait(value: integer);
var
  i: integer;
begin
  for i := 1 to value do
  begin
    sleep(3);
    application.ProcessMessages;
  end;
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
procedure GetAddrList;
var
  maxAdrNum:Integer;
  iAdr:integer;
  adrCount:integer;
begin
  arrAddrOk:=nil;
  iAdr := 0;
  maxAdrNum:=form1.OrbitaAddresMemo.Lines.Count - 1;
  for adrCount := 0 to maxAdrNum  do
  begin
    if form1.OrbitaAddresMemo.Lines.Strings[adrCount]<>'' then
    begin
      //исключаем пустые строки
      //выделим память на элемент массива параметров
      setlength(arrAddrOk, iAdr  + 1);
      arrAddrOk[iAdr]:=form1.OrbitaAddresMemo.Lines.Strings[adrCount];
      inc(iAdr);
    end;
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure SetOrbAddr;
var
  iAdr:Integer;
  maxAdrNum:integer;
begin
  //очищаем список адресов
  form1.OrbitaAddresMemo.Clear;
  maxAdrNum:=Length(arrAddrOk)-1;
  for iAdr:=0 to maxAdrNum do
  begin
    form1.OrbitaAddresMemo.Lines.Add(arrAddrOk[iAdr]);
  end;
end;
//==============================================================================

procedure TForm1.startReadACPClick(Sender: TObject);
var
  intPointNum:integer;
begin
  intPointNum:=10000;
  //объект для работы с сигналом
  if infNum=0 then
  begin
    dataM16 := TdataM16.CreateData;
  end
  else
  begin
    dataMoth := TdataMoth.CreateData;
  end;

  testOutFalg:=true;

  //setlength(data.masFastVal, trunc(form1.fastGist.BottomAxis.Maximum)-2);
  //data.masFastVal:=nil;
  //intPointNum:=trunc(form1.fastGist.BottomAxis.Maximum);
  masFastVal:=nil;
  setlength({data.}masFastVal, intPointNum);
  //проиниц. счетчики для подсч. колич. каждого типа адресов
  //ам
  acumAnalog := 0;
  //темп
  acumTemp:=0;
  //ак
  acumContact := 0;
  //б
  acumFast := 0;
  //бус
  acumBus := 0;

  //проверим по флагам откуда надо загружать адреса каналов
  TestNeedsAdrF;

  //Получение правильного списка адресов
  GetAddrList;
  //Установка списка правильных адресов
  SetOrbAddr; 
  //отключение масштабирования
  form1.gistSlowAnl.AllowZoom:=false;
  form1.gistSlowAnl.AllowPanning:=pmNone;

  form1.fastGist.AllowZoom:=false;
  form1.fastGist.AllowPanning:=pmNone;

  form1.tempGist.AllowZoom:=False;
  form1.tempGist.AllowPanning:=pmNone;
  //проверим правильность адресов
  if (GenTestAdrCorrect) then
  begin
    //объект для работы с ТЛМ
    tlm := Ttlm.CreateTLM;
    //положение ползунка скорости
    form1.tlmPSpeed.Position := 3;
    form1.tlmPSpeed.Enabled:=true;
    if form1.startReadACP.Caption = 'Прием' then
    //старт
    begin
      //AssignFile(textTestFile,'TextTestFile.txt');
      //Rewrite(textTestFile);
      //AssignFile(swtFile,ExtractFileDir(ParamStr(0)) + '/Report/' + '777.txt');
      //ReWrite(swtFile);
      //проиниц. флаг выхода из всех циклов
      flagEnd:=false;
      //заполнение массива параметров.
      if (FillAdressParam) then
      begin
        form1.startReadACP.Caption := 'Стоп';
        //режим работы приема
        form1.tlmWriteB.Enabled := true;
        form1.startReadTlmB.Enabled:=false;
        form1.propB.Enabled:=false;

        //Подготовка АЦП к работе
        if  (not boolFlg) then
        begin
          acp := Tacp.InitApc;
          //подготовимся к работе с АЦП
          acp.CreateApc;

          //включаем сбор данных с АЦП
          pModule.START_ADC();
          boolFlg:=true;
        end;
        {else
        begin
          acp := Tacp.InitApc;
          //
          pModule.START_ADC();
        end;}
        flagACPWork:=True;
        form1.TimerOutToDia.Enabled:=true;
      end
      else
      begin
        tlm := nil;
        //положение ползунка скорости
        form1.tlmPSpeed.Position := 3;
        form1.tlmPSpeed.Enabled:=false;
        ShowMessage('В списке найдены неправильные адреса!');
      end;
    end
    else
    //стоп
    begin
      flagEnd:=true;
      flagACPWork:=False;
      Form1.mmoTestResult.Clear;
      form1.startReadACP.Caption:= 'Прием';
      graphFlagFastP := false;
      //sleep(50);
      //pModule.STOP_ADC();

      //wait(50);

      flagACPWork:=False;
      //wait(50);

       //объект для работы с сигналом
      if infNum=0 then
      begin
        FreeAndNil(dataM16);
      end
      else
      begin
        FreeAndNil(dataMoth);
      end;
      FreeAndNil(tlm);

      form1.diaSlowAnl.Series[0].Clear;
      form1.gistSlowAnl.Series[0].Clear;
      form1.diaSlowCont.Series[0].Clear;
      form1.fastDia.Series[0].Clear;
      form1.fastGist.Series[0].Clear;
      Form1.tempDia.Series[0].Clear;
      Form1.tempGist.Series[0].Clear;
      
      //ReadThreadErrorNumber:=4;
      {CloseHandle(hReadThread);
      WaitForSingleObject(hReadThread, 5500);    //INFINITE
      if hReadThread <> THANDLE(nil) then
      begin
        Application.ProcessMessages;
        sleep(500);
        hReadThread:=THANDLE(nil);
      end;
      orbOkCounter:=0;}
      {graphFlagFastP := false;
      //Application.ProcessMessages;
      sleep(50);
      //Application.ProcessMessages;

      if ((form1.tlmWriteB.Enabled)and
          (not form1.startReadTlmB.Enabled)and
          (not form1.propB.Enabled))  then
      begin
        //остановим работу с АЦП
        pModule.STOP_ADC();
      end;
      //завершим все работающие циклы
      flagEnd:=true;
      wait(20);
      //while (True) do Application.ProcessMessages; //!!!!
      WinExec(PChar('OrbitaMAll.exe'), SW_ShowNormal);
      wait(20);
      //завершим приложение по человечески.
      Application.Terminate;}
    end;
  end
  else
  begin
    ShowMessage('Проверьте правильность адресов!');
  end;
end;

//закрытие программы и следовательно должны закрываться
//все открытые потоки если они в работе.

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //если закрытие приложения при приеме то остановим работу с АЦП. перед закрытием.
  if ((form1.tlmWriteB.Enabled)and(not form1.startReadTlmB.Enabled)and
      (not form1.propB.Enabled))  then
  begin
    //остановим работу с АЦП
    pModule.STOP_ADC();
  end;

  //завершим все работающие циклы
  flagEnd:=true;
  wait(20);
  //завершим приложение по человечески.
  Application.Terminate;
  //halt
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  path:string;

begin
  flagACPWork:=False;
  flagTrue:=false;
  orbOk:=False;
  orbOkCounter:=0;
  boolFlg:=false;
  csk:=TCriticalSection.Create;
  //настройка графиков
  form1.diaSlowAnl.LeftAxis.Maximum := 1025.0;
  form1.gistSlowAnl.BottomAxis.Maximum := 300;
  form1.gistSlowAnl.BottomAxis.Minimum := 0;
  form1.gistSlowAnl.LeftAxis.Maximum := 1025;
  form1.gistSlowAnl.LeftAxis.Minimum := 0;
  path:=ExtractFileDir(ParamStr(0))+'\ConfigDir\property.ini';
  propIniFile:=TIniFile.Create(path);
  //читаем из файла содержимое строки параметра path.
  propStrPath:=propIniFile.ReadString('lastPropFile','path','');
  //проверяем есть ли такой файл настроек на ПК.
  if FileExists(propStrPath) then
  begin
    //есть, но это первый запуск ПО
    if propStrPath='' then
    begin
      //доступность начальных инструментов
      //адр. Орб.
      form1.propB.Enabled := true;
      //прием
      form1.startReadACP.Enabled := false;
      //чтение
      form1.startReadTlmB.Enabled := false;
      //запись в tlm
      form1.tlmWriteB.Enabled := false;
      //панель чтения
      form1.PanelPlayer.Enabled := false;
      //ползунок положения в файле
      form1.TrackBar1.Enabled := false;
      //ползунок скорости
      form1.tlmPSpeed.Enabled:=false;
      //сохранение в файл адресов
      form1.saveAdrB.Enabled:=false;
    end
    else
    //есть.
    begin
      form1.propB.Enabled := true;
      form1.startReadACP.Enabled := true;
      form1.startReadTlmB.Enabled := true;
      form1.tlmWriteB.Enabled := false;
      form1.PanelPlayer.Enabled := false;
      form1.TrackBar1.Enabled := false;
      form1.tlmPSpeed.Enabled:=false;
      form1.saveAdrB.Enabled:=true;
    end;
    //проверим какие адреса каналов надо загружать
    testNeedsAdrF;
    //Получение правильного списка адресов
    GetAddrList;
    //Установка списка правильных адресов
    SetOrbAddr;
    GenTestAdrCorrect;
  end
  else
  //такого файла нет. Перезапишем его.
  begin
    form1.propB.Enabled := true;
    form1.startReadACP.Enabled := false;
    form1.startReadTlmB.Enabled := false;
    form1.tlmWriteB.Enabled := false;
    form1.PanelPlayer.Enabled := false;
    form1.TrackBar1.Enabled := false;
    form1.tlmPSpeed.Enabled:=false;
    form1.saveAdrB.Enabled:=false;
  end;
  //закрытли файл настроек
  propIniFile.Free;
end;

procedure TForm1.upGistSlowSizeClick(Sender: TObject);
begin
  form1.downGistSlowSize.Enabled := true;
  if form1.gistSlowAnl.BottomAxis.Maximum <=form1.gistSlowAnl.BottomAxis.Minimum + 20 then
  begin
    form1.upGistSlowSize.Enabled := false
  end
  else
  begin
    form1.gistSlowAnl.BottomAxis.Maximum := form1.gistSlowAnl.BottomAxis.Maximum - 10;
  end;
end;

procedure TForm1.downGistSlowSizeClick(Sender: TObject);
begin
  form1.upGistSlowSize.Enabled := true;
  form1.gistSlowAnl.BottomAxis.Maximum := form1.gistSlowAnl.BottomAxis.Maximum + 10;
  if form1.gistSlowAnl.BottomAxis.Maximum >= 700 then
  begin
    form1.downGistSlowSize.Enabled := false;
  end;
end;

procedure TForm1.Series1Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //избегаем доступа к мемо. и в случае доступности
  //мемо делаем его недоступным и наоборот
  //form1.OrbitaAddresMemo.Enabled:= not form1.OrbitaAddresMemo.Enabled;
  //form1.Memo1.Enabled:= not form1.Memo1.Enabled;
  if ({data.}graphFlagSlowP) then
  begin
    form1.gistSlowAnl.Series[0].Clear;
    {data.}graphFlagSlowP := false;
  end
  else
  begin
    {data.}graphFlagSlowP := true;
    //form1.dia.Canvas.MoveTo(form1.dia.Width-1051,form1.dia.Height-33);
    {data.}chanelIndexSlow := ValueIndex;
  end;
end;

procedure TForm1.TimerOutToDiaTimer(Sender: TObject);
var
  orbAdrCount: integer;
begin
  if (flagACPWork) then
  begin
    //form1.Memo1.Lines.Add('Таймер!:');
    //осуществление разбора очередной строки адреса.
    orbAdrCount := 0;
    //счетчик для подсчета количества аналоговых каналов
    {data.}analogAdrCount := 0;
    //счетчик для подсчета количества контактных каналов
    {data.}contactAdrCount := 0;
    //отчистка формы для предидущей группы
    //form1.diaSlowAnl.Series[0].Clear;
    form1.diaSlowCont.Series[0].Clear;
    form1.fastDia.Series[0].Clear;


    //sleep(3);
    //последовательно разбираем строка за строкой адреса
    //Орбиты, вынимаем нужные значения и выводим на график
    while orbAdrCount <= iCountMax - 1 do // iCountMax-1
    begin
      outToDia(
        masElemParam[orbAdrCount].numOutElemG,
        masElemParam[orbAdrCount].stepOutG,
        masGroupSize,orbAdrCount,
        masElemParam[orbAdrCount].adressType,
        masElemParam[orbAdrCount].bitNumber,
        masElemParam[orbAdrCount].numBusThread,
        masElemParam[orbAdrCount].adrBus,
        masElemParam[orbAdrCount].numOutPoint,
        masElemParam[orbAdrCount].flagGroup,
        masElemParam[orbAdrCount].flagCikl);
      inc(orbAdrCount);
    end;
    form1.TimerOutToDia.Enabled := false; 
  end; 
end;




//==============================================================================
//Объектные функции
//==============================================================================

//==============================================================================
//
//==============================================================================

constructor Tdata.CreateData;
begin
  iTempArr:=0;
  iSlowArr:=0;
  iContArr:=0;
  outTempAdr:=0;






  
  //флаг для поиска маркера для зап. массива БУС
  flagWtoBusArray:=false;



  porog := 0;
  //нач. иниц. флага подсчета порога
  //modC := false;


  //счетчик чтения из fifo битов
  fifoLevelRead := 1;
  //счетчик для записи в массив fifo битов
  fifoLevelWrite := 1;
  //счетчик количества обработанных точек
  fifoBufCount := 0;

  //счетчики для подсчета количества точек выше и ниже полога
  //numRetimePointUp := 0;
  //numRetimePointDown := 0;



  bufNumGroup:=0;



  //fraseCount := 1;
  //fraseNum:=1;
  //groupCount := 1;






  

  
  //строка для сбора слова.
  //codStr:='';
  


 
  






  //SetLength(busArray,NUM_BUS_ELEM);
  iBusArray:=0;
  //bool:=true;
end;
//==============================================================================



//==============================================================================
//
//==============================================================================
{procedure TData.AddValueInMasDiaValue(numFOut:integer;step:integer;
  masGSize:integer;var numP:integer );
var
  nPoint:integer;
  begin
  nPoint:=numFOut;
  while nPoint<=masGSize do
  begin
    //заказываем память под 1 элемент
    setlength(masDiaValue,numP+1);
    masDiaValue[numP]:=masGroup[nPoint];
    inc(numP);
    nPoint:=nPoint+step;
  end;
end;}
//==============================================================================

//==============================================================================
//Сбор 32-х разрядных слов и выводим в файл
//==============================================================================
procedure FillSwatWord;
var
  iOrbWord:integer;
  wordToFile:integer;
begin
  iOrbWord:=1;
  wordToFile:=0;
  //сбор слов вариант 2
  while iOrbWord<={length(masGroup)}masGroupSize do
  begin
     //проверяем 11 бит, холостое слово или нет
    if (masGroup[iOrbWord] and 1024)=1024 then
    begin
      //нашли начало слова
      //взяли 10 мл. битов
      wordToFile:=masGroup[iOrbWord] and 1023; //П1А12
      //след. 11 ст. битов
      wordToFile:=(masGroup[iOrbWord+1] shl 10)+wordToFile;//П2А12
      //след. 11 ст. битов
      wordToFile:=(masGroup[iOrbWord+2] shl 11)+wordToFile;//П1А22
      //writeln(swtFile,intToStr(wordToFile));
    end;
    iOrbWord:=iOrbWord+4;
  end;
  //разбор 1 потока массива группы   1024 слова Орбиты
  {while iOrbWord<=length(masGroup)-1 do
  begin
    //проверяем 11 бит, холостое слово или нет
    if (masGroup[iOrbWord] and 1024)=1024 then
    begin
      //нашли начало слова
      //взяли 10 мл. битов
      wordToFile:=masGroup[iOrbWord] and 1023;
      //след. 11 ст. битов
      wordToFile:=(masGroup[iOrbWord+2] shl 10)+wordToFile;
      //след. 11 ст. битов
      wordToFile:=(masGroup[iOrbWord+4] shl 11)+wordToFile;
      writeln(swtFile,intToStr(wordToFile));
    end;
    iOrbWord:=iOrbWord+5;
  end;

  iOrbWord:=1;
  //разбор 2 потока массива группы   512 слов Орбиты
  while iOrbWord<=round(length(masGroup)/2)-1 do
  begin
    //проверяем 11 бит, холостое слово или нет
    if (masGroup[iOrbWord] and 1024)=1024 then
    begin
      //взяли 10 мл. битов
      wordToFile:=masGroup[iOrbWord] and 1023;
      //след. 11 ст. битов
      wordToFile:=(masGroup[iOrbWord+2] shl 10)+wordToFile;
      //след. 11 ст. битов
      wordToFile:=(masGroup[iOrbWord+4] shl 11)+wordToFile;
      writeln(swtFile,intToStr(wordToFile));
    end;
    iOrbWord:=iOrbWord+5;
  end;}
end;
//==============================================================================

//==============================================================================
//Сбор значения БУС
//на вход приходит два 12 разрядных значений
//==============================================================================
function Tdata.BuildBusValue(highVal:word;lowerVal:word):word;
var
  busValBuf:word;
  bufH,bufL:word;
begin
  busValBuf:=0;
  bufH:=highVal and 2040;
  bufH:=bufH shr 3;
  bufL:=lowerVal and 2040;
  bufL:=bufL shr 3;
  bufH:=bufH shl 8;
  //в обоих переданных словах отбрасываем 12,3,2 и 1 бит.
  busValBuf:=bufH+bufL;
  //form1.Memo1.Lines.Add(intToStr(busValBuf));
  result:=busValBuf;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function TData.CollectBusArray(var iBusArray:integer):boolean;
var
  orbAdrCount:integer;
  maxPointInAdr:integer;
  nPoint:integer;
  offsetForYalkBus:short;
  highVal:word;
  lowerVal:word;
  iParity:integer;

  iCount:integer;

  lll:integer;

  busArrLen:integer;
begin
  //вывод для БУС параметров
  if form1.PageControl1.ActivePageIndex = 4 then
  begin
    orbAdrCount:=0;
    while orbAdrCount <= iCountMax - 1 do // iCountMax-1
    begin
      if masElemParam[orbAdrCount].adressType = 6 then
      begin
        iParity:=0;
        //вычисляем количество точек в пришедшем адресе
        maxPointInAdr := 0;
        nPoint := masElemParam[orbAdrCount].numOutElemG;
        while nPoint <= {length(masGroup)}masGroupSize do
        begin
          inc(maxPointInAdr);
          nPoint := nPoint + masElemParam[orbAdrCount].stepOutG;
        end;
        offsetForYalkBus := masElemParam[orbAdrCount].stepOutG *
        (masElemParam[orbAdrCount].numOutPoint - 1);
        nPoint := masElemParam[orbAdrCount].numOutElemG + offsetForYalkBus;
        nPoint := nPoint{ - 1};
        // lll:=length(masGroup);
        // form1.Memo1.Lines.Add(intToStr(lll));
        // lll:=length(masGroupAll);
        // form1.Memo1.Lines.Add(intToStr(lll));
        while nPoint<{length(masGroup)}masGroupSize-masElemParam[orbAdrCount].stepOutG do
        begin
          offsetForYalkBus := masElemParam[orbAdrCount].stepOutG *
          (masElemParam[orbAdrCount].numOutPoint - 1);
          nPoint := masElemParam[orbAdrCount].numOutElemG + offsetForYalkBus;
          nPoint := nPoint{ - 1};
          if nPoint=1024 then
          begin
            //form1.Memo1.Lines.Add(intToStr(masGroupAll[nPoint])
            // +' '+intToStr(nPoint));
          end;
          if iParity mod 2 =0 then
          begin
            //запоминаем значение слова Орбиты со старшим байтом слова БУС
            highVal:=masGroupAll[nPoint];
            //form1.Memo1.Lines.Add(intToStr(masGroupAll[nPoint])
            // +' '+intToStr(nPoint));
          end
          else
          begin
            //запоминаем значение слова Орбиты с младшим байтом слова БУС
            lowerVal:=masGroupAll[nPoint];
            //form1.Memo1.Lines.Add(intToStr(masGroupAll[nPoint])
            //+' '+intToStr(nPoint));
            //ищем маркер (последовательность из 65535,65535,65535)
            if  ((BuildBusValue(highVal,lowerVal)=65535)and   //!!77
              (not flagWtoBusArray))  then
            begin
              busArray[iBusArray]:=BuildBusValue(highVal,lowerVal);
              inc(iBusArray);
              if iBusArray=3 then
              begin
                //заполнили 3 значения
                if ((busArray[iBusArray-1]=65535)and(busArray[iBusArray-2]=65535)and
                (busArray[iBusArray-3]=65535)) then
                begin
                  //нашли теперь, можем заполнять массив
                  flagWtoBusArray:=true;
                end
                else
                begin
                  //не нашли, ищем и записываем все заново
                  iBusArray:=0;
                  flagWtoBusArray:=false;
                end;
              end;
            end
            else
            begin
              busArray[iBusArray]:=BuildBusValue(highVal,lowerVal);
              inc(iBusArray);
              if iBusArray=32{96} then
              begin
                busArrLen:=length(busArray);
                for iCount:=0 to busArrLen-1 do
                begin
                  //form1.Memo1.Lines.Add(intToStr(busArray[iCount])
                  //+' '+intToStr(iCount));
                end;
              // showMessage('!!!!');
              end;
            end;

            if (flagWtoBusArray) then
            begin
              //маркер до этого нашли. заполняем массив
              busArray[iBusArray]:=BuildBusValue(highVal,lowerVal);
              inc(iBusArray);
            end;
          end;

          inc(iParity);
          inc(masElemParam[orbAdrCount].numOutPoint);
        end;
        if masElemParam[orbAdrCount].numOutPoint > maxPointInAdr then
        begin
          masElemParam[orbAdrCount].numOutPoint := 1;
        end;
      end;
      inc(orbAdrCount);
    end;
  end;

  if iBusArray=96 then
  begin
    iBusArray:=0;
    flagWtoBusArray:=false;
    result:=true;
  end
  else
  begin
    result:=false;
  end;
end;
//==============================================================================



//==============================================================================
//Процедура ведения отчета о проверке
//==============================================================================

{procedure Tdata.SaveReport;
var
  str: string;
  i: integer;
begin
  //если у нас автоматическая проверка, то
  if (ParamStr(1) = 'StartAutoTest') then
  begin
    //проверяем был ли передан параметр2.
    //Если нет то генерируем обычный внутренний отчет
    if (ParamStr(2) = '') then
      //нет
    begin
      str := 'Тест_ЯЛК_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.txt';
      for i := 1 to length(str) do
        if (str[i] = ':') then
          str[i] := '.';
      form1.Memo1.Lines.SaveToFile(ExtractFileDir(ParamStr(0)) + '/Report/' + str);
    end
    else
      //да
    begin
      //связываем ф.п с переданным файлом
      AssignFile(ReportFile, ParamStr(2));
      //проверяем есть ли такой файл
      if (FileExists(ParamStr(2))) then
        //есть, открываем файл на дозапись
      begin
        Append(ReportFile);
      end
      else
        //нет
      begin
        //открываем на запись
        ReWrite(ReportFile);
      end;
      writeln(ReportFile, form1.Memo1.Text);
      closefile(ReportFile);
    end
  end
  else
    //ручная проверка. внутренний отчет
  begin
    str := 'Тест_ЯЛК_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.txt';
    for i := 1 to length(str) do
      if (str[i] = ':') then
        str[i] := '.';
    form1.Memo1.Lines.SaveToFile(ExtractFileDir(ParamStr(0)) + '/Report/' + str);
  end;
end;}
//==============================================================================



//==============================================================================
//Процедура для работы с системным файлом . В него пишем признак проверки
//==============================================================================

procedure Tdata.WriteSystemInfo(value: string);
begin
  //связ. файла System с файловой переменной
  AssignFile(SystemFile, 'System');
  //открытие его  на запись
  ReWrite(SystemFile);
  //запись в файл переданного значения
  writeln(SystemFile, value);
  //закрытие файла
  closefile(SystemFile);
end;
//==============================================================================

//==============================================================================
//Функция вычисления среднего значения.
//Возвращает среднее значение в целочисленном формате
//==============================================================================

function Tdata.AvrValue(firstOutPoint: integer; nextPointStep: integer;
  masGroupS: integer): integer;
var
  sum: integer;
  pointCh: integer;
begin
  sum := 0;
  pointCh := 0;
  while firstOutPoint <= masGroupS do
  begin
    sum := sum + masGroup[firstOutPoint] shr 1;
    inc(pointCh);
    firstOutPoint := firstOutPoint + nextPointStep;
  end;
  result := round(sum / pointCh);
end;
//==============================================================================

//==============================================================================
//Вывод на диаграмму число сбоев по МГ
//==============================================================================
procedure TData.OutMG(errMG:Integer);
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



//==============================================================================
//
//==============================================================================
procedure TData.ReInitialisation;
begin
//  прием доступ
  //form1.startReadACP.Enabled := true;
//  запись в tlm
  //form1.tlmWriteB.Enabled := false;
//  особождаем память объекта ацп
//  !!!
//  acp.Free;
end;
//==============================================================================

//M08,04,02,01

//==============================================================================
//Процедура для тестирования поиска маркера фразы. Выводит наглядно данные
//==============================================================================
procedure TData.TestSMFOutDate(numPointDown:Integer;numCurPoint:integer;numPointUp:integer);
var
  numP:Integer;
begin
  form1.Memo1.Lines.Add('Пороговое значение!!! '+intTostr(porog));

  //до точки
  for numP:=numCurPoint-numPointDown to  numCurPoint-1 do
  begin
    form1.Memo1.Lines.Add('Номер точки в массиве '+intTostr(numP)+' '+'Значение '+IntToStr(fifoMas[numP]));
  end;

  //после точки
  for numP:=numCurPoint to  numCurPoint+numPointUp do
  begin
    if numP=numCurPoint then
    begin
      form1.Memo1.Lines.Add('Номер точки в массиве!!! '+
        intTostr(numP)+' '+'Значение '+IntToStr(fifoMas[numP]));
    end
    else
    begin
      form1.Memo1.Lines.Add('Номер точки в массиве '+
        intTostr(numP)+' '+'Значение '+IntToStr(fifoMas[numP]));
    end;
  end;
  form1.Memo1.Lines.Add('====================');
end;
//==============================================================================

//==============================================================================
//
//==============================================================================

function TData.TestMarker(begNumPoint: integer; const pointCounter: integer): boolean;
var
  i: integer;
  j: integer;
  testFlag: boolean;
begin
  i := begNumPoint;
  if i < 1 then
  begin
    i := FIFOSIZE;
  end;
  testFlag := true;
  for j := 1 to pointCounter do
  begin
    //хоть одна точка больше порога. значит это не маркер
    //проверяем не выходим ли за пределы кольц буфера и при необх. перех. в начало
    if i > FIFOSIZE then
    begin
      i := 1;
    end;
    if fifoMas[i] >= porog then
    begin
      testFlag := false;
    end;
    inc(i);
    //!!!
    if (flagEnd) then
    begin
      testFlag := false;
      break;
    end;
  end;
  result := testFlag;
end;
//==============================================================================



procedure TForm1.upGistFastSizeClick(Sender: TObject);
begin
  form1.downGistFastSize.Enabled := true;
  //wait(1);
  testOutFalg:=false;
  //Application.ProcessMessages;
  sleep(50);
  //Application.ProcessMessages;
  if form1.fastGist.BottomAxis.Maximum <= form1.fastGist.BottomAxis.Minimum + {600}400 then
  begin
    form1.upGistFastSize.Enabled := false
  end
  else
  begin
    form1.fastGist.BottomAxis.Maximum := form1.fastGist.BottomAxis.Maximum - 20;
    //data.masFastVal:=nil;
    //setlength(data.masFastVal, trunc(form1.fastGist.BottomAxis.Maximum));
  end;
  testOutFalg:=true;
end;

procedure TForm1.downGistFastSizeClick(Sender: TObject);
begin
  testOutFalg:=false;
  form1.upGistFastSize.Enabled := true;
  sleep(50);
  //wait(1);
  //form1.Label5.Caption:=floatTostr(form1.fastGist.BottomAxis.Maximum);
  form1.fastGist.BottomAxis.Maximum := form1.fastGist.BottomAxis.Maximum + 20;
  if form1.fastGist.BottomAxis.Maximum >= {1800}2000 then
  begin
    form1.downGistFastSize.Enabled := false;
  end;
  testOutFalg:=true;
end;

procedure TForm1.tlmWriteBClick(Sender: TObject);
begin
  cOut:=0;
  if tlm.tlmBFlag then
  //запуск записи в тлм
  begin
    form1.tlmWriteB.Caption := '0 Mb';
    //пока пишем в тлм мы не можем завершить прием
    form1.startReadACP.Enabled:=false;
    //нач иниц. счетчика установки в 1 ГЦ
    tlm.iOneGC := 4;
    tlm.StartWriteTLM;
    tlm.WriteTLMhead;
    //флаг синхронизации для записи в массив цикла
    {data.}flSinxC := false;
    //разрешаем запись блоков в файл ТЛМ
    tlm.flagWriteTLM := true;
    //устанавливаем флаг первой записи блока в файл
    tlm.flagFirstWrite := true;
    tlm.flagEndWrite := false;
  end
  else
  //остановка записи в тлм
  begin
    //вспомог. флаг для синхр. записи в массив цикла
    flBeg := false;
    //флаг синхронизации для записи в массив цикла
    {data.}flSinxC := false;
    tlm.flagWriteTLM := false;
    //form1.WriteTLMTimer.Enabled:=false;
    tlm.flagEndWrite := true;
    closeFile(tlm.PtlmFile);
    tlm.countWriteByteInFile := 0;
    tlm.precision := 0;
    form1.tlmWriteB.Caption := 'Запись';
    //form1.Memo1.Lines.Add('Количество записанных блоков(циклов) '+
    //intToStr(tlm.blockNumInfile));
    ShowMessage('Файл записан!');
    //файл tlm записали, можем завершить прием
    form1.startReadACP.Enabled:=true;
  end;
  //от запуска с останову и наоборот
  tlm.tlmBFlag := not tlm.tlmBFlag;
end;

procedure TForm1.startReadTlmBClick(Sender: TObject);
begin
  //объект для работы с сигналом
  if infNum=0 then
  begin
    dataM16 := TdataM16.CreateData;
  end
  else
  begin
    dataMoth := TdataMoth.CreateData;
  end;


  //разрешение масштабирования графиков
  form1.fastGist.AllowZoom:=true;
  form1.fastGist.AllowPanning:=pmBoth;
  form1.gistSlowAnl.AllowZoom:=true;
  form1.gistSlowAnl.AllowPanning:=pmBoth;
  form1.tempGist.AllowZoom:=True;
  form1.tempGist.AllowPanning:=pmBoth;

  testOutFalg:=true;
  //проиниц. счетчики для подсч. колич. каждого типа адресов
  //ам
  acumAnalog := 0;
  //темп.
  acumTemp:=0;
  //ак
  acumContact := 0;
  //б
  acumFast := 0;
  //сброс программы в начальное состояние
  //data.ReInitialisation;
  //data.Free;
  //data := Tdata.CreateData;
  //проверим какие адреса каналов надо загружать
  testNeedsAdrF;
  //Получение правильного списка адресов
  GetAddrList;
  //Установка списка правильных адресов
  SetOrbAddr;

  //при начале работы с файлом и выборки из него назначаем что
  //нас первый блок это первый цикл первая группа первая фраза и т.д
  {data.}groupNum:=1;
  {data.}ciklNum:=1;


  //проверка правильности рабочих адресов
  if {data.}GenTestAdrCorrect then
  begin
    //объект для работы с ТЛМ
    tlm := Ttlm.CreateTLM;
    //положение ползунка скорости
    form1.tlmPSpeed.Position := 3;
    form1.tlmPSpeed.Enabled:=true;
    //заполнение массива параметров
    if ({data.}FillAdressParam) then
    begin
      ShowMessage('Выберите файл .tlm для воспроизведения!');
      form1.startReadACP.Enabled := false;
      //выводим имя открытого файла
      tlm.OutFileName;
    end
    else
    begin
      tlm := nil;
      //положение ползунка скорости
      form1.tlmPSpeed.Position := 3;
      form1.tlmPSpeed.Enabled:=false;
      ShowMessage('В списке найдены неправильные адреса!');
    end;
  end
  else
  begin
    showMessage('Проверьте правильность адресов!');
  end;
end;

procedure TForm1.Series4Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ({data.}graphFlagFastP) then
  begin
    {data.}graphFlagFastP := false;
    form1.Timer1.Enabled:=false;
    form1.fastGist.Series[0].Clear;
  end
  else
  begin
    //data.masFastVal := nil; //!!!
    //wait(1);
    //учитываем количество аналоговых и контактных адресов до этого
    {data.}chanelIndexFast := ValueIndex + acumAnalog + acumContact+acumTemp;
    //перестроим координатную ось в зависимости от типа
    //T22
    if masElemParam[{data.}chanelIndexFast].adressType = 2 then
    begin
      form1.fastGist.LeftAxis.Maximum := 64;
      form1.fastGist.LeftAxis.Minimum := 0;
    end;
    //T21
    if masElemParam[{data.}chanelIndexFast].adressType = 3 then
    begin
      form1.fastGist.LeftAxis.Maximum := 256;
      form1.fastGist.LeftAxis.Minimum := 0;
    end;
    //T24
    if masElemParam[{data.}chanelIndexFast].adressType = 5 then
    begin
      form1.fastGist.LeftAxis.Maximum := 64;
      form1.fastGist.LeftAxis.Minimum := 0;
    end;
    //form1.Timer1.Enabled:=true;
    //старт отрисовки
    {data.}graphFlagFastP := true;
  end;
end;

procedure TForm1.TimerPlayTlmTimer(Sender: TObject);
begin
  if (not flagACPWork) then
  begin
    Form1.Memo1.Lines.Add('1');
  end;
  if tlm.fFlag then
  begin
    tlm.ParseBlock(tlm.tlmPlaySpeed)
  end
  else
  begin
    form1.diaSlowAnl.Series[0].Clear;
    form1.diaSlowCont.Series[0].Clear;
    form1.fastDia.Series[0].Clear;
    form1.fastGist.Series[0].Clear;
    form1.gistSlowAnl.Series[0].Clear;
  end;
end;

procedure TForm1.playClick(Sender: TObject);
begin
  form1.TimerPlayTlm.Enabled := true;
end;

procedure TForm1.pauseClick(Sender: TObject);
begin
  form1.TimerPlayTlm.Enabled := false;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  if ((form1.TrackBar1.Position <= form1.TrackBar1.Max) and
      (form1.TrackBar1.Position >= form1.TrackBar1.Min)) then
  begin
    form1.TimerPlayTlm.Enabled := false;
    //tlm.stream.Seek(SIZEBLOCKPREF,soFromCurrent);
    //288 экспериментальное смещение для правильного чтения из файла
    tlm.stream.Position := (form1.TrackBar1.Position - 1) * tlm.sizeBlock + MAXHEADSIZE;
    //form1.Memo1.Lines.Add(intToStr(tlm.stream.Position));
    form1.TimerPlayTlm.Enabled := true;
  end
end;

procedure TForm1.stopClick(Sender: TObject);
begin
  form1.propB.Enabled := true;
  //выкл. таймера проигр файла
  form1.TimerPlayTlm.Enabled := false;
  form1.TrackBar1.Enabled := false;
  //выкл кнопок плеера
  form1.PanelPlayer.Enabled := false;
  //выбор режима работы
  form1.startReadACP.Enabled := true;
  form1.startReadTlmB.Enabled := true;
  //сброс настроек к началу
  form1.TrackBar1.Position := 1;
  form1.fileNameLabel.Caption := '';
  form1.orbTimeLabel.Caption := '';
  //завершение проигрывания
  tlm.fFlag := false;
  form1.TimerPlayTlm.Enabled := false;
  //сброс файла
  tlm.stream.Free;
  wait(10);
  form1.diaSlowAnl.Series[0].Clear;
  form1.diaSlowCont.Series[0].Clear;
  form1.fastDia.Series[0].Clear;
  form1.fastGist.Series[0].Clear;
  form1.gistSlowAnl.Series[0].Clear;
  form1.tempDia.Series[0].Clear;
  form1.tempGist.Series[0].Clear;
end;

procedure TForm1.tlmPSpeedChange(Sender: TObject);
begin
  if form1.TrackBar1.Enabled then
  begin
    form1.TimerPlayTlm.Enabled := false;
  end;
  case self.tlmPSpeed.Position of
    0:
    begin
      tlm.tlmPlaySpeed := 1;
    end;
    1:
    begin
      tlm.tlmPlaySpeed := 2;
    end;
    2:
    begin
      tlm.tlmPlaySpeed := 3;
    end;
    3:
    begin
      tlm.tlmPlaySpeed := 4;
    end;
    4:
    begin
      tlm.tlmPlaySpeed := 5;
    end;
    5:
    begin
      tlm.tlmPlaySpeed := 6;
    end;
    6:
    begin
      tlm.tlmPlaySpeed := 7;
    end;
    7:
    begin
      tlm.tlmPlaySpeed := 8;
    end;
  end;
  if form1.TrackBar1.Enabled then
  begin
    form1.TimerPlayTlm.Enabled := true;
  end;
end;

procedure TForm1.propBClick(Sender: TObject);
begin
  //при смене настроек обнулим список раб. адресов.
  form1.OrbitaAddresMemo.Clear;
  ShowMessage('Выберите файл адресов Орбиты!');
  form1.OpenDialog2.InitialDir:=ExtractFileDir(ParamStr(0))+'\ConfigDir';;
  //запросим у польз. файл настроек.
  if form1.OpenDialog2.Execute then
  begin
    propIniFile:=TIniFile.Create(ExtractFileDir(ParamStr(0))+'\ConfigDir\property.ini');
    //propStrPath:=propIniFile.ReadString('lastPropFile','path','');
    //внесем путь до файла настроек
    propIniFile.WriteString('lastPropFile','path',form1.OpenDialog2.FileName);
    //считаем внесенный путь.
    propStrPath:=propIniFile.ReadString('lastPropFile','path','');
    propIniFile.Free;
    //проверим какие адреса каналов надо загружать
    testNeedsAdrF;
    //Получение правильного списка адресов
    GetAddrList;
    //Установка списка правильных адресов
    SetOrbAddr;

    form1.startReadACP.Enabled := true;
    form1.startReadTlmB.Enabled := true;
    form1.saveAdrB.Enabled:=true;
  end
  else
  //не выбран
  begin
    ShowMessage('Файл адресов Орбиты не выбран!');
  end;
end;

procedure TForm1.saveAdrBClick(Sender: TObject);
var
  strOut:string;
begin
  strOut:=ExtractFileName(propStrPath){RightStr(propStrPath,7)};
  showMessage('Файл адресов '+strOut+' изменен!');
  form1.OrbitaAddresMemo.Lines.SaveToFile(propStrPath);
  wait(10);
end;

procedure TForm1.Series5Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ({data.}graphFlagBusP) then
  begin
    form1.busGist.Series[0].Clear;
    {data.}graphFlagBusP := false;
  end
  else
  begin
    {data.}chanelIndexBus := ValueIndex+acumAnalog + acumContact+acumTemp+acumFast;
    {data.}graphFlagBusP := true;
  end;
end;

procedure TForm1.TimerOutToDiaBusTimer(Sender: TObject);
var
iBus:integer;
busArrayLen:Integer;
begin
  if (not flagACPWork) then
  begin
    Form1.Memo1.Lines.Add('1');
  end;
  form1.busGist.Series[0].Clear;
  //sleep(3);
  busArrayLen:=length({data.}busArray);
  for iBus:=0 to busArrayLen  do
  begin
    form1.busDia.Series[0].AddXY(iBus, {data.}busArray[iBus]);
  end;
  form1.TimerOutToDiaBus.Enabled := false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  {if ((form1.upGistFastSize.Enabled)and(form1.downGistFastSize.Enabled)) then
  begin
    form1.upGistFastSize.Enabled:=false;
    form1.downGistFastSize.Enabled:=false;
  end
  else
  begin
    form1.upGistFastSize.Enabled:=true;
    form1.downGistFastSize.Enabled:=true;
  end;}
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  flagTrue:=true;
  //WinExec(PChar('OrbitaMAll.exe'), SW_ShowNormal);
end;

procedure TForm1.tmrForTestOrbSignalTimer(Sender: TObject);
begin
  if orbOkCounter>=40000 then
  begin
    orbOkCounter:=0;
    if (orbOk) then
    begin
      //сигнал найден
      form1.tmrForTestOrbSignal.Enabled:=false;
    end
    else
    begin
      form1.tmrForTestOrbSignal.Enabled:=false;
      ShowMessage('Сигнал Орбиты не найден! Проверьте сигнал!');
      {data.}graphFlagFastP := false;

      //Application.ProcessMessages;
      sleep(50);
      //Application.ProcessMessages;

      if ((form1.tlmWriteB.Enabled)and
          (not form1.startReadTlmB.Enabled)and
          (not form1.propB.Enabled))  then
      begin
        //остановим работу с АЦП
        pModule.STOP_ADC();
      end;
      //завершим все работающие циклы
      flagEnd:=true;
      wait(20);
      //завершим приложение по человечески.
      Application.Terminate;
    end;
  end;
end;

procedure TForm1.Series7Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //избегаем доступа к мемо. и в случае доступности
  //мемо делаем его недоступным и наоборот
  //form1.OrbitaAddresMemo.Enabled:= not form1.OrbitaAddresMemo.Enabled;
  //form1.Memo1.Enabled:= not form1.Memo1.Enabled;
  if ({data.}graphFlagTempP) then
  begin
    form1.tempGist.Series[0].Clear;
    {data.}graphFlagTempP := false;
  end
  else
  begin
    {data.}graphFlagTempP := true;
    //form1.dia.Canvas.MoveTo(form1.dia.Width-1051,form1.dia.Height-33);
    {data.}chanelIndexTemp := ValueIndex+ acumAnalog + acumContact;
  end;
end;

procedure TForm1.upGistTempSizeClick(Sender: TObject);
begin
  form1.downGistTempSize.Enabled := true;
  if form1.tempGist.BottomAxis.Maximum <=form1.tempGist.BottomAxis.Minimum + 20 then
  begin
    form1.upGistTempSize.Enabled := false
  end
  else
  begin
    form1.tempGist.BottomAxis.Maximum := form1.tempGist.BottomAxis.Maximum - 10;
  end;
end;

procedure TForm1.downGistTempSizeClick(Sender: TObject);
begin
  form1.upGistTempSize.Enabled := true;
  form1.tempGist.BottomAxis.Maximum := form1.tempGist.BottomAxis.Maximum + 10;
  if form1.tempGist.BottomAxis.Maximum >= 700 then
  begin
    form1.downGistTempSize.Enabled := false;
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  //flagTrue:=true;
  if nResist<500 then
  begin
    changeResistance(nResist);
    nResist:=nResist+dResist;
  end
  else
  begin
    nResist:=1;
  end;

  
end;

procedure TForm1.tmrContTimer(Sender: TObject);
var
  orbAdrCount: integer;
begin
  if (not flagACPWork) then
  begin
    Form1.Memo1.Lines.Add('1');
  end;

  orbAdrCount := 0;
  //счетчик для подсчета количества контактных каналов
  {data.}contactAdrCount := 0;
  form1.diaSlowCont.Series[0].Clear;
  while orbAdrCount <= iCountMax - 1 do // iCountMax-1
  begin
    if masElemParam[orbAdrCount].adressType=1 then
    begin
      //производим работу только с контактными каналами
      {data.}outToDia(
      masElemParam[orbAdrCount].numOutElemG,
      masElemParam[orbAdrCount].stepOutG,
      masGroupSize,orbAdrCount,
      masElemParam[orbAdrCount].adressType,
      masElemParam[orbAdrCount].bitNumber,
      masElemParam[orbAdrCount].numBusThread,
      masElemParam[orbAdrCount].adrBus,
      masElemParam[orbAdrCount].numOutPoint,
      masElemParam[orbAdrCount].flagGroup,
      masElemParam[orbAdrCount].flagCikl);
    end;
    inc(orbAdrCount);
  end;
  form1.tmrCont.Enabled := false;
end;

procedure TForm1.btnAutoTestClick(Sender: TObject);
begin
  //timeSMKB:=0;
  //считаем данные из конфигурационного файла проверки
  //если возникли ошибки то дальше не идем
  Form1.propB.Enabled:=false;


  //проверяем что загрузились настройки прибора в  конф. файле
  if (iniRead) then
  begin
    //проверяем наличие приборов
    if testOnAllTestDevices then
    begin
      //указываем номер пакета адресов для проверки БВК
      adrTestNum:=3;
      //подгружаем адреса для проверки БВК
      testNeedsAdrF;
      //активируем страницу проверки быстрых
      form1.PageControl1.ActivePageIndex:=1;

      //запуск питания прибора
      SetOnPowerSupply(0);
      SetVoltageOnPowerSupply(1,'2700');
      SetOnPowerSupply(1);

      if Form1.startReadACP.Caption='Прием' then
      begin
        //начали прием данных с прибора
        Form1.startReadACP.Click;  //!!!
      end;



      //проверка подключения источника питания
      if (flagTestDev) then
      begin
        SetOnPowerSupply(1);
        SetVoltageOnPowerSupply(1,'0000');
        Delay_ms(20);
        SetOnPowerSupply(0);
        //замыкаем контакты команды НОВ
        SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');

        SetVoltageOnPowerSupply(1,'2700');
        SetOnPowerSupply(1);
      end;

      Form1.tmr1.Enabled:=True; 



      //flagMKBEnd:=True;// временно проверяем МКТ3 и СРН2 тут
       //запуск впомогательного таймера для проверки МКТ3
      //Form1.tmrF.Enabled:=True; //!!! временно проверяем МКТ3 и СРН2 тут

      //указываем номер пакета адресов для проверки МКБ2
      {adrTestNum:=1;
      //подгружаем адреса для проверки МКБ2
      testNeedsAdrF;
      //активация вкладки с АЧХ
      form1.PageControl1.ActivePageIndex:=3;
      //проверка МКБ2
      TestMKB2;}
    end
    else
    begin
      ShowMessage('Не все приборы для проведения проверки в составе рабочего места!');
    end;
  end
  else
  begin
    ShowMessage('Ошибка при работе с конфигурационном файле');
  end;
end;

//udp для отправки команд на источник питания АКИП.
procedure TForm1.idpsrvr1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  A:array[1..1000] of char;
  A1:string;
  I:double;
begin
  if ABinding.PeerIp = IP_POWER_SUPPLY_1 then
  begin
    AData.Read(A,aData.size);
    if(A[1]='O') then
    begin
        AkipOffOnState:=True;
        //Form3.Timer1.Enabled:=False;
    end;
    if A[1] <> 'O' then
    begin
        A1:=A[5]+'.'+A[6]+A[7]+A[8];
        //CurrentFromPower:=A1;
        AkipOffOnState:=True;
        PowerRequest:=True;
        //Form3.Timer1.Enabled:=False;
    end;
  end;
end;

procedure TForm1.tmr1_1_10_2Timer(Sender: TObject);
var
  bool:Boolean;
begin
  if (startTest_1_1_10_2) then
  begin
    startTest_1_1_10_2:=False;
    case testCount of
      0:
      begin
        testResult:=true;
        //проверяем первый диапазон
        //проверка в режиме ТС
        //установим 1 диапазон
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ИЗМЕРЕНИЙ В ОДНОМ ИЗ ДВУХ ДИАПАЗОНОВ,'+
        'ПОГРЕШНОСТИ ИЗМЕРЕНИЙ, ДИСКРЕТНОСТИ ИЗМЕРЕНИЙ И ВЫБОРА ИЗМЕРИТЕЛЬНОЙ ШКАЛЫ'+').');
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ДИАПАЗОНА 1');
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:5 Ом.');
        SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=1');
        changeResistance(5.0);
        Delay_S(1);
        //проверяем 31 канал
        bool:=testChannals(minScale4,maxScale4,TS_1_MIN4,TS_1_MAX4,5.0);
        testResult:=testResult and bool;
      end;
      2:
      begin
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:15 Ом.');
        changeResistance(15.0);
        Delay_S(1);
        bool:=testChannals(minScale3,maxScale3,TS_1_MIN3,TS_1_MAX3,15.0);
        testResult:=testResult and bool;
      end;
      4:
      begin
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:30 Ом.');
        changeResistance(30.0);
        Delay_S(1);
        bool:=testChannals(minScale2,maxScale2,TS_1_MIN2,TS_1_MAX2,30.0);
        testResult:=testResult and bool;
      end;
      6:
      begin
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:60 Ом.');
        changeResistance(60.0);
        Delay_S(1);
        bool:=testChannals(minScale1,maxScale1,TS_1_MIN1,TS_1_MAX1,60.0);
        testResult:=testResult and bool;
      end;
      8:
      begin
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ДИАПАЗОНА 2');
        SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=0');
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:25 Ом.');
        changeResistance(25.0);
        Delay_S(1);
        bool:=testChannals(minScale4,maxScale4,TS_2_MIN4,TS_2_MAX4,25.0);
        testResult:=testResult and bool;
      end;
      10:
      begin
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:75 Ом.');
        changeResistance(75.0);
        Delay_S(1);
        bool:=testChannals(minScale3,maxScale3,TS_2_MIN3,TS_2_MAX3,75.0);
        testResult:=testResult and bool;
      end;
      12:
      begin
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:150 Ом.');
        changeResistance(150.0);
        Delay_S(1);
        bool:=testChannals(minScale2,maxScale2,TS_2_MIN2,TS_2_MAX2,150.0);
        testResult:=testResult and bool;
      end;
      14:
      begin
        Form1.mmoTestResult.Lines.Add('Установленное сопротивление:300 Ом.');
        changeResistance(300.0);
        Delay_S(1);
        bool:=testChannals(minScale1,maxScale1,TS_2_MIN1,TS_2_MAX1,300.0);
        testResult:=testResult and bool;
        //завершили сбор калибровок в массив
        startTestBlock:=False;
        Form1.tmr1_1_10_2.Enabled:=False;
        testCount:=0;
        if (testResult) then
        begin
          Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ИЗМЕРЕНИЯ В ЛЮБОМ ИЗ ДВУХ ДИАПАЗОНОВ,'+
           'ПОГРЕШНОСТИ ИЗМЕРЕНИЙ, ДИСКРЕТНОСТИ ИЗМЕРЕНИЙ и ВЫБОРА ИЗМЕРИТЕЛЬНОЙ ШКАЛЫ): НОРМА');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ИЗМЕРЕНИЯ В ЛЮБОМ ИЗ ДВУХ ДИАПАЗОНОВ,'+
           'ПОГРЕШНОСТИ ИЗМЕРЕНИЙ, ДИСКРЕТНОСТИ ИЗМЕРЕНИЙ и ВЫБОРА ИЗМЕРИТЕЛЬНОЙ ШКАЛЫ): !!! НЕ НОРМА !!!');
          allTestFlag:=false;
        end;
        Form1.mmoTestResult.Lines.Add('');
      end;
    end;
    minScale1:=-1;
    maxScale1:=-1;
    minScale2:=-1;
    maxScale2:=-1;
    minScale3:=-1;
    maxScale3:=-1;
    minScale4:=-1;
    maxScale4:=-1;
    Inc(testCount);
  end;
end;

procedure TForm1.tmrAllTestTimer(Sender: TObject);
begin
  //проверка калибровок
  if (testColibrFlag) then
  begin
    //проверяем установлен ли флаг собранности
    if (startTest_1_1_10_2) then
    begin
      if (testColibr) then
      begin
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ПЕРЕДАЧИ КАЛИБРОВОК): НОРМА.');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ПЕРЕДАЧИ КАЛИБРОВОК): !!! НЕ НОРМА !!!');
      end;
      Form1.mmoTestResult.Lines.Add('');
      startTest_1_1_10_2:=False;
      testColibrFlag:=False;
    end;
  end
  else
  begin
    //как только первую проверку закончили выполняем след проверку
    if (testFlag_1_1_10_2) then
    begin
      testFlag_1_1_10_2:=False;
      //запуск проверки погрешностей измерений МКТ3
      Form1.tmr1_1_10_2.Enabled:=true;
    end
    else
    begin
      //как только закончили 2 проверку
      if (not Form1.tmr1_1_10_2.Enabled) then
      begin
        if  (testFlagRco) then
        begin
          testFlagRco:=False;
          //запуск проверки компенсации начальных сопротивлений МКТ3
          Form1.tmrRCo.Enabled:=True;
        end
        else
        begin
          if (not Form1.tmrRCo.Enabled) then
          begin
            if (testFlagSrn) then
            begin
              testFlagSrn:=False;
              //запустим проверку прибора СРН2
              Form1.tmrTestSRN2.Enabled:=True;
            end;
            
            if (not Form1.tmrTestSRN2.Enabled) then
            begin
              //как только закончили проверку СРН2
              //все проверки прошли, надо выводить результат
              if (allTestFlag) then
              begin
                Form1.mmoTestResult.Lines.Add('ПРОВЕРКА МОДУЛЯ N1-1: НОРМА');
              end
              else
              begin
                Form1.mmoTestResult.Lines.Add('ПРОВЕРКА МОДУЛЯ N1-1: !!! НЕ НОРМА !!!');
              end;
              Form1.tmrAllTest.Enabled:=False;
            end; 
          end;
        end;  
      end;
    end;
  end;
end;

procedure TForm1.tmrRCoTimer(Sender: TObject);
var
  i:integer;
  bool:Boolean;
begin
  case testCount of
    1:
    begin
      testResult:=True;
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА КОМПЕНСАЦИИ НАЧАЛЬНЫХ СОПРОТИВЛЕНИЙ)');
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА ДИАПАЗОНА 1');
      SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=1');
      Delay_S(1);
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 80 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:80 Ом');
      changeResistance(80.0);
      for i:=1 to 8 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    2:
    begin
      //проверяем 31 канал
      bool:=testCompens;
      testResult:=testResult and  bool;

      for i:=1 to 8 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    3:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 40 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:40 Ом');
      changeResistance(40.0);
      for i:=9 to 17 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    4:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=9 to 17 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    5:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 20 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:20 Ом');
      changeResistance(20.0);
      for i:=18 to 26 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    6:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=18 to 26 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    7:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 10 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:10 Ом');
      changeResistance(10.0);
      for i:=27 to 35 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    8:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=27 to 35 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    9:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 5 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:5 Ом');
      changeResistance(5.0);
      for i:=36 to 44 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    10:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=36 to 44 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    11:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 2.5 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:2.5 Ом');
      changeResistance(2.5);
      for i:=45 to 53 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    12:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=45 to 53 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    13:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА ДИАПАЗОНА 2');
      SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=0');
      Delay_S(1);
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 400 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:400 Ом');
      changeResistance(400);
      for i:=1 to 8 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    14:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      testFlag_1_1_10_2:=False;
      for i:=1 to 8 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    15:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 200 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:200 Ом');
      changeResistance(200.0);
      for i:=9 to 17 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    16:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=9 to 17 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    17:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 100 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:100 Ом');
      changeResistance(100.0);
      for i:=18 to 26 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    18:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=18 to 26 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    19:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 50 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:50 Ом');
      changeResistance(50.0);
      for i:=27 to 35 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    20:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=27 to 35 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    21:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 25 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:25 Ом');
      changeResistance(25.0);
      for i:=36 to 44 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    22:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=36 to 44 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
    end;
    23:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА КОМПЕНСАЦИИ СОПРОТИВЛЕНИЯ 12.5 Ом');
      form1.mmoTestResult.Lines.Add('Установлено сопротивление:12.5 Ом');
      changeResistance(12.5);
      for i:=45 to 53 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    24:
    begin
      bool:=testCompens;
      testResult:=testResult and bool;
      for i:=45 to 53 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=0');
      end;
      Delay_S(1);
      if (testResult) then
      begin
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА КОМПЕНСАЦИИ НАЧАЛЬНЫХ СОПРОТИВЛЕНИЙ): НОРМА');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116 (ПРОВЕРКА КОМПЕНСАЦИИ НАЧАЛЬНЫХ СОПРОТИВЛЕНИЙ): !!! НЕ НОРМА !!!');
        allTestFlag:=false;
      end;
      Form1.mmoTestResult.Lines.Add('');

      if (testResult) then
      begin
        Form1.mmoTestResult.Lines.Add('ПУНКТ 1.1.10.2 ТУ ЯГАИ.468157.116: НОРМА');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('ПУНКТ 1.1.10.2 ТУ ЯГАИ.468157.116: !!! НЕ НОРМА !!!');
        allTestFlag:=false;
      end;
      Form1.mmoTestResult.Lines.Add('');

      testCount:=0;

      //startTestMKT3:=False;
      form1.tmrRCo.Enabled:=false;
    end;
  end;
  Inc(testCount);
end;

procedure TForm1.tmrTestSRN2Timer(Sender: TObject);
var
  str:string;
begin
  case testCount of
    1:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.3 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ВЫРАБОТКИ СТАБИЛИЗИРОВАННОГО НАПРЯЖЕНИЯ 6.2 В)(прибор СРН2)');
      //замыкаем нужные контакты на ИСД
      //на общ. шину
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'76'+'val=1');
      //считываем и проверяем напряжение
      str:='';
      //переводим вольтметр_1 в режим чтения
      //SetConf(m_instr_usbtmc_1[0],'READ?');
      //считываем напряжение с вольтметра_1
      //GetDatStr(m_instr_usbtmc_1[0],str);

      SetConf(m_instr_usbtmc_1[0],'READ?');
      //считываем напряжение с вольтметра_1
      GetDatStr(m_instr_usbtmc_1[0],str);

      //выводим результат проверки
      if ((strToFloat(str)>=(6.200-0.062))and(strToFloat(str)<=(6.200+0.062))) then
      begin
        form1.mmoTestResult.Lines.Add('Напряжение с прибора: '+str+' В');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.3 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ВЫРАБОТКИ СТАБИЛИЗИРОВАННОГО НАПРЯЖЕНИЯ 6.2 В)'+' НОРМА');

      end
      else
      begin
        form1.mmoTestResult.Lines.Add('Напряжение с прибора: '+str+' В');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.3 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ВЫРАБОТКИ СТАБИЛИЗИРОВАННОГО НАПРЯЖЕНИЯ 6.2 В)'+' !!!НЕ НОРМА!!!');
        allTestFlag:=False;
      end;
      form1.mmoTestResult.Lines.Add('');
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'76'+'val=0');
    end;
    2:
    begin
      form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.4 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ВЫРАБОТКИ ЭТАЛОННОГО НАПРЯЖЕНИЯ 5 В ДЛЯ КАЛИБРОВКИ ГЕНЕРАТОРНЫХ ДАТЧИКОВ)(прибор СРН2)');
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'77'+'val=1');
      //считываем и проверяем напряжение
      str:='';
      //переводим вольтметр в режим чтения
      SetConf(m_instr_usbtmc_1[0],'READ?');
      //считываем
      GetDatStr(m_instr_usbtmc_1[0],str);
      //выводим результат проверки
      if ((strToFloat(str)>=(5.0-0.010))and(strToFloat(str)<=(5.0+0.010))) then
      begin
        form1.mmoTestResult.Lines.Add('Напряжение с прибора: '+str+' В');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.4 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ВЫРАБОТКИ ЭТАЛОННОГО НАПРЯЖЕНИЯ 5 В ДЛЯ КАЛИБРОВКИ ГЕНЕРАТОРНЫХ ДАТЧИКОВ)'+' НОРМА');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('Напряжение с прибора: '+str+' В');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.4 ТУ ЯГАИ.468157.116 (ПРОВЕРКА ВЫРАБОТКИ ЭТАЛОННОГО НАПРЯЖЕНИЯ 5 В ДЛЯ КАЛИБРОВКИ ГЕНЕРАТОРНЫХ ДАТЧИКОВ)'+' !!!НЕ НОРМА!!!');
        allTestFlag:=False;
      end;
      Form1.tmrTestSRN2.Enabled:=false;
      form1.mmoTestResult.Lines.Add('');
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'77'+'val=0');
    end;
  end;
  Inc(testCount);
    {if (testCount>2) then
  begin
     Form1.tmrTestSRN2.Enabled:=false;
  end;}
end;

procedure TForm1.tmrMKB_DpartTimer(Sender: TObject);
var
  ChannelValue,VoltmetrValue,Error:double;
  i:integer;
  //значение кода для подбора напряжения 6.2 на ИСД
  val62:Integer;
  //показатель с вольтметра в виде строки
  str:string;
  //значение с вольтметра в В
  voltmetrVal:Double;
  //значение с МКБ2
  chVal:double;
  //калибровка минимума на МКБ2
  calibrMinMKB2:Integer;
  //калибровка максимума на МКБ2
  calibrMaxMKB2:integer;
begin
  case (timerMode) of
    //проверка значений каналов на 0В и 6.2В. В зависимости от разрядности канала
    1:
    begin
      //выставили на канале 0В
      {SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(numberChannel)+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
         IntToStr(numberChannel)+'val=1');}
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
         IntToStr(IsdMKBcontNum[numberChannel])+'val=1');
      //проверили показание канала на 0В
      //в зависимости от типа адреса
      case masElemParam[numberChannel-1].adressType of
        2:
        begin
          //T22. 6 разрядов
          if ((DataMKB[numberChannel]>=3) and (DataMKB[numberChannel]<=5)) then
          begin
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   НОРМА'+'[3,5]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   !!!НЕ НОРМА!!!'+'[3,5]')
          end;
        end;
        3:
        begin
          //T21. 8 разрядов
          if ((DataMKB[numberChannel]>=23) and (DataMKB[numberChannel]<=27)) then
          begin
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   НОРМА'+'[23,27]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   !!!НЕ НОРМА!!!'+'[23,27]')
          end;
        end;
      end;
      //отключили канал от общей шины
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(IsdMKBcontNum[numberChannel])+'val=0');
      //переход на след канал
      Inc(numberChannel);

      
      if (numberChannel=21) then
      begin
        //все каналы проверили перешли на след. проверку
        Inc(timerMode);
      end;
    end;

    //установка 6.2В на всех проверяемых каналах
    2:
    begin
      form1.tmrMKB_Dpart.Enabled:=False;
      i:=1;
      while (i<=20) do
      //for i:=1 to 26 do
      begin
         //отключили канал от общей шины
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+IntToStr(IsdMKBcontNum[i])+'val=0');
        //--
        val62:=3310;
        //подбираем на канале 6.2В
        while (true) do
        begin
          SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdMKBcontNum[i])+'val='+intToStr(val62)+'work=1');
          SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(IsdMKBcontNum[i])+'val=1');
          str:='';
          SetConf(m_instr_usbtmc_1[0],'READ?');
          GetDatStr(m_instr_usbtmc_1[0],str);
          delete(str,4,3);
          //form1.mmoTestResult.Lines.Add(str);
          //SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC');
          if strTofloat(str)=6.2 then
          begin
            //SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC');
            dec(val62);
            SendCommandToISD('http://'+ISDip_2+'/type=3num='+
              IntToStr(IsdMKBcontNum[i])+'val=0');
            SendCommandToISD('http://'+ISDip_2+'/type=1num='+
              IntToStr(IsdMKBcontNum[i])+'val='+intToStr(val62)+'work=1');
            //SendCommandToISD('http://'+ISDip_2+'/type=3num='+
              //IntToStr(i)+'val=1');
            //SetConf(m_instr_usbtmc_1[0],'READ?');
            Break;
          end
          else
          begin
            if strTofloat(str)<6.1 then
            begin
              val62:=val62+10;
            end
            else
            begin
              val62:=val62+2;
            end;
          end;
        end;
        //--
        Delay_ms(5);

        form1.mmoTestResult.Lines.Add(IntToStr(IsdMKBcontNum[i])+'++');
       
        Inc(i);
      end;
      Delay_S(1);

      numberChannel:=1;
      Inc(timerMode);

      form1.mmoTestResult.Lines.Add('');
      form1.mmoTestResult.Lines.Add('Проверка рабочей шкалы при напряжении 6.2В');
      form1.tmrMKB_Dpart.Enabled:=true;
    end;

    //проверка всех каналов на 6.2В
    3:
    begin
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(IsdMKBcontNum[numberChannel])+'val=1');
      //проверили показание канала на 6.2В
      case masElemParam[numberChannel-1].adressType of
        2:
        begin
          if ((DataMKB[numberChannel]>=59) and (DataMKB[numberChannel]<=61)) then
          begin
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   НОРМА'+'[59,61]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   !!!НЕ НОРМА!!!'+'[59,61]')
          end;
        end;
        3:
        begin
          if ((DataMKB[numberChannel]>=243) and (DataMKB[numberChannel]<=247)) then
          begin
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   НОРМА'+'[243,247]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+
              '   МКБ2: '+IntToStr(DataMKB[numberChannel])+' дв.ед.   !!!НЕ НОРМА!!!'+'[243,247]')
          end;
        end;
      end;

      //отключили канал от общей шины
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(IsdMKBcontNum[numberChannel])+'val=0');
      //след. канал
      inc(numberChannel);

      if (numberChannel=21) then
      begin
        //все каналы проверили перешли на след. проверку
        Inc(timerMode);
      end;
    end;
    {выставляем фиксированное напряжение на каналах для проверки}
    4:
    begin
      form1.tmrMKB_Dpart.Enabled:=false;
      if (rezFlag) then
      begin
        Form1.mmoTestResult.Lines.Add('Результат проверки рабочей шкалы при напряжении 0В и 6.2В : НОРМА');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('Результат проверки рабочей шкалы при напряжении 0В и 6.2В : !!!НЕ НОРМА!!!');
      end;

      rezFlag:=true;
      Form1.mmoTestResult.Lines.Add('Проверка точности измерения каналов');
      for i:=1 to 20 do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
              IntToStr(IsdMKBcontNum[i])+'val=2500work=1');
        form1.mmoTestResult.Lines.Add(IntToStr(IsdMKBcontNum[i])+'++');
        Delay_ms(5);
      end;

      Delay_S(1);
      numberChannel:=1;
      Inc(timerMode);
      form1.tmrMKB_Dpart.Enabled:=True;
    end;
    {проверка погрешности}
    5:
    begin
      //заводим текущий канал на вольтметр
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(IsdMKBcontNum[numberChannel])+'val=1');
      Delay_ms(5);
      //считывем показатель вольтметра
      SetConf(m_instr_usbtmc_1[0],'READ?');
      GetDatStr(m_instr_usbtmc_1[0],str);
      voltmetrVal:=strTofloat(str);



      case masElemParam[numberChannel-1].adressType of
        2:
        begin
          calibrMinMKB2:=4;
          calibrMaxMKB2:=60;
        end;
        3:
        begin
          calibrMinMKB2:=25;
          calibrMaxMKB2:=245;
        end;
      end;

      chVal:=(6.2*(DataMKB[numberChannel]-calibrMinMKB2))/(calibrMaxMKB2-calibrMinMKB2);
      error:=abs(100*(chVal-voltmetrVal)/6.2);

      case masElemParam[numberChannel-1].adressType of
        //6 разр.
        2:
        begin
          if error<=2.5 then
          begin
            Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+'   МКБ2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'В   Вольтметр: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                'В   Погрешность: '+FloatToStrF(error,ffFixed,5,2)+'%   НОРМА');
          end
          else
          begin
            rezFlag:=false;
            Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+'   МКБ2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'В   Вольтметр: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                'В   Погрешность: '+FloatToStrF(error,ffFixed,5,2)+'%  !!!НЕ НОРМА!!!');
          end;
        end;
        //8 разр.
        3:
        begin
          if error<=1.5 then
          begin
            Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+'   МКБ2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'В   Вольтметр: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                'В   Погрешность: '+FloatToStrF(error,ffFixed,5,2)+'%   НОРМА');
          end
          else
          begin
            rezFlag:=false;
            Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(numberChannel)+'   МКБ2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'В   Вольтметр: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                'В   Погрешность: '+FloatToStrF(error,ffFixed,5,2)+'%   !!!НЕ НОРМА!!!');
          end;
        end;
      end;

      //отключили канал от общей шины
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(IsdMKBcontNum[numberChannel])+'val=0');
      //след. канал
      inc(numberChannel);

      if (numberChannel=21) then
      begin
        //все каналы проверили перешли на след. проверку
        Inc(timerMode);
      end;
    end;
    {следующий прибор}
    6:
    begin
      //SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC');
      if (rezFlag) then
      begin
        Form1.mmoTestResult.Lines.Add('Результат проверки точности измерения : НОРМА');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('Результат проверки точности измерения : !!!НЕ НОРМА!!!');
      end;

      //завершение проверки МКБ2
      form1.tmrMKB_Dpart.Enabled:=False;
      //запуск впомогательного таймера для проверки МКТ3
      Form1.tmrF.Enabled:=True;
      flagMKBEnd:=True;
    end;

  end;







  {case (TimerMode) of
    1:
    begin
      if (NumberChannel=1) then
      begin
        for i:=2 to 32 do
        begin
          SaveDataMKB[i]:=DataMKB[i];
        end;
        NumberChannel:=2;
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val=0work=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
         IntToStr(ChannelsISDRating6[NumberChannel])+'val=1');
      end
      else
      begin
        if ((DataMKB[NumberChannel]>=3) and (DataMKB[NumberChannel]<=5)) then
        begin
          Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+
            '   МКБ2: '+IntToStr(DataMKB[NumberChannel])+' дв.ед.   НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+
            '   МКБ2: '+IntToStr(DataMKB[NumberChannel])+' дв.ед.   !!!НЕ НОРМА!!!')
        end;

        for i:=2 to 32 do
        begin
          if (i<>NumberChannel) then
          begin
            if (abs(DataMKB[i]-SaveDataMKB[i])>2) then
            begin
              rezFlag:=false;
              //DeviceTestRezultFlag:=false;
              Memo1.Lines.Add('Взаимовлияние канала '+IntToStr(NumberChannel)+' на канал '+IntToStr(i)+'!');
            end;
          end;
        end;
        inc(NumberChannel);
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=2500work=1');

        if (NumberChannel>32) then
        begin
          SendCommandToISD('http://'+ISDip_2+'/type=3num=85val=0');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('Проверка рабочей шкалы при напряжении 6.2В');
          SendCommandToISD('http://'+ISDip_2+'/type=3num=84val=1');
          NumberChannel:=2;
          TimerMode:=2;
          SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(ChannelsISDRating6[NumberChannel])+'val=0work=0');
          SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(ChannelsISDRating6[NumberChannel])+'val=1');
        end
        else
        begin
          SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(ChannelsISDRating6[NumberChannel])+'val=0work=0');
          SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(ChannelsISDRating6[NumberChannel])+'val=1');
        end;
      end;
    end;

    2:
    begin
      if ((DataMKB[NumberChannel]>=59) and (DataMKB[NumberChannel]<=61)) then
      begin
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+'   МКБ2: '+
          IntToStr(DataMKB[NumberChannel])+' дв.ед.   НОРМА')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+'   МКБ2: '+
          IntToStr(DataMKB[NumberChannel])+' дв.ед.   !!!НЕ НОРМА!!!')
      end;

      inc(NumberChannel);
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=0');
      SendCommandToISD('http://'+ISDip_2+'/type=1num='+
        IntToStr(ChannelsISDRating6[NumberChannel])+'val=0work=0');

      if (NumberChannel>32) then
      begin
        form1.mmoTestResult.Lines.Add('');
        if (rezFlag) then
        begin
          form1.mmoTestResult.Lines.Add('Результат проверки рабочей шкалы при напряжении 0В и взаимовлияния на другие каналы: НОРМА');
          form1.mmoTestResult.Lines.Add('');
          Form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.1.1 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ВХОДНЫХ СИГНАЛОВ) НОРМА)');
          Form1.mmoTestResult.Lines.Add('');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('Результат проверки рабочей шкалы при напряжении 0В и взаимовлияния на другие каналы: !!!НЕ НОРМА!!!');
          form1.mmoTestResult.Lines.Add('');
          form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.1.1 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ВХОДНЫХ СИГНАЛОВ) !!! НЕ НОРМА !!!)');
          Form1.mmoTestResult.Lines.Add('');
        end;
        SendCommandToISD('http://'+ISDip_2+'/type=3num=84val=0');
        //DataRating:=1;
        //SetDataRatingMKB2(DataRating);
        //LoadRequests(DataRating);
        TimerMode:=3;
        NumberChannel:=2;
        rezFlag:=true;
        Form1.mmoTestResult.Lines.Add('');
        Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТОВ 1.2.2 и 1.3.2 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК КОМУТАТОРА И РАБОТОСПОСОБНОСТИ ПРИ ИЗМЕНЕНИИ РАЗРЯДНОСТИ ОЦИФРОВКИ)');
        Form1.mmoTestResult.Lines.Add('');
        Form1.mmoTestResult.Lines.Add('Проверка точности измерения и уровней калибровки при 8-разрядной оцифровке измерительных каналов');
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating8[NumberChannel])+'val='+IntToStr(ISD_VALUE)+'work=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating8[NumberChannel])+'val=1');
      end
      else
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val=0work=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val=1');
      end;
    end;

    3:
    begin
      if (NumberChannel=2) then
      begin
        if ((CalibrMaxMKB2>=239) and (CalibrMaxMKB2<=243)) then
        begin
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Максимум калибровки 6,2В: '+
            IntToStr(CalibrMaxMKB2)+' дв.ед.  НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Максимум калибровки 6,2В: '+
            IntToStr(CalibrMaxMKB2)+' дв.ед.  !!!НЕ НОРМА!!!')
        end;
        if ((CalibrMinMKB2>=14) and (CalibrMinMKB2<=18)) then
        begin
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Минимум калибровки 6,2В: '+
            IntToStr(CalibrMinMKB2)+' дв.ед.  НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Минимум калибровки 6,2В: '+
            IntToStr(CalibrMinMKB2)+' дв.ед.  !!!НЕ НОРМА!!!')
        end;
      end;

      channelValue:=(6.2*(DataMKB[NumberChannel]-CalibrMinMKB2))/(CalibrMaxMKB2-CalibrMinMKB2);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      error:=abs(100*(channelValue-voltmetrValue)/6.2);

      if error<=1 then
      begin
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+
          '   МКБ2: '+FloatToStrF(channelValue,ffFixed,5,4)+'В   Вольтметр: '+
          FloatToStrF(voltmetrValue,ffFixed,5,4)+'В   Погрешность: '+
          FloatToStrF(error,ffFixed,5,2)+'%   НОРМА')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+'   МКБ2: '+
          FloatToStrF(ChannelValue,ffFixed,5,4)+'В   Вольтметр: '+
          FloatToStrF(VoltmetrValue,ffFixed,5,4)+'В   Погрешность: '+
          FloatToStrF(Error,ffFixed,5,2)+'%   !!!НЕ НОРМА!!!');
      end;

      inc(NumberChannel);
      SendCommandToISD('http://'+ISDip_2+'/type=1num='+
        IntToStr(ChannelsISDRating8[NumberChannel-1])+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(ChannelsISDRating8[NumberChannel-1])+'val=0');

      if (NumberChannel>16) then
      begin
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('Проверка точности измерения и уровней калибровки при 6-разрядной оцифровке измерительных каналов');
        //DataRating:=2;
        //SetDataRatingMKB2(DataRating);
        //LoadRequests(DataRating);
        TimerMode:=4;
        NumberChannel:=2;
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val='+IntToStr(ISD_VALUE)+'work=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val=1');
      end
      else
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating8[NumberChannel])+'val='+
            IntToStr(ISD_VALUE)+'work=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating8[NumberChannel])+'val=1');
      end;
    end;

    4:
    begin
      if (NumberChannel=2) then
      begin
        if ((CalibrMaxMKB2>=59) and (CalibrMaxMKB2<=61)) then
        begin
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Максимум калибровки 6,2В: '
            +IntToStr(CalibrMaxMKB2)+' дв.ед.  НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Максимум калибровки 6,2В: '+
            IntToStr(CalibrMaxMKB2)+' дв.ед.  !!!НЕ НОРМА!!!')
        end;
        if ((CalibrMinMKB2>=3) and (CalibrMinMKB2<=5)) then
        begin
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Минимум калибровки 6,2В: '+
            IntToStr(CalibrMinMKB2)+' дв.ед.  НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Минимум калибровки 6,2В: '+
            IntToStr(CalibrMinMKB2)+' дв.ед.  !!!НЕ НОРМА!!!')
        end;
      end;

      channelValue:=(6.2*(DataMKB[NumberChannel]-CalibrMinMKB2))/(CalibrMaxMKB2-CalibrMinMKB2);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      error:=abs(100*(channelValue-voltmetrValue)/6.2);

      if error<=2 then
      begin
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+'   МКБ2: '+
          FloatToStrF(channelValue,ffFixed,5,4)+'В   Вольтметр: '+
            FloatToStrF(voltmetrValue,ffFixed,5,4)+'В   Погрешность: '+
              FloatToStrF(error,ffFixed,5,2)+'%   НОРМА')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+
          '   МКБ2: '+FloatToStrF(channelValue,ffFixed,5,4)+'В   Вольтметр: '+
            FloatToStrF(voltmetrValue,ffFixed,5,4)+'В   Погрешность: '+
              FloatToStrF(error,ffFixed,5,2)+'%   !!!НЕ НОРМА!!!');
      end;

      inc(NumberChannel);
      SendCommandToISD('http://'+ISDip_2+'/type=1num='+
        IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=0');

      if (NumberChannel>32) then
      begin
        Form1.mmoTestResult.Lines.Add('');
        Form1.mmoTestResult.Lines.Add('Проверка точности измерения и уровней калибровки при 4-разрядной оцифровке измерительных каналов');
        //DataRating:=3;
        //SetDataRatingMKB2(DataRating);
        //LoadRequests(DataRating);
        TimerMode:=5;
        NumberChannel:=2;
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating4[NumberChannel])+'val='+IntToStr(ISD_VALUE)+'work=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating4[NumberChannel])+'val=1');
      end
      else
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val='+IntToStr(ISD_VALUE)+'work=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating6[NumberChannel])+'val=1');
      end;
    end;

    5:
    begin
      if (NumberChannel=2) then
      begin
        if ((CalibrMaxMKB2>=14) and (CalibrMaxMKB2<=16)) then
        begin
          form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Максимум калибровки 6,2В: '+
            IntToStr(CalibrMaxMKB2)+' дв.ед.  НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Максимум калибровки 6,2В: '+
            IntToStr(CalibrMaxMKB2)+' дв.ед.  !!!НЕ НОРМА!!!')
        end;
        if ((CalibrMinMKB2>=0) and (CalibrMinMKB2<=2)) then
        begin
          Form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Минимум калибровки 6,2В: '+
            IntToStr(CalibrMinMKB2)+' дв.ед.  НОРМА')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          form1.mmoTestResult.Lines.Add('Канал 1  МКБ2. Минимум калибровки 6,2В: '+
            IntToStr(CalibrMinMKB2)+' дв.ед.  !!!НЕ НОРМА!!!')
        end;
      end;

      channelValue:=(6.2*(DataMKB[NumberChannel]-CalibrMinMKB2))/(CalibrMaxMKB2-CalibrMinMKB2);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      error:=abs(100*(channelValue-voltmetrValue)/6.2);

      if error<=6.5 then
      begin
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+
          '   МКБ2: '+FloatToStrF(channelValue,ffFixed,5,4)+'В   Вольтметр: '+
            FloatToStrF(voltmetrValue,ffFixed,5,4)+'В   Погрешность: '+
              FloatToStrF(error,ffFixed,5,2)+'%   НОРМА')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        Form1.mmoTestResult.Lines.Add('Канал '+IntToStr(NumberChannel)+
          '   МКБ2: '+FloatToStrF(ChannelValue,ffFixed,5,4)+'В   Вольтметр: '+
            FloatToStrF(VoltmetrValue,ffFixed,5,4)+'В   Погрешность: '+
              FloatToStrF(Error,ffFixed,5,2)+'%   !!!НЕ НОРМА!!!');
      end;

      inc(NumberChannel);
      SendCommandToISD('http://'+ISDip_2+'/type=1num='+
        IntToStr(ChannelsISDRating4[NumberChannel-1])+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(ChannelsISDRating4[NumberChannel-1])+'val=0');

      if (NumberChannel>24) then
      begin
        form1.mmoTestResult.Lines.Add('');
        if (rezFlag) then
        begin
          Form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТАМ 1.2.2 и 1.3.2 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК КОМУТАТОРА И РАБОТОСПОСОБНОСТИ ПРИ ИЗМЕНЕНИИ РАЗРЯДНОСТИ ОЦИФРОВКИ) НОРМА')
        end
        else
        begin
          form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТАМ 1.2.2 и 1.3.2 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК КОМУТАТОРА И РАБОТОСПОСОБНОСТИ ПРИ ИЗМЕНЕНИИ РАЗРЯДНОСТИ ОЦИФРОВКИ) !!!НЕ НОРМА!!!');
        end;
        Form1.tmrMKB_Dpart.Enabled:=false;

        Form1.mmoTestResult.Lines.Add('');
        if (rezFlag) then
        begin
          Form1.mmoTestResult.Lines.Add('Проверка прибора МКБ2 №'+'111'+' НОРМА');
          //showmessage('Проверка прибора МКБ2 №'+edit1.text+' НОРМА');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('Проверка прибора МКБ2 №'+'111'+' !!! НЕ НОРМА!!!');
          //showmessage('Проверка прибора МКБ2 №'+edit1.text+' !!! НЕ НОРМА!!!');
        end;
        //TurnOFFPowerSupply(Number_Power_Supply_1);
        //str5:='Результаты_проверки_прибора_МКБ2_№'+edit1.Text+'_'+DateToStr(Date)+'_'+TimeToStr(Time)+'.txt';
        //for i:=1 to length(str5) do if (str5[i]=':') then str5[i]:='.';
        //Memo1.Lines.SaveToFile(str5);
        //WinExec(PAnsiChar('notepad.exe '+str5),SW_SHOW);
      end
      else
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(ChannelsISDRating4[NumberChannel])+
            'val='+IntToStr(ISD_VALUE)+'work=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+
          IntToStr(ChannelsISDRating4[NumberChannel])+'val=1');
      end;
    end;
  end;}
end;

procedure TForm1.tmrFTimer(Sender: TObject);
begin
  //проверяем что проверку МКБ2 завершили
  if (flagMKBEnd) then
  begin
    flagMKBEnd:=false;
    TestConnect(AkipV7_78_1,m_defaultRM_usbtmc_1[0],m_instr_usbtmc_1[0],viAttr_1,Timeout);
    form1.PageControl1.ActivePageIndex:=2;
    startTestBlock:=true;
    //Delay_S(5);
    //startTestMKT3:=True;

    //устанавливаем пакет адресов для проверки МКТ3
    adrTestNum:=2;
    //Form1.startReadACP.Click;
    //выставялем адреса МКТ3
    testNeedsAdrF; //!!!
    //заполним параметры адресов в массив параметров адресов
    FillAdressParam;  //!!!

    //запускаем прием данных с прибора.
    Form1.startReadACP.Click; //временно тут

    Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116'+
      '(МЕТРОЛОГИЧЕСКИЕ ХАРАКТЕРИСТИКИ ДЛЯ КАНАЛОВ ТМП(ПРИБОР МКТ3)).');
    Form1.mmoTestResult.Lines.Add('');
    Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.10.2 ТУ ЯГАИ.468157.116'+
      '(ПРОВЕРКА ПЕРЕДАЧИ НА МЕСТЕ ПЕРВОГО КАНАЛА КАЛИБРОВОЧНЫХ СИГНАЛОВ).');
    //запуск таймера проверок прибора МКТ3
    Form1.tmrAllTest.Enabled:=True;

    Form1.tmrF.Enabled:=False;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  //подача команды НОВ на БВК
  SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=0');
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //время в секундах
  timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //время в мс
  timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  form1.tmrBVK2.Enabled:=True;
end;

procedure TForm1.tmrTestBVKTimer(Sender: TObject);
const
  ErrorT=250;//50//250
var
  iCh:integer;
  iT:Integer;
  setChFlag:Boolean;
  //timeDownSetCh:cardinal;
  timeUpSetCh:Cardinal;
  chTestInt:integer;

  strOut:string;
//==============================================================================
// Проверка попадания времени срабатывания в допуск времени срабатывания
//==============================================================================
function testMTime(timeTest:integer;time:Integer;dTime:integer):boolean;
begin
  if  ((time>=timeTest-dTime)and(time<=timeTest+dTime)) then
  begin
    result:=true;
  end
  else
  begin
    result:=false;
  end;
end;
//==============================================================================
begin
  //получаем время системы
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //время в сек.
  timeBVKCarSec:=hourBVK*60*60+minBVK*60+secBVK;
  //время в мсек
  timeBVKCarMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  Form1.lbl2.Caption:=IntToStr(timeBVKCarSec-timeBVKPrevSec);
  setChFlag:=true;

  if (prFlag) then
  begin
    //предв.
    //первое заполнение
    Delay_ms(5);
    if (prBegFl) then
    begin
      prBegFl:=False;
      //получаем первое состояние канала
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        testBVK_Arr_pr_curr[iCh]:=dataMKB[iCh];
        testBVK_Arr_pr_BegState[iCh]:=dataMKB[iCh];
      end;
    end
    else
    begin
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        testBVK_Arr_pr_prev[iCh]:=testBVK_Arr_pr_curr[iCh];
        testBVK_Arr_pr_curr[iCh]:=dataMKB[iCh];
      end;
      //получили текущее состояние и предидущее

      {if testMTime(1000,timeBVKCarMSec-timeBVKPrevMSec,50) then
      begin
        form1.mmoTestResult.Lines.Add('1');
      end; }


      //проверяем изменилось ли состояние каналов
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        if Abs(testBVK_Arr_pr_prev[iCh]-testBVK_Arr_pr_curr[iCh])>=10 then
        begin
          // проверим в свое ли время оно изменилось
          for iT:=testedState_pr[iCh] to BVK_NUM_SETS+1 do
          begin
            //проверяем установлено такое время переключения
            //или переключения обратно

            strOut:='';
            if (iCh>=9) then
            begin
              strOut:='Канал К'+intTostr(iCh+2)+':';
            end
            else
            begin
              strOut:='Канал К'+intTostr(iCh)+':';
            end;

            if testMTime(testBVK_Arr_pr[iCh].setTime[iT],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //в свое
              //form1.mmoTestResult.Lines.Add('Время Пр (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              if abs(testBVK_Arr_pr_prev[iCh]-testBVK_Arr_pr_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' НОРМА'+' ВКЛ');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!НЕ НОРМА!!'+' ВКЛ');
                BVKTestFlag:=False;
              end;
              //если это состояние проверили то переключаемся на следующее
              Inc(testedState_pr[iCh]);
              Break;
            end
            else if testMTime(testBVK_Arr_pr[iCh].setTime[iT-1]+testBVK_Arr_pr[iCh].durabilityT[iT-1],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //в свое
              //form1.mmoTestResult.Lines.Add('Время Пр (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              if abs(testBVK_Arr_pr_prev[iCh]-testBVK_Arr_pr_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' НОРМА'+' ВЫКЛ');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!НЕ НОРМА!!'+' ВЫКЛ');
                BVKTestFlag:=False;
              end;
              Break;
            end
            else
            begin
               //не в свое
              //form1.mmoTestResult.Lines.Add('Время Пр (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              form1.mmoTestResult.Lines.Add('Ложное время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut);
              //form1.mmoTestResult.Lines.Add('Отладка:'+intTostr(testBVK_Arr_pr[iCh].setTime[iT])+' '+intTostr(testBVK_Arr_pr[iCh].durabilityT[iT]));
              BVKTestFlag:=False;
            end;
          end;
        end;
      end;
    end;

    //время завершения предварительного режима  20 сек
    if testMTime(20000,timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
    begin
      //проверяем константные каналы на соответствие
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        chTestInt:=0;
        strOut:='';
        if (iCh>=9) then
        begin
          strOut:='Канал К'+intTostr(iCh+2)+':';
        end
        else
        begin
          strOut:='Канал К'+intTostr(iCh)+':';
        end;

        for iT:=1 to BVK_NUM_SETS do
        begin
          chTestInt:=chTestInt+testBVK_Arr_pr[iCh].setTime[iT];
        end;
        if chTestInt=0 then
        begin
          //константа
          if abs(testBVK_Arr_pr_BegState[iCh]-testBVK_Arr_pr_curr[iCh])<=3 then
          begin
            form1.mmoTestResult.Lines.Add(strOut+' НОРМА'+' ВКЛ');
          end
          else
          begin
            form1.mmoTestResult.Lines.Add(strOut+'!!НЕ НОРМА!!'+' ВКЛ');
            BVKTestFlag:=False;
          end;
        end;
      end;    

      //закончили предварительную проверку
      prFlag:=False;
      //флаг для осущ. нач запоминания в след. режиме
      prBegFl:=True;
      //получаем время запуска
      DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
      //время в секундах
      timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
      //время в мс
      timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
      form1.mmoTestResult.lines.add('ПРОВЕРКА ОСНОВНОГО РЕЖИМА РАБОТЫ БВК');
      //подача команды НОВ для установки основной проверки на БВК
      SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=0');
    end;
  end
  else
  begin
    //основная
    //form1.mmoTestResult.Lines.Add('Время О (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
    Delay_ms(5);

    //первое заполнение
    if (prBegFl) then
    begin
      prBegFl:=False;
      //получаем первое состояние канала
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        testBVK_Arr_G_curr[iCh]:=dataMKB[iCh];
        testBVK_Arr_G_BegState[iCh]:=dataMKB[iCh];
      end;
    end
    else
    begin
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        testBVK_Arr_G_prev[iCh]:=testBVK_Arr_G_curr[iCh];
        testBVK_Arr_G_curr[iCh]:=dataMKB[iCh];
      end;
      //получили текущее состояние и предидущее

      //проверяем изменилось ли состояние каналов
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        if Abs(testBVK_Arr_G_prev[iCh]-testBVK_Arr_G_curr[iCh])>=10 then
        begin
          // проверим в свое ли время оно изменилось
          for iT:=testedState_G[iCh] to BVK_NUM_SETS+1 do    // iT:=  1
          begin
            //проверяем установлено такое время переключения
            //или переключения обратно
            strOut:='';
            if (iCh>=9) then
            begin
              strOut:='Канал К'+intTostr(iCh+2)+':';
            end
            else
            begin
              strOut:='Канал К'+intTostr(iCh)+':';
            end;

            if testMTime(testBVK_Arr_G[iCh].setTime[iT],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //в свое
              //form1.mmoTestResult.Lines.Add('Время О (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              //form1.mmoTestResult.Lines.Add('Отладка:'+intTostr(testBVK_Arr_G[iCh].setTime[iT])+' '+intTostr(testBVK_Arr_G[iCh].durabilityT[iT])+' вх');
              if abs(testBVK_Arr_G_prev[iCh]-testBVK_Arr_G_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' НОРМА'+' ВКЛ');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!НЕ НОРМА!!'+' ВКЛ');
                BVKTestFlag:=False;
              end;
              Inc(testedState_G[iCh]);
              Break;
            end
            else if testMTime(testBVK_Arr_G[iCh].setTime[iT-1]+testBVK_Arr_G[iCh].durabilityT[iT-1],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //в свое
              //form1.mmoTestResult.Lines.Add('Время О (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              //form1.mmoTestResult.Lines.Add('Отладка:'+intTostr(testBVK_Arr_G[iCh].setTime[iT-1])+' '+intTostr(testBVK_Arr_G[iCh].durabilityT[iT-1])+' вых');
              if abs(testBVK_Arr_G_prev[iCh]-testBVK_Arr_G_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' НОРМА'+' ВЫКЛ');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('Время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!НЕ НОРМА!!'+' ВЫКЛ');
                BVKTestFlag:=False;
              end;
              Break;
            end
            else
            begin
              //form1.mmoTestResult.Lines.Add('Время О (мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              //не в свое
              form1.mmoTestResult.Lines.Add('Ложное время переключения(мсек):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut);
              //form1.mmoTestResult.Lines.Add('Отладка:'+intTostr(testBVK_Arr_G[iCh].setTime[iT])+' '+intTostr(testBVK_Arr_G[iCh].durabilityT[iT]));
              BVKTestFlag:=False;
            end;
          end;
        end;
      end;
    end;
    //время завершения основного режима 330000 сек
    if testMTime(330000,timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
    begin
      //проверяем константные каналы на соответствие
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        chTestInt:=0;
        strOut:='';
        if (iCh>=9) then
        begin
          strOut:='Канал К'+intTostr(iCh+2)+':';
        end
        else
        begin
          strOut:='Канал К'+intTostr(iCh)+':';
        end;

        for iT:=1 to BVK_NUM_SETS do
        begin
          chTestInt:=chTestInt+testBVK_Arr_G[iCh].setTime[iT];
        end;
        if chTestInt=0 then
        begin
          //константа
          if abs(testBVK_Arr_G_BegState[iCh]-testBVK_Arr_G_curr[iCh])<=3 then
          begin
            form1.mmoTestResult.Lines.Add(strOut+' НОРМА'+' ВКЛ');
          end
          else
          begin
            form1.mmoTestResult.Lines.Add(strOut+'!!НЕ НОРМА!!'+' ВКЛ');
            BVKTestFlag:=False;
          end;
        end;
      end;     

      //установка флага основной проверки
      genFlag:=False;
      //закончили проверку
      if (BVKTestFlag) then
      begin
        form1.mmoTestResult.Lines.Add('ПРОВЕРКА БВК: '+'НОРМА');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('ПРОВЕРКА БВК: '+'!!НЕ НОРМА!!');
      end;  
      form1.tmrTestBVK.Enabled:=false;
    end;
  end;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  //подача команды НОВ на БВК для теста!!!
  SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=0');
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  {SetVoltageOnPowerSupply(1,'0000');
  SetOnPowerSupply(1);
  Delay_S(5);
  SetOnPowerSupply(0);
  //замыкаем контакты команды НОВ
  SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');

  //проверка подключения источника питания
  if (PowerTestConnect) then
  begin
    form1.Memo1.Lines.Add('Источник питания АКИП-1105 подключен!');
    SetVoltageOnPowerSupply(1,'2700');
    SetOnPowerSupply(1);
 //   SetVoltageOnPowerSupply(1,'0000');
    //Delay_S(5);
    //выставим 27 В

  end
  else
  begin
    form1.Memo1.Lines.Add('Источник питания АКИП-1105 не подключен!');
  end;}
  if (flagTestDev) then
  begin
    {SetOnPowerSupply(0);
    SetVoltageOnPowerSupply(1,'0000');
    SetOnPowerSupply(1);
    Delay_ms(10);
    SetOnPowerSupply(0); }
    //замыкаем контакты команды НОВ
    SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');

    SetVoltageOnPowerSupply(1,'2700');
    SetOnPowerSupply(1);
  end;

  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //время в секундах
  timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //время в мс
  timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  form1.tmrBVK2.Enabled:=True;

end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  if startBVktime=4 then   //3
  begin
    Form1.tmr1.Enabled:=false;
    //запуск проверки БВК.
    testBVK;
  end;
  Inc(startBVktime);
end;

procedure TForm1.tmrBVK2Timer(Sender: TObject);
begin
  //получаем время системы
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //время в сек.
  timeBVKCarSec:=hourBVK*60*60+minBVK*60+secBVK;
  //время в мсек
  timeBVKCarMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  Form1.lbl2.Caption:=IntToStr(timeBVKCarSec-timeBVKPrevSec);
end;

procedure TForm1.btnPoweroffClick(Sender: TObject);
begin
  SetOnPowerSupply(0);
  SetVoltageOnPowerSupply(1,'0000');
  SetOnPowerSupply(1);
  Delay_ms(10);
  SetOnPowerSupply(0);
end;

procedure TForm1.btnPowerOnClick(Sender: TObject);
begin
    SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');
    SetVoltageOnPowerSupply(1,'2700');
    SetOnPowerSupply(1);
end;

end.

