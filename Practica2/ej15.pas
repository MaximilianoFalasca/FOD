{
La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo
}
program ej15;
const
	//df=100;
	df=5;
	valorAlto=9999;
type
	emision = record
		fecha:string[10];
		codigo:integer;
		nombre:string[10];
		descripcion:string[10];
		precio:real;
		totalEjemplares:integer;
		totalVendidos:integer;
	end;
	venta = record
		fecha:string[10];
		codigo:integer;
		cant:integer;
	end;
	informacion=file of emision;
	info_det=file of venta;
	detalle=array[1..df] of info_det;
	detalle_aux=array[1..df] of venta;
	
procedure leerDatos(var i:emision);
begin
	writeln('Ingresar codigo:');
	readln(i.codigo);
	if(i.codigo<>valorAlto)then begin
		writeln('Ingresar fecha');
		readln(i.fecha);
		writeln('Ingresar nombre');
		readln(i.nombre);
		writeln('Ingresar descripcion');
		readln(i.descripcion);
		writeln('Ingresar precio');
		readln(i.precio);
		writeln('Ingresar totalEjemplares');
		readln(i.totalEjemplares);
		writeln('Ingresar totalVendidos');
		readln(i.totalVendidos);
	end;
end;

procedure leerDatosVenta(var a:info_det);
var
	i:venta;
begin
	writeln('Ingresar codigo:');
	readln(i.codigo);
	if(i.codigo<>valorAlto)then begin
		writeln('Ingresar fecha');
		readln(i.fecha);
		writeln('Ingresar cantidad de ejemplares vendidos');
		readln(i.cant);
	end;
	write(a,i);
end;
	
procedure crearDetalles(var d:detalle);
var
	i:integer;
begin
	writeln('Terminar de ingresar los datos con el codigo 9999');
	for i:=1 to df do begin
		rewrite(d[i]);
		leerDatosVenta(d[i]);
		close(d[i]);
	end;
end;

procedure crearMaestro(var m:informacion);
var
	e:emision;
begin
	rewrite(m);
	leerDatos(e);
	while(e.codigo<>valorAlto)do begin
		write(m,e);
		leerDatos(e);
	end;
	close(m);
end;
	
procedure leer(var i:info_det;var e:venta);
begin
	if not eof(i)then
		read(i,e)
	else
		e.codigo:=valorAlto;
end;
	
procedure obtenerMinimo(var d:detalle;var tmp:detalle_aux;var e:venta);
var
	pos,i:integer;
begin
	e.codigo:=valorAlto;
	for i:=1 to df do
		if (tmp[i].codigo<e.codigo) then begin
			e:=tmp[i];
			pos:=i;
		end;
	if(e.codigo<>valorAlto)then
		leer(d[pos],tmp[pos]);
end;
	
procedure procesarDatos(var m:informacion;var d:detalle);
var
	i:integer;
	tmp:detalle_aux;
	mae:emision;
	min:venta;
begin
	reset(m);
	for i:=1 to df do begin
		reset(d[i]);
		leer(d[i],tmp[i]);
	end;
	obtenerMinimo(d,tmp,min);
	read(m,mae);
	while(min.codigo<>valorAlto)do begin
		while(mae.fecha<>min.fecha)do 
			read(m,mae);
		while((min.codigo<>valorAlto)and(mae.fecha=min.fecha))do begin
			while(mae.codigo<>min.codigo)do
				read(m,mae);
			while((min.codigo<>valorAlto)and(mae.fecha=min.fecha)and(mae.codigo=min.codigo))do begin
				if(min.cant<=mae.totalEjemplares)then begin
					mae.totalEjemplares:=mae.totalEjemplares-min.cant;
					mae.totalVendidos:=mae.totalVendidos+min.cant;
				end
				else
					writeln('la cantidad vendida supera al stock de ejemplares');
				obtenerMinimo(d,tmp,min);
			end;
			write(m,mae);
		end;
	end;
	close(m);
	for i:=1 to df do
		close(d[i]);
end;
	
var
	d:detalle;
	m:informacion;
	i:integer;
	s:string;
begin
	assign(m,'ej15Maestro.dat');
	for i:=1 to df do begin
		Str(i,s);
		assign(d[i],'ej15Detalle'+s+'.dat');
	end;
	crearDetalles(d);
	crearMaestro(m);
	procesarDatos(m,d);
end.
