unit TestUnit_N1_1;

interface
uses
  Forms,Windows,Dialogs,CommInt,SysUtils,IdSocketHandle,Visa_h,Messages,IniFiles,ComObj,LibUnit;
const
  TS_1_MIN4=0;
  TS_1_MAX4=10;
  TS_1_MIN3=10;
  TS_1_MAX3=20;
  TS_1_MIN2=20;
  TS_1_MAX2=40;
  TS_1_MIN1=40;
  TS_1_MAX1=80;

  TS_2_MIN4=0;
  TS_2_MAX4=50;
  TS_2_MIN3=50;
  TS_2_MAX3=100;
  TS_2_MIN2=100;
  TS_2_MAX2=200;
  TS_2_MIN1=200;
  TS_2_MAX1=400;

  TP_1_MIN4=0;
  TP_1_MAX4=10;
  TP_1_MIN3=10;
  TP_1_MAX3=20;
  TP_1_MIN2=20;
  TP_1_MAX2=40;
  TP_1_MIN1=40;
  TP_1_MAX1=80;

  TP_2_MIN4=0;
  TP_2_MAX4=50;
  TP_2_MIN3=50;
  TP_2_MAX3=100;
  TP_2_MIN2=100;
  TP_2_MAX2=200;
  TP_2_MIN1=200;
  TP_2_MAX1=400;


  //���������� ����������� ������� �� ���
  ZU_NUM_TEST_CH=16;
  //���������� ����������� ������� �� ���
  BVK_NUM_TEST_CH=12;
  //������������ ���������� ������������ ��� ������� ������
  BVK_NUM_SETS=3;

  NUM_TESTVALMPIU=6;   //3
  //NUM_TESTVALMPIU_ALL=66;


type
  TBVKCHTestElem = record
    //������ ������������ ������, ����������� ������ 3
    setTime:array[1..BVK_NUM_SETS] of Cardinal;
    //������ ������������ ������ ����� ������������ ������
    durabilityT:array[1..BVK_NUM_SETS] of Cardinal;
  end;

  TTestMPIUElem=record
    aAdr:Integer;
    paAdr:Integer;
  end;



