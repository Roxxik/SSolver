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
	neighbour := tileValue(Field,i+x,j+y)
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
	c,i,j,imax,jmax,imin,jmin : TFieldSize;
	x,y : TOffset;
	t : TTileVal;
	mvble : Boolean;
	k : Word;
begin
	getOffset(Step, x, y);
	c := high(Field);
	k := 0;
	i := 0;
	j := 0;
	case Step of
		N,W:begin
				imin := -x;
				jmin := -y;
				imax := c;
				jmax := c;
			end;
		S,E:begin
				imin := 0;
				jmin := 0;
				imax := c-2+x;
				jmax := c-2+y;
			end;
	end;
	mvble := False;
	Repeat
		if 	(i >= imin) and
			(i <= imax) and
			(j >= jmin) and
			(j <= jmax) then begin
			if tileValue(Field,i,j) <> 0 then begin
				t := neighbour(Field, i, j, Step);
				mvble := 	(t = 0) or (t = tileValue(Field, i, j));
			end;
			inc(k);
		end;
		nextTile(Field,i,j);	
	Until mvble or (k >= (c+1)*c);
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

procedure setupField (const inString: String; var Field: TField);
var
	nmbr: String;
	n: Word;
	i,j: TFieldSize;
begin
	i := 0;
	j := 0;
	nmbr := '';
	for n := 1 to length(inString) do begin
		if isNumber(inString[n]) then
			nmbr := nmbr + inString[n]
		else
			if nmbr <> '' then begin
				setTile(Field, i, j, StrToInt(nmbr));
				nextTile(Field,i,j);
				nmbr := '';
			end;
	end;
end;

function getFieldSize (const inString: String): TFieldSize;
var
	n: Word;
	k: TFieldSize;
begin
	k := 0;
	for n := 1 to length(inString) do
		if inString[n] = '[' then
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
	c : Char;
	inString: String;
	k: TFieldSize;
	step: TStep;
begin
	read(inString);
	while not EoLN do begin
		read (input, c);
		inString := inString + c;
	end;
	if inString[3] = '2' then
		Step := W
	else
		k := getFieldSize(inString);
	setlength(Field,k,k);
	While true do begin
		setupField(inString, Field);
		step := nextStep(Field);
		write(step);
		while not EoLN do begin
			read (input, c);
			inString := inString + c;
		end;
	end;
end.
//([2, 0, 0, 2],[16, 4, 0, 0],[4, 64, 8, 0],[2, 8, 4, 2])
//([4, 0, 2, 4],[2, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0])
//([2, 0, 0, 2, 5],[16, 4, 0, 0, 5],[4, 64, 8, 0, 5],[2, 8, 4, 2, 5],[1, 2, 3, 4, 6])
