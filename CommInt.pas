//******************************************************************************
//                      VARIAN ASYNC32 COMPONENT
//               (c) VARIAN SOFTWARE SERVICES NL 1996-1998
//                          ALL RIGHTS RESERVED
//******************************************************************************
//  Remaked by Artyom Dokukin. Russia, Ivanovo, NeuroSoft, 2000-2002
//******************************************************************************

unit CommInt;

interface

uses
  Windows, Messages, SysUtils, Classes, CommObjs;

const
  DefaultDeviceName = 'COM1';

type
  ECommError = class(Exception)
    ErrorCode: Integer;
  end;

  TCommEvent = procedure(Sender: TObject; Status: DWORD) of object;
  TCommEventType = (evBreak, evCts, evDsr, evError, evRing, evRlsd, evRxChar, evRxFlag, evTxEmpty);
  TCommEventTypes = set of TCommEventType;

  TCommEventThread = class(TThread)
  private
    FCommHandle: THandle;
    FEvent: TSimpleEvent;
    FEventMask: DWORD;
    FSleepTime: DWORD;
    FOnSignal: TCommEvent;
  protected
    procedure Execute; override;
    procedure Terminate;
    procedure DoOnSignal;
  public
    constructor Create(Handle: THandle; Events: TCommEventTypes; CreateSuspended: Boolean; SleepTime: DWORD);
    destructor Destroy; override;
    property OnSignal: TCommEvent read FOnSignal write FOnSignal;
  end;

  TCustomComm = class;

  TCommEventChars = class(TPersistent)
  private
    FOwner: TCustomComm;
    FXonChar: Char;
    FXoffChar: Char;
    FErrorChar: Char;
    FEofChar: Char;
    FEvtChar: Char;
    procedure SetEventChar(Index: Integer; Value: Char);
  public
    constructor Create(Owner: TCustomComm);
    procedure Assign(Source: TPersistent); override;
  published
    property XonChar: Char index 1 read FXOnChar write SetEventChar default #17;
    property XoffChar: Char index 2 read FXOffChar write SetEventChar default #19;
    property ErrorChar: Char index 3 read FErrorChar write SetEventChar default #0;
    property EofChar: Char index 4 read FEofChar write SetEventChar default #0;
    property EvtChar: Char index 5 read FEvtChar write SetEventChar default #0;
  end;

  TBaudrate =(br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
    br19200, br38400, br56000, br57600, br115200, br128000, br4800000);
  TParity = (paNone, paOdd, paEven, paMark, paSpace);
  TStopbits = (sb10, sb15, sb20);
  TDatabits=(da4, da5, da6, da7, da8);
  TFlowControl = (fcNone, fcCTS, fcDTR, fcSoftware, fcDefault);

  TCommOption = (coParityCheck, coDsrSensitivity, coIgnoreXOff, coErrorChar, coNullStrip);
  TCommOptions = set of TCommOption;

  TCommRxCharEvent = procedure(Sender: TObject; Count: Integer) of object;
  TCommErrorEvent = procedure(Sender: TObject; Errors: Integer) of object;

  TCustomComm = class(TComponent)
  private
    FHandle: THandle;
    FDCB: TDCB;
    FDeviceName: string;
    FEvent: TSimpleEvent;
    FCriticalSection: TCriticalSection;
    FReadTimeout: Integer;
    FWriteTimeout: Integer;
    FReadBufSize: Integer;
    FWriteBufSize: Integer;
    FMonitorEvents: TCommEventTypes;
    FBaudRate: TBaudRate;
    FParity: TParity;
    FStopbits: TStopbits;
    FDatabits: TDatabits;
    FEventThread: TCommEventThread;
    FEventChars: TCommEventChars;
    FOptions: TCommOptions;
    FFlowControl: TFlowControl;
    FScanDelay: DWORD;
    FOnBreak: TNotifyEvent;
    FOnCts: TNotifyEvent;
    FOnDsr: TNotifyEvent;
    FOnError: TCommErrorEvent;
    FOnRing: TNotifyEvent;
    FOnRlsd: TNotifyEvent;
    FOnRxChar: TCommRxCharEvent;
    FOnRxFlag: TNotifyEvent;
    FOnTxEmpty: TNotifyEvent;
    procedure SetDeviceName(const Value: string);
    procedure SetMonitorEvents(Value: TCommEventTypes);
    procedure SetReadBufSize(Value: Integer);
    procedure SetWriteBufSize(Value: Integer);
    procedure SetBaudRate(Value: TBaudRate);
    procedure SetParity(Value: TParity);
    procedure SetStopbits(Value: TStopBits);
    procedure SetDatabits(Value: TDatabits);
    procedure SetOptions(Value: TCommOptions);
    procedure SetFlowControl(Value: TFlowControl);
    function GetModemState(Index: Integer): Boolean;
    function GetComState(Index: Integer): Boolean;
    procedure Lock;
    procedure Unlock;
    procedure CheckOpen;
    procedure EscapeComm(Flag: Integer);
    procedure InitHandshaking(var DCB: TDCB);
    procedure UpdateCommTimeouts;
  protected
    procedure CreateHandle; virtual;
    procedure DestroyHandle;
    procedure HandleCommEvent(Sender: TObject; Status: DWORD);
    procedure UpdateDataControlBlock;
    property DeviceName: string read FDeviceName write SetDeviceName;
    property ReadTimeout: Integer read FReadTimeout write FReadTimeout default 1000;
    property WriteTimeout: Integer read FWriteTimeout write FWriteTimeout default 1000;
    property ReadBufSize: Integer read FReadBufSize write SetReadBufSize default 4096;
    property WriteBufSize: Integer read FWriteBufSize write SetWriteBufSize default 2048;
    property MonitorEvents: TCommEventTypes read FMonitorEvents write SetMonitorEvents;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate default br9600;
    property Parity: TParity read FParity write SetParity default paNone;
    property Stopbits: TStopbits read FStopbits write SetStopbits default sb10;
    property Databits: TDatabits read FDatabits write SetDatabits default da8;
    property EventChars: TCommEventChars read FEventChars;
    property Options: TCommOptions read FOptions write SetOptions;
    property FlowControl: TFlowControl read FFlowControl write SetFlowControl default fcDefault;
    property ScanDelay: DWORD read FScanDelay write FScanDelay default 10;
    property OnBreak: TNotifyEvent read FOnBreak write FOnBreak;
    property OnCts: TNotifyEvent read FOnCts write FOnCts;
    property OnDsr: TNotifyEvent read FOnDsr write FOnDsr;
    property OnRing: TNotifyEvent read FOnRing write FOnRing;
    property OnRlsd: TNotifyEvent read FOnRlsd write FOnRlsd;
    property OnError: TCommErrorEvent read FOnError write FOnError;
    property OnRxChar: TCommRxCharEvent read FOnRxChar write FOnRxChar;
    property OnRxFlag: TNotifyEvent read FOnRxFlag write FOnRxFlag;
    property OnTxEmpty: TNotifyEvent read FOnTxEmpty write FOnTxEmpty;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open(StartReading: Boolean = True);
    procedure StartReading;
    procedure Close;
    function Enabled: Boolean;
    function Write(var Buf; Count: Integer): Integer;
    function Read(var Buf; Count: Integer): Integer;
    function InQueCount: Integer;
    function OutQueCount: Integer;
    procedure PurgeIn;
    procedure PurgeOut;
    // Comm escape functions
    procedure SetDTRState(State: Boolean);
    procedure SetRTSState(State: Boolean);
    procedure SetBREAKState(State: Boolean);
    procedure SetXONState(State: Boolean);
    // Comm status flags
    property CTS: Boolean index 1 read GetModemState;
    property DSR: Boolean index 2 read GetModemState;
    property RING: Boolean index 3 read GetModemState;
    property RLSD: Boolean index 4 read GetModemState;

    property CtsHold: Boolean index 1 read GetComState;
    property DsrHold: Boolean index 2 read GetComState;
    property RlsdHold: Boolean index 3 read GetComState;
    property XoffHold: Boolean index 4 read GetComState;
    property XOffSent: Boolean index 5 read GetComState;

    property Handle: THandle read FHandle;
  end;

  TComm = class(TCustomComm)
  published
    property DeviceName;
    property ReadTimeout;
    property WriteTimeout;
    property ReadBufSize;
    property WriteBufSize;
    property MonitorEvents;
    property BaudRate;
    property Parity;
    property Stopbits;
    property Databits;
    property EventChars;
    property Options;
    property FlowControl;
    property ScanDelay;
    property OnBreak;
    property OnCts;
    property OnDsr;
    property OnRing;
    property OnRlsd;
    property OnError;
    property OnRxChar;
    property OnRxFlag;
    property OnTxEmpty;
  end;

