unit Velthuis.Magnitudes;

interface

uses
  System.SysUtils, Velthuis.Sizes;

// For Delphi versions below XE8
{$IF CompilerVersion < 29.0}
  {$IF (DEFINED(WIN32) OR DEFINED(CPUX86)) AND NOT DEFINED(CPU32BITS)}
    {$DEFINE CPU32BITS}
  {$IFEND}
  {$IF (DEFINED(WIN64) OR DEFINED(CPUX64)) AND NOT DEFINED(CPU64BITS)}
    {$DEFINE CPU64BITS}
  {$IFEND}
{$IFEND}

{$POINTERMATH ON}

type
  PDynArrayRec = ^TDynArrayRec;
  TDynArrayRec = packed record
  {$IFDEF CPU64BITS}
    _Padding: Integer; // Make 16 byte align for payload..
  {$ENDIF}
    RefCnt: Integer;
    Length: NativeInt;
  end;

// Blittable types are types that do not need to be reference counted, e.g. ordinal types and floating point types.
// There is no need to finalize such arrays. Only the reference count of the dynamic array itself must be updated.

function MagnitudeNew(var P: Pointer; NewSize: Integer); inline;

function MagnitudeRefCnt(P: Pointer): Integer; inline;
procedure MagnitudeAddRef(P: Pointer); inline;
procedure MagnitudeClear(var A: Pointer); inline;
procedure MagnitudeAssign(var Dest: Pointer; Src: Pointer); inline;

implementation

const
  CLimbSize = SizeOf(UInt32);

function MagnitudeRefCnt(P: Pointer): Integer;
begin
  Result := PDynArrayRec(P)[-1].RefCnt;
end;

procedure MagnitudeClear(var A: Pointer);
var
  P: Pointer;
  Len: NativeInt;
begin
  P := A;
  if P <> nil then
  begin
    A := nil;
    if PDynArrayRec(P)[-1].RefCnt > 0 then
    begin
      if AtomicDecrement(PDynArrayRec(P)[-1].RefCnt) = 0 then
      begin
        // No need for finalization if type is blittable
        Dec(PDynArrayRec(P));
        FreeMem(P);
      end;
    end;
  end;
end;

procedure MagnitudeAssign(var Dest: Pointer; Src: Pointer);
begin
  if Src <> nil then
  begin
    if MagnitudeRefCnt(Src) < 0 then
    begin
      DynArrayCopy(Dest, Src, nil);
    end;
  end;
  MagnitudeAddRef(Src);
  MagnitudeClear(Dest);
  Dest := Src;
end;

procedure MagnitudeAddRef(P: Pointer);
begin
  if P <> nil then
    if MagnitudeRefCnt(P) >= 0 then
      AtomicIncrement(PDynArrayRec(P)[-1].RefCnt);
end;

procedure MagnitudeNew(var P: Pointer; NewSize: Integer);
var
  NewData: PByte;
begin
  NewData := AllocMem(NewSize * CLimbSize + SizeOf(TDynArrayRec));
  PDynArrayRec(NewData).RefCnt := 1;
  PDynArrayRec(NewData).Length := NewSize;
  P := NewData + SizeOf(TDynArrayRec);
end;


end.