var
  IniPeriphery: TIniFile;
  comm1:TComm;
  IP_POWER_SUPPLY_1,HostISD,RigolDg1022,V7_78,Transmille:string;
  IP_ADAPTER_RS485:string;
  Flag485On:Boolean=False;
  ISDip_1,ISDip_2:string;
  //��������� 1
  AkipV7_78_1:string;
  //��������� 2
  //AkipV7_78_2:string;
  //���������
  RigolDg1022_1:string;
  //������� �������������
  COMnum :string;
  //���� �������������� ����
  AkipOffOnState:Boolean;
  //�������� �OM �����
  ComPortTransmille:string;
  // ���� ��������������� ����� ������ ����� �� ��������� �������
  PowerRequest: Boolean;

  iResist:Integer=1;
  nResist:Integer=1;
  dResist:Integer=7;




  testStringsMKT3:array[1..32] of string{TStringList}=
  ('M16�1A20B60C50D12E20X11T11','M16�1A20B60C50D12E10X11T11','M16�1A20B60C50D12E30X11T11',   //'M16�1A20B60C50D12E20X11T11','M16�1A20B60C50D12E10X11T11','M16�1A20B60C50D12E30X11T11',
   'M16�1A20B60C50D12E40X11T11','M16�1A20B60C50D12E50X11T11','M16�1A20B60C50D12E60X11T11',
   'M16�1A20B60C50D12E70X11T11','M16�1A20B60C50D12E80X11T11','M16�1A20B60C50D12E10X21T11',
   'M16�1A20B60C50D12E20X21T11','M16�1A20B60C50D12E30X21T11','M16�1A20B60C50D12E40X21T11',
   'M16�1A20B60C50D12E50X21T11','M16�1A20B60C50D12E60X21T11','M16�1A20B60C50D12E70X21T11',
   'M16�1A20B60C50D12E80X21T11','M16�1A20B60C50D12E10X31T11','M16�1A20B60C50D12E20X31T11',
   'M16�1A20B60C50D12E30X31T11','M16�1A20B60C50D12E40X31T11','M16�1A20B60C50D12E50X31T11',
   'M16�1A20B60C50D12E60X31T11','M16�1A20B60C50D12E70X31T11','M16�1A20B60C50D12E80X31T11',
   'M16�1A20B60C50D12E10X41T11','M16�1A20B60C50D12E20X41T11','M16�1A20B60C50D12E30X41T11',
   'M16�1A20B60C50D12E40X41T11','M16�1A20B60C50D12E50X41T11','M16�1A20B60C50D12E60X41T11',
   'M16�1A20B60C50D12E70X41T11','M16�1A20B60C50D12E80X41T11'
  );

  testStringsMKB2:array[1..20] of string{TStringList}=
  ('M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21',
   'M16�1A20B80C11T21','M16�1A20B80C21T21','M16�1A20B80C31T21','M16�1A20B80C41T21',
   'M16�1A20B60C31D11T21','M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21'
  );

  {testStringsBVK:array[1..20] of string=
  ('M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21',
   'M16�1A20B60C22D41T21','M16�1A20B80C11T21','M16�1A20B80C21T21',
   'M16�1A20B80C31T21','M16�1A20B80C41T21','M16�1A20B60C31D11T21',
   'M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21'
  );}

   testStringsBVK:array[1..BVK_NUM_TEST_CH] of string=    //12
  ('M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21'
  );

  //�1�20-->�1A30
   {testStringsZU1:array[1..36] of string=
  ('M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21',
   'M16�1A20B80C11T21','M16�1A20B80C21T21','M16�1A20B80C31T21','M16�1A20B80C41T21',
   'M16�1A20B60C31D11T21','M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21',
   'M16�1A20B12T22','M16�1A20B20C12T21','M16�1A20B40T21','M16�1A20B20C22T01',
   'M16�1A20B60C10D12T11','M16�1A20B60C10D22T11',
   'M16�1A30B60C22D11T21','M16�1A30B60C22D21T21','M16�1A30B60C22D31T21','M16�1A30B60C22D41T21',
   'M16�1A30B80C11T21','M16�1A30B80C21T21','M16�1A30B80C31T21','M16�1A30B80C41T21',
   'M16�1A30B60C31D11T21','M16�1A30B60C31D21T21','M16�1A30B60C31D31T21','M16�1A30B60C31D41T21',
   'M16�1A30B12T22','M16�1A30B20C12T21','M16�1A30B40T21','M16�1A30B20C22T01',
   'M16�1A30B60C10D12T11','M16�1A30B60C10D22T11'
  );}

   testStringsZU1_1:array[1..32] of string=
  ('M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21',
   'M16�1A20B80C11T21','M16�1A20B80C21T21','M16�1A20B80C31T21','M16�1A20B80C41T21',
   'M16�1A20B60C31D11T21','M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21',
   'M16�1A20B12T22P01','M16�1A20B12T22P02','M16�1A20B20C12T21','M16�1A20B40T21',
   'M16�1A30B60C22D11T21','M16�1A30B60C22D21T21','M16�1A30B60C22D31T21','M16�1A30B60C22D41T21',
   'M16�1A30B80C11T21','M16�1A30B80C21T21','M16�1A30B80C31T21','M16�1A30B80C41T21',
   'M16�1A30B60C31D11T21','M16�1A30B60C31D21T21','M16�1A30B60C31D31T21','M16�1A30B60C31D41T21',
   'M16�1A30B12T22P01','M16�1A30B12T22P02','M16�1A30B20C12T21','M16�1A30B40T21'  // 'M16�1A20B12T22P01','M16�1A20B12T22P02','M16�1A30B20C12T21','M16�1A30B40T21'
  );

   testStringsZU1_2:array[1..4] of string=
  (  'M16�1A20B60C10D12T11','M16�1A20B60C10D22T11','M16�1A30B60C10D12T11','M16�1A30B60C10D22T11'
  );


  //�1�10-->�2A10
  testStringsZU2:array[1..8] of string=
  (
    'M16�1A10B11T01','M16�1A10B60T01','M16�1A10B20T01','M16�1A10B70T01',
    'M16�2A10B11T01','M16�2A10B60T01','M16�2A10B20T01','M16�2A10B70T01'
  );

  //�1�40-->�1A50
  {testStringsZU3:array[1..24] of string=
  (
    'M16�1A40B40T01','M16�1A40B20�22T01','M16�1A40B11T01',
    'M16�1A40B30C40D12T11','M16�1A40B30C40D22T11','M16�1A40B30C80D12T11','M16�1A40B30C80D22T11',
    'M16�1A40B30�11T05','M16�1A40B30�30�12T05','M16�1A40B30C21T05','M16�1A40B30C30D22T05',
    'M16�1A40B20�11T21',
    'M16�1A50B40T01','M16�1A50B20�22T01','M16�1A50B11T01',
    'M16�1A50B30C40D12T11','M16�1A50B30C40D22T11','M16�1A50B30C80D12T11','M16�1A50B30C80D22T11',
    'M16�1A50B30�11T05','M16�1A50B30�30�12T05','M16�1A50B30C21T05','M16�1A50B30C30D22T05',
    'M16�1A50B20�11T21'
  );}

  {testStringsZU3_1:array[1..14] of string=
  (
    'M16�1A40B40T01','M16�1A40B20�22T01','M16�1A40B11T01',
    'M16�1A40B30�11T05','M16�1A40B30�30�12T05','M16�1A40B30C21T05','M16�1A40B30C30D22T05',
    'M16�1A50B40T01','M16�1A50B20�22T01','M16�1A50B11T01',
    'M16�1A50B30�11T05','M16�1A50B30�30�12T05','M16�1A50B30C21T05','M16�1A50B30C30D22T05'
  );}

  {testStringsZU3_1:array[1..6] of string=
  (
    'M16�1A40B40T01','M16�1A40B20�22T01','M16�1A40B11T01',
    'M16�1A50B40T01','M16�1A50B20�22T01','M16�1A50B11T01'
  );}

  testStringsZU3_1:array[1..6] of string=
  (
    'M16�1A40B40T01','M16�1A40B20�22T01','M16�1A40B11T01',
    'M16�1A50B40T01','M16�1A50B20�22T01','M16�1A50B11T01'
  );

  testStringsZU3_2:array[1..8] of string=
  (
    'M16�1A40B30�11T05','M16�1A40B30�30D12T05','M16�1A40B30C21T05','M16�1A40B30C30D22T05',
    'M16�1A50B30�11T05','M16�1A50B30�30D12T05','M16�1A50B30C21T05','M16�1A50B30C30D22T05'
  );



  testStringsZU3_3:array[1..8] of string=
  (
    'M16�1A40B30C40D12T11','M16�1A40B30C40D22T11','M16�1A40B30C80D12T11','M16�1A40B30C80D22T11',
    'M16�1A50B30C40D12T11','M16�1A50B30C40D22T11','M16�1A50B30C80D12T11','M16�1A50B30C80D22T11'
  );

  //�2�50-->�1A60
  testStringsZU4:array[1..14] of string=
  (
    'M16�2A50B20T21','M16�2A50B30T21','M16�2A50B40T21','M16�2A50B50T21',
    'M16�2A50B60T21','M16�2A50B70T21','M16�2A50B80T21',
    'M16�1A60B20T21','M16�1A60B30T21','M16�1A60B40T21','M16�1A60B50T21',
    'M16�1A60B60T21','M16�1A60B70T21','M16�1A60B80T21'
  );

  //31 .
  testStringsMPIU31_1_1:array[1..2] of string=
  (
    'M16�1A20B20C12T21','M16�1A20B40T21'
  );

  //41 .
  testStringsMPIU41_1_1:array[1..2] of string=
  (
    'M16�2A50B20T21','M16�2A50B30T21'
  );

  //32 .
  testStringsMPIU32_1_1:array[1..2] of string=
  (
    'M16�2A50B50T21','M16�2A50B60T21'
  );

  testStringsSAZ:array[1..1] of string=
  (
    'M16�1A40B20C11T21'
  );


  testStringsPeriodTest:array[1..64] of string=
  {(
    'M16�1A20B60C50D12E20X11T11','M16�1A20B60C50D12E10X11T11','M16�1A20B60C50D12E30X11T11',
   'M16�1A20B60C50D12E40X11T11','M16�1A20B60C50D12E50X11T11','M16�1A20B60C50D12E60X11T11',
   'M16�1A20B60C50D12E70X11T11','M16�1A20B60C50D12E80X11T11','M16�1A20B60C50D12E10X21T11',
   'M16�1A20B60C50D12E20X21T11','M16�1A20B60C50D12E30X21T11','M16�1A20B60C50D12E40X21T11',
   'M16�1A20B60C50D12E50X21T11','M16�1A20B60C50D12E60X21T11','M16�1A20B60C50D12E70X21T11',
   'M16�1A20B60C50D12E80X21T11','M16�1A20B60C50D12E10X31T11','M16�1A20B60C50D12E20X31T11',
   'M16�1A20B60C50D12E30X31T11','M16�1A20B60C50D12E40X31T11','M16�1A20B60C50D12E50X31T11',
   'M16�1A20B60C50D12E60X31T11','M16�1A20B60C50D12E70X31T11','M16�1A20B60C50D12E80X31T11',
   'M16�1A20B60C50D12E10X41T11','M16�1A20B60C50D12E20X41T11','M16�1A20B60C50D12E30X41T11',
   'M16�1A20B60C50D12E40X41T11','M16�1A20B60C50D12E50X41T11','M16�1A20B60C50D12E60X41T11',
   'M16�1A20B60C50D12E70X41T11','M16�1A20B60C50D12E80X41T11',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21',
   'M16�1A20B80C11T21','M16�1A20B80C21T21','M16�1A20B80C31T21','M16�1A20B80C41T21',
   'M16�1A20B60C31D11T21','M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21',
   'M16�1A20B12T22P01','M16�1A20B12T22P02','M16�1A20B20C12T21','M16�1A20B40T21',
   'M16�1A30B60C22D11T21','M16�1A30B60C22D21T21','M16�1A30B60C22D31T21','M16�1A30B60C22D41T21',
   'M16�1A30B80C11T21','M16�1A30B80C21T21','M16�1A30B80C31T21','M16�1A30B80C41T21',
   'M16�1A30B60C31D11T21','M16�1A30B60C31D21T21','M16�1A30B60C31D31T21','M16�1A30B60C31D41T21',
   'M16�1A20B12T22P01','M16�1A20B12T22P02','M16�1A30B20C12T21','M16�1A30B40T21'
  ); }

  (
    'M16�1A20B60C50D12E20X11T11','M16�1A20B60C50D12E10X11T11','M16�1A20B60C50D12E30X11T11',
   'M16�1A20B60C50D12E40X11T11','M16�1A20B60C50D12E50X11T11','M16�1A20B60C50D12E60X11T11',
   'M16�1A20B60C50D12E70X11T11','M16�1A20B60C50D12E80X11T11','M16�1A20B60C50D12E10X21T11',
   'M16�1A20B60C50D12E20X21T11','M16�1A20B60C50D12E30X21T11','M16�1A20B60C50D12E40X21T11',
   'M16�1A20B60C50D12E50X21T11','M16�1A20B60C50D12E60X21T11','M16�1A20B60C50D12E70X21T11',
   'M16�1A20B60C50D12E80X21T11','M16�1A20B60C50D12E10X31T11','M16�1A20B60C50D12E20X31T11',
   'M16�1A20B60C50D12E30X31T11','M16�1A20B60C50D12E40X31T11','M16�1A20B60C50D12E50X31T11',
   'M16�1A20B60C50D12E60X31T11','M16�1A20B60C50D12E70X31T11','M16�1A20B60C50D12E80X31T11',
   'M16�1A20B60C50D12E10X41T11','M16�1A20B60C50D12E20X41T11','M16�1A20B60C50D12E30X41T11',
   'M16�1A20B60C50D12E40X41T11','M16�1A20B60C50D12E50X41T11','M16�1A20B60C50D12E60X41T11',
   'M16�1A20B60C50D12E70X41T11','M16�1A20B60C50D12E80X41T11',
   'M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21',
   'M16�1A20B80C11T21','M16�1A20B80C21T21','M16�1A20B80C31T21','M16�1A20B80C41T21',
   'M16�1A20B60C31D11T21','M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21',
   'M16�1A30B60C22D11T21','M16�1A30B60C22D21T21','M16�1A30B60C22D31T21','M16�1A30B60C22D41T21',
   'M16�1A30B80C11T21','M16�1A30B80C21T21','M16�1A30B80C31T21','M16�1A30B80C41T21',
   'M16�1A30B60C31D11T21','M16�1A30B60C31D21T21','M16�1A30B60C31D31T21','M16�1A30B60C31D41T21'
  );




  arrTestMPIUParam:array[1..NUM_TESTVALMPIU] of TTestMPIUElem;

  
  arrTestMPIUParamConstMPIU31:array[1..NUM_TESTVALMPIU] of TTestMPIUElem=
  (
   (aAdr:4;paAdr:1),(aAdr:4;paAdr:2),(aAdr:4;paAdr:1),(aAdr:4;paAdr:2),(aAdr:4;paAdr:1),(aAdr:4;paAdr:2) //31
  );

  arrTestMPIUParamConstMPIU41:array[1..NUM_TESTVALMPIU] of TTestMPIUElem=
  (
   (aAdr:7;paAdr:1),(aAdr:7;paAdr:2),(aAdr:7;paAdr:1),(aAdr:7;paAdr:2),(aAdr:7;paAdr:1),(aAdr:7;paAdr:2) //41
  );

  arrTestMPIUParamConstMPIU32:array[1..NUM_TESTVALMPIU] of TTestMPIUElem=
  (
   (aAdr:5;paAdr:2),(aAdr:6;paAdr:0),(aAdr:5;paAdr:2),(aAdr:6;paAdr:0),(aAdr:5;paAdr:2),(aAdr:6;paAdr:0) //32
  );

  iTestMPIUArr:Integer;
  //���������� ������� ��� �������� �� ������� �������� �������� ����
  numTestMPIUch:Integer;
  testMpiuFlag:Boolean;


  //31 1 �����.
  {testStringsMPIU31_1_1:array[1..1] of string=
  (
    'M16�1A20B20C22T01'
  );

  testStringsMPIU31_2_1:array[1..2] of string=
  (
    'M16�1A20B60C10D12T11','M16�1A20B60C10D22T11'
  );

  testStringsMPIU31_3_1:array[1..3] of string=
  (
    'M16�1A20B12T22','M16�1A20B20C12T21','M16�1A20B40T21'
  );

  //41 1 �����.
  testStringsMPIU41_1_1:array[1..11] of string=
  (
    'M16�1A10B11T01','M16�1A10B60T01','M16�1A10B20T01','M16�1A10B70T01',
    'M16�1A40B40T01','M16�1A40B20C22T01','M16�1A40B11T01','M16�1A40B30C11T05',
    'M16�1A40B30C30D12T05','M16�1A40B30C21T05','M16�1A40B30C30D22T05'
  );

  testStringsMPIU41_2_1:array[1..4] of string=
  (
    'M16�1A40B30C40D12T11','M16�1A40B30C40D22T11','M16�1A40B30C80D12T11',
    'M16�1A40B30C80D22T11'
  );

  testStringsMPIU41_3_1:array[1..5] of string=
  (
    'M16�2A21T22P01','M16�2A21T22P02','M16�2A50B20T21','M16�2A50B30T21','M16�2A50B40T21'
  );

  //32  1 �����.
  testStringsMPIU32_1_1:array[1..8] of string=
  (
    'M16�2A31T22P01','M16�2A31T22P02','M16�2A41T22P01','M16�2A31T22P02',
    'M16�2A50B50T21','M16�2A50B60T21','M16�2A50B70T21','M16�2A50B80T21'
  );


  //31 2 �����.
  testStringsMPIU31_1_2:array[1..5] of string=
  (
    'M16�2A40B70C12T01','M16�2A40B70C22T01','M16�2A40B80C12T01','M16�2A40B80C22T01',
    'M16�2A40B30C41T05'
  );

  testStringsMPIU31_2_2:array[1..2] of string=
  (
    'M16�2A40B30C70D12T11','M16�2A40B30C70D22T11'
  );

  testStringsMPIU31_3_2:array[1..5] of string=
  (
    'M16�2A80T22P01','M16�2A80T22P02','M16�2A40B11T21','M16�2A40B40T21','M16�2A40B21T21'
  );

  //41 2 �����.
  testStringsMPIU41_1_2:array[1..11] of string=
  (
    'M16�1A30B21T01','M16�1A30B70T01','M16�1A10B31T01','M16�1A30B80T01',
    'M16�1A10B20T01','M16�1A10B80C22T01','M16�1A10B1101','M16�1A10B40C1105',
    'M16�1A10B40C41T05','M16�1A10B40C21T05','M16�1A10B40C31T05'
  );

  testStringsMPIU41_2_2:array[1..4] of string=
  (
    'M16�1A10B80C10T11','M16�1A10B80C30T11','M16�1A10B80C50T11','M16�1A10B80C70T11'
  );

  testStringsMPIU41_3_2:array[1..5] of string=
  (
    'M16�1A21T22P01','M16�1A21T22P02','M16�1A30B30T21','M16�1A30B40T21','M1612A30B11T21'
  );

  //32 2 �����.
  testStringsMPIU32_1_2:array[1..10] of string=
  (
    'M16�2A11T22P01','M16�2A11T22P02','M16�2A21T22P01','M16�2A21T22P01',
    'M16�2A70B20T21','M16�2A70B31T21','M16�2A70B40T21','M16�2A70B60T21',
    'M16�2A70B11T21','M16�2A70B80T21'
  );

  arrTestMPIUParam:array[1..NUM_TESTVALMPIU] of TTestMPIUElem;

  arrTestMPIUParamConst:array[1..NUM_TESTVALMPIU_ALL] of TTestMPIUElem=
  (
   (aAdr:0;paAdr:0),(aAdr:2;paAdr:0),(aAdr:3;paAdr:0),(aAdr:4;paAdr:0),(aAdr:4;paAdr:1),(aAdr:4;paAdr:2), //31 1
   (aAdr:1;paAdr:0),(aAdr:1;paAdr:1),(aAdr:1;paAdr:2),(aAdr:1;paAdr:3),(aAdr:0;paAdr:0),(aAdr:0;paAdr:1), //41 1
   (aAdr:0;paAdr:2),(aAdr:2;paAdr:0),(aAdr:2;paAdr:1),(aAdr:2;paAdr:2),(aAdr:2;paAdr:3),(aAdr:3;paAdr:0),
   (aAdr:4;paAdr:0),(aAdr:5;paAdr:0),(aAdr:6;paAdr:0),(aAdr:7;paAdr:0),(aAdr:7;paAdr:1),(aAdr:7;paAdr:2),
   (aAdr:7;paAdr:3),
   (aAdr:5;paAdr:0),(aAdr:5;paAdr:1),(aAdr:5;paAdr:2),(aAdr:5;paAdr:3),(aAdr:6;paAdr:0),(aAdr:6;paAdr:1), //32 1
   (aAdr:6;paAdr:2),(aAdr:6;paAdr:3),
   (aAdr:0;paAdr:0),(aAdr:2;paAdr:0),(aAdr:3;paAdr:0),(aAdr:4;paAdr:0),(aAdr:4;paAdr:1),(aAdr:4;paAdr:2), //31 2
   (aAdr:1;paAdr:0),(aAdr:1;paAdr:1),(aAdr:1;paAdr:2),(aAdr:1;paAdr:3),(aAdr:0;paAdr:0),(aAdr:0;paAdr:1), //41 2
   (aAdr:0;paAdr:2),(aAdr:2;paAdr:0),(aAdr:2;paAdr:1),(aAdr:2;paAdr:2),(aAdr:2;paAdr:3),(aAdr:3;paAdr:0),
   (aAdr:4;paAdr:0),(aAdr:5;paAdr:0),(aAdr:6;paAdr:0),(aAdr:7;paAdr:0),(aAdr:7;paAdr:1),(aAdr:7;paAdr:2),
   (aAdr:7;paAdr:3),
   (aAdr:5;paAdr:0),(aAdr:5;paAdr:1),(aAdr:5;paAdr:2),(aAdr:5;paAdr:3),(aAdr:6;paAdr:0),(aAdr:6;paAdr:1), //32 2
   (aAdr:6;paAdr:2),(aAdr:6;paAdr:3)
  ); }




  //��� � ���
  {testStringsZU:array[1..24] of string=
  ('M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21','M16�1A20B60C22D41T21',
   'M16�1A20B80C11T21','M16�1A20B80C21T21','M16�1A20B80C31T21','M16�1A20B80C41T21',
   'M16�1A20B60C31D11T21','M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21',
   'M16�1A30B60C22D11T21','M16�1A30B60C22D21T21','M16�1A30B60C22D31T21','M16�1A30B60C22D41T21',
   'M16�1A30B80C11T21','M16�1A30B80C21T21','M16�1A30B80C31T21','M16�1A30B80C41T21',
   'M16�1A30B60C31D11T21','M16�1A30B60C31D21T21','M16�1A30B60C31D31T21','M16�1A30B60C31D41T21'
  );}



  {testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A30B11T22P01','M16�1A30B11T22P02','M16�1A30B21T22P01','M16�1A30B21T22P02',
   'M16�1A30B31T22P01','M16�1A30B31T22P02','M16�1A30B41T22P01','M16�1A30B41T22P02'
  );}//+

  {testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16�1A10B11T22P01','M16�1A10B11T22P02','M16�1A10B21T22P01','M16�1A10B21T22P02',
   'M16�1A10B31T22P01','M16�1A10B31T22P02','M16�1A10B41T22P01','M16�1A10B41T22P02',
   'M16�2A10B11T22P01','M16�2A10B11T22P02','M16�2A10B21T22P01','M16�2A10B21T22P02',
   'M16�2A10B31T22P01','M16�2A10B31T22P02','M16�2A10B41T22P01','M16�2A10B41T22P02'
  );}

  { testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16�1A40B11T22P01','M16�1A40B11T22P02','M16�1A40B21T22P01','M16�1A40B21T22P02',
   'M16�1A40B31T22P01','M16�1A40B31T22P02','M16�1A40B41T22P01','M16�1A40B41T22P02',
   'M16�1A50B11T22P01','M16�1A50B11T22P02','M16�1A50B21T22P01','M16�1A50B21T22P02',
   'M16�1A50B31T22P01','M16�1A50B31T22P02','M16�1A50B41T22P01','M16�1A50B41T22P02'
  );}

  {testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16�2A50B11T22P01','M16�2A50B11T22P02','M16�2A50B21T22P01','M16�2A50B21T22P02',
   'M16�2A50B31T22P01','M16�2A50B31T22P02','M16�2A50B41T22P01','M16�2A50B41T22P02',
   'M16�1A60B11T22P01','M16�1A60B11T22P02','M16�1A60B21T22P01','M16�1A60B21T22P02',
   'M16�1A60B31T22P01','M16�1A60B31T22P02','M16�1A60B41T22P01','M16�1A60B41T22P02'
  );}



  {testStringsBVK:array[1..BVK_NUM_TEST_CH] of string=    //14
  ('M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21',
   'M16�1A20B60C22D41T21','M16�1A20B80C11T21','M16�1A20B80C21T21'
  );}


  {testStringsBVK:array[1..20] of string=    //14
  ('M16�1A70B11T22P01','M16�1A70B11T22P02','M16�1A70B21T22P01','M16�1A70B21T22P02',
   'M16�1A70B31T22P01','M16�1A70B31T22P02','M16�1A70B41T22P01','M16�1A70B41T22P02',
   'M16�1A20B60C22D11T21','M16�1A20B60C22D21T21','M16�1A20B60C22D31T21',
   'M16�1A20B60C22D41T21','M16�1A20B80C11T21','M16�1A20B80C21T21',
   'M16�1A20B80C31T21','M16�1A20B80C41T21','M16�1A20B60C31D11T21',
   'M16�1A20B60C31D21T21','M16�1A20B60C31D31T21','M16�1A20B60C31D41T21'
  );}

  //������ ��� �������� ��� ����� �����  (��)
  testBVK_Arr_pr:array[1..BVK_NUM_TEST_CH] of TBVKCHTestElem=
  (
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(500,0,0);durabilityT:(0,0,0)),
   (setTime:(1000,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0))
  );
  //�������� �������� ���������  �����. ������
  testBVK_Arr_pr_curr:array[1..BVK_NUM_TEST_CH] of Integer;
  //�������� ����������� ��������� �����. ������
  testBVK_Arr_pr_prev:array[1..BVK_NUM_TEST_CH] of Integer;
  //�������� ��������� ����������� ��������� ������
  testedState_pr:array[1..BVK_NUM_TEST_CH] of Integer;
  //�������� ���������� ���������
  testBVK_Arr_pr_BegState:array[1..BVK_NUM_TEST_CH] of Integer;

  //������ ��� ������� ��� ���. �����  (��)
  testBVK_Arr_G:array[1..BVK_NUM_TEST_CH] of TBVKCHTestElem=
  (
   (setTime:(202000,209000,325000);durabilityT:(1000,1000,1000)),
   (setTime:(326000,0,0);durabilityT:(1000,0,0)),
   (setTime:(203000,0,0);durabilityT:(500,0,0)),
   (setTime:(210000,0,0);durabilityT:(1000,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0)),
   (setTime:(210000,0,0);durabilityT:(1000,0,0)),
   (setTime:(326000,0,0);durabilityT:(1000,0,0)),
   (setTime:(204000,211000,327000);durabilityT:(500,1000,1000)),
   (setTime:(500,0,0);durabilityT:(0,0,0)),
   (setTime:(1000,0,0);durabilityT:(0,0,0)),
   (setTime:(25000,0,0);durabilityT:(0,0,0)),
   (setTime:(0,0,0);durabilityT:(0,0,0))
  );

  //�������� �������� ���������  ���. ������
  testBVK_Arr_G_curr:array[1..BVK_NUM_TEST_CH] of Integer;
  //�������� ����������� ��������� ���. ���������
  testBVK_Arr_G_prev:array[1..BVK_NUM_TEST_CH] of Integer;
  //�������� ��������� ����������� ��������� ������
  testedState_G:array[1..BVK_NUM_TEST_CH] of Integer;
  //�������� ���������� ���������
  testBVK_Arr_G_BegState:array[1..BVK_NUM_TEST_CH] of Integer;



  //testBVK_Arr_pr_Beg:array[1..BVK_NUM_TEST_CH] of Integer;





  //testBVK_Arr_G_Beg:array[1..BVK_NUM_TEST_CH] of Integer;
  // ��������� �������� ������ ��� ���. ��������� ��� �������� ����������� ��������� �������
  //testBVK_Arr_G_Beg_prev:array[1..BVK_NUM_TEST_CH] of Integer;
  //reversFlagArr:array[1..BVK_NUM_TEST_CH] of Boolean;

  //timeDownSetChArr:array[1..BVK_NUM_TEST_CH] of cardinal=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  //���� ��������� ���������� ���������
  prBegFl:Boolean=True;


  //������ ������������ ������
  //tTimeBVK_pr_setT:array[1..BVK_NUM_TEST_CH] of Cardinal=(0,0,0,0,0,0,0,0,0,0,500,1000,0,0);
  //������ ������������ ������ ����� ������������ ������
  //tTimeBVK_pr_durabilityT:array[1..BVK_NUM_TEST_CH] of Cardinal=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);

  //������ ��� �������� ��� �������� �����
  //������ ������������ ������
  //tTimeBVK_G_setT:array[1..BVK_NUM_TEST_CH] of Cardinal=(0,0,0,0,0,0,0,0,0,0,500,1000,0,0);
  //������ ������������ ������ ����� ������������ ������
  //tTimeBVK_G_durabilityT:array[1..BVK_NUM_TEST_CH] of Cardinal;



  minScale1:integer=-1;
  maxScale1:Integer=-1;
  minScale2:Integer=-1;
  maxScale2:Integer=-1;
  minScale3:Integer=-1;
  maxScale3:Integer=-1;
  minScale4:Integer=-1;
  maxScale4:Integer=-1;
  startTest_1_1_10_2:Boolean=False;

  //������� �������� � ���������
  testCount:Integer=0;
  startTestBlock:Boolean;
  testFlag_1_1_10_2:Boolean={false}true;
  //startTestMKT3:Boolean;
 

  testResult:Boolean;
  allTestFlag:Boolean=true;
  flagTestSrn:Boolean=True;

  bool_1_1_10_2:Boolean;
  testColibrFlag:Boolean=true;

  countRound:Integer=1;
  acumChVal:Integer=0;
  startTest:Boolean=false;
  testFlagRco:Boolean=True;
  testFlagSrn:Boolean=True;

  rezFlag:Boolean;

  NumberChannel: byte;
  TimerMode:integer;

  tArrRound:array[1..32]of array[1..31] of Integer;  //10->32

  Values:array [1..8,1..12] of real=(
  (0.2, 0.5,   1,  10,   20,   40,   50,   59,   63,   67,   125,   250),
  (0.2, 0.5,   1,  10,   20,   60,  100,  118,  125,  132,   250,   500),
  (0.2, 0.5,   1,  10,   50,  100,  200,  237,  250,  263,   500,  1000),
  ( 10,  20,  30,  60,  200,  400,  470,  475,  500,  525,  1000,  2000),
  ( 10,  20,  30, 100,  500,  800,  950,  950, 1000, 1050,  2000,  4000),
  ( 10,  20,  30, 400,  800, 1400, 1600, 1900, 2000, 2100,  4000,  8000),
  ( 10,  20,  30, 400, 1000, 2000, 3200, 3800, 4000, 4200,  8000, 16000),
  ( 10,  20,  30, 800, 4000, 6000, 6400, 7600, 8000, 8400, 16000, 32000));

  IsdMKBcontNum:array[1..20] of Integer=
  (1,2,3,4,5,6,7,8,9,11,13,15,17,19,21,23,25,27,29,31);



  IsdZUcontNum1:array[1..20] of Integer=
  (1,2,3,4,5,6,7,8,9,11,13,15,17,19,21,23,25,27,29,31);

  // IsdMKBcontNum2, IsdMKBcontNum3, IsdMKBcontNum4 ������� ������� ������ ��� ��������� �� ��� //!!!
  IsdZUcontNum2:array[1..20] of Integer=
  (1,2,3,4,5,6,7,8,9,11,13,15,17,19,21,23,25,27,29,31);

  IsdZUcontNum3:array[1..20] of Integer=
  (1,2,3,4,5,6,7,8,9,11,13,15,17,19,21,23,25,27,29,31);

  IsdZUcontNum4:array[1..20] of Integer=
  (1,2,3,4,5,6,7,8,9,11,13,15,17,19,21,23,25,27,29,31);


  IsdMKB_ZUchVal:array[1..32] of Integer=
  (50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,
  1050,1100,1150,1200,1250,1300,1350,1400,1450,1500,1600,1700);


  dataMKB:array[1..20]of Integer;

  flagMKBEnd:Boolean=false;

  //���� ���������� ������� ��������
  flagTestDev:Boolean=true;

  //timeSMKB:Int64=0;
  hourBVK:Word=0;
  minBVK:Word=0;
  secBVK:Word=0;
  mSecBVK:Word=0;
  timeBVKCarSec:Cardinal=0;
  timeBVKCarMSec:Cardinal=0;
  timeBVKPrevSec:Cardinal=0;
  timeBVKPrevMSec:Cardinal=0;
  //���� �������� ������������� ��������� BVK
  prFlag:Boolean;
  //���� �������� �������� ��������� BVK
  genFlag:Boolean;
  //������ �������� ������� ���2 ��� �������� ���
  dataB:array[1..20]of Integer;
  dataA:array[1..20]of Integer;
  //������������  �������� ���
  BVKTestFlag:Boolean=true;

  flagFtime:Boolean=false;
  startBVktime:Integer=0;  //��� ������������ 


  

  timeZUCarSec:Cardinal=0;
  timeZUCarMSec:Cardinal=0;
  timeZUPrevSec:Cardinal=0;
  timeZUPrevMSec:Cardinal=0;

  //��� ��������� ������� �������
  //testZU_Arr_pr_BegState:array[1..100] of Integer;
  //���������� ��������� ������� ��
  testZU_Arr_pr_prev:array[1..100] of Integer;
  //������� ��������� ������� ��
  testZU_Arr_pr_curr:array[1..100] of Integer;
  //�������� ����������� �������
  dataZU:array[1..100] of Integer;
  prBegZU:Boolean;
  ZUTestFlag:Boolean;

  //���� ������� �������� ��
  flagTestZU:Boolean=True;
  //���� ������� �������� ���
  flagTestBVK:Boolean=True;

  //������� ��������� �������� ��
  flagTestZUEnd:Boolean=False;

  flagTestBVK_End:Boolean=False;

  verify_send:Boolean;

  Current1:Double;
  curVal:string;




  procedure testNeedsAdrF;
  //function Test_1_1_10_2():Boolean;
  function testOnAllTestDevices:Boolean;
  procedure changeResistance(Value:real);
  function iniRead():Boolean;
  function TestConnect(Name:string; var m_defaultRM_usbtmc_loc,
    m_instr_usbtmc_loc:Longword; vAtr:Longword; m_Timeout: integer):integer;
  function PowerTestConnect():Boolean ;
  function SetVoltageOnPowerSupply(NumberPowerSupply:integer;V:string):byte;
  function SetOnPowerSupply(NumberPowerSupply:integer):byte;
  function SetConf(m_instr_usbtmc_loc:Longword; command:string):integer;
  function GetDatStr(m_instr_usbtmc_loc:Longword; var dat:string):integer;
  procedure Delay_S(S:Integer);
  procedure Delay_ms(ms:Integer);
  function setColibr(scaleNum:Integer;colib:word):Boolean;
  function getScaleNum(chVal:word):Integer;
  function testChannals(colibMin:integer;colibMax:integer;colibMinOm:Integer;colibMaxOm:Integer;transOm:double):Boolean;
  procedure SendCommandToISD(str:string);
  function testColibr:Boolean;
  function testCompens(testVal:integer; dVal:integer; colibMin:integer; colibMax:integer; colibMinOm:Integer; colibMaxOm:Integer):boolean;
  procedure TestMKB2;
  procedure testVpMKB2();
  function getVoltmetrValue(m_instr_usbtmc:Cardinal):double;
  procedure setFrequencyOnGenerator(freq:real;ampl:real;m_instr_usbtmc:cardinal);
  procedure TestBVK;
  procedure setValOnCh(modZU:Integer);
  procedure testZU;
  procedure testMPIU;
  procedure testSazPr;
  procedure TestMKT3;
  procedure generatorOutOn(m_instr_usbtmc:cardinal);
  function SendCommandToPowerSupply(NumberPowerSupply:integer;Command:string):byte;
