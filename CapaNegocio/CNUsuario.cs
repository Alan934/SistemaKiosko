using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaDatos;
using CapaEntidad;

namespace CapaNegocio
{
    public class CNUsuario
    {
        private CDUsuario objcdUsuario = new CDUsuario();

        public List<Usuario> Listar()
        {
            return objcdUsuario.Listar();
        }

        public int Registrar(Usuario obj, out string Mensaje)
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
            if (obj.Clave == "")
            {
                Mensaje += "Es necesario la Clave\n";
            }

            if(Mensaje != string.Empty)
            {
                return 0;
            }
            else
            {
                return objcdUsuario.Registrar(obj, out Mensaje);
            }
        }

        public bool Editar(Usuario obj, out string Mensaje)
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
            if (obj.Clave == "")
            {
                Mensaje += "Es necesario la Clave\n";
            }
            if (Mensaje != string.Empty)
            {
                return false;
            }
            else
            {
                return objcdUsuario.Editar(obj, out Mensaje);
            }
        }

        public bool Eliminar(Usuario obj, out string Mensaje)
        {
            return objcdUsuario.Eliminar(obj, out Mensaje);
        }

    }
}
