<%-- 
    Document   : DefPeriodoEstudioWW
    Created on : 03-jul-2017, 18:28:52
    Author     : alvar
--%>
<%@page import="Logica.Seguridad"%>
<%@page import="Logica.LoPersona"%>
<%@page import="Enumerado.NombreSesiones"%>
<%@page import="Entidad.Persona"%>
<%@page import="Entidad.PeriodoEstudioAlumno"%>
<%@page import="Enumerado.Modo"%>
<%@page import="Enumerado.TipoMensaje"%>
<%@page import="Utiles.Retorno_MsgObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entidad.PeriodoEstudio"%>
<%@page import="java.util.List"%>
<%@page import="Logica.LoPeriodo"%>
<%@page import="Utiles.Utilidades"%>
<%

    LoPeriodo loPeriodo         = LoPeriodo.GetInstancia();
    Utilidades utilidad         = Utilidades.GetInstancia();
    String urlSistema           = (String) session.getAttribute(NombreSesiones.URL_SISTEMA.getValor());
    
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
    
    String PeriEstCod   = request.getParameter("pPeriEstCod");
    Modo Mode           = Modo.valueOf(request.getParameter("MODO"));
    String urlRetorno   = urlSistema + "Definiciones/DefPeriodoEstudioSWW.jsp?MODO=" + Mode + "&pPeriCod=" + PeriEstCod;
    
    
    List<PeriodoEstudioAlumno> lstObjeto = new ArrayList<>();
    
    Retorno_MsgObj retorno = (Retorno_MsgObj) loPeriodo.obtenerPeriodoEstudio(Long.valueOf(PeriEstCod));
    if(!retorno.SurgioErrorObjetoRequerido())
    {
        lstObjeto = ((PeriodoEstudio) retorno.getObjeto()).getLstAlumno();
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
        <title>Sistema de Gestión Académica - Periodo Estudio | Alumnos</title>
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
                            <jsp:include page="/Definiciones/DefPeriodoEstudioTabs.jsp">
                                <jsp:param name="MostrarTabs" value="SI" />
                                <jsp:param name="Codigo" value="<%= PeriEstCod %>" />
                            </jsp:include>
                        </div>
                        
                        <div class=""> 
                            <div class="" style="text-align: right;"><a href="<% out.print(urlRetorno); %>">Regresar</a></div>
                        </div>
        
                        <div style="text-align: right; padding-top: 6px; padding-bottom: 6px;">
                            <a href="#" title="Ingresar" class="glyphicon glyphicon-plus" data-toggle="modal" data-target="#PopUpAgregar"> </a>
                            <input type="hidden" name="PeriEstCod" id="PeriEstCod" value="<% out.print(PeriEstCod); %>">
                        </div>
        
                        <table style=' <% out.print(tblVisible); %>' class='table table-hover'>
                            <thead><tr>
                                <th></th>
                                <th>Código</th>
                                <th>Alumno</th>
                                <th>Fecha de inscripción</th>
                                <th>Calificación final</th>
                                <th>Inscripcion forzada</th>
                            </tr>
                            </thead>

                            <tbody>
                            <% for(PeriodoEstudioAlumno periAlumno : lstObjeto)
                            {

                            %>
                            <tr>
                                <td><% out.print("<a href='#' data-codigo='" + periAlumno.getPeriEstAluCod() + "' data-nombre='" + periAlumno.getAlumno().getNombreCompleto() +"' data-toggle='modal' data-target='#PopUpEliminar' name='btn_eliminar' id='btn_eliminar' title='Eliminar' class='glyphicon glyphicon-trash btn_eliminar'/>"); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(periAlumno.getPeriEstAluCod())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(periAlumno.getAlumno().getNombreCompleto())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(periAlumno.getPerInsFchInsc())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(periAlumno.getPerInsCalFin())); %> </td>
                                <td><% out.print( utilidad.BooleanToSiNo(periAlumno.getPerInsFrz())); %> </td>
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
        
         <!-- PopUp para Agregar personas del calendario -->

        <div id="PopUpAgregar" class="modal fade" role="dialog">
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Personas</h4>
                  </div>
                  <div class="modal-body">

                      <p>Forzar inscripción de alumnos.</p>
                      <p>Seleccione a la persona que desea inscribir.</p>

                        <div>

                            <table id="PopUpTblPersona" name="PopUpTblPersona" class="table table-striped" cellspacing="0"  class="table" width="100%">
                                <thead>
                                    <tr>
                                        <th>Codigo</th>
                                        <th>Nombre</th>
                                        <th>Tipo</th>
                                        <th>Documento</th>
                                        <th>Inscripciones</th>
                                        <th>Periodo anterior</th>
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

                        Buscar();


                        $(document).on('click', ".PopPer_Seleccionar", function() {

                           var AluPerCod = $(this).data("codigo");
                           var PeriEstCod = $('#PeriEstCod').val();

                            $.post('<% out.print(urlSistema); %>ABM_PeriodoEstudioAlumno', {
                                        pPeriEstCod: PeriEstCod,
                                        pAluPerCod: AluPerCod,
                                        pAction: "<% out.print(Modo.INSERT);%>"
                                    }, function (responseText) {
                                        var obj = JSON.parse(responseText);
                                        MostrarCargando(false);

                                        if (obj.tipoMensaje != 'ERROR')
                                        {
                                            location.reload();
                                        } else
                                        {
                                            MostrarMensaje(obj.tipoMensaje, obj.mensaje);
                                        }

                                    });
                            
                        });


                        function Buscar()
                        {

                                $.post('<% out.print(urlSistema); %>ABM_Persona', {
                                pAction : "POPUP_OBTENER"
                                    }, function(responseText) {


                                        var personas = JSON.parse(responseText);

                                        $.each(personas, function(f , persona) {

                                                       persona.perCod = "<td> <a href='#' data-codigo='"+persona.perCod+"' data-nombre='"+persona.perNom+"' class='PopPer_Seleccionar'>"+persona.perCod+" </a> </td>";
                                        });

                                        $('#PopUpTblPersona').DataTable( {
                                            data: personas,
                                            deferRender: true,
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
                                                { "data": "perCod" },
                                                { "data": "nombreCompleto"},
                                                { "data": "tipoPersona"},
                                                { "data": "perDoc"}
                                            ]

                                        } );

                                });
                        }


                    });
                    </script>
        </div>
        
        <!------------------------------------------------->
        
        <!-- PopUp para Eliminar -->
        
        <div id="PopUpEliminar"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Eliminar</h4>
                  </div>
                  <div class="modal-body">

                      <p>Eliminar la inscripción de: <label name="elim_nombre" id="elim_nombre"></label></p>
                      <p>Quiere proceder?</p>

                  </div>
                  <div class="modal-footer">
                    <button name="elim_boton_confirmar" id="elim_boton_confirmar" type="button" class="btn btn-danger" data-codigo="">Eliminar</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                  </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('.btn_eliminar').on('click', function(e) {
                        
                        var codigo = $(this).data("codigo");
                        var nombre = $(this).data("nombre");
                        
                        $('#elim_nombre').text(nombre);
                        $('#elim_boton_confirmar').data('codigo', codigo);
                        
                        
                      });
                      
                      $('#elim_boton_confirmar').on('click', function(e) {
                            var PeriEstCod = $('#PeriEstCod').val();
                            var codigo = $('#elim_boton_confirmar').data('codigo');

                            $.post('<% out.print(urlSistema); %>ABM_PeriodoEstudioAlumno', {
                                         pPeriEstCod: PeriEstCod,
                                         pPeriEstAluCod: codigo,
                                         pAction: "<% out.print(Modo.DELETE);%>"
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
                     
                      });

                });
            </script>
        </div>

        <!------------------------------------------------->
                                     
    </body>
</html>
