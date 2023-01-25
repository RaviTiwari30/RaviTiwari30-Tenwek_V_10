using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_IPD_AdmitShiftedPatient : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindCenterDropDownList(ddlCentre, "", "All");

            ddlCentre.Items.Remove(ddlCentre.Items.FindByValue(Resources.Resource.DefaultCentreID));
            All_LoadData.bindDoctor(ddlDoctor);
            CaseTypeBind();
        }
    }

    private void CaseTypeBind()
    {
        try
        {
            AllLoadData_IPD.bindBillingCategory(ddlBillCategory, "Select");
            ddlBillCategory.SelectedIndex = 0;
            AllLoadData_IPD.bindCaseType(ddlCaseType, "Select");
            All_LoadData.BindRelation(ddlHolder_Relation);

            ddlCaseType.SelectedIndex = 0;

            BindRoom();
            bindPanel();
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    private void bindPanel()
    {
        DataTable dtPanel = LoadCacheQuery.loadIPDPanel(Session["CentreID"].ToString());
        foreach (DataRow dr in dtPanel.Rows)
        {
            ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[2].ToString() + "#" + dr[5].ToString());
            ddlPanelCompany.Items.Add(li1);
            ListItem li2 = new ListItem(dr[0].ToString(), dr[1].ToString());
            ddlParentPanel.Items.Add(li2);
        }
        ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(Resources.Resource.DefaultPanelID + "#" + Resources.Resource.DefaultPanelID + "#" + "0"));
        ddlParentPanel.SelectedIndex = ddlParentPanel.Items.IndexOf(ddlParentPanel.Items.FindByValue(Resources.Resource.DefaultPanelID));
    }

    private void BindRoom()
    {
        AllLoadData_IPD.bindRoom(ddlRoom, ddlCaseType.SelectedItem.Value, 0);
    }

    [WebMethod(EnableSession = true)]
    public static string getPanelMapped(string panelID)
    {
        return StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_panel_master fpm INNER JOIN  f_center_panel fcp ON fpm.PanelID=fcp.PanelID WHERE fcp.panelID=" + panelID + " AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");
    }

    [WebMethod(EnableSession = true)]
    public static string searchShiftedPatient(string IPDNo, string PatientID, string PName, string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ps.ID shiftedID,ps.PatientID,ps.TransactionID,REPLACE(ps.TransactionID,'ISHHI','')TID,ps.ShiftedBy,DATE_FORMAT(ps.ShiftedDate,'%d-%b-%Y')ShiftedDate,pm.PName,");
        sb.Append(" cm.CentreName,CONCAT(em.Title,' ',em.Name)ShiftedName,fpm.Company_Name PanelName,ps.PanelID,fpm.ReferenceCode,fpm.applyCreditLimit,ps.BillingCategoryID billingCategory FROM patient_shift ps ");
        sb.Append(" INNER JOIN Patient_master pm ON ps.PatientID=pm.PatientID INNER JOIN center_master cm ON cm.CentreID=ps.AdmittedCentreID ");
        sb.Append(" INNER JOIN employee_master em ON em.employeeID=ps.ShiftedBy INNER JOIN f_panel_master fpm ON fpm.PanelID=ps.PanelID");
        sb.Append(" WHERE ps.isAdmitted =0 ");
        if (IPDNo.Trim() != "")
        {
            sb.Append(" AND ps.TransactionID='ISHHI" + IPDNo.Trim() + "'");
        }
        if (PatientID.Trim() != "")
        {
            sb.Append(" AND ps.PatientID='" + PatientID.Trim() + "'");
        }
        if (PName.Trim() != "")
        {
            sb.Append(" AND pm.PName  LIKE '" + PName.Trim() + "%'");
        }
        if (Centre.Trim() != "0")
        {
            sb.Append(" AND ps.AdmittedCentreID = '" + Centre.Trim() + "'");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod]
    public static string loadPatientInfo(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pip.*,pmh.PanelID,pnl.ReferenceCode,pnl.Company_Name,icm.Name RoomCategory,pmh.ScheduleChargeID,");
        sb.Append("  PolicyNo,CardNo,Employee_id,FileNo,pmh.CardHolderName,pmh.RelationWith_holder FROM ( ");
        sb.Append("   SELECT IPDCaseTypeID AS IPDCaseType_ID,IPDCaseTypeID_Bill AS IPDCaseType_ID_Bill,TransactionID FROM patient_ipd_profile WHERE TransactionID='" + TID + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1 ");
        sb.Append(" )pip INNER JOIN patient_medical_history pmh ON pip.TransactionID = pmh.TransactionID INNER JOIN f_panel_master pnl ON   ");
        sb.Append("  pmh.PanelID = pnl.PanelID INNER JOIN ipd_Case_Type_Master icm ON icm.IPDCaseTypeID = pip.IPDCaseTypeID_Bill WHERE pmh.TransactionID='" + TID + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string saveShiftedPatient(string roomType, string BillCategory, string roomID, string PatientID, string TID, string docID, int panelID, string ShiftedID, string parentPanelID, string PolicyNo, string CardNo, string CardHolderName, string RelationWith_holder, string CreditLimit, string CreditType, string PolicyDetail, string IgnoringPolicyReason, string BillingCategory, string panelCheck, string ScheduleChargeID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE Patient_IPD_Profile SET Status='OUT',EndDate=CURDATE(),EndTime=CURTIME() WHERE TransactionID='" + TID + "' AND Status='IN'");

            Patient_IPD_Profile objIPD = new Patient_IPD_Profile(tranx);
            objIPD.TransactionID = TID;
            objIPD.TobeBill = 1;
            objIPD.StartDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
            objIPD.StartTime = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
            objIPD.IPDCaseTypeID = roomType;
            objIPD.IPDCaseTypeID_Bill = BillCategory;
            objIPD.RoomID = roomID;
            objIPD.PanelID = panelID;
            objIPD.PatientID = PatientID;
            objIPD.Status = "IN";
            objIPD.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            objIPD.Hospital_Id = HttpContext.Current.Session["HospID"].ToString();
            objIPD.Insert();

            string MaxID = StockReports.ExecuteScalar("Select max(ID) from f_doctorshift where TransactionID='" + TID + "' ");

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "Update f_doctorshift set ToDate=CURDATE(),ToTime=CURTIME(),Status='OUT' where ID=" + MaxID + " ");

            string strIns = "Insert into f_doctorshift (TransactionID,DoctorID,FromDate,FromTime,UserID,Status,CentreID,HospCentreID)values ('" + TID + "','" + docID + "',CURDATE(),CURTIME(), '" + HttpContext.Current.Session["ID"].ToString() + "','IN','" + HttpContext.Current.Session["CentreID"].ToString() + "','" + HttpContext.Current.Session["HospCentreID"].ToString() + "')";

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strIns);

            StringBuilder sb = new StringBuilder();

            sb.Append(" UPDATE patient_medical_history pmh  INNER JOIN ipd_case_history iph ON pmh.TransactionID=iph.TransactionID  INNER JOIN f_ipdadjustment adj ON adj.TransactionID=pmh.TransactionID ");
            sb.Append(" SET iph.Consultant_ID='" + docID + "',iph.LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',iph.UpdateDate=NOW(),pmh.DoctorID='" + docID + "',pmh.LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',pmh.Updatedate = NOW(), ");
            sb.Append("  pmh.PanelID=" + panelID + ",pmh.PolicyNo='" + PolicyNo + "',pmh.CardNo='" + CardNo + "', pmh.IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "',pmh.ParentID='" + parentPanelID + "',pmh.CardHolderName='" + CardHolderName + "',pmh.RelationWith_holder='" + RelationWith_holder + "', ");
            if (PolicyDetail == "1")
                sb.Append("  pmh.PanelIgnoreReason='" + IgnoringPolicyReason + "', ");

            sb.Append("  adj.DoctorID='" + docID + "',adj.isShiftededPatient=0,adj.LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',adj.UpdateDate = NOW(),adj.IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "',adj.CreditLimitPanel='" + Util.GetDecimal(CreditLimit) + "',adj.CreditLimitType='" + CreditType + "' ");
            sb.Append(" WHERE pmh.TransactionID='" + TID + "' ");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE f_ledgertransaction SET PanelID=" + panelID + ",EditUSerID = '" + HttpContext.Current.Session["ID"].ToString() + "',EditDateTime = NOW(),IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "' WHERE TransactionID='" + TID + "' ");
            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, "UPDATE patient_shift SET isAdmitted=1 WHERE ID='" + ShiftedID + "' ");

            if (BillCategory == "1" || panelCheck == "1")
            {
                string str = "Select LedgerTransactionNO,ItemID,Rate,Amount,DiscountPercentage,LedgerTnxID,Surgery_ID from f_ledgertnxdetail where TransactionID='" + TID + "' and IsVerified=1 and ISSurgery=1";
                DataSet ds = MySqlHelper.ExecuteDataset(tranx, CommandType.Text, str);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    decimal TotalSurgeryAmount = Util.GetDecimal(ds.Tables[0].Compute("sum(Rate)", ""));

                    DataColumn dc = new DataColumn("Percentage", typeof(float));
                    dc.DefaultValue = 0;
                    ds.Tables[0].Columns.Add(dc);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        dr["Percentage"] = Util.GetDecimal((Util.GetDecimal(dr["Rate"])/TotalSurgeryAmount) * 100);
                    }

                    ds.Tables[0].AcceptChanges();

                    decimal TotalRate = Util.GetDecimal(StockReports.ExecuteScalar("SELECT Rate FROM f_surgery_rate_list WHERE Surgery_ID='" + ds.Tables[0].Rows[0]["Surgery_ID"].ToString() + "' and PanelID=" + panelID + " and IPDCaseTypeID='" + BillCategory + "' and ScheduleChargeID=" + ScheduleChargeID + " "));

                    if (TotalRate > 0)
                    {
                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            decimal ItemRate = (TotalRate * Util.GetDecimal(row["Percentage"]) / 100);
                            decimal ItemDisc = (ItemRate * Util.GetDecimal(row["DiscountPercentage"]) / 100);

                            str = " UPDATE f_ledgertnxdetail Set Rate =" + ItemRate + ",Amount=" + (ItemRate - ItemDisc) + ",LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',UpdateDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "'  Where LedgerTnxID ='" + row["LedgerTnxID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, str);

                            str = " UPDATE f_surgery_discription sd LEFT JOIN f_surgery_doctor sDoc on " +
                            "sd.SurgeryTransactionID = sdoc.SurgeryTransactionID " +
                            "Set sd.Rate=" + ItemRate + ",sd.Amount=" + (ItemRate - ItemDisc) + ",sDoc.Amount =" + (ItemRate - ItemDisc) + " " +
                            ",sd.LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',sd.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',sd.IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "' " +
                             ",sDoc.LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',sDoc.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',sDoc.IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "' " +
                            "WHERE sd.LedgerTransactionNo='" + row["LedgerTransactionNo"].ToString() + "' AND sd.ItemID ='" + row["ItemID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, str);
                        }
                    }
                }

                str = "  UPDATE f_ledgertnxdetail ltd INNER JOIN f_subcategorymaster sc on ltd.subcategoryID = sc.SubcategoryID  " +
                      "  INNER JOIN f_configrelation cf on cf.CategoryID = sc.CategoryID left join f_ratelist_ipd rt on " +
                      "  ltd.itemid = rt.itemid and rt.PanelID=" + panelID + "  " +
                      "  AND rt.scheduleChargeID=" + ScheduleChargeID + " AND rt.ipdcasetypeID='" + BillCategory + "'  and rt.IsCurrent=1 " +
                      "  Set ltd.Rate=IFNULL(rt.Rate,0), " +
                      "  ltd.Amount=if(ltd.IsPackage=0,((IFNULL(rt.Rate,0) * ltd.Quantity)-((IFNULL(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100),0), " +
                      "  ltd.ItemName = IF(IFNULL(rt.ItemCode,'')<>'',IF(IFNULL(rt.ItemDisplayName,'')='',CONCAT(ltd.ItemName,' (',rt.ItemCode,')'),CONCAT(rt.ItemDisplayName,' (',rt.ItemCode,')')),ltd.ItemName) " +
                     ",ltd.LastUpdatedBy = '" + HttpContext.Current.Session["ID"].ToString() + "',ltd.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ltd.IpAddress = '" + Util.GetString(HttpContext.Current.Request.UserHostAddress) + "' " +
                      "  WHERE ltd.TransactionID='" + TID + "' AND ltd.IsVerified=1 AND ltd.IsSurgery=0 AND ltd.isPackage=0 and cf.ConfigID <>11 AND UCASE(sc.DisplayName)<>'MEDICINE & CONSUMABLES' ";
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, str);
            }

            tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}