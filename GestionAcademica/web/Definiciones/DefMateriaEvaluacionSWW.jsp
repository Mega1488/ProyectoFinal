<%-- 
    Document   : DefMateriaEvaluacionWW
    Created on : jul 20, 2017, 3:28:32 p.m.
    Author     : aa
--%>

<%@page import="Entidad.Evaluacion"%>
<%@page import="Entidad.Materia"%>
<%@page import="Entidad.Carrera"%>
<%@page import="Entidad.PlanEstudio"%>
<%@page import="Logica.LoCarrera"%>
<%@page import="Enumerado.TipoMensaje"%>
<%@page import="Enumerado.Modo"%>
<%@page import="Utiles.Retorno_MsgObj"%>
<%@page import="Utiles.Utilidades"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%

    LoCarrera loCarrera = LoCarrera.GetInstancia();
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
    String PlaEstCod = request.getParameter("pPlaEstCod");
    String CarCod = request.getParameter("pCarCod");
    String MatCod = request.getParameter("pMatCod");
    
    String titulo = "";

    Carrera car = new Carrera();
    PlanEstudio plan = new PlanEstudio();
    Materia mat = new Materia();
//    Evaluacion eva      = new Evaluacion();

    Retorno_MsgObj retorno = (Retorno_MsgObj) loCarrera.obtener(Long.valueOf(CarCod));
    if (retorno.getMensaje().getTipoMensaje() != TipoMensaje.ERROR) {
        car = (Carrera) retorno.getObjeto();
        plan = car.getPlanEstudioById(Long.valueOf(PlaEstCod));
        mat = plan.getMateriaById(Long.valueOf(MatCod));
        
        titulo = plan.getCarreraPlanNombre() 
                + " - " 
                + mat.getMatNom();
        
    } else {
        out.print(retorno.getMensaje().toString());
    }

    String tblVisible = (mat.getLstEvaluacion().size() > 0 ? "" : "display: none;");

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Gestión Académica - Materia <%=titulo%> | Evaluación</title>
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
                            
                        <jsp:include page="/Definiciones/DefMateriaTabs.jsp"/>
                            
                        <div class="contenedor_agregar">
                            <a href="<% out.print(urlSistema); %>Definiciones/DefEvaluacion.jsp?MODO=<% out.print(Enumerado.Modo.INSERT); %>&pRelacion=MATERIA&pCarCod=<% out.print(car.getCarCod()); %>&pPlaEstCod=<% out.print(plan.getPlaEstCod()); %>&pMatCod=<% out.print(mat.getMatCod()); %>" title="Ingresar" class="glyphicon glyphicon-plus"> </a>
                        </div>
                        <div class="panel-body">
                            <div class=" form">
                                <div class=""> 
                                    <input type="hidden" name="MODO" id="MODO" value="<% out.print(Mode); %>">
                                    <input type="hidden" name="CarCod" id="CurCod" value="<% out.print(car.getCarCod()); %>">
                                    <input type="hidden" name="PlaEstCod" id="ModCod" value="<% out.print(plan.getPlaEstCod()); %>">
                                    <input type="hidden" name="MatCod" id="ModCod" value="<% out.print(mat.getMatCod()); %>">
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

                                    <% for (Evaluacion evaluacion : mat.getLstEvaluacion()) {

                                    %>
                                    <tr>
                                        <td><a href="<% out.print(urlSistema); %>Definiciones/DefEvaluacion.jsp?MODO=<% out.print(Enumerado.Modo.DELETE); %>&pRelacion=MATERIA&pCarCod=<% out.print(car.getCarCod()); %>&pPlaEstCod=<% out.print(plan.getPlaEstCod()); %>&pMatCod=<% out.print(mat.getMatCod()); %>&pEvlCod=<% out.print(evaluacion.getEvlCod()); %>" name="btn_eliminar" id="btn_eliminar" title='Eliminar' class='glyphicon glyphicon-trash btn_eliminar'></a></td>
                                        <td><a href="<% out.print(urlSistema); %>Definiciones/DefEvaluacion.jsp?MODO=<% out.print(Enumerado.Modo.UPDATE); %>&pRelacion=MATERIA&pCarCod=<% out.print(car.getCarCod()); %>&pPlaEstCod=<% out.print(plan.getPlaEstCod()); %>&pMatCod=<% out.print(mat.getMatCod()); %>&pEvlCod=<% out.print(evaluacion.getEvlCod()); %>" name="btn_editar" id="btn_editar" title='Editar' class='glyphicon glyphicon-edit btn_editar'></a></td>

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
        <jsp:include page="/masterPage/footer.jsp"/>
    </body>
</html>