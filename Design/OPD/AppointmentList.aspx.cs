using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_OPD_AppintmentList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAppointmentDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtAppointmentdateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindDoctor(ddlDoctor, "All");
            ViewState["UserID"] = Session["ID"].ToString();
        }
        txtAppointmentdateTo.Attributes.Add("readOnly", "true");
        txtAppointmentDateFrom.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void Search()
    {
        lblMsg.Text = "";
        string DocID = "";
        if (ddlDoctor.SelectedItem.Text != "All")
        {
            DocID = ddlDoctor.SelectedItem.Value;
        }

        DataTable dtSearch = AllLoadData_OPD.SearchAppointment(DocID, Util.GetDateTime(txtAppointmentDateFrom.Text), Util.GetDateTime(txtAppointmentdateTo.Text), "", "1", "", "", "", Session["CentreID"].ToString());
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            grdAppointment.DataSource = dtSearch;
            grdAppointment.DataBind();
        }
        else
        {
            grdAppointment.DataSource = "";
            grdAppointment.DataBind();
            lblMsg.Text = "Record Not Found";

        }
    }
    protected void grdAppointment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "Registration")
        {
            string url = string.Format("../../Design/OPD/Appointmentlist.aspx");
            Response.Redirect("NewPatientRegistration.aspx?App_ID=" + e.CommandArgument.ToString() + "&url=" + url + "");
        }
        if (e.CommandName.ToString() == "GetPayment")
        {
            string url = string.Format("../../Design/OPD/Appointmentlist.aspx");
            Response.Redirect("GetPayment.aspx?App_ID=" + e.CommandArgument.ToString().Split('#')[0] + "&PatientID=" + e.CommandArgument.ToString().Split('#')[1] + "&DoctorID=" + e.CommandArgument.ToString().Split('#')[2] + "&url=" + url + " ");
        }
        if (e.CommandName.ToString() == "Print")
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/OPD/AppointmentSlip.aspx?App_ID=" + Util.GetString(e.CommandArgument) + "');", true);
        }
        if (e.CommandName.ToString() == "Sticker")
        {
            StringBuilder sb = new StringBuilder();
            string TransactionID = e.CommandArgument.ToString();
            sb.Append(" SELECT CONCAT(PLastName,' ',PFirstName)PName,pm.PatientID  AS PatientID, ");
            sb.Append(" '' TransactionID,CONCAT(dm.Title,'',dm.Name)DName,DATE_FORMAT(pm.DOB,'%d-%b-%Y')DOB,'' AdmitDate, ");
            sb.Append(" CONCAT(pm.Age,' / ',pm.Gender)AgeSex, pmh.DoctorID FROM patient_medical_history pmh INNER JOIN ");
            sb.Append(" patient_master pm ON pm.PatientID=pmh.PatientID INNER JOIN doctor_master dm ");
            sb.Append(" ON dm.DoctorID=pmh.DoctorID where TransactionID='" + TransactionID + "' ");


            DataTable dt = StockReports.GetDataTable(sb.ToString());
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;

            Session["ReportName"] = "Sticker";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
        }
    }
    protected void grdAppointment_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (((Label)e.Row.FindControl("lblPatientID")).Text != "")
            {
                ((Button)e.Row.FindControl("btnRegistration")).Enabled = false;
                ((Button)e.Row.FindControl("btnPayment")).Enabled = true;
                ((Button)e.Row.FindControl("btnRegistration")).BackColor = System.Drawing.Color.DimGray;


                ((ImageButton)e.Row.FindControl("imgbtnSticker")).Visible = false;

                e.Row.BackColor = System.Drawing.Color.LimeGreen;
            }
            else
            {
                ((Button)e.Row.FindControl("btnRegistration")).Enabled = true;
                ((Button)e.Row.FindControl("btnPayment")).Enabled = false;
                ((Button)e.Row.FindControl("btnPayment")).BackColor = System.Drawing.Color.DimGray;
                ((ImageButton)e.Row.FindControl("imgbtnSticker")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                e.Row.BackColor = System.Drawing.Color.White;
            }
            if (((Label)e.Row.FindControl("lblLedgerTnxNo")).Text != "")
            {
                ((Button)e.Row.FindControl("btnPayment")).Enabled = false;
                ((Button)e.Row.FindControl("btnRegistration")).Enabled = false;
                ((Button)e.Row.FindControl("btnRegistration")).BackColor = System.Drawing.Color.DimGray;
                ((Button)e.Row.FindControl("btnPayment")).BackColor = System.Drawing.Color.DimGray;
                ((ImageButton)e.Row.FindControl("imgbtnSticker")).Visible = true;
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }


        }
    }
}