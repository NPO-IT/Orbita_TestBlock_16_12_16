unit OrbitaAll;

interface

uses
  SysUtils,Windows, Messages,Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, StdCtrls, Series, TeEngine, TeeProcs, Chart, ExtCtrls,
  Lusbapi,  Math, Buttons, ComCtrls, xpman, DateUtils,
  MPlayer,iniFiles,StrUtils,syncobjs,ExitForm, Gauges,TLMUnit,LibUnit,ACPUnit,UnitM16,
  OutUnit,UnitMoth,TestUnit_N1_1, IdUDPBase, IdUDPServer,IdSocketHandle;
//Lusbapi-���������� ��� ������ � ��� �20-10
//Visa_h-���������� ��� ������ � ����������� � �����������
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
    //���� ��� ���������� ������ 1 ���
    //modC: boolean;
    //������� ��� ���������� ���������� ���������� ���
    masAnlBusChCount: integer;
    //������ ��� �������� �������� ���� ������.11 ������� �����
    {masGroup:array[1..SIZEMASGROUP] of word;}

    //������ ��� �������� �������� ���� ������.12 �����
    {masGroupAll:array[1..SIZEMASGROUP] of word;}
    //bool:boolean;
    //----------------------------------- M08,04,02,01
    //������� ����
    //fraseCount: integer;
    //������� �����
    //groupCount: integer;

    //7 ��������� �������� � 0 �� 127 ������ ������
    bufNumGroup:byte;
    //������� ����������� ���� ���
    iBusArray:integer;
    //���� ��� ������ ������� ��� ���. ������� ���
    flagWtoBusArray:boolean;
    procedure OutMG(errMG:Integer);
    //��������������� ��������� ��� ������ ������ �������� �����
    procedure TestSMFOutDate(numPointDown:Integer;numCurPoint:integer;numPointUp:integer);
    //���������� ��������� � ������ ��� ������ ������
    procedure ReInitialisation;
    //���������� ������
    //procedure SaveReport;
    //��� ������ � ��������� ������(������� �������� ���� �����(system))
    procedure WriteSystemInfo(value: string);
    //������� �������� �������� � ������� ������
    function AvrValue(firstOutPoint: integer; nextPointStep: integer;
      masGroupS: integer): integer;

    constructor CreateData;

    //m08,04,02,01
    //
    //�������� ������ ����������� ������� (����� �����),



    function TestMarker(begNumPoint: integer; const pointCounter: integer): boolean;



    function BuildBusValue(highVal:word;lowerVal:word):word;
    function CollectBusArray(var iBusArray:integer):boolean;
  end;

  


var
  Form1: TForm1;
   
  //===================================
  //���������� ��� ������ � ���
  //===================================

  //=============================
  //��������� ��������.
  //=============================
  //RS485
  //���������� ��� �������� ip-������ �������� RS485 (ini-����)
  HostAdapterRS485: string;
  //���������� ��� �������� ������ ����� ��� ��������
  PortAdapterRS485: integer;
  //���1
  //���������� ��� �������� ip-������ ������� ��� (ini-����)
  HostISD1: string;
  //���2
  //���������� ��� �������� ip-������ ������� ��� (ini-����)
  HostISD2: string;
  //���������
  //���������� ��� �������� �������������� ����������
  RigolDg1022: string;
  //���������_1
  m_defaultRM_usbtmc_1, m_instr_usbtmc_1: array[0..3] of LongWord;
  viAttr_1: Longword = $3FFF001A;

  //���������_2
  m_defaultRM_usbtmc_2, m_instr_usbtmc_2: array[0..3] of LongWord;
  viAttr_2: Longword = $3FFF001A;

  viAttr: Longword = $3FFF001A;
  Timeout: integer = 1000; //7000
  //==============================

  //==============================
  //������ � �������
  //==============================
  //�������� ���������� ��� ������ � ��������� ������
  systemFile: Text;
  //�������� ���������� ��� ������������ ������ �������� � ����
  reportFile: Text;
  //���� ������ � ���
  LogFile: text;
  //==============================

  //����� ��� ������ � �������� ������
  //data: Tdata;

  dataM16:TDataM16;
  dataMoth:TDataMoth;

  //����� ��� ������ � TLM
  tlm: Ttlm;
  //����� ��� ������ � ���
  acp: Tacp;

  //����. ������ ��� ���������� �������
  masElemParam: array of channelOutParam;

  arrAddrOk:array of string;

  //������� ������ ������. ����� ������� ������
  iCountMax: integer;
  //���. ���������� �������
  acumAnalog: integer;
  //�����. ������������� �������
  acumTemp:Integer;
  //������� ���������� ����. ����������
  outTempAdr:Integer;
  //���. ����������
  acumContact: integer;
  //���. �������
  acumFast: integer;
  //���. ��� �������
  acumBus:integer;
  //���������� ����������� ���� � ������� ������ �� ���������������
  masGroupSize: integer;

  masGroup: array[1..SIZEMASGROUP] of word;
  masGroupAll: array[1..SIZEMASGROUP] of word;


  //������ � ���������������� ������
  infStr: string;



  //������� ��� �������� ������ ������
  countC: integer;

  //���������� ��� ini ����� ��� ����������� ���� ���������� ����� ��������
  propIniFile:TiniFile;
  propStrPath:string;


  flagEnd:boolean;

  //���� ��� 32-����. ����
  //swtFile:text;

  cOut:integer;
  csk:TCriticalSection;

  boolFlg:boolean;

  testOutFalg:boolean;

  //textTestFile:Text;
  //���� ��� ������ ������ �����
  orbOk:Boolean;
  orbOkCounter:integer;

  flagTrue:boolean;

  //������������ � ����������� �������� ������ � ���
  maxValue, minValue: integer;


implementation


//uses Unit1;

{$R *.dfm}

//==============================================================================
//��������� ���������� �� ����� � ����
//==============================================================================
//������������ ����� �����

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
  //�������� �� ������������ �������
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
        ShowMessage('����������� ������ �� �����. ��������� ���������������');
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
  //������ � ������.
  str: string;
  masEcount: integer;
  rez:boolean;
begin
  rez:=false;
  //�������� �� ������������ ���� �������
  for i := 0 to form1.OrbitaAddresMemo.Lines.Count - 1 do
  begin
    str := '';
    str := form1.OrbitaAddresMemo.Lines.Strings[i][1] +
      form1.OrbitaAddresMemo.Lines.Strings[i][2]+form1.OrbitaAddresMemo.Lines.Strings[i][3];
    //�������� � �� ���������� �� ��� �����������
    if str = '---' then
    begin
      //�������� �� ��������� �������� �����
      Continue;
    end;

    if ((str = 'M16')or(str = 'M08')or(str = 'M04')or(str = 'M02')or(str = 'M01')) then
    begin
      //�������� ����������� ������� ������ �� ��������� ���������������
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
      //ShowMessage('��������� ������������ �������');
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
        //�������� ����������� ������� ������ �� ��������� ���������������
        //����� �������� ����. ��� ������ ������� ����� ��� �08,04,02,01
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

        //���������� ��������� � ������� ����� �� ���������������
        masCircleSize:=masGroupSize*32;


        //���. ����. �����. ������� ����� ������
        for masEcount := 1 to FIFOSIZE do
        begin
          fifoMas[masEcount] := 9;
        end;

        //�������� ������ ��� ������ ������ 11 ���. �� �������
        //SetLength(masGroup, masGroupSize);
        //�������� ������ ��� ������ ������ 12 ���. ��� ����� �������
        //SetLength(masGroupAll, masGroupSize);
        for masEcount := 1 to masGroupSize do
        begin
          masGroup[masEcount] := 9;
          masGroupAll[masEcount] := 9;
        end;


        //���. ��������� ����� ������. �������� ������ ������� �����
        //0 �����
        {data.}reqArrayOfCircle := 0;
        //SetLength(masCircle[data.reqArrayOfCircle], masGroupSize * 32);
        //form1.Memo1.Lines.Add(intToStr(length(masCircle[reqArrayOfCircle])));
        //����. ������� �����
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
//��������� ��� �������� ������� ����� ������� � ������� ����
//==============================================================================

procedure CountAddres;
var
  //������� �������� ���� ���������� �������
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
        //����������  T01,T01-01(9 ����.)
        inc(acumAnalog);
      end;
      1:
      begin
        //����������
        inc(acumContact);
      end;
      2, 3, 4, 5:
      begin
        //�������
        inc(acumFast);
      end;
      6:
      begin
        //���
        inc(acumBus);
      end;
      7:
      begin
        //�������������
        inc(acumTemp);
      end;
    end;
    inc(adrCount);
  end;


   //�������� ������ ��� ������ ������������� ����������, ��� ��� ��� ��������� ��������
  SetLength(slowArr,acumAnalog);
  //�������� ������ ��� ������ ������������� ����������, ��� ��� ��� ��������� ��������
  SetLength(tempArr,acumTemp);
  SetLength(tempArr2,acumTemp);
end;
//==============================================================================

