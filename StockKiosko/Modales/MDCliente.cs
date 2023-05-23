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
    public partial class MDCliente : Form
    {

        public Cliente _Cliente { get; set; }
        public MDCliente()
        {
            InitializeComponent();
        }

        private void MDCliente_Load(object sender, EventArgs e)
        {
            foreach (DataGridViewColumn columna in dvgData.Columns)
            {
                cboBusqueda.Items.Add(new OpcionCombo() { Valor = columna.Name, Texto = columna.HeaderText });
            }
            cboBusqueda.DisplayMember = "Texto";
            cboBusqueda.ValueMember = "Valor";
            cboBusqueda.SelectedIndex = 0;
            List<Cliente> lista = new CNCliente().Listar();
            foreach (Cliente item in lista)
            {
                if(item.Estado)
                    dvgData.Rows.Add(new object[] { item.Documento, item.NombreCompleto});
            }
        }

        private void dvgData_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int iRow = e.RowIndex;
            int iCol = e.ColumnIndex;
            if (iRow >= 0 && iCol >= 0)
            {
                _Cliente = new Cliente()
                {
                    Documento = dvgData.Rows[iRow].Cells["Documento"].Value.ToString(),
                    NombreCompleto = dvgData.Rows[iRow].Cells["NombreCompleto"].Value.ToString(),
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
