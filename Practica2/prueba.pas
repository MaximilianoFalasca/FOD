program prueba;
type
    detalle = record
        cod: integer;
        cant: integer;
    end;

var
    d: Text;
    de: detalle;

begin
    assign(d, 'detalle_sucursal_1.txt');
    reset(d);
    while not eof(d) do begin
        read(d, de.cod, de.cant);
        writeln('Codigo: ', de.cod, ' cant: ', de.cant);
    end;
    close(d);
end.
