program punto3b;
	type 
		registro = record
			nro:integer;
			apellido:string[20];
			nombre:string[20];
			edad:integer;
			dni:longint;
		end;
		empleado= file of registro;
	var
		archivo: empleado;
		tmp: registro;

procedure listarPorNombre(var archivo: empleado;var tmp: registro);
var
	nombre:string;
begin
	writeln('Ingresar nombre o apellido');
	readln(nombre);
	writeln('-------------------------------------------------');
	writeln();
	while not eof(archivo)do begin
		read(archivo, tmp);
		if( tmp.nombre=nombre ) or ( tmp.apellido=nombre )then begin
			writeln('nro de empleado: ',tmp.nro);
			writeln('apellido: '+tmp.apellido);
			writeln('nombre: '+tmp.nombre);
			writeln('edad: ',tmp.edad);
			writeln('dni: ',tmp.dni);
			writeln();
			writeln('-------------------------------------------------');
			writeln();
		end;
	end;
end;

procedure listarPorEdad(var archivo: empleado; tmp: registro);
begin
	writeln('-------------------------------------------------');
	writeln();
	while not eof(archivo)do begin
		read(archivo, tmp);
		if( tmp.edad > 70 )then begin
			writeln('nro de empleado: ',tmp.nro);
			writeln('apellido: '+tmp.apellido);
			writeln('nombre: '+tmp.nombre);
			writeln('edad: ',tmp.edad);
			writeln('dni: ',tmp.dni);
			writeln();
			writeln('-------------------------------------------------');
			writeln();
		end;
	end;
end;

procedure listarEnFila(var archivo: empleado;var tmp: registro);
begin
	writeln('All Empleados:');
	while not eof(archivo)do begin
		read(archivo, tmp);
		writeln('nro de empleado: ',tmp.nro,' apellido: ',tmp.apellido,' nombre: ',tmp.nombre,' edad: ',tmp.edad,' dni: ',tmp.dni);
	end;
end;

procedure agregarUsuarios(var archivo:empleado; var tmp: registro);// falta posicioinar al final 
begin
	seek(archivo,0);
	writeln('-------------------------------');
	writeln('listando todos los empleados.');
	writeln('-------------------------------');
	listarEnFila(archivo,tmp);
	seek(archivo,filesize(archivo));
	writeln('Ingresar apellido (termina la ejecucion con apellido fin):');
	readln(tmp.apellido);
	while (tmp.apellido <> 'fin') do begin
		writeln('Ingresar nombre:');
		readln(tmp.nombre);
		writeln('Ingresar dni:');
		readln(tmp.dni);
		writeln(tmp.dni);
		writeln('Ingresar edad:');
		readln(tmp.edad);
		writeln('nro de empleado:');
		readln(tmp.nro);
		write(archivo,tmp);
		writeln('Ingresar apellido:');
		readln(tmp.apellido);
	end;
end;

procedure handleModAge(var archivo:empleado; var tmp:registro; nro:integer);
var
	edad:integer;
begin
	read(archivo,tmp);
	while not eof(archivo) and (tmp.nro <> nro)do begin
		read(archivo,tmp);
	end;
	if(tmp.nro = nro)then begin 
		writeln('Ingresar edad de la persona:',tmp.nombre);
		readln(edad);
		tmp.edad:=edad;
		seek(archivo, filepos(archivo)-1);
		write(archivo,tmp);
	end;
end;

procedure modificarEdad(var archivo: empleado; var tmp: registro);
var
	nro_empleado:integer;
begin
	seek(archivo,0);
	writeln('-------------------------------');
	writeln('listando todos los empleados.');
	writeln('-------------------------------');
	listarEnFila(archivo,tmp);
	seek(archivo,0);
	writeln('Ingresar nro de empleado (finaliza con nro -1)');
	readln(nro_empleado);
	while(nro_empleado <> -1)do begin
		seek(archivo,0);
		handleModAge(archivo,tmp,nro_empleado);
		writeln('nro de empleado:');
		readln(nro_empleado);
	end;
end;

procedure exportarArchivoTXT(var archivo: empleado; var tmp: registro);
var 
	archivo_tmp:Text;
begin
	seek(archivo,0);
	writeln('-------------------------------');
	writeln('listando todos los empleados.');
	writeln('-------------------------------');
	listarEnFila(archivo,tmp);
	seek(archivo,0);	
	assign(archivo_tmp,'todos_empleados.txt');
	rewrite(archivo_tmp);
	while not eof(archivo) do begin
		read(archivo,tmp);
		writeln(archivo_tmp,tmp.nro,' ',tmp.apellido,' ',tmp.nombre,' ',tmp.edad,' ',tmp.dni);
	end;
	close(archivo_tmp);
end;

begin
	writeln('-------------------------------');
	assign(archivo,'empleados.doc');
	writeln('-------------------------------');
	reset(archivo);
	seek(archivo,0);
	writeln('-------------------------------');
	writeln('listando todos los empleados.');
	writeln('-------------------------------');
	listarEnFila(archivo,tmp);
	seek(archivo,0);
	writeln('-------------------------------');
	writeln('listando los empleados segun nombre o apellido.');
	writeln('-------------------------------');
	listarPorNombre(archivo,tmp);
	seek(archivo,0);
	writeln('-------------------------------');
	writeln('listando los empleados a punto de jubilarse.');
	writeln('-------------------------------');
	seek(archivo,0);
	listarPorEdad(archivo,tmp);
	writeln('-------------------------------');
	writeln('Agregando empleados');
	writeln('-------------------------------');
	seek(archivo,0);
	agregarUsuarios(archivo,tmp);
	writeln('-------------------------------');
	writeln('Modificando edad de los empleados');
	writeln('-------------------------------');
	seek(archivo,0);
	modificarEdad(archivo,tmp);
	writeln('-------------------------------');
	writeln('Exportando archivo a todos_empleados.txt');
	writeln('-------------------------------');
	seek(archivo,0);
	exportarArchivoTXT(archivo,tmp);
	close(archivo);
end.
