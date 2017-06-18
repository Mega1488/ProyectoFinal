/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entidad;

import Enumerado.EstadoServicio;
import Enumerado.ServicioWeb;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author alvar
 */
@Entity
@Table(name = "WS_BIT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "WS_Bit.findAll",       query = "SELECT t FROM WS_Bit t")})

public class WS_Bit implements Serializable {

    private static final long serialVersionUID = 1L;
    
    
    //-ATRIBUTOS
    @Id
    @Basic(optional = false)
    @Column(name = "WsBitCod", nullable = false)
    private Integer WsBitCod;
    
    @ManyToOne(targetEntity = WS_User.class, optional=false)
    @JoinColumn(name="WsUsrCod", referencedColumnName="WsUsrCod")
    private WS_User usuario;
    
    @Column(name = "WsSrv")
    private ServicioWeb WsSrv;
    
    @Column(name = "WsBitFch", columnDefinition="DATETIME")
    @Temporal(TemporalType.TIMESTAMP)
    private Date WsBitFch;
    
    @Column(name = "WsBitEst")
    private EstadoServicio WsBitEst;
    
    
    //-CONSTRUCTOR
    
    
    public WS_Bit() {    
    }

    //-GETTERS Y SETTERS

    public Integer getWsBitCod() {
        return WsBitCod;
    }

    public void setWsBitCod(Integer WsBitCod) {
        this.WsBitCod = WsBitCod;
    }

    public WS_User getUsuario() {
        return usuario;
    }

    public void setUsuario(WS_User usuario) {
        this.usuario = usuario;
    }

    public ServicioWeb getWsSrv() {
        return WsSrv;
    }

    public void setWsSrv(ServicioWeb WsSrv) {
        this.WsSrv = WsSrv;
    }

    public Date getWsBitFch() {
        return WsBitFch;
    }

    public void setWsBitFch(Date WsBitFch) {
        this.WsBitFch = WsBitFch;
    }

    public EstadoServicio getWsBitEst() {
        return WsBitEst;
    }

    public void setWsBitEst(EstadoServicio WsBitEst) {
        this.WsBitEst = WsBitEst;
    }
    
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (WsBitCod != null ? WsBitCod.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof WS_Bit)) {
            return false;
        }
        WS_Bit other = (WS_Bit) object;
        if ((this.WsBitCod == null && other.WsBitCod != null) || (this.WsBitCod != null && !this.WsBitCod.equals(other.WsBitCod))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Entidad.WS_Bit[ id=" + WsBitCod + " ]";
    }
    
}
