using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CNVenta
    {
        private CDVenta objVenta = new CDVenta();

        public bool RestarStock(int idProducto, int cantidad)
        {
            return objVenta.RestarStock(idProducto, cantidad);
        }

        public bool SumarStock(int idProducto, int cantidad)
        {
            return objVenta.SumarStock(idProducto, cantidad);
        }

        public int ObtenerCorrelativo()
        {
            return objVenta.ObtenerCorrelativo();
        }

        public bool Registrar(Venta obj, DataTable DetalleVenta, out string Mensaje)
        {
            return objVenta.Registrar(obj, DetalleVenta, out Mensaje);
        }

        public Venta ObtenerVenta(string numero)
        {
            Venta oVenta = objVenta.ObtenerVenta(numero);
            if(oVenta.IdVenta != 0)
            {
                List<DetalleVenta> oDetalleVenta = objVenta.ObtenerDetalleVenta(oVenta.IdVenta);
                oVenta.oDetalleVenta = oDetalleVenta;
            }
            return oVenta;
        }
    }
}
