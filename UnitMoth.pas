unit UnitMoth;

interface
uses
  LibUnit,OutUnit,SysUtils;
type
   TDataMoth=class(TObject)
    //флаг нахождения первого маркера
    fraseMarkFl: boolean;
    countPointMrFrToMrFr: integer;
    //флаг для осущ. быстрого поиска маркера фразы
    qSearchFl: boolean;
    //флаг для начала счета фраз
    flagCountFrase: boolean;
    //флаг дял начала подсчета групп
    flagCountGroup: boolean;
    //буфер для сбора маркера группы
    bufMarkGroup: int64;
    //буфер для сбора маркера цикла
    bufMarkCircle: int64;
    flfl: boolean;
    iMasGroup: integer;


    //переход на нужное количество точек назад
    procedure FifoBackPoint(countPoint: integer);
    procedure testFillCircleArr(var imasCircle:Integer);
    //процедура сбора слова Орбиты М08,04,02,01
    procedure CalkWordBuf(var countStep:Extended;
      stepToTransOrbOne: extended;var wordBuf: word);
    //анализ четной фразы
    procedure evenFraseAnalyze(wordNum:integer;wordBuf:word;orbInf:string);
    //проверка собранности МГ
    procedure testCollectMG;
    //проверка собранности МГ
    procedure testCollectMC;
    function ReadFromFIFObufB(offset: integer): integer;
    function ReadFromFIFObufN(prevMarkFrBeg: integer; offset: integer): integer;
    //начало текущего маркера, информативность Орбиты
    procedure FillMasGroup(countPointToPrevM: integer;
      currentMarkFrBeg: integer; orbInf: string; var iMasGroup: integer);
    //проверка наличия нужного колич нулей маркера фразы
    function TestMFNull(curNumPoint:Integer;numNulls:integer):Boolean;
    //проверка наличия нужного колич единиц маркера фразы
    function TestMFOnes(curNumPoint:Integer;numOnes:integer):Boolean;
    function QtestMarker(begNumPoint: integer; const pointCounter: integer): boolean;
    //быстрый поиск маркера фразы
    function QfindFraseMark: boolean;
    //переход на нужное количество точек вперед
    procedure FifoNextPoint(countPoint: integer);
    //Функция поиска перехода из 0 в 1
    function SearchP0To1(curPoint:Integer;nextPoint:integer):Boolean;
    //Функция поиска перехода из 1 в 0
    function SearchP1To0(curPoint:Integer;nextPoint:integer):Boolean;
     //чтение 1 значения с кольц.буф
    function ReadFromFIFObuf: integer;
    //поиск первого маркера
    function FindFraseMark(var fifoLevelRead: integer): integer;
    //обработка сигнала для M08,04,02,01
    procedure TreatmentM8_4_2_1;
    procedure WriteToFIFObuf(valueACP: integer);
    constructor CreateData;
   end;

var
  //коеф. для поиска маркера фразы для М08,04,02,01 зависит от информативности
    markKoef:Double;
    widthPartOfMF:integer;
    //количество точек между маркерами фраз в завис. от информативности
    minSizeBetweenMrFrToMrFr:Integer;
implementation
uses
  OrbitaAll,ACPUnit;
//==============================================================================
//
//==============================================================================
constructor TDataMoth.CreateData;
begin
  //счетчики для подсчета количества точек выше и ниже полога
  //numRetimePointUp := 0;
  //numRetimePointDown := 0;
  //переменная флаг для поиска первой фразы
  //firstFraseFl := false;
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
  //iBit := 1;
  //иниц. размерности слова
  //bitSizeWord := 12;
  //pointCount:=0;
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
  //flagOutFraseNum := false;
  groupWordCount:=1; //!!
  //счетчик фраз ,нумерация будет происходить с 1. Фразы с 1 по 128.
  //myFraseNum := 1;
  //начальная иниц. маркера номера группы
  //markerNumGroup := 0;
  //нумерация маркеров номеров группы
  //nMarkerNumGroup := 1;
  //начальная иниц. маркера группы
  //markerGroup := 0;
  countEvenFraseMGToMG:=0;
  //начальная иниц. переменных для разбора сигнала Орбиты М16
  //flagL := true;
  countForMG:=1;
  countErrorMG:=0;
  iMasCircle := {0}1;
  analogAdrCount:=0;
  contactAdrCount:=0;
  tempAdrCount:=0;
  fraseMarkFl := false;
  //нач. иниц флага быстрого поиска
  qSearchFl := false;
  flagCountGroup := false;
  flagCountFrase:=false;
  bufMarkGroup := 0;
  bufMarkCircle := 0;
  flfl := false;
  //нач. иниц счетчика для заполнения массива группы
  iMasGroup := {0}1;
  numP := 0;
  numPfast := {0}1;
