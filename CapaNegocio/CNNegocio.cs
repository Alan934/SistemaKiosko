using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CNNegocio
    {

        private CDNegocio objcdNegocio = new CDNegocio();

        public Negocio ObtenerDatos()
        {
            return objcdNegocio.ObtenerDatos();
        }

        public bool GuardarDatos(Negocio obj, out string Mensaje)
        {
            Mensaje = string.Empty;
            if (obj.Nombre == "")
            {
                Mensaje += "Es necesario el Nombre\n";
            }
            if (obj.RUC == "")
            {
                Mensaje += "Es necesario el R.U.C\n";
            }
            if (obj.Direccion == "")
            {
                Mensaje += "Es necesario la Direccion\n";
            }

            if (Mensaje != string.Empty)
            {
                return false;
            }
            else
            {
                return objcdNegocio.GuardarDatos(obj, out Mensaje);
            }
        }

        public byte[] ObtenerLogo(out bool obtenido)
        {
            return objcdNegocio.ObtenerLogo(out obtenido);
        }

        public bool ActualizarLogo(byte[] imagen, out string mensaje)
        {
            return objcdNegocio.ActualizarLogo(imagen, out mensaje);
        }

    }
}
