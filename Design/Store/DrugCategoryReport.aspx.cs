using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Web.UI.HtmlControls;
public partial class Design_Store_DrugCategoryReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
            BindDrugCategoryMaster();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    public void BindDrugCategoryMaster()
    {
        DataTable dataTable = StockReports.GetDataTable("SELECT id,drugcategoryName FROM DrugCategoryMaster where isactive=1");
        ddlDrugCategory.DataSource = dataTable;
        ddlDrugCategory.DataValueField = "id";
        ddlDrugCategory.DataTextField = "drugcategoryName";
        ddlDrugCategory.DataBind();
        ddlDrugCategory.Items.Insert(0, new ListItem("All", "0"));



    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();

        //sb.Append(" SELECT cmt.`CentreName`,DATE_FORMAT(lt.Date,'%d-%b-%y')Date,lt.BillNo,CONCAT(dm.Title,'',dm.Name)DrName,dm.IMARegistartionNo,CONCAT(pm.Title,'',pm.PName)Pname,im.TypeName,sd.SoldUnits AS Quantity,");
        //sb.Append(" mm.NAME AS ManufactureName,st.BatchNumber,DATE_FORMAT(st.MedExpiryDate,'%b-%y')MedExpiryDate,im.ScheduleType,im.ItemType  FROM f_salesdetails sd INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=sd.LedgerTransactionNo");
        //sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID");
        //sb.Append(" INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID");
        //sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID inner join center_master cmt on cmt.centreID = pmh.centreID");
        //sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=sd.ItemID");
        //sb.Append(" INNER JOIN f_manufacture_master mm ON mm.ManufactureID=im.ManufactureID");
        //sb.Append(" INNER JOIN f_stock st ON st.StockID=sd.StockID");
        //sb.Append(" WHERE lt.Date>='" + (Convert.ToDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd") + "' AND lt.Date<='" + (Convert.ToDateTime(ucToDate.Text)).ToString("yyyy-MM-dd") + "'  ");

        //if (dllType.SelectedItem.Value == "1")
        //{
        //    if (ddlDrugCategory.SelectedItem.Text != "All")
        //        sb.Append(" AND im.ScheduleType='" + ddlDrugCategory.SelectedItem.Text + "' ");
        //    else
        //        sb.Append(" AND im.ScheduleType IN('H1-Schedule Type','H2-Schedule Type') ");
        //}
        //else
        //{
        //    if (ddlItemType.SelectedItem.Text != "All")
        //        sb.Append(" AND im.ItemType='" + ddlItemType.SelectedItem.Text + "' ");
        //    else
        //        sb.Append(" AND im.ItemType IN('Vital','Essential','Deseriable') and sd.SoldUnits>0 ");
        //}


        // sb.Append(" AND lt.TypeOfTnx IN ('Pharmacy-Issue','Sales','Emergency') ORDER BY lt.Date");


        sb.Append("SELECT cmt.`CentreName`, ");
        if (dllType.SelectedItem.Value == "1")
            sb.Append("im.ScheduleType, ");
        else
            sb.Append("im.ItemType,  ");

        sb.Append("DATE_FORMAT(sd.Date,'%d-%b-%y')DATE,sd.BillNo,CONCAT(dm.Title,'',dm.Name)DrName,dm.IMARegistartionNo, ");
        sb.Append("CONCAT(pm.Title,'',pm.PName)Pname,im.TypeName,sd.SoldUnits AS Quantity, mm.NAME AS ManufactureName,st.BatchNumber, ");
        sb.Append("DATE_FORMAT(st.MedExpiryDate,'%b-%y')MedExpiryDate   ");
        sb.Append("FROM f_salesdetails sd  ");
        sb.Append("INNER JOIN patient_medical_history pmh ON pmh.TransactionID=sd.TransactionID  ");
        sb.Append("LEFT JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID  ");
        sb.Append("INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  ");
        sb.Append("INNER JOIN center_master cmt ON cmt.centreID = sd.`CentreID` ");
        sb.Append("INNER JOIN f_itemmaster im ON im.ItemID=sd.ItemID  ");
        sb.Append("LEFT JOIN f_manufacture_master mm ON mm.ManufactureID=im.ManufactureID  ");
        sb.Append("INNER JOIN f_stock st ON st.StockID=sd.StockID ");
        sb.Append(" WHERE sd.Date>='" + (Convert.ToDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd") + "' AND sd.Date<='" + (Convert.ToDateTime(ucToDate.Text)).ToString("yyyy-MM-dd") + "'  ");

        if (dllType.SelectedItem.Value == "1")
        {
            if (ddlDrugCategory.SelectedItem.Text != "All")
                sb.Append(" AND im.ScheduleType='" + ddlDrugCategory.SelectedItem.Text + "' ");
            else
                sb.Append(" AND im.ScheduleType IN('H1-Schedule Type','H2-Schedule Type') ");
        }
        else
        {
            if (ddlItemType.SelectedItem.Text != "All")
                sb.Append(" AND im.ItemType='" + ddlItemType.SelectedItem.Text + "' ");
            else
                sb.Append(" AND im.ItemType IN('Vital','Essential','Deseriable') and sd.SoldUnits>0 ");
        }


        sb.Append(" and sd.`CentreID` IN("+ Centre +") AND sd.`TrasactionTypeID` IN(3,16) ORDER BY sd.Date ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            string ReportName = dllType.SelectedItem.Text + " Report";
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");

            dt.Columns.Add(dc);
            dt = Util.GetDataTableRowSum(dt);

            string CacheName = Session["ID"].ToString();
            Common.CreateCachedt(CacheName, dt); ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/commonReports/Commonreport.aspx?ReportName=" + ReportName + "&Type=E');", true);

        }
       else
           ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }
}