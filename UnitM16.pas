unit UnitM16;

interface
uses
  LibUnit,OutUnit;

type
  TDataM16=class(TObject)
    //счетчик количества повторяющихся точек выше порога
    numRetimePointUp: integer;
    //счетчик количества повторяющихся точек ниже порога
    numRetimePointDown: integer;
    //флаг показывающий что первая фраза найдена
    firstFraseFl: boolean;
    //счетчик для сбора 12 разр. слова Орбиты
    iBit: integer;
    //переменная разрядность кода. количество битов в слове.
    bitSizeWord: integer;
    //количество точек через которое должен начаться след. маркер
    pointCount: integer;
    //текущее значение измерения из кольцевого буфера
    current: integer;
    //флаг вывода фраз, что до этого была найдена 128 фраза
    flagOutFraseNum: boolean;
    //переменная для моей внутренней нумерации групп
    myFraseNum: integer;
    //беззнаковая. 8 битов.
    markerNumGroup: byte;
     //для нумерации выводов номеров маркеров групп в файл
    nMarkerNumGroup: integer;
    //знаковая. 8 битов
    markerGroup: byte;
    //для сбора слов Орбиты
    flagL: boolean;
    //аккум. 11 разр. слова Орбиты. на графики
    wordInfo: integer;

    procedure add(signalElemValue: integer);
    //обработка сигнала для M16
    procedure treatmentM16;
    //конструктор
    constructor createData;
    //разбор фразы
    procedure AnalyseFrase;
    //поиск маркера фразы
    procedure SearchFirstFraseMarker;
    procedure WordProcessing;
    //запись бита орбиты в слово
    procedure FillBitInWord;
    function Read(): integer; overload;
    function Read(offset: integer): integer; overload;
    //сбор маркера номера группы
    procedure CollectMarkNumGroup;
    //сбор маркера группы
    procedure CollectMarkGroup;
    //заполнение массива группы
    procedure FillArrayGroup;
    //заполнение массива цикла
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
  //счетчики для подсчета количества точек выше и ниже полога
  numRetimePointUp := 0;
  numRetimePointDown := 0;
  //переменная флаг для поиска первой фразы
  firstFraseFl := false;
  //флаг для синхронизации заполнения массива цикла с 1 слова первого цикла
  flBeg := false;
  //счетчик слов Орбиты
  wordNum := 1;
  fraseNum:=1;
  groupNum:=1;
  ciklNum:=1;
  //флага синхронизации для вывода и заполнения с 1 кадра 1 цикла 1 группы 1 фразы 1 слова
  flSinxC:=False;
  //флаг индикации нахождения маркера кадра
  flKadr:=False;
  startWriteMasGroup := false;
  //счетчик битов для отсчета размерности слов
  iBit := 1;
  //иниц. размерности слова
  bitSizeWord := 12;
  pointCount:=0;
  codStr := 0;
  //флаги для вывода на гистограмму
  graphFlagSlowP := false;
  graphFlagFastP := false;
  graphFlagBusP := false;
  graphFlagTempP := false;
  //счетчик для подсчета найденных маркеров фразы
  countForMF:=0;
  //счетчик подсчета сбоев по МФ за группу
  countErrorMF:=0;
  //переменная размерности буфера.
  buffDivide := 0;
  //начальная инициализация флага вывода номера группы
  flagOutFraseNum := false;
  groupWordCount:=1; //!!
  //счетчик фраз ,нумерация будет происходить с 1. Фразы с 1 по 128.
  myFraseNum := 1;
  //начальная иниц. маркера номера группы
  markerNumGroup := 0;
  //нумерация маркеров номеров группы
  nMarkerNumGroup := 1;
  //начальная иниц. маркера группы
  markerGroup := 0;
  countEvenFraseMGToMG:=0;
  //начальная иниц. переменных для разбора сигнала Орбиты М16
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
  //Заполнили 65535 элементов
  if imasCircle = {length(masCircle[reqArrayOfCircle])}masCircleSize+1 then
  begin
    imasCircle := 1;

    //Form1.Memo1.Lines.Add('Цикл №'+intTostr(ciklNum)+' '+'Группа №'+intTostr(groupNum)
    //+' '+'Фраза №'+intTostr(fraseNum)+' '+'Слово №'+intTostr(wordNum));


    //массив цикла заполнен. пишем в файл ТЛМ
    //если запись в тлм активна то пишем блок(цикл Орбиты в него)
    if (tlm.flagWriteTLM) then
    begin
      if infNum = 0 then
      begin
        //M16
        tlm.WriteTLMBlockM16(tlm.msTime);
      end
      else
      begin
        //другие информативности
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
  //берем младшие 11 разрядов. старший отбрасываем. МЧ-младший бит.
  wordInfo := (codStr and 2047) {shr 1};
  //12 битов
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
  //проверяем 12 бит, если там 1 то в конец маркера запишем 1
  if ((codStr and 2048) = 2048) then
  begin
    markerGroup := (markerGroup shl 1) or 1;
  end
  else
  begin
    //0 в конец маркера запишем 0
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
    //проверяем 12 бит, если там 1
    //то в конец маркера запишем 1
    if ((codStr and 2048) = 2048) then
    begin
      markerNumGroup := (markerNumGroup shl 1) or 1;
    end
    else
      //0 в конец маркера запишем 0
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
//Чтение значения из масива Орбиты
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
//Функция для чтения из массива фифо битов Орбиты побуферно
//offset -сдвиг для чтения необходимых элементов
//============================================================================
function TDataM16.Read(offset: integer): integer;
var
  fifoOffset: integer;
