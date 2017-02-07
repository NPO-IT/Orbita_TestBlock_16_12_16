unit TestUnit_N1_1;

interface
uses
  Dialogs,CommInt,SysUtils,IdSocketHandle,Visa_h,Messages,Forms,IniFiles,ComObj,LibUnit;
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


  //количество проверяемых каналов на СЗУ
  ZU_NUM_TEST_CH=16;
  //количество проверяемых каналов на БВК
  BVK_NUM_TEST_CH=12;
  //максимальное количество срабатываний для каждого канала
  BVK_NUM_SETS=3;



type
  TBVKCHTestElem = record
    //массив срабатываний канала, максимально задано 3
    setTime:array[1..BVK_NUM_SETS] of Cardinal;
    //массив длительности урония после срабатывания канала
    durabilityT:array[1..BVK_NUM_SETS] of Cardinal;
  end;



var
  IniPeriphery: TIniFile;
  comm1:TComm;
  IP_POWER_SUPPLY_1,HostISD,RigolDg1022,V7_78,Transmille:string;
  ISDip_1,ISDip_2:string;
  //вольтметр 1
  AkipV7_78_1:string;
  //вольтметр 2
  //AkipV7_78_2:string;
  //генератор
  RigolDg1022_1:string;
  //магазин сопротивлений
  COMnum :string;
  //флаг подключенности АКИП
  AkipOffOnState:Boolean;
  //название СOM порта
  ComPortTransmille:string;
  // Флаг устанавливается когда пришел ответ от источника питания
  PowerRequest: Boolean;

  iResist:Integer=1;
  nResist:Integer=1;
  dResist:Integer=7;




  testStringsMKT3:array[1..32] of string{TStringList}=
  ('M16П1A20B60C50D12E10X11T11','M16П1A20B60C50D12E20X11T11','M16П1A20B60C50D12E30X11T11',
  'M16П1A20B60C50D12E40X11T11','M16П1A20B60C50D12E50X11T11','M16П1A20B60C50D12E60X11T11',
  'M16П1A20B60C50D12E70X11T11','M16П1A20B60C50D12E80X11T11','M16П1A20B60C50D12E10X21T11',
  'M16П1A20B60C50D12E20X21T11','M16П1A20B60C50D12E30X21T11','M16П1A20B60C50D12E40X21T11',
  'M16П1A20B60C50D12E50X21T11','M16П1A20B60C50D12E60X21T11','M16П1A20B60C50D12E70X21T11',
  'M16П1A20B60C50D12E80X21T11','M16П1A20B60C50D12E10X31T11','M16П1A20B60C50D12E20X31T11',
  'M16П1A20B60C50D12E30X31T11','M16П1A20B60C50D12E40X31T11','M16П1A20B60C50D12E50X31T11',
  'M16П1A20B60C50D12E60X31T11','M16П1A20B60C50D12E70X31T11','M16П1A20B60C50D12E80X31T11',
  'M16П1A20B60C50D12E10X41T11','M16П1A20B60C50D12E20X41T11','M16П1A20B60C50D12E30X41T11',
  'M16П1A20B60C50D12E40X41T11','M16П1A20B60C50D12E50X41T11','M16П1A20B60C50D12E60X41T11',
  'M16П1A20B60C50D12E70X41T11','M16П1A20B60C50D12E80X41T11');

  testStringsMKB2:array[1..20] of string{TStringList}=
  ('M16П1A70B11T22P01','M16П1A70B11T22P02','M16П1A70B21T22P01','M16П1A70B21T22P02',
   'M16П1A70B31T22P01','M16П1A70B31T22P02','M16П1A70B41T22P01','M16П1A70B41T22P02',
   'M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21',
   'M16П1A20B60C22D41T21','M16П1A20B80C11T21','M16П1A20B80C21T21',
   'M16П1A20B80C31T21','M16П1A20B80C41T21','M16П1A20B60C31D11T21',
   'M16П1A20B60C31D21T21','M16П1A20B60C31D31T21','M16П1A20B60C31D41T21'
  );

  {testStringsBVK:array[1..20] of string=
  ('M16П1A70B11T22P01','M16П1A70B11T22P02','M16П1A70B21T22P01','M16П1A70B21T22P02',
   'M16П1A70B31T22P01','M16П1A70B31T22P02','M16П1A70B41T22P01','M16П1A70B41T22P02',
   'M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21',
   'M16П1A20B60C22D41T21','M16П1A20B80C11T21','M16П1A20B80C21T21',
   'M16П1A20B80C31T21','M16П1A20B80C41T21','M16П1A20B60C31D11T21',
   'M16П1A20B60C31D21T21','M16П1A20B60C31D31T21','M16П1A20B60C31D41T21'
  );}

   testStringsBVK:array[1..BVK_NUM_TEST_CH] of string=    //12
  ('M16П1A70B11T22P01','M16П1A70B11T22P02','M16П1A70B21T22P01','M16П1A70B21T22P02',
   'M16П1A70B31T22P01','M16П1A70B31T22P02','M16П1A70B41T22P01','M16П1A70B41T22P02',
   'M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21','M16П1A20B60C22D41T21'
  );

  //П1А20-->П1A30
   {testStringsZU1:array[1..36] of string=
  ('M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21','M16П1A20B60C22D41T21',
   'M16П1A20B80C11T21','M16П1A20B80C21T21','M16П1A20B80C31T21','M16П1A20B80C41T21',
   'M16П1A20B60C31D11T21','M16П1A20B60C31D21T21','M16П1A20B60C31D31T21','M16П1A20B60C31D41T21',
   'M16П1A20B12T22','M16П1A20B20C12T21','M16П1A20B40T21','M16П1A20B20C22T01',
   'M16П1A20B60C10D12T11','M16П1A20B60C10D22T11',
   'M16П1A30B60C22D11T21','M16П1A30B60C22D21T21','M16П1A30B60C22D31T21','M16П1A30B60C22D41T21',
   'M16П1A30B80C11T21','M16П1A30B80C21T21','M16П1A30B80C31T21','M16П1A30B80C41T21',
   'M16П1A30B60C31D11T21','M16П1A30B60C31D21T21','M16П1A30B60C31D31T21','M16П1A30B60C31D41T21',
   'M16П1A30B12T22','M16П1A30B20C12T21','M16П1A30B40T21','M16П1A30B20C22T01',
   'M16П1A30B60C10D12T11','M16П1A30B60C10D22T11'
  );}

   testStringsZU1_1:array[1..30] of string=
  ('M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21','M16П1A20B60C22D41T21',
   'M16П1A20B80C11T21','M16П1A20B80C21T21','M16П1A20B80C31T21','M16П1A20B80C41T21',
   'M16П1A20B60C31D11T21','M16П1A20B60C31D21T21','M16П1A20B60C31D31T21','M16П1A20B60C31D41T21',
   'M16П1A20B12T22','M16П1A20B20C12T21','M16П1A20B40T21',
   'M16П1A30B60C22D11T21','M16П1A30B60C22D21T21','M16П1A30B60C22D31T21','M16П1A30B60C22D41T21',
   'M16П1A30B80C11T21','M16П1A30B80C21T21','M16П1A30B80C31T21','M16П1A30B80C41T21',
   'M16П1A30B60C31D11T21','M16П1A30B60C31D21T21','M16П1A30B60C31D31T21','M16П1A30B60C31D41T21',
   'M16П1A30B12T22','M16П1A30B20C12T21','M16П1A30B40T21'
  );

   testStringsZU1_2:array[1..4] of string=
  (  'M16П1A20B60C10D12T11','M16П1A20B60C10D22T11','M16П1A30B60C10D12T11','M16П1A30B60C10D22T11'
  );


  //П1А10-->П2A10
  testStringsZU2:array[1..8] of string=
  (
    'M16П1A10B11T01','M16П1A10B60T01','M16П1A10B20T01','M16П1A10B70T01',
    'M16П2A10B11T01','M16П2A10B60T01','M16П2A10B20T01','M16П2A10B70T01'
  );

  //П1А40-->П1A50
  {testStringsZU3:array[1..24] of string=
  (
    'M16П1A40B40T01','M16П1A40B20С22T01','M16П1A40B11T01',
    'M16П1A40B30C40D12T11','M16П1A40B30C40D22T11','M16П1A40B30C80D12T11','M16П1A40B30C80D22T11',
    'M16П1A40B30С11T05','M16П1A40B30С30В12T05','M16П1A40B30C21T05','M16П1A40B30C30D22T05',
    'M16П1A40B20С11T21',
    'M16П1A50B40T01','M16П1A50B20С22T01','M16П1A50B11T01',
    'M16П1A50B30C40D12T11','M16П1A50B30C40D22T11','M16П1A50B30C80D12T11','M16П1A50B30C80D22T11',
    'M16П1A50B30С11T05','M16П1A50B30С30В12T05','M16П1A50B30C21T05','M16П1A50B30C30D22T05',
    'M16П1A50B20С11T21'
  );}

  {testStringsZU3_1:array[1..14] of string=
  (
    'M16П1A40B40T01','M16П1A40B20С22T01','M16П1A40B11T01',
    'M16П1A40B30С11T05','M16П1A40B30С30В12T05','M16П1A40B30C21T05','M16П1A40B30C30D22T05',
    'M16П1A50B40T01','M16П1A50B20С22T01','M16П1A50B11T01',
    'M16П1A50B30С11T05','M16П1A50B30С30В12T05','M16П1A50B30C21T05','M16П1A50B30C30D22T05'
  );}

  {testStringsZU3_1:array[1..6] of string=
  (
    'M16П1A40B40T01','M16П1A40B20С22T01','M16П1A40B11T01',
    'M16П1A50B40T01','M16П1A50B20С22T01','M16П1A50B11T01'
  );}

  testStringsZU3_1:array[1..6] of string=
  (
    'M16П1A40B40T01','M16П1A40B20С22T01','M16П1A40B11T01',
    'M16П1A50B40T01','M16П1A50B20С22T01','M16П1A50B11T01'
  );

  testStringsZU3_2:array[1..8] of string=
  (
    'M16П1A40B30С11T05','M16П1A40B30С30D12T05','M16П1A40B30C21T05','M16П1A40B30C30D22T05',
    'M16П1A50B30С11T05','M16П1A50B30С30D12T05','M16П1A50B30C21T05','M16П1A50B30C30D22T05'
  );



  testStringsZU3_3:array[1..8] of string=
  (
    'M16П1A40B30C40D12T11','M16П1A40B30C40D22T11','M16П1A40B30C80D12T11','M16П1A40B30C80D22T11',
    'M16П1A50B30C40D12T11','M16П1A50B30C40D22T11','M16П1A50B30C80D12T11','M16П1A50B30C80D22T11'
  );

  //П2А50-->П1A60
  testStringsZU4:array[1..14] of string=
  (
    'M16П2A50B20T21','M16П2A50B30T21','M16П2A50B40T21','M16П2A50B50T21',
    'M16П2A50B60T21','M16П2A50B70T21','M16П2A50B80T21',
    'M16П1A60B20T21','M16П1A60B30T21','M16П1A60B40T21','M16П1A60B50T21',
    'M16П1A60B60T21','M16П1A60B70T21','M16П1A60B80T21'
  );



  //МКБ и все
  {testStringsZU:array[1..24] of string=
  ('M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21','M16П1A20B60C22D41T21',
   'M16П1A20B80C11T21','M16П1A20B80C21T21','M16П1A20B80C31T21','M16П1A20B80C41T21',
   'M16П1A20B60C31D11T21','M16П1A20B60C31D21T21','M16П1A20B60C31D31T21','M16П1A20B60C31D41T21',
   'M16П1A30B60C22D11T21','M16П1A30B60C22D21T21','M16П1A30B60C22D31T21','M16П1A30B60C22D41T21',
   'M16П1A30B80C11T21','M16П1A30B80C21T21','M16П1A30B80C31T21','M16П1A30B80C41T21',
   'M16П1A30B60C31D11T21','M16П1A30B60C31D21T21','M16П1A30B60C31D31T21','M16П1A30B60C31D41T21'
  );}



  {testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16П1A70B11T22P01','M16П1A70B11T22P02','M16П1A70B21T22P01','M16П1A70B21T22P02',
   'M16П1A70B31T22P01','M16П1A70B31T22P02','M16П1A70B41T22P01','M16П1A70B41T22P02',
   'M16П1A30B11T22P01','M16П1A30B11T22P02','M16П1A30B21T22P01','M16П1A30B21T22P02',
   'M16П1A30B31T22P01','M16П1A30B31T22P02','M16П1A30B41T22P01','M16П1A30B41T22P02'
  );}//+

  {testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16П1A10B11T22P01','M16П1A10B11T22P02','M16П1A10B21T22P01','M16П1A10B21T22P02',
   'M16П1A10B31T22P01','M16П1A10B31T22P02','M16П1A10B41T22P01','M16П1A10B41T22P02',
   'M16П2A10B11T22P01','M16П2A10B11T22P02','M16П2A10B21T22P01','M16П2A10B21T22P02',
   'M16П2A10B31T22P01','M16П2A10B31T22P02','M16П2A10B41T22P01','M16П2A10B41T22P02'
  );}

  { testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16П1A40B11T22P01','M16П1A40B11T22P02','M16П1A40B21T22P01','M16П1A40B21T22P02',
   'M16П1A40B31T22P01','M16П1A40B31T22P02','M16П1A40B41T22P01','M16П1A40B41T22P02',
   'M16П1A50B11T22P01','M16П1A50B11T22P02','M16П1A50B21T22P01','M16П1A50B21T22P02',
   'M16П1A50B31T22P01','M16П1A50B31T22P02','M16П1A50B41T22P01','M16П1A50B41T22P02'
  );}

  {testStringsZU:array[1..ZU_NUM_TEST_CH] of string=
  ('M16П2A50B11T22P01','M16П2A50B11T22P02','M16П2A50B21T22P01','M16П2A50B21T22P02',
   'M16П2A50B31T22P01','M16П2A50B31T22P02','M16П2A50B41T22P01','M16П2A50B41T22P02',
   'M16П1A60B11T22P01','M16П1A60B11T22P02','M16П1A60B21T22P01','M16П1A60B21T22P02',
   'M16П1A60B31T22P01','M16П1A60B31T22P02','M16П1A60B41T22P01','M16П1A60B41T22P02'
  );}



  {testStringsBVK:array[1..BVK_NUM_TEST_CH] of string=    //14
  ('M16П1A70B11T22P01','M16П1A70B11T22P02','M16П1A70B21T22P01','M16П1A70B21T22P02',
   'M16П1A70B31T22P01','M16П1A70B31T22P02','M16П1A70B41T22P01','M16П1A70B41T22P02',
   'M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21',
   'M16П1A20B60C22D41T21','M16П1A20B80C11T21','M16П1A20B80C21T21'
  );}


  {testStringsBVK:array[1..20] of string=    //14
  ('M16П1A70B11T22P01','M16П1A70B11T22P02','M16П1A70B21T22P01','M16П1A70B21T22P02',
   'M16П1A70B31T22P01','M16П1A70B31T22P02','M16П1A70B41T22P01','M16П1A70B41T22P02',
   'M16П1A20B60C22D11T21','M16П1A20B60C22D21T21','M16П1A20B60C22D31T21',
   'M16П1A20B60C22D41T21','M16П1A20B80C11T21','M16П1A20B80C21T21',
   'M16П1A20B80C31T21','M16П1A20B80C41T21','M16П1A20B60C31D11T21',
   'M16П1A20B60C31D21T21','M16П1A20B60C31D31T21','M16П1A20B60C31D41T21'
  );}

  //массив для проверки БВК предв режим  (мс)
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
  //хранение текущего состояния  предв. режима
  testBVK_Arr_pr_curr:array[1..BVK_NUM_TEST_CH] of Integer;
  //хранение предидущего состояния предв. режима
  testBVK_Arr_pr_prev:array[1..BVK_NUM_TEST_CH] of Integer;
  //хранение нумерации проверенных состояний канала
  testedState_pr:array[1..BVK_NUM_TEST_CH] of Integer;
  //хранение начального состояния
  testBVK_Arr_pr_BegState:array[1..BVK_NUM_TEST_CH] of Integer;

  //массив для проерки БВК осн. режим  (мс)
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

  //хранение текущего состояния  осн. режима
  testBVK_Arr_G_curr:array[1..BVK_NUM_TEST_CH] of Integer;
  //хранение предидущего состояния осн. программы
  testBVK_Arr_G_prev:array[1..BVK_NUM_TEST_CH] of Integer;
  //хранение нумерации проверенных состояний канала
  testedState_G:array[1..BVK_NUM_TEST_CH] of Integer;
  //хранение начального состояния
  testBVK_Arr_G_BegState:array[1..BVK_NUM_TEST_CH] of Integer;



  //testBVK_Arr_pr_Beg:array[1..BVK_NUM_TEST_CH] of Integer;





  //testBVK_Arr_G_Beg:array[1..BVK_NUM_TEST_CH] of Integer;
  // временный тестовый массив для осн. программы для хранения предидущего состояния каналов
  //testBVK_Arr_G_Beg_prev:array[1..BVK_NUM_TEST_CH] of Integer;
  //reversFlagArr:array[1..BVK_NUM_TEST_CH] of Boolean;

  //timeDownSetChArr:array[1..BVK_NUM_TEST_CH] of cardinal=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  //флаг установки начального состояния
  prBegFl:Boolean=True;


  //массив срабатываний канала
  //tTimeBVK_pr_setT:array[1..BVK_NUM_TEST_CH] of Cardinal=(0,0,0,0,0,0,0,0,0,0,500,1000,0,0);
  //массив длительности урония после срабатывания канала
  //tTimeBVK_pr_durabilityT:array[1..BVK_NUM_TEST_CH] of Cardinal=(0,0,0,0,0,0,0,0,0,0,0,0,0,0);

  //массив для проверки БВК основной режим
  //массив срабатываний канала
  //tTimeBVK_G_setT:array[1..BVK_NUM_TEST_CH] of Cardinal=(0,0,0,0,0,0,0,0,0,0,500,1000,0,0);
  //массив длительности урония после срабатывания канала
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

  //счетчик итераций в проверках
  testCount:Integer=0;
  startTestBlock:Boolean;
  testFlag_1_1_10_2:Boolean={false}true;
  //startTestMKT3:Boolean;
 

  testResult:Boolean;
  allTestFlag:Boolean=true;

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

  tArrRound:array[1..10]of array[1..31] of Integer;

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

  // IsdMKBcontNum2, IsdMKBcontNum3, IsdMKBcontNum4 неверно указаны каналы для замыкания на ИСД //!!!
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

  //флаг успешности наличия приборов
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
  //флаг проверки предватиленой программы BVK
  prFlag:Boolean;
  //флаг проверки основной программы BVK
  genFlag:Boolean;
  //массив значений каналов МКБ2 для проверки БВК
  dataB:array[1..20]of Integer;
  dataA:array[1..20]of Integer;
  //корректность  проверки БВК
  BVKTestFlag:Boolean=true;

  flagFtime:Boolean=false;
  startBVktime:Integer;


  

  timeZUCarSec:Cardinal=0;
  timeZUCarMSec:Cardinal=0;
  timeZUPrevSec:Cardinal=0;
  timeZUPrevMSec:Cardinal=0;

  //нач состояние каналов прибора
  //testZU_Arr_pr_BegState:array[1..100] of Integer;
  //предидущее состояние каналов ЗУ
  testZU_Arr_pr_prev:array[1..100] of Integer;
  //текущее состояние каналов ЗУ
  testZU_Arr_pr_curr:array[1..100] of Integer;
  //значение тестируемых каналов
  dataZU:array[1..100] of Integer;
  prBegZU:Boolean;
  ZUTestFlag:Boolean;


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
  function testCompens():boolean;
  procedure TestMKB2;
  procedure testVpMKB2();
  function getVoltmetrValue(m_instr_usbtmc:Cardinal):double;
  procedure setFrequencyOnGenerator(freq:real;ampl:real;m_instr_usbtmc:cardinal);
  procedure TestBVK;
  procedure setValOnCh(modZU:Integer);
  procedure testZU;