function FormatCommError(ErrCode: Integer): string;

procedure Register;

implementation

resourcestring
  SOpenError = 'Ошибка доступа к устройству'; // 'Error accessing specified device'
  SInvalidHandle = 'Неверный дескриптор устройства, доступ запрещен'; // 'Invalid device handle, access denied'
  SPortAlreadyOpen = 'Порт уже открыт'; // 'Port already assigned (open)'
  SPortNotOpen = 'Порт не открыт, невозможно завершить операцию'; // 'Port not open, unable to complete operation'
  SSetupCommErr = 'Ошибка инициализации буферов чтения/записи'; // 'Error initializing Read/Write Buffers'
  SUpdateDCBErr = 'Ошибка обновления DCB (Data Control Block)'; // 'Error updating DataControlBlock'
  SCommTimeoutsErr = 'Ошибка обновления тайм-аутов'; // 'Error updating CommTimeouts'
  SEscFuncError = 'Ошибка EscapeCommFunction'; // 'EscapeCommFunction failure'
  SReadError = 'Ошибка чтения'; // 'Read error'
  SWriteError = 'Ошибка записи'; // 'Write error'
  SMsgExtention = ' (Код: %d) '; //' (Code: %d) '
  SMODEError = 'Неверный режим или дескриптор порта'; // The requested mode is not supported, or the hFile parameter is invalid. If this value is specified, it is the only valid error
  SBREAKError = 'Обрыв связи'; // The hardware detected a break condition
  SDNSError = 'Параллельное устройство не выбрано'; // A parallel device is not selected
  SFRAMEError = 'Ошибка фрейма'; // The hardware detected a framing error
  SIOEError = 'Ошибка ввода/вывода'; // An I/O error occurred during communications with the device
  SOOPError = 'Нет бумаги'; // A parallel device signaled that it is out of paper
  SOVERRUNError = 'Переполнение буфера символа'; // A character-buffer overrun has occurred. The next character is lost
  SPTOError = 'Время ожидания параллельного устройства истекло'; // A time-out occurred on a parallel device
  SRXOVERError = 'Переполнение входного буфера'; // An input buffer overflow has occurred. There is either no room in the input buffer, or a character was received after the end-of-file (EOF) character
  SRXPARITYError = 'Ошибка четности'; // The hardware detected a parity error
  STXFULLError = 'Переполнение выходного буфера'; // The application tried to transmit a character, but the output buffer was full
  SNoErrors = 'Нет ошибок';

