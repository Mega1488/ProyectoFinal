/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Entidad.Version;
import Enumerado.TipoMensaje;
import Logica.LoVersion;
import Utiles.Mensajes;
import Utiles.Utilidades;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alvar
 */
public class AM_Version extends HttpServlet {
    
    private final Utilidades utilidades = Utilidades.GetInstancia();
    private final LoVersion loVersion   = LoVersion.GetInstancia();

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

            
            switch(action)
            {
                case "OBTENER":
                    retorno = this.ObtnerDatos(request);
                break;
                
                case "ACTUALIZAR":
                    retorno = this.ActualizarDatos(request);
                break;
                        
            }

            out.println(retorno);
        }
    }
    
    private String ObtnerDatos(HttpServletRequest request)
    {
        String retorno = "";
        
        String SisVerCod    = request.getParameter("pSisVerCod");
        Version version     = loVersion.obtener(Integer.valueOf(SisVerCod));
        
        try
        {
            retorno = utilidades.ObjetoToJson(version);
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return retorno;
    }
    
    private String ActualizarDatos(HttpServletRequest request)
    {
        Mensajes mensaje    = new Mensajes("Error al guardar datos", TipoMensaje.ERROR);
        
        String retorno = "";
        
        String SisVerCod    = request.getParameter("pSisVerCod");
        String SisCrgDat    = request.getParameter("pSisCrgDat");
        

        Version version     = loVersion.obtener(Long.valueOf(SisVerCod));
        
        
        try
        {
            version.setSisCrgDat(Boolean.valueOf(SisCrgDat));
            loVersion.actualizar(version);
            
            mensaje    = new Mensajes("Cambios guardados correctamente", TipoMensaje.MENSAJE);
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        
        retorno = utilidades.ObjetoToJson(mensaje);

        return retorno;
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
