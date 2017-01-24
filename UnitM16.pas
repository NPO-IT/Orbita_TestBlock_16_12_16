unit UnitM16;

interface
uses
  LibUnit,OutUnit;

type
  TDataM16=class(TObject)
    //������� ���������� ������������� ����� ���� ������
    numRetimePointUp: integer;
    //������� ���������� ������������� ����� ���� ������
    numRetimePointDown: integer;
    //���� ������������ ��� ������ ����� �������
    firstFraseFl: boolean;
    //������� ��� ����� 12 ����. ����� ������
    iBit: integer;
    //���������� ����������� ����. ���������� ����� � �����.
    bitSizeWord: integer;
    //���������� ����� ����� ������� ������ �������� ����. ������
    pointCount: integer;
    //������� �������� ��������� �� ���������� ������
    current: integer;
    //���� ������ ����, ��� �� ����� ���� ������� 128 �����
    flagOutFraseNum: boolean;
    //���������� ��� ���� ���������� ��������� �����
    myFraseNum: integer;
    //�����������. 8 �����.
    markerNumGroup: byte;
     //��� ��������� ������� ������� �������� ����� � ����
    nMarkerNumGroup: integer;
    //��������. 8 �����
    markerGroup: byte;
    //��� ����� ���� ������
    flagL: boolean;
    //�����. 11 ����. ����� ������. �� �������
    wordInfo: integer;

    procedure add(signalElemValue: integer);
    //��������� ������� ��� M16
    procedure treatmentM16;
    //�����������
    constructor createData;
    //������ �����
    procedure AnalyseFrase;
    //����� ������� �����
    procedure SearchFirstFraseMarker;
    procedure WordProcessing;
    //������ ���� ������ � �����
    procedure FillBitInWord;
    function Read(): integer; overload;
    function Read(offset: integer): integer; overload;
    //���� ������� ������ ������
    procedure CollectMarkNumGroup;
    //���� ������� ������
    procedure CollectMarkGroup;
    //���������� ������� ������
    procedure FillArrayGroup;
    //���������� ������� �����
    procedure FillArrayCircle;
  end;

implementation
uses
  OrbitaAll,ACPUnit;




//==============================================================================
//
//==============================================================================
constructor TDataM16.createData;
begin
  //�������� ��� �������� ���������� ����� ���� � ���� ������
  numRetimePointUp := 0;
  numRetimePointDown := 0;
  //���������� ���� ��� ������ ������ �����
  firstFraseFl := false;
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
  iBit := 1;
  //����. ����������� �����
  bitSizeWord := 12;
  pointCount:=0;
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
  flagOutFraseNum := false;
  groupWordCount:=1; //!!
  //������� ���� ,��������� ����� ����������� � 1. ����� � 1 �� 128.
  myFraseNum := 1;
  //��������� ����. ������� ������ ������
  markerNumGroup := 0;
  //��������� �������� ������� ������
  nMarkerNumGroup := 1;
  //��������� ����. ������� ������
  markerGroup := 0;
  countEvenFraseMGToMG:=0;
  //��������� ����. ���������� ��� ������� ������� ������ �16
  flagL := true;
  countForMG:=1;
  countErrorMG:=0;
  iMasCircle := {0}1;
  analogAdrCount:=0;
  contactAdrCount:=0;
  tempAdrCount:=0;
  numP := 0;
  numPfast := {0}1;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataM16.FillArrayCircle;