const
  PurgeRead      = PURGE_RXABORT + PURGE_RXCLEAR;
  PurgeWrite     = PURGE_TXABORT + PURGE_TXCLEAR;
  PurgeReadWrite = PurgeRead + PurgeWrite;

  fBinary              = $00000001;
  fParity              = $00000002;
  fOutxCtsFlow         = $00000004;
  fOutxDsrFlow         = $00000008;
  fDtrControl          = $00000030;
  fDtrControlDisable   = $00000000;
  fDtrControlEnable    = $00000010;
  fDtrControlHandshake = $00000020;
  fDsrSensitivity      = $00000040;
  fTXContinueOnXoff    = $00000080;
  fOutX                = $00000100;
  fInX                 = $00000200;
  fErrorChar           = $00000400;
  fNull                = $00000800;
  fRtsControl          = $00003000;
  fRtsControlDisable   = $00000000;
  fRtsControlEnable    = $00001000;
  fRtsControlHandshake = $00002000;
  fRtsControlToggle    = $00003000;
  fAbortOnError        = $00004000;
  fDummy2              = $FFFF8000;

  CommEventList: array [TCommEventType] of DWORD =
    (EV_BREAK, EV_CTS, EV_DSR, EV_ERR, EV_RING, EV_RLSD, EV_RXCHAR, EV_RXFLAG, EV_TXEMPTY);

  CommBaudRates: array [TBaudRate] of Integer =
    (CBR_110, CBR_300, CBR_600, CBR_1200, CBR_2400, CBR_4800, CBR_9600, CBR_14400,
     CBR_19200, CBR_38400, CBR_56000, CBR_57600, CBR_115200, CBR_128000, 4800000);

  CommOptions: array [TCommOption] of Integer = (fParity, fDsrSensitivity, fTXContinueOnXoff, fErrorChar, fNull);

  CommDataBits: array [TDatabits] of Integer = (4, 5, 6, 7, 8);

  CommParity: array [TParity] of Integer = (NOPARITY, ODDPARITY, EVENPARITY, MARKPARITY, SPACEPARITY);

  CommStopBits: array [TStopbits] of Integer = (ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS );

