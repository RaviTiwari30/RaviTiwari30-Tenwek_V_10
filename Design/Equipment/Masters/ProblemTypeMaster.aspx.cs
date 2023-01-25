using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

public partial class Design_Equipment_Masters_ProblemTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCallType();
            //LastUpdatedby,UpdateDate,IPAddress
            ViewState["LastUpdatedby"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            ViewState["IsUpdate"] = "S";
            LoadData();
        }
        lblMsg.Text = "";
    }

    private void BindCallType()
    {
        string str = "SELECT CallTypeName,CallTypeID from eq_CallType_master Where isActive=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlCallType.DataSource = dt;
            ddlCallType.DataTextField = "CallTypeName";
            ddlCallType.DataValueField = "CallTypeID";
            ddlCallType.DataBind();
            ddlCallType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
            
        }
    }

    private void LoadData()
    {
        grdProblemType.DataSource = null;
        grdProblemType.DataBind();

        string str = "SELECT fm.ProblemTypeID,fm.ProblemTypeName,fm.ProblemTypeCode,fm.Description,";
        str += "(SELECT CallTypeName FROM eq_CallType_master WHERE CallTypeID=fm.CallTypeID)CallTypeName,";
        str += "IF(fm.IsActive=1,'Yes','No')IsActive,(SELECT NAME FROM employee_master WHERE fm.LastUpdatedby=employee_ID)LastUpdatedby,";
        str += "CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T'))UpdateDate,";
        str += "fm.IPAddress FROM eq_ProblemType_master fm ";

        DataTable dt = StockReports.GetDataTable(str);

        grdProblemType.DataSource = dt;
        grdProblemType.DataBind();
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
                    str = "Insert into eq_ProblemType_master(ProblemTypeName,ProblemTypeCode,CallTypeID,Description,LastUpdatedby,UpdateDate,IPAddress,IsActive)";
                    str += "value('" + txtname.Text.Trim() + "','" + txtCode.Text.Trim() + "','" + ddlCallType.SelectedValue + "','" + txtDescription.Text.Trim() + "',";
                    str += "'" + ViewState["LastUpdatedby"].ToString() + "',Now(),'" + ViewState["IPAddress"].ToString() + "'," + IsActive + ")";

                }
                else
                {
                    //Getting Last Record
                    string DataLog = StockReports.ExecuteScalar("SELECT Concat( " +
                    "'LastUpdatedby : ',(SELECT NAME FROM employee_master WHERE Employee_ID=fm.LastUpdatedby LIMIT 1),'</BR>" +
                    "Last Update Date : ',CONCAT(DATE_FORMAT(fm.UpdateDate,'%d-%b-%y'),' ',TIME_FORMAT(fm.UpdateDate,'%T')),'</BR>Ip Address : ',fm.IPAddress,'</BR>" +
                    "Name : ',fm.ProblemTypeName,', Code : ',fm.ProblemTypeCode," +
                    "', CallType : ' ,(SELECT CallTypeName FROM eq_CallType_master WHERE CallTypeID=fm.CallTypeID LIMIT 1),', Active : ',IF(fm.IsActive=1,'Yes','No'),'</BR>" +
                    "Description : ' ,fm.Description)DataLog " +
                    "FROM eq_ProblemType_master fm WHERE ProblemTypeID=" + ViewState["ProblemTypeID"].ToString() + " ");
                    

                    str = "Update eq_ProblemType_master Set ProblemTypeName='" + txtname.Text.Trim() + "',ProblemTypeCode='" + txtCode.Text.Trim() + "',";
                    str += "IsActive = " + IsActive + ",CallTypeID='" + ddlCallType.SelectedValue + "',Description='" + txtDescription.Text.Trim() + "',";
                    str += "LastUpdatedby='" + ViewState["LastUpdatedby"].ToString() + "',UpdateDate=Now(),IPAddress='" + ViewState["IPAddress"].ToString() + "',";
                    str += "DataLog =concat_Ws('</BR></BR>',DataLog,'" + DataLog + "') Where ProblemTypeID=" + ViewState["ProblemTypeID"].ToString() + " ";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                conn.Close();
                conn.Dispose();

                lblMsg.Text = "Record Saved";
                ViewState["ProblemTypeID"] = "";
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
        if (ddlCallType.SelectedValue.ToUpper() == "SELECT")
        {
            lblMsg.Text = "Select CallType";
            return false;
        }

        if (txtname.Text.Trim() == "")
        {
            lblMsg.Text = "Provide ProblemType Name";
            return false;
        }

        if (txtCode.Text.Trim() == "")
        {
            lblMsg.Text = "Provide ProblemType Code";
            return false;
        }

        if (ViewState["IsUpdate"].ToString() == "S")
        {
            string isExist = StockReports.ExecuteScalar("SElECT ProblemTypeName from eq_ProblemType_master Where ProblemTypeName ='"+txtname.Text.Trim()+"'");

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
        ddlCallType.SelectedIndex = 0;
        txtname.Text = "";
        txtCode.Text = "";
        txtDescription.Text = "";
    }

    protected void grdProblemType_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string ProblemTypeID = Util.GetString(e.CommandArgument);

        if (e.CommandName == "EditData")
        {
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_ProblemType_master WHERE ProblemTypeID=" + ProblemTypeID);
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlCallType.SelectedIndex = ddlCallType.Items.IndexOf(ddlCallType.Items.FindByValue(dt.Rows[0]["CallTypeID"].ToString()));
                txtname.Text = dt.Rows[0]["ProblemTypeName"].ToString();
                txtCode.Text = dt.Rows[0]["ProblemTypeCode"].ToString();
                txtDescription.Text = dt.Rows[0]["Description"].ToString();

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    chkActive.Checked = true;
                else
                    chkActive.Checked = false;

                ViewState["ProblemTypeID"] = ProblemTypeID;
                ViewState["IsUpdate"] = "U";
                btnsave.Text = "Update";
            }
        }
        else if (e.CommandName == "ViewLog")
        {
            lblLog.Text = StockReports.ExecuteScalar("SELECT Replace(DataLog,'\r\n','</BR>')DataLog FROM eq_ProblemType_master WHERE ProblemTypeID=" + ProblemTypeID);
            mdpLog.Show();
        }
    }
   
}