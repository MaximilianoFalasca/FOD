program parcial;
const
	valorAlto=9999;
	df=3;
type
	producto=record
		codigoProducto:integer;
		nombre:string[10];
		descripcion:string[10];
		codigoBarras:integer;
		categoria:integer;
		stockActual:integer;
		stockMinimo:integer;
	end;
	
	pedido=record
		codigoProducto:integer;
		cantidad:integer;
		descripcion:string[10];
	end;
	
	maestro=file of producto;
	detalle=file of pedido;
	arrayDetalles=array[1..df] of detalle;
	arrayPedido=array[1..df] of pedido;
	
procedure leerInformacion(var i:producto);
begin
	writeln('Ingresar codigo de producto');
	readln(i.codigoProducto);
	if(i.codigoProducto<>valorAlto)then begin
		writeln('Ingresar descripcion');
		readln(i.descripcion);
		writeln('Ingresar codigoBarras');
		readln(i.codigoBarras);
		writeln('Ingresar categoria');
		readln(i.categoria);
		writeln('Ingresar stockActual');
		readln(i.stockActual);
		writeln('Ingresar stockMinimo');
		readln(i.stockMinimo);
	end;
end;

procedure crearArchivo(var a:maestro);
var
	i:producto;
begin
	rewrite(a);
	leerInformacion(i);
	while(i.codigoProducto<>valorAlto)do begin
		write(a,i);
		leerInformacion(i);
	end;
	close(a);
end;

procedure leerPedido(var p:pedido);
begin
	writeln('Ingresar codigoProducto');
	readln(p.codigoProducto);
	if(p.codigoProducto<>valorAlto)then begin
		writeln('Ingresar cantidad');
		readln(p.cantidad);
		writeln('Ingresar descripcion');
		readln(p.descripcion);
	end;
end;

procedure leerPedidos(var a:arrayDetalles);
var
	i:integer;
	p:pedido;
begin
	for i:=1 to df do begin
		rewrite(a[i]);
		leerPedido(p);
		while(p.codigoProducto<>valorAlto)do begin
			write(a[i],p);
			leerPedido(p);
		end;
	end;
end;

procedure leer(var d:detalle;var p:pedido);
begin
	if(not eof(d))then
		read(d,p)
	else
		p.codigoProducto:=valorAlto;
end;

procedure obtenerMin(var a:arrayDetalles;var d:arrayPedido;var min:pedido);
var
	i,pos:integer;
begin
	min.codigoProducto:=valorAlto;
	for i:=1 to df do
		if(d[i].codigoProducto<min.codigoProducto)then begin
			min.codigoProducto:=d[i].codigoProducto;
			pos:=i;
		end;
	if(min.codigoProducto<>valorAlto)then
		leer(a[pos],d[pos]);
end;
	
procedure informarProductosSinStock(var m:maestro;var t:Text);
var
	p:producto;
begin
	rewrite(t);
	while(not eof(m))do begin
		read(m,p);
		if(p.stockActual<p.stockMinimo)then
			writeln(t,p.codigoProducto,' categoria: ',p.categoria);
	end;
	close(t);
end;
	
procedure actualizarMaestro(var m:maestro;var t:Text; var a:arrayDetalles);
var	
	min:pedido;
	p:producto;
	d:arrayPedido;
	i,diferencia:integer;
begin
	reset(m);
	leerPedidos(a);
	for i:=1 to df do begin
		seek(a[i],0);
		leer(a[i],d[i]);
	end;
	obtenerMin(a,d,min);
	read(m,p);
	while(min.codigoProducto<>valorAlto)do begin
		while(p.codigoProducto<>min.codigoProducto)do 
			read(m,p);
		while((min.codigoProducto<>valorAlto)and(p.codigoProducto=min.codigoProducto))do begin
			if((p.stockActual-min.cantidad)>=p.stockMinimo)then
				p.stockActual:=p.stockActual-min.cantidad
			else begin
				diferencia:=p.stockMinimo-(p.stockActual-min.cantidad);
				writeln('No hay suficiente stock para satisfacer el pedido: ',min.descripcion,' por esta diferencia: ',diferencia);
			end;
			obtenerMin(a,d,min);
		end;
		seek(m,filePos(m)-1);
		write(m,p);
	end;
	informarProductosSinStock(m,t);
	for i:=1 to df do begin
		close(a[i]);
	end;
	close(m);
end;	

var
	m:maestro;
	d:arrayDetalles;
	t:Text;
	i:integer;
	s:string;
begin
	assign(t,'informe.txt');
	assign(m,'maestro.dat');
	crearArchivo(m);
	for i:=1 to df do begin
		Str(i,s);
		assign(d[i],'detalle'+s+'.dat');
	end;
	{repeat
		writeln();
		writeln('Ingrese opcion:');
		writeln('opcion 1: agregar pedidos');
		writeln('opcion 2: actualizar maestro');
		writeln('opcion 3: listar informacion');
		writeln('opcion 0: terminar la ejecucion');
		readln(i);
		case(i)of
			1:agregarPedidos(m);
			2:}actualizarMaestro(m,t,d);{
			3:listarInformacion(m);
		else
			if(i<>0)then
				writeln('opcion no valida, vuelva a intentar');
		end;
	until(i=0);}
end.