implementation
  uses OrbitaAll;

//Функция проверки доступности Comm1
function ComTestConect():Boolean;
var
  falseFlag:Boolean;      // Флаг доступности или недоступности
begin
  falseFlag:=True;        // Предположим что доступен
  try
      comm1.Open();       // Попытаемся подключиться
  except
      on ECommError do    // Если исключение ошибки подключения
      begin
          falseFlag:=False; // Флаг в фоолс
          ShowMessage(ComPortTransmille+' недоступен');
      end;
  end;
  if(falseFlag=True)  then // Если порт откылся то закроем его
  begin
      comm1.Close();
  end;
  Result:=falseFlag;
end;

//процедура изменения сопротивления
//value- значение в Ом
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

//проверка наличия приборов
function testOnAllTestDevices:Boolean;
var
  str:string;
begin
  flagTestDev:=True;

  //проверка подключения магазина сопротивлений
  {if (not ComTestConect) then
  begin
    flagTestDev:=False;
    form1.Memo1.Lines.Add('Магазин сопротивлений Transmille не подключен!');
  end
  else
  begin
    form1.Memo1.Lines.Add('Магазин сопротивлений Transmille подключен!');
  end; }

  //проверка подключения вольтметра_1
  if (TestConnect(AkipV7_78_1,m_defaultRM_usbtmc_1[0],m_instr_usbtmc_1[0],viAttr_1,Timeout)=-1) then
  begin
      form1.Memo1.Lines.Add('Вольтметр не подключен!');
      flagTestDev:=False;
  end
  else
  begin
      form1.Memo1.Lines.Add('Вольтметр подключен!');
  end;

  //SetConf(m_instr_usbtmc_1[0],'READ?');
  //считываем напряжение с вольтметра_1
  //GetDatStr(m_instr_usbtmc_1[0],str);


  //проверка подключения вольтметра_2
  {if (TestConnect(AkipV7_78_2,m_defaultRM_usbtmc_2[0],m_instr_usbtmc_2[0],viAttr_2,Timeout)=-1) then
  begin
      form1.Memo1.Lines.Add('Вольтметр_2 не подключен!');
      flagTestDev:=False;
  end
  else
  begin
      form1.Memo1.Lines.Add('Вольтметр_2 подключен!');
  end;}
  {SetVoltageOnPowerSupply(1,'0000');
  SetOnPowerSupply(1);
  Delay_S(5);
  SetOnPowerSupply(0);
  //замыкаем контакты команды НОВ
  //SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1'); }

  //проверка подключения источника питания
  if (PowerTestConnect) then
  begin
    form1.Memo1.Lines.Add('Источник питания АКИП-1105 подключен!');
  end
  else
  begin
    form1.Memo1.Lines.Add('Источник питания АКИП-1105 не подключен!');
    flagTestDev:=False;
  end;

  // Проверка ИСД_1--------------------------------------------------------------------------------------------------
  try
      //нелаем неправильный запрос. если ответ есть то ИСД есть
      str:=Form1.IdHTTP1.Get('http://'+ISDip_1);
      Form1.Memo1.Lines.Add('ИСД_1 подключен!');
  except
   Form1.Memo1.Lines.Add('ИСД_1 не подключен!');
   flagTestDev:=False;
   //Exit;
  end;



  // Проверка ИСД_2--------------------------------------------------------------------------------------------------
  try
      //нелаем неправильный запрос. если ответ есть то ИСД есть
      str:=Form1.IdHTTP2.Get('http://'+ISDip_2);
      Form1.Memo1.Lines.Add('ИСД_2 подключен!');
  except
   Form1.Memo1.Lines.Add('ИСД_2 не подключен!');
   flagTestDev:=False;
   //Exit;
  end;

  Form1.idpsrvr1.Active:=False;

  //проверка подключения генератора
  {if (TestConnect(RigolDg1022_1,m_defaultRM_usbtmc_2[1],m_instr_usbtmc_2[1],viAttr,Timeout)=-1) then
  begin
    form1.Memo1.Lines.Add('Генератор не подключен!');
    flagTestDev:=False;
  end
  else
  begin
    form1.Memo1.Lines.Add('Генератор подключен!');
  end;}

  //замкнули канал для подготовки подачи команды НОВ
  //SendCommandToISD('http://'+ISDip_2+'/type=2num='+inttostr(5)+'val=1');


  Result:=flagTestDev;
end;





// -----------------------------------------------------------
// Получение данных с юсб
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
      form1.Memo1.Lines.Add('Данных нет')
  end
  else
  begin
      dat:=floattostrf(strtofloat(stbuffer), fffixed, 5, 4);
  end;
end;
// ----------------------------------------------------------------


// -------------------------------------------------
// Задержка в миллисекундах
// -------------------------------------------------
procedure Delay_ms(ms:Integer);
begin
    sleep(ms);
    Application.ProcessMessages();
end;
// --------------------------------------------------
// Задержка в секундах
// --------------------------------------------------
procedure Delay_S(S:Integer);
var
    i:Integer;
begin
    for i:=0 to (s*4) do                // Разбиваем секунды по 250 миллисекунд чтобы программа не провисала
    begin
        sleep(250);
        Application.ProcessMessages();  // Чтобы не провисала
    end;
end;
// ----------------------------------------------------
// Функция отправки команды на Источник питания
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
// Сброс установок на источник питания
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
// Ф-ия установки напряжения на источник питания
// ------------------------------------------------------
function SetVoltageOnPowerSupply(NumberPowerSupply:integer;V:string):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'VOLT 0'+V);
    sleep(100);
