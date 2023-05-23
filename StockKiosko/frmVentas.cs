using CapaEntidad;
using CapaNegocio;
using StockKiosko.Modales;
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
    public partial class frmVentas : Form
    {
        private Usuario _Usuario;
        public frmVentas(Usuario oUsuario = null)
        {
            _Usuario = oUsuario;
            InitializeComponent();
        }

        private void frmVentas_Load(object sender, EventArgs e)
        {
            txtCodigoProducto.Select();
            cboTipoDocumento.Items.Add(new OpcionCombo() { Valor = "Efectivo", Texto = "Efectivo" });
            cboTipoDocumento.Items.Add(new OpcionCombo() { Valor = "Tarjeta", Texto = "Tarjeta" });
            cboTipoDocumento.Items.Add(new OpcionCombo() { Valor = "MercadoPago", Texto = "Mercado Pago" });
            cboTipoDocumento.DisplayMember = "Texto";
            cboTipoDocumento.ValueMember = "Valor";
            cboTipoDocumento.SelectedIndex = 0;

            txtFecha.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtIdProducto.Text = "0";
            txtPagaCon.Text = "";
            txtTotalPagar.Text = "0";
            txtCambio.Text = "";
        }

        private void btnBuscarCliente_Click(object sender, EventArgs e)
        {
            using (var modal = new MDCliente())
            {
                var result = modal.ShowDialog();
                if (result == DialogResult.OK)
                {
                    txtDocCliente.Text = modal._Cliente.Documento;
                    txtNombreCliente.Text = modal._Cliente.NombreCompleto;
                    txtCodigoProducto.Select();
                }
                else
                {
                    txtDocCliente.Select();
                }
            }
        }

        private void btnBuscarCodigoProducto_Click(object sender, EventArgs e)
        {
            using (var modal = new MDProducto())
            {
                var result = modal.ShowDialog();
                if (result == DialogResult.OK)
                {
                    txtIdProducto.Text = modal._Producto.IdProducto.ToString();
                    txtCodigoProducto.Text = modal._Producto.Codigo;
                    txtProducto.Text = modal._Producto.Nombre;
                    txtPrecioCompra.Text = modal._Producto.PrecioCompra.ToString("0.00");
                    txtPrecioProducto.Text = modal._Producto.PrecioVenta.ToString("0.00");
                    txtStock.Text = modal._Producto.Stock.ToString();
                    txtCantidad.Select();
                }
                else
                {
                    txtCodigoProducto.Select();
                }
            }
        }

        private void txtCodigoProducto_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyData == Keys.Enter)
            {
                Producto oProducto = new CNProducto().Listar().Where(p => p.Codigo == txtCodigoProducto.Text && p.Estado == true).FirstOrDefault();

                if (oProducto != null)
                {
                    txtCodigoProducto.BackColor = Color.Honeydew;
                    txtIdProducto.Text = oProducto.IdProducto.ToString();
                    txtProducto.Text = oProducto.Nombre;
                    txtPrecioCompra.Text = oProducto.PrecioCompra.ToString("0.00");
                    txtPrecioProducto.Text = oProducto.PrecioVenta.ToString("0.00");
                    txtStock.Text = oProducto.Stock.ToString();
                    txtCantidad.Select();
                }
                else
                {
                    txtCodigoProducto.BackColor = Color.MistyRose;
                    txtIdProducto.Text = "0";
                    txtProducto.Text = "";
                    txtPrecioCompra.Text = "";
                    txtPrecioProducto.Text = "";
                    txtStock.Text = "";
                    txtCantidad.Value = 1;
                }
            }
        }

        private void btnAgregarProducto_Click(object sender, EventArgs e)
        {
            try
            {
                decimal precio = 0;
                bool productoExiste = false;
                decimal precioCompra = 0;
                if (!decimal.TryParse(txtPrecioCompra.Text, out precioCompra))
                {
                    MessageBox.Show("Precio Compra - Formato Moneda Incorrecto (Ta feo este error)", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }                

                if (int.Parse(txtIdProducto.Text) == 0)
                {
                    MessageBox.Show("Debe Seleccionar un Producto", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                if (!decimal.TryParse(txtPrecioProducto.Text, out precio))
                {
                    MessageBox.Show("Precio Producto - Formato Moneda Incorrecto", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    txtPrecioProducto.Select();
                    return;
                }

                if (Convert.ToInt32(txtStock.Text) < Convert.ToInt32(txtCantidad.Value.ToString()))
                {
                    MessageBox.Show("La cantidad no puede ser mayor al stock", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }

                foreach (DataGridViewRow fila in dgvData.Rows)
                {
                    if (fila.Cells["IdProducto"].Value.ToString() == txtIdProducto.Text)
                    {
                        productoExiste = true;
                        break;
                    }
                }

                if (!productoExiste)
                {
                    bool respuesta = new CNVenta().RestarStock(Convert.ToInt32(txtIdProducto.Text), Convert.ToInt32(txtCantidad.Value.ToString()));

                    if (respuesta)
                    {
                        dgvData.Rows.Add(new object[]
                        {
                        txtIdProducto.Text,
                        txtProducto.Text,
                        precioCompra.ToString("0.00"),
                        precio.ToString("0.00"),
                        txtCantidad.Value.ToString(),
                        (txtCantidad.Value * precio).ToString("0.00")
                        });
                        CalcularTotal();
                        CalcularCambio();
                        Limpiar();
                        txtCodigoProducto.Select();
                    }
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(Convert.ToString(ex), "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }

        }

        private void CalcularTotal()
        {
            decimal total = 0;
            if (dgvData.Rows.Count > 0)
            {
                foreach (DataGridViewRow row in dgvData.Rows)
                {
                    total += Convert.ToDecimal(row.Cells["SubTotal"].Value.ToString());
                }
            }
            txtTotalPagar.Text = total.ToString("0.00");
        }

        private void Limpiar()
        {
            txtIdProducto.Text = "0";
            txtCodigoProducto.Text = "";
            txtProducto.Text = "";
            txtPrecioCompra.Text = "";
            txtPrecioProducto.Text = "";
            txtStock.Text = "";
            txtCantidad.Value = 1;
        }

        private void txtPrecioProducto_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (Char.IsDigit(e.KeyChar))
            {
                e.Handled = false;
            }
            else
            {
                if (txtPrecioProducto.Text.Trim().Length == 0 && e.KeyChar.ToString() == ".")
                {
                    e.Handled = true;
                }
                else
                {
                    if (char.IsControl(e.KeyChar) || e.KeyChar.ToString() == ".")
                    {
                        e.Handled = false;
                    }
                    else
                    {
                        e.Handled = true;
                    }
                }
            }
        }

        private void txtPagaCon_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (Char.IsDigit(e.KeyChar))
            {
                e.Handled = false;
            }
            else
            {
                if (txtPagaCon.Text.Trim().Length == 0 && e.KeyChar.ToString() == ".")
                {
                    e.Handled = true;
                }
                else
                {
                    if (char.IsControl(e.KeyChar) || e.KeyChar.ToString() == ".")
                    {
                        e.Handled = false;
                    }
                    else
                    {
                        e.Handled = true;
                    }
                }
            }
        }

        private void CalcularCambio()
        {
            if(txtTotalPagar.Text.Trim() == "")
            {
                MessageBox.Show("No existen productos en la Venta", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            decimal pagaCon;
            decimal total = Convert.ToDecimal(txtTotalPagar.Text);

            if(txtPagaCon.Text.Trim() == "")
            {
                txtPagaCon.Text = "0";
            }

            if(decimal.TryParse(txtPagaCon.Text.Trim(), out pagaCon))
            {
                if(pagaCon < total)
                {
                    txtCambio.Text = "0.00";
                }
                else
                {
                    decimal cambio = pagaCon - total;
                    txtCambio.Text = cambio.ToString("0.00");
                }
            }
        }

        private void txtPagaCon_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.KeyData == Keys.Enter)
            {
                CalcularCambio();
            }
        }

        private void dgvData_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {
            if (dgvData.Columns[e.ColumnIndex].Name == "btnEliminar")
            {
                int indice = e.RowIndex;
                if (indice >= 0)
                {
                    bool respuesta = new CNVenta().SumarStock(
                        Convert.ToInt32(dgvData.Rows[indice].Cells["IdProducto"].Value.ToString()),
                        Convert.ToInt32(dgvData.Rows[indice].Cells["Cantidad"].Value.ToString()));
                    if (respuesta)
                    {
                        dgvData.Rows.RemoveAt(indice);
                        CalcularTotal();
                        CalcularCambio();
                    }
                }
            }
        }

        private void dgvData_CellPainting_1(object sender, DataGridViewCellPaintingEventArgs e)
        {
            if (e.RowIndex < 0)
                return;

            if (e.ColumnIndex == 5)
            {
                e.Paint(e.CellBounds, DataGridViewPaintParts.All);
                var w = Properties.Resources.delete.Width;
                var h = Properties.Resources.delete.Height;
                var x = e.CellBounds.Left + (e.CellBounds.Width - w) / 2;
                var y = e.CellBounds.Top + (e.CellBounds.Height - h) / 2;

                e.Graphics.DrawImage(Properties.Resources.delete, new Rectangle(x, y, w, h));
                e.Handled = true;
            }
        }

        private void btnRegistrar_Click(object sender, EventArgs e)
        {
            /*if(txtDocCliente.Text == "")
            {
                MessageBox.Show("Debe ingresar documento del cliente", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }
            if (txtNombreCliente.Text == "")
            {
                MessageBox.Show("Debe ingresar Nombre del cliente", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }*/
            if(dgvData.Rows.Count < 1)
            {
                MessageBox.Show("Debe ingresar Productos en la Venta", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }
            DataTable DetalleVenta = new DataTable();
            DetalleVenta.Columns.Add("IdProducto", typeof(int));
            DetalleVenta.Columns.Add("PrecioCompra", typeof(decimal));
            DetalleVenta.Columns.Add("PrecioVenta", typeof(decimal));
            DetalleVenta.Columns.Add("Cantidad", typeof(int));
            DetalleVenta.Columns.Add("SubTotal", typeof(decimal));

            foreach(DataGridViewRow row in dgvData.Rows)
            {
                DetalleVenta.Rows.Add(new object[]
                {
                    row.Cells["IdProducto"].Value.ToString(),
                    row.Cells["PrecioCompra"].Value.ToString(),
                    row.Cells["Precio"].Value.ToString(),
                    row.Cells["Cantidad"].Value.ToString(),
                    row.Cells["SubTotal"].Value.ToString(),
                });
            }

            int idCorrelativo = new CNVenta().ObtenerCorrelativo();
            string numeroDocumento = string.Format("{0:000000}", idCorrelativo);
            CalcularCambio();

            Venta oVenta = new Venta() { 
                oUsuario = new Usuario() { IdUsuario = _Usuario.IdUsuario},
                TipoDocumento = ((OpcionCombo)cboTipoDocumento.SelectedItem).Texto,
                NumeroDocumento = numeroDocumento,
                DocumentoCliente = txtDocCliente.Text,
                NombreCliente = txtNombreCliente.Text,
                MontoPago = Convert.ToDecimal(txtPagaCon.Text),
                MontoCambio = Convert.ToDecimal(txtCambio.Text),
                MontoTotal = Convert.ToDecimal(txtTotalPagar.Text),
            };

            string mensaje = string.Empty;
            bool respuesta = new CNVenta().Registrar(oVenta, DetalleVenta, out mensaje);

            if (respuesta)
            {
                var result = MessageBox.Show("Numero de venta generado:\n" + numeroDocumento + "\n\n¿Desea copiar al portapapeles?", "Mensaje",
                    MessageBoxButtons.YesNo, MessageBoxIcon.Information);
                if (result == DialogResult.Yes)
                    Clipboard.SetText(numeroDocumento);

                txtDocCliente.Text = "";
                txtNombreCliente.Text = "";
                dgvData.Rows.Clear();
                CalcularTotal();
                txtPagaCon.Text = "";
                txtCambio.Text = "";
            }
            else
            {
                MessageBox.Show(mensaje, "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
    }
}
