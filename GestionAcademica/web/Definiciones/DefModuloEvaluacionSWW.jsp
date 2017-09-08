<%-- 
    Document   : DefCursoEvaluacionSWW
    Created on : 06-jul-2017, 20:02:25
    Author     : alvar
--%>

<%@page import="Enumerado.TipoMensaje"%>
<%@page import="Utiles.Retorno_MsgObj"%>
<%@page import="Entidad.Evaluacion"%>
<%@page import="Entidad.Modulo"%>
<%@page import="Enumerado.Modo"%>
<%@page import="Entidad.Curso"%>
<%@page import="java.util.List"%>
<%@page import="Logica.LoCurso"%>
<%@page import="Utiles.Utilidades"%>
<%

    LoCurso loCurso = LoCurso.GetInstancia();
    Utilidades utilidad = Utilidades.GetInstancia();
    String urlSistema = utilidad.GetUrlSistema();

    //----------------------------------------------------------------------------------------------------
    //CONTROL DE ACCESO
    //----------------------------------------------------------------------------------------------------
    String usuario = (String) session.getAttribute(Enumerado.NombreSesiones.USUARIO.getValor());
    Boolean esAdm = (Boolean) session.getAttribute(Enumerado.NombreSesiones.USUARIO_ADM.getValor());
    Boolean esAlu = (Boolean) session.getAttribute(Enumerado.NombreSesiones.USUARIO_ALU.getValor());
    Boolean esDoc = (Boolean) session.getAttribute(Enumerado.NombreSesiones.USUARIO_DOC.getValor());
    Retorno_MsgObj acceso = Logica.Seguridad.GetInstancia().ControlarAcceso(usuario, esAdm, esDoc, esAlu, utilidad.GetPaginaActual(request));

    if (acceso.SurgioError()) {
        response.sendRedirect((String) acceso.getObjeto());
    }

    //----------------------------------------------------------------------------------------------------
    Modo Mode = Modo.valueOf(request.getParameter("MODO"));
    String CurCod = request.getParameter("pCurCod");
    String ModCod = request.getParameter("pModCod");

    Curso curso = new Curso();
    Modulo modulo = new Modulo();

    Retorno_MsgObj retorno = (Retorno_MsgObj) loCurso.obtener(Long.valueOf(CurCod));
    if (retorno.getMensaje().getTipoMensaje() != TipoMensaje.ERROR) {
        curso = (Curso) retorno.getObjeto();
        modulo = curso.getModuloById(Long.valueOf(ModCod));
    } else {
        out.print(retorno.getMensaje().toString());
    }

    String tblVisible = (modulo.getLstEvaluacion().size() > 0 ? "" : "display: none;");

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Gestión Académica - Modulo | Evaluación</title>
        <jsp:include page="/masterPage/head.jsp"/>
        <jsp:include page="/masterPage/head_tables.jsp"/>
    </head>
    <body>
        <jsp:include page="/masterPage/NotificacionError.jsp"/>
        <jsp:include page="/masterPage/cabezal_menu.jsp"/>
        <!-- CONTENIDO -->
        <div class="contenido" id="contenedor">                
            <div class="row">
                <div class="col-lg-12">
                    <section class="panel">
                        <!-- TABS -->
                        <jsp:include page="/Definiciones/DefModuloTabs.jsp"/>
                        <span class="contenedor_agregar">
                            <a href="<% out.print(urlSistema); %>Definiciones/DefEvaluacion.jsp?MODO=<% out.print(Enumerado.Modo.INSERT); %>&pRelacion=MODULO&pModEvlCurCod=<% out.print(curso.getCurCod()); %>&pModEvlModCod=<% out.print(modulo.getModCod()); %>" title="Ingresar" class="glyphicon glyphicon-plus"> </a>
                        </span>
                        <div class="panel-body">
                            <div class="tab-content">
                                <div id="inicio" class="tab-pane active">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <section class="panel">

                                                <div class="panel-body">
                                                    <div class=" form">
                                                        <div name="datos_ocultos">
                                                            <input type="hidden" name="MODO" id="MODO" value="<% out.print(Mode); %>">
                                                            <input type="hidden" name="CurCod" id="CurCod" value="<% out.print(curso.getCurCod()); %>">
                                                            <input type="hidden" name="ModCod" id="ModCod" value="<% out.print(modulo.getModCod()); %>">
                                                        </div>
                                                        
                                                        <table id='tbl_ww' style=' <% out.print(tblVisible); %>' class='table table-hover'>
                                                            <thead>
                                                                <tr>
                                                                    <th></th>
                                                                    <th></th>
                                                                    <th>Código</th>
                                                                    <th>Nombre</th>
                                                                    <th>Descripción</th>
                                                                    <th>Tipo</th>
                                                                    <th>Nota toal</th>
                                                                </tr>
                                                            </thead>

                                                            <% for (Evaluacion evaluacion : modulo.getLstEvaluacion()) {

                                                            %>
                                                            <tr>
                                                                <td><a href="<% out.print(urlSistema); %>Definiciones/DefEvaluacion.jsp?MODO=<% out.print(Enumerado.Modo.DELETE); %>&pRelacion=MODULO&pModEvlCurCod=<% out.print(curso.getCurCod()); %>&pModEvlModCod=<% out.print(modulo.getModCod()); %>&pEvlCod=<% out.print(evaluacion.getEvlCod()); %>" name="btn_eliminar" id="btn_eliminar" title='Eliminar' class='glyphicon glyphicon-trash btn_eliminar'></a></td>
                                                                <td><a href="<% out.print(urlSistema); %>Definiciones/DefEvaluacion.jsp?MODO=<% out.print(Enumerado.Modo.UPDATE); %>&pRelacion=MODULO&pModEvlCurCod=<% out.print(curso.getCurCod()); %>&pModEvlModCod=<% out.print(modulo.getModCod()); %>&pEvlCod=<% out.print(evaluacion.getEvlCod()); %>" name="btn_editar" id="btn_editar" title='Editar' class='glyphicon glyphicon-edit btn_editar'></a></td>

                                                                <td><% out.print(utilidad.NuloToVacio(evaluacion.getEvlCod())); %> </td>
                                                                <td><% out.print(utilidad.NuloToVacio(evaluacion.getEvlNom())); %> </td>
                                                                <td><% out.print(utilidad.NuloToVacio(evaluacion.getEvlDsc())); %> </td>
                                                                <td><% out.print(utilidad.NuloToVacio(evaluacion.getTpoEvl().getTpoEvlNom())); %> </td>
                                                                <td><% out.print(utilidad.NuloToVacio(evaluacion.getEvlNotTot())); %> </td>

                                                            </tr>
                                                            <%
                                                                }
                                                            %>
                                                        </table>
                                                    </div>
                                                </div>
                                            </section>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>

        <jsp:include page="/masterPage/footer.jsp"/>
     
    </body>
</html>

