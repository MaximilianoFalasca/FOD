program prueba;
type 
	persona = record
		apellido:string[20];
		nombre:string[20];
		dni:string[10];
		edad:integer;
	end;
var
	archivo:Text;
	tmp:persona;
begin
	assign(archivo,'personasPrueba.txt');
	rewrite(archivo);
	writeln('termina con apellido = fin');
	writeln('Ingrese apellido:');
	readln(tmp.apellido);
	while(tmp.apellido <> 'fin')do begin
		writeln('Ingrese nombre:');
		readln(tmp.nombre);
		writeln('dni:');
		readln(tmp.dni);
		writeln('edad:');
		readln(tmp.edad);
		writeln(archivo,tmp.dni,' ',tmp.apellido,' ',tmp.nombre,' ',tmp.edad);
		writeln('Ingrese apellido:');
		readln(tmp.apellido);
	end;
	close(archivo);
end.
