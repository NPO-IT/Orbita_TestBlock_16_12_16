unit ACPUnit;

interface

uses
SysUtils,Lusbapi,Windows,Dialogs,ExitForm,LibUnit,UnitM16;

type
  //новый тип. Реализация так называемого двойного буфера.
  TShortrArray = array[0..1] of array of SHORT;

  Tacp = class(TObject)
    //функция для работы с Ацп в отдельномм потоке
    function ReadThread: {DWORD}Longword;
    //вывод сообщения об ошибке
    procedure AbortProgram(ErrorString: string; AbortionFlag: {bool}boolean = true);
    function WaitingForRequestCompleted(var ReadOv: OVERLAPPED): boolean;
    procedure ShowThreadErrorMessage;
    //иниц.
    constructor InitApc;
    procedure CreateApc;
    function SignalPorogCalk(bufMasSize: integer;acpBuf: TShortrArray; reqNumb: word): integer;
  end;

var
  // идентификатор потока ввода
  hReadThread: THANDLE;
  ReadTid: DWORD;
  // флажок завершения потоков ввода данных
  IsReadThreadComplete: boolean;
  // экранный счетчик-индикатор
  Counter, OldCounter: WORD;
  // версия библиотеки Rtusbapi.dll
  DllVersion: DWORD;
  // идентификатор устройства
  ModuleHandle: THandle;
  // скорость работы шины USB
  UsbSpeed: BYTE;
  // структура с полной информацией о модуле
  ModuleDescription: MODULE_DESCRIPTION_E2010;
  // состояние процесса сбора данных
  DataState: DATA_STATE_E2010;
  // буфер пользовательского ППЗУ
  UserFlash: USER_FLASH_E2010;
  // структура параметров работы АЦП
  ap: ADC_PARS_E2010;
  // кол-во отсчетов в запросе ReadData
  DataStep: DWORD;
  // интерфейс модуля E20-10
  pModule: ILE2010;
  // название модуля
  ModuleName: string;
  // указатель на буфер для данных
  Buffer: TShortrArray;
  //номер запроса
  RequestNumber: WORD;
  // вспомогательная стр.
  Str: string;
  // столько блоков по DataStep отсчётов нужно собрать в файл
  NBlockToRead: WORD; // = 4*20;
  //массив OVERLAPPED структур из двух элементов
  ReadOv: array[0..1] of OVERLAPPED;
  // массив структур с параметрами запроса на ввод/вывод данных
  IoReq: array[0..1] of IO_REQUEST_LUSBAPI;
  // номер ошибки при выполнения потока сбора данных
  ReadThreadErrorNumber: WORD;  



implementation

uses
  OrbitaAll;   
//==============================================================================
//Функции по работе с АЦП
//==============================================================================

//==============================================================================
//Подсчет порогового значения данных
//==============================================================================
function Tacp.SignalPorogCalk(bufMasSize: integer;acpBuf: TShortrArray; reqNumb: word): integer;
var
  //максимальное и минимальное значение данных с АЦП
  //maxValue, minValue: integer;
  //счетчик для перебора эл. массива
  jSignalPorogCalk: integer;
begin
  //начальные значения массива
  maxValue := acpBuf[reqNumb xor $1][0];
  minValue := acpBuf[reqNumb xor $1][0];
  for jSignalPorogCalk := 1 to bufMasSize - 1 do
  begin
    //поиск максимума.
    if maxValue <= acpBuf[reqNumb xor $1][jSignalPorogCalk] then
    begin
      maxValue := acpBuf[reqNumb xor $1][jSignalPorogCalk];
    end;
    //поиск минимума
    if minValue >= acpBuf[reqNumb xor $1][jSignalPorogCalk] then
    begin
      minValue := acpBuf[reqNumb xor $1][jSignalPorogCalk];
    end;
  end;
  //к этому моменту min и max найдены.
  //считаем порог. среднее арифметическое
  result := (maxValue + minValue) div 2;
  //SignalPorogCalk:=1984 ;
