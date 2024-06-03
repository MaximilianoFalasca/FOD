program parcial;
type
	producto=record
		codigoProducto:integer;
		nombreProducto:string[10];
		descripcion:string[10];
		precioCompra:real;
		precioVenta:real;
		ubicacion:string[10];
	end;
	arc=file of producto;

procedure alta(var a:arc);
var
	p,aux:producto;
begin
	reset(a);
	leerProducto(p);
	if(not existeProducto(a,p.codigoProducto))then begin
		read(a,aux);
		if(aux.codigoProducto=0)then begin
			seek(a,fileSize(a));
			write(a,p);
		end
		else begin
			seek(a,aux.codigoProducto*-1);
			read(a,aux);
			
			seek(a,filePos(a)-1);
			write(a,p);
			
			seek(a,0);
			write(a,aux);
		end;
	end
	else
		writeln('El producto ya existe');
	close(a);
end;


procedure baja(var a:arc);
var
	p,aux:producto;
	codigo,i:integer;
begin
	reset(a);
	writeln('Ingresar codigo');
	readln(codigo);
	if(existeProducto(a,codigo))then begin
		seek(a,0);
		read(a,p);
		i:=p.codigo;
		while(p.codigoProducto<>codigo)do
			read(a,p);
			
		//guardar el puntero del nodo siguiente a eliminar
		aux.codigo:=(filePos(a)-1)*-1;
			
		//cambias el nodo a eliminar por el que estaba en la cabecera
		p.codigo:=i*-1;
		seek(a,filePos(a)-1);
		write(a,p);
		
		//cambias la cabecera por la nuevo
		seek(a,0);
		write(a,aux);
	end
	else
		writeln('El producto no existe en el archivo');
	close(a);
end;

var
	a:arc;
	opcion:integer;
begin
	assign(a,'arc.dat');
	crearArchivo(a);//ya se dispone
	repeat
		writeln('ingresar opcion');
		writeln('opcion1: agregar producto');
		writeln('opcion2: baja producto');
		writeln('opcion3: imprimir productos');
		writeln('opcion0: terminar proceso');
		readln(opcion);
		case(opcion)of
			1:alta(a);
			2:baja(a);
			3:imprimir(a);
		else
			if(opcion<>0)then
				writeln('opcion incorrecta');
		end;
	until(opcion=0);
end.