end;
// -------------------------------------------------------
// Ф-ия установки тока на источник питания
// -------------------------------------------------------
function SetCurrentOnPowerSupply(NumberPowerSupply:integer;A:string):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'CURR 0'+A);
    sleep(100);
end;
// --------------------------------------------------------
// Ф-ия включения выхода ON источника питания
// --------------------------------------------------------
function SetOnPowerSupply(NumberPowerSupply:integer):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'SOUT 1');
end;
// --------------------------------------------------------
// Ф-ия включения выхода ON источника питания
// --------------------------------------------------------
function TurnOFFPowerSupply(NumberPowerSupply:integer):byte;
begin
    SendCommandToPowerSupply(NumberPowerSupply,'SOUT 0');
    sleep(100);
end;
// ---------------------------------------------------------
// Функция проверки подключения источника питания
// ---------------------------------------------------------
function PowerTestConnect():Boolean ;
begin
  AkipOffOnState:=false;
  //SetOnPowerSupply(1);
  SendCommandToPowerSupply(1, 'GETD'); // Считать ток потребления
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
        //  showmessage('       Генератор сигналов не найден!');
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
            //    showmessage('       Генератор сигналов не найден!');
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
  if (st<>'Команда успешно выполнена!') then showmessage('Имитатор сигналов датчиков не отвечает!');
