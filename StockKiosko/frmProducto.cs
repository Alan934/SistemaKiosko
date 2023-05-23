using CapaEntidad;
using CapaNegocio;
using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
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

namespace StockKiosko
{
    public partial class frmProducto : Form
    {
        public frmProducto()
        {
            InitializeComponent();
        }

        private void frmProducto_Load(object sender, EventArgs e)
        {
            cboCategoria.Items.Add(new OpcionCombo() { Valor = 1, Texto = "Activo" });
            cboCategoria.Items.Add(new OpcionCombo() { Valor = 0, Texto = "No Activo" });
            cboCategoria.DisplayMember = "Texto";
            cboCategoria.ValueMember = "Valor";
            cboCategoria.SelectedIndex = 0;

            List<Categoria> listaCategoria = new CNCategoria().Listar();
            foreach (Categoria item in listaCategoria)
            {
                cboEstado.Items.Add(new OpcionCombo() { Valor = item.IdCategoria, Texto = item.Descripcion });
            }
            cboEstado.DisplayMember = "Texto";
            cboEstado.ValueMember = "Valor";
            cboEstado.SelectedIndex = 0;

            foreach (DataGridViewColumn columna in dvgData.Columns)
            {
                if (columna.Visible == true && columna.Name != "btnSeleccionar")
                {
                    cboBusqueda.Items.Add(new OpcionCombo() { Valor = columna.Name, Texto = columna.HeaderText });
                }
            }
            cboBusqueda.DisplayMember = "Texto";
            cboBusqueda.ValueMember = "Valor";
            cboBusqueda.SelectedIndex = 0;

            //Muestra todos los Productos
            List<Producto> lista = new CNProducto().Listar();
            foreach (Producto item in lista)
            {
                dvgData.Rows.Add(new object[] {
                    "",
                    item.IdProducto,
                    item.Codigo,
                    item.Nombre, 
                    item.Descripcion,
                    item.oCategoria.IdCategoria,
                    item.oCategoria.Descripcion,
                    item.Stock,
                    item.PrecioCompra,
                    item.PrecioVenta,
                    item.Estado == true ? 1 : 0,
                    item.Estado == true ? "Activo" : "No Activo"
                });
            }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            string Mensaje = string.Empty;
            try
            {
                Producto obj = new Producto()
                {
                    IdProducto = Convert.ToInt32(txtId.Text),
                    Codigo = txtCodigo.Text,
                    Nombre = txtNombre.Text,
                    Descripcion = txtDescripcion.Text,
                    oCategoria = new Categoria() { IdCategoria = Convert.ToInt32(((OpcionCombo)cboEstado.SelectedItem).Valor) },
                    Stock = Convert.ToInt32(txtStock.Text),
                    PrecioVenta = Convert.ToDecimal(txtPrecioVenta.Text),
                    PrecioCompra = Convert.ToDecimal(txtPrecioCompra.Text),
                    Estado = Convert.ToInt32(((OpcionCombo)cboCategoria.SelectedItem).Valor) == 1 ? true : false
                };

                if (obj.IdProducto == 0)//Agregar nuevo
                {
                    int idGenerado = new CNProducto().Registrar(obj, out Mensaje);

                    if (idGenerado != 0)
                    {
                        dvgData.Rows.Add(new object[] {
                        "",
                        idGenerado,
                        txtCodigo.Text,
                        txtNombre.Text,
                        txtDescripcion.Text,
                        ((OpcionCombo)cboEstado.SelectedItem).Valor.ToString(),
                        ((OpcionCombo)cboEstado.SelectedItem).Texto.ToString(),
                        txtStock.Text,
                        txtPrecioCompra.Text,
                        txtPrecioVenta.Text,
                        ((OpcionCombo)cboCategoria.SelectedItem).Valor.ToString(),
                        ((OpcionCombo)cboCategoria.SelectedItem).Texto.ToString(),
                        });
                        Limpiar();
                    }
                    else
                    {
                        MessageBox.Show(Mensaje);
                    }
                }
                else//Actualizar
                {
                    bool resultado = new CNProducto().Editar(obj, out Mensaje);
                    if (resultado)
                    {
                        DataGridViewRow row = dvgData.Rows[Convert.ToInt32(txtIndice.Text)];
                        row.Cells["Id"].Value = txtId.Text;
                        row.Cells["Codigo"].Value = txtCodigo.Text;
                        row.Cells["Nombre"].Value = txtNombre.Text;
                        row.Cells["Descripcion"].Value = txtDescripcion.Text;
                        row.Cells["Stock"].Value = txtStock.Text;
                        row.Cells["PrecioVenta"].Value = txtPrecioVenta.Text;
                        row.Cells["PrecioCompra"].Value = txtPrecioCompra.Text;
                        row.Cells["IdCategoria"].Value = ((OpcionCombo)cboEstado.SelectedItem).Valor.ToString();
                        row.Cells["Categoria"].Value = ((OpcionCombo)cboEstado.SelectedItem).Texto.ToString();
                        row.Cells["EstadoValor"].Value = ((OpcionCombo)cboCategoria.SelectedItem).Valor.ToString();
                        row.Cells["Estado"].Value = ((OpcionCombo)cboCategoria.SelectedItem).Texto.ToString();
                        Limpiar();
                    }
                    else
                    {
                        MessageBox.Show(Mensaje);
                    }
                }
            }
            catch
            {
                MessageBox.Show("Asegurese de Tener los campos completos"+Mensaje, "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private void Limpiar()
        {
            txtIndice.Text = "-1";//borarlo luego
            txtId.Text = "0";
            txtCodigo.Text = "";
            txtNombre.Text = "";
            txtDescripcion.Text = "";
            txtStock.Text = "";
            txtPrecioVenta.Text = "";
            txtPrecioCompra.Text = "";
            cboEstado.SelectedIndex = 0;
            cboCategoria.SelectedIndex = 0;
            txtCodigo.Select();
        }

        private void dvgData_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (dvgData.Columns[e.ColumnIndex].Name == "btnSeleccionar")
            {
                int indice = e.RowIndex;
                if (indice >= 0)
                {
                    txtIndice.Text = indice.ToString();//borrar luego
                    txtId.Text = dvgData.Rows[indice].Cells["Id"].Value.ToString();
                    txtCodigo.Text = dvgData.Rows[indice].Cells["Codigo"].Value.ToString();
                    txtNombre.Text = dvgData.Rows[indice].Cells["Nombre"].Value.ToString();
                    txtDescripcion.Text = dvgData.Rows[indice].Cells["Descripcion"].Value.ToString();
                    txtStock.Text = dvgData.Rows[indice].Cells["Stock"].Value.ToString();
                    txtPrecioVenta.Text = dvgData.Rows[indice].Cells["PrecioVenta"].Value.ToString();
                    txtPrecioCompra.Text = dvgData.Rows[indice].Cells["PrecioCompra"].Value.ToString();

                    foreach (OpcionCombo oc in cboEstado.Items)
                    {
                        if (Convert.ToInt32(oc.Valor) == Convert.ToInt32(dvgData.Rows[indice].Cells["IdCategoria"].Value))
                        {
                            int indiceCombo = cboEstado.Items.IndexOf(oc);
                            cboEstado.SelectedIndex = indiceCombo;
                            break;
                        }
                    }

                    foreach (OpcionCombo oc in cboCategoria.Items)
                    {
                        if (Convert.ToInt32(oc.Valor) == Convert.ToInt32(dvgData.Rows[indice].Cells["EstadoValor"].Value))
                        {
                            int indiceCombo = cboCategoria.Items.IndexOf(oc);
                            cboCategoria.SelectedIndex = indiceCombo;
                            break;
                        }
                    }
                }
            }
        }

        private void dvgData_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {
            if (e.RowIndex < 0)
                return;

            if (e.ColumnIndex == 0)
            {
                e.Paint(e.CellBounds, DataGridViewPaintParts.All);
                var w = Properties.Resources.check.Width;
                var h = Properties.Resources.check.Height;
                var x = e.CellBounds.Left + (e.CellBounds.Width - w) / 2;
                var y = e.CellBounds.Top + (e.CellBounds.Height - h) / 2;

                e.Graphics.DrawImage(Properties.Resources.check, new Rectangle(x, y, w, h));
                e.Handled = true;
            }
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(txtId.Text) != 0)
            {
                if (MessageBox.Show("¿Desea Borrar este Producto?", "Mensaje", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    string Mensaje = string.Empty;
                    Producto obj = new Producto()
                    {
                        IdProducto = Convert.ToInt32(txtId.Text),
                    };
                    bool respuesta = new CNProducto().Eliminar(obj, out Mensaje);
                    if (respuesta)
                    {
                        dvgData.Rows.RemoveAt(Convert.ToInt32(txtIndice.Text));
                        Limpiar();
                    }
                    else
                    {
                        MessageBox.Show(Mensaje, "Mensaje", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);
                    }
                }
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

        private void btnLimpiar_Click(object sender, EventArgs e)
        {
            Limpiar();
        }

        private void btnExportar_Click(object sender, EventArgs e)
        {
            if(dvgData.Rows.Count < 1)
            {
                MessageBox.Show("No hay datos para exportar", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
            else
            {
                DataTable dt = new DataTable();
                foreach (DataGridViewColumn columna in dvgData.Columns)
                {
                    if (columna.HeaderText != "" && columna.Visible)
                    {
                        dt.Columns.Add(columna.HeaderText, typeof(string));
                    }
                }
                foreach (DataGridViewRow row in dvgData.Rows)
                {
                    if (row.Visible)
                    {
                        dt.Rows.Add(new object[]
                        {
                            row.Cells[2].Value.ToString(),
                            row.Cells[3].Value.ToString(),
                            row.Cells[4].Value.ToString(),
                            row.Cells[6].Value.ToString(),
                            row.Cells[7].Value.ToString(),
                            row.Cells[8].Value.ToString(),
                            row.Cells[9].Value.ToString(),
                            row.Cells[11].Value.ToString(),
                        });
                    }
                }

                SaveFileDialog saveFile = new SaveFileDialog();
                saveFile.FileName = string.Format("ReporteProducto_{0}.xlsx", DateTime.Now.ToString("ddMMyyyyHHmmss"));
                saveFile.Filter = "Excel Files | *.xlsx";

                if (saveFile.ShowDialog() == DialogResult.OK)
                {
                    try
                    {
                        XLWorkbook wb = new XLWorkbook();
                        var hoja = wb.Worksheets.Add(dt, "Informe");
                        hoja.ColumnsUsed().AdjustToContents();
                        wb.SaveAs(saveFile.FileName);
                        MessageBox.Show("Reporte Generado", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    catch
                    {
                        MessageBox.Show("Error al generar Reporte", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                
            }
        }
    }
}
