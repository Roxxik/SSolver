program solver;
{$R+}
uses SysUtils;
type
	TTileVal = 0..4096;
	TFieldSize = Byte;
	TField = Array of Array of TTileVal;
	TStep = (N, W, S, E);
	TOffset = -1..1;

procedure setTile (var Field: TField; const i, j: TFieldSize; const TileValue: TTileVal);
begin
	Field[i,j] := TileValue;
end;

procedure InitField (var Field: TField);
//not needed atm
var
	i,j: TFieldSize;
begin
	for i := low(Field) to high(Field) do
		for j := low(Field) to high(Field) do
			setTile(Field, i, j, 0);
end;

function tileValue (const Field: TField; const i, j: TFieldSize): TTileVal;
begin
	tileValue := Field[i,j];
end;

procedure getOffset (const Step: TStep; var x,y: TOffset);
begin
	case Step of
		N: begin x := 0; y :=-1; end;
		W: begin x :=-1; y := 0; end;
		S: begin x := 0; y := 1; end;
		E: begin x := 1; y := 0; end;
	end;
end;

function turnAround(Step: TStep): TStep;
begin
	case Step of
		N: turnAround := S;
		W: turnAround := E;
		S: turnAround := N;
		E: turnAround := W;
	end;
end;


function neighbour (const Field: TField; const i,j: TFieldSize; const Step: TStep): TTileVal;
var
	x,y : TOffset;
begin
	getOffset(Step,x,y);
	neighbour := tileValue(Field,i+x,j+y);
	Writeln('Offset: ',i+x,#32,j+y,#32,tileValue(Field,i+x,j+y));
end;

procedure nextTile (Field: TField; var i, j: TFieldSize);
var
	c: TFieldSize;
begin
	c := high(Field);
	if i = c then begin
		if j = c then
			j := 0
		else
			inc(j);
		i := 0;
	end
	else
	  inc(i);
end;

function isMovable (const Field: TField; const Step: TStep): Boolean;
var
	c,i,j,imax,jmax : TFieldSize;
	t : TTileVal;
	x,y : TOffset;
	mvble : Boolean;
	k : Byte;
begin
	getOffset(Step, x, y);
	case Step of
		N,W:begin
				i := -x;
				j := -y;
				imax := high(Field);
				jmax := high(Field);
			end;
		S,E:begin
				i := 0;
				j := 0;
				imax := high(Field)-1+x;
				jmax := high(Field)-1+y;
			end;
	end;
	c := high(Field);
	writeln('i: ',i,' j: ',j,' iM: ',imax,' jM:',jmax);
	mvble := False;
	k := 0;
	Repeat
		if tileValue(Field,i,j) <> 0 then begin
			t := neighbour(Field, i, j, Step);
			mvble := 	(t = 0) or (t = tileValue(Field, i, j));
			Writeln(tileValue(Field, i, j),#32,t);
		end;
		nextTile(Field,i,j);
		inc(k);
	Until mvble or (k >= (c-1)*(c-2));
	Writeln('k: ',k);
	isMovable := mvble;
end;


function nextStep (const Field: TField): TStep;
begin
	if isMovable(Field, N) then
		nextStep := N
	else
		if isMovable(Field, W) then
			nextStep := W
		else
			if isMovable(Field, E) then
				nextStep := E
			else
				nextStep := S;
end;

function isNumber (const c: Char): Boolean;
var
	b: Boolean;
	i: Char;
begin
	b := False;
	for i := '0' to '9' do
		if c = i then
			b := True;
	isNumber := b;
end;

procedure setupField (const input: String; var Field: TField);
var
	nmbr: String;
	n: Word;
	i,j: TFieldSize;
begin
	i := 0;
	j := 0;
	nmbr := '';
	for n := 1 to length(input) do begin
		if isNumber(input[n]) then
			nmbr := nmbr + input[n]
		else
			if nmbr <> '' then begin
				setTile(Field, i, j, StrToInt(nmbr));
				nextTile(Field,i,j);
				nmbr := '';
			end;
	end;
end;

function getFieldSize (const input: String): TFieldSize;
var
	n: Word;
	k: TFieldSize;
begin
	k := 0;
	for n := 1 to length(input) do
		if input[n] = '[' then
			inc(k);
	getFieldSize := k;
end;

procedure printField (Field: TField);
var
	k,c: Byte;
	i, j: TFieldSize;
begin
	i := 0;
	j := 0;
	c := high(Field);
	for k := 1 to (c+1)*(c+1) do begin
		write(Field[i,j], ', ');
		if i = c then
			writeln;
		nextTile(Field,i,j);
	end
end;
//----------------------------------------
var
	Field: TField;
	input: String;
	k: TFieldSize;
	step: TStep;
begin
	readln(input);
	k := getFieldSize(input);
	setlength(Field,k,k);
	While true do begin
		setupField(input, Field);
		step := nextStep(Field);
		writeln(step);
		printField(Field);
		readln(input);
	end;
end.
//([2, 0, 0, 2],[16, 4, 0, 0],[4, 64, 8, 0],[2, 8, 4, 2])
//([1, 2, 3, 4],[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0])
//([2, 0, 0, 2, 5],[16, 4, 0, 0, 5],[4, 64, 8, 0, 5],[2, 8, 4, 2, 5],[1, 2, 3, 4, 6])
