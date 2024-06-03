program ejemplo;
const
	M=10;
type
	alumno=record
		nombreCompleto:string[20];
		dni:integer;
		legajo:integer;
		anioIngreso:integer;
	end;
	arc_alumno=file of alumno;
	Nodo = record
		clave: integer;
		NRR: integer; //posición relativa del registro
	end;
	arbol=record
		dato:array[1...M-1] of Nodo;
		hijos:array[1...M] of ^arbol;
		cantHijos:integer;
	end;
	
procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado);
var 
	clave_encontrada: boolean;
	pos:integer;
begin
	if (nodo = null)
		resultado := false; {clave no encontrada}
	else begin
		pos:=0;
		clave_encontrada:=false;
		while (pos<>A.cantHijos-1 and clave_encontrada=false) do begin
			posicionarYLeerNodo(A, nodo, NRR, pos);
			claveEncontrada(nodo, clave,pos, clave_encontrada);
		end;
		if (clave_encontrada) then begin
			NRR_encontrado := NRR; { NRR actual }
			pos_encontrada := pos; { posicion dentro del array }
			resultado := true;
		end
		else
			for (i:=0;i<nodo.cantidadHijos;i++) do
				buscar(nodo.hijos[i], clave, NRR_encontrado, pos_encontrada,resultado);
	end;
end;

procedure posicionarYLeerNodo(var A:arbol, var nodo: Nodo, NRR:integer; pos:integer);
begin
	nodo:=A.dato[pos];
	NRR:=nodo.NRR;
	pos:=pos+1;
end;

procedure claveEncontrada(var nodo:Nodo; clave:integer;var pos:integer; var clave_encontrada:boolean);
begin
	if(clave=nodo.clave)then begin
		pos:=pos-1;
		clave_encontrada:=true;
	end
end;
