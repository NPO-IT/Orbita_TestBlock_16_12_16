unit ACPUnit;

interface

uses
SysUtils,Lusbapi,Windows,Dialogs,ExitForm,LibUnit,UnitM16;

type
  //����� ���. ���������� ��� ����������� �������� ������.
  TShortrArray = array[0..1] of array of SHORT;

  Tacp = class(TObject)
    //������� ��� ������ � ��� � ���������� ������
    function ReadThread: {DWORD}Longword;
    //����� ��������� �� ������
    procedure AbortProgram(ErrorString: string; AbortionFlag: {bool}boolean = true);
    function WaitingForRequestCompleted(var ReadOv: OVERLAPPED): boolean;
    procedure ShowThreadErrorMessage;
    //����.
    constructor InitApc;
    procedure CreateApc;
    function SignalPorogCalk(bufMasSize: integer;acpBuf: TShortrArray; reqNumb: word): integer;
  end;

var
  // ������������� ������ �����
  hReadThread: THANDLE;
  ReadTid: DWORD;
  // ������ ���������� ������� ����� ������
  IsReadThreadComplete: boolean;
  // �������� �������-���������
  Counter, OldCounter: WORD;
  // ������ ���������� Rtusbapi.dll
  DllVersion: DWORD;
  // ������������� ����������
  ModuleHandle: THandle;
  // �������� ������ ���� USB
  UsbSpeed: BYTE;
  // ��������� � ������ ����������� � ������
  ModuleDescription: MODULE_DESCRIPTION_E2010;
  // ��������� �������� ����� ������
  DataState: DATA_STATE_E2010;
  // ����� ����������������� ����
  UserFlash: USER_FLASH_E2010;
  // ��������� ���������� ������ ���
  ap: ADC_PARS_E2010;
  // ���-�� �������� � ������� ReadData
  DataStep: DWORD;
  // ��������� ������ E20-10
  pModule: ILE2010;
  // �������� ������
  ModuleName: string;
  // ��������� �� ����� ��� ������
  Buffer: TShortrArray;
  //����� �������
  RequestNumber: WORD;
  // ��������������� ���.
  Str: string;
  // ������� ������ �� DataStep �������� ����� ������� � ����
  NBlockToRead: WORD; // = 4*20;
  //������ OVERLAPPED �������� �� ���� ���������
  ReadOv: array[0..1] of OVERLAPPED;
  // ������ �������� � ����������� ������� �� ����/����� ������
  IoReq: array[0..1] of IO_REQUEST_LUSBAPI;
  // ����� ������ ��� ���������� ������ ����� ������
  ReadThreadErrorNumber: WORD;  



implementation

uses
  OrbitaAll;   
//==============================================================================
//������� �� ������ � ���
//==============================================================================

//==============================================================================
//������� ���������� �������� ������
//==============================================================================
function Tacp.SignalPorogCalk(bufMasSize: integer;acpBuf: TShortrArray; reqNumb: word): integer;
var
  //������������ � ����������� �������� ������ � ���
  //maxValue, minValue: integer;
  //������� ��� �������� ��. �������
  jSignalPorogCalk: integer;
begin
  //��������� �������� �������
  maxValue := acpBuf[reqNumb xor $1][0];
  minValue := acpBuf[reqNumb xor $1][0];
  for jSignalPorogCalk := 1 to bufMasSize - 1 do
  begin
    //����� ���������.
    if maxValue <= acpBuf[reqNumb xor $1][jSignalPorogCalk] then
    begin
      maxValue := acpBuf[reqNumb xor $1][jSignalPorogCalk];
    end;
    //����� ��������
    if minValue >= acpBuf[reqNumb xor $1][jSignalPorogCalk] then
    begin
      minValue := acpBuf[reqNumb xor $1][jSignalPorogCalk];
    end;
  end;
  //� ����� ������� min � max �������.
  //������� �����. ������� ��������������
  result := (maxValue + minValue) div 2;
  //SignalPorogCalk:=1984 ;
end;
//==============================================================================

// ����������� ������ ��������� �� ����� ������ ������ ����� ������
//==============================================================================

