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
    public class CNCompra
    {
        private CDCompra objCompra = new CDCompra();

        public int ObtenerCorrelativo()
        {
            return objCompra.ObtenerCorrelativo();
        }

        public bool Registrar(Compra obj,DataTable DetalleCompra, out string Mensaje)
        {
            return objCompra.Registrar(obj, DetalleCompra, out Mensaje);  
        }

        public Compra ObtenerCompra(string numero)
        {
            Compra oCompra = objCompra.ObtenerCompra(numero);
            if (oCompra.IdCompra != 0) {
                List<DetalleCompra> oDetalleCompra = objCompra.ObtenerDetalleCompra(oCompra.IdCompra);
                oCompra.oDetalleCompra = oDetalleCompra;
            }
            return oCompra;
        }

    }
}
