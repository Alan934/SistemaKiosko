using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CNReporte
    {
        private CDReporte objReporte = new CDReporte();

        public List<ReporteCompra> Compra(string fechaInicio, string fechaFin, int idProveedor)
        {
            return objReporte.Compra(fechaInicio, fechaFin, idProveedor);
        }

        public List<ReporteVenta> Venta(string fechaInicio, string fechaFin)
        {
            return objReporte.Venta(fechaInicio, fechaFin);
        }

    }
}
