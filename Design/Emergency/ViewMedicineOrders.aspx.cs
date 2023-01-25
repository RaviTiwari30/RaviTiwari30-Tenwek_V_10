using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Design_Emergency_ViewMedicineOrders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPreMedicine();
        }
    }
    private void bindPreMedicine()
    {
        DataTable med = StockReports.GetDataTable("Select Medicine_ID,NoOfDays,NoTimesDay,Dose,Remarks,DATE_FORMAT(EnteryDate,'%d-%b-%Y %l:%m %p')date,MedicineName Item,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=EntryBy)UserName From patient_medicine   " +
            "  where  TransactionID='" + Request.QueryString["TransactionID"].ToString() + "'  order by date desc");
        if (med.Rows.Count > 0)
        {
            grdPreMedicine.DataSource = med;
            grdPreMedicine.DataBind();

        }
        else
        {
            grdPreMedicine.DataSource = null;
            grdPreMedicine.DataBind();

        }
    }
}