end;

// -------------------------------------------------------------
// Функция замыкания канала на общ шину ИСД
// -------------------------------------------------------------
procedure IsdConnectChanel(chanel:integer;ISDip:string);
var
    num:string;
begin
    num:=IntToStr(chanel);
    SendCommandToISD('http://'+ISDip+'/type=2num='+num+'val=1');
end;

// -------------------------------------------------------------
// Функция размыкания канала на общ шину ИСД
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
  //создаем объект Com для работы с магазином сопротивления
  comm1:=Tcomm.Create({self}nil);
  flag:=True;
  //str:=ExtractFileDir(ParamStr(0))+'Periphery.ini';
  //задаем файл конфигурации приборов
  IniPeriphery:= TIniFile.Create(ExtractFileDir(ParamStr(0))+'\Periphery.ini');
  //задаем ip источника питания
  IP_POWER_SUPPLY_1:=IniPeriphery.ReadString('Device','IP_POWER_SUPPLY_1','-111');
  //задаем порт источника питания
  form1.idpsrvr1.DefaultPort:=StrToInt(IniPeriphery.ReadString('Device','port_POWER_SUPPLY_1','6008'));
  
  //задаем ip адрес ISD_1
  ISDip_1:=IniPeriphery.ReadString('Device','ISDip_1','-111');
  //задаем ip адрес ISD_2
  ISDip_2:=IniPeriphery.ReadString('Device','ISDip_2','-111');
  //задаем из файла координаты генератора
  RigolDg1022_1:=IniPeriphery.ReadString('Device','RigolDg1022_1','-111');
  //задаем  номер Com порта
  COMnum:=IniPeriphery.ReadString('Device','COM','-111');
  //задание вольтметра_1
  AkipV7_78_1:=IniPeriphery.ReadString('Device','AkipV7_78_1','USB[0-9]*::0x164E::0x0DAD::?*INSTR');
  //задание вольтметра_2
  //AkipV7_78_2:=IniPeriphery.ReadString('Device','AkipV7_78_2','USB[0-9]*::0x164E::0x0DAD::?*INSTR');

  Form1.idpsrvr1.Active:=True;

  if {((IP_POWER_SUPPLY_1='-111') or (ISDip_1='-111') or (ISDip_2='-111') or (RigolDg1022_1='-111') or (COMnum='-111'))}((IP_POWER_SUPPLY_1='-111') or (ISDip_1='-111') or (RigolDg1022_1='-111') or (COMnum='-111')) then
  begin
    ShowMessage('Отсутствует или неправильный файл конфигурации Periphery.ini');
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

