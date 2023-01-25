using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.IO;
using System.Web;
using System.Globalization;
using System.Collections.Generic;



public partial class Design_Store_DirectGRN_Asset : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
				ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();

            //if (All_LoadData.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=For This Page';", true);
            //    return;
            //}
            //else
            //{
                //if (ChkRights())
                //{
                //    string Msg = "You do not have rights to generate GRN ";
                //    Response.Redirect("MsgPage.aspx?msg=" + Msg);
                //}
                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();
               
                rblStoreType_SelectedIndexChanged(this, new EventArgs());
                calBillDate.EndDate = DateTime.Now;
                CalchallanDate.EndDate = DateTime.Now;
                calWayBillDate.EndDate = DateTime.Now;
                calPurDate.EndDate = DateTime.Now;
                BindVendor();
            //}

        }
        txtBillDate.Attributes.Add("readOnly", "true");
        txtChallanDate.Attributes.Add("readOnly", "true");
        txtWayBillDate.Attributes.Add("readonly", "true");      
    }

    protected bool ChkRights()
    {
        string RoleId = Session["RoleID"].ToString();
        string EmpId = Session["ID"].ToString();
        rblStoreType.Items[0].Enabled = false;
        rblStoreType.Items[1].Enabled = false;
        DataTable dt = StockReports.GetRights(RoleId);
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "false")
            {
                string Msg = "You do not have rights to generate GRN ";
                Response.Redirect("MsgPage.aspx?msg=" + Msg, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else
            {
                rblStoreType.Items[0].Enabled = Util.GetBoolean(dt.Rows[0]["IsMedical"]);
                rblStoreType.Items[1].Enabled = Util.GetBoolean(dt.Rows[0]["IsGeneral"]);
                if ((dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "true") || (dt.Rows[0]["IsMedical"].ToString() == "true" && dt.Rows[0]["IsGeneral"].ToString() == "false"))
                {
                    rblStoreType.Items[0].Selected = true;
                    rblStoreType.Items[1].Selected = false;
                }
                else if (dt.Rows[0]["IsMedical"].ToString() == "false" && dt.Rows[0]["IsGeneral"].ToString() == "true")
                {
                    rblStoreType.Items[1].Selected = true;
                    rblStoreType.Items[0].Selected = false;
                }

            }
            return false;
        }
        else { return true; }
    }
    protected void rblStoreType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblStoreType.SelectedIndex < 0)
        {
            lblMsg.Text = "Please select Store Type";
            ddlVendor.SelectedIndex = 0;
            return;
        }
        else
        {
            lblMsg.Text = string.Empty;
            BindVendor();

        }
    }
    public void BindVendor()
    {
        StringBuilder sb = new StringBuilder();
        if (Resources.Resource.StoreWiseVendor == "1")
        {
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.IsAsset=1 AND vm.DepTLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName ");
        }
        else
        {
            // sb.Append(" select concat(LedgerNumber,'#',LedgerUserID)ID,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName ");
            sb.Append(" SELECT CONCAT(lm.LedgerNumber,'#',lm.LedgerUserID,'#',vm.StateID)ID,lm.LedgerName FROM f_ledgermaster  lm  ");
            sb.Append(" INNER JOIN `f_vendormaster` vm ON lm.`LedgerUserID`=vm.`Vendor_ID` ");
            sb.Append(" WHERE groupID='VEN' AND IsCurrent=1 AND vm.IsAsset=1  ORDER BY LedgerName ");

        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "ID";
            ddlVendor.DataBind();

            ddlVendor.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
        }

    }

}