implementation
  uses OrbitaAll;

//������� �������� ����������� Comm1
function ComTestConect():Boolean;
var
  falseFlag:Boolean;      // ���� ����������� ��� �������������
begin
  falseFlag:=True;        // ����������� ��� ��������
  try
      comm1.Open();       // ���������� ������������
  except
      on ECommError do    // ���� ���������� ������ �����������
      begin
          falseFlag:=False; // ���� � �����
          ShowMessage(ComPortTransmille+' ����������');
      end;
  end;
  if(falseFlag=True)  then // ���� ���� ������� �� ������� ���
  begin
      comm1.Close();
  end;
  Result:=falseFlag;
end;

//��������� ��������� �������������
//value- �������� � ��
procedure changeResistance(Value:real);
var
  buf:array[0..255] of char;
  i:integer;
  str:string;
begin
  str:=FloatToStr(Value);
  comm1.Open();
  for i:=0 to length(str)-1 do buf[i]:=str[i+1];
  buf[i]:=#13;
  buf[i+1]:=#10;
  comm1.Write(buf,i+2);
  comm1.Close;
end;

//�������� ������� ��������
function testOnAllTestDevices:Boolean;
var
  str:string;
begin
  flagTestDev:=True;

  //�������� ����������� ��������
  // �������� RS - 485 -----------------------------------------------------------
  {Flag485On:=false;

  Form1.idcmpclnt1.Host:=IP_ADAPTER_RS485;
  Form1.idcmpclnt1.ReceiveTimeout:=3000;
  try
  Form1.idcmpclnt1.Ping;
  except
      showmessage('��������� ��������� �� ����� ��������������');
  end;

  while(not Flag485On)  do
  begin
    application.ProcessMessages;
  end; }






  //�������� ����������� �������� �������������
  {if (not ComTestConect) then
  begin
    flagTestDev:=False;
    form1.Memo1.Lines.Add('������� ������������� Transmille �� ���������!');
  end
  else
  begin
    form1.Memo1.Lines.Add('������� ������������� Transmille ���������!');
  end;}

  //�������� ����������� ����������_1
  if (TestConnect(AkipV7_78_1,m_defaultRM_usbtmc_1[0],m_instr_usbtmc_1[0],viAttr_1,Timeout)=-1) then
  begin
      form1.Memo1.Lines.Add('��������� �� ���������!');
      flagTestDev:=False;
  end
  else
  begin
      form1.Memo1.Lines.Add('��������� ���������!');
  end;

  //SetConf(m_instr_usbtmc_1[0],'READ?');
  //��������� ���������� � ����������_1
  //GetDatStr(m_instr_usbtmc_1[0],str);


  //�������� ����������� ����������_2
  {if (TestConnect(AkipV7_78_2,m_defaultRM_usbtmc_2[0],m_instr_usbtmc_2[0],viAttr_2,Timeout)=-1) then
  begin
      form1.Memo1.Lines.Add('���������_2 �� ���������!');
      flagTestDev:=False;
  end
  else
  begin
      form1.Memo1.Lines.Add('���������_2 ���������!');
  end;}
  {SetVoltageOnPowerSupply(1,'0000');
  SetOnPowerSupply(1);
  Delay_S(5);
  SetOnPowerSupply(0);
  //�������� �������� ������� ���
  //SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1'); }

  //�������� ����������� ��������� �������
  if (PowerTestConnect) then
  begin
    form1.Memo1.Lines.Add('�������� ������� ����-1105 ���������!');
  end
  else
  begin
    form1.Memo1.Lines.Add('�������� ������� ����-1105 �� ���������!');
    flagTestDev:=False;
  end;

  // �������� ���_1--------------------------------------------------------------------------------------------------
  try
      //������ ������������ ������. ���� ����� ���� �� ��� ����
      str:=Form1.IdHTTP1.Get('http://'+ISDip_1);
      Form1.Memo1.Lines.Add('���_1 ���������!');
  except
   Form1.Memo1.Lines.Add('���_1 �� ���������!');
   flagTestDev:=False;
   //Exit;
  end;



  // �������� ���_2--------------------------------------------------------------------------------------------------
  try
      //������ ������������ ������. ���� ����� ���� �� ��� ����
      str:=Form1.IdHTTP2.Get('http://'+ISDip_2);
      Form1.Memo1.Lines.Add('���_2 ���������!');
  except
   Form1.Memo1.Lines.Add('���_2 �� ���������!');
   flagTestDev:=False;
   //Exit;
  end;

  Form1.idpsrvr1.Active:=False;

  //�������� ����������� ����������
  if (TestConnect(RigolDg1022_1,m_defaultRM_usbtmc_2[1],m_instr_usbtmc_2[1],viAttr,Timeout)=-1) then
  begin
    form1.Memo1.Lines.Add('��������� �� ���������!');
    flagTestDev:=False;
  end
  else
  begin
    form1.Memo1.Lines.Add('��������� ���������!');
  end;

  //�������� ����� ��� ���������� ������ ������� ���
  //SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');


  Result:=flagTestDev;
end;





// -----------------------------------------------------------
// ��������� ������ � ���
// -----------------------------------------------------------
function GetDatStr(m_instr_usbtmc_loc:Longword; var dat:string):integer;
var
  i:integer;
  len:integer;
  status:integer;
  pStrin:vichar;
  nRead: integer;
  stbuffer:string;
begin
  dat:='';
  setlength(pStrin,64);
  sleep(45);//100
  len:= 64;
  status := viRead(m_instr_usbtmc_loc, pStrin, len, @nRead);
  if (nRead > 0) then
  begin
      stbuffer:='';
      for i:=0 to (nRead-1) do
      begin
        stbuffer:=stbuffer+pStrin[i];
      end;
  end;
  if(stbuffer='') then
  begin
      form1.Memo1.Lines.Add('������ ���')
  end
  else
  begin
      dat:=floattostrf(strtofloat(stbuffer), fffixed, 5, 4);
  end;
end;
// ----------------------------------------------------------------


// -------------------------------------------------
// �������� � �������������
// -------------------------------------------------
procedure Delay_ms(ms:Integer);
begin
    sleep(ms);
    Application.ProcessMessages();
end;
// --------------------------------------------------
// �������� � ��������
// --------------------------------------------------
procedure Delay_S(S:Integer);
var
    i:Integer;
begin
    for i:=0 to (s*4) do                // ��������� ������� �� 250 ����������� ����� ��������� �� ���������
    begin
        sleep(250);
        Application.ProcessMessages();  // ����� �� ���������
    end;
end;
// ----------------------------------------------------
// ������� �������� ������� �� �������� �������
// ----------------------------------------------------
function SendCommandToPowerSupply(NumberPowerSupply:integer;Command:string):byte;
var
  pStrout:string;
begin
  pStrout:=Command+#13;
  if (NumberPowerSupply=1) then
  begin
    form1.idpsrvr1.Send(IP_POWER_SUPPLY_1,4001,pStrout);
  end;

end;
// -----------------------------------------------------
// ����� ��������� �� �������� �������
// -----------------------------------------------------
function ResetVoltageOnPowerSupply(NumberPowerSupply:integer):byte;
begin
  SendCommandToPowerSupply(NumberPowerSupply,'SOUT 0');
  sleep(100);
  SendCommandToPowerSupply(NumberPowerSupply,'VOLT 0'+'0000');
  sleep(100);
  SendCommandToPowerSupply(NumberPowerSupply,'CURR 0'+'0000');
  sleep(100);
end;
// ------------------------------------------------------
// �-�� ��������� ���������� �� �������� �������
// ------------------------------------------------------
function SetVoltageOnPowerSupply(NumberPowerSupply:integer;V:string):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'VOLT 0'+V);
    sleep(100);
