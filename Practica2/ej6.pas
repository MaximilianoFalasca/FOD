{
Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log
}
program ej6;
const
	df = 5;
	valorAlto = 9999;
type
	detalle = record
		cod:integer;
		fecha:string;
		tiempo:integer;
	end;	
	maestro = record
		cod:integer;
		fecha:string;
		tiempo_total:integer;
	end;
	archivo_detalle=file of detalle;
	archivos_detalle=array[1..df] of archivo_detalle;
	archivos_detalle_txt=array[1..df] of Text;
	archivo_maestro=file of maestro;
	archivo_maestro_txt=file of maestro;
var
	d:archivos_detalle;
	m:archivo_maestro;
	i:integer;
	a,ubicacion:string;
	
procedure agregarDatosDetalle(var d: archivo_detalle; ubicacion: string);
var
  txt: Text;
  de: detalle;
  codUsuario: integer;
  fecha: string;
  tiempo: integer;
begin
  assign(txt, ubicacion + '.txt');
  reset(txt);
  rewrite(d);
  while not eof(txt) do begin
    readln(txt, codUsuario, tiempo, fecha);
    // Escribir en el registro de detalle
    de.cod := codUsuario;
    de.fecha := fecha;
    de.tiempo := tiempo;
    writeln(de.cod,' ',de.fecha,' ',de.tiempo);
    write(d,de);
  end;
  close(d);
  close(txt);
end;

procedure hacerResets(var d:archivos_detalle);
var
	i:integer;
begin
	for i:=1 to df do
		reset(d[i]);
end;

procedure hacerClose(var d:archivos_detalle);
var
	i:integer;
begin
	for i:=1 to df do
		close(d[i]);
end;
	
procedure obtenerMin(var d:archivos_detalle;var de:detalle);
var
	i,pos:integer;
	tmp:detalle;
begin
	de.cod:=valorAlto;
	de.fecha:='ZZZZZZZZZZZZ';
	for i:=1 to df do begin
		if not eof(d[i])then begin
			read(d[i],tmp);
			if(tmp.cod<de.cod)then begin
				de.cod:=tmp.cod;
				de.fecha:=tmp.fecha;
				pos:=i;
			end
			else 
				if(tmp.cod=de.cod)then begin
					if(de.fecha>tmp.fecha)then begin
						de.fecha:=tmp.fecha;
						pos:=i;
					end;
				end;
			seek(d[i],filePos(d[i])-1);
		end;
	end;
	if(de.cod<>valorAlto)then 
		read(d[pos],de);	
end;
	
procedure actualizarMaestro(var m:archivo_maestro;var d:archivos_detalle);
var
	min:detalle;
	maestroActual:maestro;
	total:integer;
begin
	rewrite(m);
	hacerResets(d);
	obtenerMin(d,min);
	while(min.cod<>valorAlto)do begin
		maestroActual.cod:=min.cod;
		while((min.cod<>valorAlto) and (maestroActual.cod=min.cod))do begin
			maestroActual.fecha:=min.fecha;
			total:=0;
			while((min.cod<>valorAlto) and (maestroActual.cod=min.cod) and (maestroActual.fecha=min.fecha))do begin
				total:=total+min.tiempo;
				obtenerMin(d,min);
			end;
			maestroActual.tiempo_total:=total;
			write(m,maestroActual);
		end;
	end;
	hacerClose(d);
	close(m);
end;

procedure informar(var m:archivo_maestro);
var
	tmp:maestro;
begin
	reset(m);
	while not eof(m)do begin
		read(m,tmp);
		writeln('codigo: ',tmp.cod,' fecha: ',tmp.fecha,' tiempo total: ',tmp.tiempo_total);
	end;
	close(m);
end;
	
begin
	for i:=1 to df do begin
		Str(i,a);
		ubicacion:='ej6de'+a;
		assign(d[i],ubicacion+'.dat');
		agregarDatosDetalle(d[i],ubicacion);
	end;
	ubicacion:='C:/var/log/ej6ma';
	assign(m,ubicacion);
	actualizarMaestro(m,d);
	informar(m);
end.