begin
  //изменяем смещение для правильной выборки
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
//Заполнение бита Орб. слова в слово Орбиты
//==============================================================================
procedure TDataM16.FillBitInWord;
begin
  //считываем значение из кольц. буфера согласно счетчику чтения
  current := Read;
  //переменная в которую собираем 12 разрядное слово
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
  //для вывода в тлм. Для записи с первого цикла
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

  //сбор 12 битного Орбитовского слова
  while iBit <= bitSizeWord do
  begin
    {счетчик для подсчета точек по 383. Для быстрого поиска маркера фразы}
    if pointCount = -1 then
    begin
      //сброс флага найденности маркера
      firstFraseFl := false;
      break;
    end;
    dec(pointCount);

    FillBitInWord;

    //собрали 12 битное Орбитовское слово
    //Обработаем его
    WordProcessing;

    //в случаем принуд. оконч. работы с АЦП выйти из выполнения
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
    //увелич. счетчик битов соб. слова Орбиты
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
  //читаем значение текущей точки в кольцевом буфере
  current := Read;
  Inc(countForMF);
  //ищем первую нечетную фразу.
  //через 24 т.к анализируем первые биты нечетных слов начиная с нечетной фразы и заканчивая четной
  if ((current = 0) and (Read(24) = 1) and (Read(48) = 1) and
      (Read(72) = 1) and (Read(96) = 1) and (Read(120) = 0) and
      (Read(144) = 0) and (Read(168) = 0) and (Read(216) = 1) and
      (Read(240) = 0) and (Read(264) = 0) and (Read(288) = 1) and
      (Read(312) = 1) and (Read(336) = 0) and (Read(360) = 1)) then
  begin
    //нашли маркер первой нечетной фразы и в дальнейшем будем его проверять
    firstFraseFl := true;
    //счетчик количества (битов слова орбиты)точек через который маркер фразы должен повториться
    pointCount := 383;
    //сдвигаемся на прошлую точку
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
  //выше
  if signalElemValue >= porog then
  begin
    //счетчик выше
    inc(numRetimePointUp);
    //анализируем счетчик точек ниже порога
    outStep := round(numRetimePointDown / (10 / 3.145728));
    //если шаг получается нулевым, то 1
    if ((numRetimePointUp = 1)and(outStep = 0)) then
    begin
      outStep := 1;
    end;

    for iOutInFile := 1 to outStep do
    begin
      //В зависимости от выбора типа сигнала определяем как трактовать значения
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
      //сколько значений лежит в массиве
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
    //счетчик ниже
    inc(numRetimePointDown);
    //анализируем счетчик точек выше порога
    outStep := round(numRetimePointUp / (10 / 3.145728));
    if ((numRetimePointDown = 1)and(outStep = 0)) then
    begin
      outStep := 1;
    end;
    for iOutInFile := 1 to outStep do
    begin

      //fifoMas[fifoLevelWrite] := 1;
      //В зависимости от выбора типа сигнала определяем как трактовать значения
      if (form1.rb1.Checked) then
      begin
        fifoMas[fifoLevelWrite] := 1;
      end;

      if (form1.rb2.Checked) then
      begin
        fifoMas[fifoLevelWrite] := 0;
      end;


      inc(fifoLevelWrite);
      //сколько значений лежит в массиве
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
//Обработка данных M16
//==============================================================================
procedure TDataM16.treatmentM16;
begin
  //пока точек в кольц буфере больше этого числа, разбираем
  while ((fifoBufCount >= 100000)and(not flagEnd)) do  ///!!!
  begin
    //поиск маркера первой нечетной фразы
    //поиск происходит каждый раз
    if (not firstFraseFl) then
    begin
      SearchFirstFraseMarker;
      //form1.tmrForTestOrbSignal.Enabled:=True;
    end
    else
    begin
      //если нашли маркер то производим разбор
      AnalyseFrase;
    end;
    // в случае сброса выход из выполнения
    {if flagEnd then
    begin
      break;
    end;}
  end;

  //проверяем что в буфере АЦП порог данных не соответствует 200 и меньше.
  //нет сигнала
  if acp.SignalPorogCalk(round(buffDivide/10), buffer,RequestNumber)<=200 then   ///!!! round(buffDivide/10)
  begin
    outMF(127);
    //Form1.Memo1.Lines.Add('11');
    outMG(31);
  end;
