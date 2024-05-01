program prueba;
type 
	persona = record
		apellido:string[20];
		nombre:string[20];
		dni:string[10];
		edad:integer;
	end;
	archivoB=file of persona;
var
	archivo:Text;
	tmp:persona;
begin
	assign(archivo,'personasPrueba.txt');
	reset(archivo);
	while not eof(archivo) do begin
		read(archivo,tmp.dni,tmp.apellido,tmp.nombre,tmp.edad);
		writeln('lo que me dejo:',tmp.dni,tmp.apellido,tmp.nombre,tmp.edad);
	end;
	close(archivo);
end.
