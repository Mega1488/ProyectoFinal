<%-- 
    Document   : DefCalendarioWW
    Created on : 03-jul-2017, 18:28:52
    Author     : alvar
--%>
<%@page import="Enumerado.EstadoCalendarioEvaluacion"%>
<%@page import="Logica.Seguridad"%>
<%@page import="Logica.LoPersona"%>
<%@page import="Enumerado.NombreSesiones"%>
<%@page import="Entidad.Persona"%>
<%@page import="Entidad.CalendarioAlumno"%>
<%@page import="Enumerado.Modo"%>
<%@page import="Enumerado.TipoMensaje"%>
<%@page import="Utiles.Retorno_MsgObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entidad.Calendario"%>
<%@page import="java.util.List"%>
<%@page import="Logica.LoCalendario"%>
<%@page import="Utiles.Utilidades"%>
<%

    LoCalendario loCalendario   = LoCalendario.GetInstancia();
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
    

    
    String CalCod       = request.getParameter("pCalCod");
    
    List<CalendarioAlumno> lstObjeto = new ArrayList<>();
    
    Retorno_MsgObj retorno = (Retorno_MsgObj) loCalendario.obtener(Long.valueOf(CalCod));
    if(!retorno.SurgioErrorObjetoRequerido())
    {
        lstObjeto = loCalendario.AlumnoObtenerListaPorUsuario((Calendario) retorno.getObjeto(), usuario);
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
        <title>Sistema de Gestión Académica - Calendario | Alumnos</title>
        <jsp:include page="/masterPage/head.jsp"/>
    </head>
    <body>
        <div class="container-fluid">
            
            <div id="cabezal" name="cabezal" class="row">
            <jsp:include page="/masterPage/cabezal.jsp"/>
        </div>
        
        
                <div class="col-sm-2">
                    <jsp:include page="/masterPage/menu_izquierdo.jsp" />
                </div>

                <div id="contenido" name="contenido"  class="col-sm-8">
                    <h1>Calendario</h1>

                    <div id="tabs" name="tabs">
                        <jsp:include page="/Definiciones/DefCalendarioTabs.jsp"/>
                    </div>

                    <div style="text-align: right; padding-top: 6px; padding-bottom: 6px;">
                        <a href="#" title="Ingresar" class="glyphicon glyphicon-plus" data-toggle="modal" data-target="#PopUpPersona"> </a>
                        <input type="hidden" name="CalCod" id="CalCod" value="<% out.print(CalCod); %>">
                    </div>


                        <table style=' <% out.print(tblVisible); %>' class='table table-hover'>
                            <thead><tr>
                                <th></th>
                                <th></th>
                                <th>Código</th>
                                <th>Alumno</th>
                                <th>Calificación</th>
                                <th>Calificado por</th>
                                <th>Fecha</th>
                                <th>Estado</th>
                                <th>Validado por</th>
                                <th>Fecha</th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>
                            </thead>
                            
                            <tbody>
                            <% for(CalendarioAlumno calAlumno : lstObjeto)
                            {
                                
                            %>
                            <tr>
                                <td><% if(calAlumno.puedeEditarlo())  out.print("<a href='#' data-codigo='" + calAlumno.getCalAlCod() + "' data-nombre='" + calAlumno.getAlumno().getNombreCompleto() +"' data-toggle='modal' data-target='#PopUpEliminarAlumno' name='btn_eliminar' id='btn_eliminar' title='Eliminar' class='glyphicon glyphicon-trash btn_eliminar'/>"); %> </td>
                                <td><a href="#" data-codigo="<% out.print(calAlumno.getCalAlCod()); %>" data-toggle="modal" data-target="#PopUpMostrarAlumno" name="btn_ver" id="btn_ver" title="Ver" class="glyphicon glyphicon-search btn_ver"/></td>
                                <td><% out.print( utilidad.NuloToVacio(calAlumno.getCalAlCod())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio((calAlumno.getAlumno() != null ? calAlumno.getAlumno().getNombreCompleto() : "" ))); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(calAlumno.getEvlCalVal())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio((calAlumno.getEvlCalPor() != null ? calAlumno.getEvlCalPor().getNombreCompleto() : "" ))); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(calAlumno.getEvlCalFch())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(calAlumno.getEvlCalEst().getEstadoNombre())); %> </td>
                                <td><% out.print( utilidad.NuloToVacio((calAlumno.getEvlValPor() != null ? calAlumno.getEvlValPor().getNombreCompleto() : "" ))); %> </td>
                                <td><% out.print( utilidad.NuloToVacio(calAlumno.getEvlValFch())); %> </td>
                                <td><% if(calAlumno.puedeCalificarse())  out.print("<a href='#' data-codigo='" + calAlumno.getCalAlCod() + "' data-toggle='modal' data-target='#PopUpCalificarAlumno' name='btn_calificar' id='btn_calificar' title='Calificar' class='glyphicon glyphicon-edit btn_calificar'/>"); %> </td>
                                <td><% if(calAlumno.puedeEnviarToValidar())  out.print("<a href='#' data-codigo='" + calAlumno.getCalAlCod() + "' data-toggle='modal' data-target='#PopUpEnviarValidacion' name='btn_toVal' id='btn_toVal' title='Enviar a validación' class='glyphicon glyphicon-log-out btn_toVal'/>"); %> </td>
                                <td><% if(calAlumno.puedeValidarse())  out.print("<a href='#' data-codigo='" + calAlumno.getCalAlCod() + "' data-toggle='modal' data-target='#PopUpEnviarCorreccion' name='btn_toCor' id='btn_toCor' title='Enviar a corrección' class='glyphicon glyphicon-log-out btn_toCor'/>"); %> </td>
                                <td><% if(calAlumno.puedeValidarse())  out.print("<a href='#' data-codigo='" + calAlumno.getCalAlCod() + "' data-toggle='modal' data-target='#PopUpValidarAlumno' name='btn_validar' id='btn_validar' title='Validar' class='glyphicon glyphicon-ok btn_validar'/>"); %> </td>
                                
                            </tr>
                            <%
                            }
                            %>
                                </tbody>
                        </table>

                </div>
        </div>
        
        <!-- PopUp para Eliminar personas del calendario -->
                                
        <div id="PopUpPersona" class="modal fade" role="dialog">
            <jsp:include page="/PopUps/PopUpPersonaCalendario.jsp"/>
        </div>
        
        <!------------------------------------------------->
        
        <!-- PopUp para Eliminar personas del calendario -->
        
        <div id="PopUpEliminarAlumno"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Eliminar</h4>
                  </div>
                  <div class="modal-body">

                      <p>Eliminar alumno: <label name="elim_nombre" id="elim_nombre"></label></p>
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
                            var codigo = $('#elim_boton_confirmar').data('codigo');
                            var CalCod = $('#CalCod').val();
                            $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                         pCalCod: CalCod,
                                         pCalAlCod: codigo,
                                         pAction: "<% out.print(Modo.DELETE);%>"
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

                             $(function () {
                                     $('#PopUpEliminarAlumno').modal('toggle');
                                  });
                     
                      });

                });
            </script>
        </div>
                                     
        <!------------------------------------------------->
        
        <!-- PopUp para Eliminar personas del calendario -->
        
        <div id="PopUpEliminarAlumno"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Eliminar</h4>
                  </div>
                  <div class="modal-body">

                      <p>Eliminar alumno: <label name="elim_nombre" id="elim_nombre"></label></p>
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
                            var codigo = $('#elim_boton_confirmar').data('codigo');
                            var CalCod = $('#CalCod').val();
                            $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                         pCalCod: CalCod,
                                         pCalAlCod: codigo,
                                         pAction: "<% out.print(Modo.DELETE);%>"
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

                             $(function () {
                                     $('#PopUpEliminarAlumno').modal('toggle');
                                  });
                     
                      });

                });
            </script>
        </div>
                                     
        <!------------------------------------------------->
        
        <!-- PopUp para Mostrar Persona -->
        
        <div id="PopUpMostrarAlumno"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Alumno</h4>
                  </div>
                  <div class="modal-body">

                      <p>Nombre: <label name="ver_nombre" id="ver_nombre"></label></p>
                      <p>Documento: <label name="ver_documento" id="ver_documento"></label></p>
                      <p>Calificación: <label name="ver_calificacion" id="ver_calificacion"></label></p>
                      <p>Observaciones: <label name="ver_observaciones" id="ver_observaciones"></label></p>
                      <p>Validadado por: <label name="ver_validado" id="ver_validado"></label></p>
                      <p>Observaciones: <label name="ver_valObservaciones" id="ver_valObservaciones"></label></p>

                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                  </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('.btn_ver').on('click', function(e) {
                        
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "OBTENER"
                            }, function (responseText) {
                                var alumno = JSON.parse(responseText);
                                
                                $('#ver_nombre').text(alumno.alumno.nombreCompleto);
                                $('#ver_documento').text(alumno.alumno.perDoc);
                                $('#ver_calificacion').text(alumno.evlCalVal);
                                $('#ver_observaciones').text(alumno.evlCalObs);
                                $('#ver_validado').text((alumno.evlValPor != null ? alumno.evlValPor.nombreCompleto : ""));
                                $('#ver_valObservaciones').text(alumno.evlValObs);
                                
                        });

                      });
                   

            });
            </script>
        </div>
                                     
        <!------------------------------------------------->
        
        <!------------------------------------------------->
        
        <!-- PopUp para Calificar Persona -->
        
        <div id="PopUpCalificarAlumno"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Alumno</h4>
                  </div>
                  <div class="modal-body">

                      <p>Nombre: <label name="cal_nombre" id="cal_nombre"></label></p>
                      <p>Documento: <label name="cal_documento" id="cal_documento"></label></p>
                      <p>Calificación: <input type="text" class="form-control" id="cal_EvlCalVal" name="cal_EvlCalVal" placeholder="Calificación"  value="" ></p>
                      <p>Observaciones: <textarea type="text" row="5" class="form-control" id="cal_EvlCalObs" name="cal_EvlCalObs" placeholder="Observaciones"  value="" ></textarea></p>

                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-success" name="cal_boton_confirmar" id="cal_boton_confirmar" data-codigo="">Confirmar</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                  </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('.btn_calificar').on('click', function(e) {
                        
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        
                        $('#cal_boton_confirmar').data('codigo', codigo);
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "OBTENER"
                            }, function (responseText) {
                                var alumno = JSON.parse(responseText);
                                
                                $('#cal_nombre').text(alumno.alumno.nombreCompleto);
                                $('#cal_documento').text(alumno.alumno.perDoc);
                                $('#cal_EvlCalVal').val(alumno.evlCalVal);
                                $('#cal_EvlCalObs').val(alumno.evlCalObs);
                                
                        });

                      });
                    
                    $('#cal_boton_confirmar').on('click', function(e) {
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        var calificacion = $('#cal_EvlCalVal').val();
                        var observaciones =$('#cal_EvlCalObs').val();
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pEvlCalVal: calificacion,
                                pEvlCalObs: observaciones,
                                pAction: "<% out.print(Modo.UPDATE); %>"
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
        
        <!-- PopUp TO VALIDACION -->
        
        <div id="PopUpEnviarValidacion"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Alumno</h4>
                  </div>
                  <div class="modal-body">
                      <p>Desea enviar a validación el siguiente alumno?</p>
                      <p>Nombre: <label name="toVal_nombre" id="toVal_nombre"></label></p>
                      <p>Calificación: <label id="toVal_EvlCalVal" name="toVal_EvlCalVal" ></label></p>
                      <p>Observaciones: <label id="toVal_EvlCalObs" name="toVal_EvlCalObs" ></label></p>

                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-success" name="toVal_boton_confirmar" id="toVal_boton_confirmar" data-codigo="">Confirmar</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                  </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('.btn_toVal').on('click', function(e) {
                        
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        
                        $('#toVal_boton_confirmar').data('codigo', codigo);
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "OBTENER"
                            }, function (responseText) {
                                var alumno = JSON.parse(responseText);
                                
                                $('#toVal_nombre').text(alumno.alumno.nombreCompleto);
                                $('#toVal_EvlCalVal').text(alumno.evlCalVal);
                                $('#toVal_EvlCalObs').text(alumno.evlCalObs);
                                
                        });

                      });
                    
                    $('#toVal_boton_confirmar').on('click', function(e) {
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "TO_VALIDAR"
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
        
        <!-- PopUp TO CORRECCION -->
        
        <div id="PopUpEnviarCorreccion"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Alumno</h4>
                  </div>
                  <div class="modal-body">
                      <p>Desea enviar a corrección el siguiente alumno?</p>
                      <p>Nombre: <label name="toCor_nombre" id="toCor_nombre"></label></p>
                      <p>Calificación: <label id="toCor_EvlCalVal" name="toCor_EvlCalVal" ></label></p>
                      <p>Observaciones: <textarea type="text" row="5" class="form-control" id="toCor_EvlValObs" name="toCor_EvlValObs" placeholder="Observaciones"  value="" ></textarea></p>

                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-success" name="toCor_boton_confirmar" id="toCor_boton_confirmar" data-codigo="">Confirmar</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                  </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('.btn_toCor').on('click', function(e) {
                        
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        
                        $('#toCor_boton_confirmar').data('codigo', codigo);
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "OBTENER"
                            }, function (responseText) {
                                var alumno = JSON.parse(responseText);
                                
                                $('#toCor_nombre').text(alumno.alumno.nombreCompleto);
                                $('#toCor_EvlCalVal').text(alumno.evlCalVal);
                                $('#toCor_EvlValObs').text(alumno.evlValObs);
                                
                                
                        });

                      });
                    
                    $('#toCor_boton_confirmar').on('click', function(e) {
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        var EvlValObs = $('#toCor_EvlValObs').val();
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pEvlValObs: EvlValObs,
                                pAction: "TO_CORRECCION"
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
        
        <!-- PopUp VALIDAR -->
        
        <div id="PopUpValidarAlumno"  class="modal fade" role="dialog">
           
            <!-- Modal -->
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Alumno</h4>
                  </div>
                  <div class="modal-body">
                      <p>Desea validar el siguiente alumno?</p>
                      <p>Nombre: <label name="val_nombre" id="val_nombre"></label></p>
                      <p>Calificación: <label id="val_EvlCalVal" name="val_EvlCalVal" ></label></p>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-success" name="val_boton_confirmar" id="val_boton_confirmar" data-codigo="">Confirmar</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                  </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function() {
                    
                    $('.btn_validar').on('click', function(e) {
                        
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        
                        $('#val_boton_confirmar').data('codigo', codigo);
                        
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "OBTENER"
                            }, function (responseText) {
                                var alumno = JSON.parse(responseText);
                                
                                $('#val_nombre').text(alumno.alumno.nombreCompleto);
                                $('#val_EvlCalVal').text(alumno.evlCalVal);
                                
                        });

                      });
                    
                    $('#val_boton_confirmar').on('click', function(e) {
                        var codigo = $(this).data("codigo");
                        var CalCod = $('#CalCod').val();
                        $.post('<% out.print(urlSistema); %>ABM_CalendarioAlumno', {
                                pCalCod: CalCod,
                                pCalAlCod: codigo,
                                pAction: "VALIDAR"
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
