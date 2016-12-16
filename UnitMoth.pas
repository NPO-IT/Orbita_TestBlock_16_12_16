unit UnitMoth;

interface
uses
  LibUnit,OutUnit,SysUtils;
type
   TDataMoth=class(TObject)
    //���� ���������� ������� �������
    fraseMarkFl: boolean;
    countPointMrFrToMrFr: integer;
    //���� ��� ����. �������� ������ ������� �����
    qSearchFl: boolean;
    //���� ��� ������ ����� ����
    flagCountFrase: boolean;
    //���� ��� ������ �������� �����
    flagCountGroup: boolean;
    //����� ��� ����� ������� ������
    bufMarkGroup: int64;
    //����� ��� ����� ������� �����
    bufMarkCircle: int64;
    flfl: boolean;
    iMasGroup: integer;


    //������� �� ������ ���������� ����� �����
    procedure FifoBackPoint(countPoint: integer);
    procedure testFillCircleArr(var imasCircle:Integer);
    //��������� ����� ����� ������ �08,04,02,01
    procedure CalkWordBuf(var countStep:Extended;
      stepToTransOrbOne: extended;var wordBuf: word);
    //������ ������ �����
    procedure evenFraseAnalyze(wordNum:integer;wordBuf:word;orbInf:string);
    //�������� ����������� ��
    procedure testCollectMG;
    //�������� ����������� ��
    procedure testCollectMC;
    function ReadFromFIFObufB(offset: integer): integer;
    function ReadFromFIFObufN(prevMarkFrBeg: integer; offset: integer): integer;
    //������ �������� �������, ��������������� ������
    procedure FillMasGroup(countPointToPrevM: integer;
      currentMarkFrBeg: integer; orbInf: string; var iMasGroup: integer);
    //�������� ������� ������� ����� ����� ������� �����
    function TestMFNull(curNumPoint:Integer;numNulls:integer):Boolean;
    //�������� ������� ������� ����� ������ ������� �����
    function TestMFOnes(curNumPoint:Integer;numOnes:integer):Boolean;
    function QtestMarker(begNumPoint: integer; const pointCounter: integer): boolean;
    //������� ����� ������� �����
    function QfindFraseMark: boolean;
    //������� �� ������ ���������� ����� ������
    procedure FifoNextPoint(countPoint: integer);
    //������� ������ �������� �� 0 � 1
    function SearchP0To1(curPoint:Integer;nextPoint:integer):Boolean;
    //������� ������ �������� �� 1 � 0
    function SearchP1To0(curPoint:Integer;nextPoint:integer):Boolean;
     //������ 1 �������� � �����.���
    function ReadFromFIFObuf: integer;
    //����� ������� �������
    function FindFraseMark(var fifoLevelRead: integer): integer;
    //��������� ������� ��� M08,04,02,01
    procedure TreatmentM8_4_2_1;
    procedure WriteToFIFObuf(valueACP: integer);
    constructor CreateData;
   end;

var
  //����. ��� ������ ������� ����� ��� �08,04,02,01 ������� �� ���������������
    markKoef:Double;
    widthPartOfMF:integer;
    //���������� ����� ����� ��������� ���� � �����. �� ���������������
    minSizeBetweenMrFrToMrFr:Integer;
implementation
uses
  OrbitaAll,ACPUnit;
//==============================================================================
//
//==============================================================================
constructor TDataMoth.CreateData;
begin
  //�������� ��� �������� ���������� ����� ���� � ���� ������
  //numRetimePointUp := 0;
  //numRetimePointDown := 0;
  //���������� ���� ��� ������ ������ �����
  //firstFraseFl := false;
  //���� ��� ������������� ���������� ������� ����� � 1 ����� ������� �����
  flBeg := false;
  //������� ���� ������
  wordNum := 1;
  fraseNum:=1;
  groupNum:=1;
  ciklNum:=1;
  //����� ������������� ��� ������ � ���������� � 1 ����� 1 ����� 1 ������ 1 ����� 1 �����
  flSinxC:=False;
  //���� ��������� ���������� ������� �����
  flKadr:=False;
  startWriteMasGroup := false;
  //������� ����� ��� ������� ����������� ����
  //iBit := 1;
  //����. ����������� �����
  //bitSizeWord := 12;
  //pointCount:=0;
  codStr := 0;
  //����� ��� ������ �� �����������
  graphFlagSlowP := false;
  graphFlagFastP := false;
  graphFlagBusP := false;
  graphFlagTempP := false;
  //������� ��� �������� ��������� �������� �����
  countForMF:=0;
  //������� �������� ����� �� �� �� ������
  countErrorMF:=0;
  //���������� ����������� ������.
  buffDivide := 0;
  //��������� ������������� ����� ������ ������ ������
  //flagOutFraseNum := false;
  groupWordCount:=1; //!!
  //������� ���� ,��������� ����� ����������� � 1. ����� � 1 �� 128.
  //myFraseNum := 1;
  //��������� ����. ������� ������ ������
  //markerNumGroup := 0;
  //��������� �������� ������� ������
  //nMarkerNumGroup := 1;
  //��������� ����. ������� ������
  //markerGroup := 0;
  countEvenFraseMGToMG:=0;
  //��������� ����. ���������� ��� ������� ������� ������ �16
  //flagL := true;
  countForMG:=1;
  countErrorMG:=0;
  iMasCircle := {0}1;
  analogAdrCount:=0;
  contactAdrCount:=0;
  tempAdrCount:=0;
  fraseMarkFl := false;
  //���. ���� ����� �������� ������
  qSearchFl := false;
  flagCountGroup := false;
  flagCountFrase:=false;
  bufMarkGroup := 0;
  bufMarkCircle := 0;
  flfl := false;
  //���. ���� �������� ��� ���������� ������� ������
  iMasGroup := {0}1;
  numP := 0;
  numPfast := {0}1;
