program ej3;
const
	valorAlto=9999;
type
	producto = record
		cod:integer;
		nombre:string[20];
		precio:real;
		stock_actual:integer;
		stock_minimo:integer;
	end;
	venta = record
		cod:integer;
		cant:integer;
	end;
	archivoProductos = file of producto;
	archivoDetalle = file of venta;
var
	productos:archivoProductos;
	detalles:archivoDetalle;
	nombreArchivo:string[20];
	
procedure leer(var detalles:archivoDetalles;var detalle:venta);
begin
	if not eof(detalles)then
		read(detalles,detalle);
	else
		detalle.cod:=valorAlto;
end;

procedure actualizarMaestro(var productos:archivoProductos;var detalles:archivoDetalles);
var
	detalle:venta;
	p:producto;
begin
	reset(productos);
	reset(detalles);
	leer(detalles,detalle);
	while (detalle.cod <> valorAlto) do begin
		read(productos,p);
		while((detalle.cod <> valorAlto) and (detalle.cod = p.cod))do begin
			p.stock_actual:=p.stock_actual-detalle.cant;
			leer(detalles,detalle);
		end;
		seek(productos,filePos(productos)-1);
		write(productos,p);
	end;
	close(productos);
	close(detalles);
end;

procedure listarMin(var productos:archivoProductos);
var
	txt:Text;
	p:producto;
	nombre:String[20];
begin
	writeln('Ingresar nombre del archivo.doc');
	readln(nombre);
	rewrite(txt,nombre);
	while not eof(productos)do begin
		read(productos,p);
		writeln(p.cod,' ',p.nombre,' ',p.precio,' ',p.stock_actual,' ',p.stock_minimo);
	end;
	close(txt);
end;
	
begin
	writeln('Ingresar nombre del archivo de los productos:');
	readln(nombreArchivo);
	assign(productos,nombreArchivo);
	writeln('Ingresar nombre del archivo detalle:');
	readln(nombreArchivo);
	assign(detalles,nombreArchivo);
	writeln('Ingresando datos:');
	ingresarDatos(productos,detalles);
	writeln('Actualizando maestro:');
	actualizarMaestro(productos,detalles);
	writeln('listando productos con stock menor al minimo:');
	listarMin(productos);
end.
