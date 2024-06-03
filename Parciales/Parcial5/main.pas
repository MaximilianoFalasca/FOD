program parcial;
const
	valorAlto=9999;
type 
	informacion=record
		numeroUsuario:integer;
		nombreUsuario:string[10];
		nombre:string[10];
		apellido:string[10];
		cantidadMails:integer;
	end;
	
	detalle=record
		numeroUsuario:integer;
		cuentaDestino:string[10];
		cuerpoMensaje:string[30];
	end;
	maestro=file of informacion;
	arc_detalle=file of detalle;

procedure leer(var d:arc_detalle; var aux:detalle);
begin
	if(not eof(d))then
		read(d,aux)
	else
		aux.numeroUsuario:=valorAlto;
end;

procedure incisoA(var m:maestro;var d:arc_detalle);
var
	tmp:informacion;
	aux:detalle;
	usuarioActual:integer;
begin
	reset(m);
	reset(d);
	leer(d,aux);
	if(aux.numeroUsuario<>valorAlto)then begin
		read(m,tmp);
		while(aux.numeroUsuario<>valorAlto)do begin
			usuarioActual:=aux.numeroUsuario;
			while(tmp.numeroUsuario<>aux.numeroUsuario)do 
				read(m,tmp);
			while((aux.numeroUsuario<>valorAlto) and (usuarioActual=aux.numeroUsuario))do begin
				tmp.cantidadMails:=tmp.cantidadMails+1;
				leer(d,aux);
			end;
			seek(m,filePos(m)-1);
			write(m,tmp);
		end;
	end;
	close(d);
	close(m);
end;

procedure leerMaestro(var m:maestro;var tmp:informacion);
begin
	if(not eof(m))then
		read(m,tmp)
	else
		tmp.numeroUsuario:=valorAlto;
end;

procedure incisoB(var m:maestro);
var
	tmp:informacion;
	usuarioActual:integer;
begin
	reset(m);
	leerMaestro(m,tmp);
	while(tmp.numeroUsuario<>valorAlto)do begin
		usuarioActual:=tmp.numeroUsuario;
		while((tmp.numeroUsuario<>valorAlto)and(tmp.numeroUsuario=usuarioActual))do begin
			writeln('numero de usuario: ',usuarioActual,' nombre de usuario: ',tmp.nombreUsuario,' cantidad de mensajes enviados: ',tmp.cantidadMails);
			leerMaestro(m,tmp);
		end;
	end;
	close(m);
end;

var
	m:maestro;
	d:arc_detalle;
	opcion:integer;
begin
	assign(m,'var/log/logsmall.dat');
	assign(d,'6junio2017.dat');
	//suponemos que los archivos estan creados y llenos de datos.
	repeat
		writeln('Ingrese la opcion: ');
		writeln('opcion1: IncisoA');
		writeln('opcion2: IncisoB');
		writeln('opcion 0: terminar la ejecucion del programa');
		readln(opcion);
		case(opcion)of
			1:incisoA(m,d);
			2:incisoB(m);
		else
			if(opcion<>0)then
				writeln('opcion incorrecta, volver a ingresar');
		end;
	until(opcion=0);
end.