end;
//==============================================================================

// Отображение ошибок возникших во время работы потока сбора данных
//==============================================================================

procedure Tacp.ShowThreadErrorMessage;
begin
//  case ReadThreadErrorNumber of
//    $0: ;
//    $1: showMessage(' ADC Thread: STOP_ADC() --> Bad! :(((');
//    $2: showMessage(' ADC Thread: ReadData() --> Bad :(((');
//    $3: showMessage(' ADC Thread: Waiting data Error! :(((');
//    // если программа была злобно прервана, предъявим ноту протеста
//    $4: showMessage(' ADC Thread: The program was terminated! :(((');
//    $5: showMessage(' ADC Thread: Writing data file error! :(((');
//    $6: showMessage(' ADC Thread: START_ADC() --> Bad :(((');
//    $7: showMessage(' ADC Thread: GET_DATA_STATE() --> Bad :(((');
//    $8: showMessage(' ADC Thread: BUFFER OVERRUN --> Bad :(((');
//    $9: showMessage(' ADC Thread: Can''t cancel' +
//         ' pending input and output (I/O) operations! :(((');
//    $10: showMessage('Ошибка! Порог не определен!');
//
//    else
//      showMessage(' ADC Thread: Unknown error! :(((');
//  end;

  case ReadThreadErrorNumber of
    $0: ;
    $1: Form1.Memo1.Lines.Add(' ADC Thread: STOP_ADC() --> Bad! :(((');
    $2: Form1.Memo1.Lines.Add(' ADC Thread: ReadData() --> Bad :(((');
    $3: Form1.Memo1.Lines.Add(' ADC Thread: Waiting data Error! :(((');
    // если программа была злобно прервана, предъявим ноту протеста
    $4: Form1.Memo1.Lines.Add(' ADC Thread: The program was terminated! :(((');
    $5: Form1.Memo1.Lines.Add(' ADC Thread: Writing data file error! :(((');
    $6: Form1.Memo1.Lines.Add(' ADC Thread: START_ADC() --> Bad :(((');
    $7: Form1.Memo1.Lines.Add(' ADC Thread: GET_DATA_STATE() --> Bad :(((');
    $8: Form1.Memo1.Lines.Add(' ADC Thread: BUFFER OVERRUN --> Bad :(((');
    $9: Form1.Memo1.Lines.Add(' ADC Thread: Can''t cancel' +
         ' pending input and output (I/O) operations! :(((');
    $10: Form1.Memo1.Lines.Add('Ошибка! Порог не определен!');

    else
      Form1.Memo1.Lines.Add(' ADC Thread: Unknown error! :(((');
  end;
end;
//==============================================================================

//==============================================================================
// Аварийное завершение программы. Вспомогательная подпрограмма для основной
//==============================================================================

procedure Tacp.AbortProgram(ErrorString: string; AbortionFlag: {bool}boolean = true);
var
  i: WORD;
begin
  // освободим интерфейс модуля
  if pModule <> nil then
  begin
    // освободим интерфейс модуля
    if not pModule.ReleaseLInstance() then
    begin
      //form1.Memo1.Lines.Add('ReleaseLInstance() --> Bad')
      showMessage('ReleaseLInstance() --> Bad')
    end
    else
    begin
      //showMessage('ReleaseLInstance() --> OK');
      //form1.Memo1.Lines.Add('ReleaseLInstance() --> OK');
      //обнулим указатель на интерфейс модуля
      pModule := nil;
    end;
    // освободим память из-под буферов данных
    for i := 0 to 1 do
    begin
      Buffer[i] := nil;
    end;
    // если нужно - выводим сообщение с ошибкой
    if ErrorString <> ' ' then
    begin
      MessageBox(HWND(nil),pCHAR(ErrorString),'ОШИБКА!!!', MB_OK + MB_ICONINFORMATION);
    end;
    // если нужно - аварийно завершаем программу
    if AbortionFlag = true then
    begin
      halt;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//      Функция запускаемая в качестве отдельного потока
