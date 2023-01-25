using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_AssetSubTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindAssetType();
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
        }
        lblMsg.Text = "";
    }

    private void BindAssetType()
    {
        string str = " SELECT AssetTypeName,AssetTypeID FROM eq_assettype_master WHERE Isactive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlAssetType.DataSource = dt;
            ddlAssetType.DataTextField = "AssetTypeName";
            ddlAssetType.DataValueField = "AssetTypeID";
            ddlAssetType.DataBind();
            ddlAssetType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            
        }
    }

    private void LoadData()
    {
        grdAssetType.DataSource = null;
        grdAssetType.DataBind();

        string str = "SELECT EM.AssetSubTypeID,EM.AssetSubTypeName,EM.AssetSubTypeCode,";
        str += "(SELECT AssetTypeName FROM eq_assettype_master WHERE AssetTypeID=EM.AssetTypeID)AssetType,";
        str += "IF(EM.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE EM.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(EM.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(EM.UpdateDate,'%T'))UpdateDate,";
        str += "IPAddress FROM eq_assetsubtype_master EM";

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
                    str = "Insert into eq_assetsubtype_master(AssetSubTypeName,AssetSubTypeCode,AssetTypeID,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim() + "','" + txtCode.Text.Trim() + "','" + ddlAssetType.SelectedValue + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(UpdateDate,'%T')),'</BR>Ip Address : ',IPAddress,'</BR>" +
                    "Name : ',AssetSubTypeName,', Code : ',AssetSubTypeCode," +
                    "', AssetType : ' ,(SELECT AssetTypename FROM eq_assettype_master WHERE AssetTypeID=AssetTypeID LIMIT 1),', Active : ',IF(IsActive=1,'Yes','No'))DataLog " +
                    "FROM eq_assetsubtype_master WHERE AssetSubTypeID=" + ViewState["AssetSubTypeID"].ToString() + " ");
                    

                    str = "Update eq_assetsubtype_master Set AssetSubTypeName='" + txtname.Text.Trim() + "',AssetSubTypeCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",AssetTypeID='" + ddlAssetType.SelectedValue + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where AssetSubTypeID=" + ViewState["AssetSubTypeID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["AssetSubTypeID"] = "";
                ViewState["IsUpdate"] = "S";
                btnsave.Text = "Save";
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

    private void Commit()
    {
        throw new NotImplementedException();
    }    

    private bool CheckValidation()
    {
        if (ddlAssetType.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Asset Type";
            return false;
        }

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Approval Type Name";
            return false;
        }

        if (txtCode.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Approval Type Code";
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            string isExist = StockReports.ExecuteScalar("SElECT AssetSubTypeName from eq_assetsubtype_master Where AssetSubTypeName ='"+txtname.Text.Trim()+"'");

            if (isExist != string.Empty)
            {
                lblMsg.Text = "Duplicate Record Exist";
                return false;
            }

        }
        return true;
    }

    private void ClearFields()
    {
        ddlAssetType.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
    }

    protected void grdAssetType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string AssetSubTypeID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditAT")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_assetsubtype_master WHERE AssetSubTypeID=" + AssetSubTypeID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlAssetType.SelectedIndex = ddlAssetType.Items.IndexOf(ddlAssetType.Items.FindByValue(dt.Rows[0]["AssetTypeID"].ToString()));
                txtname.Text = dt.Rows[0]["AssetSubTypeName"].ToString();
                txtCode.Text = dt.Rows[0]["AssetSubTypeCode"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["AssetSubTypeID"] = AssetSubTypeID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_assetsubtype_master WHERE AssetSubTypeID=" + AssetSubTypeID);
            mdpLog.Show();
        }
    }
}