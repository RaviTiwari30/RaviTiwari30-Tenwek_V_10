using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Machine_MachineReading : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            Machine objMac = new Machine();
            ddlMachine.DataSource = objMac.MachineList(Util.GetInt(Session["CentreID"].ToString()));
            ddlMachine.DataValueField = "MachineID";
            ddlMachine.DataTextField = "MachineName";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("ALL", "0"));

        }
        dtFrom.Attributes.Add("readOnly", "true");
        dtTo.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdSearch.PageIndex = 0;
        lblMsg.Text = "";
        Search();
    }

    private void Search()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT mo.LabNo,mo.Reading,mo.MACHINE_ID,mo.Machine_ParamID,mp.machine_param,DATE_FORMAT(mo.dtEntry,'%d-%b-%Y %h:%i%p') dtEntry, ");
            sb.Append(" IF(IFNULL(mo.isSync,0)=1 OR mp.machine_ParamID=mo.Machine_ParamID,'display:none','display:block') isSync,IFNULL(mo.isSync,0) synccheck, ");
            sb.Append(" IF(IFNULL(mp.machine_param,'')='','display:none','display:block')machine_paramdis ");
            sb.Append(" FROM " + AllGlobalFunction.MachineDB + ".mac_observation mo ");
            sb.Append(" LEFT JOIN " + AllGlobalFunction.MachineDB + ".mac_machineparam mp ON mp.machine_ParamID=mo.Machine_ParamID ");
            sb.Append(" INNER JOIN " + AllGlobalFunction.MachineDB + ".mac_machinemaster mac ON mac.MACHINEID=mo.Machine_Id AND mac.CentreID=" + Session["CentreID"].ToString() + " ");
            sb.Append(" where date(mo.dtEntry)>='" + (Convert.ToDateTime(dtFrom.Text)).ToString("yyyy-MM-dd") + "' and  date(mo.dtEntry)<='" + (Convert.ToDateTime(dtTo.Text)).ToString("yyyy-MM-dd") + "' ");

            if (ddlType.SelectedIndex > 0)
                sb.Append(" and  ifnull(mo.isSync,0) ='" + ddlType.SelectedValue + "' ");

            if (ddlMachine.SelectedIndex > 0)
                sb.Append(" and  mo.MACHINE_ID ='" + ddlMachine.SelectedValue + "' ");

            if (txtSampleID.Text.Trim() != string.Empty)
                sb.Append(" and  mo.LabNo ='" + txtSampleID.Text.Trim() + "' ");

            if (ddlPageSize.SelectedIndex < ddlPageSize.Items.Count - 1)
            {
                grdSearch.AllowPaging = true;
                grdSearch.PageSize = Util.GetInt(ddlPageSize.SelectedValue);
            }
            else
                grdSearch.AllowPaging = false;

            sb.Append(" ORDER BY mo.dtEntry desc ");
            //grdSearch.AutoGenerateColumns = false;
            DataTable dtRecord = StockReports.GetDataTable(sb.ToString());
            if (dtRecord.Rows.Count > 0)
            {
                grdSearch.DataSource = dtRecord;
                grdSearch.DataBind();
            }
            else
                lblMsg.Text = "No Record Found";
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            lblMsg.Text = ex.Message;
        }

    }
    protected void grdSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            if (Session["ID"].ToString() == "EMP001")
            {
                grdSearch.Columns[7].Visible = true;
            }
            else
            {
                grdSearch.Columns[7].Visible = false;
            }
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblSync")).Text == "1")
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            else
                e.Row.BackColor = System.Drawing.Color.LightPink;
        }
    }

    protected void grdSearch_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdSearch.PageIndex = e.NewPageIndex;
        Search();
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT md.LedgerTransactionNo,md.LabNo,md.LabObservation_ID,md.Reading,  ");
            sb.Append(" DATE_FORMAT(md.dtEntry,'%d-%b-%y') dtEntry,md.PName,md.PatientID,  ");
            sb.Append(" md.Age,md.Gender,md.MachineName FROM mac_data md WHERE md.MachineName<>''  ");

            if (ddlMachine.SelectedIndex > 0)
                sb.Append(" and md.MachineName='" + ddlMachine.SelectedValue + "' ");

            sb.Append(" and date(md.dtEntry)>='" + (Convert.ToDateTime(dtFrom.Text)).ToString("yyyy-MM-dd") + "' and date(md.dtEntry)<='" + (Convert.ToDateTime(dtTo.Text)).ToString("yyyy-MM-dd") + "' ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ForDate";
                dc.DefaultValue = "Period From : " + (Convert.ToDateTime(dtFrom.Text)).ToString("yyyy-MM-dd") + " To : " + (Convert.ToDateTime(dtTo.Text)).ToString("yyyy-MM-dd") + " " + ddlMachine.SelectedValue;
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "MacData";

                //ds.WriteXmlSchema("c:\\macdata.xml");

                Session["ds"] = ds;
                Session["ReportName"] = "MacData";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/CommonReport.aspx');", true);

            }
            else
                lblMsg.Text = "No Details Found";
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);

        }
    }
}