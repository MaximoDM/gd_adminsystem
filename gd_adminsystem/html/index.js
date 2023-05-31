function startTime() {
    var today = new Date();
    var hr = today.getHours();
    var min = today.getMinutes();
    var sec = today.getSeconds();

    min = checkTime(min);
    sec = checkTime(sec);
    document.getElementById("clock").innerHTML = hr + " : " + min + " : " + sec;
    var time = setTimeout(function(){ startTime() }, 500);
}

function checkTime(i) {
    if (i < 10) {
        i = "0" + i;
    }
    return i;
}

startTime()

$(function () {

    function display(bool) {
        if (bool) {
            $("body").show();
        } else {
            $("body").hide();
        }
    }

    function setInfo(exported) {
        var index = `<div class="box">
        👔 Nombre: <span class="textjus">${exported.name}</span><br>
        🧩 Licencia: <span class="textjus">${exported.licencia}</span><br>
        🎠 Steam: <span class="textjus">${exported.steam}</span><br>
        </div>
        <div class="box">
            🔰  Grupo: <span class="textjus">${exported.grupo}</span><br>
            📌 Permisos: <span class="textjus">${exported.permisos}</span><br>
        </div>`

        $('#carga').html(index)
    }

    function setBan(exported) {
        var index = `<table class="tabla" >
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>RAZON</th>
                                <th>ADMIN</th>
                                <th>AÑADIDO</th>
                                <th>EXPIRA</th>
                                <th>PERMANENTE</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${exported}
                        </tbody>
                    </table>`
        $('#carga').html(index)
    }

    function setWarn(exported) {
        var index = `<table class="tabla">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>RAZON</th>
                                <th>ADMIN</th>
                                <th>AÑADIDO</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${exported}
                        </tbody>
                    </table>`
        $('#carga').html(index)
    }

    function setComandos() {
        $('#carga').html('<div style="padding: 50px; margin: 200px auto; color: white;background-color:#f44336; border-radius:10px; width: fit-content;">EN MANTENIMIENTO</div>')
    }

    var pending = false;

    $('button').click(function(){
        if(pending) return
        pending = true;
        var id = $(this).attr('id')
        if (id !== 'comandos') {
            $.post('http://gd_adminsystem/apartado', JSON.stringify({ident: $('.nombre-user').data('ident'), id: id})).then(exported =>{
                pending = false;
                if (id == 'info') setInfo(exported)
                if (id == 'ban') setBan(exported)
                if (id == 'warn') setWarn(exported)
                if (id == 'docs') setDocs(exported)
            })
        } else {
            pending = false;
            setComandos()
        }
    })

    window.addEventListener('message', function(event) {
        var item = event.data;     
        if (event.data.close) {
            display(false);
            return
        } else {
            display(true);
        }
        $('.nombre-user').html(item.nombreuser)
        $('.nombre-user').data('ident', item.licencia)

        setInfo(item.info)
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://gd_adminsystem/exit', JSON.stringify({}));
            return
        }
    };
})

// if (event.data.type === 'ui') {
//     display(true)
//     $("#first > text").empty();
//     $('<text>').text(item.nombre).appendTo("#first")
// } else if (event.data.status == false) {
//     display(false)
// }

