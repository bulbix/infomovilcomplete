$(document).ready(function() {
		$("#ver_mapa").click(function() {
			$('#mapa').toggle("fast")
		});
		$("#ocultarOffer").click(function() {
			$('#offer-panel').toggle("fast")
		});
		$("#ocultar-contacto").click(function() {
			$('#body-contacto').toggle("fast")
			$('#div-contact').toggle("fast")
		});
		$("#verTerms").click(function() {
			$('#Terminos').toggle("fast")
		});
		$("#ocultar-galeria").click(function() {
			$('#galeria').toggle("fast")
		});
	});
	  function verGaleria(){ 
		   if (document.getElementById("ocultar-galeria").value=="Ocultar") { 
	        document.getElementById("ocultar-galeria").value="Mostrar";
	     }
	     else { 
	         document.getElementById("ocultar-galeria").value="Ocultar";
	     }
	  }
	  function verContacto(){ 
		   if (document.getElementById("ocultar-contacto").value=="Ocultar") { 
	        document.getElementById("ocultar-contacto").value="Mostrar";
	     }
	     else { 
	         document.getElementById("ocultar-contacto").value="Ocultar";
	     }
	  }
	  function verOferta(){ 
		   if (document.getElementById("ocultarOffer").value=="Ocultar") { 
	        document.getElementById("ocultarOffer").value="Mostrar";
	     }
	     else { 
	         document.getElementById("ocultarOffer").value="Ocultar";
	     }
	  }