package com.foro.bean;

public class Correccion {

    private int idCorreccion;
    private int idMensaje;
    private String textoCorregido;
    private String explicacionErrores;

    public Correccion() {
    }

    public int getIdCorreccion() {
        return idCorreccion;
    }

    public void setIdCorreccion(int idCorreccion) {
        this.idCorreccion = idCorreccion;
    }

    public int getIdMensaje() {
        return idMensaje;
    }

    public void setIdMensaje(int idMensaje) {
        this.idMensaje = idMensaje;
    }

    public String getTextoCorregido() {
        return textoCorregido;
    }

    public void setTextoCorregido(String textoCorregido) {
        this.textoCorregido = textoCorregido;
    }

    public String getExplicacionErrores() {
        return explicacionErrores;
    }

    public void setExplicacionErrores(String explicacionErrores) {
        this.explicacionErrores = explicacionErrores;
    }
}
