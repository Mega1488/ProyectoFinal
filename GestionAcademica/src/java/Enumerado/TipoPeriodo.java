/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Enumerado;

/**
 *
 * @author Alvaro
 */
public enum TipoPeriodo {
    MENSUAL("Mensual", 1), SEMESTRAL("Semestral", 2), ANUAL("Anual", 3), MODULAR("Modular", 4);
    
    TipoPeriodo(){
        
    }
    
    private String vTpoPerNom;
    private int vTpoPerCod;

    TipoPeriodo(String tpoPerNom, int tpoPerCod) {
        this.vTpoPerCod = tpoPerCod;
        this.vTpoPerNom = tpoPerNom;
    }

    public int getTipoPeriodo() {
        return vTpoPerCod;
    }
    
    public String getTipoPeriodoNombre() {
        return vTpoPerNom;
    }
    
    public static TipoPeriodo fromCode(int tpoPerCod) {
        for (TipoPeriodo tipoPeriodo :TipoPeriodo.values()){
            if (tipoPeriodo.getTipoPeriodo() == tpoPerCod){
                return tipoPeriodo;
            }
        }
        throw new UnsupportedOperationException(
                "El tipo de periodo " + tpoPerCod + " is not supported!");
    }
    
}
