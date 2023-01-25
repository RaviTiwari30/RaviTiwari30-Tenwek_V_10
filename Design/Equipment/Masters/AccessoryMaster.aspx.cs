using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_AccessoryMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
        }
        lblMsg.Text = "";
    }

    private void BindItem(string ItemName,string ItemID)
    {
        string str = "SELECT im.TypeName ItemName,im.ItemID from f_Itemmaster im inner join f_subcategorymaster sc on im.subcategoryid = sc.subcategoryid "+
            " inner join f_configrelation cf on cf.CategoryID = sc.CategoryID Where im.isActive=1 and sc.Active=1 and cf.IsActive=1 and cf.ConfigID in (11,28) ";

        if (ItemName != string.Empty)
        {
            str += " AND im.TypeName like '%" + ItemName + "%' ";
        }

        if (ItemID != string.Empty)
        {
            str += " AND im.ItemID = '" + ItemID + "' ";
        }

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlItem.DataSource = dt;
            ddlItem.DataTextField = "ItemName";
            ddlItem.DataValueField = "ItemID";
            ddlItem.DataBind();
            ddlItem.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            
        }
    }

    private void LoadData()
    {
        grdAccessory.DataSource = null;
        grdAccessory.DataBind();

        string str = "SELECT fm.AccessoryID,fm.AccessoryName,fm.AccessoryCode,fm.Description,";
        str += "(SELECT TypeName FROM f_Itemmaster WHERE ItemID=fm.ItemID)ItemName,";
        str += "IF(fm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE fm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T'))UpdateDate,";
        str += "fm.IPAddress FROM eq_Accessory_master fm ";

        DataTable dt = StockReports.GetDataTable(str);

        grdAccessory.DataSource = dt;
        grdAccessory.DataBind();
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
                    str = "Insert into eq_Accessory_master(AccessoryName,AccessoryCode,ItemID,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim() + "','" + txtCode.Text.Trim() + "','" + ddlItem.SelectedValue + "','" + txtDescription.Text.Trim() + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>Ip Address : ',fm.IPAddress,'</BR>" +
                    "Name : ',fm.AccessoryName,', Code : ',fm.AccessoryCode," +
                    "', Item : ' ,(SELECT TypeName FROM f_Itemmaster WHERE ItemID=fm.ItemID LIMIT 1),', Active : ',IF(fm.IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ' ,fm.Description)DataLog " +
                    "FROM eq_Accessory_master fm WHERE AccessoryID=" + ViewState["AccessoryID"].ToString() + " ");
                    

                    str = "Update eq_Accessory_master Set AccessoryName='" + txtname.Text.Trim() + "',AccessoryCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",ItemID='" + ddlItem.SelectedValue + "',Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where AccessoryID=" + ViewState["AccessoryID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["AccessoryID"] = "";
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
        if (ddlItem.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select Item";
            return false;
        }

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Accessory Name";
            return false;
        }

        if (txtCode.Text.Trim() == "")
        {
            lblMsg.Text = "Provide Accessory Code";
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            string isExist = StockReports.ExecuteScalar("SElECT AccessoryName from eq_Accessory_master Where AccessoryName ='"+txtname.Text.Trim()+"'");

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
        ddlItem.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
        txtDescription.Text = "";
    }

    protected void grdAccessory_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string AccessoryID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_Accessory_master WHERE AccessoryID=" + AccessoryID);
            if (dt != null && dt.Rows.Count > 0)
            {
                BindItem("", dt.Rows[0]["ItemID"].ToString());

                ddlItem.SelectedIndex = ddlItem.Items.IndexOf(ddlItem.Items.FindByValue(dt.Rows[0]["ItemID"].ToString()));
                txtname.Text = dt.Rows[0]["AccessoryName"].ToString();
                txtCode.Text = dt.Rows[0]["AccessoryCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["AccessoryID"] = AccessoryID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_Accessory_master WHERE AccessoryID=" + AccessoryID);
            mdpLog.Show();
        }
    }
       
    protected void btnSearchItem_Click(object sender, EventArgs e)
    {
        if (txtSearchItem.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Provide ItemName by any word...";
            txtSearchItem.Focus();
            return;
        }
        else
            BindItem(txtSearchItem.Text.Trim(),"");
    }
}