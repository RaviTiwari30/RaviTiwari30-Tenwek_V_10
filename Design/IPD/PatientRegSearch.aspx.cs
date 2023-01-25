using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_IPD_PatientRegSearch : System.Web.UI.Page
{
    string strQuery = "";
    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                txtPatientID.Focus();
                txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ViewState["RoleID"] = Session["RoleID"].ToString();
            }
            txtFromDate.Attributes.Add("readOnly", "true");
            txtToDate.Attributes.Add("readOnly", "true");
        }

        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ShowSearchResult();
    }
    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Admit")
        {
            string PDetail = Util.GetString(e.CommandArgument);
            Response.Redirect("~/Design/IPD/IPDAdmissionNew.aspx?PID=" + PDetail.Split('#')[0].ToString() + "&TID=" + PDetail.Split('#')[1].ToString());
        }
        else if (e.CommandName == "EditReg")
        {
            string PDetail = Util.GetString(e.CommandArgument);
            Response.Redirect("~/Design/FrontOffice/PatientRegistration.aspx?PID=" + PDetail.Split('#')[0].ToString());
        }
        else if (e.CommandName == "EditAd")
        {
            string PDetail = Util.GetString(e.CommandArgument);
            Response.Redirect("~/Design/IPD/IPDAdmissionNew.aspx?PID=" + PDetail.Split('#')[0].ToString() + "&TID=" + PDetail.Split('#')[1].ToString());
        }
        else if (e.CommandName == "EditView")
        {
            string PDetail = Util.GetString(e.CommandArgument);
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('PatientAdmissionPrintOut.aspx?PID=" + PDetail.Split('#')[0] + " &TID=" + PDetail.Replace("ISHHI", "").Split('#')[1] + " ');", true);
            //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow2", "window.open('IPDConsentFromPrintout.aspx?PID=" + PDetail.Split('#')[0] + " &TID=" + PDetail.Replace("ISHHI", "").Split('#')[1] + " ');", true);
        }
    }

    #endregion

    #region Local Functions
    private void clear()
    {
        txtPfirstname.Text = "";
        txtplastname.Text = "";
        txtCity.Text = "";
        txtLocation.Text = "";
        txtPatientID.Text = "";
    }
    #endregion

    #region Search

    private void ShowSearchResult()
    {
        try
        {
            DataTable dt = SearchPatient().Copy();
            if (dt.Rows.Count > 0)
            {
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
            }
            else
            {
                lblMsg.Text = "Record Not Found";
                grdPatient.DataSource = null;
                grdPatient.DataBind();
                return;
            }
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            chkDate.Checked = true;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    private DataTable SearchPatient()
    {
        lblMsg.Text = "";
        string str = "";
        string PatientId = "";
        strQuery = "Select if(ich.status='IN','True','False')EdStatus,if(ich.status='IN','False','True')AdStatus,  pm.PatientID,pm.PFirstName,pm.PLastName,pm.Title,  CONCAT(pm.PFirstName,' ',pm.PLastName)   pname,concat(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City,' ',if(PM.Pincode=0,'',PM.Pincode))Address,if(pm.Phone = '',pm.Mobile,pm.Phone)Phone, if(pm.Gender='Male','M','F')Gender,pm.Age,TransactionID,ich.TransNo AS IPDNo,AdmissionReason from patient_master pm ";
        if (txtIpdno.Text.Trim() != "")
        {
            string TransactionID = StockReports.getTransactionIDbyTransNo(txtIpdno.Text.Trim());//"ISHHI" +
            strQuery = strQuery + " inner join (Select pmh.AdmissionReason,pmh.PatientID,pmh.Status,pmh.TransactionID,pmh.TransNo from patient_medical_history pmh  where pmh.TransactionID='" + TransactionID + "' ";//inner join ipd_case_history ch on ch.TransactionID = pmh.TransactionID
            if (Util.GetString(ViewState["RoleID"]) != "181") // MRD
            {
                strQuery = strQuery + "and pmh.Status='IN' AND IsDischargeIntimate=0 ";//ch
            }
            //strQuery = strQuery + " inner join (Select pmh.PatientID,ch.Status,pmh.TransactionID from patient_medical_history pmh inner join ipd_case_history ch on ch.TransactionID = pmh.TransactionID Where  ";
        }
        else
        {
            strQuery = strQuery + " inner join (Select pmh.AdmissionReason,pmh.PatientID,pmh.Status,pmh.TransactionID,pmh.DateOfVisit,pmh.TransNo from patient_medical_history pmh  Where pmh.type='IPD'  "; //inner join ipd_case_history ch on ch.TransactionID = pmh.TransactionID
            if (Util.GetString(ViewState["RoleID"]) != "181") // MRD
            {
                strQuery = strQuery + " and pmh.Status='IN'  ";//ch
            }
        }
        strQuery = strQuery + " )ich on ich.PatientID = pm.PatientID ";

        if (txtPatientID.Text.Trim() != "")
        {
            PatientId = Util.GetFullPatientID(txtPatientID.Text.Trim());
            if (str != "")
                str = str + " and pm.PatientID='" + PatientId + "'";
            else
                str = str + " Where pm.PatientID='" + PatientId + "'";
        }
        if (txtPfirstname.Text.Trim() != "")
        {
            if (str != "")
                str = str + " and pm.Pfirstname like '" + txtPfirstname.Text.Trim() + "%'";
            else
                str = str + "Where pm.Pfirstname like '" + txtPfirstname.Text.Trim() + "%' ";
        }
        if (txtplastname.Text.Trim() != "")
        {
            if (str != "")
                str = str + " and pm.Plastname like '" + txtplastname.Text.Trim() + "%'";
            else
                str = str + "Where pm.Plastname like '" + txtplastname.Text.Trim() + "%' ";
        }
        if (txtLocation.Text.Trim() != "")
        {
            if (str != "")
                str = str + " and pm.Location like '" + txtLocation.Text.Trim() + "%'";
            else
                str = str + "Where pm.Location like '" + txtLocation.Text.Trim() + "%'";
        }
        if (txtCity.Text.Trim() != "")
        {
            if (str != "")
                str = str + " and pm.City like '" + txtCity.Text.Trim() + "%'";
            else
                str = str + "Where pm.City like '" + txtCity.Text.Trim() + "%'";
        }
        if (PatientId == "" && txtIpdno.Text.Trim() == "")
        {
            if (chkDate.Checked)
            {
                if (str != "")
                    strQuery = strQuery + str + " and ich.DateOfVisit >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and ich.DateOfVisit <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'";
                else
                    strQuery = strQuery + str + "Where ich.DateOfVisit >='" + Util.GetDateTime(txtFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and ich.DateOfVisit <='" + Util.GetDateTime(txtToDate.Text.Trim()).ToString("yyyy-MM-dd") + "' ";
            }
            else
            {
                if (str != "")
                    strQuery = strQuery + str;
            }
        }
        else
        {
            if (str != "")
                strQuery = strQuery + str;
        }
        strQuery = strQuery + " order by TransactionID desc";
        DataTable dt = StockReports.GetDataTable(strQuery);
        return dt;
    }
    #endregion
}