// if (event.data.open === "infouser") {
//     $("#tabla1").show();
//     $("#tabla2").hide();
//     $("#tabla3").hide();
//     $("#tabla4").hide();
//     $("#adv").hide();
//     $("#tercero > #tabla1").empty();
//     let items = item.list
//     $("<p>").text("NOMBRE: ").append(
//         $("<text>").text(items.name)
//     ).appendTo("#tercero > #tabla1");
//     $("<p style='display:block;'>").text("NOMBRE IC: ").append(
//         $("<text>").text(items.nombre)
//     ).appendTo("#tercero > #tabla1");
//     $("<p>").text("NACIMIENTO: ").append(
//         $("<text>").text(items.birthday)
//     ).appendTo("#tercero > #tabla1");
//     $("<p>").text("TELEFONO: ").append(
//         $("<text>").text(items.phone)
//     ).appendTo("#tercero > #tabla1");
//     $("<p>").text("TRABAJO: " ).append(
//         $("<text>").text(items.trabajo),
//         $("<text id='nonne'>").text(" | RANGO: "),
//         $("<text>").text(items.rango)
//     ).appendTo("#tercero > #tabla1");
//     $("<p id='press'>").text("PERMISOS ADMIN: ").append(
//         $("<text>").text(items.permisos)
//     ).appendTo("#tercero > #tabla1");
//     $("<p>").text("GRUPO ADMIN: ").append(
//         $("<text>").text(items.grupo)
//     ).appendTo("#tercero > #tabla1");
//     $("<p id='press'>").text("DINERO EFECTIVO: ").append(
//         $("<text>").text(items.money)
//     ).appendTo("#tercero > #tabla1");
//     $("<p>").text("DINERO BANCO: ").append(
//         $("<text>").text(items.bank)
//     ).appendTo("#tercero > #tabla1");
//     $("<p>").text("DINERO NEGRO: ").append(
//         $("<text>").text(items.blackMoney)
//     ).appendTo("#tercero > #tabla1");            
//     $("<p id='press'>").text("MAFIA: ").append(
//         $("<text>").text(items.mafia),
//         $("<text id='nonne'>").text(" | RANGO: "),
//         $("<text>").text(items.grado)
//     ).appendTo("#tercero > #tabla1");   
// }

// if (event.data.open === "banlist") {
//     $("#tabla1").hide();
//     $("#tabla2").show();
//     $("#tabla3").hide();
//     $("#tabla4").hide();
//     $("#adv").hide();
//     $("#tercero > #tabla2 > tbody").empty();
//     $.each(JSON.parse(item.listban), function(i, items) {
//         var exp = ''
//         if (items.permanent === 1) {
//             exp = 'Permanente'
//         } else {
//             var date1 = new Date(items.expiration)
//             var date2 = new Date(items.timeat)
//             var difference = date1.getTime() - date2.getTime();
//             var daysDifference = Math.floor(difference/86400);
//             var hoursDifference = Math.floor((difference - (daysDifference*86400)) /3600);
//             if (hoursDifference < 10) {
//                 hoursDifference = '0'+hoursDifference;
//             };

//             exp = daysDifference+ ' dias | ' + hoursDifference + 'h'
//         }

//         let meses = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
//         let fecha = new Date(items.timeat * 1000);

//         let hora = fecha.getHours();
//         if(fecha.getHours() < 10){
//             hora = '0'+fecha.getHours();
//         };

//         let minutos = fecha.getMinutes();
//         if(fecha.getMinutes() < 10){
//             minutos = '0'+fecha.getMinutes();
//         };

//         let dia = fecha.getDate();
//         if(fecha.getDate() < 10){
//             dia = '0'+fecha.getDate();
//         };

//         let mes = meses[fecha.getMonth()];
//         let aos = fecha.getFullYear();
//         if (exp === 'Permanente') {
//             $("<tr>").append(
//                 $('<td id="primeralinea">').text(items.id),
//                 $('<td id="segundalinea">').text((items.sourceplayername || "UNKNOWN")),
//                 $('<td id="terceralinea">').text((items.reason || "UNKNOWN")),
//                 $('<td id="cuartalinea">').text(hora+':'+minutos+' - '+dia+'/'+mes+'/'+aos),
//                 $('<td id="quintalinea">').text(exp)
//             ).appendTo("#tercero > #tabla2 > tbody");
//         } else {
//             $("<tr>").append(
//                 $('<td id="primeralinea">').text(items.id),
//                 $('<td id="segundalinea">').text((items.sourceplayername || "UNKNOWN")),
//                 $('<td id="terceralinea">').text((items.reason || "UNKNOWN")),
//                 $('<td id="cuartalinea">').text(hora+':'+minutos+' - '+dia+'/'+mes+'/'+aos),
//                 $('<td id="quintalineamod">').text(exp)
//             ).appendTo("#tercero > #tabla2 > tbody");
//         }
//     });
// }