end;
//==============================================================================

//==============================================================================
//������� ��� ������ �� ������� ���� ������� ��������  offset -����� ��� ������ ����������� ���������
//============================================================================
function TDataMoth.ReadFromFIFObufN(prevMarkFrBeg: integer; offset: integer): integer;
var
  fifoOffset: integer;
begin
  //�������� �������� ��� ���������� �������
  //offset:=offset-1;
  if prevMarkFrBeg + offset > FIFOSIZE then
  begin
    fifoOffset := (prevMarkFrBeg + offset) - FIFOSIZE;
  end
  else
  begin
    fifoOffset := prevMarkFrBeg + offset;
  end;
  result := {data.fifoMas[} fifoOffset {]};
end;
//============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.FifoBackPoint(countPoint: integer);
var
  offset: integer;
begin
  //���������� ������� ������ �����
  if fifoLevelRead <= countPoint then
  begin
    offset := countPoint - fifoLevelRead;
    fifoLevelRead := FIFOSIZE - offset;
  end
  else
  begin
    fifoLevelRead := fifoLevelRead - countPoint;
  end;
  //������. ����� � �������� ���. ����� � �����. � fifoLevelRead
  fifoBufCount := fifoBufCount + countPoint;
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
procedure TDataMoth.testFillCircleArr(var imasCircle:Integer);
begin
  //��������� 32767 ���������
  if imasCircle = {length(masCircle[reqArrayOfCircle])}masCircleSize+1 then
  begin
    //form1.Memo1.Lines.Add(intToStr(length(masCircle[reqArrayOfCircle])));
    imasCircle := 1;
    //������ ����� ��������. ����� � ���� ���
    //���� ������ � ��� ������� �� ����� ����(���� ������ � ����)
    if (tlm.flagWriteTLM) then
    begin
      if infNum = 0 then
      begin
        //M16
        tlm.WriteTLMBlockM16(tlm.msTime);
      end
      else
      begin
        //������ ���������������
        tlm.WriteTLMBlockM08_04_02_01(tlm.msTime);
      end;
      {form1.WriteTLMTimer.Enabled:=true;}
    end;
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.evenFraseAnalyze(wordNum:integer;wordBuf:word;orbInf:string);
begin
  //���� ����� ������ � ��� �� ������ ���� � 1 ����� ������� 12 ��� ��� �����
  //������� ������ � ����� .8 ��������. �� 01110010. �� 10001101
  if wordNum = {9}StrToInt(orbInf[3])+1 then
  begin
    Inc(countEvenFraseMGToMG);

    //��������� 12 ���
    if ((wordBuf and $800) <> 0) then
    begin
      bufMarkGroup := (bufMarkGroup shl 1) + 1;
    end
    else
    begin
      bufMarkGroup := (bufMarkGroup shl 1) + 0;
    end;

    //����� ��������� �����(�����) �� 64 ������ �����
    //��������� �� ������� �� ������ ������ 8 ���

//    if groupNum=31 then
//    begin
//      Form1.Memo1.Lines.Add('11');
//    end;



    testCollectMG;

    //��������� �� ������� �� ������ ����� 8 ���
    testCollectMC;
  end;
end;

//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.CalkWordBuf(var countStep:Extended;
  stepToTransOrbOne: extended;var wordBuf: word);
const
  SIMBOLINWORD = 12;
var
  simbCount: integer;
