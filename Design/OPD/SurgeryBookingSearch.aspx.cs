using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
public partial class Design_OPD_SurgeryBookingSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPreSurgeryDateFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtPreSurgeryDateTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void Search()
    {
        lblMsg.Text = "";
        DataTable dtSearch = AllLoadData_OPD.SearchPreSurgery(Util.GetString(txtBookingID.Text.Trim()), Util.GetString(txtPID.Text.Trim()), Util.GetDateTime(txtPreSurgeryDateFrom.Text), Util.GetDateTime(txtPreSurgeryDateTo.Text), Util.GetString(txtPname.Text.Trim()),0);
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            grdSurgery.DataSource = dtSearch;
            grdSurgery.DataBind();
            pnlHide.Visible=true;
        }
        else
        {
            pnlHide.Visible = false;
            grdSurgery.DataSource = null;
            grdSurgery.DataBind();
            lblMsg.Text = "Record Not Found";
        }
    }
    protected void presurjeryprint(string PreSurgeryID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(pm.title,' ',pm.pname)pName,fpl.Company_name,pre.StayDays As SurgeryDays,pre.TotalAmt,pre.OtherCharges,pre.surgeryAmount,pre.PatientID PatientID,pm.age,sm.Name,DATE_FORMAT(pre.DATE,'%d-%b-%Y')DATE,");
        sb.Append(" sm.SurgeryCode,pre.PolicyNo,pre.DiagnosisName,pre.ProcedureName,pre.Remark,'' DocName ");
        sb.Append(" FROM PreSurgeryBooking_Summary pre INNER JOIN f_surgery_master sm ON sm.`Surgery_ID`=pre.`SurgeryID`  ");
        sb.Append("  inner join Patient_Master pm on pm.PatientID=pre.PatientID");
        sb.Append(" inner join f_panel_master fpl on fpl.PanelID=pre.PanelID ");
        sb.Append(" WHERE pre.presurgeryid ='" + PreSurgeryID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        string DocName = "";
        DataTable dtDoc = StockReports.GetDataTable("SELECT PreSurgeryID,PatientID,DoctorID,CONCAT(dm.title,' ',dm.name)DoctorName FROM presurgerybooking_doctor pre INNER JOIN doctor_master dm ON pre.DoctorID=dm.DoctorID  WHERE PreSurgeryID='" + PreSurgeryID + "' ");
        if (dtDoc.Rows.Count > 0)
        {

            for (int i = 0; i < dtDoc.Rows.Count; i++)
            {
                if (DocName == "")
                    DocName = dtDoc.Rows[i]["DoctorName"].ToString();
                else if (i == dtDoc.Rows.Count - 1)
                    DocName = DocName + " and " + dtDoc.Rows[i]["DoctorName"].ToString();
                else
                    DocName = DocName + " , " + dtDoc.Rows[i]["DoctorName"].ToString();
            }
        }

        string StrSummary = "SELECT PreSurgeryID,PatientID,ItemID,ItemName,Quantity,if(Amount=0,'Optional',Amount)Amount,Amount Rate   FROM PreSurgeryBooking WHERE PreSurgeryID='" + PreSurgeryID + "'";
        DataTable dtSummary = StockReports.GetDataTable(StrSummary);
        DataTable dtOtherItem = StockReports.GetDataTable("SELECT PreSurgeryID,PatientID,ItemID,ItemName,Quantity,if(Amount=0,'Optional',Amount) As Amount,Rate FROM presurgeryotherItem WHERE PreSurgeryID='" + PreSurgeryID + "' ");

        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc = new DataColumn();
            dc.ColumnName = "UserName";

            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);



            dtSummary.Merge(dtOtherItem, true, MissingSchemaAction.Ignore);

            dt.Rows[0]["DocName"] = DocName;
                      
            dt.TableName = "PreSurgery";
            dtSummary.TableName = "PreSurgery_Summary";
            dtOtherItem.TableName = "SurgeryOtherItem";

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables.Add(dtSummary.Copy());
            ds.Tables.Add(dtOtherItem.Copy());

            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());

            //ds.WriteXmlSchema("E:\\PreSurgery.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "SurgeryEstimate";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

        }

    }

    protected void grdSurgery_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "APrint")
        {
            if (e.CommandArgument.ToString() != "")
            {
                presurjeryprint(e.CommandArgument.ToString());
            }
        }
        if (e.CommandName.ToString() == "ACancel")
        {
            if (e.CommandArgument.ToString() != "")
            {
                mpCancel.Show();
                lblSurgeryID.Text = e.CommandArgument.ToString();
            }
        }
        if (e.CommandName.ToString() == "AEdit")
        {
            if (e.CommandArgument.ToString() != "")
            {
                mpEdit.Show();
                lblEditPreSurgeryID.Text = e.CommandArgument.ToString();
                DataTable dtdetails = StockReports.GetDataTable("Select ProcedureName,DiagnosisName from presurgerybooking_summary where PreSurgeryID=" + lblEditPreSurgeryID.Text.Trim() + "");
                if (dtdetails.Rows.Count > 0)
                {
                    txtProcedure.Text = dtdetails.Rows[0]["ProcedureName"].ToString();
                    txtDiagnosis.Text = dtdetails.Rows[0]["DiagnosisName"].ToString();
                }
            }
        }
    }
    protected void btnReject_Click(object sender, EventArgs e)
    {
        if (lblSurgeryID.Text.Trim() != "" && txtCancelReason.Text.Trim() != "")
        {
            bool IsReject=StockReports.ExecuteDML("Update presurgerybooking_summary set IsRejected=1,RejectDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',RejectBy='" + Session["ID"].ToString() + "' where PreSurgeryID='" + lblSurgeryID.Text.Trim() + "'");
            if (IsReject)
            {
                Search();
                lblMsg.Text = "Surgery Has Been Cancelled";
            }
        }
    }
    protected void btnEdit_Click(object sender, EventArgs e)
    {
        if (lblEditPreSurgeryID.Text.Trim() != "" && txtProcedure.Text.Trim() != "" && txtDiagnosis.Text.Trim()!="")
        {
            bool IsUpdate = StockReports.ExecuteDML("Update presurgerybooking_summary set ProcedureName='" + txtProcedure.Text.Trim() + "',DiagnosisName='" + txtDiagnosis.Text.Trim() + "' where PreSurgeryID='" + lblEditPreSurgeryID.Text.Trim() + "'");
            if (IsUpdate)
            {
                Search();
                lblMsg.Text = "Bill Has Been Updated";
            }
        }
    }
    protected void btnreport_Click(object sender, EventArgs e)
    {
        DataTable dtreport = AllLoadData_OPD.SearchPreSurgery(Util.GetString(txtBookingID.Text.Trim()), Util.GetString(txtPID.Text.Trim()), Util.GetDateTime(txtPreSurgeryDateFrom.Text), Util.GetDateTime(txtPreSurgeryDateTo.Text), Util.GetString(txtPname.Text.Trim()), 0);
        if (dtreport.Rows.Count > 0)
        {
            Session["ReportName"] = "Surgery List";
            Session["CustomData"] = dtreport;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Payroll/CustomReportForExport.aspx');", true);
        }
    }
}