//функция возвращает номер поддиапазона
function getScaleNum(chVal:word):Integer;
var
  chValBuf:Word;
begin
  //отбрасываем все биты кроме двух старших и делаем их младшими
  chValBuf:=(chVal and 768)shr 8;
  //возврат номера шкалы
  Result:=chValBuf;
end;


//устанавливаем колибровки для всех поддиапазонов
function setColibr(scaleNum:Integer;colib:word):Boolean;
begin
  //в процессе установки коибровок проверяем их
  //и если колибровка не соответствует то сбрасываем обе

  case scaleNum of
    0:
    begin
      //берем середину поддиапазона, если больше нее то это колиб. максимума
      if (colib>135) then
      begin
        //колибровка максимума
        maxScale4:=colib;
      end
      else
      begin
        //колибровка минимума
        minScale4:=colib;
      end;
    end;
    1:
    begin
      if (colib>391) then
      begin
        //колибровка максимума
        maxScale3:=colib;
      end
      else
      begin
        //колибровка минимума
        minScale3:=colib;
      end;
    end;
    2:
    begin
      if (colib>647) then
      begin
        //колибровка максимума
        maxScale2:=colib;
      end
      else
      begin
        //колибровка минимума
        minScale2:=colib;
      end;
    end;
    3:
    begin
      if (colib>903) then
      begin
        //колибровка максимума
        maxScale1:=colib;
      end
      else
      begin
        //колибровка минимума
        minScale1:=colib;
      end;
    end;
  end;


  if ((minScale1<>-1)and(maxScale1<>-1)and(minScale2<>-1)and(maxScale2<>-1)and
    (maxScale3<>-1)and(maxScale3<>-1)and(maxScale4<>-1)and(maxScale3<>-1))then
    begin
      result:=true;
    end
    else
    begin
      result:=false;
    end;
end;



//процедура для выбора правильного списка адресов каналов
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
      //перезагрузим акт. адреса. из файла для отображения
      form1.OrbitaAddresMemo.Lines.LoadFromFile(propStrPath);
    end;
    1:
    begin
      //загрузим в мемо тестовые адреса для проверки МКБ2
      for i:=1 to Length(testStringsMKB2) do //20
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMKB2[i]);
      end;
      //form1.OrbitaAddresMemo.Enabled:=False;
    end;
    2:
    begin
      //загрузим в мемо тестовые адреса для проверки  МКТ3
      for i:=1 to Length(testStringsMKT3) do //32
      begin
        form1.OrbitaAddresMemo.Lines.Add(testStringsMKT3[i]);
      end;
      //form1.OrbitaAddresMemo.Enabled:=False;
    end;
    3:
    begin
      //загрузим в мемо тестовые адреса для проверки  БВК
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
  end;  
end;

function getAbsAccuracy(chValOm:double;colibMinOm:Integer;colibMaxOm:Integer;transOm:double):Double;
var
  accur:double;
begin
  accur:=abs((chValOm-transOm)/(colibMaxOm-colibMinOm));
  Result:=accur*100;
end;



