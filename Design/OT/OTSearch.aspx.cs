using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OT_OTSearch : System.Web.UI.Page
{
    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                string roleid = Session["RoleID"].ToString();
                ViewState["RoleID"] = roleid;
                fromdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                todate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtPatientID.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");
                txtName.Attributes.Add("onKeyPress", "doClick('" + btnSearch.ClientID + "',event)");

                txtPatientID.Focus();
            }
            fromdate.Attributes.Add("readOnly", "true");
            todate.Attributes.Add("readOnly", "true");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            string FromAdmitDate = "", ToAdmitDate = "", VisitDateFrom = "", VisitDateTo = "", DischargeDateFrom = "", DischargeDateTo = "";
            string DoctorID = "", Company = "", RoomID = "", PatientName = "", PatientId = "", TransactionId = "", status = "";

            status = "IN";
            FromAdmitDate = "";
            ToAdmitDate = "";

            if (txtName.Text != "")
            {
                PatientName = txtName.Text.Trim();
            }
            if (txtPatientID.Text != "")
            {
                PatientId = txtPatientID.Text.Trim();
            }
            if (txtIpNo.Text != "")
            {
                TransactionId = "ISHHI" + txtIpNo.Text.ToString();
            }

            DataTable dt;
            dt = SearchPatientOT(PatientId, PatientName, TransactionId, RoomID, DoctorID, Company, FromAdmitDate, ToAdmitDate, DischargeDateFrom, DischargeDateTo, VisitDateFrom, VisitDateTo, status, "");

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Columns.Contains("LoginType") == false)
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "LoginType";
                    dc.DefaultValue = Session["LoginType"].ToString();
                    dt.Columns.Add(dc);
                }
                else
                {
                    dt.Columns["LoginType"].DefaultValue = Session["LoginType"].ToString();
                }
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
            }
            else
            {
                grdPatient.DataSource = null;
                grdPatient.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private bool checkpac(string tid, string ltd)
    {
        int count = Convert.ToInt32(StockReports.ExecuteScalar("select count(*) from ot_surgerydetail where TransactionID='" + tid + "' and LedgerTransactionNo='" + ltd + "'"));
        if (count > 0)
        {
            int count1 = Convert.ToInt32(StockReports.ExecuteScalar("select Is_PAC from ot_surgerydetail where TransactionID='" + tid + "' and LedgerTransactionNo='" + ltd + "'"));
            if (count1 == 1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        { return false; }
    }

    private bool checkpac1(string tid, string ltd)
    {
        int count = Convert.ToInt32(StockReports.ExecuteScalar("select count(*) from ot_surgerydetail where TransactionID='" + tid + "' and LedgerTransactionNo='" + ltd + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        { return false; }
    }

    private bool checkPOI(string tid, string ltd)
    {
        if (checkpac1(tid, ltd))
        {
            int count = Convert.ToInt32(StockReports.ExecuteScalar("select Is_Surgery_Schedule from ot_surgerydetail where TransactionID='" + tid + "' and LedgerTransactionNo='" + ltd + "'"));
            if (count > 0)
            {
                return true;
            }
            else
            { return false; }
        }
        else
        { return false; }
    }

    private bool checkSchedule(string tid, string ltd)
    {
        if (checkpac1(tid, ltd))
        {
            int count = Convert.ToInt32(StockReports.ExecuteScalar("select Is_PAC from ot_surgerydetail where TransactionID='" + tid + "' and LedgerTransactionNo='" + ltd + "'"));
            if (count == 1)
            {
                if (checkanesthesia(tid, ltd))
                {
                    return true;
                }
                else
                { return false; }
            }
            else if (count == 2)
            {
                return true;
            }
            else
            { return false; }
        }
        else
        { return false; }
    }

    private bool checkanesthesia(string tid, string ltd)
    {
        string value = StockReports.ExecuteScalar("select Fit_For_Anaesthesia from ot_anaesthesia where TransactionID='" + tid + "' and LedgerTransactionNo='" + ltd + "'");
        if (value != "not accepted for anesthesia #")
        {
            return true;
        }
        else if (value == "not accepted for anesthesia #")
        { return false; }
        else
        {
            return false;
        }
    }

    private bool bindsecurityPAC(string TransactionID, string Surgery_ID)
    {
        if (Convert.ToInt32(StockReports.ExecuteScalar("select Is_Surgery_Schdule from ot_surgery_schedule where TransactionID='" + TransactionID + "' and Surgery_ID='" + Surgery_ID + "'")) == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private bool bindsecurityPOI(string TransactionID, string Surgery_ID)
    {
        if (Convert.ToInt32(StockReports.ExecuteScalar("select Is_PAC from ot_surgery_schedule where TransactionID='" + TransactionID + "' and Surgery_ID='" + Surgery_ID + "'")) == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Registration")
        {
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
                TID = e.CommandArgument.ToString().Split('#')[0];
            else
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];

            string LoginType = Session["LoginType"].ToString();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "starScript1", "callRegistration('" + TID + "','" + Status + "','" + PID + "','" + LoginType + "','" + LTN + "','OPD');", true);
        }
        if (e.CommandName == "View")
        {
            string Type = "";

            Type = "Admit";
            string Status = e.CommandArgument.ToString().Split('#')[2];
            string transactionId = "";
            if (Status.ToUpper() == "OPD")
            {
                transactionId =  e.CommandArgument.ToString().Split('#')[1];
            }
            else
            {
                transactionId = "ISHHI" + e.CommandArgument.ToString().Split('#')[1];
            }
            string Case = e.CommandArgument.ToString().Split('#')[2];

            LoadPatientDetails(Type, transactionId, Case);
        }
        else if (e.CommandName == "PAC")
        {
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID =  e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];

            if (checkpac(TID, LTN))
            {
                string LoginType = Session["LoginType"].ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "starScript2", "callPAC('" + TID + "','" + Status + "','" + PID + "','" + LoginType + "','" + LTN + "');", true);
            }
        }
        else if (e.CommandName == "POI")
        {
            string RoleId = ViewState["RoleID"].ToString();
            if (RoleId != "111")
            {
                lblMsg.Text = "You are not authorized for OT Notes";
                return;
            }
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID =  e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LedgerTransactionNo = e.CommandArgument.ToString().Split('#')[3];
            if (checkPOI(TID, LedgerTransactionNo))
            {
                string LoginType = Session["LoginType"].ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "starScript3", "callSchedule('" + TID + "','" + Status + "','" + PID + "','" + LoginType + "','" + LedgerTransactionNo + "');", true);
            }
        }
        else if (e.CommandName == "OTSCHEDULE")
        {
            string RoleId = ViewState["RoleID"].ToString();
            if (RoleId != "111")
            {
                lblMsg.Text = "You are not authorized for sechduling OT";
                return;
            }
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID =  e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }

            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];

            if (checkSchedule(TID, LTN))
            {
                string LoginType = Session["LoginType"].ToString();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "starScript4", "callOtNotes('" + TID + "','" + Status + "','" + PID + "','" + LoginType + "','" + LTN + "');", true);
            }
        }
    }

    #endregion Events

    #region Local Functions

    private void LoadPatientDetails(string Type, string TID, string Case)
    {
        DataTable dt = new DataTable();
        if (Type == "Discharge")
        {
            dt = CreateStockMaster.GetAdmitDetail(TID, Type);
        }
        else
        {
            dt = CreateStockMaster.GetAdmitDetail(TID, Type);
        }
        if (dt != null && dt.Rows.Count > 0)
        {
            lblPhone.Text = dt.Rows[0]["Phone"].ToString();
            lblMobile.Text = dt.Rows[0]["Mobile"].ToString();
            lblRoom.Text = dt.Rows[0]["Room"].ToString();
            lblKinRelation.Text = dt.Rows[0]["KinRelation"].ToString();
            lblKinName.Text = dt.Rows[0]["KinName"].ToString();
            lblAdmitDate.Text = Util.GetDateTime(dt.Rows[0]["AdmitDate"]).ToString("dd-MMM-yyyy") + " " + Util.GetDateTime(dt.Rows[0]["TimeOfAdmit"]).ToString("HH:mm tt");

            if (dt.Columns.Contains("DischargeDate") == true)
            {
                lblDisDate.Text = dt.Rows[0]["DischargeDate"].ToString();
            }
            else
            {
                lblDisDate.Text = "-";
            }

            lblPName.Text = dt.Rows[0]["Pname"].ToString();
            lblGender.Text = dt.Rows[0]["Gender"].ToString();
            lblAge.Text = dt.Rows[0]["Age"].ToString();
            lblCase.Text = Case;
            lblAddress.Text = dt.Rows[0]["Address"].ToString();

            mdlPatient.Show();
        }
    }

    public DataTable SearchPatientOT(string PatientId, string PatientName, string TransactionId, string RoomID, string DoctorID, string Company, string FromAdmitDate, string ToAdmitDate, string DischargeDateFrom, string DischargeDateTo, string VisitDateFrom, string VisitDateTo, string status, string PatientType)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  Select '" + Session["LoginType"].ToString() + "' LoginType,if(pmh.Type='IPD','IN','OPD') Status,if(pmh.Type='IPD','true','false')Type ,PM.PatientID PatientID,concat(PM.Title,' ',PM.PName) as PName,dm.Name as DoctorName,PM.Relation,PM.RelationName, ");
        sb.Append("  CONCAT(PM.Age,' ',PM.Gender)as AgeSex,    PM.House_No as Address,'' Religion,IF(pmh.Type='IPD',Replace(pmh.TransactionID,'ISHHI',''),pmh.TransactionID)TransactionID,T.LedgerTransactionNo,DATE_FORMAT(T.date,'%d-%b-%Y') as Date  from   (  ");
        sb.Append("  	Select ltd.TransactionID,ltd.LedgerTransactionNo,ltd.date from    (  ");
        sb.Append("  		Select lt.TransactionID,lt.LedgerTransactionNo,lt.date from f_ledgertnxdetail ltd inner join f_ledgertransaction lt on    ");
        sb.Append("  		ltd.LedgerTransactionNo=lt.LedgerTransactionNo where ItemID='" + Resources.Resource.OTItemID + "' and ltd.isverified<>2 And   ");
        sb.Append("  		date(lt.Date)>='" + Util.GetDateTime(fromdate.Text).ToString("yyyy-MM-dd") + "' and  date(lt.Date) <='" + Util.GetDateTime(todate.Text).ToString("yyyy-MM-dd") + "' and lt.IsCancel=0   ");
        sb.Append("  	)ltd    ");
        sb.Append("  	left join ot_surgerydetail otd on   Otd.TransactionID = ltd.TransactionID  AND DATE(otd.EntData) >= '" + Util.GetDateTime(fromdate.Text).ToString("yyyy-MM-dd") + "'  AND DATE(otd.EntData) <= '" + Util.GetDateTime(todate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("  ) T   inner join   patient_medical_history PMH   on T.TransactionID = pmh.TransactionID    ");
        sb.Append("  inner join patient_master PM  on PMH.PatientID = pm.PatientID   ");
        sb.Append("  inner join doctor_master dm on dm.DoctorID = pmh.DoctorID ");

        if (PatientId != "" && PatientName != "" && TransactionId != "")
        {
            sb.Append(" Where PM.PatientID='" + PatientId + "' and PM.pname like '" + PatientName + "%' And pmh.TransactionID='" + TransactionId + "' ");
        }
        else if (PatientId != "" && PatientName == "" && TransactionId == "")
        {
            sb.Append(" Where PM.PatientID='" + PatientId + "'");
        }
        else if (PatientName != "" && PatientId == "" && TransactionId == "")
        {
            sb.Append(" Where PM.pname like '" + PatientName + "%'");
        }
        else if (TransactionId != "" && PatientName == "" && PatientId == "")
        {
            sb.Append(" Where pmh.TransactionID='" + TransactionId + "'");
        }

        sb.Append(" Order by PM.PatientID");

        DataTable Items = StockReports.GetDataTable(sb.ToString());

        return Items;
    }

    #endregion Local Functions

    protected void otopdgrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Registration")
        {
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID =  e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];

            //bool flag=bindsecurityPAC(TID, SID);
            //if (flag == true)
            //{
            string LoginType = Session["LoginType"].ToString();
            Response.Redirect(@"~/Design/OT/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + "&Type=OPD");
        }
        if (e.CommandName == "View")
        {
            string Type = "";

            Type = "Admit";
            string Status = e.CommandArgument.ToString().Split('#')[2];
            string transactionId = "";
            if (Status.ToUpper() == "OPD")
            {
                transactionId =  e.CommandArgument.ToString().Split('#')[1];
            }
            else
            {
                transactionId = "ISHHI" + e.CommandArgument.ToString().Split('#')[1];
            }
            string Case = e.CommandArgument.ToString().Split('#')[2];

            LoadPatientDetails(Type, transactionId, Case);
        }
        else if (e.CommandName == "PAC")
        {
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID = e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];

            if (checkpac(TID, LTN))
            {
                //bool flag=bindsecurityPAC(TID, SID);
                //if (flag == true)
                //{
                string LoginType = Session["LoginType"].ToString();
                Response.Redirect(@"~/Design/OT/PRE/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN);
            }

            //Response.Redirect("~/Design/OT/PRE/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + "&Surgery_ID=" + SID);
        }
        else if (e.CommandName == "POI")
        {
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID =  e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];
            if (checkPOI(TID, LTN))
            {
                //bool flag=bindsecurityPOI(TID, SID);
                //if (flag == true)
                //{
                string LoginType = Session["LoginType"].ToString();
                Response.Redirect(@"~/Design/OT/Post/OT_PostMainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN);
                //}
                //Response.Redirect("~/Design/OT/PRE/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + "&Surgery_ID=" + SID);
            }
        }
        else if (e.CommandName == "OTSCHEDULE")
        {
            string Status = e.CommandArgument.ToString().Split('#')[1];
            string TID = "";
            if (Status.ToUpper() == "OPD")
            {
                TID = e.CommandArgument.ToString().Split('#')[0];
            }
            else
            {
                TID = "ISHHI" + e.CommandArgument.ToString().Split('#')[0];
            }

            //string Status = e.CommandArgument.ToString().Split('#')[1];
            string PID = e.CommandArgument.ToString().Split('#')[2];
            string LTN = e.CommandArgument.ToString().Split('#')[3];

            if (checkSchedule(TID, LTN))
            {
                string LoginType = Session["LoginType"].ToString();
                Response.Redirect(@"~/Design/OT/Schedule/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN);

                //Response.Redirect("~/Design/OT/PRE/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + "&Surgery_ID=" + SID);
            }
        }
    }
}