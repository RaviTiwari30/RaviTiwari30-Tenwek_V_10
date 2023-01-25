using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_AssetTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindStore();
            bindroleid();
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            if (Session["roleid"].ToString() != "180")
            {
                ddldepartment.Enabled = false;
            
            }
            else 
            ddldepartment.Enabled = true;
            ddldepartment.SelectedIndex = ddldepartment.Items.IndexOf(ddldepartment.Items.FindByValue(Session["roleid"].ToString()));
            LoadData();
            chkActive.Checked = true;
            chkActive.Enabled = false;
            txtname.Focus();
        }
        lblMsg.Text = "";
    }
    private void  bindroleid()
    {
        DataTable dt= StockReports.GetDataTable( "select id ,rolename from f_rolemaster where active=1");
        ddldepartment.DataSource = dt;
        ddldepartment.DataValueField = "id";
        ddldepartment.DataTextField = "rolename";
        ddldepartment.DataBind();
    }

    private void BindStore()
    {
        string str = "SELECT LedgerName,LedgerNumber from f_ledgermaster Where GroupID='STO'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlStoreType.DataSource = dt;
            ddlStoreType.DataTextField = "LedgerName";
            ddlStoreType.DataValueField = "LedgerNumber";
            ddlStoreType.DataBind();
            ddlStoreType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            
        }
    }

    private void LoadData()
    {
        grdAssetType.DataSource = null;
        grdAssetType.DataBind();

        string str = "SELECT AssetTypeID,AssetTypeName,AssetTypeCode,";
        str += "(SELECT LedgerName FROM f_ledgermaster WHERE GroupID='STO' AND ledgernumber=StoreTypeID)StoreType,";
        str += "IF(IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE LastUpdatedby=employee_ID LIMIT 1)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T'))UpdateDate,";
        str += "IPAddress FROM eq_assettype_master ORDER BY AssetTypeName ";

        if (ddldepartment.SelectedItem.Value != "180")
        {
            str += "  and  roleid='" + Session["roleid"].ToString() + "' ";
        }
        else
        {
            str += " order by AssetTypeName ";
        }

        DataTable dt = StockReports.GetDataTable(str);

        grdAssetType.DataSource = dt;
        grdAssetType.DataBind();
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        if (CheckValidation())
        {   
            MySqlConnection conn = Util.GetMySqlCon();
            conn.Open();
            MySqlTransaction tnx = conn.BeginTransaction();
            
            try
            {                
                string str = "";
                int IsActive = 0;

                if (chkActive.Checked)
                    IsActive = 1;

                if (ViewState["IsUpdate"].ToString() == "S")
                {
                    str = "Insert into eq_AssetType_master(AssetTypeName,AssetTypeCode,StoreTypeID,LastUpdatedby,UpdateDate,IPAddress,IsActive,roleid)";
                    str += "value('" + txtname.Text.Trim().Replace("'","") + "','" + txtCode.Text.Trim() + "','" + ddlStoreType.SelectedValue + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ",'"+ddldepartment.SelectedItem.Value+"')";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T')),'</BR>Ip Address : ',IPAddress,'</BR>" +
                    "Name : ',AssetTypeName,', Code : ',AssetTypeCode," +
                    "', StoreType : ' ,(SELECT LedgerName FROM f_Ledgermaster WHERE Ledgernumber=StoreTypeID LIMIT 1),', Active : ',IF(IsActive=1,'Yes','No'))DataLog " +
                    "FROM eq_assettype_master WHERE AssetTypeID=" + ViewState["AssetTypeID"].ToString() + " ");
                    

                    str = "Update eq_AssetType_master Set AssetTypeName='" + txtname.Text.Trim() + "',AssetTypeCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",StoreTypeID='" + ddlStoreType.SelectedValue + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where AssetTypeID=" + ViewState["AssetTypeID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved Successfully";
                ViewState["AssetTypeID"] = "";
                ViewState["IsUpdate"] = "S";
                btnsave.Text = "Save";
                chkActive.Checked = true;
                chkActive.Enabled = false;
                ClearFields();
                LoadData();

            }
            catch (Exception ex)
            {
                tnx.Rollback();
                conn.Close();
                conn.Dispose();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
            }
        }
    }   

    private bool CheckValidation()
    {       

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Enter Asset Type Name";
            txtname.Focus();
            return false;
        }

        if (ddlStoreType.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Store Type";
            ddlStoreType.Focus();
            return false;
        }

        //if (txtCode.Text.Trim() == "")
        //{
        //    lblMsg.Text = "Provide Approval Type Code";
        //    return false;
        //}

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            int isExist = 0;
            isExist = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) from eq_assettype_master Where AssetTypeName ='"+txtname.Text.Trim()+"'"));

            if (isExist>0)
            {
                lblMsg.Text = "Duplicate Record Exist";
                txtname.Focus();
                return false;
            }

        }
        return true;
    }

    private void ClearFields()
    {
        ddlStoreType.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
    }

    protected void grdAssetType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string AssetTypeID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_assettype_master WHERE AssetTypeID=" + AssetTypeID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlStoreType.SelectedIndex = ddlStoreType.Items.IndexOf(ddlStoreType.Items.FindByValue(dt.Rows[0]["StoreTypeID"].ToString()));
                txtname.Text = dt.Rows[0]["AssetTypeName"].ToString();
                txtCode.Text = dt.Rows[0]["AssetTypeCode"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["AssetTypeID"] = AssetTypeID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";                
                chkActive.Enabled = true;
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_assettype_master WHERE AssetTypeID=" + AssetTypeID);
            mdpLog.Show();
        }
    }
}