{ RaiseCommError }

procedure RaiseCommError(Msg: string; ErrCode: Integer);
var
  E: ECommError;
begin
  E := ECommError.Create(Msg + Format(SMsgExtention, [ErrCode]));
  E.ErrorCode := ErrCode;
  raise E;
end;

function FormatCommError(ErrCode: Integer): string;

  procedure AddError(E: string);
  begin
    if Result <> '' then Result := Format('%s; %s', [Result, E]) else Result := E;
  end;

begin
  Result := '';
  if (ErrCode and CE_MODE) = CE_MODE then AddError(SMODEError)
  else
    begin
      if (ErrCode and CE_BREAK) = CE_BREAK then AddError(SBREAKError);
      if (ErrCode and CE_DNS) = CE_DNS then AddError(SDNSError);
      if (ErrCode and CE_FRAME) = CE_FRAME then AddError(SFRAMEError);
      if (ErrCode and CE_IOE) = CE_IOE then AddError(SIOEError);
      if (ErrCode and CE_OOP) = CE_OOP then AddError(SOOPError);
      if (ErrCode and CE_OVERRUN) = CE_OVERRUN then AddError(SOVERRUNError);
      if (ErrCode and CE_PTO) = CE_PTO then AddError(SPTOError);
      if (ErrCode and CE_RXOVER) = CE_RXOVER then AddError(SRXOVERError);
      if (ErrCode and CE_RXPARITY) = CE_RXPARITY then AddError(SRXPARITYError);
      if (ErrCode and CE_TXFULL) = CE_TXFULL then AddError(STXFULLError);
    end;
  if Result = '' then Result := SNoErrors;
end;

var CancelIOEntry: FARPROC = nil;

procedure StopIO(Handle: THandle);
type
  CancleIOProc = procedure (Handle: THandle); stdcall;
begin
  if CancelIOEntry <> nil then CancleIOProc(CancelIOEntry)(Handle);
end;

{ TCommEventThread }

constructor TCommEventThread.Create(Handle: THandle; Events: TCommEventTypes;
  CreateSuspended: Boolean; SleepTime: DWORD);
var
  EvIndex: TCommEventType;
  AttrWord: DWORD;
begin
  // Priority := tpHigher;
  FCommHandle := Handle;
  AttrWord := $0;
  for EvIndex := evBreak to evTxEmpty do
    if EvIndex in Events then AttrWord := AttrWord or CommEventList[EvIndex];
  SetCommMask(FCommHandle, AttrWord);
  FEvent := TSimpleEvent.Create;
  FSleepTime := SleepTime;
  inherited Create(CreateSuspended);
