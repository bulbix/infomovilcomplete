$(document).ready(function() {
                  
                  $("#head-video").click(function() {//ocultar-video
                                         $('#movie-panel').toggle("fast")
                                         });
                  
                  $("#head-promociones").click(function() {//ocultarOffer
                                               $('#offer-panel').toggle("fast")
                                               });
                  $("#head-contacto").click(function() {//ocultar-contacto
                                            $('#body-contacto').toggle("fast")
                                            $('#div-contact').toggle("fast")
                                            });
                  $("#verTerms").click(function() {
                                       $('#Terminos').toggle("fast")
                                       });
                  $("#head-galeria").click(function() {//ocultar-galeria
                                           $('#galeria').toggle("fast")
                                           });
                  $("#head-anuncioSug").click(function() {//ocultar-anuncioSug
                                              $('#anuncioSugerido').toggle("fast")
                                              });
                  $("#head-direccion").click(function() {//ocultar-direccion
                                             $('#direccion-panel').toggle("fast")
                                             });
                  $("#head-otherInfo").click(function() {//ocultar-otherInfo
                                             $('#info-panel').toggle("fast")
                                             });
                  $("#head-perfil").click(function() {//ocultar-perfil
                                          $('#perfil-panel').toggle("fast")
                                          });
                  $("#head-mapa").click(function() { //ocultar-mapa
                                        $('#mapa').toggle("fast")
                                        });
                  });

//Esta funcion permite crear el codigo HTML que genera el mapa en la pagina
function creariMapa(lat, lon){
    // Crea un documento con el nombre y la edad pasadas como referencia
    
    // Abrimos el documento
    var capa = document.getElementById("contenedorMapa");
    var imapa = document.createElement("iframe");
    imapa.id ="iMapa"; //AIzaSyB_eueWGjOfljI3d7aR2ikrRf_FL0NHEQQ   dev
    imapa.src ="https://www.google.com/maps/embed/v1/place?key=AIzaSyBfyUsYuAxuiHu1IeOW-L6dbfkNfEIEIEU&q="+lat+","+lon+"&zoom=15&maptype=roadmap ";
    var control = document.getElementById("iMapa")
    if(control == null){
		document.getElementById("mapa").style.display='block';
	  	document.getElementById("contenedorMapa").appendChild(imapa);
    }
    else{
		if(document.getElementById("mapa").style.display=='block'){
			document.getElementById("mapa").style.display='none';
        }else{
            document.getElementById("mapa").style.display='block';
        }
    }
    //<iframe id ="iMapa" src="https://www.google.com/maps/embed/v1/place?key=AIzaSyB_eueWGjOfljI3d7aR2ikrRf_FL0NHEQQ&q=19.390844345092773,-99.05858612060547&zoom=16&maptype=roadmap "></iframe>
    
}

// Estas funciones permiten cambiar la imagen de cada modulo de la pagina cuando se muestra u oculta el panel
function verVideo(){
    if (document.getElementById("ocultar-video").className == "showP") {
        document.getElementById("ocultar-video").className="hideP";
    }
    else {
        document.getElementById("ocultar-video").className="showP";
    }
}

function verGaleria(){
    if (document.getElementById("ocultar-galeria").className == "showP") {
        document.getElementById("ocultar-galeria").className = "hideP";
    }
    else {
        document.getElementById("ocultar-galeria").className = "showP";
    }
}

function verAnuncioSug(){
    if (document.getElementById("ocultar-anuncioSug").className == "showP") {
        document.getElementById("ocultar-anuncioSug").className = "hideP";
    }
    else {
        document.getElementById("ocultar-anuncioSug").className = "showP";
    }
}

function verContacto(){
    if (document.getElementById("ocultar-contacto").className == "showP") {
        document.getElementById("ocultar-contacto").className = "hideP";
    }
    else {
        document.getElementById("ocultar-contacto").className = "showP";
    }
}

function verOferta(){
    if (document.getElementById("ocultarOffer").className == "showP") {
        document.getElementById("ocultarOffer").className="hideP";
    }
    else {
        document.getElementById("ocultarOffer").className="showP";
    }
}

function verPerfil(){
    if (document.getElementById("ocultar-perfil").className == "showP") {
        document.getElementById("ocultar-perfil").className = "hideP";
    }
    else {
        document.getElementById("ocultar-perfil").className = "showP";
    }
}

function verOtherInfo(){
    if (document.getElementById("ocultar-otherInfo").className == "showP") {
        document.getElementById("ocultar-otherInfo").className = "hideP";
    }
    else {
        document.getElementById("ocultar-otherInfo").className = "showP";
    }
}

function verDireccion(){
    if (document.getElementById("ocultar-direccion").className == "showP") {
        document.getElementById("ocultar-direccion").className = "hideP";
    }
    else {
        document.getElementById("ocultar-direccion").className = "showP";
    }
}

//  Esta funcion permite insertar los conteos  de los anuncios publicados
function setCountAnuncio(){
    var idPublicidad="";
    var idDominio = "";
    idPublicidad = document.getElementById("anuncio").getAttribute("alt");
    idDominio = document.getElementById("anuncio").getAttribute("name");
    $.ajax({
           type: "POST",
           url:"contadorPublicidad.action?idAnuncio="+idPublicidad+"&idDominio="+idDominio,
           success: function(response){
           },  
           error: function(e){  
           alert('Error: ' + e);  
           },
           async: true, 
           cache: false  
           });  
}  

function navegador(){  
    var dispositivo = navigator.userAgent.toLowerCase();  
    alert("::"+dispositivo);
    var nav="";
    if( dispositivo.search(/iphone|ipod|ipad|android/) > -1 ){
        nav = "movil"; 
    }
    else{
        nav = "pc"; 
    } 
    
    
    $.ajax({  
           type: "POST",  
           url:"getNavigator.action?navType="+nav, 
           success: function(response){  
           },  
           error: function(e){  
           alert('Error: ' + e);  
           },
           async: true, 
           cache: false  
           });  
}

function noDisponible(){
    alert("No contiene informacion");
}

function isNull(){
    alert("No contiene informacion");
}