//==============================================================================
//���������� ������� ������� �����
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
  //������ ����� ������ ������
  fNumGr:=Trunc(fElemGr/masGroupSize)+1;
  //���� ������ ������� ��������� �� � ������ ������,
  //�� ��������� ����� ������ � ������ ������������� �� �� ������
  if fElemGr>masGroupSize then
  begin
    fNum:=fElemGr-((fNumGr-1)*masGroupSize);
  end;

  sElemGr:=stepNum;
  //�������� �� ���� ������
  sNumGr:=Trunc(sElemGr/masGroupSize);
  iG:=fNumGr;
  SetLength(masElemParam[iArrElemPar].arrNumGroup,i+1);
  masElemParam[iArrElemPar].arrNumGroup[i]:=iG;
  Inc(i);
  iG:=iG+sNumGr;
  //��������� ������ �� ������� ��� ������������ ����� ����� 4
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
//��������� ��� ��������� ��������� ������� ��� �������� �� ������ ���������� ������
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
    // ������� �� ���� ������� ��������� ������ ����������� �� ���������� ������
    // ���������� �����
    //������������ � ���� ������ ��� ������ ������� � �������� �� ���������� �����
    //� ������
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

    //����
    //���� ��� ��������� ����������� ����������� ������ � �������
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //� ������� ������������ �������� � �������
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;

    iMinCiklNumber:=arrNumbersCikl[1];

    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;




    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //������
    //���� ��� ��������� ����������� ����������� ����� � �������
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //� ������� ������������ �������� � �������
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];
    
    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

    {if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //����� ����������� ���������� ������ ��� ������� ������ ���������
    //��������� ���� �� ���� ��������� � �������� �� ��� � ������ ����������
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        //������� �� �����. ������ ����������
        masElemParam[i].flagCikl:=true;
        //������� �� �����. ����� �� ����������
        masElemParam[i].flagGroup:=true;
        //������������ ��� �������� ��� ���� ������� ��������� ������������
        if  maxAdrStepCikl>maxAdrStepGr then
        begin
          masElemParam[i].stepOutG:=maxAdrStepCikl;
        end
        else
        begin
          masElemParam[i].stepOutG:=maxAdrStepGr;
        end;


        //����
        //��������� ���� �� � ������� ������� ������ ��������
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������ ������
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumCikl:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //��� ���������.
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:= masElemParam[iMinCiklNumber].arrNumCikl[j];
          end;
        end;

        //������
        //��������� ���� �� � ������� ������� ����� ��������
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //���� ��������. ��������� �� ����������� ����������
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������� ������
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumGroup:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //��� ���������.
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
    //������� ���������� �� ���������� ������, ���� �����
    //������������ � ���� ������ ��� ������ ������� � �������� �� ���������� �����
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

    //���� ��� ��������� ����������� ����������� ����� � �������
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //� ������� ������������ �������� � �������
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;
    iMinCiklNumber:=arrNumbersCikl[1];
    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;

    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //����� ����������� ���������� ������ ��� ������� ������ ���������
    //��������� ���� �� ���� ��������� � �������� �� ��� � ������ ����������
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        //������� �� �����. ������ ����������
        masElemParam[i].flagCikl:=true;
        //������� �� �����. ����� �� ����������
        masElemParam[i].flagGroup:=false;
        //������������ ��� �������� ��� ���� ������� ��������� ������������
        masElemParam[i].stepOutG:=maxAdrStepCikl;


        //��������� ���� �� � ������� ������� ������ ��������
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������ ������
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumCikl:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //��� ���������.
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
    //������� ���������� �� ���������� ����� ���� ������
    //������������ � ���� ������ ��� ������ ������� � �������� �� ���������� �����
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

    //���� ��� ��������� ����������� ����������� ����� � �������
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //� ������� ������������ �������� � �������
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];

    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

   { if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //����� ����������� ���������� ����� ��� ������� ������ ���������
    //��������� ���� �� ���� ��������� � �������� �� ��� � ������ ����������
    for i:=0 to masElemParamLen-1 do
    begin
      if ((masElemParam[i].adressType=0)or(masElemParam[i].adressType=8)) then
      begin
        //������� �� �����. ������ �� ����������
        masElemParam[i].flagCikl:=false;
        //������� �� �����. ����� ����������
        masElemParam[i].flagGroup:=true;
        //������������ ��� �������� ��� ���� ������� ��������� ������������
        masElemParam[i].stepOutG:=maxAdrStepGr;

        //��������� ���� �� � ������� ������� ����� ��������
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //���� ��������. ��������� �� ����������� ����������
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������� ������
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumGroup:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //��� ���������.
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
//��������� ��� ��������� ���������� ������� ��� �������� �� ������ ���������� ������
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
    // ������� �� ���� ������� ��������� ������ ����������� �� ���������� ������
    // ���������� �����
    //������������ � ���� ������ ��� ������ ������� � �������� �� ���������� �����
    //� ������
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

    //����
    //���� ��� ��������� ����������� ����������� ������ � �������
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //� ������� ������������ �������� � �������
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;

    iMinCiklNumber:=arrNumbersCikl[1];

    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;

    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //������
    //���� ��� ��������� ����������� ����������� ����� � �������
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //� ������� ������������ �������� � �������
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];

    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

    {if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //����� ����������� ���������� ������ ��� ������� ������ ���������
    //��������� ���� �� ���� ��������� � �������� �� ��� � ������ ����������
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        //������� �� �����. ������ ����������
        masElemParam[i].flagCikl:=true;
        //������� �� �����. ����� �� ����������
        masElemParam[i].flagGroup:=true;
        //������������ ��� �������� ��� ���� ������� ��������� ������������
        if  maxAdrStepCikl>maxAdrStepGr then
        begin
          masElemParam[i].stepOutG:=maxAdrStepCikl;
        end
        else
        begin
          masElemParam[i].stepOutG:=maxAdrStepGr;
        end;


        //����
        //��������� ���� �� � ������� ������� ������ ��������
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������ ������
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumCikl:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //��� ���������.
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:= masElemParam[iMinCiklNumber].arrNumCikl[j];
          end;
        end;

        //������
        //��������� ���� �� � ������� ������� ����� ��������
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //���� ��������. ��������� �� ����������� ����������
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������� ������
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumGroup:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //��� ���������.
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
    //������� ���������� �� ���������� ������, ���� �����
    //������������ � ���� ������ ��� ������ ������� � �������� �� ���������� �����
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

    //���� ��� ��������� ����������� ����������� ����� � �������
    minCiklNumber:=Length(masElemParam[arrNumbersCikl[1]].arrNumCikl);
    //� ������� ������������ �������� � �������
    maxAdrStepCikl:=masElemParam[arrNumbersCikl[1]].stepOutG;

    iMinCiklNumber:=arrNumbersCikl[1];

    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iCikl-1 do
    begin
      if  minCiklNumber>Length(masElemParam[arrNumbersCikl[i]].arrNumCikl) then
      begin
        minCiklNumber:=Length(masElemParam[arrNumbersCikl[i]].arrNumCikl);
        iMinCiklNumber:=arrNumbersCikl[i];
      end;

      if maxAdrStepCikl<masElemParam[arrNumbersCikl[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepCikl:=masElemParam[arrNumbersCikl[i]].stepOutG;
      end;
    end;

    {if  iCikl-1<2 then
    begin
      iMinCiklNumber:=arrNumbersCikl[1];
    end;}

    //����� ����������� ���������� ������ ��� ������� ������ ���������
    //��������� ���� �� ���� ��������� � �������� �� ��� � ������ ����������
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        //������� �� �����. ������ ����������
        masElemParam[i].flagCikl:=true;
        //������� �� �����. ����� �� ����������
        masElemParam[i].flagGroup:=false;
        //������������ ��� �������� ��� ���� ������� ��������� ������������
        masElemParam[i].stepOutG:=maxAdrStepCikl;


        //��������� ���� �� � ������� ������� ������ ��������
        if (masElemParam[i].arrNumCikl<>nil) then
        begin
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������ ������
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(arrCikl,j+1);
            arrCikl[j]:=masElemParam[i].arrNumCikl[j];
          end;
          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumCikl:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minCiklNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumCikl,j+1);
            masElemParam[i].arrNumCikl[j]:=arrCikl[j];
          end;
          arrCikl:=nil;
        end
        else
        begin
          //��� ���������.
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
    //������� ���������� �� ���������� ����� ���� ������
    //������������ � ���� ������ ��� ������ ������� � �������� �� ���������� �����
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

    //���� ��� ��������� ����������� ����������� ����� � �������
    minGrNumber:=Length(masElemParam[arrNumbersGr[1]].arrNumGroup);
    //� ������� ������������ �������� � �������
    maxAdrStepGr:=masElemParam[arrNumbersGr[1]].stepOutG;

    iMinGrNumber:=arrNumbersGr[1];

    //�������� �� ���� ������� � ������ ����������� ���������� �����
    for i:=2 to iGr-1 do
    begin
      if  minGrNumber>Length(masElemParam[arrNumbersGr[i]].arrNumGroup) then
      begin
        minGrNumber:=Length(masElemParam[arrNumbersGr[i]].arrNumGroup);
        iMinGrNumber:=arrNumbersGr[i];
      end;

      if maxAdrStepGr<masElemParam[arrNumbersGr[i]].stepOutG then
      begin
        //����������� �������� ������������� �������� ��� ������� ����� �� ������ ������
        maxAdrStepGr:=masElemParam[arrNumbersGr[i]].stepOutG;
      end;
    end;

    {if  iGr-1<2 then
    begin
      iMinGrNumber:=arrNumbersGr[1];
    end;}

    //����� ����������� ���������� ����� ��� ������� ������ ���������
    //��������� ���� �� ���� ��������� � �������� �� ��� � ������ ����������
    for i:=0 to masElemParamLen-1 do
    begin
      if masElemParam[i].adressType=1 then
      begin
        //������� �� �����. ������ �� ����������
        masElemParam[i].flagCikl:=false;
        //������� �� �����. ����� ����������
        masElemParam[i].flagGroup:=true;
        //������������ ��� �������� ��� ���� ������� ��������� ������������
        masElemParam[i].stepOutG:=maxAdrStepGr;

        //��������� ���� �� � ������� ������� ����� ��������
        if (masElemParam[i].arrNumGroup<>nil) then
        begin
          //���� ��������. ��������� �� ����������� ����������
          //���������� �� ��������� ������ ����������� ����� �����(�����) ��� ������� ������
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(arrGr,j+1);
            arrGr[j]:=masElemParam[i].arrNumGroup[j];
          end;

          //�������� ������ ��� ��� ���������� � ����
          masElemParam[i].arrNumGroup:=nil;
          //�������������� ������ ����� ��� ������� �� ����� ������� ���������� �� ������ ����
          for j:=0 to minGrNumber-1 do
          begin
            SetLength(masElemParam[i].arrNumGroup,j+1);
            masElemParam[i].arrNumGroup[j]:=arrGr[j];
          end;
          arrGr:=nil;
        end
        else
        begin
          //��� ���������.
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
//���������� ������� ������� ������
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
  //������ ����� ������� �����
  fNumCikl:=Trunc(fElemC/(masGroupSize*32))+1;
  //���� ������ ������� ��������� �� � ������ �����,
  //�� ��������� ����� ����� � ������ ������������� �� ��� ������
  if fElemC>masGroupSize*32 then
  begin
    fNum:=fElemC-((fNumCikl-1)*masGroupSize*32);
  end;


  sElemC:=stepNum;
  //�������� �� ���� �����
  sNumCikl:=Trunc(sElemC/(masGroupSize*32));
  iC:=fNumCikl;
  SetLength(masElemParam[iArrElemPar].arrNumCikl,i+1);
  masElemParam[iArrElemPar].arrNumCikl[i]:=iC;
  Inc(i);
  iC:=iC+sNumCikl;
  //��������� ������ �� ������� ��� ������������ ����� ����� 4
  while iC<=MAXCIKLNUM do
  begin
    SetLength(masElemParam[iArrElemPar].arrNumCikl,i+1);
    masElemParam[iArrElemPar].arrNumCikl[i]:=iC;
    iC:=iC+sNumCikl;
    Inc(i);
  end;

  fElemGr:=fElemC-((fNumCikl-1)*masGroupSize*32);
  //sElemGr:=sElemC-((sNumCikl-1)*masGroupSize*32);

  //��������� ���� �� ��������� ������ ������
  if sElemGr>masGroupSize then
  begin
    //���������� ������� ������ ����� ���������� ������� �����
    FillGroupArr(iArrElemPar,fElemGr,sElemGr);
  end;

end;
//==============================================================================


//==============================================================================
//������ ������� ������M16
//==============================================================================
function AdressAnalyser(adressString: string; var imasElemParam: integer):Boolean;
var
  //���������� ��� ��������
  iGraph: integer;
  flagM: boolean;
  //���������� ��� �������� ASCII-���� �������
  codAsciiGraph: integer;
  stepKoef: integer;
  //��������� ��� ���������� ���������
  Ma, Mb, Mc, Md, Me, Mx: integer; //Ma=N1-1;Mb=N2-1;Mc=N3-1; � �.�
  //���� ��� ���������� ������
  //Fa=8, ���� K=0; Fa=4, ���� K=1; Fa=2, ���� K=2; ���������� ��� ������
  Fa, Fb, Fc, Fd, Fe, Fx: integer;
  //�������� ����. � �������, ������� �� �1 ��� �2
  pBeginOffset: integer;
  flagBegin: boolean;
  stepOutGins: integer;
  offset: integer;

  //��������������� ������ � ���� ������ �����
  infStrInt: integer;

  adrLength:Integer;

  //���� ��� �������� ���������� ������� ������
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
    //������ ������ ������ ���� ����������� �
    if adressString[iGraph] = 'M' then
    begin
      //� ����.
      flagM := true;
    end;

    if (flagM) then
    begin
      //M16
      if (adressString[iGraph + 1] = '1') and (adressString[iGraph + 2] = '6') then
      begin
        if ((adressString[iGraph + 3] = '�') or (adressString[iGraph + 3] = '�')) then
        begin
          if (adressString[iGraph + 4] = '1') then
          begin
            //������ ���. �������� ��� ������� �� �������
            pBeginOffset := 1;
          end;
          if (adressString[iGraph + 4] = '2') then
          begin
            //������ ���. �������� ��� ������� �� �������
            pBeginOffset := 2;
          end;
          flagBegin := true;
          iGraph := iGraph + 5;
          break;
        end
        else
        begin
          showMessage('������! �������� ����������� ������,'
            + '��������� ��������������� �� �� �������������!');
          //Application.Terminate;
          halt;
        end;
      end
      //���������
      else
      begin
        //��� ��������
        pBeginOffset := 1;
        flagBegin := true;
        iGraph := iGraph + 3;
        break;
      end;
    end;
  end;

  if (flagBegin) then
  begin
    //������������ ����� ���������
    while {(adressString[iGraph]<>' ')} iGraph <= adrLength do
    begin
      codAsciiGraph := ord(adressString[iGraph]);
      // ��������� ������������ ���� � ����� ��������� ����� � ���.
      case codAsciiGraph of
        //����� �(�)
        65, 97:
        begin
          Ma := strToInt(adressString[iGraph + 1]);
          case infNum of
            0:
            begin
              //M16
              if ((Ma<1)or(Ma>8)) then
              begin
                //������ ������� ������. �������� �����
                isOkAdr:=False;
                Break;
              end;
            end;
            1:
            begin
              //M08
              if ((Ma<1)or(Ma>8)) then
              begin
                //������ ������� ������. �������� �����
                isOkAdr:=False;
                Break;
              end;
            end;
            2:
            begin
              //M04
              if ((Ma<1)or(Ma>4)) then
              begin
                //������ ������� ������. �������� �����
                isOkAdr:=False;
                Break;
              end;
            end;
            3:
            begin
              //M02
              if ((Ma<1)or(Ma>2)) then
              begin
                //������ ������� ������. �������� �����
                isOkAdr:=False;
                Break;
              end;
            end;
            4:
            begin
              //M01
              if (Ma<>1) then
              begin
                //������ ������� ������. �������� �����
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
                  //���� Fa < 1 �� ������ ������ ���� �� �����
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
                  //���� Fa < 1 �� ������ ������ ���� �� �����
                  //!! ������
                  isOkAdr:=False;
                  Break;
                end;
                4:
                begin
                  //M01
                  //Fa := 0;
                  //���� Fa < 1 �� ������ ������ ���� �� �����
                  //!! ������
                  isOkAdr:=False;
                  Break;
                end;
              end;
            end;
          end;
          stepOutGins := Fa;
          offset := offset + Ma;
        end;
        //����� B(b)
        66, 98:
        begin
          Mb := strToInt(adressString[iGraph + 1]);
          if ((Mb<1)or(Mb>8)) then
          begin
            //������ ������� ������. �������� �����
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
        //����� C(c)
        67, 99:
        begin
          Mc := strToInt(adressString[iGraph + 1]);
          if ((Mc<1)or(Mc>8)) then
          begin
            //������ ������� ������. �������� �����
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
        //����� D(d)
        68, 100:
        begin
          Md := strToInt(adressString[iGraph + 1]);
          if ((Md<1)or(Md>8)) then
          begin
            //������ ������� ������. �������� �����
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
        //����� E(e)
        69, 101:
        begin
          Me := strToInt(adressString[iGraph + 1]);
          if ((Me<1)or(Me>8)) then
          begin
            //������ ������� ������. �������� �����
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
        //����� X(x)
        88, 120:
        begin
          Mx := strToInt(adressString[iGraph + 1]);
          if ((Mx<1)or(Mx>8)) then
          begin
            //������ ������� ������. �������� �����
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
        //����� T(t)
        84, 116:
        begin
          if ((adressString[iGraph + 1] = '0')and(adressString[iGraph + 2] = '1')and
                       (adressString[iGraph + 3] = '-')and(adressString[iGraph + 4] = '0')and
                       (adressString[iGraph + 5] = '1')
                  ) then

          begin

            //T01-01. ��������� ���������� ������ 9 ��������
            masElemParam[imasElemParam].adressType := 8;

          end
          else if ((adressString[iGraph + 1] = '0')and(adressString[iGraph + 2] = '5')) then
          begin
            //T05. ���������� 1.
            masElemParam[imasElemParam].adressType := 1;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '1')) then
          begin
            //T21 ������� 1.
            masElemParam[imasElemParam].adressType := 3;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '2')) then
          begin
            //T22. ������� 2.
            masElemParam[imasElemParam].adressType := 2;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '3')) then
          begin
            //T23. ������� 3.
            masElemParam[imasElemParam].adressType := 4;
          end else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '4')) then
          begin
            //T24 ������� 4.
            //���� ��� ��� ��� �������
            masElemParam[imasElemParam].adressType := 5;
          end
          else if ((adressString[iGraph + 1] = '2')and(adressString[iGraph + 2] = '5')) then
          begin
            //T25. ���. ��� ��������
            masElemParam[imasElemParam].adressType := 6;
          end
          else if ((adressString[iGraph + 1] = '1')and(adressString[iGraph + 2] = '1')) then
          begin
            //T11. �������������
            masElemParam[imasElemParam].adressType := 7;
          end
          else if ((adressString[iGraph + 1] = '0')and(adressString[iGraph + 2] = '1')) then
          begin
             //T01. ���������� 0.
            masElemParam[imasElemParam].adressType := 0;
            //��������� ����� ����.
            //������������ ������ ��� ����������.
            masElemParam[imasElemParam].bitNumber := 0;

          end
          else
          begin
            //���� �� ���� �� ����� �� ������
            isOkAdr:=False;
            Break;
          end;
        end;
        //����� P(p)
        80, 112:
        begin
          //����������� � ���������� ���� �����.
          //� ��������� ��������� ���������� ��� ����� ����������
          //��������� ����� ����. ������������ ������
          //��� ����������. ������������ ��� �������.
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
      //�������� ���������� ������ ������� � ����������� �� ��� ����. ������
      //M16
      if infStrInt = 16 then
      begin
        {if  ((pBeginOffset + 2 * offset)>(masGroupSize*32)) then
        begin
          //� �����
          fElemC:=pBeginOffset + 2 * offset;
          //������ ����� ������� �����
          iCikl:=Trunc(fElemC/(masGroupSize*32));
          //�������� � ����� ������
          if (fElemC-(iCikl*(masGroupSize*32)))>masGroupSize then
          begin
            fElemGr:=fElemC-(iCikl*(masGroupSize*32));
            iGr:=Trunc(fElemGr/masGroupSize);
            //������ ����� �������� � ������ ������
            masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
          end
          else
          begin
            //������ ����� �������� � ������ ������
            masElemParam[imasElemParam].numOutElemG:=fElemC-(iCikl*(masGroupSize*32));
          end;
        end
        else if  ((pBeginOffset + 2 * offset)>masGroupSize) then
        begin
          //� ������
          fElemGr:=pBeginOffset + 2 * offset;
          //������ ����� ������ ������
          iGr:=Trunc(fElem/masGroupSize);
          //������ ����� �������� � ������ ������
          masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
        end
        else
        begin
          //� ������ ������ ������� �����
          masElemParam[imasElemParam].numOutElemG := pBeginOffset + 2 * offset;
        end; }
        masElemParam[imasElemParam].numOutElemG := pBeginOffset + 2 * offset;
      end
      //���������
      else
      begin
        {if  ((pBeginOffset + offset)>(masGroupSize*32)) then
        begin
          //� �����
          fElemC:=pBeginOffset + offset;
          //������ ����� ������� �����
          iCikl:=Trunc(fElemC/(masGroupSize*32));
          //�������� � ����� ������
          if (fElemC-(iCikl*(masGroupSize*32)))>masGroupSize then
          begin
            fElemGr:=fElemC-(iCikl*(masGroupSize*32));
            iGr:=Trunc(fElemGr/masGroupSize);
            //������ ����� �������� � ������ ������
            masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
          end
          else
          begin
            //������ ����� �������� � ������ ������
            masElemParam[imasElemParam].numOutElemG:=fElemC-(iCikl*(masGroupSize*32));
          end;
        end
        else if  ((pBeginOffset + offset)>masGroupSize) then
        begin
          //� ������
          fElemGr:=pBeginOffset + offset;
          //������ ����� ������ ������
          iGr:=Trunc(fElem/masGroupSize);
          //������ ����� �������� � ������ ������
          masElemParam[imasElemParam].numOutElemG:=fElemGr-(iGr*masGroupSize);
        end
        else
        begin
          //� ������ ������ ������� �����
          masElemParam[imasElemParam].numOutElemG := pBeginOffset + offset;
        end;}
        masElemParam[imasElemParam].numOutElemG := pBeginOffset + offset;
      end;

      //���������� ��� ��� ������� ����. ����� � �����. �� ��������������� ������
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
        //�������� ������ ������ �����
        //��������� ������ ������ � �������� ������ �� ������� ���� ����� �����
        FillCiklArr(imasElemParam,masElemParam[imasElemParam].numOutElemG,
          masElemParam[imasElemParam].stepOutG );
      end
      else if (masElemParam[imasElemParam].stepOutG>masGroupSize) then
      begin
        FillGroupArr(imasElemParam,masElemParam[imasElemParam].numOutElemG,
          masElemParam[imasElemParam].stepOutG );
      end;

      //��������� �� ��������� �������� �������
      //��������� ����� � 1 ��� ���� �������
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
  //������� ��������� ������� ������
  Result:=isOkAdr;