// if (event.data.open == "warnlist") {
//     $("#tabla1").hide();
//     $("#tabla2").hide();
//     $("#tabla3").show();
//     $("#tabla4").hide();
//     $("#adv").hide();
//     $("#tercero > #tabla3 > tbody").empty();
//     $.each(JSON.parse(item.warnlist), function(i, items) {

//         let meses = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
//         let fecha = new Date(items.timestamp * 1000);

//         let hora = fecha.getHours();
//         if(fecha.getHours() < 10){
//             hora = '0'+fecha.getHours();
//         };

//         let minutos = fecha.getMinutes();
//         if(fecha.getMinutes() < 10){
//             minutos = '0'+fecha.getMinutes();
//         };

//         let dia = fecha.getDate();
//         if(fecha.getDate() < 10){
//             dia = '0'+fecha.getDate();
//         };

//         let mes = meses[fecha.getMonth()];
//         let aos = fecha.getFullYear();
//         $("<tr>").append(
//             $('<td id="primeralinea">').text(items.id),
//             $('<td id="segundalinea">').text((items.admin_name || "UNKNOWN")),
//             $('<td id="terceralinea">').text((items.reason || "UNKNOWN")),
//             $('<td id="cuartalinea">').text(hora+':'+minutos+' - '+dia+'/'+mes+'/'+aos)
//         ).appendTo("#tercero > #tabla3 > tbody");
//     });
// }     
    
// if (event.data.open == "jaillist") {
//     $("#tabla1").hide();
//     $("#tabla2").hide();
//     $("#tabla3").hide();
//     $("#tabla4").show();
//     $("#adv").show();
//     $("#tercero > #tabla4 > tbody").empty();
//     $.each(JSON.parse(item.jaillist), function(i, items) {
//         let meses = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
//         let fecha = new Date(items.timestamp * 1000);

//         let hora = fecha.getHours();
//         if(fecha.getHours() < 10){
//             hora = '0'+fecha.getHours();
//         };

//         let minutos = fecha.getMinutes();
//         if(fecha.getMinutes() < 10){
//             minutos = '0'+fecha.getMinutes();
//         };

//         let dia = fecha.getDate();
//         if(fecha.getDate() < 10){
//             dia = '0'+fecha.getDate();
//         };

//         let mes = meses[fecha.getMonth()];
//         let aos = fecha.getFullYear();
//         var restante = items.time_s
//         if (items.finished == 1) {
//             $("<tr>").append(
//                 $('<td id="primeralinea">').text(items.id),
//                 $('<td id="segundalinea">').text((items.admin_name || "UNKNOWN")),
//                 $('<td id="terceralinea">').text((items.reason || "UNKNOWN")),
//                 $('<td id="cuartalinea">').text(hora+':'+minutos+' - '+dia+'/'+mes+'/'+aos),
//                 $('<td id="quintalineamod">').text(items.totaltime+'m')
//             ).appendTo("#tercero > #tabla4 > tbody");
//         } else {
//             $("<tr>").append(
//                 $('<td id="primeralinea">').text(items.id),
//                 $('<td id="segundalinea">').text((items.admin_name || "UNKNOWN")),
//                 $('<td id="terceralinea">').text((items.reason || "UNKNOWN")),
//                 $('<td id="cuartalinea">').text(hora+':'+minutos+' - '+dia+'/'+mes+'/'+aos),
//                 $('<td id="quintalinea">').text(items.totaltime + 'm | ' + (restante/60) + 'm')
//             ).appendTo("#tercero > #tabla4 > tbody");
//         }
//     });
// }    