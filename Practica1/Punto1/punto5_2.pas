program punto5;
type
	celular = record
		codigo:integer;
		nombre:string[20];
		descripcion:string[20];
		marca:string[20];
		precio:real;
		stock_minimo:integer;
		stock_actual:integer;
	end;
	archivo = file of celular;
var
	arc:archivo;
	celu_text:Text;
	nombre_archivo:string[20];
	opcion:integer;
	
procedure leerCel(var cel:celular);
begin
	writeln('Ingresar codigo de celular:');
	readln(cel.codigo);
	if(cel.codigo <> -1)then begin
		writeln('Ingresar nombre:');
		readln(cel.nombre);
		writeln('Ingresar descripcion:');
		readln(cel.descripcion);
		writeln('Ingresar marca:');
		readln(cel.marca);
		writeln('Ingresar precio:');
		readln(cel.precio);
		writeln('Ingresar stock minimo:');
		readln(cel.stock_minimo);
		writeln('Ingresar stock actual:');
		readln(cel.stock_actual);
	end;
end;

procedure agregarCelulares(var arc:archivo);
var
	cel:celular;
begin
	leerCel(cel);
	while(cel.codigo<>-1)do begin
		write(arc,cel);
		leerCel(cel);
	end;
end;

procedure cargarArchivo(var arc:archivo);
begin
	rewrite(arc);
	agregarCelulares(arc);
	close(arc);
end;

procedure listarCelSinStockSuficiente(var arc:archivo);
var
	cel:celular;
begin
	reset(arc);
	seek(arc,0);
	writeln('Productos con menos stock del minimo:');
	while not eof(arc) do begin
		read(arc,cel);
		if(cel.stock_minimo>cel.stock_actual)then begin
			writeln('Codigo: ',cel.codigo,' Producto: ',cel.nombre,' Descripcion: ',cel.descripcion,' Marca: ',cel.marca,' Precio: ',cel.precio,' Stock Minimo: ',cel.stock_minimo,' Stock Actual: ',cel.stock_actual);
		end;
	end;
	close(arc);
end;

procedure listarCelConDescripcionCoincidiente(var arc:archivo);
var
	cadena:string;
	cel:celular;
begin
	reset(arc);
	seek(arc,0);
	writeln('Productos con un string ingresado:');
	writeln('Ingresar cadena de caracteres:');
	readln(cadena);
	while not eof(arc) do begin
		read(arc,cel);
		if pos(cadena,cel.descripcion)>0 then begin
			writeln('Codigo: ',cel.codigo,' Producto: ',cel.nombre,' Descripcion: ',cel.descripcion,' Marca: ',cel.marca,' Precio: ',cel.precio,' Stock Minimo: ',cel.stock_minimo,' Stock Actual: ',cel.stock_actual);
		end;
	end;
	close(arc);
end;

procedure exportarArchivo(var arc:archivo;var text:Text);
var
	cel:celular;
begin
	reset(arc);
	seek(arc,0);
	assign(text,'celulares.txt');
	rewrite(text);
	while not eof(arc) do begin
		read(arc,cel);
		writeln(text,'Codigo: ',cel.codigo,' Precio: ',cel.precio,' Marca: ',cel.marca);
		writeln(text,' Stock Disponible: ',cel.stock_actual,' Stock Minimo: ',cel.stock_minimo,' Descripcion: ',cel.descripcion);
		writeln(text,' Producto: ',cel.nombre);
	end;
	close(text);
	close(arc);
end;

procedure agregarCelularFinal(var arc:archivo);
begin
	reset(arc);
	seek(arc,filesize(arc));
	agregarCelulares(arc);
	close(arc);
end;

procedure modificarStock(var arc:archivo);
var
	nombre:string;
	cel:celular;
begin
	writeln('Ingresar nombre del celular a modificar:');
	readln(nombre);
	reset(arc);
	seek(arc,0);
	read(arc,cel);
	while((not eof(arc))and(cel.nombre=nombre))do begin
		read(arc,cel);
	end;
	if(cel.nombre=nombre)then begin
		writeln('Ingresar el stock actual:');
		readln(cel.stock_actual);
		seek(arc,filePos(arc)-1);
		write(arc,cel)
	end
	else begin
		writeln('No se encontro el celular');
	end;
	close(arc);
end;

procedure exportarSinStock(var arc:archivo);
var
	text_asda:Text;
	cel:celular;
begin
	assign(text_asda,'sinStock.txt');
	rewrite(text_asda);
	reset(arc);
	seek(arc,0);
	read(arc,cel);
	while not eof(arc) do begin
		if(cel.stock_actual=0)then begin
			writeln(text_asda,cel.codigo,cel.nombre,cel.descripcion,cel.marca,cel.precio,cel.stock_minimo,cel.stock_actual);
		end;
		read(arc,cel);
	end;
	close(arc);
	close(text_asda);
end;

procedure leerOpcion(var opcion:integer);
begin
	writeln('Ingresar Opcion:');
	writeln();
	writeln('opcion 1-cargar archivo: ');
	writeln('opcion 2-listar en pantalla los celulares que tengan un stock menor al stock minimo: ');
	writeln('opcion 3-listar en pantalla los celulares que tengan en la descripcion una cadena de caracteres descripta: ');
	writeln('opcion 4-exportar archivo a "celulares.txt"');
	writeln('opcion 5-agregar celular/es al final: ');
	writeln('opcion 6-modificar Stock de celular/es');
	writeln('opcion 7-exportar celulares sin stock a "sinStock.txt"');
	readln(opcion);
end;
	
begin
	writeln('Ingresar nombre del archivo:');
	readln(nombre_archivo);
	assign(arc,nombre_archivo);
	leerOpcion(opcion);
	while(opcion<>-1)do begin
		case opcion of
			1: cargarArchivo(arc);
			2: listarCelSinStockSuficiente(arc);
			3: listarCelConDescripcionCoincidiente(arc);
			4: exportarArchivo(arc,celu_text);
			5: agregarCelularFinal(arc);
			6: modificarStock(arc);
			7: exportarSinStock(arc);
		end;
		leerOpcion(opcion);
	end;
end.