begin
  simbCount := SIMBOLINWORD - 1;
  while simbCount >= 0 do
  begin
    //������� ��. � ��� � ���. ���� � �������
    if (fifoMas[round(countStep)] >= porog) then
    begin
      //������ 1 � ������ ���
      wordBuf := wordBuf or (1 shl simbCount);
    end
    else
    begin
      wordBuf := wordBuf or (0 shl simbCount);
    end;

    countStep := countStep + stepToTransOrbOne;
    if round(countStep) > FIFOSIZE then
    begin
      countStep := round(countStep) - FIFOSIZE;
    end;
    dec(simbCount);
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.testCollectMC;
begin
  if ((bufMarkGroup and 255) = 141) then
  begin
    //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' ��');
    countEvenFraseMGToMG:=0;
    groupNum := 32{1};
    //Writeln(textTestFile,' ������ ������ �����!');
    //Writeln(textTestFile,' �������:'+intTostr(groupNum)+' !!!!!');
    //Form1.Memo1.Lines.Add('���� � '+IntToStr(ciklNum));
    //Writeln(textTestFile,' ������:'+intTostr(ciklNum)+' !!');
    Inc(ciklNum);
    if ciklNum=5 then
    begin
      ciklNum:=1;
    end;


    flagCountGroup := true;
    //�������� ������ �����
    bufMarkCircle := 0;
  end;
end;
//==============================================================================


//==============================================================================
//������� ��� ������ �� ������� ���� ������� ��������  offset -����� ��� ������ ����������� ���������
//============================================================================
function TDataMoth.ReadFromFIFObufB(offset: integer): integer;
var
  fifoOffset: integer;
begin
  //�������� �������� ��� ���������� �������
  //offset:=offset-1;
  if fifoLevelRead - offset < 1 then
  begin
    fifoOffset := FIFOSIZE - abs(fifoLevelRead - offset);
  end
  else
  begin
    fifoOffset := fifoLevelRead - offset;
  end;
  result := {data.fifoMas[} fifoOffset {]};
end;
//============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.testCollectMG;
begin
//  if (groupNum=31)and(fraseNum=128) then
//  begin
//    Form1.Memo1.Lines.Add(IntToStr(groupNum)+' '+IntToStr(fraseNum)+' '+IntToStr(bufMarkGroup));
//  end;




  if {(((bufMarkGroup and 255) = 114)and(countEvenFraseMGToMG=64))}((bufMarkGroup and 255) = 114) then
  begin
    //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' ��'); //TO-DO<><><>
    //+1 ��
    Inc(countForMG);



    if countEvenFraseMGToMG<>64 then
    begin
      //���� �� �� ����
      Inc(countErrorMG);
      //form1.Memo1.Lines.Add(IntToStr(countErrorMG));
      //form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG));
      {while(flagTrue) do
      begin
        Application.ProcessMessages;
      end;}
    end;

    if countForMG={100}32 then
    begin
      //������� ����� ����� �� ��
      OutMG(countErrorMG);
      //form1.Memo1.Lines.Add(IntToStr(countErrorMG));
      countErrorMG:=0;
      countForMG:=1;
    end;
    countEvenFraseMGToMG:=0;

    //���� ��������� ����
    //flagCountFrase:=true;
    flfl := true;

    //�������� ������ ������
    //bufMarkGroup := 0;
    if (flagCountGroup) then
    begin
      //Form1.Memo1.Lines.Add('������ � '+IntToStr(groupNum));
      //Writeln(textTestFile,' ^');
      //Writeln(textTestFile,' |');
      //Writeln(textTestFile,'�������:'+intTostr(groupNum)+' !!');
      //form1.Memo1.Lines.Add('�������:'+intTostr(groupNum));
//      if  groupNum=30 then
//      begin
//        Form1.Memo1.Lines.Add('��');
//      end;
//
//      Form1.Memo1.Lines.Add(IntToStr(groupNum)+' '+IntToStr(fraseNum)+' '+IntToStr(bufMarkGroup));

      inc(groupNum);
      if groupNum = 33 then
      begin
        groupNum := 1;
      end;
    end;
    fraseNum := 128;
    //Writeln(textTestFile,'������ ������ ������! '+' �����:'+intTostr(fraseNum));


    //�������� ������ ������
    bufMarkGroup := 0;
    //break;
    //countEvenFraseMGToMG:=0;
  end;

  {if countEvenFraseMGToMG>129 then
  begin
    form1.Memo1.Lines.Add('Error '+ intToStr(countEvenFraseMGToMG));
    OutMG(99);
    countEvenFraseMGToMG:=0;
  end;}
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.FillMasGroup(countPointToPrevM: integer;
currentMarkFrBeg: integer; orbInf: string; var iMasGroup: integer);
const
  SIMBOLINWORD = 12;
var
  stepToTransOrbOne: extended;
  countStep: extended;
  //wordCount: integer;

  numWordInByte: integer;
  wordBuf: word;
  //i: integer;
  //j: integer;
  //k: integer;
  //l: integer;
  //offset: integer;
  //stepRealInFloat:int64;
  //testMas:array of testRecord; //!!!
  //iTestMas:integer;//!!!
  //ppp: integer;
  //koef: integer;