end;
//==============================================================================

//==============================================================================
//Функция для чтения из массива фифо нужного элемента  offset -сдвиг для чтения необходимых элементов
//============================================================================
function TDataMoth.ReadFromFIFObufN(prevMarkFrBeg: integer; offset: integer): integer;
var
  fifoOffset: integer;
begin
  //изменяем смещение для правильной выборки
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
  //перемещаем счетчик чтения назад
  if fifoLevelRead <= countPoint then
  begin
    offset := countPoint - fifoLevelRead;
    fifoLevelRead := FIFOSIZE - offset;
  end
  else
  begin
    fifoLevelRead := fifoLevelRead - countPoint;
  end;
  //добавл. точки к счетчику обр. точек в соотв. с fifoLevelRead
  fifoBufCount := fifoBufCount + countPoint;
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
procedure TDataMoth.testFillCircleArr(var imasCircle:Integer);
begin
  //Заполнили 32767 элементов
  if imasCircle = {length(masCircle[reqArrayOfCircle])}masCircleSize+1 then
  begin
    //form1.Memo1.Lines.Add(intToStr(length(masCircle[reqArrayOfCircle])));
    imasCircle := 1;
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
procedure TDataMoth.evenFraseAnalyze(wordNum:integer;wordBuf:word;orbInf:string);
begin
  //если фраза четная и это ее первое слов в 1 слове смотрим 12 бит для сбора
  //маркера группы и цикла .8 разрядов. МГ 01110010. МЦ 10001101
  if wordNum = {9}StrToInt(orbInf[3])+1 then
  begin
    Inc(countEvenFraseMGToMG);

    //проверяем 12 бит
    if ((wordBuf and $800) <> 0) then
    begin
      bufMarkGroup := (bufMarkGroup shl 1) + 1;
    end
    else
    begin
      bufMarkGroup := (bufMarkGroup shl 1) + 0;
    end;

    //между маркерами групп(цикла) по 64 четных фразы
    //проверяем не собрали ли маркер группы 8 бит

//    if groupNum=31 then
//    begin
//      Form1.Memo1.Lines.Add('11');
//    end;



    testCollectMG;

    //проверяем не собрали ли маркер цикла 8 бит
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
    //перевод зн. с АЦП в Орб. нули и единицы
    if (fifoMas[round(countStep)] >= porog) then
    begin
      //запись 1 в нужный бит
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
    //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' МЦ');
    countEvenFraseMGToMG:=0;
    groupNum := 32{1};
    //Writeln(textTestFile,' Найден маркер цикла!');
    //Writeln(textTestFile,' №Группы:'+intTostr(groupNum)+' !!!!!');
    //Form1.Memo1.Lines.Add('Цикл № '+IntToStr(ciklNum));
    //Writeln(textTestFile,' №Цикла:'+intTostr(ciklNum)+' !!');
    Inc(ciklNum);
    if ciklNum=5 then
    begin
      ciklNum:=1;
    end;


    flagCountGroup := true;
    //сбросили маркер цикла
    bufMarkCircle := 0;
  end;
end;
//==============================================================================


//==============================================================================
//Функция для чтения из массива фифо нужного элемента  offset -сдвиг для чтения необходимых элементов
//============================================================================
function TDataMoth.ReadFromFIFObufB(offset: integer): integer;
var
  fifoOffset: integer;