end;
//==============================================================================



//==============================================================================
//���������� ������� ���������� ������������� ������� �������16
//==============================================================================
function FillAdressParam:boolean;
var
  //���������� ������� ��� ������� ������ ������ �������
  adrCount: integer;
  //���� ���. �������
  iAdr: integer;
  maxAdrNum:Integer;
  //���� ���������� ������� �������
  isOk:Boolean;
begin
  isOk:=True;
  //��������� ������������� �������
  masElemParam := nil;
  iAdr := 0;
  maxAdrNum:=form1.OrbitaAddresMemo.Lines.Count - 1;
  for adrCount := 0 to maxAdrNum  do
  begin
    //��� ������� �� ������� ��������� ����� ��� ��� ���������� �����������
    if  form1.OrbitaAddresMemo.Lines.Strings[adrCount]<>'---' then
    begin
      //�����
      //������� ������ �� ������� ������� ����������
      setlength(masElemParam, iAdr  + 1);
      //���� ����� �������� ������� �� ������ true
      isOk:=AdressAnalyser(form1.OrbitaAddresMemo.Lines.Strings[adrCount], iAdr);
      if (not isOk) then
      begin
        //��������� ����� �������� � �������
        //������ ������ �� ���������
        Break;
      end;
      inc(iAdr);
    end;
  end;

  //���� ������� ��� ������� ������� �� ���� �� �������� ������
  if (isOk) then
  begin
    //��������� ������������ ���������� �������
    iCountMax := iAdr;
    //���������� ������� ����� ������� ���� � ������
    CountAddres;
    //masElemParam:=nil;

    //�������� ���� �� ����� ��������� ���������� ����� ��������� ������� �� �� ���� �����
    //T01 � T01-01
    vSlowFlagGr:=FillSlowFlagGr;
    //�������� ���� �� ����� ��������� ���������� ����� ��������� ������� �� �� ���� ������
    vSlowFlagCikl:=FillSlowFlagCikl;
    //���������� ��� ��������� ���������� ���������
    //��� ����������� ���� ������� � ����������� �� ����� ���������
    if ((vSlowFlagCikl)or(vSlowFlagGr)) then
    begin
      slowAdrCorrection;
    end;

    //�������� ���� �� ����� ���������� ���������� ����� ��������� ������� �� �� ���� �����
    vContFlagGr:=FillContFlagGr;
    //�������� ���� �� ����� ���������� ���������� ����� ��������� ������� �� �� ���� ������
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
//������� ��������
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
      //��������� ������ ������
      //������� ������ �� ������� ������� ����������
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
  //������� ������ �������
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
  //������ ��� ������ � ��������
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
  //�������. �������� ��� �����. �����. ������� ���� �������
  //��
  acumAnalog := 0;
  //����
  acumTemp:=0;
  //��
  acumContact := 0;
  //�
  acumFast := 0;
  //���
  acumBus := 0;

  //�������� �� ������ ������ ���� ��������� ������ �������
  TestNeedsAdrF;

  //��������� ����������� ������ �������
  GetAddrList;
  //��������� ������ ���������� �������
  SetOrbAddr; 
  //���������� ���������������
  form1.gistSlowAnl.AllowZoom:=false;
  form1.gistSlowAnl.AllowPanning:=pmNone;

  form1.fastGist.AllowZoom:=false;
  form1.fastGist.AllowPanning:=pmNone;

  form1.tempGist.AllowZoom:=False;
  form1.tempGist.AllowPanning:=pmNone;
  //�������� ������������ �������
  if (GenTestAdrCorrect) then
  begin
    //������ ��� ������ � ���
    tlm := Ttlm.CreateTLM;
    //��������� �������� ��������
    form1.tlmPSpeed.Position := 3;
    form1.tlmPSpeed.Enabled:=true;
    if form1.startReadACP.Caption = '�����' then
    //�����
    begin
      //AssignFile(textTestFile,'TextTestFile.txt');
      //Rewrite(textTestFile);
      //AssignFile(swtFile,ExtractFileDir(ParamStr(0)) + '/Report/' + '777.txt');
      //ReWrite(swtFile);
      //�������. ���� ������ �� ���� ������
      flagEnd:=false;
      //���������� ������� ����������.
      if (FillAdressParam) then
      begin
        form1.startReadACP.Caption := '����';
        //����� ������ ������
        form1.tlmWriteB.Enabled := true;
        form1.startReadTlmB.Enabled:=false;
        form1.propB.Enabled:=false;

        //���������� ��� � ������
        if  (not boolFlg) then
        begin
          acp := Tacp.InitApc;
          //������������ � ������ � ���
          acp.CreateApc;

          //�������� ���� ������ � ���
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
        //��������� �������� ��������
        form1.tlmPSpeed.Position := 3;
        form1.tlmPSpeed.Enabled:=false;
        ShowMessage('� ������ ������� ������������ ������!');
      end;
    end
    else
    //����
    begin
      flagEnd:=true;
      flagACPWork:=False;
      Form1.mmoTestResult.Clear;
      form1.startReadACP.Caption:= '�����';
      graphFlagFastP := false;
      //sleep(50);
      //pModule.STOP_ADC();

      //wait(50);

      flagACPWork:=False;
      //wait(50);

       //������ ��� ������ � ��������
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
        //��������� ������ � ���
        pModule.STOP_ADC();
      end;
      //�������� ��� ���������� �����
      flagEnd:=true;
      wait(20);
      //while (True) do Application.ProcessMessages; //!!!!
      WinExec(PChar('OrbitaMAll.exe'), SW_ShowNormal);
      wait(20);
      //�������� ���������� �� �����������.
      Application.Terminate;}
    end;
  end
  else
  begin
    ShowMessage('��������� ������������ �������!');
  end;