begin
  //� ������ ������ ��������� �������� ������ �������� �����
  wordBuf := 0;
  //������� ���������� ���� ����� ��������� �� ���������������
  //����� ��������� ������ 2 �����
  numWordInByte := StrToInt(orbInf[3]) * 2;
  //��������� ���������� ����� �����. ������ �� 1 ������ ������
  stepToTransOrbOne := countPointToPrevM / numWordInByte / SIMBOLINWORD;
  //stepToTransOrbOne := markKoef;
  //������������ � ������ ����������� ������� �����
  countStep := ReadFromFIFObufB(countPointToPrevM);
  //countStep := ReadFromFIFObufB(4);
  //��������� � �������� ����, ���. �������� +4 �����
  //countStep := ReadFromFIFObufN(round(countStep), {MARKMAXSIZE}4); //!! 1 �� 2
  //wordCount := 1;

  //if groupNum=32 then
  //begin
    //groupNum:=1;
  //end;

  wordNum:=1;
  //��������� ������ ������ ������
  while wordNum <= numWordInByte do
  begin
    //�������� ����� ����� ���������� ������� ������
    //���� ����� 1 - ������ �������� �����
    //��� 9 ������ ������ � �� ����� ����� ������ ������ ��.

    {if (flagCountFrase) then
    begin
      //Writeln(textTestFile,' ������:'+intTostr(wordNum)+'+');
    end
    else
    begin
      //Writeln(textTestFile,' ������:'+intTostr(wordNum)+'-');
    end;  }




    if (((wordNum = 1) or (wordNum = {9}StrToInt(orbInf[3])+1)) and (flagCountFrase)) then
    begin
      //����� ������� �����
      //1 � 1 ���� 1 ����� 16 ����� 1 ������ � �� ����� ����� ������ �����
      if ((wordNum = 2)and(fraseNum=16)and(groupNum=1)and(flagCountGroup))then
      begin
        //Writeln(textTestFile,'����!'+' ������:'+intTostr(wordNum)+
            //' ������:'+intTostr(fraseNum)+' �������:'+intTostr(groupNum)+
            //' ������:'+intTostr(ciklNum)+' ???');
       { if ((wordBuf and 1) = 1) then
        begin
          //������ ����� ������
          bufNumGroup:=0;
          //������ ����� ������
          //bufNumGroup:=0;
          ciklNum:=1;

          flKadr:=True;
          //tlm.flagWriteTLM:=True; //!!!
          //form1.Memo1.Lines.Add('����!');
          //Writeln(textTestFile,'����!'+' ������:'+intTostr(wordNum)+
            //' ������:'+intTostr(fraseNum)+' �������:'+intTostr(groupNum)+
            //' ������:'+intTostr(ciklNum));
          //Writeln(textTestFile,'����!');
          //Writeln(textTestFile,' |');
          //Writeln(textTestFile,' v');
          //Writeln(textTestFile,'!!���� 1');
          //Writeln(textTestFile,' |');
          //Writeln(textTestFile,' v');
        end
        else
        begin
          //������ ����� �� ������
        end; }
      end;


      //Form1.Memo1.Lines.Add('����� � '+IntToStr(fraseNum));
      inc(fraseNum);
      if fraseNum = 129 then
      begin
        fraseNum := 1;
        //������ �����, ������ ������, ������ �����. ��������� ��������� ������ �����


        if ((wordNum = 1) and (groupNum = 1) and (ciklNum=1)) then
        begin
          if ((tlm.flagWriteTLM){and(flKadr)}) then
          begin
            flSinxC := true;     /// TO-DO
          end;
        end;
      end;

      //Writeln(textTestFile,'������:'+intTostr(fraseNum));
      //Writeln(textTestFile,' |');
      //Writeln(textTestFile,' v');
      //SaveBitToLog(' ����� '+IntToStr(fraseNum));
    end ;


    //���� ����� ������ �� �������� ����. 12 ��������.
    CalkWordBuf(countStep,stepToTransOrbOne,wordBuf);





    //���� ������� ������ ������
    //7 ��������� �������� �� �������� � ��������
    {if (((fraseNum=2)or(fraseNum=4)or(fraseNum=6)or(fraseNum=8)or
        (fraseNum=10)or(fraseNum=12)or(fraseNum=14))and(wordNum=1)
       ) then
    begin
      if ((wordBuf and 1) <> 0) then
      begin
        bufNumGroup := (bufNumGroup shl 1) + 1;
      end
      else
      begin
        bufNumGroup := (bufNumGroup shl 1) + 0;
      end;
    end; }


    //��������� ������ �����

    evenFraseAnalyze(wordNum,wordBuf,orbInf);

    //!!



    //�������� ����������, ����������� 12 � 1 ���
    if (flagCountFrase) then
    begin
      //������ � ������ � �������� ����� 11 ���
      masGroup[iMasGroup] := wordBuf and 2047;{((wordBuf and 2047) shr 1)} {wordBuf} //!!!
      //������ � ������ � �������� ����� 12 ���
      masGroupAll[iMasGroup] := wordBuf and 4095;{((wordBuf and 2047) shr 1)} {wordBuf} //!!!
      inc(iMasGroup);
      //���� �������� ����. � ������� ����� ������
      if (flSinxC) then
      begin
        //������ � ���� 12 ������ ��������(���� ������)
        masCircle[reqArrayOfCircle][imasCircle] := {((} wordBuf { and 2046) shr 1)};
        inc(imasCircle);
        //��������� �� ��������� �� ������ �����
        testFillCircleArr(imasCircle);
      end;
      //��������� �� ��������� �� ������ ������
      testFillGroupArr(iMasGroup);
    end;

    wordBuf := 0;
    //���� ����������� ��������� ����� ������ ����� �
    //�� ����� ����� ������ ������ 
    if ((wordNum = numWordInByte) and (flfl)) then
    begin
      flagCountFrase := true;
    end;

    //!!!
    if (flagEnd) then
    begin
      if (form1.PageControl1.ActivePageIndex <> 2) then
      begin
        form1.TimerOutToDia.Enabled := false;
      end;

      {data.}graphFlagSlowP := false;
      {data.}graphFlagTempP := false;
      {data.}graphFlagFastP := false;
      break;
    end;
    inc(wordNum);
  end;
