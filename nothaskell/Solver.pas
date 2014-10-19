program solver;
{$R+}
type
	TTile = 0..4096;
	TFieldSize = 0..3;
	TField = Array[FieldSize,FieldSize] of TTile;
	TStep = (N, W, S, E);
	
procedure InitField (var Field : TField);
var
	i,j : TFieldSize;
begin
	for i := low(Field) to high(Field) do
		for j := low(Field) to high(Field) do
			Field[i,j] := 0;
end;

function Neigbour (i,j : TFieldSize; Step : TStep): TTile;


function isMovable (const Field : TField; const Step : TStep): Boolean
begin
	Repeat

	Until Neighbour(i,j,Step) = 
end;

function nextStep (const Field: TField): TStep;



function isNumber (const c : Char) : Boolean;
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
	if j = c then
		if i = c then
			i := 0
		else
			inc(i);
		j := 0
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
	n := 2;
	nmbr := '';
	while n <= length(input)-1 do begin
		if isNumber(input[n]) then
			nmbr := nmbr + input[n];
		else
			if nmbr <> '' then begin
				Field[i,j] := StrToInt(nmbr);
				nextTile(i,j);
				nmbr := '';
			end;
	end;
	inc(n);
end;

	while true do begin
		write ('NWE');
	end
end.
//([2, 0, 0, 2],[16, 4, 0, 0],[4, 64, 8, 0],[2, 8, 4, 2])
