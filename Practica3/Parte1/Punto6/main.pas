{
Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}
program main;
type
	prenda=record
		codigo:integer;
		descripcion:string[10];
		colores:string[10];
		tipo_prenda:string[10];
		stock:integer;
		precio_unitario:real;
	end;
	maestro=file of prenda;
	detalle=file of integer;
	
procedure leerPrenda(var p:prenda);
begin
	writeln('Ingresar codigo de prenda:');
	readln(p.codigo);
	if(p.codigo<>-1)then begin
		writeln('Ingresar descripcion:');
		readln(p.descripcion);
		writeln('Ingresar colores:');
		readln(p.colores);
		writeln('Ingresar tipo de prenda:');
		readln(p.tipo_prenda);
		writeln('Ingresar stock:');
		readln(p.stock);
		writeln('Ingresar precio unitario:');
		readln(p.precio_unitario);
	end;
end;
	
procedure crearMaestro(var m:maestro);
var
	p:prenda;
begin
	rewrite(m);
	leerPrenda(p);
	while(p.codigo<>-1)do begin
		write(m,p);
		leerPrenda(p);
	end;
	close(m);
end;

procedure cambioTemporada(var d:detalle);
var
	codigo:integer;
begin
	reset(d);
	writeln('Ingresar codigo de prenda a eliminar');
	readln(codigo);
	while(codigo<>-1)do begin
		write(d,codigo);
		writeln('Ingresar codigo de prenda a eliminar');
		readln(codigo);
	end;
	close(d);
end;

procedure bajaLogica(var m:maestro;var d:detalle);
var
	i:integer;
	p:prenda;
begin
	reset(m);
	reset(d);
	while not eof(d)do begin
		read(d,i);
		seek(m,0);
		read(m,p);
		while (p.codigo<>i) do 
			read(m,p);
		p.stock:=-1;
		seek(m,filePos(m)-1);
		write(m,p);
	end;
	close(d);
	close(m);
end;

procedure comprimirArchivo(var m:maestro);
var
	p:prenda;
	aux:maestro;
begin
	reset(m);
	assign(aux,'aux.dat');
	rewrite(aux);
	while not eof(m)do begin
		read(m,p);
		if(p.stock>=0)then begin
			write(aux,p);
		end;
	end;
	close(aux);
	close(m);
	erase(m);
	rename(aux,'maestro.dat');
end;

procedure listarContenido(var m:maestro);
var
	p:prenda;
begin
	reset(m);
	while not eof(m)do begin
		read(m,p);
		writeln('Codigo: ',p.codigo);
		writeln('descripcion: ',p.descripcion);
		writeln('colores: ',p.colores);
		writeln('tipo_prenda: ',p.tipo_prenda);
		writeln('stock: ',p.stock);
		writeln('precio_unitario: ',p.precio_unitario);
	end;
	close(m);
end;
	
var
	d:detalle;
	m:maestro;
	opcion:integer;
begin
	assign(m,'maestro.dat');
	assign(d,'detalle.dat');
	crearMaestro(m);
	rewrite(d);
	close(d);
	repeat
		writeln('Ingrese la opcion:');
		writeln('Opcion 1: Cambio de temporada');
		writeln('Opcion 2: Realizar baja logica');
		writeln('Opcion 3: Comprimir archivo');
		writeln('Opcion 4: Listar contenido');
		writeln('Opcion 0: Terminar Ejecucion');
		readln(opcion);
		case(opcion)of
			1:cambioTemporada(d);
			2:bajaLogica(m,d);
			3:comprimirArchivo(m);
			4:listarContenido(m);
			0:writeln('Terminando la ejecucion del programa...');
		else
			writeln('Opcion no valida, ingrese nuevamente');
		end;
	until(opcion=0);
end.