end;

//�������� ��������� � ������������� ������ �����������
//��� �������� ������ ���� ��� � ������.

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //���� �������� ���������� ��� ������ �� ��������� ������ � ���. ����� ���������.
  if ((form1.tlmWriteB.Enabled)and(not form1.startReadTlmB.Enabled)and
      (not form1.propB.Enabled))  then
  begin
    //��������� ������ � ���
    pModule.STOP_ADC();
  end;

  //�������� ��� ���������� �����
  flagEnd:=true;
  wait(20);
  //�������� ���������� �� �����������.
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
  //��������� ��������
  form1.diaSlowAnl.LeftAxis.Maximum := 1025.0;
  form1.gistSlowAnl.BottomAxis.Maximum := 300;
  form1.gistSlowAnl.BottomAxis.Minimum := 0;
  form1.gistSlowAnl.LeftAxis.Maximum := 1025;
  form1.gistSlowAnl.LeftAxis.Minimum := 0;
  path:=ExtractFileDir(ParamStr(0))+'\ConfigDir\property.ini';
  propIniFile:=TIniFile.Create(path);
  //������ �� ����� ���������� ������ ��������� path.
  propStrPath:=propIniFile.ReadString('lastPropFile','path','');
  //��������� ���� �� ����� ���� �������� �� ��.
  if FileExists(propStrPath) then
  begin
    //����, �� ��� ������ ������ ��
    if propStrPath='' then
    begin
      //����������� ��������� ������������
      //���. ���.
      form1.propB.Enabled := true;
      //�����
      form1.startReadACP.Enabled := false;
      //������
      form1.startReadTlmB.Enabled := false;
      //������ � tlm
      form1.tlmWriteB.Enabled := false;
      //������ ������
      form1.PanelPlayer.Enabled := false;
      //�������� ��������� � �����
      form1.TrackBar1.Enabled := false;
      //�������� ��������
      form1.tlmPSpeed.Enabled:=false;
      //���������� � ���� �������
      form1.saveAdrB.Enabled:=false;
    end
    else
    //����.
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
    //�������� ����� ������ ������� ���� ���������
    testNeedsAdrF;
    //��������� ����������� ������ �������
    GetAddrList;
    //��������� ������ ���������� �������
    SetOrbAddr;
    GenTestAdrCorrect;
  end
  else
  //������ ����� ���. ����������� ���.
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
  //�������� ���� ��������
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
  //�������� ������� � ����. � � ������ �����������
  //���� ������ ��� ����������� � ��������
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
    //form1.Memo1.Lines.Add('������!:');
    //������������� ������� ��������� ������ ������.
    orbAdrCount := 0;
    //������� ��� �������� ���������� ���������� �������
    {data.}analogAdrCount := 0;
    //������� ��� �������� ���������� ���������� �������
    {data.}contactAdrCount := 0;
    //�������� ����� ��� ���������� ������
    //form1.diaSlowAnl.Series[0].Clear;
    form1.diaSlowCont.Series[0].Clear;
    form1.fastDia.Series[0].Clear;


    //sleep(3);
    //��������������� ��������� ������ �� ������� ������
    //������, �������� ������ �������� � ������� �� ������
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
//��������� �������
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






  
  //���� ��� ������ ������� ��� ���. ������� ���
  flagWtoBusArray:=false;



  porog := 0;
  //���. ����. ����� �������� ������
  //modC := false;


  //������� ������ �� fifo �����
  fifoLevelRead := 1;
  //������� ��� ������ � ������ fifo �����
  fifoLevelWrite := 1;
  //������� ���������� ������������ �����
  fifoBufCount := 0;

  //�������� ��� �������� ���������� ����� ���� � ���� ������
  //numRetimePointUp := 0;
  //numRetimePointDown := 0;



  bufNumGroup:=0;



  //fraseCount := 1;
  //fraseNum:=1;
  //groupCount := 1;






  

  
  //������ ��� ����� �����.
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
    //���������� ������ ��� 1 �������
    setlength(masDiaValue,numP+1);
    masDiaValue[numP]:=masGroup[nPoint];
    inc(numP);
    nPoint:=nPoint+step;
  end;
end;}
//==============================================================================

//==============================================================================
//���� 32-� ��������� ���� � ������� � ����
//==============================================================================
procedure FillSwatWord;
var
  iOrbWord:integer;
  wordToFile:integer;
begin
  iOrbWord:=1;
  wordToFile:=0;
  //���� ���� ������� 2
  while iOrbWord<={length(masGroup)}masGroupSize do
  begin
     //��������� 11 ���, �������� ����� ��� ���
    if (masGroup[iOrbWord] and 1024)=1024 then
    begin
      //����� ������ �����
      //����� 10 ��. �����
      wordToFile:=masGroup[iOrbWord] and 1023; //�1�12
      //����. 11 ��. �����
      wordToFile:=(masGroup[iOrbWord+1] shl 10)+wordToFile;//�2�12
      //����. 11 ��. �����
      wordToFile:=(masGroup[iOrbWord+2] shl 11)+wordToFile;//�1�22
      //writeln(swtFile,intToStr(wordToFile));
    end;
    iOrbWord:=iOrbWord+4;
  end;
  //������ 1 ������ ������� ������   1024 ����� ������
  {while iOrbWord<=length(masGroup)-1 do
  begin
    //��������� 11 ���, �������� ����� ��� ���
    if (masGroup[iOrbWord] and 1024)=1024 then
    begin
      //����� ������ �����
      //����� 10 ��. �����
      wordToFile:=masGroup[iOrbWord] and 1023;
      //����. 11 ��. �����
      wordToFile:=(masGroup[iOrbWord+2] shl 10)+wordToFile;
      //����. 11 ��. �����
      wordToFile:=(masGroup[iOrbWord+4] shl 11)+wordToFile;
      writeln(swtFile,intToStr(wordToFile));
    end;
    iOrbWord:=iOrbWord+5;
  end;

  iOrbWord:=1;
  //������ 2 ������ ������� ������   512 ���� ������
  while iOrbWord<=round(length(masGroup)/2)-1 do
  begin
    //��������� 11 ���, �������� ����� ��� ���
    if (masGroup[iOrbWord] and 1024)=1024 then
    begin
      //����� 10 ��. �����
      wordToFile:=masGroup[iOrbWord] and 1023;
      //����. 11 ��. �����
      wordToFile:=(masGroup[iOrbWord+2] shl 10)+wordToFile;
      //����. 11 ��. �����
      wordToFile:=(masGroup[iOrbWord+4] shl 11)+wordToFile;
      writeln(swtFile,intToStr(wordToFile));
    end;
    iOrbWord:=iOrbWord+5;
  end;}
end;
//==============================================================================

//==============================================================================
//���� �������� ���
//�� ���� �������� ��� 12 ��������� ��������
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
  //� ����� ���������� ������ ����������� 12,3,2 � 1 ���.
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
  //����� ��� ��� ����������
  if form1.PageControl1.ActivePageIndex = 4 then
  begin
    orbAdrCount:=0;
    while orbAdrCount <= iCountMax - 1 do // iCountMax-1
    begin
      if masElemParam[orbAdrCount].adressType = 6 then
      begin
        iParity:=0;
        //��������� ���������� ����� � ��������� ������
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
            //���������� �������� ����� ������ �� ������� ������ ����� ���
            highVal:=masGroupAll[nPoint];
            //form1.Memo1.Lines.Add(intToStr(masGroupAll[nPoint])
            // +' '+intToStr(nPoint));
          end
          else
          begin
            //���������� �������� ����� ������ � ������� ������ ����� ���
            lowerVal:=masGroupAll[nPoint];
            //form1.Memo1.Lines.Add(intToStr(masGroupAll[nPoint])
            //+' '+intToStr(nPoint));
            //���� ������ (������������������ �� 65535,65535,65535)
            if  ((BuildBusValue(highVal,lowerVal)=65535)and   //!!77
              (not flagWtoBusArray))  then
            begin
              busArray[iBusArray]:=BuildBusValue(highVal,lowerVal);
              inc(iBusArray);
              if iBusArray=3 then
              begin
                //��������� 3 ��������
                if ((busArray[iBusArray-1]=65535)and(busArray[iBusArray-2]=65535)and
                (busArray[iBusArray-3]=65535)) then
                begin
                  //����� ������, ����� ��������� ������
                  flagWtoBusArray:=true;
                end
                else
                begin
                  //�� �����, ���� � ���������� ��� ������
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
              //������ �� ����� �����. ��������� ������
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
//��������� ������� ������ � ��������
//==============================================================================

{procedure Tdata.SaveReport;
var
  str: string;
  i: integer;
begin
  //���� � ��� �������������� ��������, ��
  if (ParamStr(1) = 'StartAutoTest') then
  begin
    //��������� ��� �� ������� ��������2.
    //���� ��� �� ���������� ������� ���������� �����
    if (ParamStr(2) = '') then
      //���
    begin
      str := '����_���_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.txt';
      for i := 1 to length(str) do
        if (str[i] = ':') then
          str[i] := '.';
      form1.Memo1.Lines.SaveToFile(ExtractFileDir(ParamStr(0)) + '/Report/' + str);
    end
    else
      //��
    begin
      //��������� �.� � ���������� ������
      AssignFile(ReportFile, ParamStr(2));
      //��������� ���� �� ����� ����
      if (FileExists(ParamStr(2))) then
        //����, ��������� ���� �� ��������
      begin
        Append(ReportFile);
      end
      else
        //���
      begin
        //��������� �� ������
        ReWrite(ReportFile);
      end;
      writeln(ReportFile, form1.Memo1.Text);
      closefile(ReportFile);
    end
  end
  else
    //������ ��������. ���������� �����
  begin
    str := '����_���_' + DateToStr(Date) + '_' + TimeToStr(Time) + '.txt';
    for i := 1 to length(str) do
      if (str[i] = ':') then
        str[i] := '.';
    form1.Memo1.Lines.SaveToFile(ExtractFileDir(ParamStr(0)) + '/Report/' + str);
  end;
end;}
//==============================================================================



//==============================================================================
//��������� ��� ������ � ��������� ������ . � ���� ����� ������� ��������
//==============================================================================

