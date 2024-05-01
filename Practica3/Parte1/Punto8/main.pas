{
Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.
}
program main;
type 
	distribucion=record
		nombre:string[10];
		anio:integer;
		version:real;
		desarrolladores:integer;
		descripcion:string[10];
	end;
	arc_distribucion=file of distribucion;
	
procedure leerDato(var d:distribucion);
begin
	writeln('Ingresar nombre');
	readln(d.nombre);
	if(d.nombre<>'zzzz')then begin
		writeln('Ingresar año');
		readln(d.anio);
		writeln('Ingresar version');
		readln(d.version);
		writeln('Ingresar desarrolladores');
		readln(d.desarrolladores);
		writeln('Ingresar descripcion');
		readln(d.descripcion);
	end;
end;
	
procedure crearArchivo(var archivo:arc_distribucion);
var
	d:distribucion;
begin
	rewrite(archivo);
	d.desarrolladores:=0;
	write(archivo,d);
	leerDato(d);
	while(d.nombre<>'zzzz')do begin
		write(archivo,d);
		leerDato(d);
	end;
	close(archivo);
end;
	
procedure altaDistribucion(var a:arc_distribucion);
var
	d,aux:distribucion;
	i:integer;
begin
	reset(a);
	leerDato(d);
	if(d.nombre<>'zzzz')then begin
		read(a,aux);
		if(aux.desarrolladores=0)then begin
			seek(a,fileSize(a));
			write(a,d);
		end
		else begin
			i:=aux.desarrolladores*-1;
			seek(a,i);
			read(a,aux);
			seek(a,filePos(a)-1);
			write(a,d);
			seek(a,0);
			write(a,aux);
		end;
	end
	else	
		writeln('Se ingreso un nombre invalido');
	close(a);
end;

function existeDistribucion(var a:arc_distribucion;nombre:string):integer;
var 
	i:integer;
	d:distribucion;
begin
	i:=-1;
	while((not eof(a)) and (i=-1))do begin
		read(a,d);
		if(d.nombre=nombre)then
			i:=filePos(a)-1;
	end;
	existeDistribucion:=i;
end;

procedure bajaDistribucion(var a:arc_distribucion);
var
	aux,tmp:distribucion;
	nombre:string[10];
	i:integer;
begin
	reset(a);
	writeln('Ingresar nombre');
	readln(nombre);
	i:=existeDistribucion(a,nombre);
	if(i<>-1)then begin
		seek(a,0);
		read(a,aux);
		seek(a,i);
		read(a,tmp);
		tmp.desarrolladores:=aux.desarrolladores;
		aux.desarrolladores:=i*-1;
		seek(a,filePos(a)-1);
		write(a,tmp);
		seek(a,0);
		write(a,aux);
	end;
	close(a);
end;

procedure ListarContenido(var a:arc_distribucion);
var
	d:distribucion;
begin
	reset(a);
	if not eof(a) then
		read(a,d);
	while not eof(a) do begin
		read(a,d);
		writeln('nombre ',d.nombre);
		writeln('año ',d.anio);
		writeln('version ',d.version);
		writeln('desarrolladores ',d.desarrolladores);
		writeln('descripcion ',d.descripcion);
	end;
	close(a);
end;
	
var
	a:arc_distribucion;
	opcion:integer;
begin
	assign(a,'archivo.dat');
	crearArchivo(a);
	repeat
		writeln('Ingrese la opcion:');
		writeln('Opcion 1: Alta distribucion');
		writeln('Opcion 2: Baja distribucion');
		writeln('Opcion 3: Listar distribuciones');
		writeln('Opcion 0: Terminar Ejecucion');
		readln(opcion);
		case(opcion)of
			1:altaDistribucion(a);
			2:bajaDistribucion(a);
			3:ListarContenido(a);
			0:writeln('Terminando la ejecucion del programa...');
		else
			writeln('Opcion no valida, ingrese nuevamente');
		end;
	until(opcion=0);
end.
