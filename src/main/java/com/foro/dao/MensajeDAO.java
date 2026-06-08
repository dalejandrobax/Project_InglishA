package com.foro.dao;

import com.foro.bean.Mensaje;
import com.foro.utils.MySQLConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MensajeDAO {

    public List<Mensaje> listarMensajesPorNivel(int idNivel) {
        List<Mensaje> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT m.*, u.username FROM mensaje m "
                    + "JOIN usuario u ON m.id_usuario = u.id_usuario "
                    + "WHERE m.id_nivel = ? ORDER BY m.fecha_registro ASC";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, idNivel);
            rs = pstm.executeQuery();
            while (rs.next()) {
                Mensaje m = new Mensaje();
                m.setIdMensaje(rs.getInt("id_mensaje"));
                m.setIdUsuario(rs.getInt("id_usuario"));
                m.setIdNivel(rs.getInt("id_nivel"));
                m.setTipoMensaje(rs.getString("tipo_mensaje"));
                m.setContenido(rs.getString("contenido"));
                m.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                m.setUsernameAutor(rs.getString("username"));
                lista.add(m);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar mensajes: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstm != null) {
                    pstm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
            }
        }
        return lista;
    }

    public int registrarMensaje(Mensaje m) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO mensaje (id_usuario, id_nivel, tipo_mensaje, contenido) VALUES (?, ?, ?, ?)";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, m.getIdUsuario());
            pstm.setInt(2, m.getIdNivel());
            pstm.setString(3, m.getTipoMensaje());
            pstm.setString(4, m.getContenido());
            res = pstm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al registrar mensaje: " + e.getMessage());
        } finally {
            try {
                if (pstm != null) {
                    pstm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
            }
        }
        return res;
    }

    public int registrarCorreccion(int idMensaje, String explicacion) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO correccion (id_mensaje, texto_corregido, explicacion_errores) VALUES (?, NULL, ?) "
                    + "ON DUPLICATE KEY UPDATE explicacion_errores = VALUES(explicacion_errores)";

            pstm = con.prepareStatement(sql);
            pstm.setInt(1, idMensaje);
            pstm.setString(2, explicacion);

            res = pstm.executeUpdate();
            System.out.println("Corrección guardada? filas=" + res + " para idMensaje=" + idMensaje);

        } catch (SQLException e) {
            System.out.println("Error al guardar corrección: " + e.getMessage());
        } finally {
            try {
                if (pstm != null) {
                    pstm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
            }
        }
        return res;
    }

    public String obtenerCorreccion(int idMensaje) {
        String resultado = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT explicacion_errores FROM correccion WHERE id_mensaje = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, idMensaje);
            rs = pstm.executeQuery();
            if (rs.next()) {
                resultado = rs.getString("explicacion_errores");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener corrección: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstm != null) {
                    pstm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
            }
        }
        return resultado;
    }

    public int registrarMensajeRetornarId(Mensaje m) {
        int idGenerado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            con = MySQLConexion.getConexion();

            String sql = "INSERT INTO mensaje (id_usuario, id_nivel, tipo_mensaje, contenido) VALUES (?, ?, ?, ?)";

            pstm = con.prepareStatement(sql, new String[]{"id_mensaje"});

            pstm.setInt(1, m.getIdUsuario());
            pstm.setInt(2, m.getIdNivel());
            pstm.setString(3, m.getTipoMensaje());
            pstm.setString(4, m.getContenido());

            int filas = pstm.executeUpdate();
            System.out.println("Filas insertadas mensaje: " + filas);

            rs = pstm.getGeneratedKeys();
            if (rs != null && rs.next()) {
                idGenerado = rs.getInt(1);
            }

            System.out.println("ID generado mensaje: " + idGenerado);

        } catch (SQLException e) {
            System.out.println("Error al registrar mensaje con ID: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstm != null) {
                    pstm.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
            }
        }

        return idGenerado;
    }
}