end;
// -------------------------------------------------------
// �-�� ��������� ���� �� �������� �������
// -------------------------------------------------------
function SetCurrentOnPowerSupply(NumberPowerSupply:integer;A:string):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'CURR 0'+A);
    sleep(100);
end;
// --------------------------------------------------------
// �-�� ��������� ������ ON ��������� �������
// --------------------------------------------------------
function SetOnPowerSupply(NumberPowerSupply:integer):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'SOUT 1');
end;
// --------------------------------------------------------
// �-�� ��������� ������ ON ��������� �������
// --------------------------------------------------------
function TurnOFFPowerSupply(NumberPowerSupply:integer):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'SOUT 0');
    sleep(100);
end;
// ---------------------------------------------------------
// ������� �������� ����������� ��������� �������
// ---------------------------------------------------------
function PowerTestConnect():Boolean ;
begin
  AkipOffOnState:=false;
  //SetOnPowerSupply(1);
  SendCommandToPowerSupply(1, 'GETD'); // ������� ��� �����������
  Delay_S(5);
  if(AkipOffOnState=false) then
  begin
      Result:=False;
  end
  else
  begin
      Result:=True;
  end;
end;

function TestConnect(Name:string; var m_defaultRM_usbtmc_loc, m_instr_usbtmc_loc:Longword; vAtr:Longword; m_Timeout: integer):integer;
var
  status:integer;
  viAttr:Longword;

  m_findList_usbtmc: LongWord;
  m_nCount: LongWord;
  instrDescriptor:vichar;
begin
  setlength(instrDescriptor,255);

  result:=0;
  status:= viOpenDefaultRM(@m_defaultRM_usbtmc_loc);
  if (status < 0) then
  begin
    viClose(m_defaultRM_usbtmc_loc);
    m_defaultRM_usbtmc_loc:= 0;
        result:=-1;
        //  showmessage('       ��������� �������� �� ������!');
  end
  else
  begin
    status:= viFindRsrc(m_defaultRM_usbtmc_loc, name, @m_findList_usbtmc, @m_nCount, instrDescriptor);
    if (status < 0) then
    begin
      status:= viFindRsrc (m_defaultRM_usbtmc_loc, 'USB[0-9]*::5710::3501::?*INSTR', @m_findList_usbtmc, @m_nCount, instrDescriptor);
      if (status < 0) then
      begin
        viClose(m_defaultRM_usbtmc_loc);
        result:=-1;
            //    showmessage('       ��������� �������� �� ������!');
        m_defaultRM_usbtmc_loc:= 0;
        exit;
      end
      else
      begin
        viOpen(m_defaultRM_usbtmc_loc, instrDescriptor, 0, 0, @m_instr_usbtmc_loc);
        status:= viSetAttribute(m_instr_usbtmc_loc, vatr, m_Timeout);
      end
    end
    else
    begin
      status:= viOpen(m_defaultRM_usbtmc_loc, instrDescriptor, 0, 0, @m_instr_usbtmc_loc);
      status:= viSetAttribute(m_instr_usbtmc_loc, viAttr, m_Timeout);
    end
  end;

  result:=status;
end;

function SetConf(m_instr_usbtmc_loc:Longword; command:string):integer;
var
  pStrout:vichar;
  i:integer;
  nWritten:LongWord;
begin
  setlength(pStrout,64);
  for i:=0 to length(command) do
  begin
    pStrout[i]:=command[i+1];
  end;
  result:= viWrite(m_instr_usbtmc_loc, pStrout, length(command), @nWritten);
  Sleep(30);
end;

procedure SendCommandToISD(str:string);
var
  st:string;
begin
  st:=form1.IdHTTP1.Get(str);
  if (st<>'������� ������� ���������!') then showmessage('�������� �������� �������� �� ��������!');
end;

// -------------------------------------------------------------
// ������� ��������� ������ �� ��� ���� ���
// -------------------------------------------------------------
procedure IsdConnectChanel(chanel:integer;ISDip:string);
var
    num:string;
begin
    num:=IntToStr(chanel);
    SendCommandToISD('http://'+ISDip+'/type=2num='+num+'val=1');
end;

// -------------------------------------------------------------
// ������� ���������� ������ �� ��� ���� ���
// -------------------------------------------------------------
procedure IsdDisconnectChanel(chanel:integer;ISDip:string);
var
    num:string;
begin
    num:=IntToStr(chanel);
    SendCommandToISD('http://'+ISDip+'/type=2num='+num+'val=0');
end;

function iniRead():Boolean;
var
  flag:Boolean;
  //str:string;
begin
  //������� ������ Com ��� ������ � ��������� �������������
  comm1:=Tcomm.Create({self}nil);
  flag:=True;
  //str:=ExtractFileDir(ParamStr(0))+'Periphery.ini';
  //������ ���� ������������ ��������
  IniPeriphery:= TIniFile.Create(ExtractFileDir(ParamStr(0))+'\Periphery.ini');

  Form1.idpsrvr2.DefaultPort := IniPeriphery.ReadInteger('Adapter_RS485', 'Port', 1000);
  IP_ADAPTER_RS485 := IniPeriphery.ReadString('Adapter_RS485', 'IP_address', '-111');

  //������ ip ��������� �������
  IP_POWER_SUPPLY_1:=IniPeriphery.ReadString('Device','IP_POWER_SUPPLY_1','-111');
  //������ ���� ��������� �������
  form1.idpsrvr1.DefaultPort:=StrToInt(IniPeriphery.ReadString('Device','port_POWER_SUPPLY_1','6008'));
  
  //������ ip ����� ISD_1
  ISDip_1:=IniPeriphery.ReadString('Device','ISDip_1','-111');
  //������ ip ����� ISD_2
  ISDip_2:=IniPeriphery.ReadString('Device','ISDip_2','-111');
  //������ �� ����� ���������� ����������
  RigolDg1022_1:=IniPeriphery.ReadString('Device','RigolDg1022_1','-111');
  //������  ����� Com �����
  COMnum:=IniPeriphery.ReadString('Device','COM','-111');
  //������� ����������_1
  AkipV7_78_1:=IniPeriphery.ReadString('Device','AkipV7_78_1','USB[0-9]*::0x164E::0x0DAD::?*INSTR');
  //������� ����������_2
  //AkipV7_78_2:=IniPeriphery.ReadString('Device','AkipV7_78_2','USB[0-9]*::0x164E::0x0DAD::?*INSTR');

  Form1.idpsrvr1.Active:=True;

  if {((IP_POWER_SUPPLY_1='-111') or (ISDip_1='-111') or (ISDip_2='-111') or (RigolDg1022_1='-111') or (COMnum='-111'))}((IP_POWER_SUPPLY_1='-111') or (ISDip_1='-111') or (RigolDg1022_1='-111') or (COMnum='-111')) then
  begin
    ShowMessage('����������� ��� ������������ ���� ������������ Periphery.ini');
    flag:=False;
  end
  else
  begin
    {form1.}comm1.DeviceName:=COMnum;
    form1.IdHTTP1.Host:=ISDip_1;
    form1.IdHTTP2.Host:=ISDip_2;
    Result:=flag;
  end;
end;

//������� ���������� ����� ������������
function getScaleNum(chVal:word):Integer;
var
  chValBuf:Word;
begin
  //����������� ��� ���� ����� ���� ������� � ������ �� ��������
  chValBuf:=(chVal and 768)shr 8;
  //������� ������ �����
  Result:=chValBuf;
end;


//������������� ���������� ��� ���� �������������
function setColibr(scaleNum:Integer;colib:word):Boolean;
var
  avg:Integer;
  i:Integer;
begin
  //� �������� ��������� ��������� ��������� ��
  //� ���� ���������� �� ������������� �� ���������� ���

  case scaleNum of
    0:
    begin
      //����� �������� ������������, ���� ������ ��� �� ��� �����. ���������
      if (colib>135) then
      begin
        //���������� ���������
        //maxScale4:=colib;
        maxScale4Arr[iMaxScale4Arr]:=colib;
        if iMaxScale4Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+maxScale4Arr[i];
          end;
          maxScale4:=Round(avg/ROUND_P_N);
          iMaxScale4Arr:=1;
        end;
        Inc(iMaxScale4Arr);
      end
      else
      begin
        //���������� ��������
        //minScale4:=colib;
        minScale4Arr[iMinScale4Arr]:=colib;
        if iMinScale4Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+minScale4Arr[i];
          end;
          minScale4:=Round(avg/ROUND_P_N);
          iMinScale4Arr:=1;
        end;
        Inc(iMinScale4Arr);
      end;
    end;
    1:
    begin
      if (colib>391) then
      begin
        //���������� ���������
        //maxScale3:=colib;
        maxScale3Arr[iMaxScale3Arr]:=colib;
        if iMaxScale3Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+maxScale3Arr[i];
          end;
          maxScale3:=Round(avg/ROUND_P_N);
          iMaxScale3Arr:=1;
        end;
        Inc(iMaxScale3Arr);
      end
      else
      begin
        //���������� ��������
        //minScale3:=colib;
        minScale3Arr[iMinScale3Arr]:=colib;
        if iMinScale3Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+minScale3Arr[i];
          end;
          minScale3:=Round(avg/ROUND_P_N);
          iMinScale3Arr:=1;
        end;
        Inc(iMinScale3Arr);
      end;
    end;
    2:
    begin
      if (colib>647) then
      begin
        //���������� ���������
        //maxScale2:=colib;
        maxScale2Arr[iMaxScale2Arr]:=colib;
        if iMaxScale2Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+maxScale2Arr[i];
          end;
          maxScale2:=Round(avg/ROUND_P_N);
          iMaxScale2Arr:=1;
        end;
        Inc(iMaxScale2Arr);
      end
      else
      begin
        //���������� ��������
        //minScale2:=colib;
        minScale2Arr[iMinScale2Arr]:=colib;
        if iMinScale2Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+minScale2Arr[i];
          end;
          minScale2:=Round(avg/ROUND_P_N);
          iMinScale2Arr:=1;
        end;
        Inc(iMinScale2Arr);
      end;
    end;
    3:
    begin
      if (colib>903) then
      begin
        //���������� ���������
        //maxScale1:=colib;
        maxScale1Arr[iMaxScale1Arr]:=colib;
        if iMaxScale1Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+maxScale1Arr[i];
          end;
          maxScale1:=Round(avg/ROUND_P_N);
          iMaxScale1Arr:=1;
        end;
        Inc(iMaxScale1Arr);
      end
      else
      begin
        //���������� ��������
        //minScale1:=colib;
        minScale1Arr[iMinScale1Arr]:=colib;
        if iMinScale1Arr=ROUND_P_N then
        begin
          avg:=0;
          for i:=1 to ROUND_P_N do
          begin
            avg:=avg+minScale1Arr[i];
          end;
          minScale1:=Round(avg/ROUND_P_N);
          iMinScale1Arr:=1;
        end;
        Inc(iMinScale1Arr);
      end;
    end;
  end;

  //Form1.mmoTestResult.Lines.Add(IntToStr(minScale1)+' '+IntToStr(maxScale1)+' '+
  //IntToStr(minScale2)+' '+IntToStr(maxScale2)+' '+IntToStr(minScale3)+' '+IntToStr(maxScale3)+' '+
  //IntToStr(minScale4)+' '+IntToStr(maxScale4));






  if ((minScale1<>-1)and(maxScale1<>-1)and(minScale2<>-1)and(maxScale2<>-1)and
    (minScale3<>-1)and(maxScale3<>-1)and(minScale4<>-1)and(maxScale4<>-1))then
  begin
    if ((minScale1>0)and(maxScale1>0)and(minScale2>0)and(maxScale2>0)and
      (minScale3>0)and(maxScale3>0)and(minScale4>0)and(maxScale4>0)) then
    begin
      result:=true;
    end
    else
    begin
      result:=false;
    end;
  end
  else
  begin
    result:=false;
  end;
