<%-- 
    Document   : DefCalendarioWW
    Created on : 03-jul-2017, 18:28:52
    Author     : alvar
--%>
<%@page import="Entidad.Periodo"%>
<%@page import="Enumerado.EstadoCalendarioEvaluacion"%>
<%@page import="Logica.Seguridad"%>
<%@page import="Logica.LoPersona"%>
<%@page import="Enumerado.NombreSesiones"%>
<%@page import="Entidad.Persona"%>
<%@page import="Entidad.PeriodoEstudio"%>
<%@page import="Enumerado.Modo"%>
<%@page import="Enumerado.TipoMensaje"%>
<%@page import="Utiles.Retorno_MsgObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entidad.Calendario"%>
<%@page import="java.util.List"%>
<%@page import="Logica.LoPeriodo"%>
<%@page import="Utiles.Utilidades"%>
<%

    LoPeriodo loPeriodo   = LoPeriodo.GetInstancia();
    Utilidades utilidad   = Utilidades.GetInstancia();
    String urlSistema     = (String) session.getAttribute(NombreSesiones.URL_SISTEMA.getValor());
    
    //----------------------------------------------------------------------------------------------------
    //CONTROL DE ACCESO
    //----------------------------------------------------------------------------------------------------
    
    String  usuario = (String) session.getAttribute(NombreSesiones.USUARIO.getValor());
    Boolean esAdm   = (Boolean) session.getAttribute(NombreSesiones.USUARIO_ADM.getValor());
    Boolean esAlu   = (Boolean) session.getAttribute(NombreSesiones.USUARIO_ALU.getValor());
    Boolean esDoc   = (Boolean) session.getAttribute(NombreSesiones.USUARIO_DOC.getValor());
    Retorno_MsgObj acceso = Seguridad.GetInstancia().ControlarAcceso(usuario, esAdm, esDoc, esAlu, utilidad.GetPaginaActual(request));
    
    if(acceso.SurgioError()) response.sendRedirect((String) acceso.getObjeto());
            
    //----------------------------------------------------------------------------------------------------
    

    
    String PeriCod       = request.getParameter("pPeriCod");
    
    List<PeriodoEstudio> lstObjeto = new ArrayList<>();
    
    Retorno_MsgObj retorno = (Retorno_MsgObj) loPeriodo.obtener(Long.valueOf(PeriCod));
    if(!retorno.SurgioErrorObjetoRequerido())
    {
        lstObjeto = ((Periodo) retorno.getObjeto()).getLstEstudio();
    }
    else
    {
        out.print(retorno.getMensaje().toString());
    }
    
    String tblVisible = (lstObjeto.size() > 0 ? "" : "display: none;");


