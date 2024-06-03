program parcial;
const
	valorAlto=9999;
type
	informacion=record
		anio:integer;
		mes:integer;
		dia:integer;
		idUsuario:integer;
		tiempo:integer;
	end;
	arc=file of informacion;
	
procedure leerInformacion(var i:informacion);
begin
	writeln('Ingresar el anio');
	readln(i.anio);
	if(i.anio<>valorAlto)then begin
		writeln('Ingresar el mes');
		readln(i.mes);
		writeln('Ingresar el dia');
		readln(i.dia);
		writeln('Ingresar el idUsuario');
		readln(i.idUsuario);
		writeln('Ingresar el tiempo');
		readln(i.tiempo);
	end;
end;
	
procedure crearArchivo(var a:arc);
var
	i:informacion;
begin
	rewrite(a);
	leerInformacion(i);
	while(i.anio<>valorAlto)do begin
		write(a,i);
		leerInformacion(i);
	end;
	close(a);
end;
	
procedure leer(var a:arc;var i:informacion);
begin
	if(not eof(a))then
		read(a,i)
	else
		i.anio:=valorAlto;
end;

procedure informe(var a:arc);
var
	i:informacion;
	anioRequest,mesActual,diaActual,tiempoTotalDia,tiempoTotalMes,tiempoTotalAnio:integer;
	pase:boolean;
begin
	reset(a);
	writeln('Ingrese el año por el cual va a realizar el informe');
	read(anioRequest);
	pase:=false;
	leer(a,i);
	if(i.anio<>valorAlto)then begin
		while((i.anio<>valorAlto)and(not pase))do 
			if(i.anio<anioRequest)then
				leer(a,i)
			else
				pase:=true;
		if(i.anio=anioRequest)then begin
			writeln('año: ',i.anio);
			tiempoTotalAnio:=0;
			while(i.anio=anioRequest)do begin
				writeln('mes: ',i.mes);
				mesActual:=i.mes;
				tiempoTotalMes:=0;
				while((i.anio<>valorAlto)and(i.anio=anioRequest)and(i.mes=mesActual))do begin
					writeln('dia: ',i.dia);
					diaActual:=i.dia;
					tiempoTotalDia:=0;
					while((i.anio<>valorAlto)and(i.anio=anioRequest)and(i.mes=mesActual)and(diaActual=i.dia))do begin
						writeln(' idUsuario ',i.idUsuario,' Tiempo Total de acceso dia ',diaActual,' mes ',mesActual);
						writeln(i.tiempo);
						tiempoTotalDia:=tiempoTotalDia+i.tiempo;
						leer(a,i);
					end;
					writeln(' Tiempo Total de acceso dia ',diaActual,' mes ',mesActual);
					writeln(tiempoTotalDia);
					tiempoTotalMes:=tiempoTotalMes+tiempoTotalDia;
				end;
				writeln('Tiempo Total de acceso mes ',mesActual);
				writeln(tiempoTotalMes);
				tiempoTotalAnio:=tiempoTotalAnio+tiempoTotalMes;
			end;
			writeln('Tiempo Total de acceso año ',anioRequest);
			writeln(tiempoTotalAnio);
		end
		else
			writeln('Año no encontrado');
	end;
	close(a);
end;

var
	a:arc;
begin
	assign(a,'archivo.dat');
	//crearArchivo(a);
	informe(a);
end.