begin
  masCircle[reqArrayOfCircle][imasCircle] := codStr;
  inc(imasCircle);
  //��������� 65535 ���������
  if imasCircle = {length(masCircle[reqArrayOfCircle])}masCircleSize+1 then
  begin
    imasCircle := 1;

    //Form1.Memo1.Lines.Add('���� �'+intTostr(ciklNum)+' '+'������ �'+intTostr(groupNum)
    //+' '+'����� �'+intTostr(fraseNum)+' '+'����� �'+intTostr(wordNum));


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
procedure TDataM16.FillArrayGroup;
begin
  //����� ������� 11 ��������. ������� �����������. ��-������� ���.
  wordInfo := (codStr and 2047) {shr 1};
  //12 �����
  masGroupAll[groupWordCount] := codStr;
  masGroup[groupWordCount] := wordInfo;
  inc(groupWordCount);
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataM16.CollectMarkGroup;
begin
  //��������� 12 ���, ���� ��� 1 �� � ����� ������� ������� 1
  if ((codStr and 2048) = 2048) then
  begin
    markerGroup := (markerGroup shl 1) or 1;
  end
  else
  begin
    //0 � ����� ������� ������� 0
    markerGroup := markerGroup shl 1;
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataM16.CollectMarkNumGroup;
begin
  if ((fraseNum = 2) or (fraseNum = 4) or (fraseNum = 6) or (fraseNum = 8) or
    (fraseNum = 10) or (fraseNum = 12) or (fraseNum = 14)
    ) then
  begin
    //��������� 12 ���, ���� ��� 1
    //�� � ����� ������� ������� 1
    if ((codStr and 2048) = 2048) then
    begin
      markerNumGroup := (markerNumGroup shl 1) or 1;
    end
    else
      //0 � ����� ������� ������� 0
    begin
      markerNumGroup := markerNumGroup shl 1;
    end;
    if fraseNum = 14 then
    begin
      inc(nMarkerNumGroup);
      markerNumGroup := 0;
    end;
  end;
end;

//=============================================================================

//=============================================================================
//������ �������� �� ������ ������
//=============================================================================
function TDataM16.Read(): integer;
begin
  result := fifoMas[fifoLevelRead];
  inc(fifoLevelRead);
  if fifoLevelRead > FIFOSIZE then
  begin
    fifoLevelRead := 1;
  end;
  dec(fifoBufCount);
end;
//=============================================================================

//==============================================================================
//������� ��� ������ �� ������� ���� ����� ������ ���������
//offset -����� ��� ������ ����������� ���������
//============================================================================
function TDataM16.Read(offset: integer): integer;
var
  fifoOffset: integer;
begin
  //�������� �������� ��� ���������� �������
  offset := offset - 1;
  if fifoLevelRead + offset > FIFOSIZE then
  begin
    fifoOffset := (fifoLevelRead + offset) - FIFOSIZE;
  end
  else
  begin
    fifoOffset := fifoLevelRead + offset;
  end;
  result := fifoMas[fifoOffset];
end;
//============================================================================


