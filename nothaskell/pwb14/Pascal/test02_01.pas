program solver;
{$R+}
uses SysUtils;
type
	TTile = 0..4096;
	TFieldSize = 0..3;
	TField = Array[TFieldSize, TFieldSize] of TTile;
	TStep = (N, W, S, E);
	
procedure InitField (Field : TField);
var
	i,j : TFieldSize;
begin
	for i := low(Field) to high(Field) do
		for j := low(Field) to high(Field) do
			Field[i,j] := 0;
end;

//function movable (Field : TField; Step : TStep): Boolean


//function nextStep (Field: TField): TStep;

function isNumber (c : Char) : Boolean;
var
	b : Boolean;
	i : Char;
begin
	b := False;
	for i := '0' to '9' do
		if c = i then
			b := True;
	isNumber := b;
end;

procedure nextTile (var i, j : TFieldSize);
var
	c : TFieldSize;
begin
	c := high(TFieldSize);
	if j = c then begin
		if i = c then
			i := 0
		else
			inc(i);
		j := 0;
		end
	else
		inc(j);
end;

procedure readField (var Field : TField);
var
	input, nmbr : String;
	n : Word;
	i,j : TFieldSize;
begin
	readln (input);
	i := 0;
	j := 0;
	n := 1;
	nmbr := '';
	while n <= length(input)-1 do begin
		if isNumber(input[n]) then
			nmbr := nmbr + input[n]
		else
			if nmbr <> '' then begin
				Field[i,j] := StrToInt(nmbr);
				//write ('dup',n,#32,nmbr,#32,i,#32,j,#32);
				nextTile(i,j);
				nmbr := '';
			end;
		inc(n);
	end;
end;


var
	Field : TField;
	k, c : Byte;
	i, j : TFieldSize;
	input : String;
begin
	
//readFieldTest
	initField(Field);
	readField(Field);
	i := 0;
	j := 0;
	c := high(TFieldSize);
	for k := 1 to (c+1)*(c+1) do begin
		write(Field[i,j], ', ');
		if j = c then
			writeln;
		nextTile(i,j);
	end


//nextTileTest
{	readln(Input);
	i := StrToInt(Input);
	readln(Input);
	j := StrToInt(Input);
	nextTile(i,j);
	writeln(i,#32,j);}
end.
//([2, 0, 0, 2],[16, 4, 0, 0],[4, 64, 8, 0],[2, 8, 4, 2])0
