program parcial;
type
	empleado = record
		dni:integer;
		nombre:string[20];
		apellido:string[20];
		edad:integer;
		domicilio:string[10];
		fechaMantenimiento:integer;
	end;
	arc_empleados=file of empleado;

procedure leerEmpleado(var e:empleado);
begin
	writeln('Ingresar dni');
	readln(e.dni);
	if(e.dni<>9999)then begin
		writeln('Ingresar nombre');
		readln(e.nombre);
		writeln('Ingresar apellido');
		readln(e.apellido);
		writeln('Ingresar edad');
		readln(e.edad);
		writeln('Ingresar domicilio');
		readln(e.domicilio);
		writeln('Ingresar fechaMantenimiento');
		readln(e.fechaMantenimiento);
	end;
end;

procedure crearArchivo(var a:arc_empleados);
var
	e:empleado;
begin
	rewrite(a);
	writeln('--------------------- crear Archivo -----------------------');
	e.dni:=0;
	write(a,e);
	leerEmpleado(e);
	while(e.dni<>9999)do begin
		write(a,e);
		leerEmpleado(e);
	end;
	writeln();
	close(a);
end;
	
function existeEmpleado(dni:integer;var a:arc_empleados):boolean;
var
	encontre:boolean;
	e:empleado;
begin
	encontre:=false;
	while((not eof(a)) and (not encontre))do begin
		read(a,e);
		if(dni=e.dni)then encontre:=true;
	end;
	existeEmpleado:=encontre;
end;	

procedure altaEmpleado(var a:arc_empleados);
var
	e,aux:empleado;
	i:integer;
begin
	reset(a);
	writeln('--------------------- Alta Empleado -----------------------');
	leerEmpleado(e);
	if(not existeEmpleado(e.dni,a))then begin
		seek(a,0);
		read(a,aux);
		if(aux.dni=0)then begin
			seek(a,fileSize(a));
			write(a,e);	
		end
		else begin
			i:=aux.dni*-1;
			seek(a,i);
			read(a,aux);
			seek(a,filePos(a)-1);
			write(a,e);
			seek(a,0);
			write(a,aux);
		end;
	end
	else
		writeln('El empleado ya existe');
	writeln();
	close(a);
end;

procedure ListarContenido(var a:arc_empleados);
var
	e:empleado;
begin
	reset(a);
	writeln('--------------------- Listar Contenido -----------------------');
	read(a,e);
	writeln('dni: ',e.dni);
	while(not eof(a))do begin
		read(a,e);
		writeln('dni: ',e.dni);
		writeln('nombre: ',e.nombre);
		writeln('apellido: ',e.apellido);
		writeln('edad: ',e.edad);
		writeln('domicilio: ',e.domicilio);
		writeln('fechaMantenimiento: ',e.fechaMantenimiento);
	end;
	writeln();
	close(a);
end;

procedure bajaEmpleado(var a:arc_empleados);
var
	dni,pos:integer;
	e,aux:empleado;
	encontre:boolean;
begin
	reset(a);
	writeln('--------------------- Baja Empleado -----------------------');
	writeln('Ingrese un dni');
	readln(dni);
	if(existeEmpleado(dni,a))then begin
		seek(a,0);
		read(a,aux);
		encontre:=false;
		while((not eof(a)) and (encontre=false))do begin
			read(a,e);
			if(dni=e.dni)then begin
				pos:=filePos(a)-1;
				seek(a,pos);
				write(a,aux);
				seek(a,0);
				aux.dni:=pos*-1;
				write(a,aux);
				encontre:=true;
			end;
		end;
	end
	else 
		writeln('El usuario con el dni: ',dni,' no existe.');
	writeln();
	close(a);
end;

var
	a:arc_empleados;
	nombre:string;
	dni:integer;
	opcion:integer;
begin
	//writeln('Ingresar nombre del archivo');
	//readln(nombre);
	nombre:='parcial.dat';
	assign(a,nombre);
	//crearArchivo(a);
	repeat
		writeln('Ingrese la opcion:');
		writeln('Opcion 1: Alta empleado');
		writeln('Opcion 2: Baja empleado');
		writeln('Opcion 3: Listar empleados');
		writeln('Opcion 4: existe empleado');
		writeln('Opcion 0: Terminar Ejecucion');
		readln(opcion);
		case(opcion)of
			1:altaEmpleado(a);
			2:bajaEmpleado(a);
			3:ListarContenido(a);
			4:begin
				reset(a);
				writeln('Ingresar dni');
				readln(dni);
				writeln(existeEmpleado(dni,a));
				close(a);
			end;
			0:writeln('Terminando la ejecucion del programa...');
		else
			writeln('Opcion no valida, ingrese nuevamente');
		end;
	until(opcion=0);
end.
