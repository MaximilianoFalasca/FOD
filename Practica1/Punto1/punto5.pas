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
	
procedure cargarArchivo(var arc:archivo;text:Text);
var
	cel:celular;
begin
	seek(text,0);
	while not eof(arc) do begin
		read(text,cel.codigo,cel.nombre,cel.descripcion,cel.marca,cel.precio,cel.stock_minimo,cel.stock_actual);
		write(arc,cel);
	end;
	close(text);
end;

procedure listarStockMin(arc:archivo);
var
	cel:celular;
begin
	writeln('Productos con menos stock del minimo:');
	seek(arc,0);
	while not eof(arc) do begin
		read(arc,cel);
		if(cel.stock_minimo>cel.stock_actual)then begin
			writeln('Codigo: ',cel.codigo,' Producto: ',cel.nombre,' Descripcion: ',cel.descripcion,' Marca: ',cel.marca,' Precio: ',cel.precio,' Stock Minimo: ',cel.stock_minimo,' Stock Actual: ',cel.stock_actual);
		end;
	end;
end;

procedure listarConDescripcion(arc:archivo);
var
	cadena:string;
	cel:celular;
begin
	writeln('Productos con un string ingresado:');
	writeln('Ingresar cadena de caracteres:');
	readln(cadena);
	seek(arc,0);
	while not eof(arc) do begin
		read(arc,cel);
		if pos(cadena,cel.descripcion)>0 then begin
			writeln('Codigo: ',cel.codigo,' Producto: ',cel.nombre,' Descripcion: ',cel.descripcion,' Marca: ',cel.marca,' Precio: ',cel.precio,' Stock Minimo: ',cel.stock_minimo,' Stock Actual: ',cel.stock_actual);
		end;
	end;
end;

procedure exportarArchivo(var arc:archivo;var text:Text);
var
	cel:celular;
begin
	seek(arc,0);
	seek(text,0);
	while not eof(arc) do begin
		read(arc,cel);
		writeln(text,'Codigo: ',cel.codigo,' Producto: ',cel.nombre,' Descripcion: ',cel.descripcion,' Marca: ',cel.marca,' Precio: ',cel.precio,' Stock Minimo: ',cel.stock_minimo,' Stock Actual: ',cel.stock_actual);
	end;
end;
	
begin
	assign(celu_text,'celulares.txt');
	reset(celu_text);
	writeln('Ingresar nombre del archivo:');
	readln(nombre_archivo);
	nombre_archivo:=nombre_archivo+'.doc';
	assign(arc,nombre_archivo);
	cargarArchivo(arc,celu_text);
	close(celu_text);
	listarStockMin(arc);
	listarConDescripcion(arc);
	exportarArchivo(arc,celu_text);
	close(arc);
end.
