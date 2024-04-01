program ej7;
const
	df = 10;
type
	datos = record
		localidad:integer;
		nombre:string[5];
		cepa:integer;
		nombre_cepa:string[5];
		activos:integer;
		nuevos:integer;
		recuperados:integer;
		fallecidos:integer;
	end;
	dato = file of datos;
	detalles_txt = array[1..df] of Text;
	detalles = array[1..df] of dato;
var
	d:detalles;
	dt:detalles_txt;
	m:dato;
	i:integer;
	
procedure agregarDatos(var da:dato;var dt:Text;i:integer);
var
	s:string;
	d:datos;
begin
	Str(i,s);
	assign(dt,'municipio'+s+'.txt');
	reset(dt);
	assign(da,'municipio'+s+'.dat');
	reset(da);
	while not eof(dt)do begin
		read(dt,d.localidad,d.cepa,d.activos,d.nuevos,d.recuperados,d.fallecidos,d.nombre,d.nombre_cepa);
		write(da,d);
	end;
	close(da);
	close(dt);
end;

procedure hacerRecets(var d:detalles);
var
	i:integer;
begin
	for i:=1 to df do 
		reset(d[i]);
end;

procedure hacerCloses(var d:detalles);
var
	i:integer
begin
	for i:=1 to df do 
		close(d[i]);
end;

procedure obtenerMin(var d:detalles;var min:datos);
var
	pos,i:integer;
	tmp:datos;
begin
	min.localidad:=valorAlto;
	for i:=1 to df do begin
		read(d[i],tmp);
		if(min.localidad>tmp.localidad)then begin
			min.localidad:=tmp.localidad;
			min.cepa:=tmp.cepa;
			pos:=i;
		end
		else 
			if((min.localidad=tmp.localidad)and(min.cepa>tmp.cepa))then begin
				min.cepa:=tmp.cepa;
				pos:=i;
			end;
		seek(d[i],filePos(d[i])-1);
	end;
	if(min.localidad<>valorAlto)then
		read(d[pos],min);
end;

procedure actualizarMaestro(var m:dato;var d:detalles);
var
	maestroActual,min:datos;
begin
	assign(m,'ministerio.dat');
	rewrite(m);
	hacerRecets(d);
	obtenerMin(d,min);
	while(min.localidad<>valorAlto)do begin
		maestroActual.localidad:=min.localidad;
		while(maestroActual.localidad=min.localidad)do begin
			maestroActual.cepa:=min.cepa;
			while((maestroActual.localidad=min.localidad) and (maestroActual.cepa=min.cepa))do begin
				maestroActual.fallecidos:=maestroActual.fallecidos+min.fallecidos;
				maestroActual.recuperados:=maestroActual.recuperados+min.recuperados;
				maestroActual.activos:=min.activos;
				maestroActual.nuevos:=min.nuevos;
				obtenerMin(d,min);
			end;
			write(m,maestroActual);
		end;
	end;
	hacerCloses(d);
	close(m);
end;

begin
	for i:=1 to df do begin
		agregarDatos(d[i],dt[i],i);
	end;
	actualizarMaestro(m,d);
end.
