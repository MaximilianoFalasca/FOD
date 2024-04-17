{
Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.
}
program ej16;
const
	df=10;
	valorAlto=9999;
type
	maestro = record
		codigo:integer;
		nombre:string[10];
		descripcion=string[10];
		modelo:integer;
		marca:string[10];
		stockActual:integer;
	end;
	detalle = record
		codigo=integer;
		precio:real;
		fecha:string[10];
	end;
	arc_detalle = file of detalle;
	arr_arc_detalle= array[1..10] of arc_detalle;
	arr_detalle=array[1..10] of detalle;
	arc_maestro = file of maestro;
	
procedure leerDatosDetalle(var aux:detalle;var i:integer);
begin
	writeln('Ingresar numero de archivo detalle:');
	readln(i);
	if(i<11 and i>0)then begin
		writeln('Ingresar codigo');
		read(aux.codigo);
		if(aux.codigo<>valorAlto)then begin
			writeln('Ingresar precio');
			read(aux.precio);
			writeln('Ingresar fecha');
			read(aux.fecha);
		end;
	end;
end;
	
procedure crearArchivoDetalle(var d:arr_arc_detalle);
var
	i:integer;
	aux:detalle;
begin
	for i:=1 to df do 
		rewrite(d[i]);
	writeln('termina con numero de archivo fuera del rango 1..10 o con el codigo 9999');
	leerDatosDetalle(aux,i);
	while(i<11 and i>0 and aux.codigo<>valorAlto)do begin
		write(d[i],aux);
		leerDatosDetalle(aux,i);
	end;
	for i:=1 to df do
		close(d[i]);
end;

procedure leerDatosMaestro(var m:maestro);
begin
	writeln('Ingresar codigo');
	readln(aux.codigo);
	if(aux.codigo<>valorAlto)then begin
		writeln('Ingresar nombre');
		readln(aux.nombre);
		writeln('Ingresar descripcion');
		readln(aux.descripcion);
		writeln('Ingresar modelo');
		readln(aux.modelo);
		writeln('Ingresar marca');
		readln(aux.marca);
		writeln('Ingresar stockActual');
		readln(aux.stockActual);
	end;
end;
	
procedure crearArchivoMaestro(var m:arc_maestro);
var
	aux:maestro;
begin
	reqrite(m);
	leerDatosMaestro(aux);
	while(aux.codigo<>valorAlto)do begin
		write(m,aux);
		leerDatosMaestro(aux);
	end;
	close(m);
end;
	
procedure actualizarMaestro(var m:arc_maestro;var d:arr_arc_detalle);
var
	i:integer;
	auxDetalle:arr_detalle;
	min:detalle;
	auxMaestro:maestro;
	maxCant,cantActual:integer;
	maxMoto:string[10];
begin
	cantidadActual:=0;
	maxCant:=9999;
	for i:= 1 to df do begin
		reset(d[i]);
		leer(d[i],auxDetalle[i]);
	end;
	reset(m);
	if not eof(m) then begin
		read(m,auxMaestro);
		obtenerMinimo(d,auxDetalle,min);
		while (min.codigo<>valorAlto) do begin
			while(auxMaestro.codigo<>min.codigo)do
				read(m,auxMaestro);
			while((min.codigo<>valorAlto)and(auxMaestro.codigo=min.codigo))do begin
				if(auxMaestro.stockActual>0)then begin
					cantidadActual:=cantidadActual+1;
					auxMaestro.stockActual:=auxMaestro.stockActual-1;
				end;
				obtenerMinimo(d,auxDetalle,min);
			end;
			if(maxCant<cantidadActual)then begin
				maxCant:=cantidadActual;
				maxMoto:=min.nombre;
			end;
			seek(m,filePos(m)-1);
			write(m,auxMaestro);
		end;
	end;
	for i:=1 to df do
		close(d[i]);
end;
	
var
	d:arr_arc_detalle;
	m:arc_maestro;
	i:integer;
	s:string;
begin
	assign(m,'ej16Maestro.dat');
	for i:=1 to df do begin
		Str(i,s);
		assign(d[i],'ej16Detalle'+s+'.dat');
	end;
	crearArchivoDetalle(d);
	crearArchivoMaestro(m);
	actualizarMaestro(m,d);
end.