procedure Tdata.WriteSystemInfo(value: string);
begin
  //����. ����� System � �������� ����������
  AssignFile(SystemFile, 'System');
  //�������� ���  �� ������
  ReWrite(SystemFile);
  //������ � ���� ����������� ��������
  writeln(SystemFile, value);
  //�������� �����
  closefile(SystemFile);
end;
//==============================================================================

//==============================================================================
//������� ���������� �������� ��������.
//���������� ������� �������� � ������������� �������
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
//����� �� ��������� ����� ����� �� ��
//==============================================================================
procedure TData.OutMG(errMG:Integer);
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



//==============================================================================
//
//==============================================================================
procedure TData.ReInitialisation;
begin
//  ����� ������
  //form1.startReadACP.Enabled := true;
//  ������ � tlm
  //form1.tlmWriteB.Enabled := false;
//  ���������� ������ ������� ���
//  !!!
//  acp.Free;
end;
//==============================================================================

//M08,04,02,01

//==============================================================================
//��������� ��� ������������ ������ ������� �����. ������� �������� ������
//==============================================================================
procedure TData.TestSMFOutDate(numPointDown:Integer;numCurPoint:integer;numPointUp:integer);
var
  numP:Integer;
begin
  form1.Memo1.Lines.Add('��������� ��������!!! '+intTostr(porog));

  //�� �����
  for numP:=numCurPoint-numPointDown to  numCurPoint-1 do
  begin
    form1.Memo1.Lines.Add('����� ����� � ������� '+intTostr(numP)+' '+'�������� '+IntToStr(fifoMas[numP]));
  end;

  //����� �����
  for numP:=numCurPoint to  numCurPoint+numPointUp do
  begin
    if numP=numCurPoint then
    begin
      form1.Memo1.Lines.Add('����� ����� � �������!!! '+
        intTostr(numP)+' '+'�������� '+IntToStr(fifoMas[numP]));
    end
    else
    begin
      form1.Memo1.Lines.Add('����� ����� � ������� '+
        intTostr(numP)+' '+'�������� '+IntToStr(fifoMas[numP]));
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
    //���� ���� ����� ������ ������. ������ ��� �� ������
    //��������� �� ������� �� �� ������� ����� ������ � ��� �����. �����. � ������
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
  //������ ������ � ���
  begin
    form1.tlmWriteB.Caption := '0 Mb';
    //���� ����� � ��� �� �� ����� ��������� �����
    form1.startReadACP.Enabled:=false;
    //��� ����. �������� ��������� � 1 ��
    tlm.iOneGC := 4;
    tlm.StartWriteTLM;
    tlm.WriteTLMhead;
    //���� ������������� ��� ������ � ������ �����
    {data.}flSinxC := false;
    //��������� ������ ������ � ���� ���
    tlm.flagWriteTLM := true;
    //������������� ���� ������ ������ ����� � ����
    tlm.flagFirstWrite := true;
    tlm.flagEndWrite := false;
  end
  else
  //��������� ������ � ���
  begin
    //�������. ���� ��� �����. ������ � ������ �����
    flBeg := false;
    //���� ������������� ��� ������ � ������ �����
    {data.}flSinxC := false;
    tlm.flagWriteTLM := false;
    //form1.WriteTLMTimer.Enabled:=false;
    tlm.flagEndWrite := true;
    closeFile(tlm.PtlmFile);
    tlm.countWriteByteInFile := 0;
    tlm.precision := 0;
    form1.tlmWriteB.Caption := '������';
    //form1.Memo1.Lines.Add('���������� ���������� ������(������) '+
    //intToStr(tlm.blockNumInfile));
    ShowMessage('���� �������!');
    //���� tlm ��������, ����� ��������� �����
    form1.startReadACP.Enabled:=true;
  end;
  //�� ������� � �������� � ��������
  tlm.tlmBFlag := not tlm.tlmBFlag;
end;

procedure TForm1.startReadTlmBClick(Sender: TObject);
begin
  //������ ��� ������ � ��������
  if infNum=0 then
  begin
    dataM16 := TdataM16.CreateData;
  end
  else
  begin
    dataMoth := TdataMoth.CreateData;
  end;


  //���������� ��������������� ��������
  form1.fastGist.AllowZoom:=true;
  form1.fastGist.AllowPanning:=pmBoth;
  form1.gistSlowAnl.AllowZoom:=true;
  form1.gistSlowAnl.AllowPanning:=pmBoth;
  form1.tempGist.AllowZoom:=True;
  form1.tempGist.AllowPanning:=pmBoth;

  testOutFalg:=true;
  //�������. �������� ��� �����. �����. ������� ���� �������
  //��
  acumAnalog := 0;
  //����.
  acumTemp:=0;
  //��
  acumContact := 0;
  //�
  acumFast := 0;
  //����� ��������� � ��������� ���������
  //data.ReInitialisation;
  //data.Free;
  //data := Tdata.CreateData;
  //�������� ����� ������ ������� ���� ���������
  testNeedsAdrF;
  //��������� ����������� ������ �������
  GetAddrList;
  //��������� ������ ���������� �������
  SetOrbAddr;

  //��� ������ ������ � ������ � ������� �� ���� ��������� ���
  //��� ������ ���� ��� ������ ���� ������ ������ ������ ����� � �.�
  {data.}groupNum:=1;
  {data.}ciklNum:=1;


  //�������� ������������ ������� �������
  if {data.}GenTestAdrCorrect then
  begin
    //������ ��� ������ � ���
    tlm := Ttlm.CreateTLM;
    //��������� �������� ��������
    form1.tlmPSpeed.Position := 3;
    form1.tlmPSpeed.Enabled:=true;
    //���������� ������� ����������
    if ({data.}FillAdressParam) then
    begin
      ShowMessage('�������� ���� .tlm ��� ���������������!');
      form1.startReadACP.Enabled := false;
      //������� ��� ��������� �����
      tlm.OutFileName;
    end
    else
    begin
      tlm := nil;
      //��������� �������� ��������
      form1.tlmPSpeed.Position := 3;
      form1.tlmPSpeed.Enabled:=false;
      ShowMessage('� ������ ������� ������������ ������!');
    end;
  end
  else
  begin
    showMessage('��������� ������������ �������!');
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
    //��������� ���������� ���������� � ���������� ������� �� �����
    {data.}chanelIndexFast := ValueIndex + acumAnalog + acumContact+acumTemp;
    //���������� ������������ ��� � ����������� �� ����
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
    //����� ���������
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
    //288 ����������������� �������� ��� ����������� ������ �� �����
    tlm.stream.Position := (form1.TrackBar1.Position - 1) * tlm.sizeBlock + MAXHEADSIZE;
    //form1.Memo1.Lines.Add(intToStr(tlm.stream.Position));
    form1.TimerPlayTlm.Enabled := true;
  end
end;

procedure TForm1.stopClick(Sender: TObject);
begin
  form1.propB.Enabled := true;
  //����. ������� ������ �����
  form1.TimerPlayTlm.Enabled := false;
  form1.TrackBar1.Enabled := false;
  //���� ������ ������
  form1.PanelPlayer.Enabled := false;
  //����� ������ ������
  form1.startReadACP.Enabled := true;
  form1.startReadTlmB.Enabled := true;
  //����� �������� � ������
  form1.TrackBar1.Position := 1;
  form1.fileNameLabel.Caption := '';
  form1.orbTimeLabel.Caption := '';
  //���������� ������������
  tlm.fFlag := false;
  form1.TimerPlayTlm.Enabled := false;
  //����� �����
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
  //��� ����� �������� ������� ������ ���. �������.
  form1.OrbitaAddresMemo.Clear;
  ShowMessage('�������� ���� ������� ������!');
  form1.OpenDialog2.InitialDir:=ExtractFileDir(ParamStr(0))+'\ConfigDir';;
  //�������� � �����. ���� ��������.
  if form1.OpenDialog2.Execute then
  begin
    propIniFile:=TIniFile.Create(ExtractFileDir(ParamStr(0))+'\ConfigDir\property.ini');
    //propStrPath:=propIniFile.ReadString('lastPropFile','path','');
    //������ ���� �� ����� ��������
    propIniFile.WriteString('lastPropFile','path',form1.OpenDialog2.FileName);
    //������� ��������� ����.
    propStrPath:=propIniFile.ReadString('lastPropFile','path','');
    propIniFile.Free;
    //�������� ����� ������ ������� ���� ���������
    testNeedsAdrF;
    //��������� ����������� ������ �������
    GetAddrList;
    //��������� ������ ���������� �������
    SetOrbAddr;

    form1.startReadACP.Enabled := true;
    form1.startReadTlmB.Enabled := true;
    form1.saveAdrB.Enabled:=true;
  end
  else
  //�� ������
  begin
    ShowMessage('���� ������� ������ �� ������!');
  end;
end;

procedure TForm1.saveAdrBClick(Sender: TObject);
var
  strOut:string;
begin
  strOut:=ExtractFileName(propStrPath){RightStr(propStrPath,7)};
  showMessage('���� ������� '+strOut+' �������!');
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
      //������ ������
      form1.tmrForTestOrbSignal.Enabled:=false;
    end
    else
    begin
      form1.tmrForTestOrbSignal.Enabled:=false;
      ShowMessage('������ ������ �� ������! ��������� ������!');
      {data.}graphFlagFastP := false;

      //Application.ProcessMessages;
      sleep(50);
      //Application.ProcessMessages;

      if ((form1.tlmWriteB.Enabled)and
          (not form1.startReadTlmB.Enabled)and
          (not form1.propB.Enabled))  then
      begin
        //��������� ������ � ���
        pModule.STOP_ADC();
      end;
      //�������� ��� ���������� �����
      flagEnd:=true;
      wait(20);
      //�������� ���������� �� �����������.
      Application.Terminate;
    end;
  end;
end;

