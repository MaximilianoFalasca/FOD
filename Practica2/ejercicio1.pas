program ej1;
const 
	valorAlto=9999;

type
  comision = record
    cod: integer;
    nombre: string[20];
    monto: real;
  end;

  descripcion = file of comision;
var
  arc_desc: descripcion;
  arc_maes: descripcion;

procedure insertarOrdenado(var arc_desc: descripcion; emp: comision);
var
  emp1, emp2: comision;
begin
  emp1.cod := 0; // Inicialización de emp1
  emp1.nombre := '';
  emp1.monto := 0.0;

  seek(arc_desc, 0);
  // Buscar la posición de inserción adecuada
  while (not eof(arc_desc)) and (emp.cod > emp1.cod) do
    read(arc_desc, emp1);

  // Realizar desplazamiento de registros
  while not eof(arc_desc) do
  begin
    read(arc_desc, emp2);
    write(arc_desc, emp1);
    emp1 := emp2;
  end;

  // Escribir el nuevo registro en la posición adecuada
  seek(arc_desc, filePos(arc_desc));
  write(arc_desc, emp);
end;

procedure crearArcDesc(var arc_desc: descripcion);
var
  emp: comision;
begin
  rewrite(arc_desc);
  writeln('Ingresar codigo de empleado:');
  readln(emp.cod);
  while (emp.cod <> -1) do
  begin
    writeln('Ingresar nombre:');
    readln(emp.nombre);
    writeln('Ingresar monto (real):');
    readln(emp.monto);
    insertarOrdenado(arc_desc, emp);
    writeln('Ingresar codigo de empleado:');
    readln(emp.cod);
  end;
  close(arc_desc);
end;

procedure imprimirArc(var arc_desc: descripcion);
var
  emp: comision;
begin
  reset(arc_desc);
  while not eof(arc_desc) do
  begin
    read(arc_desc, emp);
    writeln('codigo de empleado: ', emp.cod, ' nombre: ', emp.nombre, ' monto: ', emp.monto:0:2);
  end;
  close(arc_desc);
end;

procedure leer(var arc_desc:descripcion;var dato:comision);
begin
	if not eof(arc_desc) then 
		read(arc_desc,dato)
	else
		dato.cod:=valorAlto;
end;

procedure comprimirArc(var arc_maes:descripcion;var arc_desc:descripcion);
var
	emp:comision;
	total:real;
	num:integer;
begin
	reset(arc_desc);
	rewrite(arc_maes);
	leer(arc_desc,emp);
	total:=0;
	while (emp.cod<>valorAlto) do begin
		writeln('Codigo:',emp.cod);
		num:=emp.cod;
		while (emp.cod=num) do begin
			total:=total+emp.monto;
			leer(arc_desc,emp);
		end;
	end;
	close(arc_maes);
	close(arc_desc);
end;

begin
  assign(arc_desc, 'descripcion_ej1.dat');
  assign(arc_maes, 'maestro_ej1.dat');
  crearArcDesc(arc_desc);
  writeln('Datos ingresados:');
  imprimirArc(arc_desc);
  writeln('Comprimiendo..');
  comprimirArc(arc_desc,arc_maes);
  writeln('Archivos comprimidos..');
  imprimirArc(arc_maes);
end.
