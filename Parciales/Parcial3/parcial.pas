program parcial;
const
	df=3;
	valorAlto=9999;
type
	informacion=record
		cod_farmaco:integer;
		nombre:string[10];
		fecha:string[10];
		cantidad_vendida:integer;
		forma_pago:string[10];// contado o tarjeta
	end;
	detalle=record
		cod_farmaco:integer;
		cantidad:integer;
		sucursal:integer;
	end;
	arc_detalle=file of detalle;
	arc_empresa=file of informacion;
	arcs_empresa=array[1..df] of arc_empresa;
	a2_aux=array[1..df] of informacion;

procedure leerInformacion(var i:informacion);
begin
	writeln('Ingresar codigo de farmaco');
	readln(i.cod_farmaco);
	if(i.cod_farmaco<>valorAlto)then begin
		writeln('Ingresar nombre');
		readln(i.nombre);
		writeln('Ingresar fecha');
		readln(i.fecha);
		writeln('Ingresar cantidad_vendida');
		readln(i.cantidad_vendida);
		writeln('Ingresar forma_pago');
		readln(i.forma_pago);
	end;
end;

procedure crearArchivo(var a:arc_empresa);
var
	i:informacion;
begin
	rewrite(a);
	leerInformacion(i);
	while(i.cod_farmaco<>valorAlto)do begin
		write(a,i);
		leerInformacion(i);
	end;
	close(a);
end;

procedure leerDetalle(var d:detalle);
begin
	writeln('Ingresar codigo');
	readln(d.cod_farmaco);
	if(d.cod_farmaco<>valorAlto)then begin
		writeln('Ingresar cantidad');
		readln(d.cantidad);
		while(not(d.sucursal>0) and (d.sucursal<=df))do begin
			writeln('Ingresar sucursal (1 a ',df,')');
			readln(d.sucursal);
		end;
	end;
end;

procedure leerVentas(var v:arc_detalle);
var
	d:detalle;
begin
	rewrite(v);
	leerDetalle(d);
	while(d.cod_farmaco<>valorAlto)do begin
		write(v,d);
		leerDetalle(d);
	end;
	close(v);
end;


procedure abrirArchivos(var a:arcs_empresa);
var
	i:integer;
begin
	for i:=1 to df do 
		reset(a[i]);
end;

procedure cerrarArchivos(var a:arcs_empresa);
var
	i:integer;
begin
	for i:=1 to df do 
		close(a[i]);
end;

procedure agregarVentas(var ae:arcs_empresa);
var
	v:arc_detalle;
	d:detalle;
	encontre:boolean;
	aux:informacion;
begin
	assign(v,'ventas.dat');
	leerVentas(v);
	reset(v);
	abrirArchivos(ae);
	while(not eof(v))do begin
		read(v,d);
		encontre:=false;
		while((not eof(ae[d.sucursal])) and (encontre=false))do begin
			read(ae[d.sucursal],aux);
			if(aux.cod_farmaco=d.cod_farmaco)then begin
				aux.cantidad_vendida:=aux.cantidad_vendida+d.cantidad;
				seek(ae[d.sucursal],filePos(ae[d.sucursal])-1);
				write(ae[d.sucursal],aux);
				encontre:=true;
			end;
		end;
		if(encontre=false)then begin
			writeln('El farmaco con el codigo ', d.cod_farmaco, ' no existe en la sucursal ', d.sucursal, '.');
		end;
		seek(ae[d.sucursal],0);
	end;
	cerrarArchivos(ae);
	close(v);
end;

procedure listarInformacion(var a:arcs_empresa);
var
	i:integer;
	aux:informacion;
	s:string;
begin
	abrirArchivos(a);
	for i:=1 to df do begin
		Str(i,s);
		writeln();
		writeln('------------- sucursal numero '+s+' -------------');
		while (not eof(a[i])) do begin
			read(a[i],aux);
			writeln('codigo de farmaco: ',aux.cod_farmaco);
			writeln('nombre: ',aux.nombre);
			writeln('fecha: ',aux.fecha);
			writeln('cantidad_vendida: ',aux.cantidad_vendida);
			writeln('forma_pago: ',aux.forma_pago);
			writeln();
		end;
	end;
	cerrarArchivos(a);
end;

procedure leer(var a:arc_empresa;var aux:informacion);
begin
	if(not eof(a))then
		read(a,aux)
	else
		aux.cod_farmaco:=valorAlto;
end;

procedure obtenerMin(var a:arcs_empresa;var a1:a2_aux;var aux:informacion);
var
	i,pos:integer;
begin
	aux.cod_farmaco:=valorAlto;
	for i:= 1 to df do begin
		if(a1[i].cod_farmaco<aux.cod_farmaco)then begin
			aux:=a1[i];
			pos:=i;
		end;
	end;
	if(aux.cod_farmaco<>valorAlto)then begin
		leer(a[pos],a1[pos]);
	end;
end;

procedure informeFarmaco(var a:arcs_empresa);
var
	i,codAct,cantAct,may,codMay:integer;
	aux:informacion;
	a1:a2_aux;
begin
	writeln();
	may:=0;
	for i:=1 to df do begin
		reset(a[i]);
		leer(a[i],a1[i]);
	end;
	obtenerMin(a,a1,aux);
	while (aux.cod_farmaco<>valorAlto) do begin
		cantAct:=0;
		codAct:=aux.cod_farmaco;
		while((aux.cod_farmaco<>valorAlto) and (codAct=aux.cod_farmaco))do begin
			cantAct:=cantAct+aux.cantidad_vendida;
			obtenerMin(a,a1,aux);
		end;
		if(cantAct>may)then begin
			may:=cantAct;
			codMay:=codAct;
		end;
	end;
	writeln('El farmaco mas vendido tiene el codigo: ',codMay);
	cerrarArchivos(a);