procedure Tacp.ShowThreadErrorMessage;
begin
//  case ReadThreadErrorNumber of
//    $0: ;
//    $1: showMessage(' ADC Thread: STOP_ADC() --> Bad! :(((');
//    $2: showMessage(' ADC Thread: ReadData() --> Bad :(((');
//    $3: showMessage(' ADC Thread: Waiting data Error! :(((');
//    // ���� ��������� ���� ������ ��������, ��������� ���� ��������
//    $4: showMessage(' ADC Thread: The program was terminated! :(((');
//    $5: showMessage(' ADC Thread: Writing data file error! :(((');
//    $6: showMessage(' ADC Thread: START_ADC() --> Bad :(((');
//    $7: showMessage(' ADC Thread: GET_DATA_STATE() --> Bad :(((');
//    $8: showMessage(' ADC Thread: BUFFER OVERRUN --> Bad :(((');
//    $9: showMessage(' ADC Thread: Can''t cancel' +
//         ' pending input and output (I/O) operations! :(((');
//    $10: showMessage('������! ����� �� ���������!');
//
//    else
//      showMessage(' ADC Thread: Unknown error! :(((');
//  end;

  case ReadThreadErrorNumber of
    $0: ;
    $1: Form1.Memo1.Lines.Add(' ADC Thread: STOP_ADC() --> Bad! :(((');
    $2: Form1.Memo1.Lines.Add(' ADC Thread: ReadData() --> Bad :(((');
    $3: Form1.Memo1.Lines.Add(' ADC Thread: Waiting data Error! :(((');
    // ���� ��������� ���� ������ ��������, ��������� ���� ��������
    $4: Form1.Memo1.Lines.Add(' ADC Thread: The program was terminated! :(((');
    $5: Form1.Memo1.Lines.Add(' ADC Thread: Writing data file error! :(((');
    $6: Form1.Memo1.Lines.Add(' ADC Thread: START_ADC() --> Bad :(((');
    $7: Form1.Memo1.Lines.Add(' ADC Thread: GET_DATA_STATE() --> Bad :(((');
    $8: Form1.Memo1.Lines.Add(' ADC Thread: BUFFER OVERRUN --> Bad :(((');
    $9: Form1.Memo1.Lines.Add(' ADC Thread: Can''t cancel' +
         ' pending input and output (I/O) operations! :(((');
    $10: Form1.Memo1.Lines.Add('������! ����� �� ���������!');

    else
      Form1.Memo1.Lines.Add(' ADC Thread: Unknown error! :(((');
  end;
end;
//==============================================================================

//==============================================================================
// ��������� ���������� ���������. ��������������� ������������ ��� ��������
//==============================================================================

procedure Tacp.AbortProgram(ErrorString: string; AbortionFlag: {bool}boolean = true);
var
  i: WORD;
begin
  // ��������� ��������� ������
  if pModule <> nil then
  begin
    // ��������� ��������� ������
    if not pModule.ReleaseLInstance() then
    begin
      //form1.Memo1.Lines.Add('ReleaseLInstance() --> Bad')
      showMessage('ReleaseLInstance() --> Bad')
    end
    else
    begin
      //showMessage('ReleaseLInstance() --> OK');
      //form1.Memo1.Lines.Add('ReleaseLInstance() --> OK');
      //������� ��������� �� ��������� ������
      pModule := nil;
    end;
    // ��������� ������ ��-��� ������� ������
    for i := 0 to 1 do
    begin
      Buffer[i] := nil;
    end;
    // ���� ����� - ������� ��������� � �������
    if ErrorString <> ' ' then
    begin
      MessageBox(HWND(nil),pCHAR(ErrorString),'������!!!', MB_OK + MB_ICONINFORMATION);
    end;
    // ���� ����� - �������� ��������� ���������
    if AbortionFlag = true then
    begin
      halt;
    end;
  end;
end;
//==============================================================================

//==============================================================================
//      ������� ����������� � �������� ���������� ������
//             ��� ����� ������ c ������ E20-10
//==============================================================================
function Tacp.ReadThread: DWORD;
var
  indJ: integer;
  iReadThread: WORD;
  m:integer;
