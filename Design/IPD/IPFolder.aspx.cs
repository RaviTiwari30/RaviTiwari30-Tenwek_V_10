using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.IO;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;

public partial class Design_IPD_IPFolder : System.Web.UI.Page
{
    public string TransactionID;
    public string PatientID;
    public string Sex;
    public string BillNo;
    public string UserID;
    public string Type;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TransactionID = Request.QueryString["TID"].ToString();
            ViewState["TransactionID"] = TransactionID;
            if (!string.IsNullOrEmpty(Request.QueryString["BillNo"]))
                ViewState["BillNo"] = Request.QueryString["BillNo"].ToString();

            BillNo = Request.QueryString["BillNo"].ToString();
            PatientID = Request.QueryString["PID"].ToString();
            GenerateMainMenu(Session["RoleID"].ToString());
            BindPatientDetails(TransactionID);
            GetPatientImage(PatientID);
            UserID = Session["ID"].ToString();


            if (Session["RoleID"].ToString() == "51")
            {
                ViewState["defaultUrl"] = "../EMR/DRDetails.aspx";
            }
            else if(Session["RoleID"].ToString() == "3")
            {
                ViewState["defaultUrl"] = "IPDPatientBillDetails.aspx";
            }
            else
                ViewState["defaultUrl"] = "PatientBillMsg.aspx";
            if (TransactionID.Contains("ISHHI"))
                Type = "IPD";
            else
                Type = "OPD";

            All_LoadData.updateNotification(Util.GetString(TransactionID), Util.GetString(Session["ID"].ToString()), "", 29);
            All_LoadData.updateNotification(Util.GetString(TransactionID), Util.GetString(Session["ID"].ToString()), "", 19);
            All_LoadData.updateNotification(Util.GetString(TransactionID), Util.GetString(Session["ID"].ToString()), "", 18);
            ViewState["CanViewRate"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "CanViewRate");

