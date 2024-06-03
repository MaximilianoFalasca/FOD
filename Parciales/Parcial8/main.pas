program parcial;
const
	valorAlto=9999;
	df=3;
type
	producto=record
		codigo:integer;
		nombre:string[10];
		precio:real;
		stockActual:integer;
		stockMinimo:integer;
	end;
	venta=record
		codigo:integer;
		cantidad:integer;
	end;
	maestro=file of producto;
	detalle=file of venta;
	arr_detalle=array[1..df] of detalle;
	arr_aux=array[1..df]of venta;
	
procedure leerInformacionD(var i:venta);
begin
	writeln('Ingresar codigo');
	readln(i.codigo);
	if(i.codigo<>valorAlto)then begin
		writeln('Ingresar cantidad');
		readln(i.cantidad);
	end;
end;

procedure crearArchivoD(var a:detalle);
var
	i:venta;
begin
	rewrite(a);
	leerInformacionD(i);
	while(i.codigo<>valorAlto)do begin
		write(a,i);
		leerInformacionD(i);
	end;
	close(a);
end;
	
procedure leerInformacion(var i:producto);
begin
	writeln('Ingresar codigo');
	readln(i.codigo);
	if(i.codigo<>valorAlto)then begin
		writeln('Ingresar nombre');
		readln(i.nombre);
		writeln('Ingresar precio');
		readln(i.precio);
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
	while(i.codigo<>valorAlto)do begin
		write(a,i);
		leerInformacion(i);
	end;
	close(a);
end;
	
procedure leer(var d:detalle;var v:venta);
begin
	if(not eof(d))then
		read(d,v)
	else
		v.codigo:=valorAlto;
end;

procedure obtenerMin(var d:arr_detalle;var aux:arr_aux;var min:venta);
var
	i,pos:integer;
begin
	min.codigo:=valorAlto;
	for i:= 1 to df do
		if(aux[i].codigo<min.codigo)then begin
			pos:=i;
			min:=aux[i];
		end;
	if(min.codigo<>valorAlto)then 
		leer(d[pos],aux[pos]);
end;
	
procedure inciso(var m:maestro;var d:arr_detalle;var t:Text);
var	
	p:producto;
	aux:arr_aux;
	total:integer;
	min:venta;
	es:boolean;
begin
	reset(m);
	rewrite(t);
	for total:=1 to df do begin
		reset(d[total]);
		leer(d[total],aux[total]);
	end;
	obtenerMin(d,aux,min);
	while(min.codigo<>valorAlto)do begin
		total:=0;
		read(m,p);
		while(p.codigo<>min.codigo)do 
			read(m,p);
		while((min.codigo<>valorAlto) and (p.codigo=min.codigo))do begin
			if((p.stockActual-min.cantidad)>p.stockMinimo)then begin 
				p.stockActual:=p.stockActual-min.cantidad;
				total:=total+min.cantidad;
			end
			else begin	
				writeln('No hay mas stock para vender del producto con codigo: ',p.codigo);
				es:=true;
			end;
			repeat
				obtenerMin(d,aux,min);
				if(min.codigo<>p.codigo)then
					es:=false;
			until(es=false);
		end;
		seek(m,filePos(m)-1);
		write(m,p);
		if(total>10000)then 
			writeln(t,p.codigo,' ',p.nombre,' ',p.precio,' ',p.stockActual,' ',p.stockMinimo);
	end;
	close(t);
	close(m);
end;

procedure listarInformacion(var a:maestro);
var
	aux:producto;
begin
	reset(a);	
	writeln();
	writeln('-------------  -------------');
	while (not eof(a)) do begin
		read(a,aux);
		writeln('codigo: ',aux.codigo);
		writeln('nombre: ',aux.nombre);
		writeln('precio: ',aux.precio);
		writeln('stockActual: ',aux.stockActual);
		writeln('stockMinimo: ',aux.stockMinimo);
		writeln();
	end;
	close(a);
end;
	
procedure listar(var a:arr_detalle);
var
	i:integer;
	aux:venta;
	s:string;
begin
	for i:=1 to df do
		reset(a[i]);
	for i:=1 to df do begin
		Str(i,s);
		writeln();
		writeln('------------- sucursal numero '+s+' -------------');
		while (not eof(a[i])) do begin
			read(a[i],aux);
			writeln('codigo: ',aux.codigo);
			writeln('cantidad: ',aux.cantidad);
			writeln();
		end;
	end;
	for i:=1 to df do
		close(a[i]);
end;
	
var
	m:maestro;
	d:arr_detalle;
	t:Text;
	i:integer;
	s:string;
begin
	assign(t,'datos.txt');
	assign(m,'maestro.dat');
	writeln('Ingresando datos del archivo maestro');
	//crearArchivo(m);
	writeln();
	for i:=1 to df do begin
		Str(i,s);
		assign(d[i],'detalle'+s+'.dat');
		writeln('Ingresando datos de archivo detalle numero',i);
		writeln();
		//crearArchivoD(d[i]);
	end;
	repeat
		writeln('Ingresar Opcion');
		writeln('Opcion1: ingresar detalles');
		writeln('Opcion2: inciso');
		writeln('Opcion3: listar');
		writeln('Opcion0: terminar');
		readln(i);
		case(i)of
			1:listar(d);
			2:inciso(m,d,t);
			3:listarInformacion(m);
		else
			if(i<>0)then
				writeln('opcion invalida ingrese nuevamente');
		end;
	until(i=0);
end.