end;



//��������� ��� ������ ����������� ������ ������� �������
procedure testNeedsAdrF;
var
  i:Integer;
begin
  form1.OrbitaAddresMemo.Clear;
  Form1.diaSlowAnl.Series[0].Clear;
  Form1.diaSlowCont.Series[0].Clear;
  Form1.tempDia.Series[0].Clear;
  case adrTestNum of
    0:
    begin
      //������������ ���. ������. �� ����� ��� �����������
      form1.OrbitaAddresMemo.Lines.LoadFromFile(propStrPath);
    end;
    1:
    begin
      //�������� � ���� �������� ������ ��� �������� ���2
      for i:=1 to Length(testStringsMKB2) do //20
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMKB2[i]);
      end;
      //form1.OrbitaAddresMemo.Enabled:=False;
    end;
    2:
    begin
      //�������� � ���� �������� ������ ��� ��������  ���3
      for i:=1 to Length(testStringsMKT3) do //32
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMKT3[i]);
      end;
      //form1.OrbitaAddresMemo.Enabled:=False;
    end;
    3:
    begin
      //�������� � ���� �������� ������ ��� ��������  ���
      for i:=1 to Length(testStringsBVK) do   //12
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsBVK[i]);
      end;
    end;
    4:
    begin
      for i:=1 to Length(testStringsZU1_1) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU1_1[i]);
      end;
    end;
    5:
    begin
      for i:=1 to Length(testStringsZU1_2) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU1_2[i]);
      end;
    end;
    6:
    begin
      for i:=1 to Length(testStringsZU2) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU2[i]);
      end;
    end;
    7:
    begin
      for i:=1 to Length(testStringsZU3_1) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU3_1[i]);
      end;
    end;
    8:
    begin
      for i:=1 to Length(testStringsZU3_2) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU3_2[i]);
      end;
    end;
    9:
    begin
      for i:=1 to Length(testStringsZU3_3) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU3_3[i]);
      end;
    end;

    10:
    begin
      for i:=1 to Length(testStringsZU4) do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsZU4[i]);
      end;
    end;

    11: //21
    begin
      numTestMPIUch:=Length(testStringsMPIU31_1_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU31_1_1[i]);
      end;
    end;

    12: //21
    begin
      numTestMPIUch:=Length(testStringsMPIU41_1_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_1_1[i]);
      end;
    end;

    13: //21
    begin
      numTestMPIUch:=Length(testStringsMPIU32_1_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU32_1_1[i]);
      end;
    end;

    14:
    begin
      numTestMPIUch:=Length(testStringsSAZ);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsSAZ[i]);
      end;
    end;

    15:
    begin
      numTestMPIUch:=Length(testStringsPeriodTest);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsPeriodTest[i]);
      end;
    end;



    {14: //01,05
    begin
      numTestMPIUch:=Length(testStringsMPIU41_1_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_1_1[i]);
      end;
    end;

    15: //11
    begin
      numTestMPIUch:=Length(testStringsMPIU41_2_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_2_1[i]);
      end;
    end;

    16: //21,22
    begin
      numTestMPIUch:=Length(testStringsMPIU41_3_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_3_1[i]);
      end;
    end;

    17: //21,22
    begin
      numTestMPIUch:=Length(testStringsMPIU32_1_1);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU32_1_1[i]);
      end;
    end;

    18: //01
    begin
      numTestMPIUch:=Length(testStringsMPIU31_1_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU31_1_2[i]);
      end;
    end;

    19: //11
    begin
      numTestMPIUch:=Length(testStringsMPIU31_2_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU31_2_2[i]);
      end;
    end;

    20: //21,22
    begin
      numTestMPIUch:=Length(testStringsMPIU31_3_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU31_3_2[i]);
      end;
    end;

    21: //01,05
    begin
      numTestMPIUch:=Length(testStringsMPIU41_1_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_1_2[i]);
      end;
    end;

    22: //11
    begin
      numTestMPIUch:=Length(testStringsMPIU41_2_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_2_2[i]);
      end;
    end;

    23: //21,22
    begin
      numTestMPIUch:=Length(testStringsMPIU41_3_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU41_3_2[i]);
      end;
    end;

    24: //21,22
    begin
      numTestMPIUch:=Length(testStringsMPIU32_1_2);
      for i:=1 to numTestMPIUch do
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMPIU32_1_2[i]);
      end;
    end; }
  end;
end;

function getAbsAccuracy(chValOm:double;colibMinOm:Integer;colibMaxOm:Integer;transOm:double):Double;
var
  accur:double;
begin
  //accur:=abs((chValOm-transOm)/(colibMaxOm-colibMinOm));
  accur:=abs(100-((chValOm/transOm)*100));
  Result:=accur;
end;



//�������� ������� ��� �����������
function testCompens(testVal:integer; dVal:integer; colibMin:integer; colibMax:integer; colibMinOm:Integer; colibMaxOm:Integer):boolean;
var
  i:Integer;
  bool:Boolean;
  chValOm:double;
begin
  bool:=True;
  for i:=1 to 31 do
  begin
    chValOm:= (((tempArr3[i].val-colibMin)*(colibMaxOm-colibMinOm))/(colibMax-colibMin))+colibMinOm;

    //if  (tempArr2[i].val>=20)and(tempArr2[i].val<=30)then
    if  (tempArr3[i].val>=(testVal-dVal))and(tempArr3[i].val<=(testVal+dVal))then
    begin
      form1.mmoTestResult.Lines.Add('�����: '+intTostr(i+1)+' �������� �� ������: '+floatToStrF(chValOm,ffFixed,5,4)+' �� '+' �����');
    end
    else
    begin
      form1.mmoTestResult.Lines.Add('�����: '+intTostr(i+1)+' �������� �� ������: '+floatToStrF(chValOm,ffFixed,5,4)+' �� '+' !!! �� ����� !!!');
      bool:=false;
    end;
  end;
  Form1.mmoTestResult.Lines.Add('');
  result:=bool;
end;

//�������� �������
function testChannals(colibMin:integer;colibMax:integer;colibMinOm:Integer;colibMaxOm:Integer;transOm:double):Boolean;
var
  i:integer;
  bool:Boolean;
  absAc:double;
  chValOm:Double;
begin
  bool:=True;
  for i:=1 to 31 do
  begin
    if (not isTestCloseFl) then
    begin
      //chValOm:=(((tempArr2[i].val-colibMin)/(colibMax-colibMin))*(colibMaxOm-colibMinOm)+colibMinOm);
      chValOm:= (((tempArr3[i].val-colibMin)*(colibMaxOm-colibMinOm))/(colibMax-colibMin))+colibMinOm;


      absAc:=getAbsAccuracy(chValOm,colibMinOm,colibMaxOm,transOm);

      //    form1.Memo1.Lines.Add('�������� ������ � ���� '+floatTostr(chValOm));
      //    form1.Memo1.Lines.Add('�����'+intTostr(i)+' ���������� min ����:'+intTostr(colibMin)+
      //      ' ���������� max ����:'+intTostr(colibMax)+' ���������� min ���:'+intTostr(colibMinOm)+
      //      ' ���������� max ���:'+intTostr(colibMaxOm)+' �������� ������ � ����'+intTostr(tempArr2[i].val)+
      //      ' ����������'+floatTostr(transOm));


      if  (absAc*100<=1*100) then
      begin
        form1.mmoTestResult.Lines.Add('�����: '+intTostr(i+1)+' �������������: '+floatTostrF(chValOm,ffFixed,5,3)+' ��'+
        ' �����������: '+floatTostrF(absAc,ffFixed,2,2)+' %'+' �����');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('�����: '+intTostr(i+1)+' �������������: '+floatTostrF(chValOm,ffFixed,5,3)+' ��'+
          ' �����������: '+floatTostrF(absAc,ffFixed,2,2)+' %'+' !!! �� ����� !!!');
      end;
    end;
  end;

  form1.mmoTestResult.Lines.Add('');
end;


//������� ��� �������� ������������ ����������
function testColibr:Boolean;
var
  allColibTest:Boolean;
begin
  allColibTest:=true;
  if ((minScale4>=20)and(minScale4<=30)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���4: '+intTostr(minScale4)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���4: '+intTostr(minScale4)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((maxScale4>=240)and(maxScale4<=250)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����4: '+intTostr(maxScale4)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����4: '+intTostr(maxScale4)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((minScale3>=276)and(minScale3<=286)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���3: '+intTostr(minScale3)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���3: '+intTostr(minScale3)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((maxScale3>=496)and(maxScale3<=506)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����3: '+intTostr(maxScale3)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����3: '+intTostr(maxScale3)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((minScale2>=532)and(minScale2<=542)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���2: '+intTostr(minScale2)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���2: '+intTostr(minScale2)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((maxScale2>=752)and(maxScale2<=762)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����2: '+intTostr(maxScale2)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����2: '+intTostr(maxScale2)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((minScale1>=788)and(minScale1<=798)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���1: '+intTostr(minScale1)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ���1: '+intTostr(minScale1)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  if ((maxScale1>=1008)and(maxScale1<=1018)) then
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����1: '+intTostr(maxScale1)+' �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('���������� ����1: '+intTostr(maxScale1)+' !!! �� ����� !!!');
    allColibTest:=False;
  end;

  //������� ���������� ��� �� ���������� ����������
  minScale1:=-1;
  maxScale1:=-1;
  minScale2:=-1;
  maxScale2:=-1;
  minScale3:=-1;
  maxScale3:=-1;
  minScale4:=-1;
  maxScale4:=-1;     

  result:=allColibTest;
end;


//��������� ������������� �� ������� ���2
procedure SetcoefU(ky:integer;chn:integer);
begin
  if ky=1 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=1');
      end;
      2:begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=1');
        end;
      3:begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=1');
        end;
      4:begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=1');
        end;
    end;
  end;

  if ky=2 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=1');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=1');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=1');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=1');
      end;
    end;
  end;

  if ky=4 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=0');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=0');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=0');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=0');
      end;
    end;
  end;

  if ky=8 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=0');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=0');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=0');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=0');
      end;
    end;
  end;

  if ky=16 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=1');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=1');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=1');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=1');
      end;
    end;
  end;

  if ky=32 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=1');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=1');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=1');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=1');
      end;
    end;
  end;

  if ky=64 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=0');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=0');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=0');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=0');
      end;
    end;
  end;

  if ky=128 then
  begin
    case (chn) of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=25val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=26val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=27val=0');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=32val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=33val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=34val=0');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=39val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=40val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=41val=0');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=46val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=47val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=48val=0');
      end;
    end;
  end;
end;

// ----------------------------------------------------------
// ������� �������� ������� � USB
// ----------------------------------------------------------
function SetUsbConf(m_instr_usbtmc_loc:Longword; command:string):integer;
var
    pStrout:vichar;
    i:integer;
    nWritten:LongWord;
begin
    setlength(pStrout,64);
    for i:=0 to length(command) do
    begin
        pStrout[i]:=command[i+1];
    end;
    result:= viWrite(m_instr_usbtmc_loc, pStrout, length(command), @nWritten);
    Sleep(30);
end;
// -----------------------------------------------------------
// ������� ���������� ������ ����������
// -----------------------------------------------------------
procedure GeneratorOutOff(m_instr_usbtmc:cardinal);
begin
  SetUsbConf(m_instr_usbtmc,'OUTP OFF');
end;
// -----------------------------------------------------------
// ���������� ��������� �� ���������
// -----------------------------------------------------------
procedure GeneratorSetFrequency(Freq:real;Ampl:real;Offset:real;Dcyc:real;m_instr_usbtmc:cardinal);
begin
    SetUsbConf(m_instr_usbtmc,'VOLT:UNIT VPP');
    SetUsbConf(m_instr_usbtmc,'APPL:PULSE '+ floattostr(Freq)+','+floattostr(Ampl)+','+floattostr(Offset));
    //SetUsbConf(m_instr_usbtmc[1],'PHAS 0');
    SetUsbConf(m_instr_usbtmc,'PULS:DCYC '+floattostr(Dcyc));
    //http://www.batronix.com/pdf/Rigol/ProgrammingGuide/DG1000_ProgrammingGuide_EN.pdf
end;
// ------------------------------------------------------------
// ������� ��������� ������ �� ���������
// ------------------------------------------------------------
procedure generatorOutOn(m_instr_usbtmc:cardinal);
begin
  SetUsbConf(m_instr_usbtmc,'OUTP ON');
end;