            string PanelID = StockReports.ExecuteScalar("SELECT PanelID from patient_medical_history where TransactionID='" + TransactionID + "'");
            if (PanelID != "1" && Resources.Resource.IsShowCoPayUpdate == "1")
            {
                ViewState["CanShowCoPayment"] = All_LoadData.GetAuthorization(Util.GetInt(Session["RoleID"].ToString()), Session["ID"].ToString(), "CanShowCoPayment");
            }
            else
            {
                ViewState["CanShowCoPayment"] = "0";
            }
        }
        if (Session["LoginType"] == null && Session["UserName"] == null)
        {
            Response.Redirect("Default.aspx");
        }
    }
    //public void GenerateMenu(string roleID,string MainMenuName)
    //{
    //    DataTable dt = StockReports.GetDataTable(" SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
    //         " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + roleID + " and upper(FrameName)='IPD' ORDER BY ffr.SequenceNo");


    //    rptMenu.DataSource = dt;
    //    rptMenu.DataBind();
    //}


    public void GenerateMainMenu(string roleID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT DISTINCT( if(IFNULL(fmm.MenuHeader,'')='','Others',fmm.MenuHeader)) MenuName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID " +
             " WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + roleID + " and upper(FrameName)='IPD' ORDER BY fmm.SequenceNo");
        rptMainMenu.DataSource = dt;
        rptMainMenu.DataBind();
    }




    public void GetPatientImage(string PatientID)
    {
        try
        {
            DateTime DateEnrolle = Util.GetDateTime(StockReports.ExecuteScalar("select DateEnrolled from Patient_master where PatientID='" + PatientID + "'"));
            string Gender = Util.GetString(StockReports.ExecuteScalar("select Gender from Patient_master where PatientID='" + PatientID + "'"));
            PatientID = PatientID.Replace("/", "_");
            string PImagePath = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + DateEnrolle.Year + "\\" + DateEnrolle.Month + "\\" + PatientID + ".jpg");
            if (File.Exists(PImagePath))
            {
                byte[] byteArray = File.ReadAllBytes(PImagePath);
                string base64 = Convert.ToBase64String(byteArray);
                imgPatient.Src = string.Format("data:image/jpg;base64,{0}", base64);
            }
            else
            {
                //check gender
                if (Gender == "Male")
                {
                    imgPatient.Src = "~/Images/MaleDefault.png";
                }
                else if (Gender == "Female")
                {
                    imgPatient.Src = "~/Images/FemaleDefault.png";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
    public void GetPatientIPDInfo()
    {

        try
        {
            string strQuery = "";
            string str = "Select min(ID) from f_doctorshift where TransactionID = '" + ViewState["TransactionID"] + "'";
            string min = StockReports.ExecuteScalar(str);
            strQuery = "select CONCAT(Title,'',Name)DoctorName,df.DoctorID, CONCAT(Date_Format(df.FromDate,'%d-%b-%Y'),' ',Time_format(df.FromTime,'%h:%i %p'))DateOfAdmit from f_doctorshift df inner join doctor_master dm on dm.DoctorID=df.DoctorID where df.ID=" + min + "  ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(strQuery);
            ViewState["dt"] = dt;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
    private void BindPatientDetails(string TransactionID)
    {
        try
        {
            string Status = StockReports.ExecuteScalar("Select Status from patient_medical_history where TransactionID='" + TransactionID + "'");//IPD_case_History

            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID, Status);
            if (dt != null && dt.Rows.Count > 0)
            {
                
                //pnlPatient.Visible = true;//old
                //lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                //PatientID = lblPatientID.Text;
                //lblPatientName.Text = dt.Rows[0]["Title"].ToString() + " " + dt.Rows[0]["PName"].ToString();
                //lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString().Replace("ISHHI", "");
                //lblRoomNo.Text = dt.Rows[0]["RoomNo"].ToString();
                //lblPanelComp.Text = dt.Rows[0]["Company_Name"].ToString();
                //lblAllergies.Text = StockReports.ExecuteScalar("SELECT Allergies FROM cpoe_hpexam WHERE PatientID='" + dt.Rows[0]["PatientID"].ToString() + "' ORDER BY PastHistoryEntryDate DESC LIMIT 1");

                //lblDOB.Text = dt.Rows[0]["Age"].ToString();
                //lblMLCNo.Text = dt.Rows[0]["MLC_NO"].ToString();
                //lblSex.Text = dt.Rows[0]["gender"].ToString();
            }
            //DataTable dt1 = (DataTable)ViewState["dt"];
            //if (dt1 != null && dt1.Rows.Count > 0)
            //{
            //    lblAdmissionDate.Text = Util.GetDateTime(dt1.Rows[0]["DateOfAdmit"].ToString()).ToString("dd-MMM-yyyy hh:mm tt");
            //}
            dt = AQ.GetPatientIPDInformation(TransactionID);

            if (dt != null && dt.Rows.Count > 0)
            {
                //lblcurrntcunsltnt.Text = dt.Rows[0]["DoctorName"].ToString();
                //lblAdmissionDate.Text = Util.GetDateTime(dt.Rows[0]["DateOfAdmit"].ToString()).ToString("dd-MMM-yyyy hh:mm tt");
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    [WebMethod]
    public static string BindBillDetails(string TransactionID, string PatientID)
    {
        AllQuery AQ = new AllQuery();
        decimal TotalDisc = Math.Round(Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(SUM(TotalDiscAmt),0) + (Select IFNULL(DiscountOnBill,0) from patient_medical_history  where TransactionID='" + TransactionID + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "'  and isverified=1 and ispackage=0")), 2, MidpointRounding.AwayFromZero);//f_ipdadjustment
       // decimal AmountBilled = Math.Round(Util.GetDecimal(AQ.GetBillAmount(TransactionID, null)) - Util.GetDecimal(TotalDisc), 2, MidpointRounding.AwayFromZero);
        decimal AmountBilled = Math.Round(Util.GetDecimal(AQ.GetBillAmount(TransactionID, null)), 4, MidpointRounding.AwayFromZero);
        decimal BillAmtAfterDisc = Math.Round(Util.GetDecimal(AmountBilled) - Util.GetDecimal(TotalDisc), 2, MidpointRounding.AwayFromZero);
        decimal TaxPer = Math.Round(Util.GetDecimal(All_LoadData.GovTaxPer()), 2, MidpointRounding.AwayFromZero);
        decimal TaxAmount = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(AmountBilled) * Util.GetDecimal(TaxPer)) / 100), 2, System.MidpointRounding.AwayFromZero));
        decimal TotalAmt = Math.Round(Util.GetDecimal(AmountBilled) - Util.GetDecimal(TotalDisc) + Util.GetDecimal(TaxAmount), 2, MidpointRounding.AwayFromZero);
        decimal NetBillAmount = Util.GetDecimal(Math.Round(TotalAmt, 0, MidpointRounding.AwayFromZero));
        decimal RoundOff = Math.Round((Util.GetDecimal(NetBillAmount) - TotalAmt), 2, MidpointRounding.AwayFromZero);
        decimal TotalDeduction = Math.Round(Util.GetDecimal(AQ.GetTDS(TransactionID)) + Util.GetDecimal(AQ.GetTotalDedutions(TransactionID) + Util.GetDecimal(AQ.GetWriteoff(TransactionID))), 2, MidpointRounding.AwayFromZero);
        decimal Advance = Math.Round(Util.GetDecimal(AQ.GetPaidAmount(TransactionID)), 2, MidpointRounding.AwayFromZero);
        decimal BalanceAmt = Math.Round(Util.GetDecimal(NetBillAmount) - (Util.GetDecimal(Advance) + TotalDeduction), 2, MidpointRounding.AwayFromZero); ;
        string OutStanding = StockReports.ExecuteScalar("SELECT PatientOutstanding('" + PatientID + "')");
        //  string BillDetail = TotalDisc + "#" + AmountBilled + "#" + TaxPer + "#" + TaxAmount + "#" + TotalAmt + "#" + NetBillAmount + "#" + RoundOff + "#" + TotalDeduction + "#" + Advance + "#" + BalanceAmt + "#" + OutStanding;
        return Newtonsoft.Json.JsonConvert.SerializeObject(new
        {
            totalDiscount = TotalDisc,
            amountBilled = AmountBilled,
            taxPercent = TaxPer,
            taxAmount = TaxAmount,
            totalAmount = BillAmtAfterDisc,
            netBillAmount = NetBillAmount,
            roundOff = RoundOff,
            totalDeduction = TotalDeduction,
            advance = Advance,
            balanceAmt = BalanceAmt,
            outStanding = OutStanding,
        });
    }
    [WebMethod]
    public static string BindVitals(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ipo.Temp,ipo.POD,ipo.Pulse,ipo.Resp,ipo.BP,ipo.wound,ipo.drains,ipo.BloodSugar,ipo.Weight,ipo.Oxygen,ipo.comments,Replace(ipo.TransactionID,'ISHHI','')IPDNo,ipo.PatientID,ipo.CreatedBy, ");
        sb.Append(" TIMESTAMPDIFF(MINUTE,CreatedDate,NOW())createdDateDiff FROM IPD_Patient_ObservationChart ipo ");
        sb.Append(" WHERE ipo.transactionID = '" + TransactionID + "' GROUP BY ipo.ID order by ipo.Date Desc,ipo.time desc Limit 1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }

    [WebMethod]
    public static string bindBillingRemark(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select BillingRemarks from patient_medical_history WHERE TransactionID = '" + TransactionID + "'");//f_ipdadjustment
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string remark = string.Empty;
        if (dt.Rows.Count > 0 && dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                remark = dt.Rows[i]["BillingRemarks"].ToString();
                remark = remark.Replace("\r\n", "<br/>");
            }
        }

        if (dt.Rows.Count > 0)
            return remark;
        else
            return "";

    }
    [WebMethod]
    public static string bindPatientPayable(string TransactionID)
    {
        DataTable dt = IPDBilling.GetCopayAmount(TransactionID, 0,0);
        int IsRevert = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_PreviousCopay p WHERE p.TransactionID='" + TransactionID + "'"));
        if (dt.Rows.Count > 0 && dt != null)
        {
            dt.Columns.Add("IsRevert");
            if (IsRevert > 0)
                dt.Rows[0]["IsRevert"] = "1";
            else
                dt.Rows[0]["IsRevert"] = "0";
            dt.AcceptChanges();

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveCoPayment(string TransactionID, decimal CoPayPer)
    {
        string UpdateData = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            UpdateData = "delete from f_PreviousCopay WHERE TransactionID='" + TransactionID + "'";
            MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, UpdateData);

            UpdateData = "INSERT INTO f_PreviousCopay(LedgerTnxID,LedgerTransactionNo,TransactionID,ItemID,Rate,Amount,Quantity,DiscountPercentage,DiscAmt,CoPayPercent,IsPackage,IsVerified) SELECT LedgerTnxID,LedgerTransactionNo,TransactionID,ItemID,Rate,Amount,Quantity,DiscountPercentage,DiscAmt,CoPayPercent,IsPackage,IsVerified FROM f_ledgertnxdetail WHERE IsVerified=1 AND IsPackage=0 AND IsPayable=0 AND TransactionID='" + TransactionID + "'";
            MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, UpdateData);

            UpdateData = "UPDATE f_ledgertnxdetail ltd SET ltd.CoPayPercent=" + CoPayPer + ",LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now(),IpAddress='" + All_LoadData.IpAddress() +"' WHERE ltd.TransactionID='" + TransactionID + "' AND ltd.IsPayable=0 AND ltd.IsVerified=1 AND ltd.IsPackage=0";
            MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, UpdateData);
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Co-Payment updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Co-Payment not updated", message = ex.Message });

        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RevertCoPayment(string TransactionID)
    {
        string UpdateData = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            UpdateData = "UPDATE f_ledgertnxdetail ltd inner join f_PreviousCopay p on p.LedgerTnxID=ltd.LedgerTnxID and p.TransactionID=ltd.TransactionID  SET ltd.CoPayPercent=p.CoPayPercent,LastUpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDate=now(),IpAddress='" + All_LoadData.IpAddress() + "' WHERE ltd.TransactionID='" + TransactionID + "' AND ltd.IsPayable=0 AND ltd.IsVerified=1 AND ltd.IsPackage=0";
            MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, UpdateData);

            UpdateData = "delete from f_PreviousCopay WHERE TransactionID='" + TransactionID + "'";
            MySqlHelperNEw.ExecuteNonQuery(tnx, CommandType.Text, UpdateData);

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Co-Payment Reverted Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Co-Payment not Reverted", message = ex.Message });

        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string GetAllergiesAndDiagnosis(string patientID)
    {
        // patientID = "C0036504";
        string str = "SELECT 'Allergies' AS DataType,ce.Allergies AS DataValues,DATE_FORMAT(ce.EntryDate,'%d-%b-%y') AS EntryDate FROM cpoe_hpexam ce WHERE ce.PatientID='" + patientID + "' AND IFNULL(ce.Allergies,'')<>'' UNION ALL SELECT 'Diagnosis' AS DataType, cp.ProvisionalDiagnosis AS DataValues,DATE_FORMAT(cp.CreatedDate,'%d-%b-%y') AS EntryDate FROM cpoe_PatientDiagnosis cp WHERE cp.PatientID='" + patientID + "' AND IFNULL(cp.ProvisionalDiagnosis,'')<>''";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    protected void rptMainMenu_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater rptSubMenu = e.Item.FindControl("rptChildMenu") as Repeater;

            Label a1 = (Label)e.Item.FindControl("lblMenuName");
            var MenuName = a1.Text;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fmm.FileName,fmm.URL,fmm.FrameName FROM f_framemenumaster fmm INNER JOIN f_frame_role ffr ON fmm.ID=ffr.URLID ");
            sb.Append(" WHERE fmm.IsActive=1 AND ffr.IsActive=1 AND ffr.RoleID=" + Session["RoleID"].ToString() + " ");
            if (MenuName.ToString() != "")
            {
                if (MenuName.ToString()=="Others")
                {
                    sb.Append("  and  IFNULL(fmm.MenuHeader,'')=''  ");

                }
                else
                {
                    sb.Append("  and fmm.MenuHeader like '%" + MenuName + "%'  ");

                }
            }

            sb.Append(" and upper(FrameName)='IPD' ORDER BY ffr.SequenceNo ");




            DataTable dt = StockReports.GetDataTable(sb.ToString());


            rptSubMenu.DataSource = dt;
            rptSubMenu.DataBind();

        }




    }
}