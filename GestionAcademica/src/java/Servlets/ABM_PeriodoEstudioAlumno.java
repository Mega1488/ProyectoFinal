/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Entidad.PeriodoEstudioAlumno;
import Entidad.PeriodoEstudio;
import Entidad.Persona;
import Enumerado.NombreSesiones;
import Enumerado.TipoMensaje;
import Logica.LoPeriodo;
import Logica.LoPersona;
import Utiles.Mensajes;
import Utiles.Retorno_MsgObj;
import Utiles.Utilidades;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author alvar
 */
public class ABM_PeriodoEstudioAlumno extends HttpServlet {
    LoPeriodo loPeriodo                     = LoPeriodo.GetInstancia();
    private final Utilidades utilidades     = Utilidades.GetInstancia();
    private Mensajes mensaje                = new Mensajes("Error", TipoMensaje.ERROR);
    private Boolean error                   = false;
    private Persona perUsuario;


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
            
            HttpSession session=request.getSession(); 
            String usuario  = (String) session.getAttribute(NombreSesiones.USUARIO.getValor());            
            if(usuario != null)  perUsuario = (Persona) LoPersona.GetInstancia().obtenerByMdlUsr(usuario).getObjeto();

            
            switch(action)
            {
                
                case "INSERT":
                    retorno = this.AgregarDatos(request);
                break;
                
                case "UPDATE":
                    retorno = this.ActualizarDatos(request);
                break;
                
                case "DELETE":
                    retorno = this.EliminarDatos(request);
                break;
                
                case "OBTENER":
                    retorno = this.ObtenerDatos(request);
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

            PeriodoEstudioAlumno periAlumno = this.ValidarPeriodoEstudioAlumno(request, null);

            //------------------------------------------------------------------------------------------
            //Guardar cambios
            //------------------------------------------------------------------------------------------

            if(!error)
            {
                periAlumno.setPerInsFchInsc(new Date());
                if(perUsuario != null) periAlumno.setInscritoPor(perUsuario);
                periAlumno.setPerInsFrz(true);
                
                Retorno_MsgObj retornoObj = (Retorno_MsgObj) loPeriodo.AlumnoAgregar(periAlumno);
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
    
    private String EliminarDatos(HttpServletRequest request){
        error       = false;
        mensaje    = new Mensajes("Error al eliminar", TipoMensaje.ERROR);
        try
        {
            PeriodoEstudioAlumno periAlumno = this.ValidarPeriodoEstudioAlumno(request, null);
            
            Retorno_MsgObj retorno = (Retorno_MsgObj) loPeriodo.AlumnoEliminar(periAlumno);
            
            mensaje = retorno.getMensaje();

        }
        catch(Exception ex)
        {
            mensaje = new Mensajes("Error al Eliminar: " + ex.getMessage(), TipoMensaje.ERROR);
            throw ex;
        }

       return utilidades.ObjetoToJson(mensaje);
    }
    
    private String ActualizarDatos(HttpServletRequest request){
        mensaje    = new Mensajes("Error al guardar datos", TipoMensaje.ERROR);

        try
        {

            error           = false;
            
            PeriodoEstudioAlumno periAlumno = ValidarPeriodoEstudioAlumno(request, null);
            
            //------------------------------------------------------------------------------------------
            //Guardar cambios
            //------------------------------------------------------------------------------------------

            if(!error)
            {
                Retorno_MsgObj retornoObj = (Retorno_MsgObj) loPeriodo.AlumnoActualizar(periAlumno);
                    
                mensaje    = retornoObj.getMensaje();
            }
        }
        catch(Exception ex)
        {
            mensaje = new Mensajes("Error al actualizar: " + ex.getMessage(), TipoMensaje.ERROR);
            throw ex;
        }

        String retorno = utilidades.ObjetoToJson(mensaje);

        return retorno;
    }
    
    private String ObtenerDatos(HttpServletRequest request){
        error       = false;
        PeriodoEstudioAlumno periAlumno = new PeriodoEstudioAlumno();
        
        try
        {
            periAlumno = this.ValidarPeriodoEstudioAlumno(request, null);
        }
        catch(Exception ex)
        {
            mensaje = new Mensajes("Error al obtener: " + ex.getMessage(), TipoMensaje.ERROR);
            throw ex;
        }

       return utilidades.ObjetoToJson(periAlumno);
    }
    
    private PeriodoEstudioAlumno ValidarPeriodoEstudioAlumno(HttpServletRequest request, PeriodoEstudioAlumno periAlumno){
        if(periAlumno == null)
        {
            periAlumno   = new PeriodoEstudioAlumno();
        }

        String 	PeriEstCod	= request.getParameter("pPeriEstCod");
        String 	PeriEstAluCod   = request.getParameter("pPeriEstAluCod");
        String 	AluPerCod	= request.getParameter("pAluPerCod");
        
        //------------------------------------------------------------------------------------------
        //Validaciones
        //------------------------------------------------------------------------------------------

        //TIPO DE DATO

        if(PeriEstCod != null) periAlumno.setPeriodoEstudio(((PeriodoEstudio) loPeriodo.obtenerPeriodoEstudio(Long.valueOf(PeriEstCod)).getObjeto()));
        
        if(PeriEstAluCod != null) periAlumno = periAlumno.getPeriodoEstudio().getAlumnoById(Long.valueOf(PeriEstAluCod));
        
        if(AluPerCod != null) periAlumno.setAlumno((Persona) LoPersona.GetInstancia().obtener(Long.valueOf(AluPerCod)).getObjeto());
            
        return periAlumno;
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