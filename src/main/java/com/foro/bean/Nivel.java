package com.foro.bean;

public class Nivel {

    private int idNivel;
    private String nombre;

    public Nivel() {
    }

    public Nivel(int idNivel, String nombre) {
        this.idNivel = idNivel;
        this.nombre = nombre;
    }

    public int getIdNivel() {
        return idNivel;
    }

    public void setIdNivel(int idNivel) {
        this.idNivel = idNivel;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}
