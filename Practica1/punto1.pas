program punto1;
	type 
		archivo = file of integer;
	var 
		arc:archivo;
		nro:integer;
		nombre_archivo:string;
begin
	writeln('Ingrese el nombre del archivo');
	read(nombre_archivo);
	nombre_archivo:=nombre_archivo+'.doc';
	writeln('nombre de archivo:'+nombre_archivo);
	assign(arc,nombre_archivo);
	rewrite(arc);
	writeln('Ingrese un numero (con el 30000 finaliza la ejecucion)');
	read(nro);
	while nro <> 30000 do begin
		write(arc,nro);
		writeln('Ingrese un numero');
		read(nro);
	end;
	close(arc);
end.