procedure TForm1.Series7Click(Sender: TChartSeries; ValueIndex: Integer;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //�������� ������� � ����. � � ������ �����������
  //���� ������ ��� ����������� � ��������
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
  //������� ��� �������� ���������� ���������� �������
  {data.}contactAdrCount := 0;
  form1.diaSlowCont.Series[0].Clear;
  while orbAdrCount <= iCountMax - 1 do // iCountMax-1
  begin
    if masElemParam[orbAdrCount].adressType=1 then
    begin
      //���������� ������ ������ � ����������� ��������
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
  //������� ������ �� ����������������� ����� ��������
  //���� �������� ������ �� ������ �� ����
  Form1.propB.Enabled:=false;


  //��������� ��� ����������� ��������� ������� �  ����. �����
  if (iniRead) then
  begin
    //��������� ������� ��������
    if testOnAllTestDevices then
    begin
      //��������� ����� ������ ������� ��� �������� ���
      adrTestNum:=3;
      //���������� ������ ��� �������� ���
      testNeedsAdrF;
      //���������� �������� �������� �������
      form1.PageControl1.ActivePageIndex:=1;

      //������ ������� �������
      SetOnPowerSupply(0);
      SetVoltageOnPowerSupply(1,'2700');
      SetOnPowerSupply(1);

      if Form1.startReadACP.Caption='�����' then
      begin
        //������ ����� ������ � �������
        Form1.startReadACP.Click;  //!!!
      end;



      //�������� ����������� ��������� �������
      if (flagTestDev) then
      begin
        SetOnPowerSupply(1);
        SetVoltageOnPowerSupply(1,'0000');
        Delay_ms(20);
        SetOnPowerSupply(0);
        //�������� �������� ������� ���
        SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');

        SetVoltageOnPowerSupply(1,'2700');
        SetOnPowerSupply(1);
      end;

      Form1.tmr1.Enabled:=True; 



      //flagMKBEnd:=True;// �������� ��������� ���3 � ���2 ���
       //������ ��������������� ������� ��� �������� ���3
      //Form1.tmrF.Enabled:=True; //!!! �������� ��������� ���3 � ���2 ���

      //��������� ����� ������ ������� ��� �������� ���2
      {adrTestNum:=1;
      //���������� ������ ��� �������� ���2
      testNeedsAdrF;
      //��������� ������� � ���
      form1.PageControl1.ActivePageIndex:=3;
      //�������� ���2
      TestMKB2;}
    end
    else
    begin
      ShowMessage('�� ��� ������� ��� ���������� �������� � ������� �������� �����!');
    end;
  end
  else
  begin
    ShowMessage('������ ��� ������ � ���������������� �����');
  end;
end;

//udp ��� �������� ������ �� �������� ������� ����.
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
        //��������� ������ ��������
        //�������� � ������ ��
        //��������� 1 ��������
        Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� ��������� � ����� �� ���� ����������,'+
        '����������� ���������, ������������ ��������� � ������ ������������� �����'+').');
        Form1.mmoTestResult.Lines.Add('�������� ��������� 1');
        Form1.mmoTestResult.Lines.Add('������������� �������������:5 ��.');
        SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=1');
        changeResistance(5.0);
        Delay_S(1);
        //��������� 31 �����
        bool:=testChannals(minScale4,maxScale4,TS_1_MIN4,TS_1_MAX4,5.0);
        testResult:=testResult and bool;
      end;
      2:
      begin
        Form1.mmoTestResult.Lines.Add('������������� �������������:15 ��.');
        changeResistance(15.0);
        Delay_S(1);
        bool:=testChannals(minScale3,maxScale3,TS_1_MIN3,TS_1_MAX3,15.0);
        testResult:=testResult and bool;
      end;
      4:
      begin
        Form1.mmoTestResult.Lines.Add('������������� �������������:30 ��.');
        changeResistance(30.0);
        Delay_S(1);
        bool:=testChannals(minScale2,maxScale2,TS_1_MIN2,TS_1_MAX2,30.0);
        testResult:=testResult and bool;
      end;
      6:
      begin
        Form1.mmoTestResult.Lines.Add('������������� �������������:60 ��.');
        changeResistance(60.0);
        Delay_S(1);
        bool:=testChannals(minScale1,maxScale1,TS_1_MIN1,TS_1_MAX1,60.0);
        testResult:=testResult and bool;
      end;
      8:
      begin
        Form1.mmoTestResult.Lines.Add('�������� ��������� 2');
        SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=0');
        Form1.mmoTestResult.Lines.Add('������������� �������������:25 ��.');
        changeResistance(25.0);
        Delay_S(1);
        bool:=testChannals(minScale4,maxScale4,TS_2_MIN4,TS_2_MAX4,25.0);
        testResult:=testResult and bool;
      end;
      10:
      begin
        Form1.mmoTestResult.Lines.Add('������������� �������������:75 ��.');
        changeResistance(75.0);
        Delay_S(1);
        bool:=testChannals(minScale3,maxScale3,TS_2_MIN3,TS_2_MAX3,75.0);
        testResult:=testResult and bool;
      end;
      12:
      begin
        Form1.mmoTestResult.Lines.Add('������������� �������������:150 ��.');
        changeResistance(150.0);
        Delay_S(1);
        bool:=testChannals(minScale2,maxScale2,TS_2_MIN2,TS_2_MAX2,150.0);
        testResult:=testResult and bool;
      end;
      14:
      begin
        Form1.mmoTestResult.Lines.Add('������������� �������������:300 ��.');
        changeResistance(300.0);
        Delay_S(1);
        bool:=testChannals(minScale1,maxScale1,TS_2_MIN1,TS_2_MAX1,300.0);
        testResult:=testResult and bool;
        //��������� ���� ���������� � ������
        startTestBlock:=False;
        Form1.tmr1_1_10_2.Enabled:=False;
        testCount:=0;
        if (testResult) then
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� ��������� � ����� �� ���� ����������,'+
           '����������� ���������, ������������ ��������� � ������ ������������� �����): �����');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� ��������� � ����� �� ���� ����������,'+
           '����������� ���������, ������������ ��������� � ������ ������������� �����): !!! �� ����� !!!');
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
  //�������� ����������
  if (testColibrFlag) then
  begin
    //��������� ���������� �� ���� �����������
    if (startTest_1_1_10_2) then
    begin
      if (testColibr) then
      begin
        Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� �������� ����������): �����.');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� �������� ����������): !!! �� ����� !!!');
      end;
      Form1.mmoTestResult.Lines.Add('');
      startTest_1_1_10_2:=False;
      testColibrFlag:=False;
    end;
  end
  else
  begin
    //��� ������ ������ �������� ��������� ��������� ���� ��������
    if (testFlag_1_1_10_2) then
    begin
      testFlag_1_1_10_2:=False;
      //������ �������� ������������ ��������� ���3
      Form1.tmr1_1_10_2.Enabled:=true;
    end
    else
    begin
      //��� ������ ��������� 2 ��������
      if (not Form1.tmr1_1_10_2.Enabled) then
      begin
        if  (testFlagRco) then
        begin
          testFlagRco:=False;
          //������ �������� ����������� ��������� ������������� ���3
          Form1.tmrRCo.Enabled:=True;
        end
        else
        begin
          if (not Form1.tmrRCo.Enabled) then
          begin
            if (testFlagSrn) then
            begin
              testFlagSrn:=False;
              //�������� �������� ������� ���2
              Form1.tmrTestSRN2.Enabled:=True;
            end;
            
            if (not Form1.tmrTestSRN2.Enabled) then
            begin
              //��� ������ ��������� �������� ���2
              //��� �������� ������, ���� �������� ���������
              if (allTestFlag) then
              begin
                Form1.mmoTestResult.Lines.Add('�������� ������ N1-1: �����');
              end
              else
              begin
                Form1.mmoTestResult.Lines.Add('�������� ������ N1-1: !!! �� ����� !!!');
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
      form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� ����������� ��������� �������������)');
      form1.mmoTestResult.Lines.Add('�������� ��������� 1');
      SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=1');
      Delay_S(1);
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 80 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:80 ��');
      changeResistance(80.0);
      for i:=1 to 8 do
      begin
        SendCommandToISD('http://'+ISDip_1+'/type=2num='+inttostr(i)+'val=1');
      end;
      Delay_S(1);
    end;
    2:
    begin
      //��������� 31 �����
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 40 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:40 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 20 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:20 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 10 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:10 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 5 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:5 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 2.5 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:2.5 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ��������� 2');
      SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=0');
      Delay_S(1);
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 400 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:400 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 200 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:200 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 100 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:100 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 50 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:50 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 25 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:25 ��');
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
      form1.mmoTestResult.Lines.Add('�������� ����������� ������������� 12.5 ��');
      form1.mmoTestResult.Lines.Add('����������� �������������:12.5 ��');
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
        Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� ����������� ��������� �������������): �����');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� ����������� ��������� �������������): !!! �� ����� !!!');
        allTestFlag:=false;
      end;
      Form1.mmoTestResult.Lines.Add('');

      if (testResult) then
      begin
        Form1.mmoTestResult.Lines.Add('����� 1.1.10.2 �� ����.468157.116: �����');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('����� 1.1.10.2 �� ����.468157.116: !!! �� ����� !!!');
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
      form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.3 �� ����.468157.116 (�������� ��������� ������������������ ���������� 6.2 �)(������ ���2)');
      //�������� ������ �������� �� ���
      //�� ���. ����
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'76'+'val=1');
      //��������� � ��������� ����������
      str:='';
      //��������� ���������_1 � ����� ������
      //SetConf(m_instr_usbtmc_1[0],'READ?');
      //��������� ���������� � ����������_1
      //GetDatStr(m_instr_usbtmc_1[0],str);

      SetConf(m_instr_usbtmc_1[0],'READ?');
      //��������� ���������� � ����������_1
      GetDatStr(m_instr_usbtmc_1[0],str);

      //������� ��������� ��������
      if ((strToFloat(str)>=(6.200-0.062))and(strToFloat(str)<=(6.200+0.062))) then
      begin
        form1.mmoTestResult.Lines.Add('���������� � �������: '+str+' �');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.3 �� ����.468157.116 (�������� ��������� ������������������ ���������� 6.2 �)'+' �����');

      end
      else
      begin
        form1.mmoTestResult.Lines.Add('���������� � �������: '+str+' �');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.3 �� ����.468157.116 (�������� ��������� ������������������ ���������� 6.2 �)'+' !!!�� �����!!!');
        allTestFlag:=False;
      end;
      form1.mmoTestResult.Lines.Add('');
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'76'+'val=0');
    end;
    2:
    begin
      form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.4 �� ����.468157.116 (�������� ��������� ���������� ���������� 5 � ��� ���������� ������������ ��������)(������ ���2)');
      SendCommandToISD('http://'+ISDip_1+'/type=3num='+'77'+'val=1');
      //��������� � ��������� ����������
      str:='';
      //��������� ��������� � ����� ������
      SetConf(m_instr_usbtmc_1[0],'READ?');
      //���������
      GetDatStr(m_instr_usbtmc_1[0],str);
      //������� ��������� ��������
      if ((strToFloat(str)>=(5.0-0.010))and(strToFloat(str)<=(5.0+0.010))) then
      begin
        form1.mmoTestResult.Lines.Add('���������� � �������: '+str+' �');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.4 �� ����.468157.116 (�������� ��������� ���������� ���������� 5 � ��� ���������� ������������ ��������)'+' �����');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('���������� � �������: '+str+' �');
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.4 �� ����.468157.116 (�������� ��������� ���������� ���������� 5 � ��� ���������� ������������ ��������)'+' !!!�� �����!!!');
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
  //�������� ���� ��� ������� ���������� 6.2 �� ���
  val62:Integer;
  //���������� � ���������� � ���� ������
  str:string;
  //�������� � ���������� � �
  voltmetrVal:Double;
  //�������� � ���2
  chVal:double;
  //���������� �������� �� ���2
  calibrMinMKB2:Integer;
  //���������� ��������� �� ���2
  calibrMaxMKB2:integer;
