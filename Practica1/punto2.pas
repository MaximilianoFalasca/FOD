program punto2;
	type archivo = file of integer;
	var arch: archivo;
		num: integer;
begin
	assign(arch,'numero.doc');
	reset(arch);
	while not eof(arch) do begin
		read(arch,num);
		writeln(num);
	end;
	close(arch);
end.
