{
1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:
a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?
}
program main;
type
	producto=record
		codigo:integer;
		nombre:string[10];
		precio:real;
		stock_actual:integer;
		stock_minimo:integer;
	end;
	venta=record
		codigo:integer;
		cantidad:integer;
	end;
	arc_detalle=file of venta;
	arc_maestro=file of producto;

procedure leerDatoProducto(var p:producto);
begin
	writeln('Ingresar codigo de producto');
	readln(p.codigo);
	if(p.codigo<>9999)then begin
		writeln('Ingresar nombre de producto');
		readln(p.nombre);
		writeln('Ingresar precio de producto');
		readln(p.precio);
		writeln('Ingresar stock_actual de producto');
		readln(p.stock_actual);
		writeln('Ingresar stock_minimo de producto');
		readln(p.stock_minimo);
	end;
end;
	
procedure CrearArchivoMaestro(var a:arc_maestro);
var
	p:producto;
begin
	rewrite(a);
	leerDatoProducto(p);
	while (p.codigo<>9999) do begin
		write(a,p);
		leerDatoProducto(p);
	end;
	close(a);
end;

procedure leerDatoVenta(var p:venta);
begin
	writeln('Ingresar codigo de producto');
	readln(p.codigo);
	if(p.codigo<>9999)then begin
		writeln('Ingresar cantidad de ventas');
		readln(p.cantidad);
	end;
end;

procedure CrearArchivoDetalle(var a:arc_detalle);
var
	v:venta;
begin
	rewrite(a);
	leerDatoVenta(v);
	while (v.codigo<>9999) do begin
		write(a,v);
		leerDatoVenta(v);
	end;
	close(a);
end;

procedure ActualizarMaestro(var m:arc_maestro;var d:arc_detalle);
var
	cantTotal,cantActual:integer;
	p:producto;
	v:venta;
begin
	reset(m);
	reset(d);
	cantActual:=0;
	cantTotal:=fileSize(d);
	while(not eof(m) and (cantActual<>cantTotal))do begin
		read(m,p);
		while(not eof(d) and (cantActual<>cantTotal))do begin
			read(d,v);
			if(p.codigo=v.codigo)then begin
				if(p.stock_actual>p.stock_minimo)then
					p.stock_actual:=p.stock_actual-v.cantidad
				else
					writeln('Error: Menor stock al minimo permitido \n Codigo de producto: ',p.codigo);
				cantActual:=cantActual+1;
			end;
		end;
		seek(m,filePos(m)-1);
		write(m,p);
		seek(d,0);
	end;
	close(d);
	close(m);
end;
	
procedure ListarDatos(var a:arc_maestro);
var
	p:producto;
begin
	reset(a);
	while not eof(a) do begin
		read(a,p);
		writeln('codigo de producto ',p.codigo);
		writeln('nombre de producto ',p.nombre);
		writeln('precio de producto ',p.precio);
		writeln('stock_actual de producto ',p.stock_actual);
		writeln('stock_minimo de producto ',p.stock_minimo);
	end;
	close(a);
end;
	
var
	maestro:arc_maestro;
	detalle:arc_detalle;
begin
	assign(maestro,'maestro.dat');
	ListarDatos(maestro);
	assign(detalle,'detalle.dat');
	CrearArchivoMaestro(maestro);
	CrearArchivoDetalle(detalle);
	
	ActualizarMaestro(maestro,detalle);
	
end.