end;
//==============================================================================

//==============================================================================
//������� ������ ������� ���������� ����� ������� �����
//==============================================================================
function TDataMoth.TestMFNull(curNumPoint:Integer;numNulls:integer):Boolean;
var
  bool:boolean;
  i:Integer;
begin
  bool:=true;
  for i:=1 to numNulls do
  begin
    if curNumPoint > FIFOSIZE then
    begin
      curNumPoint := 1;
    end;
    //Form1.Memo1.Lines.Add('����');
    //Form1.Memo1.Lines.Add(IntToStr(fifoMas[curNumPoint]));
    //Form1.Memo1.Lines.Add(IntToStr(fifoMas[curNumPoint+1]));
    //Form1.Memo1.Lines.Add(IntToStr(fifoMas[curNumPoint+2]));
    if fifoMas[curNumPoint] >= porog then
    begin
      bool:= false;
      break;
    end;
    Inc(curNumPoint);
  end;
  result:=bool;
end;
//==============================================================================

//==============================================================================
//������� ������ ������� ���������� ������ ������� �����
//==============================================================================
function TDataMoth.TestMFOnes(curNumPoint:Integer;numOnes:integer):Boolean;
var
  j:Integer;
  i:Integer;
  bool:Boolean;
  //flag:boolean;
begin
  bool:=true;
  //flag:=false;

  //TestSMFOutDate(10,curNumPoint,10);

 // if (not flag) then
  //begin
  //������������ � ������������������ ������ �������
  for j:=1 to numOnes do
  begin
    Dec(curNumPoint);
    if curNumPoint < 1 then
    begin
      curNumPoint := FIFOSIZE;
    end;
  end;
    //flag:=true;
  //end;

  //TestSMFOutDate(10,curNumPoint,10);

  for i:=1 to numOnes do
  begin
    if curNumPoint > FIFOSIZE then
    begin
      curNumPoint := 1;
    end;
    //Form1.Memo1.Lines.Add('�������');
    //Form1.Memo1.Lines.Add(IntToStr(fifoMas[curNumPoint]));
    //Form1.Memo1.Lines.Add(IntToStr(fifoMas[curNumPoint+1]));
    //Form1.Memo1.Lines.Add(IntToStr(fifoMas[curNumPoint+2]));
    if fifoMas[curNumPoint] < porog then
    begin
      bool:= false;
      break;
    end;
    Inc(curNumPoint);
  end;


  result:=bool;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function TDataMoth.QfindFraseMark: boolean;
var
  testRes: boolean;
begin
  testRes := false;

  //��������� ���. ����. �������
  if (QtestMarker(fifoLevelRead, {MARKMINSIZE}widthPartOfMF)) then
  begin
    testRes := true;
  end;
  {else
  begin
    //���������  ����. ����. �������
    if (QtestMarker(fifoLevelRead, MARKMAXSIZE)) then
    begin
      testRes := true;
    end;
  end;}
  result := testRes;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
function TDataMoth.QtestMarker(begNumPoint: integer; const pointCounter: integer): boolean;
var
  i: integer;
  j: integer;
  testFlag: boolean;
  m:integer;
