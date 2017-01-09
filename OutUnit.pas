unit OutUnit;

interface
uses
  Messages,Forms,Windows,SysUtils,TestUnit_N1_1;
    //����� ������ �� �������
    procedure OutDate;
    //����� �� ��������� ���������� �������
    procedure  outToDiaCGeneral;
    procedure testFillGroupArr(var imasGroup:Integer);
    //����� �� ��������� ��������� �������
    procedure  outToDiaSGeneral;
    //����� ���������� ������ �� �����������
    procedure OutToGistGeneral;
    //����� �� ����������� ����������
    procedure OutToGistSlowAnl(firstPointValue: integer; outStep: integer;
      masOutSize: integer; var numP: integer;typeOfAdr:integer);
    //����� �� ����������� �������������
    procedure OutToGistTemp(firstPointValue: integer; outStep: integer;
      masOutSize: integer; var numP: integer);
    //����� �� ����������� �������
    procedure OutToGistFastParam(firstPointValue: integer; outStep: integer;
      masOutSize: integer; adrtype: {short}integer;
      var numPfast: integer; numBitOfValue: integer);
    //���� �������� ��������� T22
    function BuildFastValueT22(value: integer; fastWordNum: integer): integer;
    //���� �������� ��������� T24
    function BuildFastValueT24(value: integer; fastWordNum: integer): integer;
    //���� ����������� ���������
    function OutputValueForBit(value: integer; bitNum: integer): {short}integer;
    procedure outToDia(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
      numBitOfValue: {short}integer; busTh: {short}integer; busAdr: {short}integer;var numOutPoint: {short}integer;
      flagGroup:Boolean;flagCikl:Boolean);
    procedure outToDiaAnl(outStep:integer;var numOutPoint:{short}integer;
      firstPointValue:integer;var numChanel: integer;maxPointInAdr:integer;typeAdr:integer);
    procedure outToDiaCont(outStep: integer;var numOutPoint: {short}integer;
      firstPointValue: integer;var numChanel: integer;numBitOfValue: short;maxPointInAdr:integer);
    procedure outToDiaFastT21(outStep:integer;var numOutPoint:{short}integer;
      firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
    procedure outToDiaFastT22(outStep:integer;var numOutPoint:{short}integer;
      firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
    procedure outToDiaFastT24(outStep:integer;var numOutPoint:{short}integer;
      firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
    procedure outToDiaTemp(outStep:integer;var numOutPoint:{short}integer;
      firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
    procedure OutToGistBusParam(firstPointValue: integer;outStep: integer;
      masOutSize: integer; adrtype: short;var numPfast: integer; numBitOfValue: integer);
    //����� �� ��������� ������������� �������
    procedure  outToDiaTGeneral;
    //����� �� ��������� �������������
    procedure outToDiaForTemp(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
        numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
    //����� �� ��������� ���������
    procedure outToDiaForSlow(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
        numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
    //����� �� ��������� ����������
    procedure outToDiaForCont(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
        numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);    
implementation
uses
  OrbitaAll,LibUnit;


  
//==============================================================================
//����� �� ��������� ����������
//==============================================================================
procedure {TData.}outToDiaForCont(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  maxPointInAdr: integer;
begin
  //��������� ��� ������� ������� ��������� � ����������
  if form1.PageControl1.ActivePageIndex = 0 then
  begin
    //��������� ���������� ����� � ��������� ������
    maxPointInAdr := 0;
    nPoint := firstPointValue;
    while nPoint <= masOutSize do
    begin
      inc(maxPointInAdr);
      nPoint := nPoint + outStep;
    end;

    //����� ��� ���������� ������� 1
    if typeOfAddres = 1 then
    begin
//      Form1.Memo1.Lines.Add('������� '+intToStr(groupNum));
//      while (flagTrue) do
//      begin
//        Application.ProcessMessages;
//      end;

      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����
        if isInGroup(groupNum,numChanel) then
        begin
         outToDiaCont(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
        end;
      end
      else if (flagCikl) then
      begin
        if isInCikl(ciklNum,numChanel) then
        begin
          //���������� �������� ����� �� ���������� ������
          if (flagGroup) then
          begin
            //���������� �������� ����� �� ���������� �����
            if isInGroup(groupNum,numChanel) then
            begin
              outToDiaCont(outStep,numOutPoint,firstPointValue,
                numChanel,numBitOfValue,maxPointInAdr);
            end;
          end
          else
          begin
            outToDiaCont(outStep,numOutPoint,firstPointValue,
              numChanel,numBitOfValue,maxPointInAdr);
          end;
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaCont(outStep,numOutPoint,firstPointValue,numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;
end;
//==============================================================================
  
//==============================================================================
//����� �� ��������� ���������
//==============================================================================
procedure outToDiaForSlow(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  maxPointInAdr: integer;
begin
  //��������� ��� ������� ������� ��������� � ����������
  if form1.PageControl1.ActivePageIndex = 0 then
  begin
    //��������� ���������� ����� � ��������� ������
    maxPointInAdr := 0;
    nPoint := firstPointValue;
    while nPoint <= masOutSize do
    begin
      inc(maxPointInAdr);
      nPoint := nPoint + outStep;
    end;

    //����� ��� ��������� 0 � 8 . �01 � �01-01
    if ((typeOfAddres = 0)or(typeOfAddres = 8)) then
    begin
//      Form1.Memo1.Lines.Add('������� '+intToStr(groupNum));
//      while (flagTrue) do
//      begin
//        Application.ProcessMessages;
//      end;

      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����
        if isInGroup(groupNum,numChanel) then
        begin
           outToDiaAnl(outStep,numOutPoint,firstPointValue,
                numChanel,maxPointInAdr,typeOfAddres);
        end;
      end
      else if (flagCikl) then
      begin
        if isInCikl(ciklNum,numChanel) then
        begin
          //���������� �������� ����� �� ���������� ������
          if (flagGroup) then
          begin
            //���������� �������� ����� �� ���������� �����
            if isInGroup(groupNum,numChanel) then
            begin
               outToDiaAnl(outStep,numOutPoint,firstPointValue,
                numChanel,maxPointInAdr,typeOfAddres);
            end;
          end
          else
          begin
             outToDiaAnl(outStep,numOutPoint,firstPointValue,
                numChanel,maxPointInAdr,typeOfAddres);
          end;
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
         outToDiaAnl(outStep,numOutPoint,firstPointValue,numChanel,maxPointInAdr,typeOfAddres);
      end;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//����� �� ��������� �������������
//==============================================================================
procedure outToDiaForTemp(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  //���������� ��� ���������� ����������
  //����� ��� ������� ������ ����������� ������
  //���������� ��������������� � ����� ��� �����������
  //����������� ������ ����� �� �����
  maxPointInAdr: integer;
begin
  //��������� ��� ������� ������� �������������
  if form1.PageControl1.ActivePageIndex = 2 then
  begin
    //��������� ���������� ����� � ��������� ������
    maxPointInAdr := 0;
    nPoint := firstPointValue;
    while nPoint <= masOutSize do
    begin
      inc(maxPointInAdr);
      nPoint := nPoint + outStep;
    end;

    //����� ��� ������������� �������   7
    if typeOfAddres = 7 then
    begin
//      Form1.Memo1.Lines.Add('������� '+intToStr(groupNum));
//      while (flagTrue) do
//      begin
//        Application.ProcessMessages;
//      end;

      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����
        if isInGroup(groupNum,numChanel) then
        begin
          outToDiaTemp(outStep,numOutPoint,firstPointValue,
            numChanel,numBitOfValue,maxPointInAdr);
        end;
      end
      else if (flagCikl) then
      begin
        if isInCikl(ciklNum,numChanel) then
        begin
          //���������� �������� ����� �� ���������� ������
          if (flagGroup) then
          begin
            //���������� �������� ����� �� ���������� �����
            if isInGroup(groupNum,numChanel) then
            begin
              outToDiaTemp(outStep,numOutPoint,firstPointValue,
                numChanel,numBitOfValue,maxPointInAdr);
            end;
          end
          else
          begin
            outToDiaTemp(outStep,numOutPoint,firstPointValue,
              numChanel,numBitOfValue,maxPointInAdr);
          end;
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaTemp(outStep,numOutPoint,firstPointValue,numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;
end;
//==============================================================================  

//==============================================================================
//����� �� ��������� �������������  �������
//==============================================================================
procedure  outToDiaTGeneral;
var
  orbAdrCount: integer;
  //testI:Integer;
begin
  //������������� ������� ��������� ������ ������.
  orbAdrCount := 0;
  //������� ��� �������� ���������� ���������� �������
  {data.}tempAdrCount := 0;
  //form1.tempDia.Series[0].Clear;
//  if outTempAdr=acumTemp*5 then
//  begin
//    form1.tempDia.Series[0].Clear;
//    outTempAdr:=0;
//  end;



  //Form1.Memo1.Lines.Add('1');
  //sleep(3);
  //��������������� ��������� ������ �� ������� ������
  //������, �������� ������ �������� � ������� �� ������
  while orbAdrCount <= iCountMax-1 do // iCountMax-1
  begin
    if  masElemParam[orbAdrCount].adressType=7 then
    begin
      outToDiaForTemp(
      masElemParam[orbAdrCount].numOutElemG,
      masElemParam[orbAdrCount].stepOutG,
      masGroupSize,orbAdrCount,
      masElemParam[orbAdrCount].adressType,
      masElemParam[orbAdrCount].bitNumber,
      masElemParam[orbAdrCount].numOutPoint,
      masElemParam[orbAdrCount].flagGroup,
      masElemParam[orbAdrCount].flagCikl);
    end;
    inc(orbAdrCount);
  end;
end;
//==============================================================================

//==============================================================================
//������� ��� ��������� �������� ���� �� ������ ���� � ����������������� ��������
//==============================================================================

function OutputValueForBit(value: integer; bitNum: integer): {short}integer;
var
  sdvig: integer;
begin
  //�������� �� 1 ��� ������, ��� ��� ����
  //�������� �������� �� ��������� �� ���� ��� ���� ��������
  value := value shr 1;
  sdvig := -1;
  case bitNum of
    1:
    begin
      sdvig := 9;
    end;
    2:
    begin
      sdvig := 8;
    end;
    3:
    begin
      sdvig := 7;
    end;
    4:
    begin
      sdvig := 6;
    end;
    5:
    begin
      sdvig := 5;
    end;
    6:
    begin
      sdvig := 4;
    end;
    7:
    begin
      sdvig := 3;
    end;
    8:
    begin
      sdvig := 2;
    end;
    //9 � 10. ��� ���� T05 �� 10 ���
    9:
    begin
      sdvig := 1;
    end;
    10:
    begin
      sdvig := 0;
    end;
  end;
  //��������� ���������� �� ��� ����� �������� ��� �������
  if ((value shr sdvig) and 1 = 1) then
  begin
    result := 1
  end
  else
  begin
    result := 0;
  end;
end;
//==============================================================================

//==============================================================================
//���� �������� �������� T22
//�� ���� �������� 12 ��������� ��������
//==============================================================================
function BuildFastValueT24(value: integer; fastWordNum: integer): integer;
var
  //����� �������. �������� 6 ��������� ��������
  fastValBuf: byte;
begin
  fastValBuf := 0;
  //�������� ������ ����� �������. ������� 6 ���
  if fastWordNum = 1 then
  begin
    fastValBuf:=value and 63;
  end;
  //�������� ������ ����� �������. ������� 6 ���
  if fastWordNum = 2 then
  begin
    fastValBuf:=value and 4032;
  end;
  result := fastValBuf;
end;
//==============================================================================

//==============================================================================
//���� �������� �������� T22
//�� ���� �������� 12 ��������� ��������
//==============================================================================
function BuildFastValueT22(value: integer; fastWordNum: integer): integer;
var
  //����� �������
  fastValBuf: word;
begin
  fastValBuf := 0;
  //�������� ������ ����� �������
  if fastWordNum = 1 then
  begin
    //��������� 12 ���. ������� 17
    {fastValBuf:=value shl 5;
    //��������� 6 �����. �����. 11 ��� ���. ���� 5. 5 ������� �����
    fastValBuf:=fastValBuf shr 11;}
    //1
    if (value and 1024 = 1024) then
    begin
      //�������� � ������� ������ ������ 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //�������� � ������� ������ ������ 0
      fastValBuf := fastValBuf shl 1;
    end;
    //2
    if (value and 512 = 512) then
    begin
      //�������� � ������� ������ ������ 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //�������� � ������� ������ ������ 0
      fastValBuf := fastValBuf shl 1;
    end;
    //3
    if (value and 256 = 256) then
    begin
      //�������� � ������� ������ ������ 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //�������� � ������� ������ ������ 0
      fastValBuf := fastValBuf shl 1;
    end;
    //4
    if (value and 128 = 128) then
    begin
      //�������� � ������� ������ ������ 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //�������� � ������� ������ ������ 0
      fastValBuf := fastValBuf shl 1;
    end;
    //5
    if (value and 64 = 64) then
    begin
      //�������� � ������� ������ ������ 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //�������� � ������� ������ ������ 0
      fastValBuf := fastValBuf shl 1;
    end;
    //6 ���
    if (value and 4 = 4) then
    begin
      //�������� � ������� ������ ������ 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //�������� � ������� ������ ������ 0
      fastValBuf := fastValBuf shl 1;
    end;
  end;
  if fastWordNum = 2 then
  begin
    //����������� 6 ������� �����
    fastValBuf := value shl 10; //6 � 16
    //����������� 9 ������� �����. 3 ������� ����.
    fastValBuf := fastValBuf shr 13;
    //4 ���
    if (value and 2 = 2) then
    begin
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      fastValBuf := fastValBuf shl 1;
    end;
    //5 ���
    if (value and 1 = 1) then
    begin
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      fastValBuf := fastValBuf shl 1;
    end;
    //6 ���
    if (value and 2048 = 2048) then
    begin
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      fastValBuf := fastValBuf shl 1;
    end;
  end;
  result := fastValBuf;
end;
//==============================================================================

//==============================================================================
//����� �� ����������� ������� ����������
//==============================================================================
procedure OutToGistFastParam(firstPointValue: integer;outStep: integer;
  masOutSize: integer; adrtype: {short}integer;var numPfast: integer; numBitOfValue: integer);
var
  iPoint: integer;
  //i:integer;
  //kk:integer;
begin
  if (form1.PageControl1.ActivePageIndex = 1) then
  begin
    iPoint := firstPointValue;
    iPoint := iPoint{ - 1};
    while iPoint <= masOutSize - 1 do
    begin
      //T22
      if adrType = 2 then
      begin
        if numPfast < form1.fastGist.BottomAxis.Maximum then
        begin
          setlength(masFastVal, numPfast);
          masFastVal[numPfast-1]:=BuildFastValueT22(masGroupAll[iPoint], numBitOfValue);
          inc(numPfast);
          iPoint := iPoint + outStep;
        end
        else
        begin
          //sleep(2);
          form1.fastGist.Series[0].Clear;
          //sleep(2);
          countPastOut := 1;
          if form1.fastGist.BottomAxis.Maximum>length(masFastVal) then
          begin
            form1.fastGist.Series[0].AddArray(masFastVal);
          end;
          //masFastVal:=nil;
          Application.ProcessMessages;
          {sleep(10);
          Application.ProcessMessages;}
          sleep(10);

          {while countPastOut <= numPfast{ - 50} {do
          begin
            if (countPastOut mod 700 = 0) then
            begin
              //sleep(3);
              //Application.ProcessMessages;
            end;
            try
              if ((countPastOut >= form1.fastGist.BottomAxis.Minimum) and
                  (countPastOut <= form1.fastGist.BottomAxis.Maximum) and
                  (countPastOut < {length(masFastVal)}{numPfast)
                 {) then
              begin
                form1.fastGist.Series[0].AddXY(countPastOut,
                masFastVal[countPastOut]);
              end
              else
              begin
                //ShowMessage('ErrorT22!');
              end
            except
              //ShowMessage('ErrorT22!');
            end;
            inc(countPastOut);
          end;}
          //masFastVal := nil;
          //countPastOut := 1;
          numPfast := 1;
        end;
      end;

      //T21
      if adrType = 3 then
      begin
        if numPfast < form1.fastGist.BottomAxis.Maximum then
        begin
          setlength(masFastVal, numPfast);
        
          masFastVal[numPfast-1] := masGroup[iPoint] shr 3;
          inc(numPfast);
          iPoint := iPoint + outStep;
        end
        else
        begin
          //sleep(2);
          {Application.ProcessMessages;
          sleep(2);
          Application.ProcessMessages; }
          form1.fastGist.Series[0].Clear;
          {Application.ProcessMessages;
          sleep(2);
          Application.ProcessMessages;}
          //countPastOut := 1;
          //form1.downGistFastSize.Enabled := false;
          //try

          {while countPastOut<=trunc(form1.fastGist.BottomAxis.Maximum) do
          begin
            if form1.fastGist.BottomAxis.Maximum>length(masFastVal) then
            begin
              //Application.ProcessMessages;
              form1.fastGist.Series[0].AddXY(countPastOut,masFastVal[countPastOut-1]);
              //sleep(1);
              inc(countPastOut);
            end;
          end;}






          if form1.fastGist.BottomAxis.Maximum>length(masFastVal) then
          begin
            form1.fastGist.Series[0].AddArray(masFastVal);
          end;
          //kk:=form1.fastGist.Series[0].Count
          //except
            //ShowMessage('������');
          //end;
          //form1.downGistFastSize.Enabled := true;
          //masFastVal:=nil;
          Application.ProcessMessages;
          //sleep(10);
          sleep(10);
          //Application.ProcessMessages;

          {if countPastOut>=form1.fastGist.BottomAxis.Maximum then
          begin
            form1.fastGist.Series[0].Clear;
            countPastOut := 1;
          end;
          i:=1;
          while i <= numPfast - 30 do
          begin
            if (i mod 700 = 0) then
            begin
              //sleep(3);
             // Application.ProcessMessages;
            end;
            //try
              if ((i >= form1.fastGist.BottomAxis.Minimum) and
                 (i <= form1.fastGist.BottomAxis.Maximum) and
                 (i < {length(masFastVal)}{numPfast)
                {) then
              begin
                form1.fastGist.Series[0].AddXY(countPastOut,masFastVal[i]);
              end;
              //else
              //begin
                //ShowMessage('ErrorT21!');
              //end
            //except
              //ShowMessage('ErrorT21!');
            //end;
            inc(countPastOut);
            inc(i);
          end;
          //sleep(3);
          //masFastVal := nil;}
          //countPastOut := 1;
          numPfast := 1;
        end;
      end;

      //T24
      {if adrType = 5 then
      begin
        if numPfast < form1.fastGist.BottomAxis.Maximum-10 then
        begin
          setlength(masFastVal, numPfast);
          //form1.Memo1.Lines.Add(intToStr(iPoint));
          masFastVal[numPfast-1]:=BuildFastValueT24(masGroupAll[iPoint], numBitOfValue);
          //if numPfast=10 then
          //form1.Memo1.Lines.Add(intToStr(iPoint));
          inc(numPfast);
          iPoint := iPoint + outStep;
        end
        else
        begin
          //sleep(2);
          form1.fastGist.Series[0].Clear;
          //sleep(2);
          countPastOut := 1;
          if form1.fastGist.BottomAxis.Maximum>=length(masFastVal) then
          begin
            form1.fastGist.Series[0].AddArray(masFastVal);
          end;
          //masFastVal:=nil;
          {Application.ProcessMessages;
          sleep(5);
          Application.ProcessMessages;}
          {while countPastOut <= numPfast - 30 do
          begin
            if (countPastOut mod 700 = 0) then
            begin
             // sleep(3);
             // Application.ProcessMessages;
            end;
            try
              if ((countPastOut >= form1.fastGist.BottomAxis.Minimum) and
                  (countPastOut <= form1.fastGist.BottomAxis.Maximum) and
                  (countPastOut < {length(masFastVal)}{numPfast)
                {) then
              begin
                form1.fastGist.Series[0].AddXY(countPastOut,masFastVal[countPastOut]);
              end
              else
              begin
                //ShowMessage('ErrorT22!');
              end
            except
              //ShowMessage('ErrorT22!');
            end;
            inc(countPastOut);
          end;}
          //masFastVal := nil;
         { countPastOut := 1;
          numPfast := 1;
        end;
      end;}
    end;
  end;
end;
//==============================================================================




//==============================================================================
//����� �� ����������� �������������
//==============================================================================
procedure OutToGistTemp(firstPointValue: integer; outStep: integer;
  masOutSize: integer; var numP: integer);
var
  iPoint: integer;
begin
  //������� �� ���� ����� ������� ������� �������������
  if (form1.PageControl1.ActivePageIndex = 2) then
  begin
    iPoint := firstPointValue;
    iPoint := iPoint{ - 1};
    while iPoint <= masOutSize-1 do
    begin
      if (numP < form1.tempGist.BottomAxis.Maximum - 10) then
        form1.tempGist.Series[0].AddXY(numP, masGroup[iPoint] shr 1);
      inc(numP);
      if (numP = form1.tempGist.BottomAxis.Maximum - 10) then
      begin
        form1.upGistTempSize.Enabled := false;
      end;
      if (numP >= form1.tempGist.BottomAxis.Maximum) then
      begin
        numP := 0;
        form1.lnsrsSeries8.Clear;
        form1.upGistTempSize.Enabled := true;
        form1.downGistTempSize.Enabled := true;
      end;
      iPoint := iPoint + outStep;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//����� �� ����������� ���������� ���������
//==============================================================================
procedure OutToGistSlowAnl(firstPointValue: integer; outStep: integer;
  masOutSize: integer; var numP: integer;typeOfAdr:integer);
var
  iPoint: integer;
begin
  //������� �� ���� ����� ������� ������� ������. ����.
  if (form1.PageControl1.ActivePageIndex = 0) then
  begin
    iPoint := firstPointValue;
    iPoint := iPoint{ - 1};


    while iPoint <= masOutSize-1 do
    begin
      //����� �� ���
      //form1.Memo1.Lines.Add('#�����'+IntToStr(ciklNum)+' �������:'+IntToStr(groupNum)+
      //' ����� ������:'+IntToStr(chanelIndexSlow)+' ���������� ������:'+
      //IntToStr(masGroup[iPoint] shr 1));
      {while (flagTrue) do
      begin
        Application.ProcessMessages;
      end;}


      if (numP < form1.gistSlowAnl.BottomAxis.Maximum - 10) then
      begin
        //T01
        if (typeOfAdr=0) then
        begin
          form1.gistSlowAnl.Series[0].AddXY(numP, masGroup[iPoint] shr 1);
        end;
        //T01-01
        if (typeOfAdr=8) then
        begin
          form1.gistSlowAnl.Series[0].AddXY(numP, masGroup[iPoint] shr 2);
        end;
        //form1.Memo1.Lines.Add(IntToStr(numP)+' '+IntToStr(masGroup[iPoint] shr 1));
      end;

      inc(numP);
      if (numP = form1.gistSlowAnl.BottomAxis.Maximum - 10) then
      begin
        form1.upGistSlowSize.Enabled := false;
      end;
      if (numP >= form1.gistSlowAnl.BottomAxis.Maximum) then
      begin
        numP := 0;
        form1.Series2.Clear;
        form1.upGistSlowSize.Enabled := true;
        form1.downGistSlowSize.Enabled := true;
      end;
      iPoint := iPoint + outStep;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//����� ��������� ������ �� �������
//==============================================================================
procedure OutToGistGeneral;
begin
  //����� �� ������ ��� ���������� � ����������
  if (graphFlagSlowP) then
  begin
    {OutToGistSlowAnl(masElemParam[chanelIndexSlow].numOutElemG,
      masElemParam[chanelIndexSlow].stepOutG,
      {length(masGroup)}{masGroupSize, data.numP); }

    if (masElemParam[chanelIndexSlow].flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����
        {if groupNum=1 then
        begin
          form1.Memo1.Lines.Add('111');
        end;}

        if isInGroup(groupNum,chanelIndexSlow) then
        begin
          OutToGistSlowAnl(masElemParam[chanelIndexSlow].numOutElemG,
            masElemParam[chanelIndexSlow].stepOutG,masGroupSize, {data.}numP,
            masElemParam[chanelIndexSlow].adressType);
        end;
      end
      else if (masElemParam[chanelIndexSlow].flagCikl) then
      begin
        if isInCikl(ciklNum,chanelIndexSlow) then
        begin
          //���������� �������� ����� �� ���������� �����
          if (masElemParam[chanelIndexSlow].flagGroup) then
          begin
            //���������� �������� ����� �� ���������� �����
            if isInGroup(groupNum,chanelIndexSlow) then
            begin
              OutToGistSlowAnl(masElemParam[chanelIndexSlow].numOutElemG,
                masElemParam[chanelIndexSlow].stepOutG,masGroupSize, {data.}numP,
                masElemParam[chanelIndexSlow].adressType);
            end;
          end
          else
          begin
            OutToGistSlowAnl(masElemParam[chanelIndexSlow].numOutElemG,
              masElemParam[chanelIndexSlow].stepOutG,masGroupSize, {data.}numP,
              masElemParam[chanelIndexSlow].adressType);
          end;
        end;
      end
      else
      begin
        OutToGistSlowAnl(masElemParam[chanelIndexSlow].numOutElemG,
            masElemParam[chanelIndexSlow].stepOutG,masGroupSize, {data.}numP,
            masElemParam[chanelIndexSlow].adressType);
      end;
  end;

  //����� �� ������ ������. ����������
  if (graphFlagTempP) then
  begin
    if (masElemParam[chanelIndexTemp].flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����
        if isInGroup(groupNum,chanelIndexTemp) then
        begin
          OutToGistTemp(masElemParam[chanelIndexTemp].numOutElemG,
            masElemParam[chanelIndexTemp].stepOutG,masGroupSize, {data.}numP);
        end;
      end
      else if (masElemParam[chanelIndexTemp].flagCikl) then
      begin
        if isInCikl(ciklNum,chanelIndexTemp) then
        begin
          //���������� �������� ����� �� ���������� ������
          if (masElemParam[chanelIndexTemp].flagGroup) then
          begin
            //���������� �������� ����� �� ���������� �����
            if isInGroup(groupNum,chanelIndexTemp) then
            begin
              OutToGistTemp(masElemParam[chanelIndexTemp].numOutElemG,
                masElemParam[chanelIndexTemp].stepOutG,masGroupSize, {data.}numP);
            end;
          end
          else
          begin
            OutToGistTemp(masElemParam[chanelIndexTemp].numOutElemG,
              masElemParam[chanelIndexTemp].stepOutG,masGroupSize, {data.}numP);
          end;
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        OutToGistTemp(masElemParam[chanelIndexTemp].numOutElemG,
          masElemParam[chanelIndexTemp].stepOutG,masGroupSize, {data.}numP);
      end;
  end;

  //����� �� ��������� ��� ������� ����������
  if (graphFlagFastP)and(testOutFalg) then
  begin
    OutToGistFastParam(masElemParam[chanelIndexFast].numOutElemG,
      masElemParam[chanelIndexFast].stepOutG, {length(masGroup)}masGroupSize,
      masElemParam[chanelIndexFast].adressType, {data.}numPfast,
      masElemParam[chanelIndexFast].bitNumber);
  end;




  // ����� �� ��������� ��� ���
  {if (graphFlagBusP) then
  begin
    OutToGistBusParam(masElemParam[chanelIndexFast].numOutElemG,
      masElemParam[chanelIndexFast].stepOutG, {length(masGroup)}{masGroupSize,
      masElemParam[chanelIndexFast].adressType, data.numPfast,
      masElemParam[chanelIndexFast].bitNumber);
  end;}
end;
//==============================================================================


//==============================================================================
//����� �� ��������� ���������  �������
//==============================================================================
procedure  outToDiaSGeneral;
var
  orbAdrCount: integer;
begin
  //������������� ������� ��������� ������ ������.
  orbAdrCount := 0;
  //������� ��� �������� ���������� ���������� �������
  {data.}tempAdrCount := 0;
  //form1.tempDia.Series[0].Clear;
//  if outTempAdr=acumTemp*5 then
//  begin
//    form1.tempDia.Series[0].Clear;
//    outTempAdr:=0;
//  end;



  //Form1.Memo1.Lines.Add('1');
  //sleep(3);
  //��������������� ��������� ������ �� ������� ������
  //������, �������� ������ �������� � ������� �� ������
  while orbAdrCount <= iCountMax - 1 do // iCountMax-1
  begin
    if ((masElemParam[orbAdrCount].adressType=0)or
        (masElemParam[orbAdrCount].adressType=8))then
    begin
       //�������� ������ � ���������� ����������� ��� �01
       {data.}outToDiaForSlow(
        masElemParam[orbAdrCount].numOutElemG,
        masElemParam[orbAdrCount].stepOutG,
        masGroupSize,orbAdrCount,
        masElemParam[orbAdrCount].adressType,
        masElemParam[orbAdrCount].bitNumber,
        masElemParam[orbAdrCount].numOutPoint,
        masElemParam[orbAdrCount].flagGroup,
        masElemParam[orbAdrCount].flagCikl);
    end;
    inc(orbAdrCount);
  end;
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
procedure testFillGroupArr(var imasGroup:Integer);
begin
  //��������� 1023 ��������
  if iMasGroup = {1024}{1025}masGroupSize+1 then //!!!!
  begin
    iMasGroup := 1;

    // � ����������� �� ���� ������� ����� ���������� �� ���������
    //���� ��� �����, ���� �� ���

    //���������� ��� �������� �������
    case form1.PageControl1.ActivePageIndex  of
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
        //��� {�������� � �� ������������}
      end;
      3:
      begin
        //�������������
        //���� ������� ������� ������������� ����������
        //�� �� ����������� ������� ��� �����
        {data.}outToDiaTGeneral;
      end;
    end;




    //����� ���� �������� �� ������
    OutToGistGeneral;

    //��������� ������� �� 97 �������� ���  0..96
    {if (CollectBusArray(iBusArray)) then
      begin
       //��� ������ ������ �� ��������� ���
        form1.TimerOutToDiaBus.Enabled := true;
      end;  }

    { if (graphFlag) then
      begin
        OutToGist(masElemParam[chanelIndex].numOutElemG,
        masElemParam[chanelIndex].stepOutG,
        length(masGroup),numP);
      end;}
  end;
end;
//==============================================================================

//==============================================================================
//����� ��������� ���������� ������� �� ���������
//==============================================================================
procedure outToDiaAnl(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel: integer;maxPointInAdr:integer;typeAdr:integer);
var
  //���������� ��� ���������� �������� ��� ���������� �������
  offsetForYalkAnalog: short;
  nPoint: integer;
  i:Integer;
begin
  //����� ������ ����� � ������� firstPointValue ��� �������� ������
  //���������� ��������� �������� ��� ����������� �� 1 ������ ������ 1 �����
  //���������� ��������, ��� ������� ���� ������ ����� ���� ��������
  offsetForYalkAnalog := outStep * (numOutPoint - 1);
  //���������� ������ ������� ��������� �����
  nPoint := firstPointValue + offsetForYalkAnalog;
  //��� ��� ������ ������ � 0
  nPoint := nPoint{ - 1};

  { while (flagTrue) do
  begin
   Application.ProcessMessages;
  end;
  //����� �� ���
  form1.Memo1.Lines.Add('#�����'+IntToStr(ciklNum)+' �������:'+IntToStr(groupNum)+
    ' ����� ������:'+IntToStr(numChanel)+'����� �����'+IntToStr(nPoint)+' ���������� ������:'+
      IntToStr(masGroup[nPoint] shr 1));}


  if iSlowArr=acumAnalog then
  begin
    form1.diaSlowAnl.Series[0].Clear;
    for i:=0 to iSlowArr-1 do
    begin
      //form1.Memo1.Lines.Add(IntToStr(slowArr[i].num)+' '+IntToStr(slowArr[i].val));
      //if  ((slowArr[i].num=0)or(slowArr[i].num=1)) then
      //begin

      //end
      //else
      //begin
        //form1.Memo1.Lines.Add('!');
      //end;

      form1.diaSlowAnl.Series[0].AddXY(slowArr[i].num,slowArr[i].val);
      //form1.Memo1.Lines.Add(IntToStr(tempArr[i].num)+' '+IntToStr(tempArr[i].val));
    end;
    iSlowArr:=0;
  end;


  //form1.tempDia.Series[0].AddXY(numChanel, masGroup[nPoint] shr 1);
  //sleep(1);
  //form1.Memo1.Lines.Add(IntToStr(numChanel)+' '+IntToStr(masGroup[nPoint] shr 1));
  //form1.Memo1.Lines.Add(' ');
  form1.Memo1.Clear;
  slowArr[iSlowArr].num:=numChanel;
  if typeAdr=0 then
  begin
    //10 �����
    slowArr[iSlowArr].val:=masGroup[nPoint] shr 1;
  end;
  if typeAdr=8 then
  begin
    //9 �����
    slowArr[iSlowArr].val:=masGroup[nPoint] shr 2;
  end;

  inc(iSlowArr);

  //����� �� ���
  //form1.diaSlowAnl.Series[0].AddXY(numChanel, masGroup[nPoint] shr 1);
  //���������� �������� ��������� ����� ������
  inc(numOutPoint);
  //��������� �� ����� �� �� �� ������������ �������� ��� �������� ������
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
  //������� �������� ���������� ���������� �������
  inc(analogAdrCount);
end;
//==============================================================================

//==============================================================================
//����� ��������� ���������� ������� �� ���������
//==============================================================================
procedure outToDiaCont(outStep: integer;var numOutPoint: {short}integer;
  firstPointValue: integer;var numChanel: integer;numBitOfValue: short;maxPointInAdr:integer);
var
  nPoint: integer;
  offsetForYalkContact: short;
  i:Integer;
  //��� �������� �������� ����������� ������
  contVal: integer;
begin
  offsetForYalkContact := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkContact;
  //��� ��� ������ ������ � 0
  nPoint := nPoint {- 1};


  if iContArr=acumContact then
  begin
    form1.diaSlowCont.Series[0].Clear;
    for i:=0 to iContArr-1 do
    begin
      //form1.Memo1.Lines.Add(IntToStr(contArr[i].num)+' '+IntToStr(contArr[i].val));
      form1.diaSlowCont.Series[0].AddXY(contArr[i].num,contArr[i].val);
      //form1.Memo1.Lines.Add(IntToStr(contArr[i].num)+' '+IntToStr(contArr[i].val));
    end;
    iContArr:=0;
  end;

  form1.Memo1.Clear;
  contArr[iContArr].num:=numChanel - analogAdrCount;
  contVal := OutputValueForBit(masGroup[nPoint], numBitOfValue);
  contArr[iContArr].val:=contVal;

  inc(iContArr);

  inc(numOutPoint);
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
  //������� �������� ���������� ���������� �������
  inc(contactAdrCount);
  //SaveBitToLog(IntToStr(numChanel-20));
  //if numChanel-20=8 then form1.gistCont.Series[0].Clear;
end;
//==============================================================================

//==============================================================================
//����� ������� ������� �21 �� ���������
//==============================================================================
procedure outToDiaFastT21(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  //����������� ��� ������� �������� T21
  fastValT21: integer;
  offsetForYalkFastParamT21: short;
begin
  //���������� �������� ��� ��������� ������ ��� ���������
  //����� ��� ������� �������������� ������
  //�������� � ������ ����� ������ ����� �����������
  offsetForYalkFastParamT21 := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkFastParamT21;
  //��� ��� ������ ������ � 0
  nPoint := nPoint {- 1};
  fastValT21 := masGroup[nPoint] shr 3; //8 ��������
  try
    form1.fastDia.Series[0].AddXY(numChanel, fastValT21);
    {if numChanel=11 then
    begin
      Form1.mmoTestResult.Lines.Add('1');
    end;}
    dataMKB[numChanel+1]:=fastValT21;
  except
    //ShowMessage('222');
  end;
  inc(numOutPoint);
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
end;
//==============================================================================

//==============================================================================
//����� ������� ������� �22 �� ���������
//==============================================================================
procedure outToDiaFastT22(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  //����������� ��� ������� �������� T22
  fastValT22: integer;
  offsetForYalkFastParamT22: short;
begin
  //���������� �������� ��� ��������� ������ ��� ���������
  //����� ��� ������� �������������� ������
  //�������� � ������ ����� ������ ����� �����������
  offsetForYalkFastParamT22 := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkFastParamT22;
  //��� ��� ������ ������ � 0
  nPoint := nPoint{ - 1};
  //�������� � ������� ������ ����� T22
  fastValT22 := BuildFastValueT22(masGroupAll[nPoint], numBitOfValue);
  try
    form1.fastDia.Series[0].AddXY(numChanel, fastValT22 {rrr});
    dataMKB[numChanel+1]:=fastValT22;
  except
    //ShowMessage('111');
  end;
  inc(numOutPoint);
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
end;
//==============================================================================

//==============================================================================
//����� ������� ������� �24 �� ���������
//==============================================================================
procedure outToDiaFastT24(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  //����������� ��� ������� �������� T24
  fastValT24: integer;
  offsetForYalkFastParamT24: short;
begin
  offsetForYalkFastParamT24 := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkFastParamT24;
  nPoint := nPoint {- 1};
  //form1.Memo1.Lines.Add(intToStr(nPoint));
  fastValT24 := BuildFastValueT24(masGroupAll[nPoint], numBitOfValue);
  try
    form1.fastDia.Series[0].AddXY(numChanel, fastValT24);
  except
    //ShowMessage('111');
  end;
  inc(numOutPoint);
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
end;
//==============================================================================

//==============================================================================
//����� ������������� ������� �� ���������
//==============================================================================
procedure outToDiaTemp(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  offsetForYalkTemp: short;

  i:Integer;
  j:integer;

  k,l,m:Integer;
  
begin
  //����� ������ ����� � ������� firstPointValue ��� �������� ������
  //���������� ��������� �������� ��� ����������� �� 1 ������ ������ 1 �����
  //���������� ��������, ��� ������� ���� ������ ����� ���� ��������
  offsetForYalkTemp := outStep * (numOutPoint - 1);
  //���������� ������ ������� ��������� �����
  nPoint := firstPointValue + offsetForYalkTemp;
  //��� ��� ������ ������ � 0
  nPoint := nPoint{ - 1};

  //����� �� ���
  {form1.Memo1.Lines.Add('#�����'+IntToStr(ciklNum)+' �������:'+IntToStr(groupNum)+
    ' ����� ������:'+IntToStr(numChanel)+' ���������� ������:'+
      IntToStr(masGroup[nPoint] shr 1));
  while (flagTrue) do
  begin
   Application.ProcessMessages;
  end;}


  if iTempArr=acumTemp then
  begin
    form1.tempDia.Series[0].Clear;
    for i:=0 to iTempArr-1 do
    begin
      //form1.Memo1.Lines.Add(IntToStr(tempArr[i].num)+' '+IntToStr(tempArr[i].val));
      //������� ����� �����
      //!!!
      tempArr2[0]:=tempArr[0];
      Dec(tempArr2[0].num);
      tempArr2[1]:=tempArr[length(tempArr)-1];
      inc(tempArr2[1].num);
      for j:=1 to length(tempArr)-2 do
      begin
        tempArr2[j+1]:=tempArr[j];
      end;

      //���� �� ������ �������� ������� �� ������������� ����������
      if (startTestBlock) then
      begin
        if (countRound=11) then
        begin
          //�������� ������� ��������� �� ������ ������
          for l:=1 to 31 do
          begin
            for m:=1 to countRound-1 do
            begin
              acumChVal:=acumChVal+tArrRound[m][l];
            end;
            tempArr2[l].val:=Round(acumChVal/(countRound-1));
            acumChVal:=0;
          end;
          acumChVal:=0;
          countRound:=1; 
        end
        else
        begin
          //������������� ����������
          startTest_1_1_10_2:=setColibr(getScaleNum(tempArr[0].val),tempArr[0].val);
          for k:=1 to 31 do
          begin
            tArrRound[countRound][k]:=tempArr2[k].val;
          end;
          Inc(countRound)
        end;
      end;


      //form1.tempDia.Series[0].AddXY(tempArr[i].num,tempArr[i].val);
      if ((tempArr2[i].num>=32)or(tempArr2[i].num<0)) then
      begin
        form1.tempDia.Series[0].AddXY(tempArr2[i].num,tempArr2[i].val);
      end;
      form1.tempDia.Series[0].AddXY(tempArr2[i].num+1,tempArr2[i].val);
      //form1.Memo1.Lines.Add(IntToStr(tempArr[i].num)+' '+IntToStr(tempArr[i].val));
    end;
    iTempArr:=0;
  end;


  //form1.tempDia.Series[0].AddXY(numChanel, masGroup[nPoint] shr 1);

  //Form1.Memo1.Clear;
  tempArr[iTempArr].num:=numChanel; //numChanel
  tempArr[iTempArr].val:=masGroup[nPoint] shr 1;
  inc(iTempArr);

  //�������� ������� ���������� ����. ����������
  Inc(outTempAdr);
  //���������� �������� ��������� ����� ������
  inc(numOutPoint);
  //��������� �� ����� �� �� �� ������������ �������� ��� �������� ������
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
  //������� �������� ���������� ���������� �������
  inc(tempAdrCount);
end;
//==============================================================================

//==============================================================================
//����� �� ����������� ���������� ���
//==============================================================================
procedure OutToGistBusParam(firstPointValue: integer;outStep: integer;
masOutSize: integer; adrtype: short;var numPfast: integer; numBitOfValue: integer);
var
  iPoint: integer;
  busArrLen:integer;
begin
  //������� �� ���� ����� ������� ������� ������. ����.
  if (form1.PageControl1.ActivePageIndex = 4) then
  begin
    iPoint:=0;
    busArrLen:=length(busArray);
    while iPoint <=busArrLen  do
    begin
      if (numP < form1.busGist.BottomAxis.Maximum - 10) then
      begin
         form1.busGist.Series[0].AddXY(numP, busArray[iPoint]);
      end;
      inc(numP);
      if (numP = form1.busGist.BottomAxis.Maximum - 10) then
      begin
        //form1.upGistSlowSize.Enabled := false;
      end;
      if (numP >= form1.busGist.BottomAxis.Maximum) then
      begin
        numP := 0;
        form1.Series6.Clear;
        //form1.upGistSlowSize.Enabled := true;
        //form1.downGistSlowSize.Enabled := true;
      end;
      iPoint := iPoint + 1;
    end;
  end;
end;
//==============================================================================

//=============================================================================
//����� �� �����������
//=============================================================================
procedure outToDia(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer; busTh: {short}integer; busAdr: {short}integer;var numOutPoint: {short}integer;
  flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  //���������� ��� ���������� ����������
  //����� ��� ������� ������ ����������� ������
  //���������� ��������������� � ����� ��� �����������
  //����������� ������ ����� �� �����
  maxPointInAdr: integer;
begin
  //��������� ���������� ����� � ��������� ������
  maxPointInAdr := 0;
  nPoint := firstPointValue;
  while nPoint <= masOutSize do
  begin
    inc(maxPointInAdr);
    nPoint := nPoint + outStep;
  end;

  //����� ������������ ������ ���� ������� ���������� � ���������� ������� �������
  if form1.PageControl1.ActivePageIndex = 0 then
  begin
    //����� ��� ���������� �������   0,8
    if ((typeOfAddres = 0)or(typeOfAddres = 8)) then
    begin
      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����
         //���������� �������� ����� �� ���������� �����
        if isInGroup(groupNum,numChanel) then
        begin
          //form1.Memo1.Lines.Add('#�����'+IntToStr(ciklNum)+' �������:'+IntToStr(groupNum)+
    //' ����� ������:'+IntToStr(numChanel)+'����� �����'+IntToStr(2)+' ���������� ������:'+
      //IntToStr(masGroup[2] shr 1));
          //����� ���������� � ������ ����� ������
          outToDiaAnl(outStep,numOutPoint,firstPointValue,
          numChanel,maxPointInAdr,typeOfAddres);
        end;
      end
      else if (flagCikl) then
      begin
        //���������� �������� ����� �� ���������� ������
        if isInCikl(ciklNum,numChanel) then
        begin
          //���������� �������� ����� �� ���������� ������
          if (flagGroup) then
          begin
            //���������� �������� ����� �� ���������� �����
            if isInGroup(groupNum,numChanel) then
            begin
              outToDiaAnl(outStep,numOutPoint,firstPointValue,
                numChanel,maxPointInAdr,typeOfAddres);
            end;
          end
          else
          begin
            outToDiaAnl(outStep,numOutPoint,firstPointValue,
              numChanel,maxPointInAdr,typeOfAddres);
          end;
        end;
        {if (flagGroup) then
        begin
          //���������� �������� ����� �� ���������� �����

        end;}
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaAnl(outStep,numOutPoint,firstPointValue,
          numChanel,maxPointInAdr,typeOfAddres);
      end;
    end;

    //����� ��� ���������� �������     1
    if typeOfAddres = 1 then
    begin
      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����

      end
      else if (flagCikl) then
      begin
        //���������� �������� ����� �� ���������� ������
        if (flagGroup) then
        begin
          //���������� �������� ����� �� ���������� �����
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaCont(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;

  //����� ��� ������� ����������
  if form1.PageControl1.ActivePageIndex = 1 then
  begin

    //����� ��� ������� ����������   T22
    if typeOfAddres = 2 then
    begin
      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����

      end
      else if (flagCikl) then
      begin
        //���������� �������� ����� �� ���������� ������
        if (flagGroup) then
        begin
          //���������� �������� ����� �� ���������� �����
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaFastT22(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;

    //����� ��� ������� ����������   T21
    if typeOfAddres = 3 then
    begin
      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����

      end
      else if (flagCikl) then
      begin
        //���������� �������� ����� �� ���������� ������
        if (flagGroup) then
        begin
          //���������� �������� ����� �� ���������� �����
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaFastT21(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;

    //����� ��� ������� ����������   T24
    if typeOfAddres = 5 then
    begin
      if (flagGroup) then
      begin
        //���������� �������� ����� �� ���������� �����

      end
      else if (flagCikl) then
      begin
        //���������� �������� ����� �� ���������� ������
        if (flagGroup) then
        begin
          //���������� �������� ����� �� ���������� �����
        end;
      end
      else
      begin
        //����� ���������� � ������ ����� ������
        outToDiaFastT24(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;

  //����� ��� ���
  if form1.PageControl1.ActivePageIndex = 4 then
  begin
  end;
end;


//==============================================================================
//����� �� ��������� ����������  �������
//==============================================================================
procedure  outToDiaCGeneral;
var
  orbAdrCount: integer;
begin
  //������������� ������� ��������� ������ ������.
  orbAdrCount := 0;
  //������� ��� �������� ���������� ���������� �������
  {data.}tempAdrCount := 0;
  //form1.tempDia.Series[0].Clear;
//  if outTempAdr=acumTemp*5 then
//  begin
//    form1.tempDia.Series[0].Clear;
//    outTempAdr:=0;
//  end;



  //Form1.Memo1.Lines.Add('1');
  //sleep(3);
  //��������������� ��������� ������ �� ������� ������
  //������, �������� ������ �������� � ������� �� ������
  while orbAdrCount <= iCountMax - 1 do // iCountMax-1
  begin
    if masElemParam[orbAdrCount].adressType=1 then
    begin
      //�������� ������ � ����������� �������� T05
      {data.}outToDiaForCont(
        masElemParam[orbAdrCount].numOutElemG,
        masElemParam[orbAdrCount].stepOutG,
        masGroupSize,orbAdrCount,
        masElemParam[orbAdrCount].adressType,
        masElemParam[orbAdrCount].bitNumber,
        masElemParam[orbAdrCount].numOutPoint,
        masElemParam[orbAdrCount].flagGroup,
        masElemParam[orbAdrCount].flagCikl);
    end;
    inc(orbAdrCount);
  end;
end;
//==============================================================================

//==============================================================================
//
//==============================================================================
procedure OutDate;
begin
  //���� ���� ��� ����� //!!!!!
  //FillSwatWord;
 { if (form1.PageControl1.ActivePageIndex = 3) then
  begin
    //���� ������� ������� ������������� ����������
    //�� �� ����������� ������� ��� �����
    data.outToDiaTGeneral;
  end
  else
  begin
    form1.TimerOutToDia.Enabled := true;
  end;
  //form1.Memo1.Lines.Add('����:'+intTostr(ciklNum));
  //����� �� �������. ����� ���������.
  OutToGistGeneral; }
  //���������� ��� �������� �������
    case form1.PageControl1.ActivePageIndex  of
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

        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;
      1:
      begin
        //�������
        //����� �� �������
        form1.TimerOutToDia.Enabled := true;
        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;
      4:
      begin
        //��� {�������� � �� ������������}
        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;
      2:
      begin
        //�������������
        //���� ������� ������� ������������� ����������
        //�� �� ����������� ������� ��� �����
        {data.}outToDiaTGeneral;
      end;
      {3:
      begin
        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;}
    end;

    //����� ���� �������� �� ������
    OutToGistGeneral;
end;
//==============================================================================
end.
