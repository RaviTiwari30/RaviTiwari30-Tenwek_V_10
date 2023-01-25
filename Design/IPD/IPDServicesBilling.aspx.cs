using System;
using System.Data;
using System.Web.Services;
using System.Text;

public partial class Design_IPD_IPDServicesBilling : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["PatientId"] != null)
            {
                if (Resources.Resource.AllowFiananceIntegration == "1")//
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(Request.QueryString["TransactionID"].ToString()) > 0)
                    {
                        string Msga = "Patient's Final Bill Already Posted To Finance...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
                    }
                }
                spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
                spnPatientID.InnerText = Request.QueryString["PatientId"].ToString();
                AllQuery AQ = new AllQuery();
                DataTable dt = AQ.GetPatientAdjustmentDetails(spnTransactionID.InnerText);
                DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
                ViewState["Authority"] = dtAuthority;
                if (dtAuthority.Rows.Count > 0)
                {
                    ViewState["IsDiscount"] = dtAuthority.Rows[0]["IsDiscount"].ToString();
                    ViewState["IsRate"] = dtAuthority.Rows[0]["IsEdit"].ToString();
                }
                else
                {
                    ViewState["IsDiscount"] = "1";
                    ViewState["IsRate"] = "1";
                }
                if (dt != null && dt.Rows.Count > 0)
                {
                    if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                    {
                        DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                        if ((dt.Rows[0]["IsBillFreezed"].ToString() == "1") && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                        {
                            string Msg = "";
                            int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                            if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0" && auth == 0)
                            {
                                Msg = "You Are Not Authorised To AMEND IPD Bills...";
                                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                            }
                            else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                            {
                                Msg = "Patient's Final Bill has been Closed for Further Updating...";
                                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                            }
                        }
                        else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                        {
                            string Msg = "";
                            Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }

                    if (dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                    {
                        string Msg = "";
                        Msg = "Patient's Final Bill has been Closed for Further Updating...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
                AllLoadData_IPD.fromDatetoDate(spnTransactionID.InnerText, ucDate, toDate, calucDate, caltoDate);
            }
        }
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "[]";

        if (cmd == "item")
        {
            rtrn = makejsonoftable(BindItem(), makejson.e_with_square_brackets);
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();
            return;
        }
        txtSelectDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender1.StartDate = DateTime.Now;

        txtStopDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        CalendarExtender2.StartDate = DateTime.Now;

        ucDate.Attributes.Add("readOnly", "true");
        toDate.Attributes.Add("readonly", "true");

        txtStopDate.Attributes.Add("readonly", "true");
        txtSelectDate.Attributes.Add("readonly", "true"); 
    }
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }


    public DataTable BindItem()
    {
        string transactionid = Util.GetString(Request.QueryString["TransactionID"]);
        string category = Util.GetString(Request.QueryString["category"]);
        string subcategory = Util.GetString(Request.QueryString["subcategory"]);
        string itemName = Util.GetString(Request.QueryString["q"]);
        int ReferenceCode = Util.GetInt(Request.QueryString["ReferenceCode"].ToString().Trim());
        string IPDCaseTypeID = Util.GetString(Request.QueryString["IPDCaseTypeID"]);
        string ScheduleChargeID = Util.GetString(Request.QueryString["ScheduleChargeID"]);
        string limit = Util.GetString(Request.QueryString["rows"]);
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TypeName,SubCategoryName,ItemCode,IF(Rate IS NULL,0,Rate) Rate, ");
        sb.Append("CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#' ");
        sb.Append(",IF(IFNULL(ItemDisplayName,'')='',TypeName,ItemDisplayName),'#' ");
        sb.Append(",IF(ItemCode IS NULL,CPTCode,ItemCode),'#',IF(RateListID IS NULL,'',RateListID),'#',RateEditable,'#',GSTDetails,'#','NA','#','NA', ");
        sb.Append("'#','NA','#','NA','#',Type_ID,'#',SubCategoryID,'#',ConfigID)ItemId FROM (  ");
        sb.Append("SELECT im.TypeName AS TypeName,sub.Name AS SubCategoryName, ");
        sb.Append("IM.ItemID,IFNULL(IM.Type_ID,'')Type_ID,IM.SubCategoryID,RL.Rate,RL.ItemDisplayName,RL.ItemCode,RL.RateListID,IM.RateEditable,IM.ItemCode CPTCode, ");
        sb.Append("cf.ConfigID,CONCAT(IFNULL(IM.HSNCode,''),'^',IM.IGSTPercent,'^',IM.SGSTPercent,'^',IM.CGSTPercent,'^',IFNULL(IM.GSTType,''))GSTDetails ");
        sb.Append("FROM f_itemmaster IM  ");
        sb.Append("INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID` ");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("LEFT JOIN (  ");
        sb.Append("SELECT ID RateListID,ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID.Trim() + "'  ");
        sb.Append("AND ScheduleChargeID='" + ScheduleChargeID.Trim() + "' AND PanelID=" + ReferenceCode + "  AND IsCurrent=1  ");
        sb.Append(") RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID IN (2,6,8,9,10,20,24,14,26,27,29) AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + Session["CentreID"].ToString() + "' ");
        sb.Append(" AND TypeName like '%" + itemName.Trim() + "%' ");
        if (category != "0" && category != "null")
        {
            sb.Append(" AND cf.CategoryID='" + category + "'");
        }
        if (subcategory != "0" && subcategory != "null")
        {
            sb.Append("   AND sub.SubCategoryID='" + subcategory + "'");
        }
        sb.Append("  LIMIT " + Util.GetString(Request.QueryString["rows"]) + " )t  ORDER BY TypeName ");
        return StockReports.GetDataTable(sb.ToString());
    }
}