program solver;
{$R+}
uses sysUtils;
var
	i,k : Byte;
	input : String;
begin
	i := 0;
	k := 0;
	while k <= 20 do begin
		case i of
			0:write ('N');
			1:write ('W');
			2:write ('E');
			3:write ('S');
		end;
		Read(input);
		if input = '' then
			i := 1
		else
			i := 2;
		inc(k);
	end
end.
