/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;


import Entidad.Notificacion;
import Enumerado.Modo;
import Enumerado.ObtenerDestinatario;
import Enumerado.TipoEnvio;
import Enumerado.TipoMensaje;
import Enumerado.TipoNotificacion;
import Enumerado.TipoRepeticion;
import Logica.LoNotificacion;
import Utiles.Mensajes;
import Utiles.Retorno_MsgObj;
import Utiles.Utilidades;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alvar
 */
public class ABM_Notificacion extends HttpServlet {
    private final LoNotificacion loNotificacion           = LoNotificacion.GetInstancia();
    private final Utilidades utilidades     = Utilidades.GetInstancia();
    private Mensajes mensaje                = new Mensajes("Error", TipoMensaje.ERROR);
    private Boolean error                   = false;
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            
            
            String action   = request.getParameter("pAction");
            String retorno  = "";

            
            Modo mode = Modo.valueOf(action);


            switch(mode)
            {

                case INSERT:
                    retorno = this.AgregarDatos(request);
                break;

                case UPDATE:
                    retorno = this.ActualizarDatos(request);
                break;

                case DELETE:
                    retorno = this.EliminarDatos(request);
                break;

            }


            out.println(retorno);
            
        }
        
    }
    
    private String AgregarDatos(HttpServletRequest request){
        mensaje    = new Mensajes("Error al guardar datos", TipoMensaje.ERROR);

        try
        {

            error           = false;

            Notificacion notificacion = this.ValidarNotificacion(request, null);

            //------------------------------------------------------------------------------------------
            //Guardar cambios
            //------------------------------------------------------------------------------------------

            if(!error)
            {
                Retorno_MsgObj retornoObj = (Retorno_MsgObj) loNotificacion.guardar(notificacion);
                mensaje    = retornoObj.getMensaje();
            }
        }
        catch(Exception ex)
        {
            mensaje = new Mensajes("Error al guardar: " + ex.getMessage(), TipoMensaje.ERROR);
            throw ex;
        }

        String retorno = utilidades.ObjetoToJson(mensaje);

        return retorno;
    }

    private String ActualizarDatos(HttpServletRequest request){
        mensaje    = new Mensajes("Error al guardar datos", TipoMensaje.ERROR);
        try
        {

            error           = false;
            
            Notificacion notificacion = this.ValidarNotificacion(request, null);

            //------------------------------------------------------------------------------------------
            //Guardar cambios
            //------------------------------------------------------------------------------------------

            Retorno_MsgObj retorno = new Retorno_MsgObj();
            
            if(!error)
            {
                retorno     = (Retorno_MsgObj) loNotificacion.actualizar(notificacion);
            }

            mensaje = retorno.getMensaje(); 
            
        }
        catch(Exception ex)
        {
            mensaje = new Mensajes("Error al actualizar: " + ex.getMessage(), TipoMensaje.ERROR);
            throw ex;
        }

        String retorno = utilidades.ObjetoToJson(mensaje);

        return retorno;
    }

    private String EliminarDatos(HttpServletRequest request){
        error       = false;
        mensaje    = new Mensajes("Error al eliminar", TipoMensaje.ERROR);
        try
        {

            Notificacion notificacion = this.ValidarNotificacion(request, null);

            if(!error)
            {
                mensaje = ((Retorno_MsgObj) loNotificacion.eliminar(notificacion)).getMensaje();
            }
            
        }
        catch(Exception ex)
        {
            mensaje = new Mensajes("Error al Eliminar: " + ex.getMessage(), TipoMensaje.ERROR);
            throw ex;
        }



        return utilidades.ObjetoToJson(mensaje);
    }
        
    private Notificacion ValidarNotificacion(HttpServletRequest request, Notificacion notificacion){
        
        if(notificacion == null)
        {
            notificacion   = new Notificacion();
        }

            
                String NotCod= request.getParameter("pNotCod");
                String NotAct= request.getParameter("pNotAct");
                String NotApp= request.getParameter("pNotApp");
                String NotAsu= request.getParameter("pNotAsu");
                String NotCon= request.getParameter("pNotCon");
                String NotDsc= request.getParameter("pNotDsc");
                String NotEmail= request.getParameter("pNotEmail");
                String NotNom= request.getParameter("pNotNom");
                String NotObtDest= request.getParameter("pNotObtDest");
                String NotRepHst= request.getParameter("pNotRepHst");
                String NotRepTpo= request.getParameter("pNotRepTpo");
                String NotRepVal= request.getParameter("pNotRepVal");
                String NotTpo= request.getParameter("pNotTpo");
                String NotTpoEnv= request.getParameter("pNotTpoEnv");
                String NotWeb= request.getParameter("pNotWeb");
                
                
                //------------------------------------------------------------------------------------------
                //Validaciones
                //------------------------------------------------------------------------------------------

                //TIPO DE DATO

                


                //Sin validacion
                if(NotCod != null) if(!NotCod.isEmpty()) notificacion = (Notificacion) loNotificacion.obtener(Long.valueOf(NotCod)).getObjeto();
                
                if(NotAct != null) if(!NotAct.isEmpty()) notificacion.setNotAct(Boolean.valueOf(NotAct));
                if(NotApp != null) if(!NotApp.isEmpty()) notificacion.setNotApp(Boolean.valueOf(NotApp));
                if(NotAsu != null) if(!NotAsu.isEmpty()) notificacion.setNotAsu(NotAsu);
                if(NotCon != null) if(!NotCon.isEmpty()) notificacion.setNotCon(NotCon);
                if(NotDsc != null) if(!NotDsc.isEmpty()) notificacion.setNotDsc(NotDsc);
                if(NotEmail != null) if(!NotEmail.isEmpty()) notificacion.setNotEmail(Boolean.valueOf(NotEmail));
                if(NotNom != null) if(!NotNom.isEmpty()) notificacion.setNotNom(NotNom);
                if(NotObtDest != null) if(!NotObtDest.isEmpty()) notificacion.setNotObtDest(ObtenerDestinatario.fromCode(Integer.valueOf(NotObtDest)));
                if(NotRepHst != null) if(!NotRepHst.isEmpty()) notificacion.setNotRepHst(Date.valueOf(NotRepHst));
                if(NotRepTpo != null) if(!NotRepTpo.isEmpty()) notificacion.setNotRepTpo(TipoRepeticion.fromCode(Integer.valueOf(NotRepTpo)));
                if(NotRepVal != null) if(!NotRepVal.isEmpty()) notificacion.setNotRepVal(Integer.valueOf(NotRepVal));
                if(NotTpo != null) if(!NotTpo.isEmpty()) notificacion.setNotTpo(TipoNotificacion.fromCode(Integer.valueOf(NotTpo)));
                if(NotTpoEnv != null) if(!NotTpoEnv.isEmpty()) notificacion.setNotTpoEnv(TipoEnvio.fromCode(Integer.valueOf(NotTpoEnv)));
                if(NotWeb != null) if(!NotWeb.isEmpty()) notificacion.setNotWeb(Boolean.valueOf(NotWeb));

                return notificacion;
        }

    
        
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}