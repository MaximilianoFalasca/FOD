program punto3;
	type 
		registro = record
			nro:integer;
			apellido:string[20];
			nombre:string[20];
			edad:integer;
			dni:integer;
		end;
	var
		archivo: file of registro;
		tmp: registro;
		nombre_archivo: string[10];
begin
	writeln('Ingresar nombre del archivo');
	readln(nombre_archivo);
	nombre_archivo:=nombre_archivo+'.doc';
	assign(archivo, nombre_archivo);
	rewrite(archivo);
	writeln('Ingresar apellido (termina la ejecucion con apellido fin):');
	readln(tmp.apellido);
	while (tmp.apellido <> 'fin') do begin
		writeln('Ingresar nombre:');
		readln(tmp.nombre);
		writeln('Ingresar dni:');
		readln(tmp.dni);
		writeln('Ingresar edad:');
		readln(tmp.edad);
		writeln('nro de empleado:');
		readln(tmp.nro);
		write(archivo,tmp);
		writeln('Ingresar apellido');
		readln(tmp.apellido);
	end;
	close(archivo);
end.
