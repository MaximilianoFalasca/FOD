{
    Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
    incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
    cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
    archivo debe ser proporcionado por el usuario desde teclado.

    Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
    agregándole una opción para realizar bajas copiando el último registro del archivo en
    la posición del registro a borrar y luego truncando el archivo en la posición del último
    registro de forma tal de evitar duplicados.
}
program ej1;
type    
    archivo=file of integer;

procedure ingresarDatos(var a:archivo);
var 
    dato:integer;
begin
    rewrite(a);
    writeln('El ingreso de datos termina al ingresar el numero 30000');
    writeln('Ingresar un numero:');
    readln(dato);
    while(dato<>30000)do begin
        write(a,dato);
        writeln('Ingresar un numero:');
        readln(dato);
    end;
    close(a);
end;

procedure eliminarDato(var a:archivo);
var 
    datoAEliminar,datoAux,datoUltimo:integer;
begin
    reset(a);
    writeln('Ingresar el dato a eliminar');
    readln(datoAEliminar);
    seek(a,fileSize(a));
    read(a,datoUltimo);
    truncate(a);
    seek(a,0);
    datoAux:=30000;
    while((not eof (a)) and (datoAux<>datoAEliminar))do 
        read(a,datoAux);
    if eof(a) then
        writeln('no existe el archivo a eliminar')
    else begin
        seek(a,filePos(a)-1);
        write(a,datoUltimo);
    end;
    close(a);
end;

var
    a:archivo;
    nombre_archivo:string;
    opcion:integer;
begin
    writeln('Ingresar nombre del archivo a crear');
    readln(nombre_archivo);
    assign(a,nombre_archivo);
    opcion:=9;
    writeln('Opcion 1: Ingresar dato');
    writeln('Opcion 2: Eliminar dato');
    writeln('Opcion 0: Salir del programa');
    while (opcion<>0) do begin
        writeln('Ingresar opcion: ');
        readln(opcion);
        case (opcion) of
            1:ingresarDatos(a);
            2: eliminarDato(a);
        else
            writeln('Opcion no valida');
    end;
end.