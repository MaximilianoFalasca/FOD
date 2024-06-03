program parcial;
const
	valorAlto=9999;
type
	producto=record
		codigo:integer;
		nombre:string[10];
		descripcion:string[10];
		precioCompra:real;
		precioVenta:real;
		ubicacion:string[10];
	end;
	arc=file of producto;

procedure leerProducto(var p:producto);
begin
	writeln('ingresar codigo');
	readln(p.codigo);
	if(p.codigo<>valorAlto)then begin
		writeln('ingresar nombre');
		readln(p.nombre);
		writeln('ingresar descripcion');
		readln(p.descripcion);
		writeln('ingresar precioCompra');
		readln(p.precioCompra);
		writeln('ingresar precioVenta');
		readln(p.precioVenta);
		writeln('ingresar ubicacion');
		readln(p.ubicacion);
	end;
end;

procedure crearArchivo(var a:arc);
var
	p:producto;
begin
	rewrite(a);
	p.codigo:=0;
	write(a,p);
	leerProducto(p);
	while(p.codigo<>valorAlto)do begin
		write(a,p);
		leerProducto(p);
	end;
	close(a);
end;

function existeProducto(var a:arc;p:producto):boolean;
var
	aux:producto;
	encontre:boolean;
begin
	seek(a,0);
	encontre:=false;
	while((encontre=false) and(not eof(a)))do begin
		read(a,aux);
		if(aux.codigo=p.codigo)then
			encontre:=true;
	end;
	seek(a,0);
	existeProducto:=encontre;
end;

procedure agregarProducto(var a:arc);
var
	p,aux:producto;
begin
	reset(a);
	leerProducto(p);
	if(not existeProducto(a,p))then begin
		seek(a,0);
		read(a,aux);
		if(aux.codigo<0)then begin
			//voy a la posicion, agarro su pos y sobreescribo
			seek(a,aux.codigo*-1);
			read(a,aux);
			seek(a,filePos(a)-1);
			write(a,p);
			//voy a la pos de la cabecera y sobreecribo con le pos agarrada
			seek(a,0);
			write(a,aux);
		end
		else begin
			//voy a la ultima posicion
			seek(a,fileSize(a));
			//agrego elemento
			write(a,p);
		end;
	end
	else
		writeln('El producto ya existe en el archivo');
	close(a);
end;

procedure bajaProducto(var a:arc);
var
	p,aux:producto;
	cod:integer;
begin
	reset(a);
	leerProducto(p);
	if(existeProducto(a,p))then begin
		seek(a,0);
		read(a,aux);
		cod:=aux.codigo;
		while((not eof(a)) and (aux.codigo<>p.codigo))do
			read(a,aux);
		aux.codigo:=cod;
		
		seek(a,filePos(a)-1);
		write(a,aux);
		cod:=filePos(a)-1;
				
		aux.codigo:=cod*-1;	
		seek(a,0);
		write(a,aux);
	end
	else
		writeln('El producto no exite en el archivo');
	close(a);
end;

procedure listar(var a:arc);
var
	p:producto;
begin
	reset(a);
	while(not eof(a))do begin
		read(a,p);
		writeln();
		writeln('codigo: ',p.codigo);
		writeln('nombre: ',p.nombre);
		writeln('descripcion: ',p.descripcion);
		writeln('precioCompra: ',p.precioCompra);
		writeln('precioVenta: ',p.precioVenta);
		writeln('ubicacion: ',p.ubicacion);
	end;
	close(a);
end;

var
	a:arc;
	opcion:integer;
begin
	assign(a,'archivo.dat');
	crearArchivo(a);//suponemos que ya esta cargado correctamente
	repeat
		writeln('Ingrese opcion');
		writeln('opcion1: agregar producto');
		writeln('opcion2: baja logica del producto');
		writeln('opcion3: listar');
		writeln('opcion0: terminal la ejecucion del programa');
		readln(opcion);
		case(opcion)of	
			1:agregarProducto(a);
			2:bajaProducto(a);
			3:listar(a);
		else
			if(opcion<>0)then 
				writeln('opcion no valida ingrese nuevamente');
		end;
	until(opcion=0);
end.
