using System;
using System.Data;
using System.Web.Services;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_IPD_IPDLabPrescriptionNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["PatientId"] != null)
            {
                spnTransactionID.InnerText = Request.QueryString["TransactionID"].ToString();
                spnPatientID.InnerText = Request.QueryString["PatientID"].ToString();
                AllQuery AQ = new AllQuery();
                DataTable dt = AQ.GetPatientAdjustmentDetails(spnTransactionID.InnerText);
                DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
                ViewState["Authority"] = dtAuthority;
                if (Resources.Resource.AllowFiananceIntegration == "1")//
                {
                    if (AllLoadData_IPD.CheckDataPostToFinance(spnTransactionID.InnerText) > 0)
                    {
                        string Msga = "Patient's Final Bill Already Posted To Finance...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msga);
                    }
                }
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
    [WebMethod(EnableSession=true)]
    public static string LoadSetItems(int SetID, int panelRefID, string TID, string IPDCaseTypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lim.ID,lim.quantity,IF(IFNULL(rt.ItemDisplayName,'')='',im.TypeName,rt.ItemDisplayName) NAME, ");
        sb.Append("CONCAT(im.ItemId,'#',IF(rt.Rate IS NULL,0,rt.Rate),'#' ");
        sb.Append(",IF(rt.ItemDisplayName IS NULL,im.TypeName,rt.ItemDisplayName),'#' ");
        sb.Append(",IF(rt.ItemCode IS NULL,IM.ItemCode,rt.ItemCode),'#',IF(rt.ID IS NULL,'',rt.ID),'#',IFNULL(im.RateEditable,0),'#',mm.GenderInvestigate,'#',mm.TYPE,'#',mm.IsOutSource, ");
        sb.Append("'#',mm.OutSourceLabID,'#',mm.SampleTypeName,'#',im.Type_ID,'#',im.SubCategoryID,'#',cf.ConfigID)ItemId,   ");
        sb.Append("lim.SetID, ");
        sb.Append("lis.name setName,IFNULL(rt.Rate,0)Rate,IFNULL(IF(DATE(ltd.EntryDate)=DATE(CURRENT_DATE()),1,0) ,0)chkAlreadyPrescribe  ");
        sb.Append("FROM lab_itemSet_master  lim INNER JOIN f_itemmaster im ON im.ItemID=lim.itemID   ");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("INNER JOIN  lab_itemSet lis ON lim.setID=lis.ID  ");
        sb.Append("INNER JOIN Investigation_master mm ON im.Type_ID=mm.Investigation_Id  ");
        sb.Append("LEFT JOIN f_ledgertnxdetail ltd  ON ltd.ItemID=im.ItemID AND ltd.TransactionID='"+ TID +"' "); 
        sb.Append("AND DATE(ltd.EntryDate)=DATE(CURRENT_DATE())   LEFT JOIN f_ratelist_ipd rt ON rt.ItemID=im.ItemID "); 
        sb.Append("INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rt.PanelID   AND rsc.IsDefault=1 AND rsc.ScheduleChargeID=rt.ScheduleChargeID  ");
        sb.Append("AND rt.IsCurrent=1  AND rt.CentreID='"+ HttpContext.Current.Session["CentreID"].ToString() +"' AND rsc.IsDefault=1 AND rt.PanelID="+ panelRefID +" AND rt.ipdCaseTypeID='"+ IPDCaseTypeID +"' WHERE lim.setID='" + SetID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());  
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    public DataTable BindItem()
    {
        DataTable dt = new DataTable();
        string transactionid = Util.GetString(Request.QueryString["TransactionID"]);
        string category = Util.GetString(Request.QueryString["category"]);
        string subcategory = Util.GetString(Request.QueryString["subcategory"]);
        string itemName = Util.GetString(Request.QueryString["q"]);
        string ReferenceCode = Util.GetString(Request.QueryString["ReferenceCode"]);
        string IPDCaseTypeID = Util.GetString(Request.QueryString["IPDCaseTypeID"]);
        string ScheduleChargeID = Util.GetString(Request.QueryString["ScheduleChargeID"]);
        string CentreID = Util.GetString(Session["CentreID"]);
        if (itemName == "")
            return dt;
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TypeName,SubCategoryName,ItemCode,IF(Rate IS NULL,0,Rate) Rate, ");
        sb.Append("CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#' ");
        sb.Append(",IF(IFNULL(ItemDisplayName,'')='',TypeName,ItemDisplayName),'#' ");
        sb.Append(",IF(ItemCode IS NULL,IFNULL(CPTCode,''),ItemCode),'#',IF(RateListID IS NULL,'',RateListID),'#',RateEditable,'#',GenderInvestigate,'#',TYPE,'#',IsOutSource, ");
        sb.Append("'#',OutSourceLabID,'#',SampleTypeName,'#',Type_ID,'#',SubCategoryID,'#',ConfigID)ItemId FROM (  ");
        sb.Append("SELECT im.TypeName AS TypeName,ims.GenderInvestigate,sub.Name AS SubCategoryName, ");
        sb.Append("IM.ItemID,IM.Type_ID,IM.SubCategoryID,RL.Rate,RL.ItemDisplayName,RL.ItemCode,RL.RateListID,IM.RateEditable,IM.ItemCode CPTCode, ");
        sb.Append("ims.TYPE,ims.IsOutSource,ims.OutSourceLabID,IFNULL(ims.SampleTypeName,'')SampleTypeName,cf.ConfigID ");
        sb.Append("FROM f_itemmaster IM  ");
        sb.Append("INNER JOIN `f_itemmaster_centerwise` itc ON itc.`ItemID`=im.`ItemID`");
        sb.Append("INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID   ");
        sb.Append("INNER JOIN investigation_master ims ON ims.Investigation_Id=im.Type_ID  ");
        sb.Append("INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID  ");
        sb.Append("LEFT JOIN (  ");
        sb.Append("SELECT ID RateListID,ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + IPDCaseTypeID.Trim() + "'  ");
        sb.Append("AND ScheduleChargeID='" + ScheduleChargeID.Trim() + "' AND PanelID='" + ReferenceCode.Trim() + "'  AND IsCurrent=1  and CentreID='" + CentreID + "'");
        sb.Append(") RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID=3 AND im.Isactive=1 AND itc.`IsActive`=1 AND itc.CentreID='" + Session["CentreID"].ToString() + "' ");
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
         dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    [WebMethod]
    public static string checkEmergencyCharges()
    {
      int IsEmergencyCharges = Util.GetInt(StockReports.ExecuteScalar("SELECT IF(CURTIME()>='20:00:00' OR CURTIME()<='08:00:00',1,0) AS IsEmergencyCharges"));
      if (IsEmergencyCharges == 1)
          //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Kindly add the <span class='patientInfo'>'Emergency Fees'</span> if required from <span class='patientInfo'>'IPD Services'</span> Screen." });
          return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "OK for Save" });
      else
          return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "OK for Save" });
    }

}