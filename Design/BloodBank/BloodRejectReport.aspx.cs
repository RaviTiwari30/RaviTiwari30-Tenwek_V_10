using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_BloodBank_BloodRejectReport : System.Web.UI.Page
{
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblerrmsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();

        dt = SearchBloodRekect(Centre);

        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + txtRejectdatefrom.Text + " To : " + txtRejectdateTo.Text;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
            Session["ReportName"] = "BloodRejectReport";

             //ds.WriteXmlSchema("D:/BloodRejectReport.xml");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Bloodbank/Commenreport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtRejectdatefrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtRejectdateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BloodBank.bindComponent(ddlComponentName);
            ddlComponentName.Items.Insert(0,new ListItem("All"));
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
        }
        txtRejectdatefrom.Attributes.Add("readOnly", "true");
        txtRejectdateTo.Attributes.Add("readOnly", "true");
    }

    private DataTable SearchBloodRekect(string Centre)
    {
        DataTable dt1 = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (rdbType.SelectedValue == "OPD")
            {
                sb.Append(" SELECT pm.Pname,pm.PatientID,bcm.ComponentName,DATE_FORMAT((lt.entryDate),'%d-%b-%Y')RejectDate,REPLACE(lt.quantity,'-','')quantity  ");
                sb.Append("FROM f_ledgertnxdetail lt INNER JOIN bb_item_component bic ON bic.ItemID=lt.ItemID ");
                sb.Append("INNER JOIN bb_component_master bcm ON bcm.Id=bic.ComponentID  ");
                sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID ");
                sb.Append(" LEFT JOIN  bb_return_blood brb ON brb.LedgerTnxID=lt.LedgerTnxID  ");
                sb.Append(" WHERE  configid=7 AND lt.quantity<0  AND brb.ComponentID IS NULL ");

                if (ddlComponentName.SelectedIndex != 0)
                {
                    sb.Append(" AND bic.ComponentID='" + ddlComponentName.SelectedItem.Value + "'");
                }
                if (rdbType.SelectedValue != "ALL")
                {
                    if (rdbType.SelectedValue == "OPD")
                    {
                        sb.Append(" AND  pmh.Type='" + rdbType.SelectedItem.Text + "' ");
                    }
                    else
                    {
                        sb.Append(" AND  pmh.Type='" + rdbType.SelectedItem.Text + "' ");
                    }
                }
                if (ddlComponentName.SelectedIndex == 0)
                {
                    if (txtRejectdatefrom.Text != "")
                    {
                        sb.Append(" AND DATE(lt.entryDate) >='" + Util.GetDateTime(txtRejectdatefrom.Text).ToString("yyyy-MM-dd") + "' ");
                    }
                    if (txtRejectdateTo.Text != "")
                    {
                        sb.Append(" and DATE(lt.entryDate) <='" + Util.GetDateTime(txtRejectdateTo.Text).ToString("yyyy-MM-dd") + "' ");
                    }
                }
                sb.Append("ORDER BY DATE(lt.entryDate)");
            }
            else
            {
                sb.Append(" SELECT cm.CentreID,cm.CentreName, pm.Pname,pm.PatientID,bcm.ComponentName,DATE_FORMAT((isr.CancelDate),'%d-%b-%Y')RejectDate,isr.RejectQty quantity,CONCAT(em.Title,'',em.Name)RejectBy,isr.Patient_Type ");
                sb.Append(" FROM ipdservices_request isr INNER JOIN bb_item_component bic ON bic.ItemID=isr.ItemID INNER JOIN bb_component_master bcm ON bcm.Id=bic.ComponentID  ");
                sb.Append(" INNER JOIN patient_master pm ON isr.PatientID=pm.PatientID INNER JOIN employee_master em ON em.Employee_ID=isr.Cancelby INNER JOIN center_master cm ON cm.CentreID=isr.CentreID WHERE isr.IsCancel=1 and isr.Type='BB' and isr.CentreID in (" + Centre + ") ");
                if (ddlComponentName.SelectedIndex != 0)
                {
                    sb.Append(" AND bic.ComponentID='" + ddlComponentName.SelectedItem.Value + "'");
                }
                if (ddlComponentName.SelectedIndex == 0)
                {
                    if (txtRejectdatefrom.Text != "")
                    {
                        sb.Append(" AND isr.CancelDate >='" + Util.GetDateTime(txtRejectdatefrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    }
                    if (txtRejectdateTo.Text != "")
                    {
                        sb.Append(" and isr.CancelDate <='" + Util.GetDateTime(txtRejectdateTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
                    }
                }
                if (rdbType.SelectedValue != "ALL")
                {
                    sb.Append(" and isr.Patient_Type = '"+rdbType.SelectedValue+"' ");
                }
                sb.Append(" ORDER BY isr.CancelDate");
            }
            dt1 = StockReports.GetDataTable(sb.ToString());
            return dt1;
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);

            return dt1;
        }
    }
}