end;

procedure obtenerFechaMaxima(var a:arc_empresa;var fecha:string;var may:integer);
var
	i:informacion;
	codAct,cantAct,posMay,mayAct:integer;
begin
	mayAct:=0;
	seek(a,0);
	leer(a,i);
	while(i.cod_farmaco<>valorAlto)do begin
		cantAct:=0;
		codAct:=i.cod_farmaco;
		writeln();
		writeln('codigo: ',i.cod_farmaco);
		while((i.cod_farmaco<>valorAlto) and (codAct=i.cod_farmaco))do begin
			writeln('forma de pago: ',i.forma_pago);
			writeln('cant: ',i.cantidad_vendida);
			if(i.forma_pago='contado')then
				cantAct:=cantAct+i.cantidad_vendida;
			leer(a,i);
		end;
		writeln('cantAct: ',cantAct);
		if(cantAct>mayAct)then begin
			writeln('actualice may con: ',cantAct);
			mayAct:=cantAct;
			posMay:=filePos(a)-1;
		end;
	end;
	writeln('mayAct: ',mayAct);
	if(mayAct<>0)then begin
		seek(a,posMay);
		read(a,i);
		fecha:=i.fecha;
	end
	else
		fecha:='...';
	may:=mayAct;
end;

procedure agregarFecha(var a:arc_empresa; i:informacion);
var
	aux:informacion;
	encontre: boolean;
begin
	seek(a, 0);
	if i.forma_pago = 'contado' then begin
		encontre := false;
		while not eof(a) and not encontre do begin
			read(a, aux);
			if aux.fecha = i.fecha then begin
				i.cantidad_vendida := i.cantidad_vendida + aux.cantidad_vendida;
				seek(a, filePos(a) - 1);
				write(a, i);
				encontre := true;
			end;
		end;
		if not encontre then begin
			write(a, i);
		end;
	end;
end;


procedure informarFechas(var a:arc_empresa);
var
	aux:informacion;
begin
	seek(a,0);
	while (not eof(a)) do begin
		read(a,aux);
		writeln('codigo: ',aux.cod_farmaco,' fecha: ',aux.fecha,' cantidad: ',aux.cantidad_vendida,' forma de pago: ',aux.forma_pago);
	end;
end;

procedure informeFecha(var a:arcs_empresa);
var
	i,codAct,may:integer;
	fechaMay:string;
	min:informacion;
	a1:a2_aux;
	a2:arc_empresa;
begin
	assign(a2,'cantFarmacos.dat');
	rewrite(a2);
	writeln();
	may:=0;
	for i:=1 to df do begin
		reset(a[i]);
		leer(a[i],a1[i]);
	end;
	obtenerMin(a,a1,min);
	while (min.cod_farmaco<>valorAlto) do begin
		codAct:=min.cod_farmaco;
		while((min.cod_farmaco<>valorAlto) and (codAct=min.cod_farmaco))do begin
			agregarFecha(a2,min);
			obtenerMin(a,a1,min);
		end;
	end;
	informarFechas(a2);
	obtenerFechaMaxima(a2,fechaMay,may);
	if(may<>0)then
		writeln('La fecha en la que se produjeron mas ventas al contado ', fechaMay,' con un total de: ',may)
	else	
		writeln('No existe informacion de farmacos archivados');
	cerrarArchivos(a);
	close(a2);
end;

{
procedure exportarArchivo(var a:arcs_empresa;var t:Text);
var
	i,codAct,cantAct:integer;
	aux:informacion;
	a1:a2_aux;
begin
	rewrite(t);
	writeln();
	for i:=1 to df do begin
		reset(a[i]);
		leer(a[i],a1[i]);
	end;
	obtenerMin(a,a1,aux);
	while (aux.cod_farmaco<>valorAlto) do begin
		cantAct:=0;
		codAct:=aux.cod_farmaco;
		while((aux.cod_farmaco<>valorAlto) and (codAct=aux.cod_farmaco))do begin
			cantAct:=cantAct+aux.cantidad_vendida;
			obtenerMin(a,a1,aux);
		end;
		writeln(t,aux.cod_farmaco,' ',aux.nombre,' ',aux.fecha,' ',aux.cantidad_vendida,' ',aux.forma_pago);
	end;
	cerrarArchivos(a);
	close(t);
end;
}

var
	a:arcs_empresa;
	i,opcion:integer;
	s:string;
	t:Text;
begin
	writeln('Iniciando programa....');
	assign(t,'archivo_text.txt');
	for i:=1 to df do begin
		Str(i,s);
		assign(a[i],'archivo'+s+'.dat');
		//crearArchivo(a[i]);
	end;
	repeat
		writeln();
		writeln('Ingrese opcion:');
		writeln('opcion 1: agregar ventas del dia');
		writeln('opcion 2: listar informacion');
		writeln('opcion 3: informar el farmaco con mayor cantidad de ventas');
		writeln('opcion 4: informar fecha con mayor cantidad de ventas al contado');
		//writeln('opcion 5: exportar a archivo de texto');
		writeln('opcion 0: terminar la ejecucion');
		readln(opcion);
		case(opcion)of
			1:agregarVentas(a);
			2:listarInformacion(a);
			3:informeFarmaco(a);
			4:informeFecha(a);
			//5:exportarArchivo(a,t);
		else
			if(opcion<>0)then
				writeln('opcion no valida, vuelva a intentar');
		end;
	until(opcion=0);
end.