//             для сбора данных c модуля E20-10
//==============================================================================
function Tacp.ReadThread: DWORD;
var
  indJ: integer;
  iReadThread: WORD;
  m:integer;
begin
  // остановим работу АЦП и одновременно сбросим USB-канал чтения данных
  if not pModule.STOP_ADC() then
  begin
    ReadThreadErrorNumber := 1;
    IsReadThreadComplete := true;
    result := 1;
    exit;
  end;

  // формируем необходимые для сбора данных структуры
  for iReadThread := 0 to 1 do
  begin
    // инициализация структуры типа OVERLAPPED
    ZeroMemory(@ReadOv[iReadThread], sizeof(OVERLAPPED));
    // создаём событие для асинхронного запроса
    ReadOv[iReadThread].hEvent := CreateEvent(nil, FALSE, FALSE, nil);
    // формируем структуру IoReq
    IoReq[iReadThread].Buffer := Pointer(Buffer[iReadThread]);
    IoReq[iReadThread].NumberOfWordsToPass := DataStep;
    IoReq[iReadThread].NumberOfWordsPassed := 0;
    IoReq[iReadThread].Overlapped := @ReadOv[iReadThread];
    IoReq[iReadThread].TimeOut := Round(Int(DataStep / ap.KadrRate)) + 1000;
  end;

  // заранее закажем первый асинхронный сбор данных в Buffer
  RequestNumber := 0;
  if not pModule.ReadData(@IoReq[RequestNumber]) then
  begin
    CloseHandle(IoReq[0].Overlapped.hEvent);
    CloseHandle(IoReq[1].Overlapped.hEvent);
    ReadThreadErrorNumber := 2;
    IsReadThreadComplete := true;
    result := 1;
    exit;
  end;

  //сбор данных
  if pModule.START_ADC() then
  begin
    while hReadThread <> THANDLE(nil) do
    begin
      RequestNumber := RequestNumber xor $1;
      // сделаем запрос на очередную порции вводимых данных
      if not pModule.ReadData(@IoReq[RequestNumber]) then
      begin
        ReadThreadErrorNumber := 2;
        break;
      end;
      if not WaitForSingleObject(IoReq[RequestNumber xor $1].Overlapped.hEvent,
          IoReq[RequestNumber xor $1].TimeOut) = WAIT_TIMEOUT then
      begin
        ReadThreadErrorNumber := 3;
        break;
      end;
      // попробуем получить текущее состояние процесса сбора данных
      if not pModule.GET_DATA_STATE(@DataState) then
      begin
        ReadThreadErrorNumber := 7;
        break;
      end;
      // теперь можно проверить этот признак переполнения
      // внутреннего буфера модуля
      if (DataState.BufferOverrun = (1 shl BUFFER_OVERRUN_E2010)) then
      begin
        ReadThreadErrorNumber := 8;
        break;
      end;
      //При первом проходе считаем пороговое значение
      //if (not data.modC) then
      //begin
        buffDivide := length(buffer[RequestNumber xor $1]);
        //Высчитываем значения порога для дальнейшего анализа массива.
        {data.}porog := acp.SignalPorogCalk(Round(buffDivide/10), buffer,RequestNumber); //!!! Round(data.buffDivide/10)
        //data.modC := true;
      //end;

     { for m:=1 to 3000 do
      begin
      form1.Memo1.Lines.Add(inttostr(m)+'  '+intTostr(buffer[RequestNumber xor $1][m]));
      end;



      while (true) do application.processmessages; }



      //проверяем, что сигнал Орбиты подан.
      if {data.}porog>200 then
      begin
        //Проверяем выбранную информативность
        indJ := 0;
        form2.Hide;
        //M16
        if infNum = 0 then
        begin
          //если не закончена работа с ацп
          if not flagEnd then
          begin
            //переписываем данные в кольц буфер.
            while indJ < buffDivide do
            begin
              dataM16.Add(Buffer[RequestNumber xor $1][indJ]);
              inc(indJ);
            end;
            //разбираем М16
            dataM16.TreatmentM16;
          end;
        end
        //M8,4,2,1
        else
        begin
          if not flagEnd then
          begin
            while indJ < buffDivide do
            begin
              dataMoth.WriteToFIFObuf(Buffer[RequestNumber xor $1][indJ]);
              inc(indJ);
            end;
            //разбираем М8_4_2_1
            dataMoth.TreatmentM8_4_2_1;
          end;
        end;
      end
      else
      begin
        //CloseFile(textTestFile);
        {data.graphFlagFastP := false;

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
        wait(100); }

        //data.modC := false;
        form2.show;

      end;

      // были ли ошибки или пользователь прервал ввод данных?
      if ReadThreadErrorNumber <> 0 then
      begin
        break;
      end
      else
      begin
        //Sleep(20);
      end;

      // увеличиваем счётчик полученных блоков данных(проходов)
      inc(countC);
      {if countC = 12 then
      begin
        form1.Label2.Caption:=IntToStr(countC);
      end;}

      //сброс счетчика циклов чтения. Для работы вечно=).
      if (countC = 32767) then
      begin
        countC := 0;
      end;
      //form1.Label2.Caption := IntToStr(countC);
    end;
  //закрываем считывание.Перестаем запрашивать данные.
  end
  else
  begin
    ReadThreadErrorNumber := 6;
  end;
  // остановим сбор данных c АЦП
  // !!!ВАЖНО!!! Если необходима достоверная информация о целостности
  // ВСЕХ собраных данных, то функцию STOP_ADC() следует выполнять не позднее,
  // чем через 800 мс после окончания ввода последней порции данных.
  // Для заданной частоты сбора данных в 5 МГц эта величина определяет время
  // переполнения внутренненого FIFO буфера модуля, который имеет размер 8 Мб.
  if not pModule.STOP_ADC() then
  begin
    ReadThreadErrorNumber := 1;
  end;
  acp.ShowThreadErrorMessage();
  // если нужно - анализируем окончательный признак
  //переполнения внутреннего буфера модуля
  if (DataState.BufferOverrun <> (1 shl BUFFER_OVERRUN_E2010)) then
  begin
    // попробуем получить окончательный состояние процесса сбора данных
    if not pModule.GET_DATA_STATE(@DataState) then
    begin
      ReadThreadErrorNumber := 7
    end
    // теперь можно проверить этот признак
    //переполнения внутреннего буфера модуля
    else
    begin
      if (DataState.BufferOverrun = (1 shl BUFFER_OVERRUN_E2010)) then
      begin
        ReadThreadErrorNumber := 8;
      end;
    end
  end;
  // если надо, то прервём все незавершённые асинхронные запросы
  if not CancelIo(ModuleHandle) then
  begin
    ReadThreadErrorNumber := 9;
  end;
  // освободим идентификаторы событий
  CloseHandle(IoReq[0].Overlapped.hEvent);
  CloseHandle(IoReq[1].Overlapped.hEvent);
  // задержечка
  //Sleep(100);
  //после сброса очищаем все графики
  form1.diaSlowAnl.Series[0].Clear;
  form1.gistSlowAnl.Series[0].Clear;
  form1.diaSlowCont.Series[0].Clear;
  form1.fastDia.Series[0].Clear;
  form1.fastGist.Series[0].Clear;
  Form1.tempDia.Series[0].Clear;
  Form1.tempGist.Series[0].Clear;
  //после окончательного сброса делаем доступным прием и чтение.
  form1.startReadACP.Enabled:=true;
  form1.startReadTlmB.Enabled:=true;
  result := 0;
