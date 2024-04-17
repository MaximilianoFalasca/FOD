{
Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
NombreHospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.
NOTA: El archivo debe recorrerse solo una vez.
}
program ej17;
const
	valorAlto=9999;
type
	archivo = record
		codigoLocalidad:integer;
		codigoMunicipalidad:integer;
		codigoHospital:integer;
		cantidadDePositivos:integer;
		nombreLocalidad:string[10];
		nombreMunicipalidad:string[10];
		nombreHospital:string[10];
		fecha:string[10];
	end;
	archivos=file of archivo;
	
procedure leerDatos(var aux:archivo);
begin
	writeln('Ingresar codigo de localidad:');
	readln(aux.codigoLocalidad);
	if(aux.codigoLocalidad<>valorAlto)then begin
		writeln('Ingresar nombre de localidad:');
		readln(aux.nombreLocalidad);
		writeln('Ingresar codigo de municipalidad:');
		readln(aux.codigoMunicipalidad);
		writeln('Ingresar nombre de localidad:');
		readln(aux.nombreMunicipalidad);
		writeln('Ingresar codigo de hospital:');
		readln(aux.codigoHospital);
		writeln('Ingresar nombre de hospital:');
		readln(aux.nombreHospital);
		writeln('Ingresar cantidad de casos positivos:');
		readln(aux.cantidadDePositivos);
		writeln('Ingresar fecha:');
		readln(aux.v);
	end;
end;
	
procedure crearArchivo(var a:archivos);
var
	aux:archivo;
begin
	writeln('El ingreso de datos termina con el codigo de localidad 9999 y los strings tienen longitud 10');
	rewrite(a);
	leerDatos(aux);
	while(aux.codigoLocalidad<>valorAlto)do begin
		writeln(a,aux);
		//writeln(a,aux.codigoLocalidad,' ',aux.nombreLocalidad,' ',aux.codigoMunicipalidad,' ',aux.nombreMunicipalidad,' ',aux.codigoHospital,' ',aux.nombreHospital,' ',aux.cantidadDePositivos,' ',aux.fecha);
		leerDatos(aux);
	end;
	close(a);
end;
	
procedure leer(var a:archivos;var aux:archivo);
begin
	if not eof(a) then
		read(a,aux);
	else
		aux.codigoLocalidad:=valorAlto;
end;
	
procedure procesarDatos(var a:archivos;var t:Text);
var
	aux:archivo;
	localidadActual,municipioActual,hospitalActual,cantidadLocalidad,cantidadMunicipio,cantidadHospital:integer;
	nombreLocalidad,nombreMunicipalidad:string;
begin
	reset(a);
	leer(a,aux);
	while(aux.codigoLocalidad<>valorAlto)do begin
		localidadActual:=aux.codigoLocalidad;
		nombreLocalidad:=aux.nombreLocalidad;
		cantidadLocalidad:=0;
		while((aux.codigoLocalidad<>valorAlto)and(localidadActual=aux.codigoLocalidad))do begin
			municipioActual:=aux.codigoMunicipio;
			nombreMunicipalidad:=aux.nombreMunicipio;
			cantidadMunicipio:=0;
			while((aux.codigoLocalidad<>valorAlto)and(localidadActual=aux.codigoLocalidad)and(municipioActual=aux.codigoMunicipio))do begin
				hospitalActual:=aux.codigoHospital;
				cantidadHospital:=0;
				while ((aux.codigoLocalidad<>valorAlto)and(localidadActual=aux.codigoLocalidad)and(municipioActual=aux.codigoMunicipio)and(hospitalActual=aux.codigoHospital)) do begin
					cantidadHospital:=aux.cantidadDePositivos;
					leer(a,aux);
				end;
				cantidadMunicipio:=cantidadMunicipio+cantidadHospital;
			end;
			if (cantidadMunicipio>1500) then begin
				writeln(t,nombreLocalidad,' ',nombreMunicipalidad,' ',cantidadMunicipio);
			end;
		end;
	end;
	close(a);
end;
	
var
	a:archivos;
	t:Text;
begin
	assign(a,'ej17Archivo.dat');
	assign(t,'ej17Text.txt');
	crearArchivo(a);
	procesarDatos(a,t);
end.
