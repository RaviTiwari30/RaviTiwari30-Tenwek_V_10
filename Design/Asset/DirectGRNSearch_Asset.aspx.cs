using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Globalization;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;

public partial class Design_Store_DirectGRNSearch_Asset : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            //    return;
            //}
            //else
            //{
                ChkRights();
                txtInvoiceNo.Focus();
                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

                AllLoadData_Store.bindStore(ddlVendor, "VEN", "All");
                AllLoadData_Store.bindStore(ddlEditVender, "VEN", "");
                BindStore();
                ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            //}
                fromdate.EndDate = DateTime.Now;
                todate.EndDate = DateTime.Now;
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        txtEditInvoiceDate.Attributes.Add("readonly", "true");
        calInvoiceDate.EndDate = DateTime.Now;

    }
    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();

        string EmpId = Session["ID"].ToString();

        string str = "SELECT IsGeneral,IsMedical FROM f_rolemaster WHERE id='" + RoleId + "' and active=1 and IsStore=1 ";
        DataTable dt = StockReports.GetDataTable(str.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "1" && dt.Rows[0]["IsGeneral"].ToString() == "1")
            {
                ddlStore.SelectedIndex = 0;
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "1" || dt.Rows[0]["IsGeneral"].ToString() == "1")
            {
                if (dt.Rows[0]["IsMedical"].ToString() == "1")
                {
                    ddlStore.SelectedIndex = 0;
                    ddlStore.Enabled = false;
                }
                else if (dt.Rows[0]["IsGeneral"].ToString() == "1")
                {
                    ddlStore.SelectedIndex = 1;
                    ddlStore.Enabled = false;
                }
            }
            else if (dt.Rows[0]["IsMedical"].ToString() == "0" && dt.Rows[0]["IsGeneral"].ToString() == "0")
            {
                string Msg = "You do not have rights to Search GRN ";
                Response.Redirect("../Purchase/MsgPage.aspx?msg=" + Msg);
            }
            return false;
        }
        else { return true; }

    }
    private void BindStore()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlStore.DataSource = dt;
            ddlStore.DataTextField = "LedgerName";
            ddlStore.DataValueField = "LedgerNumber";
            ddlStore.DataBind();
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Bind_GRN();
    }
    protected void gvGRN_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvGRN.PageIndex = e.NewPageIndex;
        Bind_GRN();
    }
    protected void gvGRN_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        int IsPostGRN = 0;
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(HttpContext.Current.Session["RoleID"]), Util.GetString(HttpContext.Current.Session["ID"]));
        if (dtAuthority.Rows.Count > 0)
        {
            if (Util.GetInt(dtAuthority.Rows[0]["IsPostGRN"]) == 1)
            {
                IsPostGRN = 1;//"You Are Not Authorised for it";
            }
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");
            if (ViewState["DeptLedgerNo"].ToString() == AllGlobalFunction.MedicalDeptLedgerNo)
            {
                e.Row.Attributes.Add("ondblclick", "ShowPO('" + Util.GetString(row["GRNNo"]) + "','Hos_GRN');");
            }
            else
            {
                e.Row.Attributes.Add("ondblclick", "ShowPO('" + Util.GetString(row["GRNNo"]) + "','Proj_GRN');");
            }
            if (IsPostGRN == 0)
            {
                e.Row.FindControl("imbPost").Visible = false;
            }
            else if (((Label)e.Row.FindControl("lblpost")).Text == "false")
            {
                e.Row.FindControl("imbPost").Visible = true;
            }
        }
    }
    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        txtCancelReason.Text = "";
        if (e.CommandName == "APost")
        {
            string str = "update f_stock set ispost = 1,PostDate = current_timeStamp() where LedgerTransactionNo = '" + Util.GetString(e.CommandArgument) + "' and IsPost!=3 and StoreLedgerNo='" + ddlStore.SelectedValue + "'";
            string str2 = "update eq_asset_stock set ispost = 1 where LedgerTransactionNo = '" + Util.GetString(e.CommandArgument) + "' and IsPost!=3";
            StockReports.ExecuteDML(str);
            StockReports.ExecuteDML(str2);
            Bind_GRN();
        }
        if (e.CommandName == "ACancel")
        {
            lblGRNNo.Text = Util.GetString(e.CommandArgument);
            mpCancel.Show();
        }

        if (e.CommandName == "Abar")
        {

        }


        if (e.CommandName == "AViewGRNFile")
        {
            lblGRNNo.Text = Util.GetString(e.CommandArgument);

            string FilePath = Util.GetString(StockReports.ExecuteScalar("select FileName from f_invoicemaster where LedgerTnxNo='" + Util.GetString(e.CommandArgument) + "'"));
            string file = FilePath;
            string AppPath = "";
            if (Request.ApplicationPath == "/")
                AppPath = "";
            else
                AppPath = Request.ApplicationPath;

            string URLAttach = Server.UrlPathEncode("http://" + Request.Url.Host + AppPath + "/Documents/GRN/" + FilePath + "");

            string script = "";
            script = "<script>window.open('" + URLAttach + "');</script>";
            String js = "window.open('" + URLAttach + "', '_blank');";
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Open Signature.aspx", js, true);


        }

      
    }
    protected void btnGRNCancel_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string UserID = Convert.ToString(Session["ID"]);
        string strSql = string.Empty;
        strSql = "CALL CancelGRN('" + lblGRNNo.Text.Trim() + "','" + txtCancelReason.Text.Trim() + "','" + UserID + "','" + ddlStore.SelectedValue + "')";



        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strSql);
        con.Close();
        Bind_GRN();

    }

    #region Data Binding



    private void Bind_GRN()
    {

        string typeOfTnx = "";
        if (ddlStore.SelectedValue == "STO00001")
            typeOfTnx = "Purchase";
        else
            typeOfTnx = "NMPURCHASE";

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IsGRNUploaded,GRNNo,BillNo,GRNDate,AgainstPONo,InvoiceNo,ChalanNo,Amt,LedgerName,SUM(isPosted)IsPosted,IF(SUM(notPosted)=0,'true','false')Post,");
        sb.Append(" SUM(rejected)Rejected,IF(SUM(rejected)<>SUM(COUNT) AND SUM(isPosted)<>SUM(COUNT),'true','false')Reject1,IF((SUM(notPosted)=0 ");
        sb.Append(" AND SUM(rejected)=0),'Yes',IF((SUM(COUNT)=SUM(rejected)),'Cancel','No'))NewPost,VendorId FROM ( ");
        sb.Append("  SELECT inv.IsGRNUploaded,(st.LedgerTransactionNo)GRNNo,DATE_FORMAT(lt.Date,'%d-%b-%y')GRNDate,");
        sb.Append(" lt.AgainstPONo,lt.InvoiceNo,lt.ChalanNo, ROUND(lt.GrossAmount,2)Amt,");
        sb.Append(" (CASE WHEN st.ispost=1 THEN '1'  ELSE '0' END)IsPosted,");
        sb.Append(" (CASE  WHEN st.ispost=0 THEN '1' ELSE '0' END)NotPosted,(CASE WHEN st.ispost=3 THEN '1' ELSE '0' END)Rejected,");
        sb.Append(" lm.LedgerName,lt.IsCancel,'1' AS COUNT,lt.LedgerNoCr VendorId,BillNo FROM f_ledgertransaction lt  INNER JOIN f_ledgermaster lm ON ");
        sb.Append(" lm.LedgerNumber = lt.LedgerNoCr INNER JOIN f_stock st ON lt.LedgerTransactionNo = st.LedgerTransactionNo ");
        sb.Append(" LEFT JOIN f_invoicemaster inv on inv.LedgerTnxNo=st.LedgerTransactionNo ");
        sb.Append(" WHERE lt.TypeOfTnx = '" + typeOfTnx.Trim() + "' AND lt.DeptLedgerNo='" + Session["DeptLedgerNo"].ToString() + "' AND lm.GroupID = 'Ven'  AND AgainstPONo=''");

        if (txtInvoiceNo.Text.Trim() != string.Empty)
            sb.Append(" and lt.InvoiceNo = '" + txtInvoiceNo.Text.Trim() + "'");

        if (txtGRNNo.Text.Trim() != string.Empty)
            sb.Append(" and lt.LedgerTransactionNo = '" + txtGRNNo.Text.Trim() + "'");

        if (ddlGRNType.SelectedIndex > 0)
            sb.Append(" and st.IsPost = " + ddlGRNType.SelectedValue);

        if (ddlVendor.SelectedIndex > 0)
            sb.Append(" and lt.LedgerNoCr = '" + ddlVendor.SelectedValue + "'");
        if (ucFromDate.Text != string.Empty)
            sb.Append(" and date(lt.date) >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'");
        if (ucToDate.Text != string.Empty)
            sb.Append(" and date(lt.date) <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append("  and st.StoreLedgerNo='" + ddlStore.SelectedValue + "' ");
        sb.Append(" )t GROUP BY GRNNo");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {

            gvGRN.DataSource = dt;
            gvGRN.DataBind();
            lblMsg.Text = "";

        }
        else
        {
            gvGRN.DataSource = null;
            gvGRN.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }

    }
    #endregion
    protected void ddlStore_SelectedIndexChanged(object sender, EventArgs e)
    {
        Bind_GRN();
    }


    protected void btnUpload_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {
            string FileExtension = Path.GetExtension(FileUpload1.PostedFile.FileName);

            if (FileExtension.ToLower() != ".pdf")
            {
                lblMsg.Text = "Kindly Upload pdf files...";
                return;
            }
        }

        if (FileUpload1.HasFile)
        {
            string strQuery = "";
            StringBuilder sb = new StringBuilder();
            string FileName = "";
            string Mypath = "";

            if (!Directory.Exists(Server.MapPath("~/Documents/GRN/")))
                Directory.CreateDirectory(Server.MapPath("~/Documents/GRN/"));

            FileName = Path.GetFileName(FileUpload1.FileName);
            Mypath = Server.MapPath("~/Documents/GRN/" + FileName);

            if (File.Exists(Mypath))
                File.Delete(Mypath);

            FileUpload1.SaveAs(Mypath);

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string User = Util.GetString(StockReports.ExecuteScalar("select CONCAT(Title,' ',Name) from Employee_Master where Employee_ID='" + Util.GetString(ViewState["ID"]) + "'"));
                sb.Clear();
                sb.Append("update f_invoicemaster set IsGRNUploaded=1,FilePath='" + Mypath + "',FileName='" + FileName + "',UploadDate=now(),UploadedBy='" + Util.GetString(ViewState["ID"]) + "',UploadedUser='" + User + "',FileRemark='"+Util.GetString(txtRemark.Text)+"' where LedgerTnxNo='" + Util.GetString(lblGRN_No.Text) + "'");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
                MySqltrans.Commit();
                lblMsg.Text = "File Saved Sucessfully";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "", "closeGRNFileUpload()", true);
                txtRemark.Text="";
            }
                
            catch (Exception ex)
            {
                MySqltrans.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                lblMsg.Text = "Please Try Again..";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "", "closeGRNFileUpload()", true);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
        










    }
}