end;
//=============================================================================

//==============================================================================
// Ожидание завершения выполнения очередного запроса на сбор данных
//==============================================================================

function Tacp.WaitingForRequestCompleted(var ReadOv: OVERLAPPED): boolean;
var
  BytesTransferred: DWORD;
begin
  Result := true;
  while true do
  begin
    if GetOverlappedResult(ModuleHandle, ReadOv,BytesTransferred, FALSE) then
    begin
      break
    end
    else
    begin
      if (GetLastError() <> ERROR_IO_INCOMPLETE) then
      begin
        // ошибка ожидания ввода очередной порции данных
        ReadThreadErrorNumber := 3;
        Result := false;
        break;
      end
      else
      begin
        //Sleep(20);
      end;
    end;
  end
end;
//==============================================================================


//==============================================================================
//
//==============================================================================
constructor Tacp.InitApc;
begin
  //разм. мас АЦП
  DataStep := 1024 * 1024;
  //счетчик проходов АЦП
  countC := 0;
  // Инициализация флага ошибки. ошибок нет 0. сбросим флаги ошибки потока ввода
  ReadThreadErrorNumber := 0;
end;

//==============================================================================

//=============================================================================
//
//=============================================================================
procedure Tacp.CreateApc;
var
  iGeneralTh, jGeneralTh: integer;