procedure setFrequencyOnGenerator(freq:real;ampl:real;m_instr_usbtmc:cardinal);
begin
  SetConf(m_instr_usbtmc,'VOLT:UNIT VPP');
  SetConf(m_instr_usbtmc,'APPL:SIN '+ Floattostr(Freq)+','+floattostr(Ampl)+',0.0');
  SetConf(m_instr_usbtmc,'PHAS 0');
  SetConf(m_instr_usbtmc,'OUTP ON');
end;

//���������� ��������� � ����������� ����������
function getVoltmetrValue(m_instr_usbtmc:Cardinal):double;
var
  str:string;
begin
  sleep(40);
  SetConf(m_instr_usbtmc,'READ?');
  sleep(150);
  GetDatStr(m_instr_usbtmc,str);
  sleep(10);
  Result:=StrToFloat(str);
end;

function SetGNDVoltage(ISD_ip:string;m_instr_usbtmc:cardinal):double;                                 //������������� ���������� ���������� 6,2�
var
  i:integer;
  voltmetrValue:double;
begin
  i:=795;
  SendCommandToISD('http://'+ISD_ip+'/type=1num=85val='+IntToStr(i)+'work=1');
  SendCommandToISD('http://'+ISD_ip+'/type=3num=85val=1');
  voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc);
  while ((voltmetrValue<-0.0015) or (voltmetrValue>0.0015)) do
  begin
    if (voltmetrValue<-0.0015) then
    begin
      inc(i)
    end
    else
    begin
      dec(i);
    end;
    SendCommandToISD('http://'+ISD_ip+'/type=1num=85val='+IntToStr(i)+'work=1');
    sleep(5);
    voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc);
  end;
  SendCommandToISD('http://'+ISD_ip+'/type=3num=85val=0');
  Result:=voltmetrValue;
end;


procedure testVpMKB2();
var
  voltmetrValue:double;
begin
  //�������� ����������� ���������� 3,1�
  rezFlag:=true;
  Form1.mmoTestResult.Lines.Add('');
  Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.11.1 �� ����.468363.026 (�������� �������� ����������� ���������� �� ������ ������� ������)');
  Form1.mmoTestResult.Lines.Add('');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('1 �����: ���������� = '+FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('1 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�   !!! �� ����� !!!')
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=34val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('2 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('2 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�   !!! �� ����� !!!')
  end;
  SendCommandToISD('http://'+Form1.IdHTTP1.Host+'/type=3num=34val=0');

  SendCommandToISD('http://'+Form1.IdHTTP1.Host+'/type=3num=35val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('3 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�   �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('3 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�   !!! �� ����� !!!')
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=35val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('4 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�   �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('4 �����: ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�   !!! �� ����� !!!')
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=0');

  Form1.mmoTestResult.Lines.Add('');
  if (rezFlag) then
  begin
    Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.11.1 �� ����.468363.026 (�������� �������� ����������� ���������� �� ������ ������� ������) : �����')
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.11.1 �� ����.468363.026 (�������� �������� ����������� ���������� �� ������ ������� ������) : !!! �� ����� !!!');
    allTestFlag:=False;
  end;


  //SetConf(m_instr_usbtmc[0],'CONF:VOLT:AC');
end;




function setCalibrVoltage(ISD_ip:string;m_instr_usbtmc:Cardinal):double;                                 //������������� ���������� ���������� 6,2�
var
  i:integer;
  voltmetrValue:double;
begin
  for i:=1 to 96 do
  begin
    SendCommandToISD('http://'+ISD_ip+'/type=3num='+IntToStr(i)+'val=0');
  end;

  i:=3336;
  SendCommandToISD('http://'+ISD_ip+'/type=1num=84val='+IntToStr(i)+'work=1');
  SendCommandToISD('http://'+ISD_ip+'/type=3num=84val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc);
  while ((voltmetrValue<6.1985) or (voltmetrValue>6.2015)) do
  begin
    if (voltmetrValue<6.1985) then
    begin
      inc(i)
    end
    else
    begin
      dec(i);
    end;
    SendCommandToISD('http://'+ISD_ip+'/type=1num=84val='+IntToStr(i)+'work=1');
    sleep(5);
    voltmetrValue:=getVoltmetrValue(m_instr_usbtmc);
  end;
  SendCommandToISD('http://'+ISD_ip+'/type=3num=84val=0');
  Result:=VoltmetrValue;
end;

//===========================================================
//�������� ������� ���
//===========================================================
procedure TestBVK;
var
  i:integer;
begin
  //�������� ����� �������
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //����� � ��������
  timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //����� � ��
  timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  //��������� �������� ��������������� ���������
  prFlag:=True;

  for i:=1 to BVK_NUM_TEST_CH do
  begin
    testedState_pr[i]:=1;
    testedState_G[i]:=1;
  end;
  startBVktime:=0;


  form1.mmoTestResult.lines.add('�������� ������ 1.1.5 �� ����.468363.026 (�������� ������������ �������� ��� ��������� � ������������� ������)');
  form1.mmoTestResult.lines.add('');
  form1.mmoTestResult.lines.add('�������� ���������������� ������ ������ ���');
  form1.tmrTestBVK.Enabled:=True;
end;
//===========================================================

//===========================================================
//
//===========================================================
procedure testZU;
begin
  //�������� ����� �������
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //����� � ��������
  timeZUPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //����� � ��
  timeZUPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;

  form1.tmrTestZU.Enabled:=True;
end;
//===========================================================
//===========================================================
//
//===========================================================
procedure setValOnCh(modZU:Integer);
var
  i:Integer;
begin
  case modZU of
    1:
    begin
      For i:=1 to Length(IsdZUcontNum1) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum1[i])+'val='+intToStr(IsdMKB_ZUchVal[i])+'work=1');
        //Delay_ms(1);
      end;
    end;
    3:
    begin
      For i:=1 to Length(IsdZUcontNum1) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum1[i])+'val='+intToStr(0)+'work=0');
        //Delay_ms(1);
      end;

      For i:=1 to Length(IsdZUcontNum2) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum2[i])+'val='+intToStr(IsdMKB_ZUchVal[i])+'work=1');
        //Delay_ms(1);
      end;
    end;
    5:
    begin
      For i:=1 to Length(IsdZUcontNum2) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum2[i])+'val='+intToStr(0)+'work=0');
        //Delay_ms(1);
      end;

      For i:=1 to Length(IsdZUcontNum3) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum3[i])+'val='+intToStr(IsdMKB_ZUchVal[i])+'work=1');
        //Delay_ms(1);
      end;
    end;
    7:
    begin
      For i:=1 to Length(IsdZUcontNum3) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum3[i])+'val='+intToStr(0)+'work=0');
        //Delay_ms(1);
      end;

      For i:=1 to Length(IsdZUcontNum4) do
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=1num='+
            IntToStr(IsdZUcontNum4[i])+'val='+intToStr(IsdMKB_ZUchVal[i])+'work=1');
        //Delay_ms(1);
      end;
    end;
  end;
end;
//============================================================


//============================================================
//
//============================================================
procedure testSazPr;
var
  i:integer;
  bool:Boolean;
begin
  iTestSazArr:=1;
  //��������� ������� � ��������
  form1.PageControl1.ActivePageIndex:=1;
  chanelIndexFast:=0;
  //��������� ������
  graphFlagFastP := true;
  startWSaz:=False;
  i:=1;
  form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� �� ���');
  form1.mmoTestResult.Lines.Add('');
  Form1.tmrTestSaz.Enabled:=True;

  //���� ���� �� �������� ������ ���
  while ((iTestSazArr<>SAZ_NUM+1)and(not isTestCloseFl)) do
  begin
    Application.ProcessMessages;
  end;


  bool:=True;
  for i:=1 to 22 do
  begin
    if (testSazArr[i]<>testSazArrConst[i]) then
    begin
      bool:=false;
      Break;
    end;

    if (isTestCloseFl) then
    begin
      Break;
    end;
  end;

  if (bool) then
  begin
    Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� �� ���: �����');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� �� ���: !!! �� ����� !!!');
    allTestFlag:=False;
  end;
  form1.mmoTestResult.Lines.Add('');
end;
//=============================================================

//============================================================
//
//============================================================
procedure testMPIU;
var
  testProgramm:integer;
  i:Integer;
  bool:Boolean;

  flagMPIU31:Boolean;
  flagMPIU41:Boolean;
  flagMPIU32:Boolean;

  ret:integer;
begin
  flagMPIU31:=true;
  flagMPIU41:=true;
  flagMPIU32:=true;

  //������� �������� ��������� ������
  testProgramm:=1;
  Form1.mmoTestResult.Lines.Add('�������� ����');
  Form1.mmoTestResult.Lines.Add('');
  //�������� �� ������� �21
  form1.PageControl1.ActivePageIndex:=1;
  if (testProgramm=1) then
  begin
    //1 ��������� ������
    //31
    Form1.mmoTestResult.Lines.Add('�������� ���� 31');
    Form1.mmoTestResult.Lines.Add('');
    //M16�1A20B20C12T21 {A=4 ��=1}, M16�1A20B40T21 {A=4 ��=2}
    adrTestNum:=11;
    //���������� ������
    testNeedsAdrF;
    //�������� ��������� ������� � ������ ���������� �������
    FillAdressParam;

    iTestMPIUArr:=1;
    graphFlagFastP := true; //��� ����� ���� ��������� ���������
    form1.tmrTestMPIU.enabled:=True;

    while ((iTestMPIUArr<>NUM_TESTVALMPIU+1)and( not isTestCloseFl)) do
    begin
      Application.ProcessMessages;
    end;

    graphFlagFastP := false;//���� ����� ���� ��������� ���������


    bool:=True;
    for i:=1 to NUM_TESTVALMPIU do
    begin
      if ((arrTestMPIUParam[i].aAdr<>arrTestMPIUParamConstMPIU31[i].aAdr)or
          (arrTestMPIUParam[i].paAdr<>arrTestMPIUParamConstMPIU31[i].paAdr)) then
      begin
        bool:=false;
        Break;
      end;

      if (not isTestCloseFl) then
      begin
        Break;
      end;
    end;

    if (bool) then
    begin
      Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����31: �����');
    end
    else
    begin
      flagMPIU31:=false;
      Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����31: !!! �� ����� !!!');
      allTestFlag:=False;
    end;
    Form1.mmoTestResult.Lines.Add('');
    testMpiuFlag:=false;

    //������������ 31_X2,31_X3 �� 41_X2,41_X3
    ret :=Application.MessageBox(PAnsiChar('������������ �� �������� ������ 31_X2,31_X3 �� ������ 41_X2,41_X3 � ������� �� ��� ����������� ��������'),PAnsiChar('������������ �������'), MB_OK+MB_ICONWARNING);
    if ret=IDOK then
    begin
        //41
      Form1.mmoTestResult.Lines.Add('�������� ���� 41');
      Form1.mmoTestResult.Lines.Add('');
      //M16�2A50B20T21 {A=7 ��=1}, M16�2A50B30T21 {A=7 ��=2}
      adrTestNum:=12;
      //���������� ������
      testNeedsAdrF;
      //�������� ��������� ������� � ������ ���������� �������
      FillAdressParam;
      
      iTestMPIUArr:=1;
      graphFlagFastP := true; //��� ����� ���� ��������� ���������
      form1.tmrTestMPIU.enabled:=True;
      while ((iTestMPIUArr<>NUM_TESTVALMPIU+1)and( not isTestCloseFl)) do
      begin
        Application.ProcessMessages;
      end;
      graphFlagFastP := false; //��� ����� ���� ��������� ���������

      bool:=True;
      for i:=1 to NUM_TESTVALMPIU do
      begin
        if ((arrTestMPIUParam[i].aAdr<>arrTestMPIUParamConstMPIU41[i].aAdr)or
            (arrTestMPIUParam[i].paAdr<>arrTestMPIUParamConstMPIU41[i].paAdr)) then
        begin
          bool:=false;
          Break;
        end;

        if (isTestCloseFl) then
        begin
          Break;
        end;
      end;

      if (bool) then
      begin
        Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����41: �����');
      end
      else
      begin
        flagMPIU41:=false;
        Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����41: !!! �� ����� !!!');
        allTestFlag:=False;
      end;
      Form1.mmoTestResult.Lines.Add('');
      testMpiuFlag:=false;

      //������������ 41_X2,41_X3 �� 32_X2,32_X3
      ret :=Application.MessageBox(PAnsiChar('������������ �� �������� ������ 41_X2,41_X3 �� ������ 32_X2,32_X3 � ������� �� ��� ����������� ��������'),PAnsiChar('������������ �������'), MB_OK);
      if ret=IDOK then
      begin
        //32
        Form1.mmoTestResult.Lines.Add('�������� ���� 32');
        Form1.mmoTestResult.Lines.Add('');
        //M16�2A50B50T21 {A=5 ��=2}, M16�2A50B60T21 {A=6 ��=0}
        form1.PageControl1.ActivePageIndex:=1;
        adrTestNum:=13;
        //���������� ������
        testNeedsAdrF;
        //�������� ��������� ������� � ������ ���������� �������
        FillAdressParam;
        iTestMPIUArr:=1;
        form1.tmrTestMPIU.enabled:=True;
        graphFlagFastP := true;
        while((iTestMPIUArr<>NUM_TESTVALMPIU+1)and(not isTestCloseFl)) do
        begin
          Application.ProcessMessages;
        end;
        graphFlagFastP :=False;
        bool:=True;
        for i:=1 to NUM_TESTVALMPIU do
        begin
          if ((arrTestMPIUParam[i].aAdr<>arrTestMPIUParamConstMPIU32[i].aAdr)or
              (arrTestMPIUParam[i].paAdr<>arrTestMPIUParamConstMPIU32[i].paAdr)) then
          begin
            bool:=false;
            Break;
          end;

          if (isTestCloseFl) then
          begin
            Break;
          end;
        end;

        //������������ 32_X2,32_X3 �� 31_X2,31_X3
        ret :=Application.MessageBox(PAnsiChar('������������ �� �������� ������ 32_X2,41_X3 �� ������ 31_X2,32_X3 � ������� �� ��� ����������� ��������'),PAnsiChar('������������ �������'), MB_OK);
        
        if (bool) then
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����32: �����');
        end
        else
        begin
          flagMPIU32:=false;
          Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����32: !!! �� ����� !!!');
          allTestFlag:=False;
        end;       
        testMpiuFlag:=false;
        Form1.mmoTestResult.Lines.Add('');
        //��������� ��� �� �������� ���� ��������
        if (flagMPIU31 and flagMPIU41 and flagMPIU32) then
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����: �����');
        end
        else
        begin
          Form1.mmoTestResult.Lines.Add('�������� ������ ������ � ������� ����: !!! �� ����� !!!');
          allTestFlag:=False;
        end;
        Form1.mmoTestResult.Lines.Add('');
        Form1.fastGist.Series[0].Clear;
      end; 
    end;


    {for i:=11  to 13 do  //11-T01,05; 12-T11; 13-T21,22
    begin
      if i=11 then
      begin
        form1.PageControl1.ActivePageIndex:=0;
      end
      else if (i=12) then
      begin
        form1.PageControl1.ActivePageIndex:=2;
      end
      else
      begin
        form1.PageControl1.ActivePageIndex:=1;
      end;
      adrTestNum:=i;
      //���������� ������
      testNeedsAdrF;
      //�������� ��������� ������� � ������ ���������� �������
      FillAdressParam;
      form1.startTestMPIU.enabled:=True;

      while(form1.startTestMPIU.enabled) do
      begin
        Application.ProcessMessages;
      end;
    end;}





    {for i:=14  to 16 do  //14-T01,05; 15-T11; 16-T21,22
    begin
      if i=14 then
      begin
        form1.PageControl1.ActivePageIndex:=0;
      end
      else if (i=15) then
      begin
        form1.PageControl1.ActivePageIndex:=2;
      end
      else
      begin
        form1.PageControl1.ActivePageIndex:=1;
      end;
      adrTestNum:=i;
      testNeedsAdrF;
      //�������� ��������� ������� � ������ ���������� �������
      FillAdressParam;
      form1.startTestMPIU.enabled:=True;

      while(form1.startTestMPIU.enabled) do
      begin
        Application.ProcessMessages;
      end;
    end;}





    {adrTestNum:=17;
    //���������� ������ T21,T22
    testNeedsAdrF;
    //�������� ��������� ������� � ������ ���������� �������
    FillAdressParam;
    form1.startTestMPIU.enabled:=True;

    while(form1.startTestMPIU.enabled) do
    begin
      Application.ProcessMessages;
    end;}
  end;
  {else
  begin
     //2 ��������� ������
    //31
    Form1.mmoTestResult.Lines.Add('�������� ���� 31');
    for i:=18  to 20 do
    begin
      if i=18 then
      begin
        form1.PageControl1.ActivePageIndex:=0;
      end
      else if (i=19) then
      begin
        form1.PageControl1.ActivePageIndex:=2;
      end
      else
      begin
        form1.PageControl1.ActivePageIndex:=1;
      end;

      adrTestNum:=i;
      testNeedsAdrF;
      //�������� ��������� ������� � ������ ���������� �������
      FillAdressParam;
      form1.startTestMPIU.enabled:=True;

      while(form1.startTestMPIU.enabled) do
      begin
        Application.ProcessMessages;
      end;
    end;

    //41
    Form1.mmoTestResult.Lines.Add('�������� ���� 41');
    for i:=21  to 23 do
    begin
      if i=21 then
      begin
        form1.PageControl1.ActivePageIndex:=0;
      end
      else if (i=22) then
      begin
        form1.PageControl1.ActivePageIndex:=2;
      end
      else
      begin
        form1.PageControl1.ActivePageIndex:=1;
      end;
      adrTestNum:=i;
      //���������� ������ T11
      testNeedsAdrF;
      //�������� ��������� ������� � ������ ���������� �������
      FillAdressParam;
      form1.startTestMPIU.enabled:=True;

      while(form1.startTestMPIU.enabled) do
      begin
        Application.ProcessMessages;
      end;
    end;

    //32
    Form1.mmoTestResult.Lines.Add('�������� ���� 32');
    form1.PageControl1.ActivePageIndex:=1;
    adrTestNum:=24;
    //���������� ������ T21,T22
    testNeedsAdrF;
    //�������� ��������� ������� � ������ ���������� �������
    FillAdressParam;
    form1.startTestMPIU.enabled:=True;

    while(form1.startTestMPIU.enabled) do
    begin
      Application.ProcessMessages;
    end;
  end;}
