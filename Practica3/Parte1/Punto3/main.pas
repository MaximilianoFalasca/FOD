{
    Realizar un programa que genere un archivo de novelas filmadas durante el presente
    año. De cada novela se registra: código, género, nombre, duración, director y precio.
    El programa debe presentar un menú con las siguientes opciones:
    a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
    utiliza la técnica de lista invertida para recuperar espacio libre en el
    archivo. Para ello, durante la creación del archivo, en el primer registro del
    mismo se debe almacenar la cabecera de la lista. Es decir un registro
    ficticio, inicializando con el valor cero (0) el campo correspondiente al
    código de novela, el cual indica que no hay espacio libre dentro del
    archivo.
    b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
    inciso a., se utiliza lista invertida para recuperación de espacio. En
    particular, para el campo de ´enlace´ de la lista, se debe especificar los
    números de registro referenciados con signo negativo, (utilice el código de
    novela como enlace).Una vez abierto el archivo, brindar operaciones para:
    i. Dar de alta una novela leyendo la información desde teclado. Para
    esta operación, en caso de ser posible, deberá recuperarse el
    espacio libre. Es decir, si en el campo correspondiente al código de
    novela del registro cabecera hay un valor negativo, por ejemplo -5,
    se debe leer el registro en la posición 5, copiarlo en la posición 0
    (actualizar la lista de espacio libre) y grabar el nuevo registro en la
    posición 5. Con el valor 0 (cero) en el registro cabecera se indica
    que no hay espacio libre.
    ii. Modificar los datos de una novela leyendo la información desde
    teclado. El código de novela no puede ser modificado.
    iii. Eliminar una novela cuyo código es ingresado por teclado. Por
    ejemplo, si se da de baja un registro en la posición 8, en el campo
    código de novela del registro cabecera deberá figurar -8, y en el
    registro en la posición 8 debe copiarse el antiguo registro cabecera.
    c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
    representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
    NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
    proporcionado por el usuario
}
program ej3;
const   
    valorAlto=9999;
type
    novela=record
        codigo:integer;
        genero:string[10];
        nombre:string[10];
        duracion:integer;
        director:string[10];
        precio:real;
    end;
    archivo=file of novela;

procedure leerDato(var n:novela);
begin
    writeln('Ingresar codigo de la novela');
    readln(n.codigo);
    if(n.codigo<>valorAlto)then begin
        writeln('Ingresar genero de la novela');
        readln(n.genero);
        writeln('Ingresar nombre de la novela');
        readln(n.nombre);
        writeln('Ingresar duracion de la novela');
        readln(n.duracion);
        writeln('Ingresar director de la novela');
        readln(n.director);
        writeln('Ingresar precio de la novela');
        readln(n.precio);
    end;
end;

procedure crearArchivo(var a:archivo);
var 
    n:novela;
begin
    rewrite(a);
    writeln('El ingreso de datos termina con el codigo de novela 9999');
    n.codigo:=0;
    while(n.codigo<>valorAlto)do begin
        write(a,n);
        leerDato(n);
    end;
    close(a);
end;

procedure darAltaNovela(var a:archivo);
var 
    n,novelaAux:novela;
begin
    reset(a);
    leerDato(n);
    while(n.codigo=valorAlto)do begin
        writeln('codigo no valido, ingrese nuevamente los datos:');
        leerDato(n);
    end;
    read(a,novelaAux);
    //case(novelaAux.codigo)of
    if(novelaAux.codigo<0)then begin
        seek(a,-novelaAux.codigo);
        read(a,novelaAux);
        seek(a,filePos(a)-1);
        write(a,n);
        seek(a,0);
        write(a,novelaAux);
    end;
    else begin
        seek(a,filePos(a));
        write(a,n);
    end;
    close(a);
end;

procedure mantenerArchivo(var a:archivo);
var
    opcion:integer;
begin
    repeat
        writeln('Ingresar Opcion:');
        writeln('1: dar de alta una novela');
        writeln('2: modificar datos de una novela');
        writeln('3: eliminar novela');
        writeln('0: Terminar la ejecucion del proceso');
        readln(opcion);
        case (opcion) of
            1: darAltaNovela(a);
            2: modificarNovela(a);
            3: eliminarNovela(a);
            0: writeln('Terminando la ejecucion del proceso...');
        end;
        else
            writeln('Opcion no valida, ingrese nuevamente');
    until (opcion=0);
end;

var 
    a:archivo;
    nombre_archivo:string[10];
    opcion:integer;
begin
    writeln('Ingresar nombre del archivo');
    readln(nombre_archivo);
    assign(a,nombre_archivo);
    repeat
        writeln('Ingresar Opcion:');
        writeln('1: crear archivo y cargarlo con datos');
        writeln('2: abrir archivo existente y mantener');
        writeln('3: listar en archivo de texto todas las novelas');
        writeln('0: Terminar la ejecucion del programa');
        readln(opcion);
        case (opcion) of
            1: crearArchivo(a);
            2: mantenerArchivo(a);
            3: listarArchivo(a);
            0: writeln('Terminando la ejecucion del programa...');
        else
            writeln('Opcion no valida, ingrese nuevamente');
    until (opcion=0);
end.    