begin
  iGeneralTh := 0;
  //Проверка параметров АЦП.
  //============================================================================
  //проверим версию используемой DLL библиотеки
  //процедура получения Dll версии библиотеки для работы с АЦП
  DllVersion := GetDllVersion;

  //Версия DLL не соответствует.
  if DllVersion <> CURRENT_VERSION_LUSBAPI then
  begin
    Str := 'Неверная версия DLL библиотеки Lusbapi.dll! ' + #10#13 +
    '           Текущая: ' + IntToStr(DllVersion shr 16) +
    '.' + IntToStr(DllVersion and $FFFF) + '.' +
    ' Требуется: ' + IntToStr(CURRENT_VERSION_LUSBAPI shr 16) +
    '.' + IntToStr(CURRENT_VERSION_LUSBAPI and $FFFF) + '.';
    //была получена ошибка касаемо версии, вывели её в
    //системную информацию и закончили выполнение проги.
    AbortProgram(Str);
  end;

  //попробуем получить указатель на интерфейс для модуля E20-10
  //Получаем адрес АЦП в системе
  pModule := CreateLInstance(pCHAR('e2010'));

  //устройство не подключено, указатель nil
  if pModule = nil then
  begin
    AbortProgram('Не могу найти интерфейс модуля E20-10!');
  end;

  // попробуем обнаружить модуль E20-10 в
  //первых MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI виртуальных слотах
  {for iGeneralTh := 0 to (MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI - 1) do
    begin
      if pModule.OpenLDevice(iGeneralTh) then
        begin
          AbortProgram('Не могу найти интерфейс модуля E20-10!');
        end;
    end;}

  //проводим поиск e20-10 в нулевом виртуальном слоте
  iGeneralTh := 0;
  if not pModule.OpenLDevice(iGeneralTh) then
  begin
    AbortProgram('Не могу найти интерфейс модуля E20-10!');
  end;

  //определяем скрость работы USB
  if not pModule.GetUsbSpeed(@UsbSpeed) then
  begin
    AbortProgram(' Не могу определить скорость работы шины USB')
  end;

  {// теперь отобразим скорость работы шины USB}
  if UsbSpeed = USB11_LUSBAPI then
  begin
    Str := 'Full-Speed Mode (12 Mbit/s)';
  end
  else
  begin
    //480 МБит/c   . КОД 1
    Str := 'High-Speed Mode (480 Mbit/s)';
  end;



  //iGeneralTh:=0;
  // что-нибудь обнаружили?
  //Определяем определилось ли устройство. Если нет, то выводим ошибку.
  {if iGeneralTh = MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI then
  begin
    AbortProgram('Не удалось обнаружить модуль E20-10' +
      'в первых 127 виртуальных слотах!');
  end
  else
  begin
    //не нашли ничего
    //вывод адреса устройства
    //form1.Memo1.Lines.Add(Format('OpenLDevice(%u) --> OK', [iGeneralTh]));
  end; }

  // получим идентификатор устройства
  //ModuleHandle := pModule.GetModuleHandle();

  //прочитаем название модуля в текущем виртуальном слоте
  //присвоение модулю АЦП виртуального названия
  ModuleName := '0123456';
  //ModuleName := 'E20-10';


  //Название записалось и считать получилось его?
  if not pModule.GetModuleName(pCHAR(ModuleName)) then
  begin
    AbortProgram('Не могу прочитать название модуля!')
  end;


  {// проверим, что это модуль E20-10}
  if Boolean(AnsiCompareStr(ModuleName, 'E20-10')) then
  begin
    AbortProgram('Обнаруженный модуль не является E20-10!');
  end;

  // Образ для ПЛИС возьмём из соответствующего ресурса DLL библиотеки Lusbapi.dll
  if not pModule.LOAD_MODULE(nil) then
  begin
    AbortProgram('Не могу загрузить модуль E20-10!');
  end;

  if not pModule.TEST_MODULE() then
  begin
    AbortProgram('Ошибка в загрузке модуля E20-10!');
  end;

  if not pModule.GET_MODULE_DESCRIPTION(@ModuleDescription) then
  begin
    AbortProgram('Не могу получить информацию о модуле!');
  end;

  if not pModule.READ_FLASH_ARRAY(@UserFlash) then
  begin
    AbortProgram('Не могу прочитать пользовательское ППЗУ!');
  end;

  if not pModule.GET_ADC_PARS(@ap) then
  begin
    AbortProgram('Не могу получить текущие параметры ввода данных!');
  end;


  if ModuleDescription.Module.Revision = BYTE(REVISIONS_E2010[REVISION_A_E2010]) then
  begin
    // запретим автоматическую корректировку данных на уровне модуля (для Rev.A)
    ap.IsAdcCorrectionEnabled := FALSE
  end
  else
  begin
    //разрешим автоматическую корректировку
    //данных на уровне модуля (для Rev.B и выше)
    ap.IsAdcCorrectionEnabled := TRUE;
    ap.SynchroPars.StartDelay := 0;
    ap.SynchroPars.StopAfterNKadrs := 0;
    ap.SynchroPars.SynchroAdMode := NO_ANALOG_SYNCHRO_E2010;
    //ap.SynchroPars.SynchroAdMode:=ANALOG_SYNCHRO_ON_HIGH_LEVEL_E2010;
    ap.SynchroPars.SynchroAdChannel := $0;
    ap.SynchroPars.SynchroAdPorog := 0;
    ap.SynchroPars.IsBlockDataMarkerEnabled := $0;
  end;

  // внутренний старт сбора с АЦП
  ap.SynchroPars.StartSource := INT_ADC_START_E2010;

  // внешний старт сбора с АЦП
  // ap.SynchroPars.StartSource := EXT_ADC_START_ON_RISING_EDGE_E2010;

  // внутренние тактовые импульсы АЦП
  ap.SynchroPars.SynhroSource := INT_ADC_CLOCK_E2010;

  // фиксация факта перегрузки входных каналов при помощи
  //маркеров в отсчёте АЦП (только для Rev.A)
  // ap.OverloadMode := MARKER_OVERLOAD_E2010;

  // обычная фиксация факта перегрузки входных каналов
  //путём ограничения отсчёта АЦП (только для Rev.A)
  ap.OverloadMode := CLIPPING_OVERLOAD_E2010;

  // кол-во активных каналов
  ap.ChannelsQuantity := CHANNELSQUANTITY;

  //-
  // если активных каналов больше 1.
  {for iGeneralTh := 0 to (ap.ChannelsQuantity - 1) do
    begin
      ap.ControlTable[iGeneralTh] := iGeneralTh;
    end;}

  //запиcываем номер канала в нулевой элемент контрольного массив
  {if (strtoint(form1.ComboBox1.Text)<>0) then }
    //ap.ControlTable[0]:=1;  //присваиваем номер канала(1)

  //+
  // частоту сбора будем устанавливать в зависимости от скорости USB
  // частота АЦП данных в кГц
  // соответствует константе
  ap.AdcRate := AdcRate;
  // в зависимости от скорости USB выставляем
  //межкадровую задержку и размер запроса.
  if UsbSpeed = USB11_LUSBAPI then
  begin
    // межкадровая задержка в мс.
    //Через какое время время будет приходить ответ с АЦП.
    // 12 Mbit/s
    ap.InterKadrDelay := 0.01;
    DataStep := 256 * 1024; // размер запроса
  end
  else
  begin
    // межкадровая задержка в мс  . 1/131072= 0.00007. 7 микро секунд.
    // 480 Mbit/s
    ap.InterKadrDelay := 0.0;
    DataStep := 1024 * 1024; // размер запроса
  end;

  // конфигурим входные каналы . Настройка 4-х аналоговых каналов.
  {for iGeneralTh := 0 to (ADC_CHANNELS_QUANTITY_E2010 - 1) do
    begin
      // входной диапазон 3В
      ap.InputRange[iGeneralTh] := ADC_INPUT_RANGE_3000mV_E2010;
      // источник входа - сигнал
      ap.InputSwitch[iGeneralTh] := ADC_INPUT_SIGNAL_E2010;
    end;}

  iGeneralTh := 0;
  // входной диапазон 3В
  ap.InputRange[iGeneralTh] := ADC_INPUT_RANGE_3000mV_E2010;
  // источник входа - сигнал
  ap.InputSwitch[iGeneralTh] := ADC_INPUT_SIGNAL_E2010;

  // передаём в структуру параметров работы АЦП корректировочные коэффициенты АЦП
  //задаем погрешность и параметры измерения АЦП аналоговых сигналов
  {for iGeneralTh := 0 to (ADC_INPUT_RANGES_QUANTITY_E2010 - 1) do
    begin
      for jGeneralTh := 0 to (ADC_CHANNELS_QUANTITY_E2010 - 1) do
        begin
          // корректировка смещения
          ap.AdcOffsetCoefs[iGeneralTh][jGeneralTh] :=
            ModuleDescription.Adc.OffsetCalibration[jGeneralTh +
              iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];
          // корректировка масштаба
          ap.AdcScaleCoefs[iGeneralTh][jGeneralTh] :=
            ModuleDescription.Adc.ScaleCalibration[jGeneralTh +
              iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];
        end;
    end;}

  iGeneralTh:=0;
  jGeneralTh:=0;
  // корректировка смещения
  ap.AdcOffsetCoefs[iGeneralTh][jGeneralTh] :=
    ModuleDescription.Adc.OffsetCalibration[jGeneralTh +
      iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];
  // корректировка масштаба
  ap.AdcScaleCoefs[iGeneralTh][jGeneralTh] :=
    ModuleDescription.Adc.ScaleCalibration[jGeneralTh +
      iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];

  // передадим в модуль требуемые параметры по вводу данных
  // записываем параметры ввода в АЦП
  // не удалось записать
  if not pModule.SET_ADC_PARS(@ap) then
  begin
    AbortProgram('Не могу установить параметры ввода данных!');
  end;


  // попробуем выделить нужное кол-во памяти под буфера данных
  for iGeneralTh := 0 to 1 do
  begin
    SetLength(Buffer[iGeneralTh], DataStep);
    ZeroMemory(Buffer[iGeneralTh], DataStep * SizeOf(SHORT));
  end;

  // запустим поток сбора данных
  hReadThread := BeginThread(nil, 0, @Tacp.ReadThread, nil, 0, ReadTid);
  if hReadThread = THANDLE(nil) then
  begin
    AbortProgram('Не могу запустить поток сбора данных!');
  end;
end;
//==============================================================================

end.