end;
//==============================================================================

//==============================================================================
//Обработка слова Орбиты
//==============================================================================
procedure TDataM16.WordProcessing;
begin
  if iBit = bitSizeWord then
  begin
    //если номер слова 1 значит это новая фраза
    if wordNum = 1 then
    begin
      //form1.Memo1.Lines.Add('Фраза №'+IntToStr(fraseNum));
      //проверяем что до этого нашли 128 фразу.
      if (flagOutFraseNum) then
      begin

        //Form1.Memo1.Lines.Add('#слова '+intToStr(wordNum)+' #фразы '+intToStr(fraseNum)+
        //'#группы '+intToStr(groupWordCount));
        //поиск маркера кадра
        //1 в 1 бите 1 слова 16 фразы 1 группы
        if ((wordNum = 1)and(fraseNum=16)and(groupNum=1))then
        begin
          if ((codStr and {1}2048) = {1}2048) then
          begin
            //маркер кадра найден
            //bufNumGroup:=0;
            ciklNum:=1;

            flKadr:=True;
            //tlm.flagWriteTLM:=True; //!!!
            //form1.Memo1.Lines.Add('Кадр!');

            //Writeln(textTestFile,'Кадр!');
            //Writeln(textTestFile,' |');
            //Writeln(textTestFile,' v');
            //Writeln(textTestFile,'!!Цикл 1');
            //Writeln(textTestFile,' |');
            //Writeln(textTestFile,' v');
          end
          else
          begin
            //маркер кадра не найден
          end;
        end;


        {if fraseNum=126 then
         begin
          SaveBitToLog('Фраза 126:'+codStr);
         end;}
        //SaveBitToLog('Фраза №'+IntToStr(fraseNum)+' ');
        //Writeln(textTestFile,'Фраза№:'+intTostr(fraseNum));
        if fraseNum = 1 then
        begin
          //нумеруем с 1 т.к массив группы с 1
          groupWordCount := {0}1;
          //разрешаем запись в массив группы
          //startWriteMasGroup := true;  //!!
        end;
      end;



      //-----------------------
      //поиск маркера группы
      //-----------------------
      //смотрим четную фразу
      if (myFraseNum mod 2 = 0) then
      begin
        //сбор маркера номера группы
        CollectMarkNumGroup;
        //сбор маркера группы
        CollectMarkGroup;

        Inc(countEvenFraseMGToMG);

        //проверяем не собрали ли маркера группы или маркер цикла
        if ((markerGroup = 114) or (markerGroup = 141)) then
        //нашли маркер
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
            //нашли маркер группы
            begin
              //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' МГ'); //TO-DO <><><>
              Inc(countForMG);

              //form1.Memo1.Lines.Add('Группа№:'+intTostr(groupNum));
              //Writeln(textTestFile,' ^');
              //Writeln(textTestFile,' |');
              //Writeln(textTestFile,'Группа№:'+intTostr(groupNum));
              Inc(groupNum);
              if groupNum=33 then
              begin
                groupNum:=1;
              end;

              //+1 МГ
              if countEvenFraseMGToMG<>64 then
              begin
                //сбой по МГ есть
                Inc(countErrorMG);
              end;

              if countForMG={100}32 then
              begin
                //выводим число сбоев по МГ
                OutMG(countErrorMG);
                countErrorMG:=0;
                countForMG:=1;
              end;

              countEvenFraseMGToMG:=0;
              //счетчику cлов в группе начало массива
              //data.groupWordCount:=0;
              //разрешаем запись в массив группы
              startWriteMasGroup:=true; ///!!
            end;

            //----------------------------
            //цикл
            //----------------------------
            if markerGroup = 141 then
            //нашли маркер цикла
            begin
              //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' МЦ');
              countEvenFraseMGToMG:=0;
              //Writeln(textTestFile,' ^');
              //Writeln(textTestFile,' |');
              //Writeln(textTestFile,'Группа№:'+intTostr(groupNum));
              groupNum:={32}1;
              //form1.Memo1.Lines.Add('цикл№:'+intTostr(ciklNum));
              //Writeln(textTestFile,' ^');
              //Writeln(textTestFile,' |');
              //Writeln(textTestFile,'цикл№:'+intTostr(ciklNum));
              Inc(ciklNum);
              if ciklNum=5 then
              begin
                ciklNum:=1;
                if ((tlm.flagWriteTLM)and(flKadr)) then
                begin
                  flBeg := true;
                end;
              end;

              //SaveBitToLog('Номер группы '+'32');