begin
  // ��������� ������ ��� � ������������ ������� USB-����� ������ ������
  if not pModule.STOP_ADC() then
  begin
    ReadThreadErrorNumber := 1;
    IsReadThreadComplete := true;
    result := 1;
    exit;
  end;

  // ��������� ����������� ��� ����� ������ ���������
  for iReadThread := 0 to 1 do
  begin
    // ������������� ��������� ���� OVERLAPPED
    ZeroMemory(@ReadOv[iReadThread], sizeof(OVERLAPPED));
    // ������ ������� ��� ������������ �������
    ReadOv[iReadThread].hEvent := CreateEvent(nil, FALSE, FALSE, nil);
    // ��������� ��������� IoReq
    IoReq[iReadThread].Buffer := Pointer(Buffer[iReadThread]);
    IoReq[iReadThread].NumberOfWordsToPass := DataStep;
    IoReq[iReadThread].NumberOfWordsPassed := 0;
    IoReq[iReadThread].Overlapped := @ReadOv[iReadThread];
    IoReq[iReadThread].TimeOut := Round(Int(DataStep / ap.KadrRate)) + 1000;
  end;

  // ������� ������� ������ ����������� ���� ������ � Buffer
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

  //���� ������
  if pModule.START_ADC() then
  begin
    while hReadThread <> THANDLE(nil) do
    begin
      RequestNumber := RequestNumber xor $1;
      // ������� ������ �� ��������� ������ �������� ������
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
      // ��������� �������� ������� ��������� �������� ����� ������
      if not pModule.GET_DATA_STATE(@DataState) then
      begin
        ReadThreadErrorNumber := 7;
        break;
      end;
      // ������ ����� ��������� ���� ������� ������������
      // ����������� ������ ������
      if (DataState.BufferOverrun = (1 shl BUFFER_OVERRUN_E2010)) then
      begin
        ReadThreadErrorNumber := 8;
        break;
      end;
      //��� ������ ������� ������� ��������� ��������
      //if (not data.modC) then
      //begin
        buffDivide := length(buffer[RequestNumber xor $1]);
        //����������� �������� ������ ��� ����������� ������� �������.
        {data.}porog := acp.SignalPorogCalk(Round(buffDivide/10), buffer,RequestNumber); //!!! Round(data.buffDivide/10)
        //data.modC := true;
      //end;

     { for m:=1 to 3000 do
      begin
      form1.Memo1.Lines.Add(inttostr(m)+'  '+intTostr(buffer[RequestNumber xor $1][m]));
      end;



      while (true) do application.processmessages; }



      //���������, ��� ������ ������ �����.
      if {data.}porog>200 then
      begin
        //��������� ��������� ���������������
        indJ := 0;
        form2.Hide;
        //M16
        if infNum = 0 then
        begin
          //���� �� ��������� ������ � ���
          if not flagEnd then
          begin
            //������������ ������ � ����� �����.
            while indJ < buffDivide do
            begin
              dataM16.Add(Buffer[RequestNumber xor $1][indJ]);
              inc(indJ);
            end;
            //��������� �16
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
            //��������� �8_4_2_1
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
          //��������� ������ � ���
          pModule.STOP_ADC();
        end;
        //�������� ��� ���������� �����
        flagEnd:=true;
        wait(100); }

        //data.modC := false;
        form2.show;

      end;

      // ���� �� ������ ��� ������������ ������� ���� ������?
      if ReadThreadErrorNumber <> 0 then
      begin
        break;
      end
      else
      begin
        //Sleep(20);
      end;

      // ����������� ������� ���������� ������ ������(��������)
      inc(countC);
      {if countC = 12 then
      begin
        form1.Label2.Caption:=IntToStr(countC);
      end;}

      //����� �������� ������ ������. ��� ������ �����=).
      if (countC = 32767) then
      begin
        countC := 0;
      end;
      //form1.Label2.Caption := IntToStr(countC);
    end;
  //��������� ����������.��������� ����������� ������.
  end
  else
  begin
    ReadThreadErrorNumber := 6;
  end;
  // ��������� ���� ������ c ���
  // !!!�����!!! ���� ���������� ����������� ���������� � �����������
  // ���� �������� ������, �� ������� STOP_ADC() ������� ��������� �� �������,
  // ��� ����� 800 �� ����� ��������� ����� ��������� ������ ������.
  // ��� �������� ������� ����� ������ � 5 ��� ��� �������� ���������� �����
  // ������������ ������������� FIFO ������ ������, ������� ����� ������ 8 ��.
  if not pModule.STOP_ADC() then
  begin
    ReadThreadErrorNumber := 1;
  end;
  acp.ShowThreadErrorMessage();
  // ���� ����� - ����������� ������������� �������
  //������������ ����������� ������ ������
  if (DataState.BufferOverrun <> (1 shl BUFFER_OVERRUN_E2010)) then
  begin
    // ��������� �������� ������������� ��������� �������� ����� ������
    if not pModule.GET_DATA_STATE(@DataState) then
    begin
      ReadThreadErrorNumber := 7
    end
    // ������ ����� ��������� ���� �������
    //������������ ����������� ������ ������
    else
    begin
      if (DataState.BufferOverrun = (1 shl BUFFER_OVERRUN_E2010)) then
      begin
        ReadThreadErrorNumber := 8;
      end;
    end
  end;
  // ���� ����, �� ������ ��� ������������� ����������� �������
  if not CancelIo(ModuleHandle) then
  begin
    ReadThreadErrorNumber := 9;
  end;
  // ��������� �������������� �������
  CloseHandle(IoReq[0].Overlapped.hEvent);
  CloseHandle(IoReq[1].Overlapped.hEvent);
  // ����������
  //Sleep(100);
  //����� ������ ������� ��� �������
  form1.diaSlowAnl.Series[0].Clear;
  form1.gistSlowAnl.Series[0].Clear;
  form1.diaSlowCont.Series[0].Clear;
  form1.fastDia.Series[0].Clear;
  form1.fastGist.Series[0].Clear;
  Form1.tempDia.Series[0].Clear;
  Form1.tempGist.Series[0].Clear;
  //����� �������������� ������ ������ ��������� ����� � ������.
  form1.startReadACP.Enabled:=true;
  form1.startReadTlmB.Enabled:=true;
  result := 0;