begin
  //���������������� ������� ����� �������� �������
  i := begNumPoint;

  testFlag := false;

  if TestMFOnes(i,pointCounter) then
  begin
    if TestMFNull(i,pointCounter) then
    begin
      //��� ������
      testFlag:=true;
    end;
  end;
  {

  testFlag := true;
  //��������� ��� ������ ���������� ����������� ������ ������������
  for j := 1 to pointCounter do
  begin
    if i > FIFOSIZE then
    begin
      i := 1;
    end;

    {form1.Memo1.Lines.Add(inttostr(i-1220));
    form1.Memo1.Lines.Add(inttostr(i));

    for m:=i-3000 to i+3000 do
    begin
      form1.Memo1.Lines.Add(inttostr(m)+'   '+intTostr(fifoMas[m]));
    end;



    while (true) do application.processmessages; }







   { if fifoMas[i] < porog then
    begin
      testFlag := false;
      break;
    end;
    //!!!
    if (flagEnd) then
    begin
      testFlag := false;
      break;
    end;
    inc(i);
  end;
  //��������� ��� ����� ����. ����� ������ ��������� ������� �� �����
  if (testFlag) then
  begin
    for j := 1 to pointCounter do
    begin
      if i > FIFOSIZE then
      begin
        i := 1;
      end;
      if fifoMas[i] >= porog then
      begin
        testFlag := false;
        break;
      end;
      //!!!
      if (flagEnd) then
      begin
        testFlag := false;
        break;
      end;
      inc(i);
    end;
  end; }
  result := testFlag;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataMoth.FifoNextPoint(countPoint: integer);
var
  offset: integer;
begin
  //���������� ������� ������ ������
  if ((fifoLevelRead + countPoint) > FIFOSIZE) then
  begin
    //��������� �� ������� ������ ������������� �������� ������ ����� � ����. ������
    offset := (fifoLevelRead + countPoint) - FIFOSIZE;
    fifoLevelRead := offset
  end
  else
  begin
    fifoLevelRead := fifoLevelRead + countPoint;
  end;
  //��������. ����� �� �������� ���. ����� � �����. � fifoLevelRead
  fifoBufCount := fifoBufCount - countPoint;
end;
//==============================================================================


//==============================================================================
//������� ������ �������� �� 0 � 1
//==============================================================================
function TDataMoth.SearchP0To1(curPoint:Integer;nextPoint:integer):Boolean;
var
  bool:Boolean;
begin
  bool:=False;
  //��������� ������� ����� ����� �� 0 � 1
  if ((curPoint < porog) and (nextPoint >= porog)) then
  begin
    bool:=True;
  end;
  result:=bool;
end;
//==============================================================================

//==============================================================================
//������� ������ �������� �� 0 � 1
//==============================================================================
function TDataMoth.SearchP1To0(curPoint:Integer;nextPoint:integer):Boolean;
var
  bool:Boolean;
begin
  bool:=false;
  //��������� ������� ����� ����� �� 1 � 0
  if ((curPoint > porog) and (nextPoint <= porog)) then
  begin
    bool:=True;
  end;
  result:=bool;
end;
//==============================================================================

//=============================================================================
//
//=============================================================================
function TDataMoth.ReadFromFIFObuf: integer;
begin
  result := fifoMas[fifoLevelRead];
  inc(fifoLevelRead);
  if fifoLevelRead > {=} fifoSize then
  begin
    fifoLevelRead := 1;
  end;
  dec(fifoBufCount);
end;
//==============================================================================


//=============================================================================
//
//=============================================================================
procedure TDataMoth.WriteToFIFObuf(valueACP: integer);
begin
  if (form1.rb1.Checked) then
  begin
    fifoMas[fifoLevelWrite] := valueACP;
  end
  else
  begin
    if valueACP>porog then
    begin
      fifoMas[fifoLevelWrite] :=minValue ;
    end
    else
    begin
       fifoMas[fifoLevelWrite] :=maxValue ;
    end;
  end;


  inc(fifoLevelWrite);
  inc(fifoBufCount);
  if (fifoLevelWrite > fifoSize) then
  begin
    fifoLevelWrite := 1;
  end;
end;
//==============================================================================

//==============================================================================
//������� ��� ������ ������� �����. �� ���� ����� ����� � �����.������(������ ����������� ������� ��.)
//�� ������ ����� ����� � �����. ������(������ ����. ������� ��.).
//���������� �����. ����� ����� ��������� ��.
//==============================================================================
function TDataMoth.FindFraseMark(var fifoLevelRead: integer): integer;
var
  currentACPVal: integer;
  frMarkSize: integer;

  //ppp:integer;
  startSearch: boolean;
  fl: boolean;
  fl2: boolean;
  sizeFraseInPoint: integer;
  //iOut: integer;
  //m: integer;


  m:integer;

  //������� ������. �����
  iSearch: integer;
  downToUpFl: boolean;
  //���� ���������� ������ ������� �����
  searchOKfl: boolean;
  numPointFromFpToMf:Integer;
begin
  //���������� ����� �� �������
  {searchOKfl := false;
  frMarkSize := 0;
  sizeFraseInPoint := 0;
  //����� ������� ����� ����
  startSearch := false;
  //����� ��� ������ �������� �������� ������ ������
  downToUpFl := false;
  fl := false;
  fl2 := false;
  //���� ������ ����� � (3)2 �������� ����� ����� ����� ���������
  for iSearch := 1 to MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR * 2 do //3 �� 2
  begin
    if (not downToUpFl) then
    begin
      //��������� ������� �����
      currentACPVal := ReadFromFIFObuf;
      //+1 ����� � ������� ����� ����� ��������� ����
      inc(sizeFraseInPoint);
      if ((currentACPVal < porog) and (fifoMas[fifoLevelRead] >= porog)) then
      begin
        fl := true;
      end;
      if ((fl) and (currentACPVal >= porog)) then
      begin
        downToUpFl := true;
        startSearch := true;
        //���������������� ����� �������, ����������� �
        inc(frMarkSize);
      end;
    end;
    if (startSearch) then
    begin
      currentACPVal := ReadFromFIFObuf;
      //+1 ����� � ������� ����� ����� ��������� ����
      inc(sizeFraseInPoint);
      //ppp:=fifoMas[fifoLevelRead-1];
      if currentACPVal >= porog then
      begin
        inc(frMarkSize);
        fl2 := true;
      end;
      if ((fl2) and (currentACPVal < porog)) then
      begin
        if ((frMarkSize >= MARKMINSIZE) and (frMarkSize <= MARKMAXSIZE)) then
        begin
          if (TestMarker(fifoLevelRead - 1, MARKMAXSIZE)) then
          begin
            fifoBackPoint(frMarkSize + 1);
            searchOKfl := true;
            break;
          end
          else
          //�� ������
          begin
            searchOKfl := false;
            break;
          end;
        end;
        frMarkSize := 0;
        downToUpFl := false;
        startSearch := false;
        fl := false;
        fl2 := false;
      end;
    end;
  end;
  if (searchOKfl) then
  //���� ������
  begin
      //���������� ���������� ����� ����� ��������� ����
    result := sizeFraseInPoint - (frMarkSize + 1);
  end
  else
  //��� �������
  begin
    result := -1;
  end;}

  numPointFromFpToMf:=0;
  //��������� ����������� ������� �������� �� 0 � 1
  downToUpFl:=false;
  searchOKfl:=false;
  sizeFraseInPoint := 0;
  // � ���� ������ �����. ����� ����� ��������� ���� ������� �� 0 � 1
  for iSearch := 1 to {MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR}minSizeBetweenMrFrToMrFr * 2 do //3 �� 2
  begin
    //��������� ������� �����
    currentACPVal := ReadFromFIFObuf;
    //+1 ����� � ������� ����� ����� ��������� ����
    inc(sizeFraseInPoint);
    //��������� ������� ����� ����� �� 0 � 1
    //���� ������ ������� �����, �� ������ �� ����
    if ((SearchP0To1(currentACPVal,fifoMas[fifoLevelRead]))and(not downToUpFl)) then
    begin
      //����� ������ �������
      downToUpFl:=true;
      //TestSMFOutDate(5,fifoLevelRead,5);
    end;

    if (downToUpFl) then
    begin
      Inc(numPointFromFpToMf);
      //���� ����� ������� ����� �����
      if ((SearchP0To1(currentACPVal,fifoMas[fifoLevelRead]))or
         (SearchP1To0(currentACPVal,fifoMas[fifoLevelRead]))) then
      begin
        //dec(numPointFromFpToMf);//!! ��� ����� ������� ����� 
        //��������� �� ����� �� ������
        if ((Frac(numPointFromFpToMf/markKoef)>=0.25)and
           (Frac(numPointFromFpToMf/markKoef)<=0.75)) then
         begin
          //TestSMFOutDate(10,fifoLevelRead,10);
          //����� ������
          searchOKfl:=True;
          //����� �� ������
          Break;
         end;
      end;
    end;
  end;
  if (searchOKfl) then
  //���� ������
  begin
    //���������� ���������� ����� ����� ��������� ����
    result := sizeFraseInPoint {- (frMarkSize + 1)};
  end
  else
  //��� �������
  begin
    result := -1;
  end;
end;
//==============================================================================


//==============================================================================
//��������� ������ M08,04,02,01
//==============================================================================
procedure TDataMoth.TreatmentM8_4_2_1;
begin
  //��������� ����� ������� 3 ��������� ����� ����� ����� �������� ����
  while (fifoBufCount >= MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR * 2) do //!! 3 �� 2
  begin
     {while (flagTrue) do
      begin
      Application.ProcessMessages;
      end;}

    //���� ������ ����� ������
    if (not fraseMarkFl) then
    begin
      countPointMrFrToMrFr := FindFraseMark(fifoLevelRead);
      //TestSMFOutDate(20,fifoLevelRead,1230);
      //while (true) do application.processmessages;
      if ((countPointMrFrToMrFr = -1) and (not flagEnd)) then
      begin
        {showMessage('������ ������! ��������� ��������� �� ������ ��� ������� ������ � ����!');
        //closeFile(LogFile);
        acp.AbortProgram(' ', false);
        if ReadThreadErrorNumber <> 0 then
        acp.ShowThreadErrorMessage();
        //else form1.Memo1.Lines.Add(' The program was completed successfully!!!');
        //����
        halt;
        //���� ����� ������ , �� ���������� ������
        if hReadThread <> THANDLE(nil) then
        begin
          //������� �����
          //EndThread(hReadThread);
          CloseHandle(hReadThread);
          sleep(50);
          showMessage('��������� ���� ���������');
          halt;
        end;}
      end;
      //��� ������ ������ ���. �� ����������
      countPointMrFrToMrFr := 0;
      //������ ������ ����� �����
      fraseMarkFl := true;
    end
    else
    //����� ������ �����
    begin
      if (not qSearchFl) then
      begin
        qSearchFl := true;
      end
      else
      begin
        Inc(countForMF);
        //������������� �� ������ ���������� ����� ������
        FifoNextPoint({MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR}minSizeBetweenMrFrToMrFr);
        //FifoNextPoint(10);
        //TestSMFOutDate(10,fifoLevelRead,10);
        //����. ������� ������� �����
        if (QfindFraseMark) then
        begin
          //form1.Memo1.Lines.Add('1220');
          //Writeln(textTestFile,'1220');
          //TestSMFOutDate(10,fifoLevelRead,10);
          //FifoBackPoint(6); //!!!
          //TestSMFOutDate(10,fifoLevelRead,10);
          //orbOk:=True;
          //Form1.Memo1.Lines.Add(IntToStr(fifoLevelRead)+' '+'1220'+' --');

          FillMasGroup(minSizeBetweenMrFrToMrFr, fifoLevelRead,infStr, {data.}iMasGroup);
        end
        else
        begin
          //��������� � �������� ����� ������
          FifoBackPoint(minSizeBetweenMrFrToMrFr);
          //FifoBackPoint(10);
          //������������� �� ������ ���������� ����� ������
          FifoNextPoint(minSizeBetweenMrFrToMrFr + 1);
          //FifoNextPoint(11);
          //����. ������� ������� �����
          if (QfindFraseMark) then
          begin
             //form1.Memo1.Lines.Add('1221');
             //Writeln(textTestFile,'1221');
            // TestSMFOutDate(10,fifoLevelRead,10);
            //FifoBackPoint(6); //!!!
            //TestSMFOutDate(10,fifoLevelRead,10);
            //orbOk:=True;

            //Form1.Memo1.Lines.Add(IntToStr(fifoLevelRead)+' '+'1221'+' --');

            FillMasGroup(minSizeBetweenMrFrToMrFr + 1, fifoLevelRead, infStr, {data.}iMasGroup);
          end
          else
          begin
            //������� ����� �� �����
            //��������� � �������� ����� ������.
            FifoBackPoint(minSizeBetweenMrFrToMrFr + 1);
            //��������� �� 2 ����� ������ ����� �� ����� ���������� ������
            FifoNextPoint(2);
            //FifoBackPoint(11);
            //TestSMFOutDate(1230,fifoLevelRead,1230);
            //while (True) do Application.ProcessMessages;
            //������� ������� ������ �� �����, ���� ��������
            countPointMrFrToMrFr := FindFraseMark(fifoLevelRead);
            //��������� 2 ����� � ������� �.� ���������� �� ��� ������
            countPointMrFrToMrFr:=countPointMrFrToMrFr+2;

            //Form1.Memo1.Lines.Add(IntToStr(fifoLevelRead)+' ++');


            Inc(countErrorMF);
            //Form1.Memo1.Lines.Add(IntToStr(countErrorMF)+' '+IntToStr(fifoLevelRead)+' '+IntToStr(countPointMrFrToMrFr));

            if countForMF={100}127 then
            begin
              //while (True) do Application.ProcessMessages; //!!!!
              countForMF:=0;
              //����� ����� �� ������� ����� �� �����
              OutMF(countErrorMF);
              //��������� ���� �� �� ��������� �� � �� �� �������� �������
              if countErrorMF={100}127 then
              begin
                OutMG(31);
              end;
              countErrorMF:=0;
            end;

            //Writeln(textTestFile,intToStr(countPointMrFrToMrFr));
            //form1.Memo1.Lines.Add(IntToStr(countPointMrFrToMrFr));
            if ((countPointMrFrToMrFr = -1) and (not flagEnd)) then
            begin
              {showMessage('������ ������! ��������� ��������� �� ������ � ������ � ����!');
              halt;}
            end;
            FillMasGroup(countPointMrFrToMrFr, fifoLevelRead,infStr, {data.}iMasGroup);
          end;
        end;
      end;
      //�������� ������� ��� �������� ���������� �������� �����
      if countForMF={100}127 then
      begin
        countForMF:=0;
        OutMF(countErrorMF);
        countErrorMF:=0;
      end;
    end;
  end;
  {if orbOk=False then
  begin
    CloseFile(textTestFile);
    data.graphFlagFastP := false;

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
    wait(100);
    form2.show;
  end;}
end;
//==============================================================================

end.