end;

destructor TCommEventThread.Destroy;
begin
  FEvent.Free;
  inherited Destroy;
end;

procedure TCommEventThread.Execute;
var
  Overlapped: TOverlapped;
  WaitEventResult: Boolean;
begin
  FillChar(Overlapped, Sizeof(Overlapped), 0);
  Overlapped.hEvent := FEvent.Handle;
  while not Terminated do
    begin
      WaitEventResult := WaitCommEvent(FCommHandle, FEventMask, @Overlapped);
      if (GetLastError = ERROR_IO_PENDING) then
        WaitEventResult := (FEvent.WaitFor(INFINITE) = wrSignaled);
      if Terminated then
        // сбрасываем текущую асинхронную операцию (WaitCommEvent)
        StopIO(FCommHandle)
      else
        if WaitEventResult then
          begin
            Synchronize(DoOnSignal);
            FEvent.ResetEvent;
            Sleep(FSleepTime);
          end;
    end;
end;

procedure TCommEventThread.Terminate;
begin
  inherited Terminate;
  FEvent.SetEvent;
  if Suspended then Resume;
  WaitFor;
end;

procedure TCommEventThread.DoOnSignal;
begin
  if Assigned(FOnSignal) then FOnSignal(Self, FEventMask);
end;

{ TCommEventChars }

constructor TCommEventChars.Create(Owner: TCustomComm);
begin
  inherited Create;
  FOwner := Owner;
  FXonChar := #17;
  FXoffChar := #19;
  FErrorChar := #0;
  FEofChar := #0;
  FEvtChar := #0;
end;

procedure TCommEventChars.SetEventChar(Index: Integer; Value: Char);
begin
  case Index of
    1: FXOnChar := Value;
    2: FXOffChar := Value;
    3: FErrorChar := Value;
    4: FEofChar := Value;
    5: FEvtChar := Value;
  end;
  if FOwner <> nil then
    FOwner.UpdateDataControlBlock;
end;

procedure TCommEventChars.Assign(Source: TPersistent);
begin
  if (Source <> nil) and (Source is TCommEventChars) then
    begin
      FXonChar := TCommEventChars(Source).FXonChar;
      FXoffChar := TCommEventChars(Source).FXoffChar;
      FErrorChar := TCommEventChars(Source).FErrorChar;
      FEofChar := TCommEventChars(Source).FEofChar;
      FEvtChar := TCommEventChars(Source).FEvtChar;
    end
  else
    inherited Assign(Source);
end;

{ TCustomComm }

constructor TCustomComm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := INVALID_HANDLE_VALUE;
  FDeviceName := DefaultDeviceName;
  FReadTimeout := 1000;
  FWriteTimeout := 1000;
  FReadBufSize := 4096;
  FWriteBufSize := 2048;
  FMonitorEvents := [evBreak, evCts, evDsr, evError, evRing, evRlsd, evRxChar, evRxFlag, evTxEmpty];
  FBaudRate := br9600;
  FParity := paNone;
  FStopbits := sb10;
  FDatabits := da8;
  FOptions := [];
  FFlowControl := fcDefault;
  FScanDelay := 10;
  FEventChars := TCommEventChars.Create(self);
  FEvent := TSimpleEvent.Create;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TCustomComm.Destroy;
begin
  Close;
  FEventChars.Free;
  FEvent.Free;
  FCriticalSection.Free;
  inherited Destroy;
end;

procedure TCustomComm.Lock;
begin
  FCriticalSection.Enter;
end;

procedure TCustomComm.Unlock;
begin
  FCriticalSection.Leave;
end;

function TCustomComm.Enabled: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

procedure TCustomComm.CheckOpen;
begin
  if Enabled then RaiseCommError(SPortAlreadyOpen, -1);
end;

