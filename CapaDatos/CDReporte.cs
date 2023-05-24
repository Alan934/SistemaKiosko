using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace CapaDatos
{
    public class CDReporte
    {
        public List<ReporteCompra> Compra(string fechaInicio, string fechaFin, int idProveedor)
        {
            List<ReporteCompra> lista = new List<ReporteCompra>();
            using (SqlConnection oconexion = new SqlConnection(Conexion.cadena))
            {
                try
                {
                    StringBuilder query = new StringBuilder();
                    SqlCommand cmd = new SqlCommand("SPREPORTECOMPRAS", oconexion);
                    cmd.Parameters.AddWithValue("FechaInicio", fechaInicio);
                    cmd.Parameters.AddWithValue("FechaFin", fechaFin);
                    cmd.Parameters.AddWithValue("IdProveedor", idProveedor);
                    cmd.CommandType = CommandType.StoredProcedure;
                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new ReporteCompra()
                            {
                                FechaRegistro = dr["FechaRegistro"].ToString(),
                                TipoDocumento = dr["TipoDocumento"].ToString(),
                                NumeroDocumento = dr["NumeroDocumento"].ToString(),
                                MontoTotal = dr["MontoTotal"].ToString(),
                                UsuarioRegistro = dr["UsuarioRegistro"].ToString(),
                                DocumentoProveedor = dr["DocumentoProveedor"].ToString(),
                                RazonSocial = dr["RazonSocial"].ToString(),
                                CodigoProducto = dr["CodigoProducto"].ToString(),
                                NombreProducto = dr["NombreProducto"].ToString(),
                                Categoria = dr["Categoria"].ToString(),
                                PrecioCompra = dr["PrecioCompra"].ToString(),
                                PrecioVenta = dr["PrecioVenta"].ToString(),
                                Cantidad = dr["Cantidad"].ToString(),
                                SubTotal = dr["SubTotal"].ToString(),
                                Ganancia = Convert.ToDecimal(dr["PrecioVenta"]) - Convert.ToDecimal(dr["PrecioCompra"]),
                                GananciaTotal = (Convert.ToDecimal(dr["PrecioVenta"])* Convert.ToDecimal(dr["Cantidad"])) - (Convert.ToDecimal(dr["PrecioCompra"]) * Convert.ToDecimal(dr["Cantidad"]))
                            });
                        }
                    }
                }
                catch (Exception ex)
                {
                    lista = new List<ReporteCompra>();
                }
            }
            return lista;
        }

        public List<ReporteVenta> Venta(string fechainicio, string fechafin)
        {
            List<ReporteVenta> lista = new List<ReporteVenta>();

            using (SqlConnection oconexion = new SqlConnection(Conexion.cadena))
            {
                try
                {
                    StringBuilder query = new StringBuilder();
                    SqlCommand cmd = new SqlCommand("SPREPORTEVENTAS", oconexion);
                    cmd.Parameters.AddWithValue("FechaInicio", fechainicio);
                    cmd.Parameters.AddWithValue("FechaFin", fechafin);
                    cmd.CommandType = CommandType.StoredProcedure;
                    oconexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new ReporteVenta()
                            {
                                FechaRegistro = dr["FechaRegistro"].ToString(),
                                TipoDocumento = dr["TipoDocumento"].ToString(),
                                NumeroDocumento = dr["NumeroDocumento"].ToString(),
                                MontoTotal = dr["MontoTotal"].ToString(),
                                UsuarioRegistro = dr["UsuarioRegistro"].ToString(),
                                DocumentoCliente = dr["DocumentoCliente"].ToString(),
                                NombreCliente = dr["NombreCliente"].ToString(),
                                CodigoProducto = dr["CodigoProducto"].ToString(),
                                NombreProducto = dr["NombreProducto"].ToString(),
                                Categoria = dr["Categoria"].ToString(),
                                PrecioCompra = dr["PrecioCompra"].ToString(),
                                PrecioVenta = dr["PrecioVenta"].ToString(),
                                Cantidad = dr["Cantidad"].ToString(),
                                SubTotal = dr["SubTotal"].ToString(),
                                Ganancia = Convert.ToDecimal(dr["PrecioVenta"]) - Convert.ToDecimal(dr["PrecioCompra"]),
                                GananciaTotal = (Convert.ToDecimal(dr["PrecioVenta"]) * Convert.ToDecimal(dr["Cantidad"])) - (Convert.ToDecimal(dr["PrecioCompra"]) * Convert.ToDecimal(dr["Cantidad"]))
                            });
                        }
                    }
                }
                catch (Exception ex)
                {
                    lista = new List<ReporteVenta>();
                }
            }
            return lista;
        }

        public List<ReporteVenta> ReporteTotal(string fechainicio, string fechafin)
        {
            List<ReporteVenta> lista = new List<ReporteVenta>();

            using (SqlConnection oconexion = new SqlConnection(Conexion.cadena))
            {
                decimal PrecioCompra = 0;
                decimal PrecioVenta = 0;
                decimal Cantidad = 0;
                decimal SubTotal = 0;
                decimal GananciaTotal = 0;
                try
                {
                    StringBuilder query = new StringBuilder();
                    SqlCommand cmd = new SqlCommand("SPREPORTEVENTAS", oconexion);
                    cmd.Parameters.AddWithValue("FechaInicio", fechainicio);
                    cmd.Parameters.AddWithValue("FechaFin", fechafin);
                    cmd.CommandType = CommandType.StoredProcedure;
                    oconexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            string PrecioCompraS = dr["PrecioCompra"].ToString();
                            PrecioCompra += Convert.ToDecimal(PrecioCompraS);
                            string PrecioVentaS = dr["PrecioVenta"].ToString();
                            PrecioVenta += Convert.ToDecimal(PrecioVentaS);
                            string CantidadS = dr["Cantidad"].ToString();
                            Cantidad += Convert.ToDecimal(CantidadS);
                            string SubTotalS = dr["SubTotal"].ToString();
                            SubTotal += Convert.ToDecimal(SubTotalS);
                            string GananciaTotalS = ((Convert.ToDecimal(dr["PrecioVenta"]) * Convert.ToDecimal(dr["Cantidad"])) - (Convert.ToDecimal(dr["PrecioCompra"]) * Convert.ToDecimal(dr["Cantidad"]))).ToString();
                            GananciaTotal += Convert.ToDecimal(GananciaTotalS);
                        }
                    }
                    lista.Add(new ReporteVenta()
                    {
                        PrecioCompra = PrecioCompra.ToString("0.00"),
                        PrecioVenta = PrecioVenta.ToString("0.00"),
                        Cantidad = Cantidad.ToString(),
                        SubTotal = SubTotal.ToString("0.00"),
                        Ganancia = Math.Round((PrecioVenta/Cantidad),2),
                        GananciaTotal = Math.Round((GananciaTotal),2)
                    });
                }
                catch (Exception ex)
                {
                    lista = new List<ReporteVenta>();
                }
            }
            return lista;
        }
    }
}