//==============================================================================
//���������� ���� ���. ����� � ����� ������
//==============================================================================
procedure TDataM16.FillBitInWord;
begin
  //��������� �������� �� �����. ������ �������� �������� ������
  current := Read;
  //���������� � ������� �������� 12 ��������� �����
  if current = 1 then
  begin
    codStr := (codStr shl 1) or 1;
  end
  else
  begin
    codStr := codStr shl 1;
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure TDataM16.AnalyseFrase;
begin
  //��� ������ � ���. ��� ������ � ������� �����
  if (flBeg) then
  begin
    if((wordNum = 1)and(fraseNum=1)and(groupNum=1)and(ciklNum=1))then
    begin
      flSinxC := true;
    end;
  end;

  if (flKadr) then
  begin
    if((wordNum = 1)and(fraseNum=1)and(groupNum=1)and(ciklNum=1))then
    begin
      //startWriteMasGroup := true;  //!!!
    end;
  end;

  //���� 12 ������� ������������ �����
  while iBit <= bitSizeWord do
  begin
    {������� ��� �������� ����� �� 383. ��� �������� ������ ������� �����}
    if pointCount = -1 then
    begin
      //����� ����� ����������� �������
      firstFraseFl := false;
      break;
    end;
    dec(pointCount);

    FillBitInWord;

    //������� 12 ������ ����������� �����
    //���������� ���
    WordProcessing;

    //� ������� ������. �����. ������ � ��� ����� �� ����������
    if (flagEnd) then
    begin
      if (form1.PageControl1.ActivePageIndex <> 2) then
      begin
        form1.TimerOutToDia.Enabled:=False;
      end;

      graphFlagSlowP := false;
      graphFlagFastP:= false;
      graphFlagTempP:= false;
      break;
    end;
    //������. ������� ����� ���. ����� ������
    inc(iBit);
    if iBit = 13 then
    begin
      iBit := 1;
    end;

  end;
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
procedure TDataM16.SearchFirstFraseMarker;
begin
  //������ �������� ������� ����� � ��������� ������
  current := Read;
  Inc(countForMF);
  //���� ������ �������� �����.
  //����� 24 �.� ����������� ������ ���� �������� ���� ������� � �������� ����� � ���������� ������
  if ((current = 0) and (Read(24) = 1) and (Read(48) = 1) and
      (Read(72) = 1) and (Read(96) = 1) and (Read(120) = 0) and
      (Read(144) = 0) and (Read(168) = 0) and (Read(216) = 1) and
      (Read(240) = 0) and (Read(264) = 0) and (Read(288) = 1) and
      (Read(312) = 1) and (Read(336) = 0) and (Read(360) = 1)) then
  begin
    //����� ������ ������ �������� ����� � � ���������� ����� ��� ���������
    firstFraseFl := true;
    //������� ���������� (����� ����� ������)����� ����� ������� ������ ����� ������ �����������
    pointCount := 383;
    //���������� �� ������� �����
    dec(fifoLevelRead);
    inc(fifoBufCount);
  end
  else
  begin
    Inc(countErrorMF);
  end;

  if countForMF={100}127 then
  begin
    countForMF:=0;
    OutMF(countErrorMF);
    //Form1.Memo1.Lines.Add(IntToStr(22));
    countErrorMF:=0;
  end;
end;
//==============================================================================



//==============================================================================
//
//==============================================================================

procedure TDataM16.add(signalElemValue: integer); //value= signalElemValue
var
  iOutInFile: integer;
begin
  //����
  if signalElemValue >= porog then
  begin
    //������� ����
    inc(numRetimePointUp);
    //����������� ������� ����� ���� ������
    outStep := round(numRetimePointDown / (10 / 3.145728));
    //���� ��� ���������� �������, �� 1
    if ((numRetimePointUp = 1)and(outStep = 0)) then
    begin
      outStep := 1;
    end;

    for iOutInFile := 1 to outStep do
    begin
      //� ����������� �� ������ ���� ������� ���������� ��� ���������� ��������
      if (form1.rb1.Checked) then
      begin
        fifoMas[fifoLevelWrite] := 0;
      end;

      if (form1.rb2.Checked) then
      begin
        fifoMas[fifoLevelWrite] := 1;
      end;

      //fifoMas[fifoLevelWrite] := 0;



      inc(fifoLevelWrite);
      //������� �������� ����� � �������
      inc(fifoBufCount);
      if (fifoLevelWrite > FIFOSIZE) then
      begin
        fifoLevelWrite := 1;
      end;
    end;
    numRetimePointDown := 0;
  end
  else
  begin
    //������� ����
    inc(numRetimePointDown);
    //����������� ������� ����� ���� ������
    outStep := round(numRetimePointUp / (10 / 3.145728));
    if ((numRetimePointDown = 1)and(outStep = 0)) then
    begin
      outStep := 1;
    end;
    for iOutInFile := 1 to outStep do
    begin

      //fifoMas[fifoLevelWrite] := 1;
      //� ����������� �� ������ ���� ������� ���������� ��� ���������� ��������
      if (form1.rb1.Checked) then
      begin
        fifoMas[fifoLevelWrite] := 1;
      end;

      if (form1.rb2.Checked) then
      begin
        fifoMas[fifoLevelWrite] := 0;
      end;


      inc(fifoLevelWrite);
      //������� �������� ����� � �������
      inc(fifoBufCount);
      if (fifoLevelWrite > FIFOSIZE) then
      begin
        fifoLevelWrite := 1;
      end;
    end;
    numRetimePointUp := 0;
  end;
