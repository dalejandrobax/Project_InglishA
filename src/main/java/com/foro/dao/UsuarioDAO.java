package com.foro.dao;

import com.foro.bean.Usuario;
import com.foro.utils.MySQLConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public Usuario validarLogin(String user, String pass) {
        Usuario obj = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT * FROM usuario WHERE username = ? AND password = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, user);
            pstm.setString(2, pass);
            rs = pstm.executeQuery();
            if (rs.next()) {
                obj = new Usuario();
                obj.setIdUsuario(rs.getInt("id_usuario"));
                obj.setUsername(rs.getString("username"));
                obj.setNombres(rs.getString("nombres"));
                obj.setApellidos(rs.getString("apellidos"));
                obj.setIdRol(rs.getInt("id_rol"));
                obj.setIdNivel(rs.getObject("id_nivel") != null ? rs.getInt("id_nivel") : null);
                obj.setTipoCuenta(rs.getString("tipo_cuenta"));
                obj.setEstrellas(rs.getInt("estrellas"));
            }
        } catch (SQLException e) {
            System.out.println("Error en Login: " + e.getMessage());
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
        return obj;
    }

    public int registrarUsuario(Usuario u) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO usuario (username, password, nombres, apellidos, id_rol, tipo_cuenta) VALUES (?, ?, ?, ?, 1, 'Gratis')";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, u.getUsername());
            pstm.setString(2, u.getPassword());
            pstm.setString(3, u.getNombres());
            pstm.setString(4, u.getApellidos());
            res = pstm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error en Registro: " + e.getMessage());
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

    public int actualizarNivel(int idUsuario, int idNivel) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET id_nivel = ? WHERE id_usuario = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, idNivel);
            pstm.setInt(2, idUsuario);
            res = pstm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar nivel: " + e.getMessage());
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

    public int sumarEstrellas(int idUsuario, int cantidad) {
        int total = -1;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET estrellas = COALESCE(estrellas, 0) + ? WHERE id_usuario = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, cantidad);
            pstm.setInt(2, idUsuario);
            pstm.executeUpdate();
            pstm.close();
            pstm = null;

            sql = "SELECT estrellas FROM usuario WHERE id_usuario = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, idUsuario);
            rs = pstm.executeQuery();
            if (rs.next()) {
                total = rs.getInt("estrellas");
            }
        } catch (SQLException e) {
            System.out.println("Error al sumar estrellas: " + e.getMessage());
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
        return total;
    }

    public int actualizarTipoCuenta(int idUsuario, String tipoCuenta) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET tipo_cuenta = ? WHERE id_usuario = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, tipoCuenta);
            pstm.setInt(2, idUsuario);
            res = pstm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar tipo de cuenta: " + e.getMessage());
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

    public int actualizarDatosCuenta(int idUsuario, String username, String nombres, String apellidos) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET username = ?, nombres = ?, apellidos = ? WHERE id_usuario = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, username);
            pstm.setString(2, nombres);
            pstm.setString(3, apellidos);
            pstm.setInt(4, idUsuario);
            res = pstm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar datos de cuenta: " + e.getMessage());
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

    public int actualizarPassword(int idUsuario, String passwordActual, String passwordNueva) {
        int res = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET password = ? WHERE id_usuario = ? AND password = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, passwordNueva);
            pstm.setInt(2, idUsuario);
            pstm.setString(3, passwordActual);
            res = pstm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error al actualizar contraseña: " + e.getMessage());
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
}
