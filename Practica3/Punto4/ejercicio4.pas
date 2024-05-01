{
Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
	Abre el archivo y agrega una flor, recibida como parámetro	
	manteniendo la política descrita anteriormente
		procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
}
program ejercicio4;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;

procedure CrearArchivo(var a: tArchFlor);

procedure leerFlor(var f:reg_flor);
begin
	writeln('Ingresar codigo');
	readln(f.codigo);
	if(f.codigo>0)then begin
		writeln('Ingresar nombre');
		readln(f.nombre);
	end;
end;

var
	r:reg_flor;
begin
	rewrite(a);
	r.codigo=0;
	write(a,r);
	writeln('Ingrese datos hasta codigo<=0');
	leerFlor(r);
	while(r.codigo>0)do begin
		write(a,r);
		leerFlor(r);
	end;
	close(a);
end;

procedure agregarFlor (var a:tArchFlores; nombre:string; codigo:integer);
var
	cabecera,r:reg_flor;
begin
	reset(a);
	read(a,cabecera);
	r.codigo:=codigo;
	r.nombre:=nombre;
	if(cabecera.codigo<0)then begin
		seek(a,cabecera.codigo*-1);
		read(a,cabecera);
		seek(a,filePos(a)-1);
		write(a,r);
		seek(a,0);
		write(a,cabecera);
	end
	else begin
		seek(a,fileSize(a));
		write(a,r);
	end;
	close(a);
end;

procedure ListarContenido(var a:tArchFlores);
var
	r:reg_flor;
begin
	reset(a);
	repeat
		read(a,r);
		if(r.codigo>0)then
			writeln('Codigo de Flor: ',r.codigo,' Nombre: ',r.nombre);
	until eof(a);
	close(a);
end;

procedure EliminarFlor(var a:tArchFlores);
var
	r,aux:reg_flor;
	ok:boolean;
	codigo:integer;
begin
	reset(a);
	writeln('Ingresar el codigo de la flor a eliminar: ');
	readln(codigo);
	read(a,r);
	while (not eof(a) and (ok=false))do begin
		read(a,aux);
		if(aux.codigo=codigo)then begin
			seek(a,filePos(a)-1);
			write(a,r);
			aux.codigo=(filePos(a)-1)*-1;
			seek(a,0);
			write(a,aux);
		end;
	end;
	close(a);
end;

var
	archivo:tArchFlores;
	opcion:integer;
	codigo:integer;
	nombre:string;
begin
	assign(archivo,'archivoDat.dat');
	CrearArchivo(archivo);
	repeat
		writeln('Ingrese la opcion:');
		writeln('Opcion 1: AgregarFlor');
		writeln('Opcion 2: Listar contenido');
		writeln('Opcion 3: EliminarFlor');
		writeln('Opcion 0: Terminar Ejecucion');
		readln(opcion);
		case(opcion)of
			1:begin
				writeln('Ingresar nombre:');
				readln(nombre);
				writeln('Ingresar codigo');
				readln(codigo);
				agregarFlor(archivo,nombre,codigo);
			end;
			2:ListarContenido(archivo);
			3:EliminarFlor(archivo);
			0:writeln('Terminando la ejecucion del programa...');
		else
			writeln('Opcion no valida, ingrese nuevamente');
	until(opcion=0);
end.