end;
//==============================================================================

//==============================================================================
//��������� ������ M16
//==============================================================================
procedure TDataM16.treatmentM16;
begin
  //���� ����� � ����� ������ ������ ����� �����, ���������
  while ((fifoBufCount >= 100000)and(not flagEnd)) do  ///!!!
  begin
    //����� ������� ������ �������� �����
    //����� ���������� ������ ���
    if (not firstFraseFl) then
    begin
      SearchFirstFraseMarker;
      //form1.tmrForTestOrbSignal.Enabled:=True;
    end
    else
    begin
      //���� ����� ������ �� ���������� ������
      AnalyseFrase;
    end;
    // � ������ ������ ����� �� ����������
    {if flagEnd then
    begin
      break;
    end;}
  end;

  //��������� ��� � ������ ��� ����� ������ �� ������������� 200 � ������.
  //��� �������
  if acp.SignalPorogCalk(round(buffDivide/10), buffer,RequestNumber)<=200 then   ///!!! round(buffDivide/10)
  begin
    outMF(127);
    //Form1.Memo1.Lines.Add('11');
    outMG(31);
  end;
end;
//==============================================================================

//==============================================================================
//��������� ����� ������
//==============================================================================
procedure TDataM16.WordProcessing;
begin
  if iBit = bitSizeWord then
  begin
    //���� ����� ����� 1 ������ ��� ����� �����
    if wordNum = 1 then
    begin
      //form1.Memo1.Lines.Add('����� �'+IntToStr(fraseNum));
      //��������� ��� �� ����� ����� 128 �����.
      if (flagOutFraseNum) then
      begin

        //Form1.Memo1.Lines.Add('#����� '+intToStr(wordNum)+' #����� '+intToStr(fraseNum)+
        //'#������ '+intToStr(groupWordCount));
        //����� ������� �����
        //1 � 1 ���� 1 ����� 16 ����� 1 ������
        if ((wordNum = 1)and(fraseNum=16)and(groupNum=1))then
        begin
          if ((codStr and {1}2048) = {1}2048) then
          begin
            //������ ����� ������
            //bufNumGroup:=0;
            ciklNum:=1;

            flKadr:=True;
            //tlm.flagWriteTLM:=True; //!!!
            //form1.Memo1.Lines.Add('����!');

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
          end;
        end;


        {if fraseNum=126 then
         begin
          SaveBitToLog('����� 126:'+codStr);
         end;}
        //SaveBitToLog('����� �'+IntToStr(fraseNum)+' ');
        //Writeln(textTestFile,'�����:'+intTostr(fraseNum));
        if fraseNum = 1 then
        begin
          //�������� � 1 �.� ������ ������ � 1
          groupWordCount := {0}1;
          //��������� ������ � ������ ������
          //startWriteMasGroup := true;  //!!
        end;
      end;



      //-----------------------
      //����� ������� ������
      //-----------------------
      //������� ������ �����
      if (myFraseNum mod 2 = 0) then
      begin
        //���� ������� ������ ������
        CollectMarkNumGroup;
        //���� ������� ������
        CollectMarkGroup;

        Inc(countEvenFraseMGToMG);

        //��������� �� ������� �� ������� ������ ��� ������ �����
        if ((markerGroup = 114) or (markerGroup = 141)) then
        //����� ������
        begin
          if fraseNum <> 128 then
          begin
            if flagL = true then
            begin
              fraseNum := 128;
            end;
            flagL := true;
          end;
          if fraseNum = 128 then
          begin
            flagL := false;

            //---------------------------
            if markerGroup = 114 then
            //����� ������ ������
            begin
              //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' ��'); //TO-DO <><><>
              Inc(countForMG);

              //form1.Memo1.Lines.Add('������:'+intTostr(groupNum));
              //Writeln(textTestFile,' ^');
              //Writeln(textTestFile,' |');
              //Writeln(textTestFile,'������:'+intTostr(groupNum));
              Inc(groupNum);
              if groupNum=33 then
              begin
                groupNum:=1;
              end;

              //+1 ��
              if countEvenFraseMGToMG<>64 then
              begin
                //���� �� �� ����
                Inc(countErrorMG);
              end;

              if countForMG={100}32 then
              begin
                //������� ����� ����� �� ��
                OutMG(countErrorMG);
                countErrorMG:=0;
                countForMG:=1;
              end;

              countEvenFraseMGToMG:=0;
              //�������� c��� � ������ ������ �������
              //data.groupWordCount:=0;
              //��������� ������ � ������ ������
              startWriteMasGroup:=true; ///!!
            end;

            //----------------------------
            //����
            //----------------------------
            if markerGroup = 141 then
            //����� ������ �����
            begin
              //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' ��');
              countEvenFraseMGToMG:=0;
              //Writeln(textTestFile,' ^');
              //Writeln(textTestFile,' |');
              //Writeln(textTestFile,'������:'+intTostr(groupNum));
              groupNum:={32}1;
              //form1.Memo1.Lines.Add('����:'+intTostr(ciklNum));
              //Writeln(textTestFile,' ^');
              //Writeln(textTestFile,' |');
              //Writeln(textTestFile,'����:'+intTostr(ciklNum));
              Inc(ciklNum);
              if ciklNum=5 then
              begin
                ciklNum:=1;
                if ((tlm.flagWriteTLM)and(flKadr)) then
                begin
                  flBeg := true;
                end;
              end;

              //SaveBitToLog('����� ������ '+'32');
