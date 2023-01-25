using System;
using System.Data;
using System.Web.Services;
using System.Text;

public partial class Design_IPD_IPDSurgeryBillingNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null)
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
                spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();
              
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
                };
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
        DataTable dt = new DataTable();
        string itemName = Util.GetString(Request.QueryString["q"]);
        string ReferenceCode = Util.GetString(Request.QueryString["ReferenceCode"]);
        string groupId = Util.GetString(Request.QueryString["groupId"]);
        if (itemName == "")
            return dt;
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT s.Surgery_ID ItemId,UPPER(s.Name)TypeName,UPPER(sgm.GroupName)GroupName,s.SurgeryCode,s.Department,s.`GroupID`,  ");
        sb.Append("IFNULL(( ");
        sb.Append("SELECT ROUND(SUM(g.`Rate`*g.`ScaleOfCost`),4) FROM `f_surgery_group` g WHERE g.`GroupID`=s.`GroupID` AND g.`Isactive`=1 ");
        sb.Append("AND g.`PanelID`='" + ReferenceCode + "' ");
        sb.Append("),0) SurgeryRate ");
        sb.Append("FROM `f_surgery_master` s  ");
        sb.Append("INNER JOIN `f_surgery_groupmaster` sgm ON sgm.`GroupID`=s.`GroupID` ");
        sb.Append("WHERE s.`IsActive`=1 AND s.`GroupID`=" + groupId + "  ");
        sb.Append(" AND s.Name LIKE '%" + itemName.Trim() + "%' ");
        sb.Append(" ORDER BY s.`Name` ");
        sb.Append(" LIMIT " + Util.GetString(Request.QueryString["rows"]) + " ");
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}