begin
  case (timerMode) of
    //�������� �������� ������� �� 0� � 6.2�. � ����������� �� ����������� ������
    1:
    begin
      //��������� �� ������ 0�
      {SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(numberChannel)+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
         IntToStr(numberChannel)+'val=1');}
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
         IntToStr(IsdMKBcontNum[numberChannel])+'val=1');
      //��������� ��������� ������ �� 0�
      //� ����������� �� ���� ������
      case masElemParam[numberChannel-1].adressType of
        2:
        begin
          //T22. 6 ��������
          if ((DataMKB[numberChannel]>=3) and (DataMKB[numberChannel]<=5)) then
          begin
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   �����'+'[3,5]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   !!!�� �����!!!'+'[3,5]')
          end;
        end;
        3:
        begin
          //T21. 8 ��������
          if ((DataMKB[numberChannel]>=23) and (DataMKB[numberChannel]<=27)) then
          begin
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   �����'+'[23,27]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   !!!�� �����!!!'+'[23,27]')
          end;
        end;
      end;
      //��������� ����� �� ����� ����
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(IsdMKBcontNum[numberChannel])+'val=0');
      //������� �� ���� �����
      Inc(numberChannel);

      
      if (numberChannel=21) then
      begin
        //��� ������ ��������� ������� �� ����. ��������
        Inc(timerMode);
      end;
    end;

    //��������� 6.2� �� ���� ����������� �������
    2:
    begin
      form1.tmrMKB_Dpart.Enabled:=False;
      i:=1;
      while (i<=20) do
      //for i:=1 to 26 do
      begin
         //��������� ����� �� ����� ����
        SendCommandToISD('http://'+ISDip_2+'/type=3num='+IntToStr(IsdMKBcontNum[i])+'val=0');
        //--
        val62:=3310;
        //��������� �� ������ 6.2�
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
      form1.mmoTestResult.Lines.Add('�������� ������� ����� ��� ���������� 6.2�');
      form1.tmrMKB_Dpart.Enabled:=true;
    end;

    //�������� ���� ������� �� 6.2�
    3:
    begin
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(IsdMKBcontNum[numberChannel])+'val=1');
      //��������� ��������� ������ �� 6.2�
      case masElemParam[numberChannel-1].adressType of
        2:
        begin
          if ((DataMKB[numberChannel]>=59) and (DataMKB[numberChannel]<=61)) then
          begin
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   �����'+'[59,61]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   !!!�� �����!!!'+'[59,61]')
          end;
        end;
        3:
        begin
          if ((DataMKB[numberChannel]>=243) and (DataMKB[numberChannel]<=247)) then
          begin
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   �����'+'[243,247]')
          end
          else
          begin
            rezFlag:=false;
            //DeviceTestRezultFlag:=false;
            form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+
              '   ���2: '+IntToStr(DataMKB[numberChannel])+' ��.��.   !!!�� �����!!!'+'[243,247]')
          end;
        end;
      end;

      //��������� ����� �� ����� ����
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(IsdMKBcontNum[numberChannel])+'val=0');
      //����. �����
      inc(numberChannel);

      if (numberChannel=21) then
      begin
        //��� ������ ��������� ������� �� ����. ��������
        Inc(timerMode);
      end;
    end;
    {���������� ������������� ���������� �� ������� ��� ��������}
    4:
    begin
      form1.tmrMKB_Dpart.Enabled:=false;
      if (rezFlag) then
      begin
        Form1.mmoTestResult.Lines.Add('��������� �������� ������� ����� ��� ���������� 0� � 6.2� : �����');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('��������� �������� ������� ����� ��� ���������� 0� � 6.2� : !!!�� �����!!!');
      end;

      rezFlag:=true;
      Form1.mmoTestResult.Lines.Add('�������� �������� ��������� �������');
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
    {�������� �����������}
    5:
    begin
      //������� ������� ����� �� ���������
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
            IntToStr(IsdMKBcontNum[numberChannel])+'val=1');
      Delay_ms(5);
      //�������� ���������� ����������
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
        //6 ����.
        2:
        begin
          if error<=2.5 then
          begin
            Form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+'   ���2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'�   ���������: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                '�   �����������: '+FloatToStrF(error,ffFixed,5,2)+'%   �����');
          end
          else
          begin
            rezFlag:=false;
            Form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+'   ���2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'�   ���������: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                '�   �����������: '+FloatToStrF(error,ffFixed,5,2)+'%  !!!�� �����!!!');
          end;
        end;
        //8 ����.
        3:
        begin
          if error<=1.5 then
          begin
            Form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+'   ���2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'�   ���������: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                '�   �����������: '+FloatToStrF(error,ffFixed,5,2)+'%   �����');
          end
          else
          begin
            rezFlag:=false;
            Form1.mmoTestResult.Lines.Add('����� '+IntToStr(numberChannel)+'   ���2: '+
              FloatToStrF(chVal,ffFixed,5,4)+'�   ���������: '+FloatToStrF(voltmetrVal,ffFixed,5,4)+
                '�   �����������: '+FloatToStrF(error,ffFixed,5,2)+'%   !!!�� �����!!!');
          end;
        end;
      end;

      //��������� ����� �� ����� ����
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(IsdMKBcontNum[numberChannel])+'val=0');
      //����. �����
      inc(numberChannel);

      if (numberChannel=21) then
      begin
        //��� ������ ��������� ������� �� ����. ��������
        Inc(timerMode);
      end;
    end;
    {��������� ������}
    6:
    begin
      //SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC');
      if (rezFlag) then
      begin
        Form1.mmoTestResult.Lines.Add('��������� �������� �������� ��������� : �����');
      end
      else
      begin
        Form1.mmoTestResult.Lines.Add('��������� �������� �������� ��������� : !!!�� �����!!!');
      end;

      //���������� �������� ���2
      form1.tmrMKB_Dpart.Enabled:=False;
      //������ ��������������� ������� ��� �������� ���3
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
          Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+
            '   ���2: '+IntToStr(DataMKB[NumberChannel])+' ��.��.   �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+
            '   ���2: '+IntToStr(DataMKB[NumberChannel])+' ��.��.   !!!�� �����!!!')
        end;

        for i:=2 to 32 do
        begin
          if (i<>NumberChannel) then
          begin
            if (abs(DataMKB[i]-SaveDataMKB[i])>2) then
            begin
              rezFlag:=false;
              //DeviceTestRezultFlag:=false;
              Memo1.Lines.Add('������������� ������ '+IntToStr(NumberChannel)+' �� ����� '+IntToStr(i)+'!');
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
          Memo1.Lines.Add('�������� ������� ����� ��� ���������� 6.2�');
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
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+'   ���2: '+
          IntToStr(DataMKB[NumberChannel])+' ��.��.   �����')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+'   ���2: '+
          IntToStr(DataMKB[NumberChannel])+' ��.��.   !!!�� �����!!!')
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
          form1.mmoTestResult.Lines.Add('��������� �������� ������� ����� ��� ���������� 0� � ������������� �� ������ ������: �����');
          form1.mmoTestResult.Lines.Add('');
          Form1.mmoTestResult.Lines.Add('������������ ������� ���2 ������ 1.1.1 �� ����.468363.026 (�������� ������� ��������) �����)');
          Form1.mmoTestResult.Lines.Add('');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('��������� �������� ������� ����� ��� ���������� 0� � ������������� �� ������ ������: !!!�� �����!!!');
          form1.mmoTestResult.Lines.Add('');
          form1.mmoTestResult.Lines.Add('������������ ������� ���2 ������ 1.1.1 �� ����.468363.026 (�������� ������� ��������) !!! �� ����� !!!)');
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
        Form1.mmoTestResult.Lines.Add('�������� ������� 1.2.2 � 1.3.2 �� ����.468363.026 (�������� �������� ��������������� ������������� ���������� � ����������������� ��� ��������� ����������� ���������)');
        Form1.mmoTestResult.Lines.Add('');
        Form1.mmoTestResult.Lines.Add('�������� �������� ��������� � ������� ���������� ��� 8-��������� ��������� ������������� �������');
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
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. �������� ���������� 6,2�: '+
            IntToStr(CalibrMaxMKB2)+' ��.��.  �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. �������� ���������� 6,2�: '+
            IntToStr(CalibrMaxMKB2)+' ��.��.  !!!�� �����!!!')
        end;
        if ((CalibrMinMKB2>=14) and (CalibrMinMKB2<=18)) then
        begin
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. ������� ���������� 6,2�: '+
            IntToStr(CalibrMinMKB2)+' ��.��.  �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. ������� ���������� 6,2�: '+
            IntToStr(CalibrMinMKB2)+' ��.��.  !!!�� �����!!!')
        end;
      end;

      channelValue:=(6.2*(DataMKB[NumberChannel]-CalibrMinMKB2))/(CalibrMaxMKB2-CalibrMinMKB2);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      error:=abs(100*(channelValue-voltmetrValue)/6.2);

      if error<=1 then
      begin
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+
          '   ���2: '+FloatToStrF(channelValue,ffFixed,5,4)+'�   ���������: '+
          FloatToStrF(voltmetrValue,ffFixed,5,4)+'�   �����������: '+
          FloatToStrF(error,ffFixed,5,2)+'%   �����')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+'   ���2: '+
          FloatToStrF(ChannelValue,ffFixed,5,4)+'�   ���������: '+
          FloatToStrF(VoltmetrValue,ffFixed,5,4)+'�   �����������: '+
          FloatToStrF(Error,ffFixed,5,2)+'%   !!!�� �����!!!');
      end;

      inc(NumberChannel);
      SendCommandToISD('http://'+ISDip_2+'/type=1num='+
        IntToStr(ChannelsISDRating8[NumberChannel-1])+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(ChannelsISDRating8[NumberChannel-1])+'val=0');

      if (NumberChannel>16) then
      begin
        form1.mmoTestResult.Lines.Add('');
        form1.mmoTestResult.Lines.Add('�������� �������� ��������� � ������� ���������� ��� 6-��������� ��������� ������������� �������');
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
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. �������� ���������� 6,2�: '
            +IntToStr(CalibrMaxMKB2)+' ��.��.  �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. �������� ���������� 6,2�: '+
            IntToStr(CalibrMaxMKB2)+' ��.��.  !!!�� �����!!!')
        end;
        if ((CalibrMinMKB2>=3) and (CalibrMinMKB2<=5)) then
        begin
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. ������� ���������� 6,2�: '+
            IntToStr(CalibrMinMKB2)+' ��.��.  �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. ������� ���������� 6,2�: '+
            IntToStr(CalibrMinMKB2)+' ��.��.  !!!�� �����!!!')
        end;
      end;

      channelValue:=(6.2*(DataMKB[NumberChannel]-CalibrMinMKB2))/(CalibrMaxMKB2-CalibrMinMKB2);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      error:=abs(100*(channelValue-voltmetrValue)/6.2);

      if error<=2 then
      begin
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+'   ���2: '+
          FloatToStrF(channelValue,ffFixed,5,4)+'�   ���������: '+
            FloatToStrF(voltmetrValue,ffFixed,5,4)+'�   �����������: '+
              FloatToStrF(error,ffFixed,5,2)+'%   �����')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+
          '   ���2: '+FloatToStrF(channelValue,ffFixed,5,4)+'�   ���������: '+
            FloatToStrF(voltmetrValue,ffFixed,5,4)+'�   �����������: '+
              FloatToStrF(error,ffFixed,5,2)+'%   !!!�� �����!!!');
      end;

      inc(NumberChannel);
      SendCommandToISD('http://'+ISDip_2+'/type=1num='+
        IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=0work=0');
      SendCommandToISD('http://'+ISDip_2+'/type=3num='+
        IntToStr(ChannelsISDRating6[NumberChannel-1])+'val=0');

      if (NumberChannel>32) then
      begin
        Form1.mmoTestResult.Lines.Add('');
        Form1.mmoTestResult.Lines.Add('�������� �������� ��������� � ������� ���������� ��� 4-��������� ��������� ������������� �������');
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
          form1.mmoTestResult.Lines.Add('����� 1  ���2. �������� ���������� 6,2�: '+
            IntToStr(CalibrMaxMKB2)+' ��.��.  �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. �������� ���������� 6,2�: '+
            IntToStr(CalibrMaxMKB2)+' ��.��.  !!!�� �����!!!')
        end;
        if ((CalibrMinMKB2>=0) and (CalibrMinMKB2<=2)) then
        begin
          Form1.mmoTestResult.Lines.Add('����� 1  ���2. ������� ���������� 6,2�: '+
            IntToStr(CalibrMinMKB2)+' ��.��.  �����')
        end
        else
        begin
          rezFlag:=false;
          //DeviceTestRezultFlag:=false;
          form1.mmoTestResult.Lines.Add('����� 1  ���2. ������� ���������� 6,2�: '+
            IntToStr(CalibrMinMKB2)+' ��.��.  !!!�� �����!!!')
        end;
      end;

      channelValue:=(6.2*(DataMKB[NumberChannel]-CalibrMinMKB2))/(CalibrMaxMKB2-CalibrMinMKB2);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      error:=abs(100*(channelValue-voltmetrValue)/6.2);

      if error<=6.5 then
      begin
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+
          '   ���2: '+FloatToStrF(channelValue,ffFixed,5,4)+'�   ���������: '+
            FloatToStrF(voltmetrValue,ffFixed,5,4)+'�   �����������: '+
              FloatToStrF(error,ffFixed,5,2)+'%   �����')
      end
      else
      begin
        rezFlag:=false;
        //DeviceTestRezultFlag:=false;
        Form1.mmoTestResult.Lines.Add('����� '+IntToStr(NumberChannel)+
          '   ���2: '+FloatToStrF(ChannelValue,ffFixed,5,4)+'�   ���������: '+
            FloatToStrF(VoltmetrValue,ffFixed,5,4)+'�   �����������: '+
              FloatToStrF(Error,ffFixed,5,2)+'%   !!!�� �����!!!');
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
          Form1.mmoTestResult.Lines.Add('������������ ������� ���2 ������� 1.2.2 � 1.3.2 �� ����.468363.026 (�������� �������� ��������������� ������������� ���������� � ����������������� ��� ��������� ����������� ���������) �����')
        end
        else
        begin
          form1.mmoTestResult.Lines.Add('������������ ������� ���2 ������� 1.2.2 � 1.3.2 �� ����.468363.026 (�������� �������� ��������������� ������������� ���������� � ����������������� ��� ��������� ����������� ���������) !!!�� �����!!!');
        end;
        Form1.tmrMKB_Dpart.Enabled:=false;

        Form1.mmoTestResult.Lines.Add('');
        if (rezFlag) then
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������� ���2 �'+'111'+' �����');
          //showmessage('�������� ������� ���2 �'+edit1.text+' �����');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������� ���2 �'+'111'+' !!! �� �����!!!');
          //showmessage('�������� ������� ���2 �'+edit1.text+' !!! �� �����!!!');
        end;
        //TurnOFFPowerSupply(Number_Power_Supply_1);
        //str5:='����������_��������_�������_���2_�'+edit1.Text+'_'+DateToStr(Date)+'_'+TimeToStr(Time)+'.txt';
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
  //��������� ��� �������� ���2 ���������
  if (flagMKBEnd) then
  begin
    flagMKBEnd:=false;
    TestConnect(AkipV7_78_1,m_defaultRM_usbtmc_1[0],m_instr_usbtmc_1[0],viAttr_1,Timeout);
    form1.PageControl1.ActivePageIndex:=2;
    startTestBlock:=true;
    //Delay_S(5);
    //startTestMKT3:=True;

    //������������� ����� ������� ��� �������� ���3
    adrTestNum:=2;
    //Form1.startReadACP.Click;
    //���������� ������ ���3
    testNeedsAdrF; //!!!
    //�������� ��������� ������� � ������ ���������� �������
    FillAdressParam;  //!!!

    //��������� ����� ������ � �������.
    Form1.startReadACP.Click; //�������� ���

    Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116'+
      '(��������������� �������������� ��� ������� ���(������ ���3)).');
    Form1.mmoTestResult.Lines.Add('');
    Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116'+
      '(�������� �������� �� ����� ������� ������ ������������� ��������).');
    //������ ������� �������� ������� ���3
    Form1.tmrAllTest.Enabled:=True;

    Form1.tmrF.Enabled:=False;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  //������ ������� ��� �� ���
  SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=0');
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //����� � ��������
  timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //����� � ��
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
// �������� ��������� ������� ������������ � ������ ������� ������������
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
  //�������� ����� �������
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //����� � ���.
  timeBVKCarSec:=hourBVK*60*60+minBVK*60+secBVK;
  //����� � ����
  timeBVKCarMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  Form1.lbl2.Caption:=IntToStr(timeBVKCarSec-timeBVKPrevSec);
  setChFlag:=true;

  if (prFlag) then
  begin
    //�����.
    //������ ����������
    Delay_ms(5);
    if (prBegFl) then
    begin
      prBegFl:=False;
      //�������� ������ ��������� ������
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
      //�������� ������� ��������� � ����������

      {if testMTime(1000,timeBVKCarMSec-timeBVKPrevMSec,50) then
      begin
        form1.mmoTestResult.Lines.Add('1');
      end; }


      //��������� ���������� �� ��������� �������
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        if Abs(testBVK_Arr_pr_prev[iCh]-testBVK_Arr_pr_curr[iCh])>=10 then
        begin
          // �������� � ���� �� ����� ��� ����������
          for iT:=testedState_pr[iCh] to BVK_NUM_SETS+1 do
          begin
            //��������� ����������� ����� ����� ������������
            //��� ������������ �������

            strOut:='';
            if (iCh>=9) then
            begin
              strOut:='����� �'+intTostr(iCh+2)+':';
            end
            else
            begin
              strOut:='����� �'+intTostr(iCh)+':';
            end;

            if testMTime(testBVK_Arr_pr[iCh].setTime[iT],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //� ����
              //form1.mmoTestResult.Lines.Add('����� �� (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              if abs(testBVK_Arr_pr_prev[iCh]-testBVK_Arr_pr_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' �����'+' ���');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!�� �����!!'+' ���');
                BVKTestFlag:=False;
              end;
              //���� ��� ��������� ��������� �� ������������� �� ���������
              Inc(testedState_pr[iCh]);
              Break;
            end
            else if testMTime(testBVK_Arr_pr[iCh].setTime[iT-1]+testBVK_Arr_pr[iCh].durabilityT[iT-1],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //� ����
              //form1.mmoTestResult.Lines.Add('����� �� (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              if abs(testBVK_Arr_pr_prev[iCh]-testBVK_Arr_pr_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' �����'+' ����');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!�� �����!!'+' ����');
                BVKTestFlag:=False;
              end;
              Break;
            end
            else
            begin
               //�� � ����
              //form1.mmoTestResult.Lines.Add('����� �� (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              form1.mmoTestResult.Lines.Add('������ ����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut);
              //form1.mmoTestResult.Lines.Add('�������:'+intTostr(testBVK_Arr_pr[iCh].setTime[iT])+' '+intTostr(testBVK_Arr_pr[iCh].durabilityT[iT]));
              BVKTestFlag:=False;
            end;
          end;
        end;
      end;
    end;

    //����� ���������� ���������������� ������  20 ���
    if testMTime(20000,timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
    begin
      //��������� ����������� ������ �� ������������
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        chTestInt:=0;
        strOut:='';
        if (iCh>=9) then
        begin
          strOut:='����� �'+intTostr(iCh+2)+':';
        end
        else
        begin
          strOut:='����� �'+intTostr(iCh)+':';
        end;

        for iT:=1 to BVK_NUM_SETS do
        begin
          chTestInt:=chTestInt+testBVK_Arr_pr[iCh].setTime[iT];
        end;
        if chTestInt=0 then
        begin
          //���������
          if abs(testBVK_Arr_pr_BegState[iCh]-testBVK_Arr_pr_curr[iCh])<=3 then
          begin
            form1.mmoTestResult.Lines.Add(strOut+' �����'+' ���');
          end
          else
          begin
            form1.mmoTestResult.Lines.Add(strOut+'!!�� �����!!'+' ���');
            BVKTestFlag:=False;
          end;
        end;
      end;    

      //��������� ��������������� ��������
      prFlag:=False;
      //���� ��� ����. ��� ����������� � ����. ������
      prBegFl:=True;
      //�������� ����� �������
      DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
      //����� � ��������
      timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
      //����� � ��
      timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
      form1.mmoTestResult.lines.add('�������� ��������� ������ ������ ���');
      //������ ������� ��� ��� ��������� �������� �������� �� ���
      SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=0');
    end;
  end
  else
  begin
    //��������
    //form1.mmoTestResult.Lines.Add('����� � (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
    Delay_ms(5);

    //������ ����������
    if (prBegFl) then
    begin
      prBegFl:=False;
      //�������� ������ ��������� ������
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
      //�������� ������� ��������� � ����������

      //��������� ���������� �� ��������� �������
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        if Abs(testBVK_Arr_G_prev[iCh]-testBVK_Arr_G_curr[iCh])>=10 then
        begin
          // �������� � ���� �� ����� ��� ����������
          for iT:=testedState_G[iCh] to BVK_NUM_SETS+1 do    // iT:=  1
          begin
            //��������� ����������� ����� ����� ������������
            //��� ������������ �������
            strOut:='';
            if (iCh>=9) then
            begin
              strOut:='����� �'+intTostr(iCh+2)+':';
            end
            else
            begin
              strOut:='����� �'+intTostr(iCh)+':';
            end;

            if testMTime(testBVK_Arr_G[iCh].setTime[iT],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //� ����
              //form1.mmoTestResult.Lines.Add('����� � (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              //form1.mmoTestResult.Lines.Add('�������:'+intTostr(testBVK_Arr_G[iCh].setTime[iT])+' '+intTostr(testBVK_Arr_G[iCh].durabilityT[iT])+' ��');
              if abs(testBVK_Arr_G_prev[iCh]-testBVK_Arr_G_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' �����'+' ���');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!�� �����!!'+' ���');
                BVKTestFlag:=False;
              end;
              Inc(testedState_G[iCh]);
              Break;
            end
            else if testMTime(testBVK_Arr_G[iCh].setTime[iT-1]+testBVK_Arr_G[iCh].durabilityT[iT-1],timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
            begin
              //� ����
              //form1.mmoTestResult.Lines.Add('����� � (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              //form1.mmoTestResult.Lines.Add('�������:'+intTostr(testBVK_Arr_G[iCh].setTime[iT-1])+' '+intTostr(testBVK_Arr_G[iCh].durabilityT[iT-1])+' ���');
              if abs(testBVK_Arr_G_prev[iCh]-testBVK_Arr_G_curr[iCh])>=10 then
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+' �����'+' ����');
              end
              else
              begin
                form1.mmoTestResult.Lines.Add('����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut+'!!�� �����!!'+' ����');
                BVKTestFlag:=False;
              end;
              Break;
            end
            else
            begin
              //form1.mmoTestResult.Lines.Add('����� � (����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec));
              //�� � ����
              form1.mmoTestResult.Lines.Add('������ ����� ������������(����):'+intTostr(timeBVKCarMSec-timeBVKPrevMSec)+' '+strOut);
              //form1.mmoTestResult.Lines.Add('�������:'+intTostr(testBVK_Arr_G[iCh].setTime[iT])+' '+intTostr(testBVK_Arr_G[iCh].durabilityT[iT]));
              BVKTestFlag:=False;
            end;
          end;
        end;
      end;
    end;
    //����� ���������� ��������� ������ 330000 ���
    if testMTime(330000,timeBVKCarMSec-timeBVKPrevMSec,ErrorT) then
    begin
      //��������� ����������� ������ �� ������������
      for iCh:=1 to BVK_NUM_TEST_CH do
      begin
        chTestInt:=0;
        strOut:='';
        if (iCh>=9) then
        begin
          strOut:='����� �'+intTostr(iCh+2)+':';
        end
        else
        begin
          strOut:='����� �'+intTostr(iCh)+':';
        end;

        for iT:=1 to BVK_NUM_SETS do
        begin
          chTestInt:=chTestInt+testBVK_Arr_G[iCh].setTime[iT];
        end;
        if chTestInt=0 then
        begin
          //���������
          if abs(testBVK_Arr_G_BegState[iCh]-testBVK_Arr_G_curr[iCh])<=3 then
          begin
            form1.mmoTestResult.Lines.Add(strOut+' �����'+' ���');
          end
          else
          begin
            form1.mmoTestResult.Lines.Add(strOut+'!!�� �����!!'+' ���');
            BVKTestFlag:=False;
          end;
        end;
      end;     

      //��������� ����� �������� ��������
      genFlag:=False;
      //��������� ��������
      if (BVKTestFlag) then
      begin
        form1.mmoTestResult.Lines.Add('�������� ���: '+'�����');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('�������� ���: '+'!!�� �����!!');
      end;  
      form1.tmrTestBVK.Enabled:=false;
    end;
  end;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  //������ ������� ��� �� ��� ��� �����!!!
  SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=0');
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  {SetVoltageOnPowerSupply(1,'0000');
  SetOnPowerSupply(1);
  Delay_S(5);
  SetOnPowerSupply(0);
  //�������� �������� ������� ���
  SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');

  //�������� ����������� ��������� �������
  if (PowerTestConnect) then
  begin
    form1.Memo1.Lines.Add('�������� ������� ����-1105 ���������!');
    SetVoltageOnPowerSupply(1,'2700');
    SetOnPowerSupply(1);
 //   SetVoltageOnPowerSupply(1,'0000');
    //Delay_S(5);
    //�������� 27 �

  end
  else
  begin
    form1.Memo1.Lines.Add('�������� ������� ����-1105 �� ���������!');
  end;}
  if (flagTestDev) then
  begin
    {SetOnPowerSupply(0);
    SetVoltageOnPowerSupply(1,'0000');
    SetOnPowerSupply(1);
    Delay_ms(10);
    SetOnPowerSupply(0); }
    //�������� �������� ������� ���
    SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');

    SetVoltageOnPowerSupply(1,'2700');
    SetOnPowerSupply(1);
  end;

  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //����� � ��������
  timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //����� � ��
  timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  form1.tmrBVK2.Enabled:=True;

end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  if startBVktime=4 then   //3
  begin
    Form1.tmr1.Enabled:=false;
    //������ �������� ���.
    testBVK;
  end;
  Inc(startBVktime);
end;

procedure TForm1.tmrBVK2Timer(Sender: TObject);
begin
  //�������� ����� �������
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //����� � ���.
  timeBVKCarSec:=hourBVK*60*60+minBVK*60+secBVK;
  //����� � ����
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

