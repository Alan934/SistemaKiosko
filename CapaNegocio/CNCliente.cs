using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CNCliente
    {
        private CDCliente objcdCliente = new CDCliente();

        public List<Cliente> Listar()
        {
            return objcdCliente.Listar();
        }

        public int Registrar(Cliente obj, out string Mensaje)
        {
            Mensaje = string.Empty;
            if (obj.Documento == "")
            {
                Mensaje += "Es necesario el Documento\n";
            }
            if (obj.NombreCompleto == "")
            {
                Mensaje += "Es necesario el Nombre Completo\n";
            }

            if (Mensaje != string.Empty)
            {
                return 0;
            }
            else
            {
                return objcdCliente.Registrar(obj, out Mensaje);
            }
        }

        public bool Editar(Cliente obj, out string Mensaje)
        {
            Mensaje = string.Empty;
            if (obj.Documento == "")
            {
                Mensaje += "Es necesario el Documento\n";
            }
            if (obj.NombreCompleto == "")
            {
                Mensaje += "Es necesario el Nombre Completo\n";
            }
            if (Mensaje != string.Empty)
            {
                return false;
            }
            else
            {
                return objcdCliente.Editar(obj, out Mensaje);
            }
        }

        public bool Eliminar(Cliente obj, out string Mensaje)
        {
            return objcdCliente.Eliminar(obj, out Mensaje);
        }
    }
}
