{
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.
}
program main;
type
	localidad=record
		codigo:integer;
		numero:integer;
		cantidad:integer;
	end;
	arc_localidad=file of localidad;
	
procedure leerDato(var l:localidad);
begin
	writeln('Ingresar codigo de localidad');
	readln(l.codigo);
	if(l.codigo<>9999)then begin
		writeln('Ingresar numero de mesa');
		readln(l.numero);
		writeln('Ingresar cantidad de votaciones');
		readln(l.cantidad);
	end;
end;
	
procedure crearArchivo(var a:arc_localidad);
var
	l:localidad;
begin
	rewrite(a);
	leerDato(l);
	while(l.codigo<>9999)do begin
		write(a,l);
		leerDato(l);
	end;
	close(a);
end;

procedure CrearArchivoAux(var m:arc_localidad;var d:arc_localidad);
var
	auxM,auxD:localidad;
	cantidadTotal:integer;
begin
	cantidadTotal:=0;
	while not eof(m)do begin
		read(m,auxM);
		if not eof(d)then begin	
			read(d,auxD);
			while (not eof(d) and (auxD.codigo<>auxM.codigo)) do begin
				read(d,auxD);
			end;
			if(auxD.codigo=auxM.codigo)then	begin
				auxD.cantidad:=auxD.cantidad+auxM.cantidad
				seek(d,filePos(d)-1);
				write(d,auxD);
			end;
			else 
				write(d,auxM);
		end
		else
			write(d,auxM);
		cantidadTotal:=cantidadTotal+auxM.cantidad;
	end;
end;

procedure procesarArchivo(var a:arc_localidad);
var
	l:localidad;
	aux:arc_localidad;
begin
	reset(a);
	rewrite(aux);
	CrearArchivoAux(a,aux);
	listarInformacion(aux);
	close(aux);
	close(a);
end;
	
var
	maestro:arc_localidad;
begin
	assign(maestro,'maestro.dat');
	crearArchivo(maestro);
	procesarArchivo(maestro);
end;