//               flBeg := false;
//                if ((tlm.flagWriteTLM)and(flKadr)) then
//                begin
//                  flBeg := true;
//                end;
            end;
            //----------------------------
            markerGroup := 0;
            //����������� ����� ������ ������ ������
            flagOutFraseNum := true;
          end;
        end
      end;

      //----------------------------------
      inc(myFraseNum);
      //��������� ��������� ����,
      //��� ���� ����� �� ����� �� �������.
      //��� ��������� ���������.
      if myFraseNum = 129 then
      begin
        myFraseNum := 1;
      end;
      //form1.Memo1.Lines.Add('�����:'+intTostr(fraseNum));
      //Writeln(textTestFile,'�����:'+intTostr(fraseNum));
      inc(fraseNum);
      //��������� ��������� ����,
      //��� ���� ����� �� ����� �� �������.
      //��������� ��� ������.
      if fraseNum = 129 then
      begin
        fraseNum := 1;
        //groupWordCount := {0}1;
      end;
    end;

    // � ������� ����� ���������������� 12 ���,
    // �� ��� ������� �������� �����
    //����� ������ ����� � ���������� ��������
    //SaveBitToLog('C���o �'+IntToStr(wordNum)+
    //' �������� �����:'+IntToStr(codStr));
    if (startWriteMasGroup) then
    begin
      FillArrayGroup;
      //���� �������� ����. � ������� (�����)����� ������
      if (flSinxC) then
      begin
        FillArrayCircle;
      end;
      //��������� �� �������� �� ������ ������
      // ����������� ����� � 0 �� 2047. ������� 2048
      if groupWordCount = masGroupSize+1 then
      begin
        OutDate;
      end;
    end;
    codStr := 0;
    inc(wordNum);


    if wordNum = 17 then
    begin
      //���������
      wordNum := 1;
    end;
  end;
end;
//==============================================================================
end.
