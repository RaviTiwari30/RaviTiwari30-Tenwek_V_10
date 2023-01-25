using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_IPD_PatientReturnIndent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["LoginType"] = Session["LoginType"].ToString().ToUpper();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TID"] = TID;
            AllQuery AQ = new AllQuery();

            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

            DataTable dtadj = StockReports.GetDataTable("SELECT * FROM patient_medical_history WHERE (BILLno IS NULL OR billno = '') AND TransactionID = '" + ViewState["TID"].ToString() + "'");//f_ipdadjustment

            if (dtadj != null && dtadj.Rows.Count > 0)
            {

                BindDepartments(TID);
                BindDetails(ddlDept.SelectedItem.Value);
                TypeMaster();
            }
            else
            {
                string Msg = "Patient bill has been generated.";
                Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
            }

        }
    }

    private void BindDetails(string departmentLedgerNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT t3.ItemId,IM.TypeName ItemName,UPPER(IM.IsExpirable)IsExpirable,UPPER(sm.DisplayName)DisplayName,UPPER(IM.`UnitType`)UnitType,IM.Type_ID,inHandUnits ");
        sb.Append("   FROM ( ");
        sb.Append("       SELECT t1.itemid,(t1.SoldQty - IF(t2.RetQty IS NULL,0,t2.RetQty ) )  ");
        sb.Append("       AS inHandUnits,t1.TransactionID ");
        sb.Append("       FROM (  ");
        sb.Append("       SELECT sd.ItemID,sd.StockID,SUM(sd.SoldUnits)SoldQty,lt.TransactionID FROM f_salesdetails sd ");
        sb.Append("       INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = sd.ledgertransactionno ");
        sb.Append("       WHERE lt.TransactionID='" + ViewState["TID"].ToString() + "' AND sd.TrasactionTypeID IN ('3','4') AND sd.DeptLedgerNo='" + departmentLedgerNo + "'  ");
        sb.Append("       GROUP BY sd.itemid  ");
        sb.Append("       )t1 LEFT JOIN ( ");
        sb.Append("       SELECT sd.ItemID,SUM(sd.SoldUnits)RetQty FROM f_salesdetails sd ");
        sb.Append("       INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = sd.ledgertransactionno ");
        sb.Append("       WHERE lt.TransactionID='" + ViewState["TID"].ToString() + "' AND sd.TrasactionTypeID IN ('5','6') ");
        sb.Append("       GROUP BY sd.itemid ");
        sb.Append("       )t2 ON t1.ItemID=t2.ItemID ");
        sb.Append("   )t3 INNER JOIN f_itemmaster IM ON t3.itemid=IM.ItemID  ");
        sb.Append("       INNER JOIN `f_subcategorymaster` sm ON im.`SubCategoryID`=sm.`SubCategoryID` ");
        sb.Append("   WHERE t3.inHandUnits>0 ");
        sb.Append("   ORDER BY IM.TypeName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdRequsition.DataSource = dt;
            grdRequsition.DataBind();
            btnReturn.Visible = true;
        }
        else
        {
            btnReturn.Visible = false;
        }
    }
       
    protected void grdRequsition_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            
        }
        if (e.CommandName == "APrint")
        {
           
        }
    }

    private void BindDepartments(string transactionID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT f.DeptLedgerNo,f.DeptName FROM `f_rolemaster`  f INNER JOIN (SELECT sd.DeptLedgerNo,SUM(sd.SoldUnits)SoldQty,lt.TransactionID FROM f_salesdetails sd INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionNo = sd.ledgertransactionno WHERE lt.TransactionID='" + transactionID + "' AND sd.TrasactionTypeID IN ('3','4') GROUP BY sd.DeptLedgerNo) t ON t.DeptLedgerNo=f.DeptLedgerNo WHERE Active=1 AND IsStore=1 AND IFNULL(f.DeptLedgerNo,'')<>'' AND IFNULL(f.DeptName,'')<>'' ORDER BY f.DeptName ");



        DataTable dtDepartment = StockReports.GetDataTable(sb.ToString());
        if (dtDepartment.Rows.Count > 0)
        {
            ddlDept.DataSource = dtDepartment;
            ddlDept.DataTextField = "DeptName";
            ddlDept.DataValueField = "DeptLedgerNo";
            ddlDept.DataBind();
            lblMsg.Text = string.Empty;
            // ddlDept.Items.Insert(0, "Select");
            //ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue(AllGlobalFunction.MedicalDeptLedgerNo));
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByText("PHARMACY"));
            // ddlDept.Enabled = false;
        }
		 else
        {
            ddlDept.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void TypeMaster()
    {
        AllQuery AQ = new AllQuery();
        DataTable dt = AQ.getTypeMaster();
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlRequestType.DataSource = dt;
            ddlRequestType.DataTextField = "TypeName";
            ddlRequestType.DataValueField = "TypeID";
            ddlRequestType.DataBind();

        }
    }

    protected void btnReturn_Click(object sender, EventArgs e)
    {

        string IndentNo="";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            bool status = true;
            IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no_patient_return('" + ViewState["DeptLedgerNo"].ToString() + "')").ToString();
            foreach (GridViewRow row in grdRequsition.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    status = false;
                    if (Util.GetDecimal(((TextBox)row.FindControl("txtReqQty")).Text)==0)
                    {
                        lblMsg.Text = "Please Enter Requested Quantity";
                        ((TextBox)row.FindControl("txtReqQty")).Focus();
                        return;
                    }


                    if (Util.GetDecimal(((TextBox)row.FindControl("txtReqQty")).Text) > Util.GetDecimal(((Label)row.FindControl("lblInHandUnits")).Text))
                    {
                        lblMsg.Text = "Requested Quantity can not be greater than InHand Quantity..";
                        ((TextBox)row.FindControl("txtReqQty")).Focus();
                        return;
                    }

                    if (Util.GetString(txtNarration.Text)==string.Empty)
                    {
                        lblMsg.Text = "Enter Reason of Medicine Return";
                        txtNarration.Focus();
                        return;
                    }

                    StringBuilder sb = new StringBuilder();
                    sb.Append("insert into f_indent_detail_patient_return(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,TransactionID,Type,IndentType)  ");
                    sb.Append("values('" + IndentNo + "','" + Util.GetString(((Label)row.FindControl("lblItemID")).Text) + "','" + Util.GetString(((Label)row.FindControl("lblItemName")).Text) + "'," + Util.GetDecimal(((TextBox)row.FindControl("txtReqQty")).Text) + "");
                    sb.Append(",'" + Util.GetString(((Label)row.FindControl("lblUnitType")).Text) + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + ddlDept.SelectedValue + "','STO00001','" + txtNarration.Text + "' ,'" + ViewState["ID"].ToString() + "','" + ViewState["TID"].ToString() + "','1','" + ddlRequestType.SelectedItem.Text + "') ");

                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return;
                    }



                }
                
            }
            if (status)
            {
                lblMsg.Text = "Please Select Atleast One Item";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
                return;
            }

            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            BindDetails(ddlDept.SelectedItem.Value);
            txtNarration.Text = "";
            ddlRequestType.SelectedIndex = 0;
            lblMsg.Text = "Indent Created Successfully";
        }
       catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return;

        }
    }
    protected void rblPaymentType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDetails(ddlDept.SelectedItem.Value);
    }
    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDetails(ddlDept.SelectedItem.Value);
    }
}