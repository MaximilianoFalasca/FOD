{
Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}
program ej5;
const 
	rango = 30;
	valorAlto = 9999;
type
	producto = record
		cod:integer;
		nombre:string[20];
		descripcion:string[50];
		stock_actual:integer;
		stock_minimo:integer;
		precio:real;
	end;
	detalle = record
		cod:integer;
		cant:integer;
	end;
	archivo_productos = file of producto;
	archivo_detalles = file of detalle;
	vector_detalles = array[1..rango] of archivo_detalles;
var
	productos: archivo_productos;
	detalles: vector_detalles;
	i,c,ac:integer;
	a:string[10];

procedure obtenerMin(var detalles:vector_detalles;var d:detalle);
var
	tmp:detalle;
	i,pos:integer;
begin
	d.cod:=valorAlto;
	for i:=1 to rango do begin
		writeln('iteracion:',i);
		reset(detalles[i]);
		read(detalles[i],tmp);
		writeln('tmp.cod:',tmp.cod,' d.cod:',d.cod);
		if(d.cod>tmp.cod)then begin
			pos:=i;
			d.cod:=tmp.cod;
		 end;	
		seek(detalles[i],filePos(detalles[i])-1);	
		close(detalles[i]);
	end;
	writeln('4');
	if(d.cod<>valorAlto)then begin
		reset(detalles[i]);
		read(detalles[pos],d);
		close(detalles[i]);
		writeln('5');
	end;
	writeln('6');
end;

procedure actualizarMaestro(var productos:archivo_productos;var detalles:vector_detalles);
var
	p:producto;
	d:detalle;
begin
	reset(productos);
	obtenerMin(detalles,d);
	writeln('?');
	while(d.cod<>valorAlto)do begin
		writeln('??');
		read(productos,p);
		while((d.cod<>valorAlto)and(p.cod=d.cod))do begin
			p.stock_actual:=p.stock_actual-d.cant;
			obtenerMin(detalles,d);
		end;
		seek(productos,filePos(productos)-1);
		write(productos,p);
	end;
	close(productos);
end;

procedure realizarInforme(var productos:archivo_productos);
var
	txt:Text;
	p:producto;
begin
	assign(txt,'ej5txt.doc');
	rewrite(txt);
	while not eof(productos)do begin
		read(productos,p);
		if(p.stock_actual<p.stock_minimo)then
			writeln(txt,p.nombre,' ',p.descripcion,' ',p.stock_actual,' ',p.precio);
	end;
	close(txt);
end;

procedure informar(var d:archivo_detalles);
var
	de:detalle;
begin
	reset(d);
	while not eof(d) do begin
		read(d,de);
		writeln('Codigo: ',de.cod,' cant: ',de.cant);
	end;
	close(d);
end;

begin
	assign(productos,'productos_maestro.dat');
	ac:=1;
	for i:=1 to 10 do begin
		c:=1;
		Str(c,a);
		assign(detalles[ac],'detalle_sucursal_'+a+'.txt');
		informar(detalles[ac]);
		ac:=ac+1;
		c:=c+1;
		Str(c,a);
		assign(detalles[ac],'detalle_sucursal_'+a+'.txt');
		informar(detalles[ac]);
		ac:=ac+1;
		c:=c+1;
		Str(c,a);
		assign(detalles[ac],'detalle_sucursal_'+a+'.txt');
		informar(detalles[ac]);
		ac:=ac+1;
	end;
	writeln('hola'); 
	actualizarMaestro(productos,detalles);
	writeln('hola2');
	realizarInforme(productos);
	//actualizarMaestro(productos,detalles) realizando el informe aca.
end.