//проверка каналов при компенсации
function testCompens():boolean;
var
  i:Integer;
  bool:Boolean;
begin
  bool:=True;
  for i:=1 to 31 do
  begin
    if  (tempArr2[i].val>=20)and(tempArr2[i].val<=30)then
    begin
      form1.mmoTestResult.Lines.Add('Канал: '+intTostr(i+1)+' Значение на канале: '+intToStr(tempArr2[i].val)+' НОРМА!');
    end
    else
    begin
      form1.mmoTestResult.Lines.Add('Канал: '+intTostr(i+1)+' Значение на канале: '+intToStr(tempArr2[i].val)+' !!!НЕ НОРМА!!!');
      bool:=false;
    end;
  end;
  Form1.mmoTestResult.Lines.Add('');
  result:=bool;
end;

//проверка каналов
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
    chValOm:=(((tempArr2[i].val-colibMin)/(colibMax-colibMin))*(colibMaxOm-colibMinOm)+colibMinOm);

    absAc:=getAbsAccuracy(chValOm,colibMinOm,colibMaxOm,transOm);

//    form1.Memo1.Lines.Add('Значение канала в омах '+floatTostr(chValOm));
//    form1.Memo1.Lines.Add('Канал'+intTostr(i)+' Колибровка min коды:'+intTostr(colibMin)+
//      ' Колибровка max коды:'+intTostr(colibMax)+' Колибровка min омы:'+intTostr(colibMinOm)+
//      ' Колибровка max омы:'+intTostr(colibMaxOm)+' Значения канала в коде'+intTostr(tempArr2[i].val)+
//      ' Выставлено'+floatTostr(transOm));


    if  (absAc*100<=1*100) then
    begin
      form1.mmoTestResult.Lines.Add('Канал: '+intTostr(i+1)+' Сопротивление: '+floatTostrF(chValOm,ffFixed,5,3)+' Ом'+
      ' Погрешность: '+floatTostrF(absAc,ffFixed,2,2)+' %'+' НОРМА');
    end
    else
    begin
      form1.mmoTestResult.Lines.Add('Канал: '+intTostr(i+1)+' Сопротивление: '+floatTostrF(chValOm,ffFixed,5,3)+' Ом'+
        ' Погрешность:'+floatTostrF(absAc,ffFixed,2,2)+' %'+' !!! НЕ НОРМА!!!');
    end;
    
  end;

  form1.mmoTestResult.Lines.Add('');
end;


//Функция для проверки правильности колибровок
function testColibr:Boolean;
var
  allColibTest:Boolean;
