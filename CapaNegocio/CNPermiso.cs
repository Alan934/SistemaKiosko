using CapaDatos;
using CapaEntidad;
using System.Collections.Generic;

namespace CapaNegocio
{
    public class CNPermiso
    {

        private CDPermiso objcdPermiso = new CDPermiso();

        public List<Permiso> Listar(int IdUsuario)
        {
            return objcdPermiso.Listar(IdUsuario);
        }
    }
}
