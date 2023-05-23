using CapaEntidad;
using CapaNegocio;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace StockKiosko
{
    public partial class frmDetalleCompra : Form
    {
        public frmDetalleCompra()
        {
            InitializeComponent();
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            Compra oCompra = new CNCompra().ObtenerCompra(txtBusqueda.Text);
            if(oCompra.IdCompra != 0)
            {
                txtNumeroDocumento.Text = oCompra.NumeroDocumento;
                txtFecha.Text = oCompra.FechaRegistro;
                txtTipoDocumento.Text = oCompra.TipoDocumento;
                txtUsuario.Text = oCompra.oUsuario.NombreCompleto;
                txtDocProveedor.Text = oCompra.oProveedor.Documento;
                txtNombreProveedor.Text = oCompra.oProveedor.RazonSocial;
                dgvData.Rows.Clear();
                foreach(DetalleCompra dc in oCompra.oDetalleCompra)
                {
                    dgvData.Rows.Add(new object[] { dc.oProducto.Nombre, dc.PrecioCompra, dc.Cantidad, dc.MontoTotal });
                }
                txtTotalPagar.Text = oCompra.MontoTotal.ToString("0.00");
            }
        }

        private void btnBorrar_Click(object sender, EventArgs e)
        {
            txtFecha.Text = "";
            txtTipoDocumento.Text = "";
            txtUsuario.Text = "";
            txtDocProveedor.Text = "";
            txtNombreProveedor.Text = "";
            dgvData.Rows.Clear();
            txtTotalPagar.Text = "0.00";
        }

        private void btnDescargar_Click(object sender, EventArgs e)
        {
            if(txtTipoDocumento.Text == "")
            {
                MessageBox.Show("No se encontraron resultados, Complete campos", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            string TextoHtml = Properties.Resources.PlantillaCompra.ToString();
            Negocio oDatos = new CNNegocio().ObtenerDatos();

            TextoHtml = TextoHtml.Replace("@nombrenegocio", oDatos.Nombre.ToUpper());
            TextoHtml = TextoHtml.Replace("@docnegocio", oDatos.RUC);
            TextoHtml = TextoHtml.Replace("@direcnegocio", oDatos.Direccion);

            TextoHtml = TextoHtml.Replace("@tipodocumento", txtTipoDocumento.Text.ToUpper());
            TextoHtml = TextoHtml.Replace("@numerodocumento", txtNumeroDocumento.Text);

            TextoHtml = TextoHtml.Replace("@docproveedor", txtDocProveedor.Text);
            TextoHtml = TextoHtml.Replace("@nombreproveedor", txtNombreProveedor.Text);
            TextoHtml = TextoHtml.Replace("@fecharegistro", txtFecha.Text);
            TextoHtml = TextoHtml.Replace("@usuarioregistro", txtUsuario.Text);

            string filas = string.Empty;
            foreach(DataGridViewRow row in dgvData.Rows)
            {
                filas += "<tr>";
                filas += "<td>" + row.Cells["Producto"].Value.ToString() + "</td>";
                filas += "<td>" + row.Cells["PrecioCompra"].Value.ToString() + "</td>";
                filas += "<td>" + row.Cells["Cantidad"].Value.ToString() + "</td>";
                filas += "<td>" + row.Cells["SubTotal"].Value.ToString() + "</td>";
                filas += "</tr>";
            }
            TextoHtml = TextoHtml.Replace("@filas", filas);
            TextoHtml = TextoHtml.Replace("@montototal", txtTotalPagar.Text);

            SaveFileDialog saveFile = new SaveFileDialog();
            saveFile.FileName = string.Format("Compra_{0}.pdf", txtNumeroDocumento.Text);
            saveFile.Filter = "Pdf Files|*.pdf";

            if (saveFile.ShowDialog() == DialogResult.OK)
            {
                using (FileStream stream = new FileStream(saveFile.FileName, FileMode.Create))
                {
                    Document pdfDoc = new Document(PageSize.A4,25,25,25,25);
                    PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
                    pdfDoc.Open();

                    bool obtenido = true;
                    byte[] byteImage = new CNNegocio().ObtenerLogo(out obtenido);

                    if (obtenido)
                    {
                        iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(byteImage);
                        img.ScaleToFit(60, 60);
                        img.Alignment = iTextSharp.text.Image.UNDERLYING;
                        img.SetAbsolutePosition(pdfDoc.Left, pdfDoc.GetTop(51));
                        pdfDoc.Add(img);
                    }
                    using (StringReader sr = new StringReader(TextoHtml))
                    {
                        XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
                    }
                    pdfDoc.Close();
                    stream.Close();
                    MessageBox.Show("Documento Generado", "Mensaje", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }
    }
}
