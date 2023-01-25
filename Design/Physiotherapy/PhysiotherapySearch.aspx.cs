using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Physiotherapy_PhysiotherapySearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string doctor = Convert.ToString(Session["LoginType"]).ToUpper();
            All_LoadData.BindPanelOPD(ddlPanel);
            All_LoadData.BindPhysioDoctor(ddlDoctor);
            All_LoadData.BindOPDType(ddlOPDType);
            GetDoctor();
            fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtRegNo.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
            txtPName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");

            txtRegNo.Focus();
        }
        fromDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }

    private void GetDoctor()
    {
        if (Convert.ToString(Session["LoginType"]).ToUpper() == "PHYSIOTHERAPY")
        {
            string str = "select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt != null && dt.Rows.Count > 0)
                ddlDoctor.Text = Util.GetString(dt.Rows[0][0]);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    private void Search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT app.PatientID,LedgerTnxNo,app.PatientID MRNo,app.App_ID,app.AppNo,CONCAT(pm.Title,' ',pm.Pname)Pname,CONCAT(dm.Title,'',dm.Name)DName, ");
            sb.Append(" Get_Current_Age(pm.PatientID)Age,app.Sex,DATE_FORMAT(app.date,'%d-%b-%y')AppointmentDate,app.Sex,app.ContactNo,  IF(ISNULL(app.Physiotherapy_ID)=' ','Old Patient','New Patient')  VisitType,TypeOfApp,pmh.TransactionID ,");
            sb.Append(" IF(app.flag = 1,'true','false')Isdone,IF(app.flag = 1,'Closed','Pending')IsCompleated,IF(ISNULL(app.Physiotherapy_ID),'',Physiotherapy_ID)Physiotherapy_ID ");
            sb.Append(" FROM appointment app INNER JOIN patient_master pm ON pm.PatientID=app.PatientID ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=app.TransactionID AND pmh.Type='OPD' INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
            sb.Append("   INNER JOIN (SELECT DoctorID FROM doctor_hospital WHERE department='Physiotherapy' GROUP BY DoctorID)dh  ON dh.DoctorID=app.DoctorID");
            sb.Append(" WHERE app.PatientID<>'' and LedgerTnxNo>'' AND app.IsConform=1 ");

            if (txtPName.Text.Trim() != string.Empty)
                sb.Append(" and app.Pname like '%" + txtPName.Text.Trim() + "%'");
            if (txtRegNo.Text.Trim() != string.Empty)
                sb.Append(" and app.PatientID='" + txtRegNo.Text.Trim() + "'");
            if (ddlDoctor.SelectedIndex > 0)
                sb.Append(" and app.DoctorID='" + ddlDoctor.SelectedValue + "'");

            if (fromDate.Text != string.Empty)
                sb.Append(" and app.date>='" + Util.GetDateTime(fromDate.Text).ToString("yyyy-MM-dd") + "'");
            if (ToDate.Text != string.Empty)
                sb.Append(" and app.date<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");
            if (txtAppNo.Text.Trim() != string.Empty)
                sb.Append(" and app.AppNo=" + txtAppNo.Text.Trim() + "");
            sb.Append(" Order by app.date, app.AppNo");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                grdPatient.DataSource = null;
                grdPatient.DataBind();
                lblMsg.Text = "No Record Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
        }
    }

    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Aview")
        {
            Response.Redirect("~/Design/Physiotherapy/Physiotherapy.aspx" + Convert.ToString(e.CommandArgument));
        }
    }

    protected void grdPatient_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");
            if (Util.GetBoolean(row["IsDone"]))
            {
                e.Row.Attributes.Add("ondblclick", "ShowPatient('" + Util.GetString(row["TransactionID"]) + "');");
                e.Row.BackColor = System.Drawing.Color.Cyan;
            }
        }
    }
}