end;
//=============================================================================

//==============================================================================
// �������� ���������� ���������� ���������� ������� �� ���� ������
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
        // ������ �������� ����� ��������� ������ ������
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
  //����. ��� ���
  DataStep := 1024 * 1024;
  //������� �������� ���
  countC := 0;
  // ������������� ����� ������. ������ ��� 0. ������� ����� ������ ������ �����
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
  //�������� ���������� ���.
  //============================================================================
  //�������� ������ ������������ DLL ����������
  //��������� ��������� Dll ������ ���������� ��� ������ � ���
  DllVersion := GetDllVersion;

  //������ DLL �� �������������.
  if DllVersion <> CURRENT_VERSION_LUSBAPI then
  begin
    Str := '�������� ������ DLL ���������� Lusbapi.dll! ' + #10#13 +
    '           �������: ' + IntToStr(DllVersion shr 16) +
    '.' + IntToStr(DllVersion and $FFFF) + '.' +
    ' ���������: ' + IntToStr(CURRENT_VERSION_LUSBAPI shr 16) +
    '.' + IntToStr(CURRENT_VERSION_LUSBAPI and $FFFF) + '.';
    //���� �������� ������ ������� ������, ������ � �
    //��������� ���������� � ��������� ���������� �����.
    AbortProgram(Str);
  end;

  //��������� �������� ��������� �� ��������� ��� ������ E20-10
  //�������� ����� ��� � �������
  pModule := CreateLInstance(pCHAR('e2010'));

  //���������� �� ����������, ��������� nil
  if pModule = nil then
  begin
    AbortProgram('�� ���� ����� ��������� ������ E20-10!');
  end;

  // ��������� ���������� ������ E20-10 �
  //������ MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI ����������� ������
  {for iGeneralTh := 0 to (MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI - 1) do
    begin
      if pModule.OpenLDevice(iGeneralTh) then
        begin
          AbortProgram('�� ���� ����� ��������� ������ E20-10!');
        end;
    end;}

  //�������� ����� e20-10 � ������� ����������� �����
  iGeneralTh := 0;
  if not pModule.OpenLDevice(iGeneralTh) then
  begin
    AbortProgram('�� ���� ����� ��������� ������ E20-10!');
  end;

  //���������� ������� ������ USB
  if not pModule.GetUsbSpeed(@UsbSpeed) then
  begin
    AbortProgram(' �� ���� ���������� �������� ������ ���� USB')
  end;

  {// ������ ��������� �������� ������ ���� USB}
  if UsbSpeed = USB11_LUSBAPI then
  begin
    Str := 'Full-Speed Mode (12 Mbit/s)';
  end
  else
  begin
    //480 ����/c   . ��� 1
    Str := 'High-Speed Mode (480 Mbit/s)';
  end;



  //iGeneralTh:=0;
  // ���-������ ����������?
  //���������� ������������ �� ����������. ���� ���, �� ������� ������.
  {if iGeneralTh = MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI then
  begin
    AbortProgram('�� ������� ���������� ������ E20-10' +
      '� ������ 127 ����������� ������!');
  end
  else
  begin
    //�� ����� ������
    //����� ������ ����������
    //form1.Memo1.Lines.Add(Format('OpenLDevice(%u) --> OK', [iGeneralTh]));
  end; }

  // ������� ������������� ����������
  //ModuleHandle := pModule.GetModuleHandle();

  //��������� �������� ������ � ������� ����������� �����
  //���������� ������ ��� ������������ ��������
  ModuleName := '0123456';
  //ModuleName := 'E20-10';


  //�������� ���������� � ������� ���������� ���?
  if not pModule.GetModuleName(pCHAR(ModuleName)) then
  begin
    AbortProgram('�� ���� ��������� �������� ������!')
  end;


  {// ��������, ��� ��� ������ E20-10}
  if Boolean(AnsiCompareStr(ModuleName, 'E20-10')) then
  begin
    AbortProgram('������������ ������ �� �������� E20-10!');
  end;

  // ����� ��� ���� ������ �� ���������������� ������� DLL ���������� Lusbapi.dll
  if not pModule.LOAD_MODULE(nil) then
  begin
    AbortProgram('�� ���� ��������� ������ E20-10!');
  end;

  if not pModule.TEST_MODULE() then
  begin
    AbortProgram('������ � �������� ������ E20-10!');
  end;

  if not pModule.GET_MODULE_DESCRIPTION(@ModuleDescription) then
  begin
    AbortProgram('�� ���� �������� ���������� � ������!');
  end;

  if not pModule.READ_FLASH_ARRAY(@UserFlash) then
  begin
    AbortProgram('�� ���� ��������� ���������������� ����!');
  end;

  if not pModule.GET_ADC_PARS(@ap) then
  begin
    AbortProgram('�� ���� �������� ������� ��������� ����� ������!');
  end;


  if ModuleDescription.Module.Revision = BYTE(REVISIONS_E2010[REVISION_A_E2010]) then
  begin
    // �������� �������������� ������������� ������ �� ������ ������ (��� Rev.A)
    ap.IsAdcCorrectionEnabled := FALSE
  end
  else
  begin
    //�������� �������������� �������������
    //������ �� ������ ������ (��� Rev.B � ����)
    ap.IsAdcCorrectionEnabled := TRUE;
    ap.SynchroPars.StartDelay := 0;
    ap.SynchroPars.StopAfterNKadrs := 0;
    ap.SynchroPars.SynchroAdMode := NO_ANALOG_SYNCHRO_E2010;
    //ap.SynchroPars.SynchroAdMode:=ANALOG_SYNCHRO_ON_HIGH_LEVEL_E2010;
    ap.SynchroPars.SynchroAdChannel := $0;
    ap.SynchroPars.SynchroAdPorog := 0;
    ap.SynchroPars.IsBlockDataMarkerEnabled := $0;
  end;

  // ���������� ����� ����� � ���
  ap.SynchroPars.StartSource := INT_ADC_START_E2010;

  // ������� ����� ����� � ���
  // ap.SynchroPars.StartSource := EXT_ADC_START_ON_RISING_EDGE_E2010;

  // ���������� �������� �������� ���
  ap.SynchroPars.SynhroSource := INT_ADC_CLOCK_E2010;

  // �������� ����� ���������� ������� ������� ��� ������
  //�������� � ������� ��� (������ ��� Rev.A)
  // ap.OverloadMode := MARKER_OVERLOAD_E2010;

  // ������� �������� ����� ���������� ������� �������
  //���� ����������� ������� ��� (������ ��� Rev.A)
  ap.OverloadMode := CLIPPING_OVERLOAD_E2010;

  // ���-�� �������� �������
  ap.ChannelsQuantity := CHANNELSQUANTITY;

  //-
  // ���� �������� ������� ������ 1.
  {for iGeneralTh := 0 to (ap.ChannelsQuantity - 1) do
    begin
      ap.ControlTable[iGeneralTh] := iGeneralTh;
    end;}

  //����c����� ����� ������ � ������� ������� ������������ ������
  {if (strtoint(form1.ComboBox1.Text)<>0) then }
    //ap.ControlTable[0]:=1;  //����������� ����� ������(1)

  //+
  // ������� ����� ����� ������������� � ����������� �� �������� USB
  // ������� ��� ������ � ���
  // ������������� ���������
  ap.AdcRate := AdcRate;
  // � ����������� �� �������� USB ����������
  //����������� �������� � ������ �������.
  if UsbSpeed = USB11_LUSBAPI then
  begin
    // ����������� �������� � ��.
    //����� ����� ����� ����� ����� ��������� ����� � ���.
    // 12 Mbit/s
    ap.InterKadrDelay := 0.01;
    DataStep := 256 * 1024; // ������ �������
  end
  else
  begin
    // ����������� �������� � ��  . 1/131072= 0.00007. 7 ����� ������.
    // 480 Mbit/s
    ap.InterKadrDelay := 0.0;
    DataStep := 1024 * 1024; // ������ �������
  end;

  // ���������� ������� ������ . ��������� 4-� ���������� �������.
  {for iGeneralTh := 0 to (ADC_CHANNELS_QUANTITY_E2010 - 1) do
    begin
      // ������� �������� 3�
      ap.InputRange[iGeneralTh] := ADC_INPUT_RANGE_3000mV_E2010;
      // �������� ����� - ������
      ap.InputSwitch[iGeneralTh] := ADC_INPUT_SIGNAL_E2010;
    end;}

  iGeneralTh := 0;
  // ������� �������� 3�
  ap.InputRange[iGeneralTh] := ADC_INPUT_RANGE_3000mV_E2010;
  // �������� ����� - ������
  ap.InputSwitch[iGeneralTh] := ADC_INPUT_SIGNAL_E2010;

  // ������� � ��������� ���������� ������ ��� ���������������� ������������ ���
  //������ ����������� � ��������� ��������� ��� ���������� ��������
  {for iGeneralTh := 0 to (ADC_INPUT_RANGES_QUANTITY_E2010 - 1) do
    begin
      for jGeneralTh := 0 to (ADC_CHANNELS_QUANTITY_E2010 - 1) do
        begin
          // ������������� ��������
          ap.AdcOffsetCoefs[iGeneralTh][jGeneralTh] :=
            ModuleDescription.Adc.OffsetCalibration[jGeneralTh +
              iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];
          // ������������� ��������
          ap.AdcScaleCoefs[iGeneralTh][jGeneralTh] :=
            ModuleDescription.Adc.ScaleCalibration[jGeneralTh +
              iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];
        end;
    end;}

  iGeneralTh:=0;
  jGeneralTh:=0;
  // ������������� ��������
  ap.AdcOffsetCoefs[iGeneralTh][jGeneralTh] :=
    ModuleDescription.Adc.OffsetCalibration[jGeneralTh +
      iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];
  // ������������� ��������
  ap.AdcScaleCoefs[iGeneralTh][jGeneralTh] :=
    ModuleDescription.Adc.ScaleCalibration[jGeneralTh +
      iGeneralTh * ADC_CHANNELS_QUANTITY_E2010];

  // ��������� � ������ ��������� ��������� �� ����� ������
  // ���������� ��������� ����� � ���
  // �� ������� ��������
  if not pModule.SET_ADC_PARS(@ap) then
  begin
    AbortProgram('�� ���� ���������� ��������� ����� ������!');
  end;


  // ��������� �������� ������ ���-�� ������ ��� ������ ������
  for iGeneralTh := 0 to 1 do
  begin
    SetLength(Buffer[iGeneralTh], DataStep);
    ZeroMemory(Buffer[iGeneralTh], DataStep * SizeOf(SHORT));
  end;

  // �������� ����� ����� ������
  hReadThread := BeginThread(nil, 0, @Tacp.ReadThread, nil, 0, ReadTid);
  if hReadThread = THANDLE(nil) then
  begin
    AbortProgram('�� ���� ��������� ����� ����� ������!');
  end;
end;
//==============================================================================

end.
