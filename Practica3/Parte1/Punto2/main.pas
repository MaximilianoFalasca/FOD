{
    Definir un programa que genere un archivo con registros de longitud fija conteniendo
    información de asistentes a un congreso a partir de la información obtenida por
    teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
    nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
    archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
    asistente inferior a 1000.
    Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
    String a su elección. Ejemplo: ‘@Saldaño’.
}
program ej2;
const
    valorAlto=9999;
type    
    informacion= record
        nroAsistente:integer;
        nombreCompleto:string[25];
        email:string[10];
        telefono:integer;
        dni:integer;
    end;
    archivo = file of informacion;

procedure leerDato(var d:informacion);
begin
    writeln('Ingresar nro de asistente');
    readln(d.nroAsistente);
    if(d.nroAsistente<>valorAlto)then begin
        writeln('Ingresar nombreCompleto');
        readln(d.nombreCompleto);
        writeln('Ingresar email');
        readln(d.email);
        writeln('Ingresar telefono');
        readln(d.telefono);
        writeln('Ingresar dni');
        readln(d.dni);
    end;
end;

procedure ingresarDatos(var a:archivo);
var 
    dato:informacion;
begin
    rewrite(a);
    writeln('El ingreso de datos termina al ingresar el nro de asistente 9999');
    leerDato(dato);
    while(dato.nroAsistente<>valorAlto)do begin
        write(a,dato);
        leerDato(dato);
    end;
    close(a);
end;    

procedure eliminarAsistentes(var a:archivo);
var
    datoAux:informacion;
begin
    reset(a);
    seek(a,0);
    while not eof(a) do begin
        read(a,datoAux);
        if(datoAux.nroAsistente<1000)then begin
            datoAux.nombreCompleto:='@'+datoAux.nombreCompleto;
            seek(a,filePos(a)-1);
            write(a,datoAux);
        end;
    end;
    close(a);
end;

var 
    a:archivo;
begin
    assign(a,'ej2.dat');
    ingresarDatos(a);
    eliminarAsistentes(a);
end.