unit OutUnit;

interface
uses
  Messages,Forms,Windows,SysUtils,TestUnit_N1_1;
    //Вывод данных на графики
    procedure OutDate;
    //вывод на диаграмму контактных главная
    procedure  outToDiaCGeneral;
    procedure testFillGroupArr(var imasGroup:Integer);
    //вывод на диаграмму медленных главная
    procedure  outToDiaSGeneral;
    //общая спроцедура вывода на гистограммы
    procedure OutToGistGeneral;
    //вывод на гистограмму аналоговые
    procedure OutToGistSlowAnl(firstPointValue: integer; outStep: integer;
      masOutSize: integer; var numP: integer;typeOfAdr:integer);
    //вывод на гистограмму температурные
    procedure OutToGistTemp(firstPointValue: integer; outStep: integer;
      masOutSize: integer; var numP: integer);
    //вывод на гистограмму быстрые
    procedure OutToGistFastParam(firstPointValue: integer; outStep: integer;
      masOutSize: integer; adrtype: {short}integer;
      var numPfast: integer; numBitOfValue: integer);
    //сбор быстрого параметра T22
    function BuildFastValueT22(value: integer; fastWordNum: integer): integer;
    //сбор быстрого параметра T24
    function BuildFastValueT24(value: integer; fastWordNum: integer): integer;
    //сбор контактного параметра
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
    //вывод на диаграмму температурных главная
    procedure  outToDiaTGeneral;
    //вывод на диаграмму температурных
    procedure outToDiaForTemp(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
        numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
    //вывод на диаграмму медленных
    procedure outToDiaForSlow(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
        numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
    //вывод на диаграмму контактных
    procedure outToDiaForCont(firstPointValue: integer;outStep: integer;
      masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
        numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);    
implementation
uses
  OrbitaAll,LibUnit;


  
//==============================================================================
//Вывод на диаграмму контактных
//==============================================================================
procedure {TData.}outToDiaForCont(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  maxPointInAdr: integer;
begin
  //проверяем что активна вкладка медленных и контактных
  if form1.PageControl1.ActivePageIndex = 0 then
  begin
    //вычисляем количество точек в пришедшем адресе
    maxPointInAdr := 0;
    nPoint := firstPointValue;
    while nPoint <= masOutSize do
    begin
      inc(maxPointInAdr);
      nPoint := nPoint + outStep;
    end;

    //вывод для контактных каналов 1
    if typeOfAddres = 1 then
    begin
//      Form1.Memo1.Lines.Add('№Группы '+intToStr(groupNum));
//      while (flagTrue) do
//      begin
//        Application.ProcessMessages;
//      end;

      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп
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
          //необходимо вынимать слова из конкретных циклов
          if (flagGroup) then
          begin
            //необходимо вынимать слова из конкретных групп
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
        //вывод происходит в рамках одной группы
        outToDiaCont(outStep,numOutPoint,firstPointValue,numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;
end;
//==============================================================================
  
//==============================================================================
//Вывод на диаграмму медленных
//==============================================================================
procedure outToDiaForSlow(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  maxPointInAdr: integer;
begin
  //проверяем что активна вкладка медленных и контактных
  if form1.PageControl1.ActivePageIndex = 0 then
  begin
    //вычисляем количество точек в пришедшем адресе
    maxPointInAdr := 0;
    nPoint := firstPointValue;
    while nPoint <= masOutSize do
    begin
      inc(maxPointInAdr);
      nPoint := nPoint + outStep;
    end;

    //вывод для медленных 0 и 8 . Т01 и Т01-01
    if ((typeOfAddres = 0)or(typeOfAddres = 8)) then
    begin
//      Form1.Memo1.Lines.Add('№Группы '+intToStr(groupNum));
//      while (flagTrue) do
//      begin
//        Application.ProcessMessages;
//      end;

      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп
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
          //необходимо вынимать слова из конкретных циклов
          if (flagGroup) then
          begin
            //необходимо вынимать слова из конкретных групп
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
        //вывод происходит в рамках одной группы
         outToDiaAnl(outStep,numOutPoint,firstPointValue,numChanel,maxPointInAdr,typeOfAddres);
      end;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//Вывод на диаграмму температурных
//==============================================================================
procedure outToDiaForTemp(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer;var numOutPoint: {short}integer;flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  //переменная для вычисления количества
  //точек для каждого нового приходящего адреса
  //переменная вспомогательная и нужна для организации
  //цикличности вывода точек по одной
  maxPointInAdr: integer;
begin
  //проверяем что активна вкладка температурных
  if form1.PageControl1.ActivePageIndex = 2 then
  begin
    //вычисляем количество точек в пришедшем адресе
    maxPointInAdr := 0;
    nPoint := firstPointValue;
    while nPoint <= masOutSize do
    begin
      inc(maxPointInAdr);
      nPoint := nPoint + outStep;
    end;

    //вывод для температурных каналов   7
    if typeOfAddres = 7 then
    begin
//      Form1.Memo1.Lines.Add('№Группы '+intToStr(groupNum));
//      while (flagTrue) do
//      begin
//        Application.ProcessMessages;
//      end;

      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп
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
          //необходимо вынимать слова из конкретных циклов
          if (flagGroup) then
          begin
            //необходимо вынимать слова из конкретных групп
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
        //вывод происходит в рамках одной группы
        outToDiaTemp(outStep,numOutPoint,firstPointValue,numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;
end;
//==============================================================================  

//==============================================================================
//Вывод на диаграмму температурных  главная
//==============================================================================
procedure  outToDiaTGeneral;
var
  orbAdrCount: integer;
  //testI:Integer;
begin
  //осуществление разбора очередной строки адреса.
  orbAdrCount := 0;
  //счетчик для подсчета количества аналоговых каналов
  {data.}tempAdrCount := 0;
  //form1.tempDia.Series[0].Clear;
//  if outTempAdr=acumTemp*5 then
//  begin
//    form1.tempDia.Series[0].Clear;
//    outTempAdr:=0;
//  end;



  //Form1.Memo1.Lines.Add('1');
  //sleep(3);
  //последовательно разбираем строка за строкой адреса
  //Орбиты, вынимаем нужные значения и выводим на график
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
//Функция для получения значения бита по номеру бита и непосредственному значению
//==============================================================================

function OutputValueForBit(value: integer; bitNum: integer): {short}integer;
var
  sdvig: integer;
begin
  //сдвигаем на 1 бит вправо, так как сюда
  //приходит значение не сдвинутое на него для прав значения
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
    //9 и 10. для типа T05 из 10 бит
    9:
    begin
      sdvig := 1;
    end;
    10:
    begin
      sdvig := 0;
    end;
  end;
  //проверяем установлен ли бит номер которого был передан
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
//Сбор быстрого значения T22
//на вход приходит 12 разрядное значение
//==============================================================================
function BuildFastValueT24(value: integer; fastWordNum: integer): integer;
var
  //буфер быстрых. собираем 6 разрядное значение
  fastValBuf: byte;
begin
  fastValBuf := 0;
  //собираем первое слово быстрых. младшие 6 бит
  if fastWordNum = 1 then
  begin
    fastValBuf:=value and 63;
  end;
  //собираем второе слово быстрых. старшие 6 бит
  if fastWordNum = 2 then
  begin
    fastValBuf:=value and 4032;
  end;
  result := fastValBuf;
end;
//==============================================================================

//==============================================================================
//Сбор быстрого значения T22
//на вход приходит 12 разрядное значение
//==============================================================================
function BuildFastValueT22(value: integer; fastWordNum: integer): integer;
var
  //буфер быстрых
  fastValBuf: word;
begin
  fastValBuf := 0;
  //собираем первое слово быстрых
  if fastWordNum = 1 then
  begin
    //отбросили 12 бит. сделали 17
    {fastValBuf:=value shl 5;
    //отбросили 6 младш. битов. 11 бит инф. стал 5. 5 старших битов
    fastValBuf:=fastValBuf shr 11;}
    //1
    if (value and 1024 = 1024) then
    begin
      //записали в младший разряд буфера 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //записали в младший разряд буфера 0
      fastValBuf := fastValBuf shl 1;
    end;
    //2
    if (value and 512 = 512) then
    begin
      //записали в младший разряд буфера 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //записали в младший разряд буфера 0
      fastValBuf := fastValBuf shl 1;
    end;
    //3
    if (value and 256 = 256) then
    begin
      //записали в младший разряд буфера 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //записали в младший разряд буфера 0
      fastValBuf := fastValBuf shl 1;
    end;
    //4
    if (value and 128 = 128) then
    begin
      //записали в младший разряд буфера 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //записали в младший разряд буфера 0
      fastValBuf := fastValBuf shl 1;
    end;
    //5
    if (value and 64 = 64) then
    begin
      //записали в младший разряд буфера 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //записали в младший разряд буфера 0
      fastValBuf := fastValBuf shl 1;
    end;
    //6 бит
    if (value and 4 = 4) then
    begin
      //записали в младший разряд буфера 1
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      //записали в младший разряд буфера 0
      fastValBuf := fastValBuf shl 1;
    end;
  end;
  if fastWordNum = 2 then
  begin
    //отбрасываем 6 старших битов
    fastValBuf := value shl 10; //6 в 16
    //отбрасываем 9 младших битов. 3 старших бита.
    fastValBuf := fastValBuf shr 13;
    //4 бит
    if (value and 2 = 2) then
    begin
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      fastValBuf := fastValBuf shl 1;
    end;
    //5 бит
    if (value and 1 = 1) then
    begin
      fastValBuf := (fastValBuf shl 1) or 1;
    end
    else
    begin
      fastValBuf := fastValBuf shl 1;
    end;
    //6 бит
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
//Вывод на гистограмму быстрых параметров
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
            //ShowMessage('ошибка');
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
//Вывод на гистограмму температурных
//==============================================================================
procedure OutToGistTemp(firstPointValue: integer; outStep: integer;
  masOutSize: integer; var numP: integer);
var
  iPoint: integer;
begin
  //выводим на гист когда активна вкладка температурных
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
//Вывод на гистограмму аналоговых медленных
//==============================================================================
procedure OutToGistSlowAnl(firstPointValue: integer; outStep: integer;
  masOutSize: integer; var numP: integer;typeOfAdr:integer);
var
  iPoint: integer;
begin
  //выводим на гист когда активна вкладка аналог. медл.
  if (form1.PageControl1.ActivePageIndex = 0) then
  begin
    iPoint := firstPointValue;
    iPoint := iPoint{ - 1};


    while iPoint <= masOutSize-1 do
    begin
      //вывод на диа
      //form1.Memo1.Lines.Add('#цикла'+IntToStr(ciklNum)+' №группы:'+IntToStr(groupNum)+
      //' номер канала:'+IntToStr(chanelIndexSlow)+' содержимое канала:'+
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
//Общая процедура вывода на графики
//==============================================================================
procedure OutToGistGeneral;
begin
  //вывод на график для контактных и аналоговых
  if (graphFlagSlowP) then
  begin
    {OutToGistSlowAnl(masElemParam[chanelIndexSlow].numOutElemG,
      masElemParam[chanelIndexSlow].stepOutG,
      {length(masGroup)}{masGroupSize, data.numP); }

    if (masElemParam[chanelIndexSlow].flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп
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
          //необходимо вынимать слова из конкретных групп
          if (masElemParam[chanelIndexSlow].flagGroup) then
          begin
            //необходимо вынимать слова из конкретных групп
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

  //вывод на график темпер. параметров
  if (graphFlagTempP) then
  begin
    if (masElemParam[chanelIndexTemp].flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп
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
          //необходимо вынимать слова из конкретных циклов
          if (masElemParam[chanelIndexTemp].flagGroup) then
          begin
            //необходимо вынимать слова из конкретных групп
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
        //вывод происходит в рамках одной группы
        OutToGistTemp(masElemParam[chanelIndexTemp].numOutElemG,
          masElemParam[chanelIndexTemp].stepOutG,masGroupSize, {data.}numP);
      end;
  end;

  //вывод на диаграмму для быстрых параметров
  if (graphFlagFastP)and(testOutFalg) then
  begin
    OutToGistFastParam(masElemParam[chanelIndexFast].numOutElemG,
      masElemParam[chanelIndexFast].stepOutG, {length(masGroup)}masGroupSize,
      masElemParam[chanelIndexFast].adressType, {data.}numPfast,
      masElemParam[chanelIndexFast].bitNumber);
  end;




  // вывод на диаграмму для БУС
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
//Вывод на диаграмму медленных  главная
//==============================================================================
procedure  outToDiaSGeneral;
var
  orbAdrCount: integer;
begin
  //осуществление разбора очередной строки адреса.
  orbAdrCount := 0;
  //счетчик для подсчета количества аналоговых каналов
  {data.}tempAdrCount := 0;
  //form1.tempDia.Series[0].Clear;
//  if outTempAdr=acumTemp*5 then
//  begin
//    form1.tempDia.Series[0].Clear;
//    outTempAdr:=0;
//  end;



  //Form1.Memo1.Lines.Add('1');
  //sleep(3);
  //последовательно разбираем строка за строкой адреса
  //Орбиты, вынимаем нужные значения и выводим на график
  while orbAdrCount <= iCountMax - 1 do // iCountMax-1
  begin
    if ((masElemParam[orbAdrCount].adressType=0)or
        (masElemParam[orbAdrCount].adressType=8))then
    begin
       //работаем только с медленными параметрами тип Т01
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
  //заполнили 1023 элемента
  if iMasGroup = {1024}{1025}masGroupSize+1 then //!!!!
  begin
    iMasGroup := 1;

    // в зависимости от типа адресов будем отображать на диаграмме
    //либо все точки, либо не все

    //определяем тип активной вкладки
    case form1.PageControl1.ActivePageIndex  of
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
        //БУС {невидима и не используется}
      end;
      3:
      begin
        //температурные
        //если активна вкладка температурных параметров
        //то на гистограмму выводим все точки
        {data.}outToDiaTGeneral;
      end;
    end;




    //вывод всех значений на график
    OutToGistGeneral;

    //проверяем собрали ли 97 значений БУС  0..96
    {if (CollectBusArray(iBusArray)) then
      begin
       //вкл таймер вывода на диаграмму БУС
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
//Вывод медленных аналоговых каналов на диаграмму
//==============================================================================
procedure outToDiaAnl(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel: integer;maxPointInAdr:integer;typeAdr:integer);
var
  //переменная для вычисления смещения для аналоговых каналов
  offsetForYalkAnalog: short;
  nPoint: integer;
  i:Integer;
begin
  //вывод первой точки в массиве firstPointValue для текущего адреса
  //необходимо учитывать смещение для отображения за 1 проход адреса 1 точки
  //вычисление смещения, для каждого типа адреса будет свое смещение
  offsetForYalkAnalog := outStep * (numOutPoint - 1);
  //вычисление номера текущей выводимой точки
  nPoint := firstPointValue + offsetForYalkAnalog;
  //так как массив группы с 0
  nPoint := nPoint{ - 1};

  { while (flagTrue) do
  begin
   Application.ProcessMessages;
  end;
  //вывод на диа
  form1.Memo1.Lines.Add('#цикла'+IntToStr(ciklNum)+' №группы:'+IntToStr(groupNum)+
    ' номер канала:'+IntToStr(numChanel)+'номер точки'+IntToStr(nPoint)+' содержимое канала:'+
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
    //10 битов
    slowArr[iSlowArr].val:=masGroup[nPoint] shr 1;
  end;
  if typeAdr=8 then
  begin
    //9 битов
    slowArr[iSlowArr].val:=masGroup[nPoint] shr 2;
  end;

  inc(iSlowArr);

  //вывод на диа
  //form1.diaSlowAnl.Series[0].AddXY(numChanel, masGroup[nPoint] shr 1);
  //увеличение счетчика выводимой точки адреса
  inc(numOutPoint);
  //проверяем не вышли ли мы за максимальный диапазон для текущего адреса
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
  //счетчик подсчета количества аналоговых адресов
  inc(analogAdrCount);
end;
//==============================================================================

//==============================================================================
//Вывод медленных контактных каналов на диаграмму
//==============================================================================
procedure outToDiaCont(outStep: integer;var numOutPoint: {short}integer;
  firstPointValue: integer;var numChanel: integer;numBitOfValue: short;maxPointInAdr:integer);
var
  nPoint: integer;
  offsetForYalkContact: short;
  i:Integer;
  //для хранения значения контактного канала
  contVal: integer;
begin
  offsetForYalkContact := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkContact;
  //так как массив группы с 0
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
  //счетчик подсчета количества контактных адресов
  inc(contactAdrCount);
  //SaveBitToLog(IntToStr(numChanel-20));
  //if numChanel-20=8 then form1.gistCont.Series[0].Clear;
end;
//==============================================================================

//==============================================================================
//Вывод быстрых каналов Т21 на диаграмму
//==============================================================================
procedure outToDiaFastT21(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  //аккумулятор для быстрых значений T21
  fastValT21: integer;
  offsetForYalkFastParamT21: short;
begin
  //вычисление смещения для вынимания каждый раз следующей
  //точки для данного анализируемого адреса
  //смещение в записи этого адреса будет запоминатся
  offsetForYalkFastParamT21 := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkFastParamT21;
  //так как массив группы с 0
  nPoint := nPoint {- 1};
  fastValT21 := masGroup[nPoint] shr 3; //8 разрядов
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
//Вывод быстрых каналов Т22 на диаграмму
//==============================================================================
procedure outToDiaFastT22(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  //аккумулятор для быстрых значений T22
  fastValT22: integer;
  offsetForYalkFastParamT22: short;
begin
  //вычисление смещения для вынимания каждый раз следующей
  //точки для данного анализируемого адреса
  //смещение в записи этого адреса будет запоминатся
  offsetForYalkFastParamT22 := outStep * (numOutPoint - 1);
  nPoint := firstPointValue + offsetForYalkFastParamT22;
  //так как массив группы с 0
  nPoint := nPoint{ - 1};
  //собираем и выводим первое слово T22
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
//Вывод быстрых каналов Т24 на диаграмму
//==============================================================================
procedure outToDiaFastT24(outStep:integer;var numOutPoint:{short}integer;
  firstPointValue:integer;var numChanel:integer;numBitOfValue:{short}integer;maxPointInAdr:integer);
var
  nPoint: integer;
  //аккумулятор для быстрых значений T24
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
//Вывод температурных каналов на диаграмму
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
  //вывод первой точки в массиве firstPointValue для текущего адреса
  //необходимо учитывать смещение для отображения за 1 проход адреса 1 точки
  //вычисление смещения, для каждого типа адреса будет свое смещение
  offsetForYalkTemp := outStep * (numOutPoint - 1);
  //вычисление номера текущей выводимой точки
  nPoint := firstPointValue + offsetForYalkTemp;
  //так как массив группы с 0
  nPoint := nPoint{ - 1};

  //вывод на диа
  {form1.Memo1.Lines.Add('#цикла'+IntToStr(ciklNum)+' №группы:'+IntToStr(groupNum)+
    ' номер канала:'+IntToStr(numChanel)+' содержимое канала:'+
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
      //получим номер шкалы
      //!!!
      tempArr2[0]:=tempArr[0];
      Dec(tempArr2[0].num);
      tempArr2[1]:=tempArr[length(tempArr)-1];
      inc(tempArr2[1].num);
      for j:=1 to length(tempArr)-2 do
      begin
        tempArr2[j+1]:=tempArr[j];
      end;

      //Если мы начали проверку прибора то устанавливаем колибровки
      if (startTestBlock) then
      begin
        if (countRound=11) then
        begin
          //получаем среднее измерение на каждом канале
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
          //устанавливаем колибровки
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

  //увеличим счетчик выведенных темп. параметров
  Inc(outTempAdr);
  //увеличение счетчика выводимой точки адреса
  inc(numOutPoint);
  //проверяем не вышли ли мы за максимальный диапазон для текущего адреса
  if numOutPoint > maxPointInAdr then
  begin
    numOutPoint := 1;
  end;
  //счетчик подсчета количества аналоговых адресов
  inc(tempAdrCount);
end;
//==============================================================================

//==============================================================================
//Вывод на гистограмму параметров БУС
//==============================================================================
procedure OutToGistBusParam(firstPointValue: integer;outStep: integer;
masOutSize: integer; adrtype: short;var numPfast: integer; numBitOfValue: integer);
var
  iPoint: integer;
  busArrLen:integer;
begin
  //выводим на гист когда активна вкладка аналог. медл.
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
//Вывод на гистограмму
//=============================================================================
procedure outToDia(firstPointValue: integer;outStep: integer;
  masOutSize: integer; var numChanel: integer;typeOfAddres: {short}integer;
  numBitOfValue: {short}integer; busTh: {short}integer; busAdr: {short}integer;var numOutPoint: {short}integer;
  flagGroup:Boolean;flagCikl:Boolean);
var
  nPoint: integer;
  //переменная для вычисления количества
  //точек для каждого нового приходящего адреса
  //переменная вспомогательная и нужна для организации
  //цикличности вывода точек по одной
  maxPointInAdr: integer;
begin
  //вычисляем количество точек в пришедшем адресе
  maxPointInAdr := 0;
  nPoint := firstPointValue;
  while nPoint <= masOutSize do
  begin
    inc(maxPointInAdr);
    nPoint := nPoint + outStep;
  end;

  //вывод производится только если вкладка аналоговых и контактных каналов активна
  if form1.PageControl1.ActivePageIndex = 0 then
  begin
    //вывод для аналоговых каналов   0,8
    if ((typeOfAddres = 0)or(typeOfAddres = 8)) then
    begin
      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп
         //необходимо вынимать слова из конкретных групп
        if isInGroup(groupNum,numChanel) then
        begin
          //form1.Memo1.Lines.Add('#цикла'+IntToStr(ciklNum)+' №группы:'+IntToStr(groupNum)+
    //' номер канала:'+IntToStr(numChanel)+'номер точки'+IntToStr(2)+' содержимое канала:'+
      //IntToStr(masGroup[2] shr 1));
          //вывод происходит в рамках одной группы
          outToDiaAnl(outStep,numOutPoint,firstPointValue,
          numChanel,maxPointInAdr,typeOfAddres);
        end;
      end
      else if (flagCikl) then
      begin
        //необходимо вынимать слова из конкретных циклов
        if isInCikl(ciklNum,numChanel) then
        begin
          //необходимо вынимать слова из конкретных циклов
          if (flagGroup) then
          begin
            //необходимо вынимать слова из конкретных групп
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
          //необходимо вынимать слова из конкретных групп

        end;}
      end
      else
      begin
        //вывод происходит в рамках одной группы
        outToDiaAnl(outStep,numOutPoint,firstPointValue,
          numChanel,maxPointInAdr,typeOfAddres);
      end;
    end;

    //вывод для контактных каналов     1
    if typeOfAddres = 1 then
    begin
      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп

      end
      else if (flagCikl) then
      begin
        //необходимо вынимать слова из конкретных циклов
        if (flagGroup) then
        begin
          //необходимо вынимать слова из конкретных групп
        end;
      end
      else
      begin
        //вывод происходит в рамках одной группы
        outToDiaCont(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;

  //вывод для быстрых параметров
  if form1.PageControl1.ActivePageIndex = 1 then
  begin

    //вывод для быстрых параметров   T22
    if typeOfAddres = 2 then
    begin
      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп

      end
      else if (flagCikl) then
      begin
        //необходимо вынимать слова из конкретных циклов
        if (flagGroup) then
        begin
          //необходимо вынимать слова из конкретных групп
        end;
      end
      else
      begin
        //вывод происходит в рамках одной группы
        outToDiaFastT22(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;

    //вывод для быстрых параметров   T21
    if typeOfAddres = 3 then
    begin
      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп

      end
      else if (flagCikl) then
      begin
        //необходимо вынимать слова из конкретных циклов
        if (flagGroup) then
        begin
          //необходимо вынимать слова из конкретных групп
        end;
      end
      else
      begin
        //вывод происходит в рамках одной группы
        outToDiaFastT21(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;

    //вывод для быстрых параметров   T24
    if typeOfAddres = 5 then
    begin
      if (flagGroup) then
      begin
        //необходимо вынимать слова из конкретных групп

      end
      else if (flagCikl) then
      begin
        //необходимо вынимать слова из конкретных циклов
        if (flagGroup) then
        begin
          //необходимо вынимать слова из конкретных групп
        end;
      end
      else
      begin
        //вывод происходит в рамках одной группы
        outToDiaFastT24(outStep,numOutPoint,firstPointValue,
          numChanel,numBitOfValue,maxPointInAdr);
      end;
    end;
  end;

  //вывод для БУС
  if form1.PageControl1.ActivePageIndex = 4 then
  begin
  end;
end;


//==============================================================================
//Вывод на диаграмму контактных  главная
//==============================================================================
procedure  outToDiaCGeneral;
var
  orbAdrCount: integer;
begin
  //осуществление разбора очередной строки адреса.
  orbAdrCount := 0;
  //счетчик для подсчета количества аналоговых каналов
  {data.}tempAdrCount := 0;
  //form1.tempDia.Series[0].Clear;
//  if outTempAdr=acumTemp*5 then
//  begin
//    form1.tempDia.Series[0].Clear;
//    outTempAdr:=0;
//  end;



  //Form1.Memo1.Lines.Add('1');
  //sleep(3);
  //последовательно разбираем строка за строкой адреса
  //Орбиты, вынимаем нужные значения и выводим на график
  while orbAdrCount <= iCountMax - 1 do // iCountMax-1
  begin
    if masElemParam[orbAdrCount].adressType=1 then
    begin
      //работаем только с контактными адресами T05
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
  //сбор слов для Свята //!!!!!
  //FillSwatWord;
 { if (form1.PageControl1.ActivePageIndex = 3) then
  begin
    //если активна вкладка температурных параметров
    //то на гистограмму выводим все точки
    data.outToDiaTGeneral;
  end
  else
  begin
    form1.TimerOutToDia.Enabled := true;
  end;
  //form1.Memo1.Lines.Add('цикл№:'+intTostr(ciklNum));
  //вывод на графики. Общая процедура.
  OutToGistGeneral; }
  //определяем тип активной вкладки
    case form1.PageControl1.ActivePageIndex  of
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

        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;
      1:
      begin
        //быстрые
        //вывод по таймеру
        form1.TimerOutToDia.Enabled := true;
        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;
      4:
      begin
        //БУС {невидима и не используется}
        if (testFlag_1_1_10_2) then
        begin
          outToDiaTGeneral;
        end;
      end;
      2:
      begin
        //температурные
        //если активна вкладка температурных параметров
        //то на гистограмму выводим все точки
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

    //вывод всех значений на график
    OutToGistGeneral;
end;
//==============================================================================
end.
