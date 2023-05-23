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
    public partial class MDProveedor : Form
    {
        public Proveedor _Proveedor { get; set; }
        public MDProveedor()
        {
            InitializeComponent();
        }

        private void MDProveedor_Load(object sender, EventArgs e)
        {

            foreach (DataGridViewColumn columna in dvgData.Columns)
            {
                if (columna.Visible == true)
                {
                    cboBusqueda.Items.Add(new OpcionCombo() { Valor = columna.Name, Texto = columna.HeaderText });
                }
            }
            cboBusqueda.DisplayMember = "Texto";
            cboBusqueda.ValueMember = "Valor";
            cboBusqueda.SelectedIndex = 0;

            List<Proveedor> lista = new CNProveedor().Listar();
            foreach (Proveedor item in lista)
            {
                dvgData.Rows.Add(new object[] {item.IdProveedor, item.Documento, item.RazonSocial});
            }
        }

        private void dvgData_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int iRow = e.RowIndex;
            int iCol = e.ColumnIndex;
            if(iRow >= 0 && iCol > 0)
            {
                _Proveedor = new Proveedor()
                {
                    IdProveedor = Convert.ToInt32(dvgData.Rows[iRow].Cells["id"].Value.ToString()),
                    Documento = dvgData.Rows[iRow].Cells["Documento"].Value.ToString(),
                    RazonSocial = dvgData.Rows[iRow].Cells["RazonSocial"].Value.ToString()
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