procedure TCustomComm.CreateHandle;
begin
  FHandle := CreateFile(PCHAR(FDeviceName), GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if not Enabled then RaiseCommError(SOpenError, GetLastError);
  if GetFileType(FHandle) <> FILE_TYPE_CHAR then
    begin
      DestroyHandle;
      RaiseCommError(SInvalidHandle, -1);
    end;
end;

procedure TCustomComm.DestroyHandle;
begin
  // завершаем асинхронные операции
  StopIO(FHandle);
  // чистим порт
  PurgeComm(FHandle, PurgeReadWrite);
  CloseHandle(FHandle);
  FHandle := INVALID_HANDLE_VALUE;
end;

procedure TCustomComm.Open(StartReading: Boolean = True);
begin
  CheckOpen;
  CreateHandle;
  if Enabled then
    begin
      FEventThread := TCommEventThread.Create(FHandle, FMonitorEvents, not StartReading, ScanDelay);
      FEventThread.OnSignal := HandleCommEvent;
      UpdateCommTimeouts;
      UpdateDataControlBlock;
      if not SetupComm(FHandle, FReadBufSize, FWriteBufSize) then
        RaiseCommError(SSetupCommErr, GetLastError);
    end;
end;

procedure TCustomComm.Close;
begin
  if Enabled then
    begin
      FEventThread.Terminate;
      FEventThread.Free;
      DestroyHandle;
    end;
end;

procedure TCustomComm.StartReading;
begin
  if Enabled then FEventThread.Resume;
end;

function TCustomComm.Write(var Buf; Count: Integer): Integer;
var
  Overlapped: TOverlapped;
  ErrorCode: Integer;
begin
  Lock;
  try
    FillChar(Overlapped, Sizeof(Overlapped), 0);
    Overlapped.hEvent := FEvent.Handle;
    if not WriteFile(FHandle, Buf, Count, DWORD(Result),
      @Overlapped) and (GetLastError <> ERROR_IO_PENDING) then
      begin
        ErrorCode := GetLastError;
        RaiseCommError(SWriteError, ErrorCode);
      end;
    if FEvent.WaitFor(FWriteTimeout) <> wrSignaled then
      Result := -1
    else
      begin
        GetOverlappedResult(Handle, Overlapped, DWORD(Result), False);
        FEvent.ResetEvent;
      end;
  finally
    Unlock;
  end;
end;

function TCustomComm.Read(var Buf; Count: Integer): Integer;
var
  Overlapped: TOverlapped;
  ErrorCode: Integer;
begin
  Lock;
  try
    FillChar(Overlapped, Sizeof(Overlapped), 0);
    Overlapped.hEvent := FEvent.Handle;
    if not ReadFile(FHandle, Buf, Count, DWORD(Result),
      @Overlapped) and (GetLastError <> ERROR_IO_PENDING) then
      begin
        ErrorCode := GetLastError;
        RaiseCommError(SReadError, ErrorCode);
      end;
    if FEvent.WaitFor(FReadTimeout) <> wrSignaled then
      Result := -1
    else
      begin
        GetOverlappedResult(Handle, Overlapped, DWORD(Result), False);
        FEvent.ResetEvent;
      end;
  finally
    Unlock;
  end;
end;

function TCustomComm.InQueCount: Integer;
var
  ComStat: TComStat;
  Errors: DWORD;
begin
  if Enabled then
    begin
      ClearCommError(FHandle, Errors, @ComStat);
      Result := ComStat.cbInQue;
    end
  else
    Result := -1;
end;

function TCustomComm.OutQueCount: Integer;
var
  ComStat: TComStat;
  Errors: DWORD;
begin
  if Enabled then
    begin
      ClearCommError(FHandle, Errors, @ComStat);
      Result := ComStat.cbOutQue;
    end
  else
    Result := -1;
end;

procedure TCustomComm.PurgeIn;
begin
  if Enabled then PurgeComm(FHandle, PurgeRead);
end;

procedure TCustomComm.PurgeOut;
begin
  if Enabled then PurgeComm(FHandle, PurgeWrite);
end;

procedure TCustomComm.SetDeviceName(const Value: string);
begin
  if FDeviceName <> Value then
    begin
      CheckOpen;
      FDeviceName := Value;
    end;
end;

procedure TCustomComm.SetMonitorEvents(Value: TCommEventTypes);
begin
  if FMonitorEvents <> Value then
    begin
      CheckOpen;
      FMonitorEvents := Value;
    end;
end;

procedure TCustomComm.SetReadBufSize(Value: Integer);
begin
  if FReadBufSize <> Value then
    begin
      CheckOpen;
      FReadBufSize := Value;
    end;
end;

procedure TCustomComm.SetWriteBufSize(Value: Integer);
begin
  if FWriteBufSize <> Value then
    begin
      CheckOpen;
      FWriteBufSize := Value;
    end;
end;

procedure TCustomComm.SetBaudRate(Value: TBaudRate);
begin
  if FBaudRate <> Value then
    begin
      FBaudRate := Value;
      UpdateDataControlBlock;
    end;
end;

procedure TCustomComm.SetParity(Value: TParity);
begin
  if FParity <> Value then
    begin
      FParity := Value;
      UpdateDataControlBlock;
    end;
end;

procedure TCustomComm.SetStopbits(Value: TStopbits);
begin
  if FStopBits <> Value then
    begin
      FStopbits := Value;
      UpdateDataControlBlock;
  end;
end;

procedure TCustomComm.SetDataBits(Value: TDatabits);
begin
  if FDataBits <> Value then
    begin
      FDataBits:=Value;
      UpdateDataControlBlock;
    end;
end;

procedure TCustomComm.SetOptions(Value: TCommOptions);
begin
  if FOptions <> Value then
    begin
      FOptions := Value;
      UpdateDataControlBlock;
    end;
end;

procedure TCustomComm.SetFlowControl(Value: TFlowControl);
begin
  if FFlowControl <> Value then
    begin
      FFlowControl := Value;
      UpdateDataControlBlock;
    end;
end;

procedure TCustomComm.HandleCommEvent(Sender: TObject; Status: DWORD);
var
  ComStat: TComStat;
  Errors: DWORD;
begin
  ClearCommError(FHandle, Errors, @ComStat);
  if (Status and EV_BREAK > 0) and Assigned(FOnBreak) then FOnBreak(Self);
  if (Status and EV_CTS > 0) and Assigned(FOnCts) then FOnCts(Self);
  if (Status and EV_DSR > 0) and Assigned(FOnDsr) then FOnDsr(Self);
  if ((Status and EV_ERR > 0) or (Errors > 0)) and Assigned(FOnError) then FOnError(Self, Errors);
  if (Status and EV_RING > 0) and Assigned(FOnRing) then FOnRing(Self);
  if (Status and EV_RLSD > 0) and Assigned(FOnRlsd) then FOnRlsd(Self);
  if (Status and EV_RXCHAR > 0) and (ComStat.cbInQue > 0) and Assigned(FOnRxChar) then FOnRxChar(Self, ComStat.cbInQue);
  if (Status and EV_RXFLAG > 0) and Assigned(FOnRxFlag) then FOnRxFlag(Self);
  if (Status and EV_TXEMPTY > 0) and Assigned(FOnTxEmpty) then FOnTxEmpty(Self);
end;

function TCustomComm.GetModemState(Index: Integer): boolean;
var
  Flag, State: DWORD;
begin
  case Index of
    1: State := MS_CTS_ON;
    2: State := MS_DSR_ON;
    3: State := MS_RING_ON;
    4: State := MS_RLSD_ON;
  else
    State := 0;
  end;
  Result := False;
  if Enabled then
    if GetCommModemStatus(FHandle, Flag) then Result := (Flag and State > 0);
end;

function TCustomComm.GetComState(Index: Integer): Boolean;
var
  Flag: TComStateFlag;
  ComStat: TComStat;
  Errors: DWORD;
begin
  case Index of
    1: Flag := fCtlHold;
    2: Flag := fDsrHold;
    3: Flag := fRlsHold;
    4: Flag := fXoffHold;
    5: Flag := fXOffSent;
    else
      Flag := fCtlHold;
  end;
  Result := False;
  if Enabled then
    begin
      ClearCommError(FHandle, Errors, @ComStat);
      Result := Flag in ComStat.Flags;
    end;
end;

procedure TCustomComm.UpdateDataControlBlock;
var
  OptIndex: TCommOption;
begin
  if Enabled then
    begin
      GetCommState(FHandle, FDCB);

      FDCB.BaudRate := CommBaudRates[FBaudRate];
      FDCB.Parity := CommParity[FParity];
      FDCB.Stopbits := CommStopbits[FStopbits];
      FDCB.Bytesize := CommDatabits[FDatabits];
      FDCB.XonChar := FEventChars.XonChar;
      FDCB.XoffChar := FEventChars.XOffChar;
      FDCB.ErrorChar := FEventChars.ErrorChar;
      FDCB.EofChar := FEventChars.EofChar;
      FDCB.EvtChar := FEventChars.EvtChar;
      FDCB.XonLim := FReadBufSize div 4;
      FDCB.XoffLim := FReadBufSize div 4;

      InitHandshaking(FDCB);

      for OptIndex := coParityCheck to coNullStrip do
        if OptIndex in FOptions then FDCB.Flags := FDCB.Flags or CommOptions[OptIndex]
          else FDCB.Flags := FDCB.Flags and not CommOptions[OptIndex];

      if not SetCommState(FHandle, FDCB) then RaiseCommError(SUpdateDCBErr, GetLastError);
    end;
end;

procedure TCustomComm.EscapeComm(Flag: Integer);
var
  Escaped: Boolean;
begin
  if Enabled then
    begin
      Escaped := EscapeCommFunction(FHandle, Flag);
      if not Escaped then RaiseCommError(SEscFuncError, GetLastError);
    end
  else
    RaiseCommError(SPortNotOpen, -1);
end;

procedure TCustomComm.SetDTRState(State: boolean);
const
  DTR: array [Boolean] of Integer = (CLRDTR, SETDTR);
begin
  EscapeComm(DTR[State]);
end;

procedure TCustomComm.SetRTSState(State: boolean);
const
  RTS: array [Boolean] of Integer = (CLRRTS, SETRTS);
begin
  EscapeComm(RTS[State]);
end;

procedure TCustomComm.SetBREAKState(State: Boolean);
const
  BREAK: array [Boolean] of Integer = (CLRBREAK, SETBREAK);
begin
  EscapeComm(BREAK[State]);
  if Enabled then PurgeComm(FHandle, PurgeReadWrite);
end;

procedure TCustomComm.SetXONState(State: Boolean);
const
  XON: array [Boolean] of Integer = (SETXOFF, SETXON);
begin
  EscapeComm(XON[State]);
end;

procedure TCustomComm.UpdateCommTimeouts;
var
  CommTimeouts: TCommTimeouts;
begin
  FillChar(CommTimeOuts, Sizeof(CommTimeOuts), 0);
  CommTimeOuts.ReadIntervalTimeout := MAXDWORD;
  if not SetCommTimeOuts(FHandle, CommTimeOuts) then
    RaiseCommError(SCommTimeoutsErr, GetLastError);
end;

procedure TCustomComm.InitHandshaking(var DCB: TDCB);
begin
  case FFlowControl of
    fcNone: DCB.Flags := fBinary; // Clear all flags
    fcDefault:; // do nothing
    fcCTS: DCB.Flags := DCB.Flags or fOutxCtsFlow or fRtsControlHandshake;
    fcDTR: DCB.Flags := DCB.Flags or fOutxDsrFlow or fDtrControlHandshake;
    fcSoftware: DCB.Flags := DCB.Flags or fOutX or fInX;
  end;
end;

procedure SetupCancelIO;
var
  M: HMODULE;
begin
  M := GetModuleHandle('KERNEL32.DLL');
  if M <> 0 then CancelIOEntry := GetProcAddress(M, 'CancelIo');
end;

procedure Register;
begin
  RegisterComponents('NS Components', [TComm]);
end;

initialization
  SetupCancelIO;

end.

