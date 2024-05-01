{
Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}
program main;
type
	aves=record
		codigo:integer;
		nombre:string[10];
		familia:string[10];
		descripcion:string[10];
		zona:string[10];
	end;
	arc_ave=file of aves;
	
procedure leerDato(var a:aves);
begin
	writeln('Ingresar codigo');
	readln(a.codigo);
	if(a.codigo>=0)then begin
		writeln('Ingresar nombre');
		readln(a.nombre);
		writeln('Ingresar familia');
		readln(a.familia);
		writeln('Ingresar descripcion');
		readln(a.descripcion);
		writeln('Ingresar zona');
		readln(a.zona);
	end;
	writeln(); 
end;
	
procedure crearArchivo(var a:arc_ave);
var
	tmp:aves;
begin
	rewrite(a);
	leerDato(tmp);
	while(tmp.codigo>=0)do begin
		write(a,tmp);
		leerDato(tmp);
	end;
	close(a);
end;
	
procedure ListarContenido(var a:arc_ave);
var
	tmp:aves;
begin
	reset(a);
	while not eof(a) do begin
		read(a,tmp);
		writeln('codigo ',tmp.codigo);
		writeln('nombre ',tmp.nombre);
		writeln('familia ',tmp.familia);
		writeln('descripcion ',tmp.descripcion);
		writeln('zona ',tmp.zona);
	end;
	close(a);
	writeln();
end;

procedure bajaLogica(var a:arc_ave);
var
	tmp:longint;
	aux:aves;
begin
	reset(a);
	writeln('Ingresar codigo de ave a eliminar');
	readln(tmp);
	while(tmp<>50000)do begin
		read(a,aux);
		while(not eof(a) and (aux.codigo<>tmp))do
			read(a,aux);
		if(aux.codigo=tmp)then begin
			seek(a,filePos(a)-1);
			aux.codigo:=aux.codigo*-1;
			write(a,aux);
		end
		else 
			writeln('No se encontro el codigo a eliminar');
		seek(a,0);
		writeln('Ingresar codigo de ave a eliminar');
		readln(tmp);
	end;
	close(a);
end;

procedure comprimirArchivo(var a:arc_ave);
var
	tmp,ultimo:aves;
	i:integer;
begin
	reset(a);
	while not eof(a)do begin
		read(a,tmp);
		if(tmp.codigo<0)then begin
			i:=filePos(a)-1;
			seek(a,fileSize(a)-1);
			read(a,ultimo);
			if(filepos(a)-1 <> 0) then
                        while(ultimo.codigo < 0) do 
                            begin
                                seek(a, filesize(a)-1);
                                truncate(a);
                                seek(a, filesize(a)-1);
                                read(a, ultimo);
                            end;
			seek(a,fileSize(a)-1);
			truncate(a);
			seek(a,i);
			write(a,ultimo);
			writeln(filePos(a)-2);
			seek(a,filePos(a)-2);
		end;
	end;
	close(a);
end;
	
var
	a:arc_ave;
	opcion:integer;
begin
	assign(a,'archivo.dat');
	crearArchivo(a);
	repeat
		writeln('Ingrese la opcion:');
		writeln('Opcion 1: Listar contenido');
		writeln('Opcion 2: baja logica');
		writeln('Opcion 3: comprimir');
		writeln('Opcion 0: Terminar Ejecucion');
		readln(opcion);
		case(opcion)of
			1:ListarContenido(a);
			2:bajaLogica(a);
			3:comprimirArchivo(a);
			0:writeln('Terminando la ejecucion del programa...');
		else
			writeln('Opcion no valida, ingrese nuevamente');
		end;
	until(opcion=0);
end.