begin
  //изменяем смещение для правильной выборки
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
    //Form1.Memo1.Lines.Add(IntToStr(countEvenFraseMGToMG)+' МФ'); //TO-DO<><><>
    //+1 МГ
    Inc(countForMG);



    if countEvenFraseMGToMG<>64 then
    begin
      //сбой по МГ есть
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
      //выводим число сбоев по МГ
      OutMG(countErrorMG);
      //form1.Memo1.Lines.Add(IntToStr(countErrorMG));
      countErrorMG:=0;
      countForMG:=1;
    end;
    countEvenFraseMGToMG:=0;

    //флаг нумерации фраз
    //flagCountFrase:=true;
    flfl := true;

    //сбросили маркер группы
    //bufMarkGroup := 0;
    if (flagCountGroup) then
    begin
      //Form1.Memo1.Lines.Add('Группа № '+IntToStr(groupNum));
      //Writeln(textTestFile,' ^');
      //Writeln(textTestFile,' |');
      //Writeln(textTestFile,'№Группы:'+intTostr(groupNum)+' !!');
      //form1.Memo1.Lines.Add('№Группы:'+intTostr(groupNum));
//      if  groupNum=30 then
//      begin
//        Form1.Memo1.Lines.Add('МГ');
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
    //Writeln(textTestFile,'Маркер группы найден! '+' Фраза№:'+intTostr(fraseNum));


    //сбросили маркер группы
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
  //в начало каждой процедуры приходит начало нечетной фразы
  wordBuf := 0;
  //считаем количество слов между маркерами от информативности
  //между маркерами всегда 2 фразы
  numWordInByte := StrToInt(orbInf[3]) * 2;
  //вычисляем количество точек кольц. буфера на 1 символ Орбиты
  stepToTransOrbOne := countPointToPrevM / numWordInByte / SIMBOLINWORD;
  //stepToTransOrbOne := markKoef;
  //возвращаемся к началу предидущего маркера фразы
  countStep := ReadFromFIFObufB(countPointToPrevM);
  //countStep := ReadFromFIFObufB(4);
  //смещаемся в середину бита, нач. смещение +4 точки
  //countStep := ReadFromFIFObufN(round(countStep), {MARKMAXSIZE}4); //!! 1 на 2
  //wordCount := 1;

  //if groupNum=32 then
  //begin
    //groupNum:=1;
  //end;

  wordNum:=1;
  //заполняем массив группы Орбиты
  while wordNum <= numWordInByte do
  begin
    //нумеруем фразы после нахождения маркера группы
    //если слово 1 - начало нечетной фразы
    //или 9 начало четной и до этого нашли маркер группы то.

    {if (flagCountFrase) then
    begin
      //Writeln(textTestFile,' №слова:'+intTostr(wordNum)+'+');
    end
    else
    begin
      //Writeln(textTestFile,' №слова:'+intTostr(wordNum)+'-');
    end;  }




    if (((wordNum = 1) or (wordNum = {9}StrToInt(orbInf[3])+1)) and (flagCountFrase)) then
    begin
      //поиск маркера кадра
      //1 в 1 бите 1 слова 16 фразы 1 группы и до этого нашли маркер цикла
      if ((wordNum = 2)and(fraseNum=16)and(groupNum=1)and(flagCountGroup))then
      begin
        //Writeln(textTestFile,'Кадр!'+' №слова:'+intTostr(wordNum)+
            //' №фразы:'+intTostr(fraseNum)+' №группы:'+intTostr(groupNum)+
            //' №цикла:'+intTostr(ciklNum)+' ???');
       { if ((wordBuf and 1) = 1) then
        begin
          //маркер кадра найден
          bufNumGroup:=0;
          //маркер кадра найден
          //bufNumGroup:=0;
          ciklNum:=1;

          flKadr:=True;
          //tlm.flagWriteTLM:=True; //!!!
          //form1.Memo1.Lines.Add('Кадр!');
          //Writeln(textTestFile,'Кадр!'+' №слова:'+intTostr(wordNum)+
            //' №фразы:'+intTostr(fraseNum)+' №группы:'+intTostr(groupNum)+
            //' №цикла:'+intTostr(ciklNum));
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
        end; }
      end;


      //Form1.Memo1.Lines.Add('Фраза № '+IntToStr(fraseNum));
      inc(fraseNum);
      if fraseNum = 129 then
      begin
        fraseNum := 1;
        //первое слово, первой группы, первой фразы. Разрешаем заполнять массив цикла


        if ((wordNum = 1) and (groupNum = 1) and (ciklNum=1)) then
        begin
          if ((tlm.flagWriteTLM){and(flKadr)}) then
          begin
            flSinxC := true;     /// TO-DO
          end;
        end;
      end;

      //Writeln(textTestFile,'№Фразы:'+intTostr(fraseNum));
      //Writeln(textTestFile,' |');
      //Writeln(textTestFile,' v');
      //SaveBitToLog(' Фраза№ '+IntToStr(fraseNum));
    end ;


    //сбор слова Орбиты со старшего бита. 12 разрядов.
    CalkWordBuf(countStep,stepToTransOrbOne,wordBuf);





    //сбор маркера номера группы
    //7 разрядное значение со старшего к младшему
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


    //проверяем четную фразу

    evenFraseAnalyze(wordNum,wordBuf,orbInf);

    //!!



    //получаем информацию, отбрасываем 12 и 1 бит
    if (flagCountFrase) then
    begin
      //запись в группу с младшего слова 11 бит
      masGroup[iMasGroup] := wordBuf and 2047;{((wordBuf and 2047) shr 1)} {wordBuf} //!!!
      //запись в группу с младшего слова 12 бит
      masGroupAll[iMasGroup] := wordBuf and 4095;{((wordBuf and 2047) shr 1)} {wordBuf} //!!!
      inc(iMasGroup);
      //если включена синх. с началом цикла Орбиты
      if (flSinxC) then
      begin
        //запись в цикл 12 битных значений(слов Орбиты)
        masCircle[reqArrayOfCircle][imasCircle] := {((} wordBuf { and 2046) shr 1)};
        inc(imasCircle);
        //проверяем не заполнили ли массив цикла
        testFillCircleArr(imasCircle);
      end;
      //проверяем не заполнили ли массив группы
      testFillGroupArr(iMasGroup);
    end;

    wordBuf := 0;
    //если анализируем последнее слово четной фразы и
    //до этого нашли маркер группы 
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
//Функция поиска нужного количества нулей маркера фразы
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
    //Form1.Memo1.Lines.Add('Нули');
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
//Функция поиска нужного количества единиц маркера фразы
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
  //переместимся к предположительному началу маркера
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
    //Form1.Memo1.Lines.Add('Единицы');
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

  //проверяем мин. разм. маркера
  if (QtestMarker(fifoLevelRead, {MARKMINSIZE}widthPartOfMF)) then
  begin
    testRes := true;
  end;
  {else
  begin
    //проверяем  макс. разм. маркера
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
  //предположительно передан номер середины маркера
  i := begNumPoint;

  testFlag := false;

  if TestMFOnes(i,pointCounter) then
  begin
    if TestMFNull(i,pointCounter) then
    begin
      //это маркер
      testFlag:=true;
    end;
  end;
  {

  testFlag := true;
  //проверяем что нужное количество Орбитовских единиц присутствует
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
  //проверяем что после пров. колич единиц находится столько же нулей
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
  //перемещаем счетчик чтения вперед
  if ((fifoLevelRead + countPoint) > FIFOSIZE) then
  begin
    //вычисляем на сколько больше максимального значения номера точки в цикл. буфере
    offset := (fifoLevelRead + countPoint) - FIFOSIZE;
    fifoLevelRead := offset
  end
  else
  begin
    fifoLevelRead := fifoLevelRead + countPoint;
  end;
  //убавляем. точки от счетчика обр. точек в соотв. с fifoLevelRead
  fifoBufCount := fifoBufCount - countPoint;
end;
//==============================================================================


//==============================================================================
//Функция поиска перехода из 0 в 1
//==============================================================================
function TDataMoth.SearchP0To1(curPoint:Integer;nextPoint:integer):Boolean;
var
  bool:Boolean;
begin
  bool:=False;
  //проверяем переход через порог из 0 в 1
  if ((curPoint < porog) and (nextPoint >= porog)) then
  begin
    bool:=True;
  end;
  result:=bool;
end;
//==============================================================================

//==============================================================================
//Функция поиска перехода из 0 в 1
//==============================================================================
function TDataMoth.SearchP1To0(curPoint:Integer;nextPoint:integer):Boolean;
var
  bool:Boolean;
begin
  bool:=false;
  //проверяем переход через порог из 1 в 0
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
//Функция для поиска маркера фразы. На вход номер точки в кольц.буфере(начало предидущего маркера фр.)
//На выходе номер точки в кольц. буфере(начало след. маркера фр.).
//Возвращает колич. точек между маркерами фр.
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

  //счетчик анализ. точек
  iSearch: integer;
  downToUpFl: boolean;
  //флаг успешности поиска маркера фразы
  searchOKfl: boolean;
  numPointFromFpToMf:Integer;
begin
  //изначально поиск не успешен
  {searchOKfl := false;
  frMarkSize := 0;
  sizeFraseInPoint := 0;
  //можно считать точки пред
  startSearch := false;
  //флаги для поиска ситуации перехода меньше больше
  downToUpFl := false;
  fl := false;
  fl2 := false;
  //ищем маркер фразы в (3)2 размерах колич точек между маркерами
  for iSearch := 1 to MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR * 2 do //3 на 2
  begin
    if (not downToUpFl) then
    begin
      //прочитаем текущую точку
      currentACPVal := ReadFromFIFObuf;
      //+1 точка в счетчик точек между маркерами фраз
      inc(sizeFraseInPoint);
      if ((currentACPVal < porog) and (fifoMas[fifoLevelRead] >= porog)) then
      begin
        fl := true;
      end;
      if ((fl) and (currentACPVal >= porog)) then
      begin
        downToUpFl := true;
        startSearch := true;
        //предположительно точка маркера, засчитываем её
        inc(frMarkSize);
      end;
    end;
    if (startSearch) then
    begin
      currentACPVal := ReadFromFIFObuf;
      //+1 точка в счетчик точек между маркерами фраз
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
          //не маркер
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
  //есть маркер
  begin
      //возвращаем количество точек между маркерами фраз
    result := sizeFraseInPoint - (frMarkSize + 1);
  end
  else
  //нет маркера
  begin
    result := -1;
  end;}

  numPointFromFpToMf:=0;
  //состояние найденности первого перехода из 0 в 1
  downToUpFl:=false;
  searchOKfl:=false;
  sizeFraseInPoint := 0;
  // в двух блоках колич. точек между маркерами ищем переход из 0 в 1
  for iSearch := 1 to {MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR}minSizeBetweenMrFrToMrFr * 2 do //3 на 2
  begin
    //прочитаем текущую точку
    currentACPVal := ReadFromFIFObuf;
    //+1 точка в счетчик точек между маркерами фраз
    inc(sizeFraseInPoint);
    //проверяем переход через порог из 0 в 1
    //если первый переход нашли, то дальше не ищем
    if ((SearchP0To1(currentACPVal,fifoMas[fifoLevelRead]))and(not downToUpFl)) then
    begin
      //нашли первый переход
      downToUpFl:=true;
      //TestSMFOutDate(5,fifoLevelRead,5);
    end;

    if (downToUpFl) then
    begin
      Inc(numPointFromFpToMf);
      //ищем любой переход через порог
      if ((SearchP0To1(currentACPVal,fifoMas[fifoLevelRead]))or
         (SearchP1To0(currentACPVal,fifoMas[fifoLevelRead]))) then
      begin
        //dec(numPointFromFpToMf);//!! для более точного счета 
        //проверяем не нашли ли маркер
        if ((Frac(numPointFromFpToMf/markKoef)>=0.25)and
           (Frac(numPointFromFpToMf/markKoef)<=0.75)) then
         begin
          //TestSMFOutDate(10,fifoLevelRead,10);
          //нашли маркер
          searchOKfl:=True;
          //вышли из поиска
          Break;
         end;
      end;
    end;
  end;
  if (searchOKfl) then
  //есть маркер
  begin
    //возвращаем количество точек между маркерами фраз
    result := sizeFraseInPoint {- (frMarkSize + 1)};
  end
  else
  //нет маркера
  begin
    result := -1;
  end;
end;
//==============================================================================


//==============================================================================
//Обработка данных M08,04,02,01
//==============================================================================
procedure TDataMoth.TreatmentM8_4_2_1;
begin
  //ограничим поиск маркера 3 размерами колич точек между маркерам фраз
  while (fifoBufCount >= MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR * 2) do //!! 3 на 2
  begin
     {while (flagTrue) do
      begin
      Application.ProcessMessages;
      end;}

    //ищем маркер фразы первый
    if (not fraseMarkFl) then
    begin
      countPointMrFrToMrFr := FindFraseMark(fifoLevelRead);
      //TestSMFOutDate(20,fifoLevelRead,1230);
      //while (true) do application.processmessages;
      if ((countPointMrFrToMrFr = -1) and (not flagEnd)) then
      begin
        {showMessage('Ошибка работы! Проверьте подключен ли прибор или наличие данных с него!');
        //closeFile(LogFile);
        acp.AbortProgram(' ', false);
        if ReadThreadErrorNumber <> 0 then
        acp.ShowThreadErrorMessage();
        //else form1.Memo1.Lines.Add(' The program was completed successfully!!!');
        //тест
        halt;
        //Если поток создан , то завершение потока
        if hReadThread <> THANDLE(nil) then
        begin
          //закрыли поток
          //EndThread(hReadThread);
          CloseHandle(hReadThread);
          sleep(50);
          showMessage('Программа была завершена');
          halt;
        end;}
      end;
      //при первом поиске рез. не достоверны
      countPointMrFrToMrFr := 0;
      //первый маркер фразы нашли
      fraseMarkFl := true;
    end
    else
    //нашли маркер фразы
    begin
      if (not qSearchFl) then
      begin
        qSearchFl := true;
      end
      else
      begin
        Inc(countForMF);
        //переместились на нужное количество точек вперед
        FifoNextPoint({MIN_SIZE_BETWEEN_MR_FR_TO_MR_FR}minSizeBetweenMrFrToMrFr);
        //FifoNextPoint(10);
        //TestSMFOutDate(10,fifoLevelRead,10);
        //пров. наличия маркера фразы
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
          //вернулись к исходной точке поиска
          FifoBackPoint(minSizeBetweenMrFrToMrFr);
          //FifoBackPoint(10);
          //переместились на нужное количество точек вперед
          FifoNextPoint(minSizeBetweenMrFrToMrFr + 1);
          //FifoNextPoint(11);
          //пров. наличия маркера фразы
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
            //быстрым точки не нашли
            //вернулись к исходной точке поиска.
            FifoBackPoint(minSizeBetweenMrFrToMrFr + 1);
            //смещаемся на 2 точки вперед чтобы не найти предидущий маркер
            FifoNextPoint(2);
            //FifoBackPoint(11);
            //TestSMFOutDate(1230,fifoLevelRead,1230);
            //while (True) do Application.ProcessMessages;
            //быстрым поиском маркер не нашли, ищем основным
            countPointMrFrToMrFr := FindFraseMark(fifoLevelRead);
            //добавляем 2 точки в подсчет т.к сместились на них вперед
            countPointMrFrToMrFr:=countPointMrFrToMrFr+2;

            //Form1.Memo1.Lines.Add(IntToStr(fifoLevelRead)+' ++');


            Inc(countErrorMF);
            //Form1.Memo1.Lines.Add(IntToStr(countErrorMF)+' '+IntToStr(fifoLevelRead)+' '+IntToStr(countPointMrFrToMrFr));

            if countForMF={100}127 then
            begin
              //while (True) do Application.ProcessMessages; //!!!!
              countForMF:=0;
              //вывод сбоев по маркеру фразы на форму
              OutMF(countErrorMF);
              //проверяем если МФ не находится то и МГ не найдется подавно
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
              {showMessage('Ошибка работы! Проверьте подключен ли прибор и данные с него!');
              halt;}
            end;
            FillMasGroup(countPointMrFrToMrFr, fifoLevelRead,infStr, {data.}iMasGroup);
          end;
        end;
      end;
      //проверим счетчик для подсчета количества маркеров фразы
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
      //остановим работу с АЦП
      pModule.STOP_ADC();
    end;
    //завершим все работающие циклы
    flagEnd:=true;
    wait(100);
    form2.show;
  end;}
end;
//==============================================================================

end.
