package com.foro.bean;

import java.sql.Timestamp;

public class Mensaje {

    private int idMensaje;
    private int idUsuario;
    private int idNivel;
    private String tipoMensaje;
    private String contenido;
    private Timestamp fechaRegistro;
    private String usernameAutor;

    public Mensaje() {
    }

    public int getIdMensaje() {
        return idMensaje;
    }

    public void setIdMensaje(int idMensaje) {
        this.idMensaje = idMensaje;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdNivel() {
        return idNivel;
    }

    public void setIdNivel(int idNivel) {
        this.idNivel = idNivel;
    }

    public String getTipoMensaje() {
        return tipoMensaje;
    }

    public void setTipoMensaje(String tipoMensaje) {
        this.tipoMensaje = tipoMensaje;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getUsernameAutor() {
        return usernameAutor;
    }

    public void setUsernameAutor(String usernameAutor) {
        this.usernameAutor = usernameAutor;
    }
}