end;
//=============================================================



//============================================================
//
//============================================================
procedure TestMKT3;
begin  
  //�������� ���3
  form1.PageControl1.ActivePageIndex:=2;
  //��������� ����� ��� ���� �������� ����������
  startTestBlock:=true;
  //������������� ����� ������� ��� �������� ���3
  adrTestNum:=2;
  //���������� ������ ���3
  testNeedsAdrF;
  //�������� ��������� ������� � ������ ���������� �������
  FillAdressParam;

  Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116'+
    '(��������������� �������������� ��� ������� ���(������ ���3)).');
  Form1.mmoTestResult.Lines.Add('');
  Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116'+
    '(�������� �������� �� ����� ������� ������ ������������� ��������).');

  //���� ���� �������� ����������
  while ((not startTest_1_1_10_2) and( not isTestCloseFl)) do
  begin
    Application.ProcessMessages;
  end;

  //�������� ���������� �� ������������
  if (testColibr) then
  begin
    Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� �������� ����������): �����.');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('�������� ������ 1.1.10.2 �� ����.468157.116 (�������� �������� ����������): !!! �� ����� !!!');
    allTestFlag:=False;
  end;
  Form1.mmoTestResult.Lines.Add('');
  startTest_1_1_10_2:=False;

  //���� ���� �������� ���������� �����
  while ((not startTest_1_1_10_2)and( not isTestCloseFl)) do
  begin
    Application.ProcessMessages;
  end;

  //������ �������� ������������ ��������� ���3
  Form1.tmr1_1_10_2.Enabled:=true;

  //���� ���� �������� ��������
  while ((Form1.tmr1_1_10_2.Enabled)and( not isTestCloseFl)) do
  begin
    Application.ProcessMessages;
  end;

  //���� ���� �������� ���������� �����
  while ((not startTest_1_1_10_2) and (not isTestCloseFl)) do
  begin
    Application.ProcessMessages;
  end;




  //������ �������� ����������� ��������� ������������� ���3
  Form1.tmrRCo.Enabled:=True;

  //���� ���� �������� �������� �����������
  while ((Form1.tmrRCo.Enabled)and(not isTestCloseFl)) do
  begin
    Application.ProcessMessages;
  end;

  //���������� �������� ���3  
end;
//============================================================



//===========================================================
//�������� ������� ���2
//===========================================================
procedure TestMKB2;
var
  chNum:Integer;
  i:Integer;
  k:Integer;
  voltmetrValue:double;
  parazit:double;
  amplsr:Double;
  rky:Double;

  N:array[1..12] of real;

  freqNum:Integer;
  rezFlagTestF:boolean;

