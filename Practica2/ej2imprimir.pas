program ej2;
type
	alumno = record
		cod:integer;
		apellido:string[20];
		nombre:string[20];
		cursadas:integer;
		aprobadas:integer;
	end;
	alumnoDetalle=record
		cod:integer;
		aproboFinal:boolean;
	end;
	archivoAl=file of alumno;
	archivoDe=file of alumnoDetalle;
var
	al:archivoAl;
	de:archivoDe;
	nombreArchivo:String[10];
begin
	assign(al,'');
end;
