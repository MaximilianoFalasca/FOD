program parcial;
type
	dinosaurio=record
		codigo:integer;
		tipo:string[10];
		altura:integer;
		peso:real;
		descripcion:string[20];
		zona:string[10];
	end;
	arc_dinosaurio=file of dinosaurio;
	
procedure leerDinosaurio(var d:dinosaurio);
begin
	writeln('Ingresar codigo');
	readln(d.codigo);
	if(d.codigo<>9999)then begin
		writeln('Ingresar tipo');
		readln(d.tipo);
		writeln('Ingresar altura');
		readln(d.altura);
		writeln('Ingresar peso');
		readln(d.peso);
		writeln('Ingresar descripcion');
		readln(d.descripcion);
		writeln('Ingresar zona');
		readln(d.zona);
	end;
end;
	
procedure crearArchivo(var a:arc_dinosaurio);
var
	d:dinosaurio;
begin
	rewrite(a);
	writeln();
	d.codigo:=0;
	write(a,d);
	leerDinosaurio(d);
	while(d.codigo<>9999)do begin
		write(a,d);
		leerDinosaurio(d);
	end;
	close(a);
end;

function existeDinosaurio(var a:arc_dinosaurio; d:dinosaurio):integer;
var
	i:integer;
	aux:dinosaurio;
begin
	i:=-1;
	seek(a,0);
	while(not eof(a) and (i=-1))do begin
		read(a,aux);
		if(aux.codigo=d.codigo)then 
			i:=filePos(a)-1;
	end;
	existeDinosaurio:=i;
end;
	
procedure agregarDinosaurios(var a:arc_dinosaurio;d:dinosaurio);
var
	i:integer;
	aux:dinosaurio;
begin
	reset(a);
	if(not eof(a))then begin
		read(a,aux);
		i:=existeDinosaurio(a,d);
		seek(a,0);
		if(i=-1)then
			if(aux.codigo=0)then begin
				seek(a,fileSize(a));
				write(a,d);
			end
			else begin
				seek(a,aux.codigo*-1);
				read(a,aux);
				seek(a,filePos(a)-1);
				write(a,d);
				seek(a,0);
				write(a,aux);
			end
		else
			writeln('El dinosaurio con el codigo: ',d.codigo,' ya existe. ');
	end
	else
		writeln('El archivo esta vacio');
	close(a);
end;
	
procedure bajaDinosaurio(var a:arc_dinosaurio; d:dinosaurio);
var
	i:integer;
	tmp:dinosaurio;
begin
	i:=existeDinosaurio(a,d);
	if(i<>-1)then begin
		//agarrar el primer elemento con el indice
		seek(a,0);
		read(a,tmp);

		//obtengo el indice del ultimo elemento eliminado hasta el momento
		d.codigo:=tmp.codigo;
		tmp.codigo:=i*-1;
		
		//cambio el indice de la cabecera por la ubicacion del elemento a eliminar
		seek(a,0);
		write(a,tmp);

		//efectuo la baja cambiando el indice actual por el indice anterior de la cabecera 
		seek(a,i);
		write(a,d);
	end
	else
		writeln('El dinosaurio a eliminar no existe');
end;

procedure bajaDinosaurio(var a:arc_dinosaurio);
var
	d:dinosaurio;
begin
	reset(a);
	if(not eof(a))then begin
		repeat
			writeln('Ingresar dinosaurio a eliminar: ');
			leerDinosaurio(d);
			bajaDinosaurio(a,d);
		until(d.codigo=9999);
	end
	else
		writeln('El archivo esta vacio');
	close(a);
end;

procedure imprimirContenido(var a:arc_dinosaurio);
var
	d:dinosaurio;
begin
	reset(a);
	while(not eof(a))do begin
		read(a,d);
		writeln('codigo: ',d.codigo);
		writeln('tipo: ',d.tipo);
		writeln('altura: ',d.altura);
		writeln('peso: ',d.peso);
		writeln('descripcion:',d.descripcion);
		writeln('zona: ',d.zona);
	end;
	close(a);
end;
	
procedure extraerContenido(var a:arc_dinosaurio; var t:Text);
var
	d:dinosaurio;
begin
	reset(a);
	rewrite(t);
	while(not eof(a))do begin
		read(a,d);
		writeln(t,d.codigo,d.tipo,d.altura,d.peso,d.descripcion,d.zona);
	end;
	close(t);
	close(a);
end;
	
var
	a:arc_dinosaurio;
	opcion:integer;
	t:Text;
	d:dinosaurio;
begin
	writeln('Iniciando programa...');
	assign(a,'arc.dat');
	assign(t,'arc_text.txt');
	//crearArchivo(a);
	repeat 
		writeln();
		writeln('Ingrese opcion:');
		writeln('opcion 1: agregar dinosaurio');
		writeln('opcion 2: baja dinosaurio');
		writeln('opcion 3: imprimir contenido');
		writeln('opcion 4: extraer contenido en archivo de texto');
		writeln('opcion 0: terminar ejecucion');
		readln(opcion);
		case(opcion)of
			1:begin
				writeln();
				leerDinosaurio(d);
				agregarDinosaurios(a,d);
			end;
			2:bajaDinosaurio(a);
			3:imprimirContenido(a);
			4:extraerContenido(a,t);
		else
			writeln('Opcion no valida, ingrese nuevamente..');
		end;
	until(opcion=0);
end.
