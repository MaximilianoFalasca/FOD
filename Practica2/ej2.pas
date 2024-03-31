program ej2;
const
	valorAlto=9999;
type
	alumno = record
		cod:integer;
		apellido:string[20];
		nombre:string[20];
		cursadas:integer;
		aprobadas:integer;
	end;
	alumnoDetalle=record
		cod:integer;
		aproboFinal:boolean;
	end;
	archivoAl=file of alumno;
	archivoDe=file of alumnoDetalle;
var
	txt:Text;
	al:archivoAl;
	de:archivoDe;
	nombreArchivo:String[10];
	
procedure ingresarDatosAlumnos(var al:archivoAl);
var
	tmp:alumno;
begin
	writeln('Finaliza con cod -1');
	writeln('Ingresar codigo de alumno');
	readln(tmp.cod);
	while(tmp.cod<>-1)do begin
		writeln('Ingresar apellido');
		readln(tmp.apellido);
		writeln('Ingresar nombre');
		readln(tmp.nombre);
		tmp.cursadas:=0;
		tmp.aprobadas:=0;
		write(al,tmp);
		writeln('Ingresar codigo de alumno');
		readln(tmp.cod);
	end;
end;

procedure ingresarDatosDetalle(var de:archivoDe);
var
	tmp:alumnoDetalle;
	num:integer;
begin
	writeln('Finaliza con cod -1');
	writeln('Ingresar codigo de alumno');
	readln(tmp.cod);
	while(tmp.cod<>-1)do begin
		writeln('Ingresar si aprobo la cursada o el final');
		writeln('1 si aprobo final, 2 si aprobo cursada');
		readln(num);
		if(num=1)then 
			tmp.aproboFinal:=true
		else
			tmp.aproboFinal:=false;
		write(de,tmp);
		writeln('Ingresar codigo de alumno');
		readln(tmp.cod);
	end;
end;
	
procedure ingresarDatos(var al:archivoAl;var de:archivoDe);
begin
	//.dat
	rewrite(al);
	rewrite(de);
	writeln('Ingresar datos de los alumnos:');
	ingresarDatosAlumnos(al);
	writeln('Ingresando datos de los detalles:');
	ingresarDatosDetalle(de);
	close(de);
	close(al);
end;

procedure leerDetalle(var de:archivoDe;var tmp:alumnoDetalle);
begin
	if not eof(de) then 
		read(de,tmp)
	else
		tmp.cod:=valorAlto;
end;

procedure actualizarMaestro(var al:archivoAl;var de:archivoDe);
var
	tmpDe:alumnoDetalle;
	tmpAl:alumno;
begin
	reset(al);
	reset(de);
	leerDetalle(de,tmpDe);
	while (tmpDe.cod<>valorAlto) do begin
		writeln('Entre');
		read(al,tmpAl);
		while((tmpDe.cod<>valorAlto)and(tmpDe.cod=tmpAl.cod))do begin
			writeln('tmpDe.aproboFinal: ',tmpDe.aproboFinal);
			if(tmpDe.aproboFinal)then begin
				if(tmpAl.cursadas>0)then
					tmpAl.cursadas:=tmpAl.cursadas-1;
				tmpAl.aprobadas:=tmpAl.aprobadas+1;
			end
			else
				tmpAl.cursadas:=tmpAl.cursadas+1;
			leerDetalle(de,tmpDe);
		end;
		seek(al,filePos(al)-1);
		write(al,tmpAl);
	end;
	close(de);
	close(al);
end;

procedure listar(var al:archivoAl;var txt:Text);
var
	nombre:string[10];
	tmp:alumno;
begin
	//.doc
	writeln('Ingresar nombre del archivo de texto');
	readln(nombre);
	assign(txt,nombre);
	rewrite(txt);
	reset(al);
	while not eof(al)do begin
		read(al,tmp);
		if(tmp.cursadas<tmp.aprobadas)then 
			writeln(txt,tmp.cod,' ',tmp.apellido,' ',tmp.nombre,' ',tmp.cursadas,' ',tmp.aprobadas);
	end;
	close(al);
	close(txt);
end;

procedure imprimir (var txt:Text);
var 
	tmp:string;
begin
	reset(txt);
	while not eof(txt)do begin
		readln(txt,tmp);
		writeln(tmp);
	end;
	close(txt);
end;

procedure imprimirDatos(var al:archivoAl;var de:archivoDe);
var
	tmp:alumno;
	d:alumnoDetalle;
begin
	reset(al);
	writeln('Imprimiendo Alumnos');
	while not eof(al)do begin
		read(al,tmp);
		writeln(tmp.cod,' ',tmp.apellido,' ',tmp.nombre,' ',tmp.cursadas,' ',tmp.aprobadas);
	end;
	close(al);
	reset(de);
	while not eof(de)do begin
		read(de,d);
		writeln(d.cod,' ',d.aproboFinal);
	end;
	close(de);
end;

begin
	writeln('Ingresar nombre del archivo alumnos');
	readln(nombreArchivo);
	assign(al,nombreArchivo);
	writeln('Ingresar nombre del archivo detalle');
	readln(nombreArchivo);
	assign(de,nombreArchivo);
	writeln('Ingresando datos');
	ingresarDatos(al,de);
	writeln('Imprimierndo datos');
	imprimirDatos(al,de);
	writeln('Actualizando archivo maestro');
	actualizarMaestro(al,de);
	writeln('Imprimierndo datos');
	imprimirDatos(al,de);
	writeln('Listando datos');
	listar(al,txt);
	writeln('Imprimiendo datos');
	imprimir(txt);
end.
