using CapaEntidad;
using CapaNegocio;
using StockKiosko.Utilidades;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace StockKiosko.Modales
{
    public partial class MDProducto : Form
    {

        public Producto _Producto { get; set; }
        public MDProducto()
        {
            InitializeComponent();
        }

        private void MDProducto_Load(object sender, EventArgs e)
        {
            txtBusqueda.Select();
            foreach (DataGridViewColumn columna in dvgData.Columns)
            {
                if (columna.Visible == true)
                {
                    cboBusqueda.Items.Add(new OpcionCombo() { Texto = columna.HeaderText, Valor = columna.Name });
                }
            }
            cboBusqueda.DisplayMember = "Texto";
            cboBusqueda.ValueMember = "Valor";
            cboBusqueda.SelectedIndex = 1;

            List<Producto> lista = new CNProducto().Listar();
            foreach (Producto item in lista)
            {
                dvgData.Rows.Add(new object[] {
                    item.IdProducto,
                    item.Codigo,
                    item.Nombre,
                    item.oCategoria.Descripcion,
                    item.Stock,
                    item.PrecioCompra,
                    item.PrecioVenta
                });
            }
        }

        private void dvgData_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int iRow = e.RowIndex;
            int iCol = e.ColumnIndex;
            if (iRow >= 0 && iCol > 0)
            {
                _Producto = new Producto()
                {
                    IdProducto = Convert.ToInt32(dvgData.Rows[iRow].Cells["id"].Value.ToString()),
                    Codigo = dvgData.Rows[iRow].Cells["Codigo"].Value.ToString(),
                    Nombre = dvgData.Rows[iRow].Cells["Nombre"].Value.ToString(),
                    Stock = Convert.ToInt32(dvgData.Rows[iRow].Cells["Stock"].Value.ToString()),
                    PrecioCompra = Convert.ToDecimal(dvgData.Rows[iRow].Cells["PrecioCompra"].Value.ToString()),
                    PrecioVenta = Convert.ToDecimal(dvgData.Rows[iRow].Cells["PrecioVenta"].Value.ToString())
                };
                this.DialogResult = DialogResult.OK;
                this.Close();
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            string columnaFiltro = ((OpcionCombo)cboBusqueda.SelectedItem).Valor.ToString();

            if (dvgData.Rows.Count > 0)
            {
                foreach (DataGridViewRow row in dvgData.Rows)
                {
                    if (row.Cells[columnaFiltro].Value.ToString().Trim().ToUpper().Contains(txtBusqueda.Text.Trim().ToUpper()))
                    {
                        row.Visible = true;
                    }
                    else
                    {
                        row.Visible = false;
                    }
                }
            }
        }

        private void btnLimpiarBuscador_Click(object sender, EventArgs e)
        {
            txtBusqueda.Text = "";
            foreach (DataGridViewRow row in dvgData.Rows)
            {
                row.Visible = true;
            }
        }
    }
}