%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Gestión Académica - Estudios</title>
        <jsp:include page="/masterPage/head.jsp"/>
    </head>
    <body>
        <jsp:include page="/masterPage/NotificacionError.jsp"/>
        <div class="wrapper">
            <jsp:include page="/masterPage/menu_izquierdo.jsp" />
            
            <div id="contenido" name="contenido" class="main-panel">
                
                <div class="contenedor-cabezal">
                    <jsp:include page="/masterPage/cabezal.jsp"/>
                </div>
                
                <div class="contenedor-principal">
                    <div class="col-sm-11 contenedor-texto-titulo-flotante">
                        
                        <div id="tabs" name="tabs" class="contenedor-tabs">
                            <jsp:include page="/Definiciones/DefPeriodoTabs.jsp"/>
                        </div>
                        
                        <div class=""> 
                            <div class="" style="text-align: right;"><a href="<% out.print(urlSistema); %>Definiciones/DefPeriodoWW.jsp">Regresar</a></div>
                        </div>
        
                        <div style="text-align: right; padding-top: 6px; padding-bottom: 6px;">
                            <a href="#" title="Ingresar" class="glyphicon glyphicon-plus" data-toggle="modal" data-target="#PopUpAgregar"> </a>
                            <input type="hidden" name="PeriCod" id="PeriCod" value="<% out.print(PeriCod); %>">
                        </div>


                        <table style=' <% out.print(tblVisible); %>' class='table table-hover'>
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Código</th>
                                    <th>Estudio</th>
                                    <th>Alumnos</th>
                                    <th></th>
                                    <th>Docentes</th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>

                            <tbody>
                            <% for(PeriodoEstudio periEst : lstObjeto)
                            {

                            %>
                            <tr>
                                <td><a href="<% out.print(urlSistema); %>Definiciones/DefPeriodoEstudio.jsp?MODO=<% out.print(Enumerado.Modo.DELETE); %>&pPeriEstCod=<% out.print(periEst.getPeriEstCod()); %>" name="btn_eliminar" id="btn_eliminar" title="Eliminar" class="glyphicon glyphicon-trash"/></td>
                                <td><% out.print( utilidad.NuloToVacio(periEst.getPeriEstCod())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(periEst.getEstudioNombre())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(periEst.getCantidadAlumnos())); %> </td>
                                <td><a href="<% out.print(urlSistema); %>Definiciones/DefPeriodoAlumnoSWW.jsp?MODO=<% out.print(Enumerado.Modo.UPDATE); %>&pPeriEstCod=<% out.print(periEst.getPeriEstCod()); %>" name="btn_edit_alm" id="btn_edit_alm" title="Alumnos" class="glyphicon glyphicon-edit"/></td>
                                <td><% out.print( utilidad.NuloToVacio(periEst.getCantidadDocente())); %> </td>
                                <td><a href="<% out.print(urlSistema); %>Definiciones/DefPeriodoDocenteSWW.jsp?MODO=<% out.print(Enumerado.Modo.UPDATE); %>&pPeriEstCod=<% out.print(periEst.getPeriEstCod()); %>" name="btn_edit_dct" id="btn_edit_dct" title="Docentes" class="glyphicon glyphicon-edit"/></td>
                                <td><a href="<% out.print(urlSistema); %>Definiciones/DefPeriodoDocumentoSWW.jsp?MODO=<% out.print(Enumerado.Modo.UPDATE); %>&pPeriEstCod=<% out.print(periEst.getPeriEstCod()); %>" name="btn_edit_doc" id="btn_edit_doc" title="Documentos" class="glyphicon glyphicon-file"/></td>
                                
                            </tr>
                            <%
                            }
                            %>
                                </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        
       <!-- PopUp para Agregar -->
                                
        <div id="PopUpAgregar" class="modal fade" role="dialog">
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Estudio</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <label class="radio-inline"><input type="radio" name="pop_TpoEst" id="pop_TpoEst" value="carrera">Carrera</label>
                            <label class="radio-inline"><input type="radio" name="pop_TpoEst" id="pop_TpoEst" value="curso">Curso</label>
                        </div>
                        
                        <div class="row">
                            <div id="pop_FltrCarrera" name="pop_FltrCarrera">
                                <select class="form-control" id="pop_FltrCarCod" name="pop_FltrCarCod"></select>
                                <select class="form-control" id="pop_FltrPlaCod" name="pop_FltrPlaCod"></select>
                            </div>
                        </div>
                        
                        <div class="row">
                            <table id="PopUpTblEstudio" name="PopUpTblEstudio" class="table table-striped" cellspacing="0"  class="table" width="100%">
                                <thead>
                                    <tr>
                                        <th>Codigo</th>
                                        <th>Nombre</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                    </div>
                </div>
            </div>
    
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('input:radio[name="pop_TpoEst"][value="carrera"]').prop("checked", true);
                    $('#pop_FltrCarrera').show();
                        
                    CargarCarreras();
                    
                    $('input:radio[name="pop_TpoEst"]').change(
                        function(){
                            $('#pop_FltrCarrera').show();
                            
                            if (this.checked) {
                                if(this.value == "carrera")
                                {
                                    CargarCarreras();
                                }
                                
                                if(this.value == "curso")
                                {
                                    CargarCurso();
                                    $('#pop_FltrCarrera').hide();
                                }
                            }
                    });
                        
                    
                    function CargarCurso()
                    {
                        $.post('<% out.print(urlSistema); %>ABM_Curso', {
                                         pAction: "POPUP_OBTENER"
                                     }, function (responseText) {
                                        var cursos = JSON.parse(responseText);
                                         
                                        $.each(cursos, function(f , curso) {
                                            curso.curCod = "<td> <a href='#' data-codigo='"+curso.curCod+"' data-nombre='"+curso.curNom+"' class='Pop_Seleccionar'>"+curso.curCod+" </a> </td>";
                                        });

                                         
                                        $('#PopUpTblEstudio').DataTable( {
                                            data: cursos,
                                            deferRender: true,
                                            bLengthChange : false, //thought this line could hide the LengthMenu
                                            destroy: true,
                                            pageLength: 10,
                                            language: {
                                                "lengthMenu": "Mostrando _MENU_ registros por página",
                                                "zeroRecords": "No se encontraron registros",
                                                "info": "Página _PAGE_ de _PAGES_",
                                                "infoEmpty": "No hay registros",
                                                "search":         "Buscar:",
                                                "paginate": {
                                                        "first":      "Primera",
                                                        "last":       "Ultima",
                                                        "next":       "Siguiente",
                                                        "previous":   "Anterior"
                                                    },
                                                "infoFiltered": "(Filtrado de _MAX_ total de registros)"
                                            }
                                            ,columns: [
                                                { "data": "curCod" },
                                                { "data": "curNom"}
                                            ]

                                        } );

                                     });
                    }
                    
                    function CargarCarreras()
                    {
                        $('#pop_FltrCarCod').empty();
                        
                        $.post('<% out.print(urlSistema); %>ABM_Carrera', {
                                         pAccion: "POPUP_OBTENER"
                                     }, function (responseText) {
                                        var carreras = JSON.parse(responseText);
                                        
                                        $.each(carreras, function (i, objeto) {
                                             $('#pop_FltrCarCod').append($('<option>', { 
                                                value: objeto.carCod,
                                                text : objeto.carNom 
                                            }));

                                            if(i == 0)
                                            {
                                                CargarPlanes(objeto);
                                            }

                                        });
                                    });
                    }
                    
                    function CargarPlanes(carrera)
                    {
                        
                        
                        $.each(carrera.plan, function(f , plan) {
                            plan.plaEstCod = "<td> <a href='#' data-codigo='"+plan.plaEstCod+"' data-nombre='"+plan.plaEstNom+"' class='Pop_Seleccionar'>"+plan.plaEstCod+" </a> </td>";
                        });
                        
                            $('#PopUpTblEstudio').DataTable( {
                                data: carrera.plan,
                                deferRender: true,
                                destroy: true,
                                bLengthChange : false, //thought this line could hide the LengthMenu
                                pageLength: 10,
                                language: {
                                    "lengthMenu": "Mostrando _MENU_ registros por página",
                                    "zeroRecords": "No se encontraron registros",
                                    "info": "Página _PAGE_ de _PAGES_",
                                    "infoEmpty": "No hay registros",
                                    "search":         "Buscar:",
                                    "paginate": {
                                            "first":      "Primera",
                                            "last":       "Ultima",
                                            "next":       "Siguiente",
                                            "previous":   "Anterior"
                                        },
                                    "infoFiltered": "(Filtrado de _MAX_ total de registros)"
                                }
                                ,columns: [
                                    { "data": "plaEstCod" },
                                    { "data": "plaEstNom"}
                                ]

                            } );
                        
                    }
                    
                    $('#pop_FltrCarCod').on('change', function() {
                        
                        //$('#PopUpTblEstudio').dataTable().fnClearTable();
                        
                        var CarCod = $('select[name=pop_FltrCarCod]').val();
                        $.post('<% out.print(urlSistema); %>ABM_Carrera', {
                                         pAccion: "POPUP_OBTENER"
                                     }, function (responseText) {
                                        var carreras = JSON.parse(responseText);
                                        
                                        
                                        $.each(carreras, function (i, objeto) {
                                            if(objeto.carCod == CarCod)
                                            {
                                                
                                                CargarPlanes(objeto);
                                            }

                                        });
                                    });
                     })
                
                    $(document).on('click', ".Pop_Seleccionar", function() {

                            var CarCod = $('select[name=pop_FltrCarCod]').val();
                            var codigo = $(this).data("codigo");
                            var PerCod = $('#PerCod').val();
                            
                            var tipo    = "CARRERA";
                            
                            if($('input:radio[name="pop_TpoEst"][value="carrera"]').prop("checked"))
                            {
                                tipo = "CARRERA";
                            }
                            
                            if($('input:radio[name="pop_TpoEst"][value="curso"]').prop("checked"))
                            {
                                tipo = "CURSO";
                            }
                            
                            
                            $.post('<% out.print(urlSistema); %>ABM_Inscripcion', {
                                    pCarCod: CarCod,
                                    pPerCod: PerCod,
                                    pCodigoEstudio: codigo,
                                    pTipoEstudio: tipo,
                                    pAction: "<% out.print(Modo.INSERT);%>"
                                 }, function (responseText) {
                                     var obj = JSON.parse(responseText);

                                     if (obj.tipoMensaje != 'ERROR')
                                     {
                                         location.reload();
                                     } else
                                     {
                                         MostrarMensaje(obj.tipoMensaje, obj.mensaje);
                                     }

                                 });

                            $(function () {
                                    $('#PopUpAgregar').modal('toggle');
                                 });
                    });
                    
                    
                });
            </script>

        </div>
                                     
    </body>
</html>