using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Finance_MapReceipt : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadData();

            txtFrmDt.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtTDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFrmDt.Attributes.Add("readonly", "true");
        txtTDate.Attributes.Add("readonly", "true");
    }

    private void LoadData()
    {
      DataTable dt=  StockReports.GetDataTable(" SELECT cr.ConfigID,im.ItemID,im.TypeName FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID INNER JOIN f_configrelation cr ON sm.CategoryID=cr.CategoryID WHERE cr.ConfigID=20 AND im.isadvance=1");

      ddlReceiptType.DataSource = dt;
      ddlReceiptType.DataTextField = "TypeName";
      ddlReceiptType.DataValueField = "ItemID";
        ddlReceiptType.DataBind();
    }

    public ListItem[] LoadItems(DataTable str)
    {
        try
        {
            if (str == null)
            {
                ListItem[] iItems = new ListItem[1];
                iItems[0] = new ListItem("", "");
                return iItems;
            }

            ListItem[] Items = new ListItem[str.Rows.Count];

            for (int i = 0; i < str.Rows.Count; i++)
            {
                Items[i] = new ListItem(str.Rows[i][0].ToString(), str.Rows[i][1].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            string LedgerTransactionNo="", PatientID="",ReceiptNo="",PatientName="";
            LedgerTransactionNo = ((Label)GridView1.SelectedRow.FindControl("lblLedgerTransactionNo")).Text;
            PatientID = GridView1.SelectedRow.Cells[2].Text;
            ReceiptNo = GridView1.SelectedRow.Cells[3].Text;
            PatientName = GridView1.SelectedRow.Cells[1].Text;
            txtReceiptMap.Text = ReceiptNo;
            if (ViewState["LedgerTransactionNo"] != null)
            {
                ViewState["LedgerTransactionNo"] = LedgerTransactionNo;
            }
            else
            {
                ViewState.Add("LedgerTransactionNo", LedgerTransactionNo);
            }

            if (ViewState["PatientID"] != null)
            {
                ViewState["PatientID"] = PatientID;
            }
            else
            {
                ViewState.Add("PatientID", PatientID);
            }

            if (ViewState["ReceiptNo"] != null)
            {
                ViewState["ReceiptNo"] = ReceiptNo;
            }
            else
            {
                ViewState.Add("ReceiptNo", ReceiptNo);
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    public DataTable SearchPatient(string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status, string LabNo, string Department, string Locality)
    {
        try
        {
            int iCheck = 0;
            if (TransactionId != "" || PatientId != "" || PatientName != "")
                iCheck = 1;

            StringBuilder sb = new StringBuilder();
            sb.Append("");

            sb.Append("Select concat(t2.Title, ' ',t2.PName)PName,t2.PatientID,t2.Gender,");
            sb.Append("concat(t2.House_No,'',t2.Street_Name,'',t2.Locality,'',t2.City,'',t2.Pincode)Address,t2.Mobile,");
            sb.Append("t2.Age,t2.TransactionID,dm.Name as DName,ictm1.Name as RName,fpm.Company_Name,ictm2.Name as BillingCategory,");
            sb.Append("concat(t2.DateOfAdmit,' ',t2.TimeOfAdmit)AdmitDate,concat(t2.DateOfDischarge,' ',t2.TimeOfDischarge)DischargeDate,t2.Status,concat(t2.Age,' / ',t2.Gender)AgeSex,concat(rm.Bed_No,'/',rm.Name)RoomName,t2.IPDCaseType_ID,fpm.ReferenceCode,t2.PanelID,t2.ScheduleChargeID, ");
            sb.Append("IF(IFNULL((SELECT SUM(amount) FROM f_ledgertnxdetail WHERE TransactionID=t2.TransactionID AND IsVerified=1 AND IsPackage=0),0) - ");
            sb.Append("IFNULL((SELECT SUM(amountpaid) FROM f_reciept WHERE TransactionID='ISHHI4' AND Iscancel=0),0) > ");
            sb.Append("IFNULL((SELECT amount FROM f_thresholdlimit WHERE Isactive=1 AND PanelID=t2.PanelID),0),'True','False')PayStatus,Department, ");
            sb.Append("(Select BillNo from f_ipdadjustment where TransactionID=t2.TransactionID)BillNo ");
            sb.Append("from (");
            sb.Append("     Select t1.*,pm.ID,pm.Title,PName,Gender,House_No,Street_Name,Locality,City,Pincode,Age,pm.PatientID,pm.Mobile ");
            sb.Append("     from (Select pip.PatientID,pip.IPDCaseType_ID,pip.IPDCaseType_ID_Bill,pip.Room_ID,");
            sb.Append("     pip.TransactionID,pip.Status,Date_Format(ich.DateOfAdmit,'%d-%b-%y')DateOfAdmit,");
            sb.Append("     Time_format(ich.TimeOfAdmit,'%l: %i %p')TimeOfAdmit,pmh.DoctorID,pmh.PanelID,pmh.ScheduleChargeID,");
            sb.Append("     if(ich.DateOfDischarge='0001-01-01','-',Date_Format(ich.DateOfDischarge,'%d-%b-%y'))DateOfDischarge,");
            sb.Append("     if(ich.TimeOfDischarge='00:00:00','',Time_format(ich.TimeOfDischarge,'%l: %i %p'))TimeOfDischarge");
            sb.Append("     from (");
            sb.Append("         Select pip1.PatientIPDProfile_ID,pip1.PatientID,pip1.IPDCaseType_ID,");
            sb.Append("         pip1.IPDCaseType_ID_Bill,pip1.Room_ID,pip1.TransactionID,pip1.Status ");
            sb.Append("         from patient_ipd_profile pip1 inner join (");
            sb.Append("             Select max(PatientIPDProfile_ID)PatientIPDProfile_ID ");
            sb.Append("             from patient_ipd_profile Where status = '" + status + "' ");
            if (TransactionId != "")
            {
                sb.Append("         and TransactionID='" + TransactionId + "'");
            }

            if (PatientId != "")
            {
                sb.Append("         and PatientID='" + PatientId + "'");
            }
            if (RoomID != "")
            {
                sb.Append("         and IPDCaseType_ID = '" + RoomID + "'");
            }

            sb.Append("             group by TransactionID ");
            sb.Append("        )pip2 on pip1.PatientIPDProfile_ID = pip2.PatientIPDProfile_ID ");
            sb.Append("     )pip inner join ipd_case_history ich on pip.TransactionID = ich.TransactionID ");
            sb.Append("     inner join patient_medical_history pmh on pmh.TransactionID = ich.TransactionID and pmh.Type='IPD' ");
            sb.Append("     Where ich.status='" + status + "'  ");
            if (TransactionId != "")
            {
                sb.Append(" and ich.TransactionID='" + TransactionId + "'");
            }
            if (FromAdmitDate != "" && ToAdmitDate != "")
            {
                sb.Append(" and ich.DateOfAdmit >= '" + FromAdmitDate + "' and ich.DateOfAdmit <= '" + ToAdmitDate + "'");
            }
            else if (FromAdmitDate != "" && ToAdmitDate == "")
            {
                sb.Append(" and ich.DateOfAdmit >= '" + FromAdmitDate + "'");
            }

            if (iCheck == 0)
            {
                if (DischargeDateFrom != "" && DischargeDateTo != "")
                {
                    sb.Append(" and ich.DateOfDischarge >= '" + DischargeDateFrom + "' and ich.DateOfDischarge <= '" + DischargeDateTo + "'");
                }
                else if (DischargeDateFrom != "" && DischargeDateTo == "")
                {
                    sb.Append(" and ich.DateOfDischarge >= '" + DischargeDateFrom + "'");
                }
            }
            if (Company != "")
            {
                sb.Append(" and PanelID=" + Company + " ");
            }

            if (DoctorID != "")
            {
                sb.Append(" and DoctorID = '" + DoctorID + "'");
            }


            sb.Append(") t1 inner join  patient_master pm  ");
            sb.Append("on t1.PatientID = pm.PatientID ");
            sb.Append("Where pm.PatientID <>'' ");



            if (PatientId != "")
            {
                sb.Append(" and PatientID='" + PatientId + "'");
            }

            if (PatientName != "" && PatientId == "")
            {
                sb.Append(" and pname like '%" + PatientName + "%'");
            }

            if (Locality != "")
            {
                sb.Append(" and Locality like '" + Locality + "%'");
            }

            sb.Append(" ) t2 ");
            sb.Append("inner join f_panel_master fpm on fpm.PanelID = t2.PanelID ");
            sb.Append("inner join doctor_master dm on t2.DoctorID = dm.DoctorID ");
            sb.Append("inner join (Select DoctorID,Department from doctor_Hospital ");

            if (Department != "")
                sb.Append("where Department like '" + Department + "' ");

            sb.Append("group by DoctorID) dh on t2.DoctorID = dh.DoctorID ");
            sb.Append("inner join ipd_case_type_master ictm1 on ictm1.IPDCaseType_ID = t2.IPDCaseType_ID  ");
            sb.Append("inner join ipd_case_type_master ictm2 on ictm2.IPDCaseType_ID = t2.IPDCaseType_ID_Bill ");
            sb.Append("inner join room_master rm on rm.Room_Id = t2.room_id ");

            sb.Append("order by t2.ID desc, t2.PName, t2.PatientID");
            DataTable Items = StockReports.GetDataTable(sb.ToString());

          
          

            if (Items.Rows.Count > 0)
            {
                return Items;
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return null;
        }
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        try
        {
            //if (txtRegNo.Text.Trim() == "")
            //{
            //    lblMsg.Text = "Please Specify Patient Registration No";
            //    return;
            //}
            if (txtFrmDt.Text.Trim() == "")
            {
                lblMsg.Text = "Please Specify Date of Registration";
                return;
            }

            if (txtReceiptNo.Text.Trim() == "")
            {
                lblMsg.Text = "Please Specify ReceiptNo";
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }

        try
        {
            string PatientName = "", PatientID = "", DateFrom = "", DateTo = "", ItemID = "", ReceiptNo = "";

            if (txtPatientName.Text.Trim() != "")
            {
                PatientName = txtPatientName.Text.Trim();
            }

            if (txtRegNo.Text.Trim() != "")
            {
                PatientID = txtRegNo.Text.Trim();
            }
            if (txtFrmDt.Text.Trim() != "")
            {
                DateFrom = txtFrmDt.Text.Trim();
            }

            if (txtTDate.Text.Trim() != "")
            {
                DateTo = txtTDate.Text.Trim();
            }
            else
            {
                DateTo = DateTime.Now.ToString("dd-MMM-yyyy");
            }
            if (txtReceiptNo.Text.Trim() != "")
            {
                ReceiptNo = txtReceiptNo.Text.Trim();
            }

            ItemID = ddlReceiptType.SelectedItem.Value;

            DataTable dtSearch = SearchMappingReceipt(PatientName, PatientID, ReceiptNo, ItemID, DateFrom, DateTo);

            if (dtSearch != null && dtSearch.Rows.Count > 0)
            {
                GridView1.DataSource = dtSearch;
                GridView1.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
     
    }
    public DataTable SearchMappingReceipt(string PName, string PID, string ReceiptNo, string ItemID, string FromDate, string ToDate)
    {
       

        try
        {
            string strSelect = "Select PM.PName,PM.PatientID,RE.ReceiptNo,Date_Format(RE.Date,'%d-%b-%y')Date,RE.AmountPaid,LTD.LedgerTransactionNo from ";

            strSelect = strSelect + " (Select * from patient_master ";
            if (PName != "" && PID != "")
            {
                strSelect = strSelect + " Where PatientID = '" + PID + "' and PName like '" + PName + "%'";
            }
            else if (PName != "" && PID == "")
            {
                strSelect = strSelect + " Where  PName like '" + PName + "%'";
            }
            else if (PName == "" && PID != "")
            {
                strSelect = strSelect + " Where PatientID = '" + PID + "'";
            }
            strSelect = strSelect + " )PM,";
            strSelect = strSelect + " (Select * from f_reciept ";
            if (FromDate != "" && ToDate != "" && ReceiptNo != "")
            {
                strSelect = strSelect + " Where ReceiptNo = '" + ReceiptNo + "' and Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'";
            }
            else if (FromDate != "" && ToDate != "" && ReceiptNo == "")
            {
                strSelect = strSelect + " Where Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and Date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'";
            }

            if (PID != "")
            {
                strSelect = strSelect + " and depositor ='" + PID + "'";
            }
            strSelect = strSelect + " )RE,";

            strSelect = strSelect + " (Select * from f_ledgertnxdetail Where ItemID = '" + ItemID + "') LTD Where LTD.LedgerTransactionNo = RE.AsainstLedgerTnxNo and RE.Depositor = PM.PatientID";

            DataTable dt = StockReports.GetDataTable(strSelect);

           
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
            return null;
        }
    }
    protected void grdPatient_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            string TransactionID = "", PatientID = "";

            PatientID = grdPatient.SelectedRow.Cells[0].Text;
            TransactionID = grdPatient.SelectedRow.Cells[7].Text;

            if (ViewState["PatientID"] != null)
            {
                ViewState["PatientID"] = PatientID;
            }
            else
            {
                ViewState.Add("PatientID", PatientID);
            }

            if (ViewState["TransactionID"] != null)
            {
                ViewState["TransactionID"] = TransactionID;
            }
            else
            {
                ViewState.Add("TransactionID", TransactionID);
            }

            txtTransctionID.Text = TransactionID;

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionID = "", PatientID = "", LedgerTransactionNo = "", ReceiptNo = "";

            PatientID = ViewState["PatientID"].ToString();

            if (txtTransctionID.Text.Trim() != "")
            {
                TransactionID = "ISHHI" + txtTransctionID.Text.Trim();
            }

            LedgerTransactionNo = ViewState["LedgerTransactionNo"].ToString();
            ReceiptNo = ViewState["ReceiptNo"].ToString();

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT LedgerTransactionNO from f_ledgertransaction where TransactionID='" + TransactionID + "'").Tables[0];

            string strQuery = "UPDATE receipt_mapped SET TransactionID='" + TransactionID + "',LedgerTransactionNO='" + dt.Rows[0]["LedgerTransactionNO"].ToString() + "',DefaultMapped=1,MapDateTime=NOW() WHERE LedgerTransactionNO_old='" + LedgerTransactionNo + "' AND ReceiptNO='" + ReceiptNo + "'";
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, strQuery);

            string strQueryf_reciept = "Update f_reciept Set TransactionID = '" + TransactionID + "' Where ReceiptNo = '" + ReceiptNo + "'";
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, strQueryf_reciept);

            MySqltrans.Commit();
          

            lblMsg.Text = "Receipt No. : " + ReceiptNo + " is mapped to IPD No. : " + TransactionID;
            GridView1.DataSource = null;
            GridView1.DataBind();

                grdPatient.DataSource = null;
                grdPatient.DataBind();

            Clear();
            }
        catch (Exception ex)
            {
            MySqltrans.Rollback();
           
            lblMsg.Text = "Record Not Altered";
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            }
        finally
            {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
            }
        }

    private void Clear()
    {
        txtPatientName.Text = "";
        txtReceiptMap.Text = "";
        txtTransctionID.Text = "";
        txtReceiptNo.Text = "";
        txtRegNo.Text = "";       

    }

}
