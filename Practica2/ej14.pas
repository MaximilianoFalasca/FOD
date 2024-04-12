{
Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
}
program ej14;
const
	df=10;
	valorAlto=9999;
type 
	informacion = record
		codigoPcia:integer;
		nombrePcia:string[10];
		codigoLocalidad:integer;
		nombreLocalidad:string[10];
		viviendasLuz:integer;
		viviendas:integer;
		viviendasAgua:integer;
		viviendasSani:integer;
	end;
	info = file of informacion;
	detalle = array[1..df] of info;
	detalle_aux= array[1..df] of informacion;
	
procedure leerDatosDetalle(var i:informacion;var mes:integer);
begin
	writeln('Ingresar Mes');
	readln(mes);
	if(mes<=10)then begin
		writeln('Ingresar codigo de provincia');
		readln(i.codigoPcia);
		if(i.codigoPcia<>valorAlto)then begin
			writeln('Ingresar nombre de provincia');
			readln(i.nombrePcia);
			writeln('Ingresar codigo de localidad');
			readln(i.codigoLocalidad);
			writeln('Ingresar nombre de localidad');
			readln(i.nombreLocalidad);
			writeln('Ingresar viviendas con luz');
			readln(i.viviendasLuz);
			writeln('Ingresar viviendas construidas');
			readln(i.viviendas);
			writeln('Ingresar viviendas con agua');
			readln(i.viviendasAgua);
			writeln('Ingresar viviendas con sanitarios');
			readln(i.viviendasSani);
		end;
	end;
end;
	
procedure crearArchivoDetalle(var d:detalle);
var
	mes:integer;
	i:informacion;
begin
	for mes:=1 to df do
		rewrite(d[mes]);
	writeln('corta con codigo: 9999');
	leerDatosDetalle(i,mes);
	while((mes<=10)and(i.codigoPcia<>valorAlto))do begin
		write(d[mes],i);
		leerDatosDetalle(i,mes);
	end;
	for mes:=1 to df do
		close(d[mes]);
end;

procedure leerDatosMaestro(var i:informacion);
begin
	writeln('Ingresar codigo de provincia');
	readln(i.codigoPcia);
	if(i.codigoPcia<>valorAlto)then begin
		writeln('Ingresar nombre de provincia');
		readln(i.nombrePcia);
		writeln('Ingresar codigo de localidad');
		readln(i.codigoLocalidad);
		writeln('Ingresar nombre de localidad');
		readln(i.nombreLocalidad);
		writeln('Ingresar viviendas sin luz');
		readln(i.viviendasLuz);
		writeln('Ingresar viviendas con chapa');
		readln(i.viviendas);
		writeln('Ingresar viviendas sin agua');
		readln(i.viviendasAgua);
		writeln('Ingresar viviendas sin sanitarios');
		readln(i.viviendasSani);
	end;
end;
	
procedure crearArchivoMaestro(var m:info);
var
	i:informacion;
begin
	rewrite(m);
	writeln('corta con codigo: 9999');
	leerDatosMaestro(i);
	while(i.codigoPcia<>valorAlto)do begin
		write(m,i);
		leerDatosMaestro(i);
	end;
	close(m);
end;
	
procedure leer(var i:info;var min:informacion);
begin
	if not eof(i)then
		read(i,min)
	else
		min.codigoPcia:=valorAlto;
end;
	
procedure minimo(var d:detalle;var aux:detalle_aux;var min:informacion);
var
	i,pos:integer;
begin
	writeln('Minimo');
	min.codigoPcia:=valorAlto;
	for i:=1 to df do begin
		writeln('i: ',i,' aux[i].codigoPcia: ',aux[i].codigoPcia);
		if(aux[i].codigoPcia<min.codigoPcia)then begin
			writeln('entre');
			pos:=i;
			min:=aux[i];
		end;
	end;
	if(min.codigoPcia<>valorAlto)then begin
		leer(d[pos],aux[pos]);
		writeln('if min.codigoPcia:',min.codigoPcia);
	end;
end;
	
procedure procesarDatos(var m:info;var d:detalle);
var
	i:integer;
	min,mae:informacion;
	aux:detalle_aux;
begin
	reset(m);
	for i:=1 to df do begin
		reset(d[i]);
		leer(d[i],aux[i]);
		writeln('i: ',i,' aux[i].codigoPcia: ',aux[i].codigoPcia);
	end;
	minimo(d,aux,min);
	read(m,mae);
	writeln('min.codigoPcia:',min.codigoPcia);
	while(min.codigoPcia<>valorAlto)do begin
		while(mae.codigoPcia<>min.codigoPcia)do
			read(m,mae);
		writeln('b');
		while((min.codigoPcia<>valorAlto)and(mae.codigoPcia=min.codigoPcia))do begin
			writeln('mae.viviendasLuz:',mae.viviendasLuz);
			mae.viviendasLuz:=mae.viviendasLuz-min.viviendasLuz;
			writeln('mae.viviendasLuz:',mae.viviendasLuz);
			
			writeln('mae.viviendas:',mae.viviendas);
			mae.viviendas:=mae.viviendas-min.viviendas;
			writeln('mae.viviendasLuz:',mae.viviendasLuz);
			
			writeln('mae.viviendasAgua:',mae.viviendasAgua);
			mae.viviendasAgua:=mae.viviendasAgua-min.viviendasAgua;
			writeln('mae.viviendasAgua:',mae.viviendasAgua);
			
			writeln('mae.viviendasSani:',mae.viviendasSani);
			mae.viviendasSani:=mae.viviendasSani-min.viviendasSani;
			writeln('mae.viviendasSani:',mae.viviendasSani);
			
			minimo(d,aux,min);
		end;
		seek(m,filePos(m)-1);	
		write(m,mae);
	end;
	for i:=1 to df do
		close(d[i]);
	close(m);
end;
	
procedure informar(i:informacion);
begin
	writeln('codigo provincia: ',i.codigoPcia);
	writeln('viviendas sin luz: ',i.viviendasLuz);
	writeln('viviendas hechas de chapa: ',i.viviendasLuz);
	writeln('viviendas sin agua: ',i.viviendasLuz);
	writeln('viviendas sin sanitarios: ',i.viviendasLuz);
end;
	
procedure informarMaestro(var m:info); 
var
	i:informacion;
begin
	reset(m);
	while not eof(m) do begin
		read(m,i);
		informar(i);
	end;
	close(m);
end;

procedure informarDetalle(var d:detalle); 
var
	info:informacion;
	i:integer;
begin
	for i:=1 to df do begin
		reset(d[i]);
		if not eof(d[i])then begin
			read(d[i],info);
			writeln('Informando Detalle ',i,': ');
			informar(info);
		end;
		close(d[i]);
	end;
end;
	
var
	m:info;
	d:detalle;
	i:integer;
	s:string;
begin
	for i:=1 to df do begin
		Str(i,s);
		assign(d[i],'ej14Detalle'+s+'.dat');
	end;
	assign(m,'ej14Mestro.dat');
	crearArchivoDetalle(d);
	crearArchivoMaestro(m);
	writeln('Informando Detalles: ');
	informarDetalle(d);
	writeln('Informando Maestro: ');
	informarMaestro(m);
	procesarDatos(m,d);
	writeln('Informando Detalles: ');
	informarDetalle(d);
	writeln('Informando Maestro: ');
	informarMaestro(m);
end.
