program parcial;
const
	valorAlto=9999;
type
	informacion= record
		nombre_sistema_operativo:string[10];
		cantidad_instalaciones:integer;
		es_de_codigo_abierto:boolean;
		tipo_licencia:string[3];
	end;
	arc=file of informacion;

procedure leerInformacion(var i:informacion);
var
	es:string;
begin
	writeln('Ingresar cantidad de instalaciones');
	readln(i.cantidad_instalaciones);
	if(i.cantidad_instalaciones<>valorAlto)then begin
		writeln('Ingresar nombre_sistema_operativo');
		readln(i.nombre_sistema_operativo);
		writeln('Ingresar es_de_codigo_abierto');
		readln(es);
		if(es='true')then 
			i.es_de_codigo_abierto:=true
		else
			i.es_de_codigo_abierto:=false;
		writeln('Ingresar tipo_licencia');
		readln(i.tipo_licencia);
	end;
end;

procedure crearArchivo(var a:arc); 
var
	i:informacion;
begin
	rewrite(a);
	i.cantidad_instalaciones:=0;
	write(a,i);
	leerInformacion(i);
	while(i.cantidad_instalaciones<>valorAlto)do begin
		write(a,i);
		leerInformacion(i);
	end;
	close(a);
end;

function obtenerRegistro():informacion;
var
	i:informacion;
begin
	leerInformacion(i);
	obtenerRegistro:=i;
end;

function posArchivo(var a:arc;i:informacion):integer;
var
	pos:integer;
	aux:informacion;
begin
	pos:=-1;
	seek(a,0);
	while((not eof(a)) and (pos=-1))do begin
		read(a,aux);
		if(aux.nombre_sistema_operativo=i.nombre_sistema_operativo)then
			pos:=filePos(a)-1;
	end;
	posArchivo:=pos;
end;

procedure altaSistema(var a:arc;i:informacion);
var
	aux:informacion;
	pos:integer;
begin
	reset(a);
	if(eof(a))then begin
		aux.cantidad_instalaciones:=0;
		write(a,aux);
		write(a,i);
	end
	else begin
		pos:=posArchivo(a,i);
		seek(a,0);
		if(pos=-1)then begin
			read(a,aux);
			if(aux.cantidad_instalaciones=0)then begin
				seek(a,fileSize(a));
				write(a,i);
			end
			else begin
				read(a,aux);
				aux.cantidad_instalaciones:=aux.cantidad_instalaciones*-1;
				seek(a,aux.cantidad_instalaciones);
				read(a,aux);
				seek(a,filePos(a)-1);
				write(a,i);
				seek(a,0);
				write(a,aux);
			end;
		end
		else begin
			writeln('El sistema ya existe en el archivo.');
		end;
	end;
	close(a);
end;

procedure bajaSistema(var a:arc;i:informacion);
var	
	aux:informacion;
	pos:integer;
begin
	reset(a);
	if(not eof(a))then begin
		pos:=posArchivo(a,i);
		if(pos<>-1)then begin
			//agarramos la pos de la cabecera
			seek(a,0);
			read(a,aux);
			
			//vamos donde el elemento a eliminar
			seek(a,pos);
			//cambiamos la cant por el pos de la cabecera
			write(a,aux);
			
			//vamos a la cabecera y le insertamos la pos nueva 
			aux.cantidad_instalaciones:=pos*-1;
			seek(a,0);
			read(a,aux);
		end
		else 
			writeln('El archivo no existe en el sistema');
	end
	else 
		writeln('El archivo esta vacio.');
	close(a);
end;

procedure leer(var a:arc;var i:informacion);
begin
	if(not eof(a))then
		read(a,i)
	else
		i.cantidad_instalaciones:=valorAlto;
end;

procedure listarInformacion(var a:arc);
var
	i:informacion;
begin
	reset(a);
	writeln();
	leer(a,i);
	while(i.cantidad_instalaciones<>valorAlto)do begin
		writeln('cantidad de instalaciones: ',i.cantidad_instalaciones);
		writeln('nombre_sistema_operativo:',i.nombre_sistema_operativo);
		writeln('es_de_codigo_abierto:',i.es_de_codigo_abierto);
		writeln('tipo_licencia: ',i.tipo_licencia);
		writeln();
		leer(a,i);
	end;
	close(a);
end;

var	
	a:arc;
	opcion:integer;
begin
	assign(a,'logsall.dat');
	crearArchivo(a);
	repeat
		writeln('Ingresar opcion');
		writeln('opcion 1: alta sistema operativo');
		writeln('opcion 2: baja');
		writeln('opcion 3: listar');
		writeln('opcion 0: terminar proceso');
		readln(opcion);
		case(opcion)of
			1:altaSistema(a,obtenerRegistro());
			2:bajaSistema(a,obtenerRegistro());
			3:listarInformacion(a);
		else
			if(opcion<>0)then
				writeln('Opcion invalida');
		end;
	until (opcion=0);
end.