begin
  allColibTest:=true;
  if ((minScale4>=20)and(minScale4<=30)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин4: '+intTostr(minScale4)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин4: '+intTostr(minScale4)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((maxScale4>=240)and(maxScale4<=250)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс4: '+intTostr(maxScale4)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс4: '+intTostr(maxScale4)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((minScale3>=276)and(minScale3<=286)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин3: '+intTostr(minScale3)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин3: '+intTostr(minScale3)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((maxScale3>=496)and(maxScale3<=506)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс3: '+intTostr(maxScale3)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс3: '+intTostr(maxScale3)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((minScale2>=532)and(minScale2<=542)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин2: '+intTostr(minScale2)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин2: '+intTostr(minScale2)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((maxScale2>=752)and(maxScale2<=762)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс2: '+intTostr(maxScale2)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс2: '+intTostr(maxScale2)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((minScale1>=788)and(minScale1<=798)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин1: '+intTostr(minScale1)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Мин1: '+intTostr(minScale1)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  if ((maxScale1>=1008)and(maxScale1<=1018)) then
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс1: '+intTostr(maxScale1)+' НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('Калибровка Макс1: '+intTostr(maxScale1)+' !!! НЕ НОРМА !!!');
    allColibTest:=False;
  end;

  //сбросим колибровки для их повторного нахождения
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


//установка сопротивлений на приборе МКБ2
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
// Функция отправки команды в USB
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
// Функция отключения выхода генератора
// -----------------------------------------------------------
procedure GeneratorOutOff(m_instr_usbtmc:cardinal);
begin
  SetUsbConf(m_instr_usbtmc,'OUTP OFF');
end;
// -----------------------------------------------------------
// Установить настройки на генератор
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
// Функция включения выхода на генератор
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

//считывание показания с переданного вольтметра
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

function SetGNDVoltage(ISD_ip:string;m_instr_usbtmc:cardinal):double;                                 //Устанавливает напряжение калибровки 6,2В
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
  //Проверка постоянного напряжения 3,1В
  rezFlag:=true;
  Form1.mmoTestResult.Lines.Add('');
  Form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.2.1 ТУ ЯГАИ.468363.026 (ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ)');
  Form1.mmoTestResult.Lines.Add('');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('1 канал: напряжение = '+FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('1 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!')
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=34val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('2 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('2 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!')
  end;
  SendCommandToISD('http://'+Form1.IdHTTP1.Host+'/type=3num=34val=0');

  SendCommandToISD('http://'+Form1.IdHTTP1.Host+'/type=3num=35val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('3 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('3 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!')
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=35val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=3.070) and (voltmetrValue<=3.130)) then
  begin
    Form1.mmoTestResult.Lines.Add('4 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    Form1.mmoTestResult.Lines.Add('4 канал: напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!')
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=36val=0');

  Form1.mmoTestResult.Lines.Add('');
  if (rezFlag) then
  begin
    Form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.2.1 ТУ ЯГАИ.468363.026'+
      '(ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ) НОРМА')
  end
  else
  begin
    Form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.2.1 ТУ ЯГАИ.468363.026'+
      '(ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ) !!!НЕ НОРМА!!!');
  end;


  //SetConf(m_instr_usbtmc[0],'CONF:VOLT:AC');
end;




function setCalibrVoltage(ISD_ip:string;m_instr_usbtmc:Cardinal):double;                                 //Устанавливает напряжение калибровки 6,2В
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
//Проверка прибора БВК
//===========================================================
procedure TestBVK;
var
  i:integer;
begin
  //получаем время запуска
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //время в секундах
  timeBVKPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //время в мс
  timeBVKPrevMSec:=1000*(hourBVK*60*60+minBVK*60+secBVK)+mSecBVK;
  //установка проверки предварительной программы
  prFlag:=True;

  for i:=1 to BVK_NUM_TEST_CH do
  begin
    testedState_pr[i]:=1;
    testedState_G[i]:=1;
  end;
  startBVktime:=0;


  form1.mmoTestResult.lines.add('ПРОВЕРКА ПУНКТА 1.1.5 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ФОРМИРОВАНИЯ ПРИБОРОМ БВК реллейных и потенциальных команд)');
  form1.mmoTestResult.lines.add('ПРОВЕРКА ПРЕДВАРИТЕЛЬНОГО РЕЖИМА РАБОТЫ БВК');
  form1.tmrTestBVK.Enabled:=True;
end;
//===========================================================

//===========================================================
//
//===========================================================
procedure testZU;
begin
  //получаем время запуска
  DecodeTime(GetTime,hourBVK,minBVK,secBVK,mSecBVK);
  //время в секундах
  timeZUPrevSec:=hourBVK*60*60+minBVK*60+secBVK;
  //время в мс
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











//===========================================================
//Проверка прибора МКБ2
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
begin
  rezFlag:=True;
  setConf(m_instr_usbtmc_1[0],'CONF:VOLT:AC 10');
  generatorOutOn(m_instr_usbtmc_2[1]);
  form1.mmoTestResult.lines.add('ПРОВЕРКА ПУНКТА 1.2.1 ТУ ЯГАИ.468363.026 (ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ)');
  for chNum:=1 to 4 do
  begin
    Form1.mmoTestResult.Lines.Add('');
    form1.mmoTestResult.lines.add('Проверка усиления '+IntToStr(chNum)+' канала');
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

    //для каждого канала проверяем его на всех кэф усиления
    For i:=1 to 8 do
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
      //
      setcoefU(k,chNum);

      sleep(1000);
      voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
      sleep(1000);
      rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
      //rky:=(VoltmetrValue)/(4/(k*sqrt(2)));
      if (rky>0.95)and(rky<1.05) then
      begin
        Form1.mmoTestResult.Lines.Add('Проверка усиления х'+intTostr(k)+' Норма: '+FloatToStrF(rky*k,fffixed,5,2))
      end
      else
      begin
        voltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
        sleep(1000);
        rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
        if (rky>0.95)and(rky<1.05) then
        begin
          Form1.mmoTestResult.Lines.Add('Проверка усиления х'+intTostr(k)+' Норма: '+FloatToStrF(rky*k,fffixed,5,2))
        end
        else
        begin
          VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
          sleep(1000);
          rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
          if (rky>0.95)and(rky<1.05) then
          begin
            Form1.mmoTestResult.Lines.Add('Проверка усиления х'+intTostr(k)+' Норма: '+FloatToStrF(rky*k,fffixed,5,2))
          end
          else
          begin
            VoltmetrValue:=GetVoltmetrValue(m_instr_usbtmc_1[0]);
            sleep(1000);
            rky:=1+((VoltmetrValue)*sqrt(2)-3)/6;
            if (rky>0.95)and(rky<1.05) then
            begin
              Form1.mmoTestResult.Lines.Add('Проверка усиления х'+intTostr(k)+'  Норма: '+FloatToStrF(rky*k,fffixed,5,2))
            end
            else
            begin
              Form1.mmoTestResult.Lines.Add('Проверка усиления х'+intTostr(k)+' !!! Не Норма !!!'+FloatToStrF(rky*k,fffixed,5,2));
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

  if (rezFlag) then
  begin
    Form1.mmoTestResult.lines.add('Проверка усиления каналов: НОРМА');
  end
  else
  begin
    Form1.mmoTestResult.lines.add('Проверка усиления каналов: !!! HE НОРМА !!!');
  end; 
  Form1.mmoTestResult.Lines.Add('');
  //------------
  
  rezFlag:=True;
  form1.mmoTestResult.Lines.Add(' Построение Амплитудно-частотной характеристики');
  //перебираем все 4 канала
  for chNum:=1 to 4 do
  begin
    form1.mmoTestResult.Lines.Add('Проверка '+intTostr(chNum)+'канала');
    SetcoefU(1,chNum);
    case chNum  of
      1:
      begin
        SendCommandToISD('http://'+ISDip_2+'/type=2num=58val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=53val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=3num=33val=1');
        SendCommandToISD('http://'+ISDip_2+'/type=2num=31val=1');
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

    //перебираем частотные диапазоны для каждого канала
    for freqNum:=1 to 8 do
    begin
      rezFlag:=true;
      case freqNum of
        1:
        begin
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 63 Гц, нижняя 0.5 Гц');
          case chNum  of
            1:
            begin
              SetFrequencyOnGenerator(200000,6,m_instr_usbtmc_2[1]);
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 125 Гц, нижняя 0.5 Гц');
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 250 Гц, нижняя 0.5 Гц');
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 500 Гц, нижняя 20 Гц');
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 1024 Гц, нижняя 20 Гц');
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 2048 Гц, нижняя 20 Гц');
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 4096 Гц, нижняя 20 Гц');
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
          form1.mmoTestResult.Lines.Add('Верхняя полоса пропускания 8192 Гц, нижняя 20 Гц');
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

      //
      for i:=1 to 12 do
      begin
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
      end;

      for i:=1 to 3 do
      begin
        form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,i])+
        ' ГЦ; Амплитуда: '+FloatToStrF(N[i],fffixed,5,4));
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
        if (N[i]<(amplsr*0.94))or(N[i]>(amplsr*1.06)) then
        begin
         rezFlag:=false;
          form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,i])+
            ' ГЦ; Амплитуда: '+FloatToStrF(N[i],fffixed,5,4)+
            ' Погрешность:'+FloattostrF(abs(((N[i]-amplsr)*100)/amplsr),fffixed,3,2)+
            '%  !!! НЕ НОРМА!!!');
        end
        else
        begin
          form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,i])+
            ' ГЦ; Амплитуда: '+FloatToStrF(N[i],fffixed,5,4)+
            ' Погрешность:'+FloattostrF(abs(((N[i]-amplsr)*100)/amplsr),fffixed,3,2)+
            '% НОРМА');
        end;
        Form1.lnsrsSeries10.AddXY(Values[freqNum,i],(amplsr*1.06));
        Form1.lnsrsSeries11.AddXY(Values[freqNum,i],(amplsr*0.94));
      end;

      form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,8])+
        ' ГЦ; Амплитуда: '+FloatToStrF(N[8],fffixed,5,4));

      if (N[8]<(amplsr*0.7))or(N[10]>(amplsr*0.7)) then
      begin
        rezFlag:=false;
        form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,9])+
          ' ГЦ; Амплитуда: '+FloatToStrF(N[9],fffixed,5,4)+' !!! НЕ НОРМА !!!');
      end
      else
      begin
        form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,9])+
          ' ГЦ; Амплитуда: '+FloatToStrF(N[9],fffixed,5,4)+' НОРМА');
      end;

      for i:=10 to 12 do
      begin
        form1.mmoTestResult.Lines.Add('Частота: '+Floattostr(Values[freqNum,i])+
          ' ГЦ; Амплитуда: '+FloatToStrF(N[i],fffixed,5,4));
      end;

      if (not rezFlag) then
      begin
        form1.mmoTestResult.Lines.Add('!!!НЕ НОРМА!!!');
        //DeviceTestRezultFlag:=false;
        //RezultFlag3:=false;
      end
      else
      begin
        form1.mmoTestResult.Lines.Add(' НОРМА');
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
  SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC 10');
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('Установленное значение напряжения калибровки 6,2В: '+FloatToStrF(setCalibrVoltage(ISDip_2,m_instr_usbtmc_1[0]),ffFixed,6,4));       //Устанавливаем на ИСД напряжение калибровки 6,2В
  SetGNDVoltage(ISDip_2,m_instr_usbtmc_1[0]);
  form1.mmoTestResult.Lines.Add('');
  //доразмыкаем не используемые ранее каналы ИСД
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
  setFrequencyOnGenerator(100000,5,m_instr_usbtmc_2[1]);
  SetConf(m_instr_usbtmc_1[0],'CONF:VOLT:DC');

  rezFlag:=true;
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТА 1.1.3 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ЭЛЕКТРИЧЕСКИХ ПАРАМЕТРОВ ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ)');
  form1.mmoTestResult.Lines.Add('');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=51val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=10.8) and (voltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('1 канал (контакт 23): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('1 канал (контакт 23): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=51val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=52val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('1 канал (контакт 24): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('1 канал (контакт 24): напряжение = '+
      FloatToStrF(VoltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=52val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=53val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((VoltmetrValue>=10.8) and (VoltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('2 канал (контакт 29): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('2 канал (контакт 29): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=53val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=54val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('2 канал (контакт 30): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('2 канал (контакт 30): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=54val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=55val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=10.8) and (voltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('3 канал (контакт 32): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('3 канал (контакт 32): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=55val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=56val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('3 канал (контакт 33): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('3 канал (контакт 33): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=56val=0');

  SendCommandToISD('http://'+ISDip_2+'/type=3num=57val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=10.8) and (voltmetrValue<=13.2)) then
  begin
    form1.mmoTestResult.Lines.Add('4 канал (контакт 39): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('4 канал (контакт 39): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=57val=0');
  SendCommandToISD('http://'+ISDip_2+'/type=3num=58val=1');
  voltmetrValue:=getVoltmetrValue(m_instr_usbtmc_1[0]);
  if ((voltmetrValue>=-13.2) and (voltmetrValue<=-10.8)) then
  begin
    form1.mmoTestResult.Lines.Add('4 канал (контакт 40): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   НОРМА')
  end
  else
  begin
    rezFlag:=false;
    //DeviceTestRezultFlag:=false;
    form1.mmoTestResult.Lines.Add('4 канал (контакт 40): напряжение = '+
      FloatToStrF(voltmetrValue,ffFixed,7,4)+'В   !!!НЕ НОРМА!!!');
  end;
  SendCommandToISD('http://'+ISDip_2+'/type=3num=58val=0');

  form1.mmoTestResult.Lines.Add('');
  if (rezFlag) then
  begin
    form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.1.3 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ЭЛЕКТРИЧЕСКИХ ПАРАМЕТРОВ ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ) НОРМА');
  end
  else
  begin
    form1.mmoTestResult.Lines.Add('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.1.3 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ЭЛЕКТРИЧЕСКИХ ПАРАМЕТРОВ ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ)  !!!НЕ НОРМА!!!');
    //DeviceTestRezultFlag:=false;
    {ret := Application.MessageBox(PAnsiChar('СООТВЕТСТВИЕ ПРИБОРА МКБ2 ПУНКТУ 1.1.3 ТУ ЯГАИ.468363.026 (ПРОВЕРКА ЭЛЕКТРИЧЕСКИХ ПАРАМЕТРОВ ВИБРАЦИОННЫХ УСИЛИТЕЛЕЙ) !!!НЕ НОРМА!!!'),PAnsiChar('Дальнейшие действия'),MB_ABORTRETRYIGNORE + MB_ICONQUESTION);
    if ret=IDABORT then
    Begin
      str5:='Результаты_проверки_прибора_МКБ2_'+DateToStr(Date)+'_'+TimeToStr(Time)+'.txt';
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
  //проверка постоянных напряжений на каналах  МКБ2
  testVpMKB2;


  //начали прием данных с прибора
  Form1.startReadACP.Click;  //!!!

  Delay_S(5);

  TimerMode:=1;
  NumberChannel:=1;
  rezFlag:=true;                                                                                                   //Результат проверки одного пункта ТУ
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('ПРОВЕРКА ПУНКТОВ 1.2.2 И 1.1.1 ТУ ЯГАИ.468363.026'+
    '(ПРОВЕРКА МЕТРОЛОГИЧЕСКИХ ХАРАКТЕРИСТИК КОМУТАТОРА И ПРОВЕРКА ВХОДНЫХ СИГНАЛОВ))');
  form1.mmoTestResult.Lines.Add('');
  form1.mmoTestResult.Lines.Add('Проверка рабочей шкалы при напряжении 0В');


  //выставим 0В на всех проверяемых каналах
  for i:=1 to 20 do
  begin
    SendCommandToISD('http://'+ISDip_2+'/type=1num='+
          IntToStr(IsdMKBcontNum[i])+'val=0work=0');
    form1.mmoTestResult.Lines.Add(IntToStr(IsdMKBcontNum[i])+'++');
    Delay_S(1);
  end;//!!!


  Delay_S(1);

  form1.PageControl1.ActivePageIndex:=1;

  //TimerMode:=6;//!!!

  Form1.tmrMKB_Dpart.Enabled:=true;
end;
//============================================================

//проверка блока N1-1
//Пункт 1.1.10.2
//function Test_1_1_10_2():Boolean;
//begin
//  testResult:=true;
//  //проверяем первый диапазон
//  //проверка в режиме ТС
//  //установим 1 диапазон
//  SendCommandToISD('http://'+ISDip_1+'/type=2num=54val=1');
//  //проверяем установились ли калибровки
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
//  //проверяем 31 канал
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

  //проверка в режиме ТП

  //проверяем второй диапазон
  //проверка в режиме ТС
  //установим 2 диапазон
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




  //проверка в режиме ТП

  //changeResistance(2.0);
  //changeResistance(10.0);

  //выставляем номер диапазона
 // diap:=1;





  //Result:=testResult;
//end;



end.
