program prueba2;
	type archivo = file of integer;
	var arc: archivo;
begin
	assign(arc,'numero.doc');
	rewrite()
	write(arc,50);
	close(arc);
end.