begin
  rezFlag:=True;
  setConf(m_instr_usbtmc_1[0],'CONF:VOLT:AC 10');
  generatorOutOn(m_instr_usbtmc_2[1]);

  //=== ���������� ������� ���, ���������, ��������� ��� ������� ��������� 1 ������
  sendCommandToISD('http://'+ISDip_2+'/type=1num=33val=820work=0');
  sendCommandToISD('http://'+ISDip_2+'/type=3num=33val=1');
  sendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1');
  sendCommandToISD('http://'+ISDip_2+'/type=2num=31val=1');
  //setcoefU(1,chNum);
  sendCommandToISD('http://'+ISDip_2+'/type=2num=53val=1');
  setFrequencyOnGenerator(20,6,m_instr_usbtmc_2[1]);
  sleep(1000);
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  sleep(1000);

  //===
  form1.mmoTestResult.lines.add('�������� ������ 1.2.1 �� ����.468363.026 (�������� ��������������� ������������� ������������ ����������)');
  form1.mmoTestResult.lines.add('');
  for chNum:=1 to 4 do  //1
  begin
    if (isTestCloseFl) then
    begin
      Break;
    end;

    //Form1.mmoTestResult.Lines.Add('');
    form1.mmoTestResult.lines.add('�������� �������� '+IntToStr(chNum)+' ������');
    case chNum of
      1:
      begin
        sendCommandToISD('http://'+ISDip_2+'/type=1num=33val=820work=0');
        sendCommandToISD('http://'+ISDip_2+'/type=3num=33val=1');
        sendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1');
        sendCommandToISD('http://'+ISDip_2+'/type=2num=31val=1');
        //setcoefU(1,chNum);
        sendCommandToISD('http://'+ISDip_2+'/type=2num=53val=1');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=53val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=31val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=1num=34val=820work=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=34val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=38val=1');
        //SetcoefU(1,chNum);
        SendCommandToISD('http://'+ISDip_2+'/type=2num=54val=1');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=3num=34val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=54val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=38val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=1num=35val=820work=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=35val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=45val=1');
        //SetcoefU(1,chNum);
        SendCommandToISD('http://'+ISDip_2+'/type=2num=55val=1');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=3num=35val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=55val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=45val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=1num=36val=820work=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=64val=1');
        //SetcoefU(1,chNum);
        SendCommandToISD('http://'+ISDip_2+'/type=2num=56val=1');
      end;
    end;

    //��� ������� ������ ��������� ��� �� ���� ��� ��������
    For i:=1 to 1 do   // 8 ��������� ��� ���� �������� . 1 ��������� �� ���� ������� ������ 1 ���� ��������
    begin
      case i of
        1:
        begin
          k:=1;
          setFrequencyOnGenerator(20,6,m_instr_usbtmc_2[1]);
        end;
        2:
        begin
          k:=2;
          SetFrequencyOnGenerator(20,3,m_instr_usbtmc_2[1]);
        end;
        3:
        begin
          k:=4;
          SetFrequencyOnGenerator(20,1.5,m_instr_usbtmc_2[1]);
        end;
        4:
        begin
          k:=8;
          SetFrequencyOnGenerator(20,0.75,m_instr_usbtmc_2[1]);
        end;
        5:
        begin
          k:=16;
          SetFrequencyOnGenerator(20,0.375,m_instr_usbtmc_2[1]);
        end;
        6:
        begin
          k:=32;
          SetFrequencyOnGenerator(20,0.1875,m_instr_usbtmc_2[1]);
        end;
        7:
        begin
          k:=64;
          SetFrequencyOnGenerator(20,0.0937,m_instr_usbtmc_2[1]);
        end;
        8:
        begin
          k:=128;
          SetFrequencyOnGenerator(20,0.0468,m_instr_usbtmc_2[1]);
        end;
      end;

      if (isTestCloseFl) then
      begin
        Break;
      end;


      //
      setcoefU(k,chNum);

      sleep(1000);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      sleep(1000);
      rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
      //rky:=(VoltmetrValue)/(4/(k*sqrt(2)));
      if (rky>0.95)and(rky<1.05) then
      begin
        Form1.mmoTestResult.Lines.Add('�������� �������� �'+intTostr(k)+' �����: '+FloatToStrF(rky*k,fffixed,5,2))
      end
      else
      begin
        voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
        sleep(1000);
        rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
        if (rky>0.95)and(rky<1.05) then
        begin
          Form1.mmoTestResult.Lines.Add('�������� �������� �'+intTostr(k)+' �����: '+FloatToStrF(rky*k,fffixed,5,2))
        end
        else
        begin
          VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
          sleep(1000);
          rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
          if (rky>0.95)and(rky<1.05) then
          begin
            Form1.mmoTestResult.Lines.Add('�������� �������� �'+intTostr(k)+' �����: '+FloatToStrF(rky*k,fffixed,5,2))
          end
          else
          begin
            VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
            sleep(1000);
            rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
            if (rky>0.95)and(rky<1.05) then
            begin
              Form1.mmoTestResult.Lines.Add('�������� �������� �'+intTostr(k)+'  �����: '+FloatToStrF(rky*k,fffixed,5,2))
            end
            else
            begin
              Form1.mmoTestResult.Lines.Add('�������� �������� �'+intTostr(k)+' !!! �� ����� !!! '+FloatToStrF(rky*k,fffixed,5,2));
              //DeviceTestRezultFlag:=false;
              //RezultFlag3:=false;
              //RezultFlag1:=false;
              rezFlag:=False;
            end;
          end;
        end;
      end;
    //
    end;
  end;

  SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=56val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=64val=0');
  SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:AC 10');

  Form1.mmoTestResult.Lines.Add('');
  if (rezFlag) then
  begin
    Form1.mmoTestResult.lines.add('�������� ������ 1.2.1 �� ����.468363.026 (�������� ��������������� ������������� ������������ ����������): �����');
  end
  else
  begin
    Form1.mmoTestResult.lines.add('�������� ������ 1.2.1 �� ����.468363.026 (�������� ��������������� ������������� ������������ ����������): !!! HE ����� !!!');
  end; 
  Form1.mmoTestResult.Lines.Add('');
  //------------



  rezFlag:=True;
  rezFlagTestF:=true;
  form1.mmoTestResult.Lines.Add('���������� ���');
  //���������� ��� 4 ������
  for chNum:=1 to 4 do
  begin
    form1.mmoTestResult.Lines.Add('�������� '+intTostr(chNum)+'������');
    SetcoefU(1,chNum);
    case chNum  of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1'); // ����� �����
        SendCommandToISD('http://'+ISDip_2+'/type=2num=53val=1'); // ����� �� �� ����������
        SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=1'); // ����� ��� 1
        //SendCommandToISD('http://'+ISDip_2+'/type=2num=31val=1');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=0');

        SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:AC 1');
      end;
      2:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=53val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=54val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=34val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=38val=1');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=0');
      end;
      3:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=54val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=34val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=55val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=35val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=45val=1');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=0');
      end;
      4:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=55val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=35val=0');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=56val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=64val=1');

        SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=0');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=0');
      end;
    end;

    if (isTestCloseFl) then
    begin
      Break;
    end;

    //���������� ��������� ��������� ��� ������� ������
    for freqNum:=6 to 6 do    // 1-8 ���. �� ��������� ������ 2048 6-6
    begin
      if (isTestCloseFl) then
      begin
        Break;
      end;

      rezFlag:=true;

      SetFrequencyOnGenerator(200000,6,m_instr_usbtmc_2[1]);   //!!
      Delay_ms(10);
      //wait(500);
      voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
      Delay_ms(10);
      //wait(500);
      voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
      Delay_ms(10);
      //wait(500);
      parazit:=voltmetrValue;
      SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:AC 10');



      case freqNum of
        1:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 63 ��, ������ 0.5 ��');
          case chNum  of
            1:
            begin
              SetFrequencyOnGenerator(200000,6,m_instr_usbtmc_2[1]);   //!!
              Delay_ms(10);
              //wait(500);
              voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
              Delay_ms(10);
              //wait(500);
              voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
              Delay_ms(10);
              //wait(500);
              parazit:=voltmetrValue;
              SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:AC 10');
            end;
            2:
            begin
              Delay_ms(10);
              //wait(500);
              VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
              Delay_ms(10);
              //wait(500);
              parazit:=VoltmetrValue;
            end;
            3:
            begin
              Delay_ms(10);
              //wait(500);
              voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
              Delay_ms(10);
              //wait(500);
              parazit:=voltmetrValue;
            end;
            4:
            begin
              Delay_ms(10);
              //wait(500);
              VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
              Delay_ms(10);
              //wait(500);
              parazit:=VoltmetrValue;
            end;
          end;

        end;
        2:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 125 ��, ������ 0.5 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=0');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=0');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=0');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=0');
            end;
          end;
        end;
        3:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 250 ��, ������ 0.5 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=0');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=0');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=0');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=0');
            end;
          end;
        end;
        4:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 500 ��, ������ 20 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=31val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=0');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=38val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=0');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=45val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=0');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=64val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=0');
            end;
          end;
        end;
        5:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 1024 ��, ������ 20 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=1');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=1');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=1');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=1');
            end;
          end;
        end;
        6:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 2048 ��, ������ 20 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=1');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=1');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=1');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=1');
            end;
          end;
        end;
        7:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 4096 ��, ������ 20 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=1');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=1');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=1');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=0');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=1');
            end;
          end;
        end;
        8:
        begin
          form1.mmoTestResult.Lines.Add('������� ������ ����������� 8192 ��, ������ 20 ��');
          case chNum  of
            1:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=28val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=29val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=30val=1');
            end;
            2:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=35val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=37val=1');
            end;
            3:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=42val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=43val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=44val=1');
            end;
            4:
            begin
              SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=1');
              SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=1');
            end;
          end;
        end;
      end;

      if (isTestCloseFl) then
      begin
        Break;
      end;

      //
      for i:=1 to 12 do
      begin
        if (isTestCloseFl) then
        begin
          Break;
        end;
        SetFrequencyOnGenerator(Values[freqNum,i],6,m_instr_usbtmc_2[1]);
        //wait(500);
        Delay_ms(10);
        VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
        Delay_ms(10);
        //wait(500);
        N[i]:=VoltmetrValue-parazit;
        if N[i]<0 then
        begin
          N[i]:=0.001;
        end;
        Form1.lnsrsSeries9.AddXY(Values[freqNum,i],N[i]);

        if (isTestCloseFl) then
        begin
          Break;
        end;
      end;

      for i:=1 to 3 do
      begin
        if (isTestCloseFl) then
        begin
          Break;
        end;
        form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,i])+
        ' ��; ���������: '+FloatToStrF(N[i],fffixed,5,4));
      end;

      if ((freqNum=1)or(freqNum=6)or(freqNum=7)or(freqNum=8))then
      begin
        amplsr:=(N[4]+N[5]+N[6]+N[7])/4;
      end
      else
      begin
        amplsr:=(N[5]+N[6]+N[7])/3;
      end;

      for i:=4 to 7 do
      begin
        if (isTestCloseFl) then
        begin
          Break;
        end;

        if (N[i]<(amplsr*0.94))or(N[i]>(amplsr*1.06)) then
        begin
         rezFlag:=false;
          form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,i])+
            ' ��; ���������: '+FloatToStrF(N[i],fffixed,5,4)+
            ' �����������: '+FloattostrF(abs(((N[i]-amplsr)*100)/amplsr),fffixed,3,2)+
            '%  !!! �� ����� !!!');
        end
        else
        begin
          form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,i])+
            ' ��; ���������: '+FloatToStrF(N[i],fffixed,5,4)+
            ' �����������: '+FloattostrF(abs(((N[i]-amplsr)*100)/amplsr),fffixed,3,2)+
            '% �����');
        end;
        Form1.lnsrsSeries10.AddXY(Values[freqNum,i],(amplsr*1.06));
        Form1.lnsrsSeries11.AddXY(Values[freqNum,i],(amplsr*0.94));

        if (isTestCloseFl) then
        begin
          Break;
        end;
      end;

      form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,8])+
        ' ��; ���������: '+FloatToStrF(N[8],fffixed,5,4));

      if (N[8]<(amplsr*0.7))or(N[10]>(amplsr*0.7)) then
      begin
        rezFlag:=false;
        form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,9])+
          ' ��; ���������: '+FloatToStrF(N[9],fffixed,5,4)+' !!! �� ����� !!!');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,9])+
          ' ��; ���������: '+FloatToStrF(N[9],fffixed,5,4)+' �����');
      end;

      for i:=10 to 12 do
      begin
        if (isTestCloseFl) then
        begin
          Break;
        end;
        form1.mmoTestResult.Lines.Add('�������: '+Floattostr(Values[freqNum,i])+
          ' ��; ���������: '+FloatToStrF(N[i],fffixed,5,4));
      end;

      if (not rezFlag) then
      begin
        form1.mmoTestResult.Lines.Add('!!! �� ����� !!!');
        rezFlagTestF:=false;
        //DeviceTestRezultFlag:=false;
        //RezultFlag3:=false;
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('�����');
      end;

      form1.mmoTestResult.Lines.Add('');
      Delay_ms(10);
      //wait(500);
      Form1.lnsrsSeries9.Clear;
      Form1.lnsrsSeries10.Clear;
      Form1.lnsrsSeries11.Clear;
      //
    end;
  end;

  Form1.achxG.Series[0].Clear;
  Form1.achxG.Series[1].Clear;
  Form1.achxG.Series[2].Clear;
  Application.ProcessMessages;

  if (not rezFlagTestF) then
  begin
    form1.mmoTestResult.Lines.Add('�������� ������� ������ ����������� � ��������������� ��������� ��������������:  !!! �� ����� !!!');
    allTestFlag:=False;
    //DeviceTestRezultFlag:=false;
    //RezultFlag3:=false;
  end
  else
  begin
    form1.mmoTestResult.Lines.Add('�������� ������� ������ ����������� � ��������������� ��������� ��������������:  �����');
  end;

  form1.PageControl1.ActivePageIndex:=1;


  SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC 10');
  //form1.mmoTestResult.Lines.Add('');
  //form1.mmoTestResult.Lines.Add('������������� �������� ���������� ���������� 6,2�: '+FloatToStrF(setCalibrVoltage(ISDip_2,m_instr_usbtmc_1[0]),ffFixed,6,4));       //������������� �� ��� ���������� ���������� 6,2�
  //SetGNDVoltage(ISDip_2,m_instr_usbtmc_1[0]);
  form1.mmoTestResult.Lines.Add('');
  //����������� ������������ ����� ������ ���
  SendCommandToISD('http://'+ISDip_2+'/type=2num=31val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=38val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=45val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=56val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=36val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=64val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=61val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=62val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=2num=63val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=0');


  //
  setFrequencyOnGenerator(100000,5,m_instr_usbtmc_2[1]);
  SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC');

  rezFlag:=true;
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('�������� ������ 1.1.3 �� ����.468363.026 (�������� ������������� ���������� ������������ ����������)');
  form1.mmoTestResult.Lines.Add('');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=51val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=10.8) and (voltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('1 ����� (������� 23): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('1 ����� (������� 23): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=51val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=52val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('1 ����� (������� 24): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('1 ����� (������� 24): ���������� = '+
      FloatToStrF(VoltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=52val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=53val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);

//  if (isTestCloseFl) then
//  begin
//    Break;
//  end;

  if ((VoltmetrValue>=10.8) and (VoltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('2 ����� (������� 29): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('2 ����� (������� 29): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;

//  if (isTestCloseFl) then
//  begin
//    Break;
//  end;

  SendCommandToISD('http://'+ISDip_2+'/type=3num=53val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=54val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('2 ����� (������� 30): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('2 ����� (������� 30): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=54val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=55val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);

//  if (isTestCloseFl) then
//  begin
//    Break;
//  end;

  if ((voltmetrValue>=10.8) and (voltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('3 ����� (������� 32): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('3 ����� (������� 32): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=55val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=56val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('3 ����� (������� 33): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('3 ����� (������� 33): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=56val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=57val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);

//  if (isTestCloseFl) then
//  begin
//    Break;
//  end;

  if ((voltmetrValue>=10.8) and (voltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('4 ����� (������� 39): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('4 ����� (������� 39): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=57val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=58val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('4 ����� (������� 40): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  �����')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('4 ����� (������� 40): ���������� = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'�  !!! �� ����� !!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=58val=0');

  form1.mmoTestResult.Lines.Add('');

  if (rezFlag) then
  begin
    form1.mmoTestResult.Lines.Add('�������� ������ 1.1.3 �� ����.468363.026 (�������� ������������� ���������� ������������ ����������) : �����');
  end
  else
  begin
    form1.mmoTestResult.Lines.Add('�������� ������ 1.1.3 �� ����.468363.026 (�������� ������������� ���������� ������������ ����������) : !!! �� ����� !!!');
    allTestFlag:=False;
    //DeviceTestRezultFlag:=false;
    {ret := Application.MessageBox(PAnsiChar('������������ ������� ���2 ������ 1.1.3 �� ����.468363.026 (�������� ������������� ���������� ������������ ����������) !!! �� ����� !!!'),PAnsiChar('���������� ��������'),MB_ABORTRETRYIGNORE + MB_ICONQUESTION);
    if ret=IDABORT then
    Begin
      str5:='����������_��������_�������_���2_'+DateToStr(Date)+'_'+TimeToStr(Time)+'.txt';
      for i:=1 to length(str5) do
      begin
        if (str5[i]=':') then str5[i]:='.';
      end;
      Memo1.Lines.SaveToFile(str5);
      WinExec(PAnsiChar('notepad.exe '+str5),SW_SHOW);
      exit;
    end
    else
    begin
      if ret=IDRETRY then
      begin
        TestRezultFlag:=true;
        GOTO M4;
      end;
    end;}
  end;
  //�������� ���������� ���������� �� �������  ���2
  if (not isTestCloseFl) then
  begin
    testVpMKB2;
  end;



  //������ ����� ������ � �������
  //Form1.startReadACP.Click;  //!!!

  if Form1.startReadACP.Caption='�����' then
  begin
    //������ ����� ������ � �������
    Form1.startReadACP.Click;  //!!!
  end;



  Delay_S(5);

  TimerMode:=1;
  NumberChannel:=1;
  rezFlag:=true;                                                                                                   //��������� �������� ������ ������ ��
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('�������� ������� 1.2.2 � 1.1.1 �� ����.468363.026'+
    '(�������� ��������������� ������������� ���������� � �������� ������� ��������))');
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('�������� ������� ����� ��� ���������� 0�');


  //�������� 0� �� ���� ����������� �������
  for i:=1 to 20 do
  begin
    if (isTestCloseFl) then
    begin
      Break;
    end;

    SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(IsdMKBcontNum[i])+'val=0work=0');
    //form1.mmoTestResult.Lines.Add(IntToStr(IsdMKBcontNum[i])+'++');
    //Delay_S(1);  ///!!!
  end;//!!!

  if (not isTestCloseFl) then
  begin
    Delay_S(1);

    form1.PageControl1.ActivePageIndex:=1;

    //TimerMode:=6;//!!!

    Form1.tmrMKB_Dpart.Enabled:=true;
  end;

end;
//============================================================

//�������� ����� N1-1
//����� 1.1.10.2
//function Test_1_1_10_2():Boolean;
//begin
//  testResult:=true;
//  //��������� ������ ��������
//  //�������� � ������ ��
//  //��������� 1 ��������
//  SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=1');
//  //��������� ������������ �� ����������
//  while (not startTest_1_1_10_2) do
//  begin
//    if (startTest_1_1_10_2) then
//    begin
//      Break;
//    end
//    else
//    begin
//      Application.ProcessMessages;
//    end;
//  end;
//
//  testCount:=0;
//  form1.tmr1_1_10_2.Enabled;

//  changeResistance(0.0);
//  //��������� 31 �����
//  testResult:=testChannals(minScale4);
//  changeResistance(9.0);
//  testResult:=testChannals(maxScale4-round((maxScale4-minScale4)/10));
//  changeResistance(10.0);
//  testResult:=testChannals(minScale3);
//  changeResistance(19.0);
//  testResult:=testChannals(maxScale3-round((maxScale3-minScale3)/10));
//  changeResistance(20.0);
//  testResult:=testChannals(minScale2);
//  changeResistance(39.0);
//  testResult:=testChannals(maxScale2-round((maxScale2-minScale2)/20));
//  changeResistance(40.0);
//  testResult:=testChannals(minScale1);
//  changeResistance(79.0);
//  testResult:=testChannals(maxScale1-round((maxScale1-minScale1)/40));

  //�������� � ������ ��

  //��������� ������ ��������
  //�������� � ������ ��
  //��������� 2 ��������
  {SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=0');
  changeResistance(0.0);
  testResult:=testChannals(minScale4);
  changeResistance(49.0);
  testResult:=testChannals(maxScale4-round((maxScale4-minScale4)/50));
  changeResistance(50.0);
  testResult:=testChannals(minScale3);
  changeResistance(99.0);
  testResult:=testChannals(maxScale3-round((maxScale3-minScale3)/50));
  changeResistance(100.0);
  testResult:=testChannals(minScale2);
  changeResistance(199.0);
  testResult:=testChannals(maxScale2-round((maxScale2-minScale2)/100));
  changeResistance(200.0);
  testResult:=testChannals(minScale1);
  changeResistance(399.0);
  testResult:=testChannals(maxScale1-round((maxScale1-minScale1)/200));}




  //�������� � ������ ��

  //changeResistance(2.0);
  //changeResistance(10.0);

  //���������� ����� ���������
 // diap:=1;





  //Result:=testResult;
//end;



end.