//               flBeg := false;
//                if ((tlm.flagWriteTLM)and(flKadr)) then
//                begin
//                  flBeg := true;
//                end;
            end;
            //----------------------------
            markerGroup := 0;
            //выставление флага вывода номера группы
            flagOutFraseNum := true;
          end;
        end
      end;

      //----------------------------------
      inc(myFraseNum);
      //проверяем нумерацию фраз,
      //для того чтобы не выйти за границы.
      //Моя внутреняя нумерация.
      if myFraseNum = 129 then
      begin
        myFraseNum := 1;
      end;
      //form1.Memo1.Lines.Add('фраза№:'+intTostr(fraseNum));
      //Writeln(textTestFile,'Фраза№:'+intTostr(fraseNum));
      inc(fraseNum);
      //проверяем нумерацию фраз,
      //для того чтобы не выйти за границы.
      //Нумерация для вывода.
      if fraseNum = 129 then
      begin
        fraseNum := 1;
        //groupWordCount := {0}1;
      end;
    end;

    // к моменту когда проанализировали 12 бит,
    // мы уже собрали значение слова
    //вывод номера слова и собранного значения
    //SaveBitToLog('Cловo №'+IntToStr(wordNum)+
    //' Значение слова:'+IntToStr(codStr));
    if (startWriteMasGroup) then
    begin
      FillArrayGroup;
      //если включена синх. с началом (цикла)кадра Орбиты
      if (flSinxC) then
      begin
        FillArrayCircle;
      end;
      //проверяем не заполнен ли массив группы
      // орбитовские слова с 0 по 2047. счетчик 2048
      if groupWordCount = masGroupSize+1 then
      begin
        OutDate;
      end;
    end;
    codStr := 0;
    inc(wordNum);


    if wordNum = 17 then
    begin
      //нумерация
      wordNum := 1;
    end;
  end;
end;
//==============================================================================
end.
