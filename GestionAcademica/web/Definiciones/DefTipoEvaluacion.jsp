<%-- 
    Document   : DefTipoEvaluacion
    Created on : 03-jul-2017, 18:29:13
    Author     : alvar
--%>

<%@page import="Enumerado.TipoMensaje"%>
<%@page import="Utiles.Retorno_MsgObj"%>
<%@page import="Moodle.MoodleCategory"%>
<%@page import="Entidad.Parametro"%>
<%@page import="Logica.LoParametro"%>
<%@page import="Logica.LoCategoria"%>
<%@page import="Entidad.TipoEvaluacion"%>
<%@page import="Logica.LoTipoEvaluacion"%>
<%@page import="Utiles.Utilidades"%>
<%@page import="Enumerado.Modo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    LoParametro loParam    = LoParametro.GetInstancia();
    Parametro param        = loParam.obtener(1);
    LoTipoEvaluacion loTipoEvaluacion        = LoTipoEvaluacion.GetInstancia();
    Utilidades utilidad    = Utilidades.GetInstancia();
    String urlSistema      = utilidad.GetUrlSistema();
    
    Modo Mode           = Modo.valueOf(request.getParameter("MODO"));
    String TpoEvlCod    = request.getParameter("pTpoEvlCod");
    String js_redirect  = "window.location.replace('" + urlSistema +  "Definiciones/DefTipoEvaluacionWW.jsp');";

    TipoEvaluacion tpoEvaluacion     = new TipoEvaluacion();
    
    if(Mode.equals(Modo.UPDATE) || Mode.equals(Modo.DISPLAY) || Mode.equals(Modo.DELETE))
    {
        Retorno_MsgObj retorno = (Retorno_MsgObj) loTipoEvaluacion.obtener(Long.valueOf(TpoEvlCod));
        if(!retorno.SurgioErrorObjetoRequerido())
        {
            tpoEvaluacion = (TipoEvaluacion) retorno.getObjeto();
        }
        else
        {
            out.print(retorno.getMensaje().toString());
        }
    }
    
    String CamposActivos = "disabled";
    
    switch(Mode)
    {
        case INSERT: CamposActivos = "enabled";
            break;
        case DELETE: CamposActivos = "disabled";
            break;
        case DISPLAY: CamposActivos = "disabled";
            break;
        case UPDATE: CamposActivos = "enabled";
            break;
    }
    
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Gestión Académica - Tipo Evaluación</title>
        <jsp:include page="/masterPage/head.jsp"/>
        
        <script>
                $(document).ready(function() {
                    $('#btn_guardar').click(function(event) {
                                
                                MostrarCargando(true);
                                
                                var	TpoEvlCod	= $('#TpoEvlCod').val();
                                var	TpoEvlNom	= $('#TpoEvlNom').val();
                                var	TpoEvlExm	= document.getElementById('TpoEvlExm').checked;
                                var	TpoEvlInsAut	= document.getElementById('TpoEvlInsAut').checked;
                                
                                if(TpoEvlNom == '')
                                    {
                                        MostrarMensaje("ERROR", "Completa los datos papa");
                                        MostrarCargando(false);
                                    }
                                    else
                                    {
                                        
                                        if($('#MODO').val() == "INSERT")
                                         {

                                                     // Si en vez de por post lo queremos hacer por get, cambiamos el $.post por $.get
                                                     $.post('<% out.print(urlSistema); %>ABM_TipoEvaluacion', {
                                                            pTpoEvlCod	:	TpoEvlCod,
                                                            pTpoEvlNom	:	TpoEvlNom,
                                                            pTpoEvlExm	:	TpoEvlExm,
                                                            pTpoEvlInsAut	:	TpoEvlInsAut,
                                                            pAction          : "INSERTAR"
                                                     }, function(responseText) {
                                                         var obj = JSON.parse(responseText);
                                                         MostrarCargando(false);

                                                         if(obj.tipoMensaje != 'ERROR')
                                                         {
                                                             <%
                                                                 out.print(js_redirect);
                                                             %>     
                                                         }
                                                         else
                                                         {
                                                             MostrarMensaje(obj.tipoMensaje, obj.mensaje);
                                                         }

                                                     });
                                            }
                                         

                                            if($('#MODO').val() == "UPDATE")
                                            {
                                                // Si en vez de por post lo queremos hacer por get, cambiamos el $.post por $.get
                                                $.post('<% out.print(urlSistema); %>ABM_TipoEvaluacion', {
                                                        pTpoEvlCod	:	TpoEvlCod,
                                                        pTpoEvlNom	:	TpoEvlNom,
                                                        pTpoEvlExm	:	TpoEvlExm,
                                                        pTpoEvlInsAut	:	TpoEvlInsAut,
                                                        pAction          : "ACTUALIZAR"
                                                }, function(responseText) {
                                                    var obj = JSON.parse(responseText);
                                                    MostrarCargando(false);

                                                    if(obj.tipoMensaje != 'ERROR')
                                                    {
                                                        <%
                                                            out.print(js_redirect);
                                                        %>     
                                                    }
                                                    else
                                                    {
                                                        MostrarMensaje(obj.tipoMensaje, obj.mensaje);
                                                    }

                                                });
                                            }

                                            if($('#MODO').val() == "DELETE")
                                            {
                                                $.post('<% out.print(urlSistema); %>ABM_TipoEvaluacion', {
                                                        pTpoEvlCod	:	TpoEvlCod,
                                                        pTpoEvlNom	:	TpoEvlNom,
                                                        pTpoEvlExm	:	TpoEvlExm,
                                                        pTpoEvlInsAut	:	TpoEvlInsAut,
                                                        pAction          : "ELIMINAR"
                                                }, function(responseText) {
                                                    var obj = JSON.parse(responseText);
                                                    MostrarCargando(false);

                                                    if(obj.tipoMensaje != 'ERROR')
                                                    {
                                                        <%
                                                            out.print(js_redirect);
                                                        %>     
                                                    }
                                                    else
                                                    {
                                                        MostrarMensaje(obj.tipoMensaje, obj.mensaje);
                                                    }

                                                });
                                            }
                                    }
                        });
                
                });
                
        </script>
        
    </head>
    <body>
        <div id="cabezal" name="cabezal">
            <jsp:include page="/masterPage/cabezal.jsp"/>
        </div>

        <div style="float:left; width: 10%; height: 100%;">
            <jsp:include page="/masterPage/menu_izquierdo.jsp" />
        </div>

        <div id="contenido" name="contenido" style="float: right; width: 90%;">

            
            <h1>Tipo de Evaluacion</h1>
            
            <div style="display:none" id="datos_ocultos" name="datos_ocultos">
                    <input type="hidden" name="MODO" id="MODO" value="<% out.print(Mode); %>">
                </div>
                <form id="frm_objeto" name="frm_objeto">
                    
                    <div><label>Código</label><input type="text" class="form-control" id="TpoEvlCod" name="TpoEvlCod" placeholder="TpoEvlCod" disabled value="<% out.print( utilidad.NuloToVacio(tpoEvaluacion.getTpoEvlCod())); %>" ></div>
                    <div><label>Nombre</label><input type="text" class="form-control" id="TpoEvlNom" name="TpoEvlNom" placeholder="TpoEvlNom" <% out.print(CamposActivos); %> value="<% out.print( utilidad.NuloToVacio(tpoEvaluacion.getTpoEvlNom())); %>" ></div>
                    <div><label>Es exámen</label><input type="checkbox" class="form-control" id="TpoEvlExm" name="TpoEvlExm" placeholder="TpoEvlExm" <% out.print(CamposActivos); %> <% out.print( utilidad.BooleanToChecked(tpoEvaluacion.getTpoEvlExm())); %> ></div>
                    <div><label>Inscripción automática</label><input type="checkbox" class="form-control" id="TpoEvlInsAut" name="TpoEvlInsAut" placeholder="TpoEvlInsAut" <% out.print(CamposActivos); %> <% out.print( utilidad.BooleanToChecked(tpoEvaluacion.getTpoEvlInsAut())); %> ></div>
                    
                    <div>
                        <input name="btn_guardar" id="btn_guardar" value="Guardar" type="button" />
                    </div>
            </form>
        </div>
    </body>
</html>